import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:readmore/readmore.dart';
import 'package:shop/common/styles/padding.dart';

import 'package:shop/common/widgets/button/elevated_button.dart';

import 'package:shop/common/widgets/texts/section_heading.dart';
import 'package:shop/features/shop/models/product_model.dart';
import 'package:shop/features/shop/screens/checkout/checkout.dart';
import 'package:shop/features/shop/screens/product_details/widgets/bottom_add_to_cart.dart';
import 'package:shop/features/shop/screens/product_details/widgets/product_attributes.dart';

import 'package:shop/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:shop/features/shop/screens/product_details/widgets/product_npl_reviews_container.dart';

import 'package:shop/features/shop/screens/product_details/widgets/product_thumbnail_and_slider.dart';
import 'package:shop/utils/constants/enums.dart';




import '../../../../utils/constants/sizes.dart';
import '../../controllers/cart/cart_controller.dart';
import '../../controllers/product/product_controller.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key,required this.product});

  final ProductModel product;
  @override
  Widget build(BuildContext context) {
     Get.put(ProductController());
     Get.put(CartController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
           UProductThumbnailAndSlider(product: product,),
            Padding(
              padding: UPadding.screenPadding,
              child: Column(
                children: [
                  UProductMetaData(product: product,),
                  SizedBox(height: USizes.spaceBtwSections,),
                  if(product.productType == ProductType.variable.toString())...[
                    UProductAttributes(product: product,),
                    SizedBox(height: USizes.spaceBtwSections,),
                  ],

                  UElevatedButton(onPressed: ()=> Get.to(CheckoutScreen()), child: Text("Checkout")),
                  SizedBox(height: USizes.spaceBtwItems,),
                  USectionHeading(title: "Description",showActionButton: false,),
                  SizedBox(height: USizes.spaceBtwItems,),

                  ReadMoreText(
                   product.description ?? '',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: "Show more",
                    trimExpandedText: "Less",
                    moreStyle: TextStyle(fontSize: 14.0,fontWeight: FontWeight.w800),
                    lessStyle: TextStyle(fontSize: 14.0,fontWeight: FontWeight.w800),

                  ),
                  SizedBox(height: USizes.spaceBtwSections,),
                  UProductNLPReviewsContainer(productId: product.id,),
                  SizedBox(height: USizes.spaceBtwItems,),



                ],
              ),
            )


          ],
        ),
      ),
      bottomNavigationBar: UBottomAddToCart(product: product,),
    );
  }
}




