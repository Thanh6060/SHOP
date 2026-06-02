import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shop/common/widgets/products/favourite/favourite_icon.dart';
import 'package:shop/features/shop/controllers/product/image_controller.dart';
import 'package:shop/features/shop/models/product_model.dart';

import '../../../../../common/widgets/appbar/appbar.dart';

import '../../../../../common/widgets/images/rounded_image.dart';
import '../../../../../utils/constants/colors.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_function.dart';

class UProductThumbnailAndSlider extends StatelessWidget {
  const UProductThumbnailAndSlider({
    super.key,
    required this.product

  });


final ProductModel product;
  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    final controller = Get.put(ImageController());
    List<String> images = controller.getAllProductImages(product);
    return Container(
      color: dark ? UColors.darkGrey : UColors.light,
      child: Stack(
        children: [
          SizedBox(
            height: 400,
            child: Padding(
              padding: const EdgeInsets.all(USizes.productImageRadius*2),
              child: Center(child:
              Obx(
                  (){
                    final image = controller.selectedProductImage.value;
                    return GestureDetector(
                      onTap: ()=> controller.showEnlargeImage(image),
                      child: CachedNetworkImage(
                        imageUrl: image,
                        progressIndicatorBuilder: (context,url,progress)=> CircularProgressIndicator(color: UColors.primary,value: progress.progress,),
                      ),
                    );
                  }
              )
              ),
            ),

          ),
          Positioned(
            left: USizes.defaultSpace,
            right: 0,
            bottom: 30,
            child: SizedBox(
              height: 80.0,
              child: ListView.separated(
                separatorBuilder: (context,index)=>SizedBox(width: USizes.spaceBtwItems,),
                shrinkWrap: true,
                itemCount: images.length,
                scrollDirection: Axis.horizontal,
                itemBuilder:(context,index) =>Obx(
                    (){
                      bool isImageSelected = controller.selectedProductImage.value == images[index];
                     return URoundedImage(
                        width: 80,
                        isNetworkImage: true,
                        onTap: ()=>controller.selectedProductImage.value == images[index],
                        backgroundColor: dark ? UColors.dark : UColors.white,
                        padding: EdgeInsets.all(USizes.sm),
                        border: Border.all(color: isImageSelected ?  UColors.primary : Colors.transparent),
                        imageUrl: images[index],
                      );
                    }
                )
              ),
            ),
          ),
          UAppBar(
            showBackArrow: true,
            action: [
              UFavouriteIcon(productId: product.id,)
            ],
          )
        ],
      ),
    );
  }
}