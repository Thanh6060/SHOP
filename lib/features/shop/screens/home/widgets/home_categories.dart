import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/common/widgets/shimmer/category_shimmer.dart';
import 'package:shop/features/shop/controllers/category/category_controller.dart';
import 'package:shop/features/shop/models/category_model.dart';
import 'package:shop/features/shop/screens/sub_category/sub_category.dart';



import '../../../../../common/widgets/image_text/vertical_image_text.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/texts.dart';

class UHomeCategories extends StatelessWidget {
  const UHomeCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    return Padding(
      padding: const EdgeInsets.only(left: USizes.spaceBtwSections),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(UTexts.popularCategories,
            style: Theme.of(context).textTheme.headlineSmall!.apply(color: UColors.white),),
          SizedBox(height: USizes.spaceBtwItems,),
          Obx(
              (){
                final categories = controller.featuredCategories;
                if(controller.isCategoriesLoading.value){
                  return UCategoryShimmer(itemCount: 6,);
                }
                if(categories.isEmpty){
                  return Text('Categories Not Found');
                }
                return SizedBox(
                  height: 82,
                  child: ListView.separated(
                    separatorBuilder: (context,index)=> SizedBox(width: USizes.spaceBtwItems,),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context,index){
                      CategoryModel category = categories[index];
                      return UVerticalImageText(
                        title: category.name,
                        image: category.image,
                        textColor: UColors.white,
                        onTap: ()=>Get.to(()=>SubCategoryScreen(category:category)),
                      );
                    },
                  ),
                );
              }
          ),
        ],
      ),
    );
  }
}

