import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants/apis.dart';

import '../../../../data/responsibilities/authentication_repo.dart';
import '../../models/review_summary_model.dart';

class ProductReviewNLPController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  final String _googleApiKey = UApiUrls.googleApiKey;

  final commentController = TextEditingController();
  final RxDouble selectedRating = 5.0.obs;

  final Rx<ReviewSummaryModel?> reviewSummary = Rx<ReviewSummaryModel?>(null);
  final RxList<Map<String, dynamic>> commentsList = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  void streamReviewSummary(String productId) {
    _db.collection('Review_Summaries').doc(productId).snapshots().listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        reviewSummary.value = ReviewSummaryModel.fromFirestore(snapshot.data()!);
      } else {
        reviewSummary.value = null;
      }
    });
  }

  void streamComments(String productId) {
    isLoading.value = true;


    _deleteExpiredNegativeComments(productId);

    _db.collection('Products')
        .doc(productId)
        .collection('Reviews')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {

      final now = DateTime.now();
      List<Map<String, dynamic>> validComments = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();


        if (data['sentiment'] == 'negative' && data['deleteAt'] != null) {
          DateTime deleteTime = (data['deleteAt'] as Timestamp).toDate();
          if (now.isAfter(deleteTime)) {
            continue;
          }
        }
        validComments.add(data);
      }

      commentsList.value = validComments;
      isLoading.value = false;
    }, onError: (e) {
      isLoading.value = false;

    });
  }


  Future<void> sendComment(String productId) async {
    final String text = commentController.text.trim();
    if (text.isEmpty) return;

    try {
      isSubmitting.value = true;
      final String currentUserId = AuthenticationRepo.instance.currentUser!.uid;

      final userDoc = await _db.collection('Users').doc(currentUserId).get();
      final username = userDoc.data()?['username'] ?? 'Ẩn danh';
      final profilePicture = userDoc.data()?['profilePicture'] ?? '';


      String aiSentiment = await _analyzeSentimentWithGemini(text);

      final String reviewId = DateTime.now().millisecondsSinceEpoch.toString();
      final DateTime now = DateTime.now();

      final Map<String, dynamic> newComment = {
        'reviewId': reviewId,
        'userId': currentUserId,
        'username': username,
        'profilePicture': profilePicture,
        'rating': selectedRating.value,
        'comment': text,
        'timestamp': FieldValue.serverTimestamp(),
        'sentiment': aiSentiment,
      };


      if (aiSentiment == 'negative') {
        newComment['deleteAt'] = Timestamp.fromDate(now.add(const Duration(minutes: 10)));
      }


      await _db.collection('Products').doc(productId).collection('Reviews').doc(reviewId).set(newComment);

      commentController.clear();
      selectedRating.value = 5.0;


      await _generateAndSaveAISummary(productId, aiSentiment);

    } catch (e) {
      print("Lỗi gửi bình luận: $e");
    } finally {
      isSubmitting.value = false;
    }
  }
  Future<void> _deleteExpiredNegativeComments(String productId) async {
    try {
      final now = DateTime.now();
      final snapshot = await _db.collection('Products')
          .doc(productId)
          .collection('Reviews')
          .where('sentiment', isEqualTo: 'negative')
          .get();

      WriteBatch batch = _db.batch();
      bool hasUpdates = false;

      for (var doc in snapshot.docs) {
        if (doc.data()['deleteAt'] != null) {
          DateTime deleteTime = (doc.data()['deleteAt'] as Timestamp).toDate();

          if (now.isAfter(deleteTime)) {
            batch.delete(doc.reference);
            hasUpdates = true;
          }
        }
      }

      if (hasUpdates) {
        await batch.commit();


        _generateAndSaveAISummary(productId, 'neutral');
      }
    } catch (e) {
      print("Lỗi xóa bình luận: $e");
    }
  }


  Future<String> _analyzeSentimentWithGemini(String commentText) async {
    final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_googleApiKey';
    final prompt = "Phân tích sắc thái của bình luận sau và CHỈ TRẢ VỀ DUY NHẤT một trong ba từ: 'positive' (nếu tích cực/khen), 'negative' (nếu tiêu cực/chê), hoặc 'neutral' (nếu trung lập/bình thường). Không viết thêm bất kỳ chữ nào khác ngoài 3 từ khóa này. Bình luận: \"$commentText\"";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{"parts": [{"text": prompt}]}]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String result = data['candidates'][0]['content']['parts'][0]['text'].toString().trim().toLowerCase();
        if (result.contains('positive')) return 'positive';
        if (result.contains('negative')) return 'negative';
        return 'neutral';
      }
    } catch (e) {
      print("Lỗi phân tích sắc thái: $e");
    }
    return "positive";
  }


  Future<void> _generateAndSaveAISummary(String productId, String latestSentiment) async {
    final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_googleApiKey';


    String rawReviewsData = commentsList.take(15).map((e) => "- Đánh giá: ${e['rating']} sao, Nội dung: ${e['comment']}").join("\n");

    final prompt = """
Bạn là một chuyên gia phân tích dữ liệu mua sắm thông minh. Dưới đây là danh sách các bình luận thực tế từ người mua cho sản phẩm này:
$rawReviewsData

Hãy viết một đoạn tóm tắt ngắn gọn từ 1 đến 2 câu phản ánh chính xác đánh giá thực tế. Chú ý chỉ ra cả điểm tốt và điểm chưa hài lòng của người dùng nếu có phản hồi trái chiều (ví dụ: người dùng chọn sao thấp nhưng nội dung mâu thuẫn, hoặc phàn nàn về chất lượng). Yêu cầu trả về câu chữ tự nhiên, ngắn gọn, súc tích cho người mua sau dễ nắm bắt.
""";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{"parts": [{"text": prompt}]}]
        }),
      );

      String finalSummaryText = "Chưa có đủ dữ liệu phân tích từ AI.";
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        finalSummaryText = data['candidates'][0]['content']['parts'][0]['text'].toString().trim();
      }


      final summaryRef = _db.collection('review_summaries').doc(productId);
      final summaryDoc = await summaryRef.get();

      double pos = (latestSentiment == 'positive') ? 0.2 : 0.0;
      double neu = (latestSentiment == 'neutral') ? 0.2 : 0.0;
      double neg = (latestSentiment == 'negative') ? 0.2 : 0.0;

      if (summaryDoc.exists) {
        await summaryRef.update({
          'positiveRate': FieldValue.increment(pos),
          'neutralRate': FieldValue.increment(neu),
          'negativeRate': FieldValue.increment(neg),
          'aiSummary': finalSummaryText,
        });
      } else {
        await summaryRef.set({
          'productId': productId,
          'positiveRate': latestSentiment == 'positive' ? 1.0 : 0.0,
          'neutralRate': latestSentiment == 'neutral' ? 1.0 : 0.0,
          'negativeRate': latestSentiment == 'negative' ? 1.0 : 0.0,
          'aiSummary': finalSummaryText,
          'aspects': [{'label': 'Độ hoàn thiện', 'type': latestSentiment, 'count': 1}]
        });
      }
    } catch (e) {
      print("Lỗi tạo tóm tắt: $e");
    }
  }
}