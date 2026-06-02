import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/features/shop/controllers/cart/cart_controller.dart';

import '../../../../../common/widgets/products/cart/cart_item.dart';
import '../../../../../common/widgets/products/cart/product_quantity_with_add_remove.dart';
import '../../../../../common/widgets/texts/product_price_text.dart';
import '../../../../../utils/constants/sizes.dart';

class UCartItems extends StatelessWidget {
  const UCartItems({
    super.key, this.showAddRemoveButton = true,
  });
final bool showAddRemoveButton;
  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    return Obx(
      ()=> ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context,index)=>SizedBox(height: USizes.spaceBtwSections,),

          itemCount: controller.cartItems.length,
          itemBuilder: (context,index){
            final cartItem = controller.cartItems[index];


              return Column(
                children: [
                  UCartItem(cartItem: cartItem,),
                  if(showAddRemoveButton) SizedBox(height: USizes.spaceBtwItems,),
                  if(showAddRemoveButton) Row(
                    children: [
                      SizedBox(width: 70.0,),
                      UProductQuantityWithAddRemove(
                        quantity: cartItem.quantity,
                        add: ()=>controller.addOneToCart(cartItem),
                        remove: ()=> controller.removeOneFromCart(cartItem),
                      ),
                      Spacer(),
                      UProductPriceText(price: (cartItem.price * cartItem.quantity).toStringAsFixed(0),),

                    ],
                  )
                ],
              );

          }),
    );
  }
}
