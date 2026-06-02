import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/common/styles/padding.dart';
import 'package:shop/common/widgets/appbar/appbar.dart';
import 'package:shop/common/widgets/custom_shapes/rounded_container.dart';
import 'package:shop/common/widgets/loader/screen_partial_loader.dart';

import 'package:shop/features/shop/controllers/cart/cart_controller.dart';

import 'package:shop/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:shop/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:shop/features/shop/screens/checkout/widgets/billing_amount_section.dart';
import 'package:shop/features/shop/screens/checkout/widgets/billing_payment_section.dart';


import 'package:shop/utils/constants/sizes.dart';
import 'package:shop/utils/constants/texts.dart';
import 'package:shop/utils/helpers/pricing_calculator.dart';
import 'package:shop/utils/popups/snackbar_helpers.dart';

import '../../../../common/widgets/button/elevated_button.dart';
import '../../../../common/widgets/textfield/promo_code.dart';

import '../../controllers/checkout/checkout_controller.dart';
import '../../controllers/promo_code/promo_code_controller.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final promoCodeController = Get.put(PromoCodeController());
    final cartController = CartController.instance;
    double subTotal = cartController.totalCartPrice.value;

    double totalPrice = UPricingCalculator.calculateTotalPrice(subTotal, 'VietNam');

    final checkoutController = Get.put(CheckoutController());
    return Obx(
      ()=> UPartialScreenLoading(
        isLoading: checkoutController.isPaymentSuccess.value,

        child: Scaffold(
            appBar: UAppBar(
              showBackArrow: true,title: Text("Order Review",style: Theme.of(context).textTheme.headlineSmall,),),
          body: SingleChildScrollView(
            child: Padding(
              padding: UPadding.screenPadding,
              child: Column(
                children: [
                  UCartItems(showAddRemoveButton: false,),
                  SizedBox(height: USizes.spaceBtwSections,),
                  UPromoCodeField(),
                  SizedBox(height: USizes.spaceBtwSections,),
                  URoundedContainer(
                    showBorder: true,
                    padding: EdgeInsets.all(USizes.md),
                    backgroundColor: Colors.transparent,
                    child: Column(
                      children: [
                        UBillingAmountSection(),
                        SizedBox(height: USizes.spaceBtwItems,),
                        UBillingPaymentSection(),
                        SizedBox(height: USizes.spaceBtwItems,),
                        UBillingAddressSection()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),


          bottomNavigationBar: Obx(
              (){
                final promoCode = promoCodeController.appliedPromoCode.value;
                totalPrice = promoCodeController.calculatePriceAfterDiscount(promoCode, totalPrice);
              return  Padding(
                  padding: const EdgeInsets.all(USizes.defaultSpace),
                  child: UElevatedButton(
                      onPressed: subTotal > 0
                          ? ()=> checkoutController.checkout(totalPrice)
                          : ()=> USnackBarHelpers.errorSnackBar(title: 'Empty Cart',message: 'Add items in the cart')
                      ,
                      child: Text("Checkout ${UTexts.currency}${totalPrice.toStringAsFixed(2)}")),
                );
              }
          ),
        ),
      ),
    );
  }
}




