import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop/features/shop/controllers/cart/cart_controller.dart';
import 'package:shop/features/shop/models/cart_item_model.dart';
import 'package:shop/features/shop/models/product_model.dart';
import 'package:shop/features/shop/screens/product_details/product_details.dart';
import 'package:shop/utils/constants/enums.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class ProductAddToCardButton extends StatelessWidget {
  const ProductAddToCardButton({super.key,required this.product});

  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());
    return InkWell(
      onTap: (){
        if(product.productType == ProductType.single.toString()){
          CartItemModel cartItem = controller.convertToCartItem(product, 1);
          controller.addOneToCart(cartItem);
        }else{
          Get.to(()=>ProductDetailsScreen(product: product));
        }
      },
      child: Obx(
          (){
            final productQuantityInCart = controller.getProductQuantityInCart(product.id);
            return Container(
              width: USizes.iconLg * 1.2,
              height: USizes.iconLg * 1.2,

              decoration: BoxDecoration(
                  color: productQuantityInCart > 0 ? UColors.dark : UColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(USizes.cardRadiusMd),
                    bottomRight: Radius.circular(USizes.productImageRadius),
                  )
              ),
              child: Center(
                child: productQuantityInCart > 0 ? Text(productQuantityInCart.toString(),style: Theme.of(context).textTheme.titleLarge!.apply(color: UColors.white),) : Icon(Iconsax.add, color: UColors.white,),
              ),
            );
          }
      )
    );
  }
}
