

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/common/widgets/shimmer/brands_shimmer.dart';

import 'package:shop/common/widgets/texts/section_heading.dart';
import 'package:shop/features/shop/controllers/brand/brand_controller.dart';
import 'package:shop/features/shop/controllers/category/category_controller.dart';
import 'package:shop/features/shop/models/brand_model.dart';
import 'package:shop/features/shop/screens/brands/all_brands.dart';
import 'package:shop/features/shop/screens/store/widgets/category_tab.dart';
import 'package:shop/features/shop/screens/store/widgets/store_primary_header.dart';


import '../../../../common/widgets/appbar/tabbar.dart';
import '../../../../common/widgets/brands/brand_card.dart';


import '../../../../utils/constants/sizes.dart';
import '../brands/brand_products.dart';

class StoreScreen extends StatelessWidget {

  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
      final controller = CategoryController.instance;
      final brandController = Get.put(BrandController());
    return DefaultTabController(
      length: controller.featuredCategories.length,
      child: Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:(context, innerBOxScrolled){
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: 340,
                  pinned: true,
                  floating: false,
                  flexibleSpace:  SingleChildScrollView(
                    child: Column(
                      children: [
                        UStorePrimaryHeader(),
                        SizedBox(height: USizes.spaceBtwItems,),
                          
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: USizes.defaultSpace),
                          child: Column(
                            children: [
                              USectionHeading(title: "Branch", onPressed: ()=>Get.to(()=>BrandScreen()),),
                          
                              SizedBox(
                                height: USizes.brandCardHeight,
                                child: Obx(
                                    (){
                                      if(brandController.isLoading.value){
                                        return UBrandsShimmer();
                                      }
                                      if(brandController.featuredBrands.isEmpty){
                                        return Text('Brands Not Found');
                                      }
                                      return ListView.separated(
                                          separatorBuilder: (context,index)=> SizedBox(width: USizes.spaceBtwItems,),
                                          shrinkWrap: true,
                                          itemCount: brandController.featuredBrands.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context,index){
                                            BrandModel brand = brandController.featuredBrands[index];
                                            return SizedBox(
                                              width: USizes.brandCardWidth,
                                              child: UBrandCard(brand: brand, onTap: ()=>Get.to(()=>BrandProducts(
                                                title: brand.name,
                                                brand: brand,
                                              )),),);
                                          }

                                      );
                                    }
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  bottom: UTabBar(
                    tabs: controller.featuredCategories.map((category)=>Tab(child: Text(category.name),)).toList()
                  ),
                ),
              ];
            },
            body: TabBarView(
                children: controller.featuredCategories.map((category)=>UCategoryTab(category: category,)).toList()
            ),
        ),
      ),
    );
  }
}








