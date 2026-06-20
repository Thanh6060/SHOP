import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop/common/widgets/custom_shapes/rounded_container.dart';
import 'package:shop/common/widgets/loader/animation_loader.dart';
import 'package:shop/features/authentication/model/order_model.dart';
import 'package:shop/features/shop/controllers/order/order_controller.dart';
import 'package:shop/navigation_menu.dart';
import 'package:shop/utils/constants/colors.dart';
import 'package:shop/utils/constants/images.dart';
import 'package:shop/utils/constants/sizes.dart';
import 'package:shop/utils/helpers/cloud_helper_functions.dart';
import 'package:shop/utils/helpers/helper_function.dart';

import 'detail.dart';

class UOrdersListItem extends StatelessWidget {
  const UOrdersListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    final controller = Get.put(OrderController());
    return FutureBuilder(
        future: controller.fetchUserOrders(),
        builder: (context,snapshot){
          final nothingFound = UAnimationLoader(
            text: 'No order yet!',
            showActionButton: true,
            actionText: "Let's fill it",
            animation: UImages.pencilAnimation,
            onActionPressed: ()=> Get.offAll(()=> NavigationMenu()),
          );
          final widget = UCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot,nothingFound: nothingFound);
          if(widget != null) return widget;

          List<OrderModel> orders = snapshot.data!;
          return ListView.separated(
              separatorBuilder: (context,index)=>SizedBox(height: USizes.spaceBtwItems,),
              itemCount: orders.length,
              itemBuilder: (context,index){
                OrderModel order = orders[index];
                return URoundedContainer(
                  showBorder: true,
                  backgroundColor: dark ? UColors.dark : UColors.light,
                  padding: EdgeInsets.all(USizes.md),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(Iconsax.ship),
                          SizedBox(width: USizes.spaceBtwItems/2,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.orderStatusText,style: Theme.of(context).textTheme.bodyLarge!.apply(color: UColors.primary,fontWeightDelta: 1),),
                                Text(order.formattedOrderDate,style: Theme.of(context).textTheme.headlineSmall,)

                              ],
                            ),
                          ),
                          IconButton(onPressed: ()=> Get.to(()=>DetailScreen(orderId: order.id,)), icon: Icon(Iconsax.arrow_right_34,size: USizes.iconSm,))
                        ],
                      ),
                      SizedBox(height: USizes.spaceBtwItems,),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(Iconsax.tag),
                                SizedBox(width: USizes.spaceBtwItems/2,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Order",style: Theme.of(context).textTheme.labelMedium,),
                                      Text(order.id,style: Theme.of(context).textTheme.titleMedium,)

                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Icon(Iconsax.calendar),
                                SizedBox(width: USizes.spaceBtwItems/2,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Shipping Date",style: Theme.of(context).textTheme.labelMedium,),
                                      Text(order.formattedDeliveryDate,style: Theme.of(context).textTheme.titleMedium,)

                                    ],
                                  ),
                                ),

                              ],
                            ),
                          )
                        ],
                      )

                    ],
                  ),
                );
              }
          );
        }
    );
  }
}
