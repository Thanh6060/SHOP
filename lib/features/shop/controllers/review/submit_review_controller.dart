import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop/utils/popups/snackbar_helpers.dart';
import '../../../../data/services/product_ai_service.dart';

class SubmitReviewController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ProductAIService _aiService = ProductAIService();

  Future<void> sendReview(String productId, String comment, double rating) async {
    try {

      await _db.collection('products').doc(productId).collection('reviews').add({
        'comment': comment,
        'rating': rating,
        'timestamp': FieldValue.serverTimestamp(),
      });


      Future.microtask(() => _aiService.runNLPAnalysis(productId).catchError((e) {
        USnackBarHelpers.errorSnackBar(title: 'error', message: e.toString());
      }));


      USnackBarHelpers.successSnackBar(title: 'Thành công', message: 'Đã gửi đánh giá');

    } catch (e) {

      USnackBarHelpers.errorSnackBar(title: 'error', message: e.toString());
    }
  }
}