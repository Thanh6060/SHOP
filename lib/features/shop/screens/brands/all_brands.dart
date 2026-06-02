import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/common/styles/padding.dart';
import 'package:shop/common/widgets/appbar/appbar.dart';
import 'package:shop/common/widgets/brands/brand_card.dart';
import 'package:shop/common/widgets/layouts/grid_layouts.dart';
import 'package:shop/common/widgets/texts/section_heading.dart';
import 'package:shop/features/shop/controllers/brand/brand_controller.dart';

import 'package:shop/features/shop/screens/brands/brand_products.dart';
import 'package:shop/utils/constants/sizes.dart';

class BrandScreen extends StatelessWidget {
  const BrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BrandController.instance;
    return Scaffold(
      appBar: UAppBar(
        showBackArrow: true,
        title: Text("Brand",style: Theme.of(context).textTheme.headlineMedium,),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: UPadding.screenPadding,
          child: Column(
            children: [
              USectionHeading(title: "Brand", showActionButton: false,),
              SizedBox(height: USizes.spaceBtwItems,),
              Obx(
                  (){
                    if(controller.isLoading.value){
                      return Center(child: CircularProgressIndicator());
                    }
                    if(controller.featuredBrands.isEmpty){
                      return Text('Brands Not Found');
                    }
                    return UGridLayout(
                      itemCount: controller.allBrands.length,
                      itemBuilder: (context,index){
                        final brand = controller.allBrands[index];
                        return UBrandCard(
                          onTap: ()=>Get.to(()=>BrandProducts(
                            title: brand.name,
                            brand: brand,
                          )),
                          brand: brand,);
                      },
                      mainAxisExtent: 80,
                    );
                  }
              )
            ],
          ),
        ),
      ),
    );
  }
}