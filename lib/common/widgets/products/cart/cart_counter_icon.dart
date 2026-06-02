import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop/features/shop/controllers/cart/cart_controller.dart';
import 'package:shop/features/shop/screens/cart/cart.dart';
import 'package:shop/utils/helpers/helper_function.dart';

import '../../../../utils/constants/colors.dart';

class UCartCounterIcon extends StatelessWidget {
  const UCartCounterIcon({
    super.key,

  });



  @override
  Widget build(BuildContext context) {
    bool dark = UHelperFunctions.isDarkMode(context);
    final controller = Get.put(CartController());
    return Stack(
      children: [
        IconButton(
          onPressed: ()=>Get.to(()=>CartScreen()),
          icon: const Icon(Iconsax.shopping_cart),
          color: UColors.light,
        ),

        Positioned(
          right: 6.0,
          child:  Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              color: dark ? UColors.dark : UColors.light,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Obx(
            ()=> Text(controller.noOfCartItem.value.toString(),
                  style: Theme.of(context).
                  textTheme.
                  labelLarge!.
                  apply(fontSizeFactor:0.8, color: dark ? UColors.light : UColors.dark ),),
              ),
            ),
          ),)
      ],
    );
  }
}