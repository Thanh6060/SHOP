import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shop/utils/helpers/network_manager.dart';

import '../../../../data/responsibilities/authentication_repo.dart';
import '../../../../data/responsibilities/promo_code/promo_code_repo.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/texts.dart';
import '../../../../utils/helpers/pricing_calculator.dart' show UPricingCalculator;
import '../../../../utils/popups/snackbar_helpers.dart';
import '../../models/promo_code_model.dart';
import '../cart/cart_controller.dart';

class PromoCodeController extends GetxController{
  static PromoCodeController get instance => Get.find();
  RxString promoCode = ''.obs;
  RxBool isLoading = false.obs;
  Rx<PromoCodeModel> appliedPromoCode = PromoCodeModel.empty().obs;
  RxList<PromoCodeModel> myCoupons = <PromoCodeModel>[].obs;

  final _repository = Get.put(PromoCodeRepo());
  final cartController = Get.put(CartController());
  void onPromoChanged(String value) => promoCode.value = value;

  Future<void> applyPromoCode() async{
    try{
      isLoading.value = true;
      bool isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        USnackBarHelpers.errorSnackBar(title: 'No Internet',message: 'Please check your internet connection');

        return;
      }
      PromoCodeModel promoCode = await _repository.fetchSinglePromCode(this.promoCode.value);
      if(promoCode.id.isEmpty){

        USnackBarHelpers.warningSnackBar(title: 'Invalid Promo Code',message: 'Please enter a valid promo code');
        return;
      }
      DateTime time = DateTime.now();
      if(promoCode.endDate!.isBefore(time)){
        USnackBarHelpers.warningSnackBar(title: 'Promo Code Expired',message: 'This promo code has expired');
        return;
      }

      if(!promoCode.isActive){
        USnackBarHelpers.warningSnackBar(title: 'Promo Code Expired',message: 'This promo code has expired');
        return;
      }

      double subTotal = cartController.totalCartPrice.value;
      double totalPrice = UPricingCalculator.calculateTotalPrice(subTotal, 'VietNam');


      if(!(totalPrice >= promoCode.minOrderPrice)){

        USnackBarHelpers.warningSnackBar(
            title: 'Promo Code Not Applicable',
            message: 'Minium order amount must be  ${UTexts.currency}${promoCode.minOrderPrice.toStringAsFixed(0)}');
        return;
      }
      if(!(promoCode.noOfPromoCodes > 0)){
        USnackBarHelpers.warningSnackBar(title: 'Promo Code Expired',message: 'This promo code has expired');
        return;
      }

      List<String> userIds = promoCode.userIds ?? [];
      String currentUserId = AuthenticationRepo.instance.currentUser!.uid;

      if(userIds.contains(currentUserId)){
        USnackBarHelpers.warningSnackBar(title: 'Already Applied',message: 'You have already applied this promo code');
        return;
      }
      appliedPromoCode.value = promoCode;







    }catch(e){

      USnackBarHelpers.errorSnackBar(title: 'Error',message: e.toString());
    }finally{
      isLoading.value = false;
    }

  }

  double calculatePriceAfterDiscount(PromoCodeModel promoCode,double totalPrice){
    if(promoCode.id.isNotEmpty){

      if(promoCode.discountType == DiscountType.percentage){
        return UPricingCalculator.calculatePercentageDiscount(totalPrice, promoCode.discount);
      }
      else {
        return UPricingCalculator.calculateFixedDiscount(totalPrice, promoCode.discount);
      }
    }
    return totalPrice;



  }


  String getDiscountPrice(){
    if(appliedPromoCode.value.id.isEmpty) return '';
    if(appliedPromoCode.value.discountType == DiscountType.percentage){
      return '${appliedPromoCode.value.discount}%';

    }else {
      return '${UTexts.currency}${appliedPromoCode.value.discount}';
    }

  }

  Future<void> decreaseNoOfPromoCode() async{
    try{
      if(appliedPromoCode.value.id.isEmpty) return;
      int noOfPromoCodes = appliedPromoCode.value.noOfPromoCodes - 1;
      _repository.updateSingleField(appliedPromoCode.value, 'noOfPromoCodes', noOfPromoCodes);

    }catch(e){
      USnackBarHelpers.errorSnackBar(title: 'Error',message: e.toString());
    }
  }

  Future<void> addUserToPromoCode() async{
    try{
      if(appliedPromoCode.value.id.isEmpty) return;
      List<String> userIds = appliedPromoCode.value.userIds ?? [];
      userIds.add(AuthenticationRepo.instance.currentUser!.uid);
     await _repository.updateSingleField(appliedPromoCode.value, 'userIds', userIds);
      
    }catch(e){
      USnackBarHelpers.errorSnackBar(title: 'Error',message: e.toString());
    }
  }

  String _generateRandomString(int length) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final Random random = Random();
    String code = List.generate(length, (index) => characters[random.nextInt(characters.length)]).join();
    return 'LUCKY-$code';
  }
  Future<void> checkAndGenerateRewardPromoCode() async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final String currentUserId = AuthenticationRepo.instance.currentUser!.uid;


      final userDocRef = db.collection('Users').doc(currentUserId);

      await userDocRef.update({'orderCount': FieldValue.increment(1)});


      final userSnapshot = await userDocRef.get();
      final userData = userSnapshot.data() as Map<String, dynamic>;
      int currentOrderCount = userData['orderCount'] ?? 0;

      if (currentOrderCount >= 5) {
        String randomCode = _generateRandomString(4);

        final Map<String, dynamic> newRewardPromo = {
          'id': randomCode,
          'code': randomCode,
          'name': 'Thưởng khách hàng thân thiết (Đủ 5 đơn hàng)',
          'discount': 50.0,
          'discountType': 'DiscountType.fixedAmount',
          'minOrderPrice': 20.0,
          'noOfPromoCodes': 1,
          'isActive': true,
          'startDate': Timestamp.fromDate(DateTime.now()),
          'endDate': Timestamp.fromDate(DateTime.now().add(const Duration(hours: 72))),
          'userIds': [],
        };


        await db.collection('Promotions').doc(randomCode).set(newRewardPromo);


        await userDocRef.set(
            {'orderCount': FieldValue.increment(1)},
            SetOptions(merge: true)
        );


        Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text("🎉 QUÀ THÂN THIẾT!", textAlign: TextAlign.center, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Bạn đã hoàn thành xuất sắc 5 đơn hàng! Nhận ngay mã giảm giá độc quyền dành riêng cho bạn:", textAlign: TextAlign.center),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green, style: BorderStyle.solid),
                  ),
                  child: Text(randomCode, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.black)),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {

                  Clipboard.setData(ClipboardData(text: randomCode));
                  Get.back();
                  USnackBarHelpers.successSnackBar(title: 'Đã sao chép', message: 'Mã đã lưu vào bộ nhớ tạm, hãy sử dụng ở đơn sau!');
                },
                child: const Text("Sao chép mã & Đóng", style: TextStyle(fontWeight: FontWeight.bold)),
              )
            ],
          ),
          barrierDismissible: false,
        );
      }
    } catch (e) {


      USnackBarHelpers.errorSnackBar(title: 'Lỗi Loyalty', message: e.toString());
    }
  }
  Future<void> applyPromoCodeUsedToFirestore() async {
    try {
      if (appliedPromoCode.value.id.isEmpty) return;

      final FirebaseFirestore db = FirebaseFirestore.instance;
      final String currentUserId = AuthenticationRepo.instance.currentUser!.uid;
      final String promoId = appliedPromoCode.value.id;


      if (promoId.startsWith('LUCKY-')) {


        await db.collection('users')
            .doc(currentUserId)
            .collection('coupons')
            .doc(promoId)
            .delete();



      } else {


        await db.collection('promotions').doc(promoId).update({
          'noOfPromoCodes': FieldValue.increment(-1),
          'userIds': FieldValue.arrayUnion([currentUserId]),
        });


      }

    } catch (e) {
      USnackBarHelpers.errorSnackBar(title: "Error code processing", message: e.toString());
    }
  }
  Future<void> fetchMyCoupons() async {
    try {
      final String currentUserId = AuthenticationRepo.instance.currentUser!.uid;
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('coupons')
          .get();

      final list = snapshot.docs.map((doc) => PromoCodeModel.fromSnapshot(doc)).toList();
      myCoupons.assignAll(list);
    } catch (e) {
     USnackBarHelpers.errorSnackBar(title: 'error', message: e.toString());
    }
  }
}