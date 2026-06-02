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
}