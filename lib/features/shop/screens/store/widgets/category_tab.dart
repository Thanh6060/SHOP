import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:shop/features/shop/controllers/category/category_controller.dart';
import 'package:shop/features/shop/models/category_model.dart';
import 'package:shop/features/shop/models/product_model.dart';
import 'package:shop/features/shop/screens/all_products/all_products.dart';
import 'package:shop/features/shop/screens/store/widgets/category_brands.dart';
import 'package:shop/utils/helpers/cloud_helper_functions.dart';


import '../../../../../common/widgets/layouts/grid_layouts.dart';
import '../../../../../common/widgets/products/product_cards/product_card_vertical.dart';
import '../../../../../common/widgets/texts/section_heading.dart';

import '../../../../../utils/constants/sizes.dart';

class UCategoryTab extends StatelessWidget {
  const UCategoryTab({
    super.key,
    required this.category
  });
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: USizes.defaultSpace),
          child: Column(
            children: [
              CategoryBrands(category: category,),

              SizedBox(height: USizes.spaceBtwItems,),
              USectionHeading(title: "You might like", onPressed: ()=>Get.to(()=>AllProductsScreen(title: category.name,
              futureMethod: controller.getCategoryProducts(categoryId: category.id,limit: -1),
              )),),
              FutureBuilder(
                  future: controller.getCategoryProducts(categoryId: category.id),
                  builder: (context,snapshot){
                    const loader = UVerticalProductShimmer(itemCount: 4,);
                    final widget = UCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot,loader: loader);
                    if(widget != null) return widget;
                    List<ProductModel> products = snapshot.data!;
                    return UGridLayout(
                      itemCount: products.length,
                      itemBuilder: (context,index){
                        ProductModel product = products[index];
                        return UProductCardVertical(
                          product: product,);
                      },
                    );
                  }
              ),
              SizedBox(height: USizes.spaceBtwSections,)
            ],
          ),
        ),
      ],
    );
  }
}