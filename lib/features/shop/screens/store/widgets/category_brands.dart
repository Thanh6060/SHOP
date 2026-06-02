

import 'package:flutter/material.dart';
import 'package:shop/common/widgets/shimmer/boxes_shimmer.dart';
import 'package:shop/common/widgets/shimmer/list_tile_shimmer.dart';
import 'package:shop/features/shop/controllers/brand/brand_controller.dart';
import 'package:shop/features/shop/models/category_model.dart';
import 'package:shop/utils/helpers/cloud_helper_functions.dart';

import '../../../../../common/widgets/brands/brand_showcase.dart';

import '../../../../../utils/constants/sizes.dart';

class CategoryBrands extends StatelessWidget {
  const CategoryBrands({super.key,required this.category});

  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    final controller = BrandController.instance;
    return FutureBuilder(

      future: controller.getBrandsForCategory(category.id),
      builder: (context,snapshot){
        const loader = Column(
          children: [

            UListTileShimmer(),
            SizedBox(height: USizes.spaceBtwItems,),
            UBoxesShimmer(),
            SizedBox(height: USizes.spaceBtwItems,),
          ],
        );

        final widget =    UCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot,loader: loader);
        if(widget != null) return widget;
        final brands = snapshot.data!;
       return ListView.builder(
         physics: NeverScrollableScrollPhysics(),
         shrinkWrap: true,
       itemCount: brands.length,
       itemBuilder: (context,index){

         final brand = brands[index];
         return FutureBuilder(
           future: controller.getBrandProducts(brand.id,limit: 3),
           builder: (context,snapshot){
             final widget = UCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot);
             if(widget != null ) return widget;
             final products = snapshot.data!;
             return UBrandShowCase(
                 brand: brand,
                 images: products.map((product)=>product.thumbnail).toList());
           },
         );
       });
      },
    );
  }
}
