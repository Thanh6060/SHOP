
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/common/widgets/custom_shapes/rounded_container.dart';
import 'package:shop/common/widgets/texts/section_heading.dart';
import 'package:shop/features/shop/controllers/checkout/checkout_controller.dart';
import 'package:shop/utils/constants/colors.dart';

import 'package:shop/utils/constants/sizes.dart';
import 'package:shop/utils/helpers/helper_function.dart';

class UBillingPaymentSection extends StatelessWidget {
  const UBillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    final controller = CheckoutController.instance;
    return Column(
      children: [
        USectionHeading(title: 'Payment Method',buttonTitle: "Change", onPressed: ()=>controller.selectPaymentMethod(context),),
        SizedBox(height: USizes.spaceBtwItems/2,),
        Obx(
          ()=> Row(
            children: [
              URoundedContainer(
                width: 60,
                height: 35,
                backgroundColor: dark ? UColors.light : UColors.white,
                padding: EdgeInsets.all(USizes.sm),
                child: Image(image: AssetImage(controller.selectedPaymentMethod.value.image),fit: BoxFit.contain,),
          
              ),
              SizedBox(width: USizes.spaceBtwItems/2,),
              Text(controller.selectedPaymentMethod.value.name,style: Theme.of(context).textTheme.bodyLarge,)
            ],
          ),
        )
      ],
    );
  }
}
