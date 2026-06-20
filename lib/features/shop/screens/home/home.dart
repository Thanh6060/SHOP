
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/features/shop/controllers/product/product_controller.dart';
import 'package:shop/features/shop/models/product_model.dart';




import 'package:shop/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:shop/features/shop/screens/home/widgets/home_categories.dart';
import 'package:shop/common/widgets/custom_shapes/primary_header_container.dart';
import 'package:shop/features/shop/screens/home/widgets/promo_slider.dart';



import 'package:shop/utils/constants/sizes.dart';


import '../../../../common/widgets/layouts/grid_layouts.dart';
import '../../../../common/widgets/products/product_cards/product_card_vertical.dart';
import '../../../../common/widgets/textfield/search_bar.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../controllers/home/home_controller.dart';
import '../all_products/all_products.dart';






class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductController());
     Get.put(HomeController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // upper part
            Stack(
              children: [
                SizedBox(height: USizes.homePrimaryHeaderHeight + 10,),
                UPrimaryHeaderContainer(
                  height: USizes.homePrimaryHeaderHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UHomeAppBar(),
                      SizedBox(height: USizes.spaceBtwSections,),
                      UHomeCategories(),
                    ],
                  ),
                ),
        
                Positioned(
                    bottom: 0,
                    left: USizes.defaultSpace,
                    right: USizes.defaultSpace,
                    child: USearchBar()),
        
              ],
            ),
            SizedBox(height: USizes.defaultSpace,),
            // lower part
            Padding(
              padding: const EdgeInsets.all(USizes.defaultSpace),
              child: Column(
                children: [
                  UPromoSlider(),
                  const SizedBox(height: USizes.spaceBtwSections,),
        
                  USectionHeading(title: "Popular Products", onPressed: ()=>Get.to(()=>AllProductsScreen(
                    title: 'Popular Products',
                    futureMethod: productController.getAllFeaturedProduct(),
                  )),),
        
                  const SizedBox(height: USizes.spaceBtwSections,),
        
                  Obx((){
                    if(productController.isLoading.value){
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    if(productController.featuredProducts.isEmpty){
                      return Center(child: Text('Products Not Found'),);
                    }
                  return UGridLayout(
                      itemCount: productController.featuredProducts.length,
                      itemBuilder: (context,index){
                        ProductModel product = productController.featuredProducts[index];
                        return UProductCardVertical(product: product,);
                      },
                    );
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}























