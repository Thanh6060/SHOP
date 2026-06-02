import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/features/shop/controllers/cart/cart_controller.dart';
import 'package:shop/utils/constants/colors.dart';
import 'package:shop/utils/constants/texts.dart';
import 'package:shop/utils/helpers/pricing_calculator.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/promo_code/promo_code_controller.dart';

class UBillingAmountSection extends StatelessWidget {
  const UBillingAmountSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final subTotal = cartController.totalCartPrice.value;
    final promoCodeController = PromoCodeController.instance;
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Text("Subtotal", style: Theme.of(context).textTheme.bodyMedium,)),
            Text(" ${UTexts.currency}$subTotal", style: Theme.of(context).textTheme.bodyMedium,),
          ],
        ),
        SizedBox(height: USizes.spaceBtwItems/2,),
        Row(
          children: [
            Expanded(child: Text("Shipping Fee", style: Theme.of(context).textTheme.bodyMedium,)),
            Text("${UTexts.currency}${UPricingCalculator.calculateShippingCost(subTotal, 'VietNam')}", style: Theme.of(context).textTheme.labelLarge,),
          ],
        ),
        SizedBox(height: USizes.spaceBtwItems/2,),
        Row(
          children: [
            Expanded(
                child: Text("Tax Fee", style: Theme.of(context).textTheme.bodyMedium,)),
            Text("${UTexts.currency}${UPricingCalculator.calculateTax(subTotal, 'VietNam')}", style: Theme.of(context).textTheme.bodyMedium,),
          ],
        ),
        SizedBox(height: USizes.spaceBtwItems/2,),
        Row(
          children: [
            Expanded(child: Text("Order Total", style: Theme.of(context).textTheme.bodyMedium,)),
            Obx((){

              double totalPrice = UPricingCalculator.
              calculateTotalPrice(subTotal, 'VietNam');

              final promoCode = promoCodeController.appliedPromoCode.value;
              totalPrice = promoCodeController.calculatePriceAfterDiscount(promoCode, totalPrice);

              return Text(""
                  "${UTexts.currency}"
                  "${totalPrice.toStringAsFixed(2)}",
                style: Theme.of(context).textTheme.titleMedium,
              );
            } ),
          ],
        ),
        SizedBox(height: USizes.spaceBtwItems/2,),

        Obx((){
          final promoCode = promoCodeController.appliedPromoCode.value;

          if(promoCode.id.isEmpty) return SizedBox();
          return Row(
            children: [
              Expanded(
                  child: Text("Discount",
                    style: Theme.of(context).
                    textTheme.
                    bodyMedium!
                        .apply(color: UColors.success),
                  )),
              Text(promoCodeController.getDiscountPrice(),style: Theme.of(context).textTheme.titleMedium!.apply(color: UColors.success) ,)

            ],
          );
        })
      ],
    );
  }
}