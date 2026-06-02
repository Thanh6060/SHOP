import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shop/common/styles/padding.dart';
import 'package:shop/common/widgets/appbar/appbar.dart';
import 'package:shop/common/widgets/shimmer/horizontal_product_shimmer.dart';


import 'package:shop/common/widgets/texts/section_heading.dart';
import 'package:shop/features/shop/controllers/category/category_controller.dart';
import 'package:shop/features/shop/models/category_model.dart';
import 'package:shop/features/shop/models/product_model.dart';
import 'package:shop/features/shop/screens/all_products/all_products.dart';

import 'package:shop/utils/constants/sizes.dart';
import 'package:shop/utils/helpers/cloud_helper_functions.dart';




import '../../../../common/widgets/products/product_cards/product_card_horizontal.dart';



class SubCategoryScreen extends StatelessWidget {
  const SubCategoryScreen({super.key,required this.category});
final CategoryModel category;
  @override
  Widget build(BuildContext context) {

    final controller = CategoryController.instance;

    return Scaffold(
      appBar: UAppBar(
        showBackArrow: true,title: Text(category.name,style: Theme.of(context).textTheme.headlineMedium,),),
      body: SingleChildScrollView(
        child: Padding(
            padding: UPadding.screenPadding,
          child: FutureBuilder(
              future: controller.getSubCategories(category.id),
              builder: (context,snapshot){
               const loader = UHorizontalProductShimmer();

                final widget = UCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot,loader: loader);
                if(widget != null) return widget;
                List<CategoryModel> subCategories = snapshot.data!;
               return ListView.builder(
                  shrinkWrap: true,
                  itemCount: subCategories.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){
                    CategoryModel subCategory = subCategories[index];
                  return FutureBuilder(
                      future: controller.getCategoryProducts(categoryId: subCategory.id),
                      builder: (context,snapshot){

                        final widget = UCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot,loader: loader);

                        if(widget != null) return widget;
                        List<ProductModel> products = snapshot.data!;
                         return Column(
                          children: [
                            USectionHeading(
                              title: subCategory.name,
                              onPressed: ()=>Get.to(()=>AllProductsScreen(
                                title: subCategory.name,
                                futureMethod: controller.getCategoryProducts(categoryId: subCategory.id,limit: -1),)),),
                            SizedBox(height: USizes.spaceBtwItems/2,),
                            SizedBox(height: 120,
                                child: ListView.separated(
                                    separatorBuilder: (context,index)=>SizedBox(width: USizes.spaceBtwItems/2,),
                                    itemCount: products.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context,index){
                                      ProductModel product = products[index];
                                      return UProductCardHorizontal(product: product,);
                                    })),

                          ],
                        );
                      }
                  );
                });
              }
          ),
        ),
      ),
    );
  }
}

