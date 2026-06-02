import 'package:flutter/material.dart';
import 'package:shop/common/styles/shadow.dart';
import 'package:shop/common/widgets/button/add_to_card_button.dart';
import 'package:shop/common/widgets/custom_shapes/rounded_container.dart';
import 'package:shop/common/widgets/images/rounded_image.dart';
import 'package:shop/common/widgets/products/favourite/favourite_icon.dart';
import 'package:shop/features/shop/controllers/product/product_controller.dart';
import 'package:shop/features/shop/models/product_model.dart';

import 'package:shop/utils/helpers/helper_function.dart';

import '../../../../features/shop/screens/product_details/product_details.dart';
import '../../../../utils/constants/colors.dart';

import '../../../../utils/constants/sizes.dart';


import '../../texts/brand_title_with_verify_icon.dart';
import '../../texts/product_price_text.dart';
import '../../texts/product_title_text.dart';
import 'package:get/get.dart';

class UProductCardVertical extends StatelessWidget {
  const UProductCardVertical({
    super.key,
    required this.product
  });
  final ProductModel product;


  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    final controller = ProductController.instance;
    String? salePercentage = controller.calculateSalePercentage(product.price,product.salePrice);
    return GestureDetector(
      onTap: ()=>Get.to(()=>ProductDetailsScreen(product: product,)),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: UShadow.verticalProductShadow,
          borderRadius: BorderRadius.circular(USizes.productImageRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            URoundedContainer(
              height: 180,
              padding: const EdgeInsets.all(USizes.sm),
              backgroundColor: dark ? UColors.dark : UColors.light,
              child: Stack(
                children: [
                  Center(child: URoundedImage(imageUrl: product.thumbnail,isNetworkImage: true,)),
                  if(salePercentage != null)
                  Positioned(
                    top: 12,
                    child: URoundedContainer(
                      radius: USizes.sm,
                      backgroundColor: UColors.yellow.withValues(alpha: 0.8),
                      padding: const EdgeInsets.symmetric(horizontal: USizes.sm,vertical: USizes.xs),
                      child: Text("$salePercentage%", style: Theme.of(context).textTheme.labelLarge!.apply(color: UColors.black),),
                    ),
                  ),
                  Positioned(
                    right: 0,
                      top: 0,
                      child: UFavouriteIcon(productId: product.id,),
                  )
                ],
              ),
            ),
            SizedBox(height: USizes.spaceBtwItems/2,),
            Padding(
              padding: const EdgeInsets.only(left: USizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UProductTitleText(title: product.title, smallSize: true,),
                  SizedBox(height: USizes.spaceBtwItems / 2,),
                  UBranchTitleWithVerifyIcon(
                    title: product.brand!.name,
                  ),
                  
      
      

      
                ],
              ),
            ),
            Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: USizes.sm),
                  child: UProductPriceText(price: controller.getProductPrice(product),),
                ),



                ProductAddToCardButton(product: product,)
              ],
            )
          ],
        ),
      ),
    );
  }
}







