import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/features/shop/models/product_model.dart';
import 'package:shop/utils/constants/sizes.dart';

class ImageController extends GetxController{
  static ImageController get instance => Get.find();
  RxString selectedProductImage = ''.obs;

  List<String> getAllProductImages(ProductModel product){
    Set<String> images = {};
    // load image
    images.add(product.thumbnail);
    // assign as selected image
    selectedProductImage.value = product.thumbnail;
    // load all image of product
    if(product.images != null && product.images!.isNotEmpty){
      images.addAll(product.images!);
    }
    // load all image from the product variation
    if(product.productVariations != null && product.productVariations!.isNotEmpty){
      List<String> variationImages = product.productVariations!.map((variation)=>variation.image).toList();
      images.addAll(variationImages);
    }
    return images.toList();
  }
  void showEnlargeImage(String image){
    Get.to(
        fullscreenDialog: true,
        ()=> Dialog.fullscreen(
          child: Column(
            children: [

              // image
              Padding(padding: EdgeInsets.symmetric(vertical: USizes.defaultSpace*2,horizontal: USizes.defaultSpace),
              child: CachedNetworkImage(imageUrl: image),
              ),
              SizedBox(height: USizes.spaceBtwSections,),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 150,
                  child: OutlinedButton(onPressed: Get.back, child: Text('Close')),
                ),
              )
            ],
          ),
        )
    );
  }
}