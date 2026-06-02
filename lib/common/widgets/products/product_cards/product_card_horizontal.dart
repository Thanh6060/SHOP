import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shop/common/widgets/button/add_to_card_button.dart';
import 'package:shop/common/widgets/products/favourite/favourite_icon.dart';
import 'package:shop/common/widgets/texts/brand_title_with_verify_icon.dart';
import 'package:shop/common/widgets/texts/product_price_text.dart';
import 'package:shop/common/widgets/texts/product_title_text.dart';
import 'package:shop/features/shop/controllers/product/product_controller.dart';
import 'package:shop/features/shop/models/product_model.dart';
import 'package:shop/utils/helpers/helper_function.dart';

import '../../../../features/shop/screens/product_details/product_details.dart';
import '../../../../utils/constants/colors.dart';

import '../../../../utils/constants/sizes.dart';
import '../../custom_shapes/rounded_container.dart';

import '../../images/rounded_image.dart';

class UProductCardHorizontal extends StatelessWidget {
  const UProductCardHorizontal({
    super.key,
    required this.product

  });

final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    final controller = ProductController.instance ;
    String? salePercentage = controller.calculateSalePercentage(product.price,product.salePrice);
    return GestureDetector(
      onTap: ()=>Get.to(()=>ProductDetailsScreen(product: product,)),
      child: Container(
        width: 310,
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(USizes.productImageRadius),
          color: dark ? UColors.darkGrey : UColors.light,
        ),
        child: Row(
          children: [
            URoundedContainer(
              height: 120,
              padding: EdgeInsets.all(USizes.sm),
              backgroundColor: dark ? UColors.dark : UColors.light,
              child: Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: URoundedImage(imageUrl: product.thumbnail,isNetworkImage: true,),
      
                  ),
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
            SizedBox(
              width: 172.0,
      
              child: Padding(
                padding: const EdgeInsets.only(left: USizes.sm,top: USizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UProductTitleText(title: product.title,smallSize: true,),
                        SizedBox(height: USizes.spaceBtwItems/2,),
                        UBranchTitleWithVerifyIcon(title: product.brand!.name)
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: UProductPriceText(price: controller.getProductPrice(product))),
                        ProductAddToCardButton(product: product)
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
