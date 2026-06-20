

import 'package:flutter/material.dart';
import 'package:shop/common/widgets/shimmer/boxes_shimmer.dart';
import 'package:shop/common/widgets/shimmer/list_tile_shimmer.dart';
import 'package:shop/features/shop/controllers/brand/brand_controller.dart';
import 'package:shop/features/shop/models/category_model.dart';


import '../../../../../common/widgets/brands/brand_showcase.dart';

import '../../../../../common/widgets/shimmer/brands_shimmer.dart';
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loader;
        }

        if (snapshot.hasError) {

          return Text("ERROR");
        }

        if (!snapshot.hasData) {

          return Text("NO DATA");
        }



        if (snapshot.data!.isEmpty) {

          return const Center(
            child: Text("No Brand Data Found for this Category!"),
          );
        }

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
             if (snapshot.connectionState == ConnectionState.waiting) {
               return const UBrandsShimmer();
             }
             if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
               return UBrandShowCase(brand: brand, images: const []);
             }
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
