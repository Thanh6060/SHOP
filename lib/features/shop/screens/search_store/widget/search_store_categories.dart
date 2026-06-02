import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/features/shop/controllers/category/category_controller.dart';
import 'package:shop/features/shop/models/category_model.dart';
import 'package:shop/features/shop/screens/all_products/all_products.dart';

import '../../../../../common/widgets/images/rounded_image.dart';
import '../../../../../common/widgets/texts/section_heading.dart';

import '../../../../../utils/constants/sizes.dart';

class SearchStoreCategories extends StatelessWidget {
  const SearchStoreCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;
    return Obx((){
      if(controller.isCategoriesLoading.value) return Center(child: CircularProgressIndicator(),);
      if(controller.allCategories.isEmpty) return Text('No Categories Found!');
      List<CategoryModel> categories = controller.allCategories;
      return Column(
        children: [
          USectionHeading(title: 'Categories',showActionButton: false,),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (context,index){
                CategoryModel category = categories[index];
                return ListTile(
                  onTap: ()=>Get.to(()=> AllProductsScreen(
                    title: category.name,
                    futureMethod: controller.getCategoryProducts(
                        categoryId: category.id
                    ),)),
                  contentPadding: EdgeInsets.zero,
                  leading: URoundedImage(imageUrl: category.image, borderRadius: 0,width: USizes.iconLg,height: USizes.iconLg,isNetworkImage: true,),
                  title: Text(category.name),
                );
              }
          )
        ],
      );
    });
  }
}
