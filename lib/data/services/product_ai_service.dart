import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart'; // Dùng thư viện gốc của Google
import 'dart:convert';

import 'package:shop/utils/popups/snackbar_helpers.dart';

import '../../utils/constants/apis.dart';

class ProductAIService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  final String _apiKey = UApiUrls.googleApiKey;

  Future<void> runNLPAnalysis(String productId) async {
    try {



      final reviewsSnapshot = await _db
          .collection('products')
          .doc(productId)
          .collection('reviews')
          .get();

      if (reviewsSnapshot.docs.isEmpty) {

        return;
      }


      List<String> reviewsList = reviewsSnapshot.docs
          .where((doc) => doc.data().containsKey('comment'))
          .map((doc) => doc.data()['comment'].toString())
          .toList();


      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _apiKey,
        generationConfig: GenerationConfig(responseMimeType: 'application/json'),
      );


      final prompt = '''
      Bạn là một chuyên gia phân tích ngôn ngữ tự nhiên (NLP) cho sàn thương mại điện tử. 
      Hãy phân tích danh sách các đánh giá sản phẩm dưới đây và trả về một chuỗi JSON duy nhất (không chứa thêm từ nào khác ngoài JSON) có cấu trúc chính xác như sau:
      {
        "positive_rate": 0.00,
        "neutral_rate": 0.00,
        "negative_rate": 0.00,
        "ai_summary": "Đoạn văn tóm tắt ưu nhược điểm khách quan bằng tiếng Việt (2-3 câu)",
        "aspects": [
          {"label": "Tên tag viết ngắn gọn 2-3 từ", "type": "positive hoặc neutral hoặc negative", "count": số lần xuất hiện}
        ]
      }
      
      Danh sách đánh giá cần phân tích: ${jsonEncode(reviewsList)}
      ''';


      final response = await model.generateContent([Content.text(prompt)]);

      if (response.text != null) {

        final Map<String, dynamic> resultJson = jsonDecode(response.text!);


        await _db.collection('review_summaries').doc(productId).set({
          'product_id': productId,
          'positive_rate': resultJson['positive_rate'],
          'neutral_rate': resultJson['neutral_rate'],
          'negative_rate': resultJson['negative_rate'],
          'ai_summary': resultJson['ai_summary'],
          'aspects': resultJson['aspects'],
          'updated_at': FieldValue.serverTimestamp(),
        });

        USnackBarHelpers.successSnackBar(title: 'Success');
      }
    } catch (e) {
      USnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}