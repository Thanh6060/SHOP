import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:shop/common/widgets/texts/section_heading.dart';
import 'package:shop/features/shop/controllers/promo_code/promo_code_controller.dart';
import 'package:shop/features/shop/models/payment_method_model.dart';
import 'package:shop/utils/constants/enums.dart';
import 'package:shop/utils/constants/images.dart';
import 'package:shop/utils/constants/sizes.dart';

import '../../../../data/services/stripe_services.dart';
import '../../../../utils/popups/snackbar_helpers.dart';
import '../../screens/checkout/widgets/payment_tile.dart';
import '../order/order_controller.dart';

class CheckoutController extends GetxController{
  static CheckoutController get instance => Get.find();

  Rx<PaymentMethodModel>  selectedPaymentMethod = PaymentMethodModel.empty().obs;

  final _orderController = Get.put(OrderController());
  final _stripeServices = Get.put(StripServices());
  final isPaymentSuccess = false.obs;


  @override
  void onInit() {
    selectedPaymentMethod.value = PaymentMethodModel(name: 'Cash on delivery', image: UImages.codIcon,paymentMethod: PaymentMethods.cashOnDelivery);
    super.onInit();
  }

  Future<void> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(context: context, builder: (context)=> SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(USizes.lg),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           USectionHeading(title: 'Select Payment Method',showActionButton: false,),
           SizedBox(height: USizes.spaceBtwSections,),
           UPaymentTitle(paymentMethod: PaymentMethodModel(name: 'Cash on delivery', image: UImages.codIcon,paymentMethod: PaymentMethods.cashOnDelivery)),
           SizedBox(height: USizes.spaceBtwItems/2,),
           UPaymentTitle(paymentMethod: PaymentMethodModel(name: 'Paypal', image: UImages.paypal,paymentMethod: PaymentMethods.paypal)),
           SizedBox(height: USizes.spaceBtwItems/2,),
           UPaymentTitle(paymentMethod: PaymentMethodModel(name: 'Credit/Debit Card', image: UImages.creditCard,paymentMethod: PaymentMethods.creditCard)),
           SizedBox(height: USizes.spaceBtwItems/2,),

         ],
       ), 
      ),
    ));
  }

  Future<void> checkout(double totalAmount) async{
    try{
      isPaymentSuccess.value = true;
      PaymentMethods paymentMethod = selectedPaymentMethod.value.paymentMethod;
      switch(paymentMethod){
        case PaymentMethods.creditCard:
          await _stripeServices.initPaymentSheet('USD', totalAmount.toInt());
          await _stripeServices.showPaymentSheet();


        case PaymentMethods.cashOnDelivery:
          break;
        default:
         throw 'Payment method not supported';

      }
      isPaymentSuccess.value = false;



     await _orderController.processOrder(totalAmount);

    await PromoCodeController.instance.decreaseNoOfPromoCode();

    await PromoCodeController.instance.addUserToPromoCode();
    }catch(e){
      isPaymentSuccess.value = false;
      USnackBarHelpers.errorSnackBar(title: 'Error!',message: e.toString());

    }

  }
}

