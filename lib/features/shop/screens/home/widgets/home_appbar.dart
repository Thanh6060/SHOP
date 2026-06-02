import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/common/widgets/shimmer/shimmer_effect.dart';
import 'package:shop/features/personalization/controllers/user_controller.dart';
import 'package:shop/utils/constants/sizes.dart';
import 'package:shop/utils/helpers/helper_function.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/products/cart/cart_counter_icon.dart';
import '../../../../../utils/constants/colors.dart';


class UHomeAppBar extends StatelessWidget {
  const UHomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return UAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(UHelperFunctions.getGreetingMessage(),
            style: Theme.of(context).textTheme.labelMedium!.apply(color: UColors.grey),),
          SizedBox(height: USizes.spaceBtwItems/3,),
          Obx(
            (){
              if(controller.profileLeading.value){
                return UShimmerEffect(width: 80, height: 15);
              }

              return Text(
                controller.user.value.fullName,
                style: Theme.of(context).textTheme.labelSmall!.apply(color: UColors.white),);
            }
    ),
        ],
      ),
      action: [
        UCartCounterIcon()


      ],

    );
  }
}