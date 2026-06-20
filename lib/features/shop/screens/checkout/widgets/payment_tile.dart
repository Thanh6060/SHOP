import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop/features/shop/controllers/checkout/checkout_controller.dart';

import '../../../../../common/widgets/custom_shapes/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_function.dart';
import '../../../models/payment_method_model.dart';

class UPaymentTitle extends StatelessWidget {
  const UPaymentTitle({super.key,required this.paymentMethod, this.onTap});
  final PaymentMethodModel paymentMethod;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final controller = CheckoutController.instance;
    return ListTile(
      onTap: (){
        controller.selectedPaymentMethod.value = paymentMethod;
        Get.back();
      },
      contentPadding: EdgeInsets.zero,
      leading: URoundedContainer(
        width: 40,
        height: 40,
        backgroundColor: UHelperFunctions.isDarkMode(context) ? UColors.light : UColors.white,
        padding: EdgeInsets.all(USizes.sm),
        child: Image(image: AssetImage(paymentMethod.image),fit: BoxFit.contain,),
      ),
      title: Text(paymentMethod.name),
      trailing: Icon(Iconsax.arrow_right_34),
    );
  }
}