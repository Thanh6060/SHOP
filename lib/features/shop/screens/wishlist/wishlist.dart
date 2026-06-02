import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:iconsax/iconsax.dart';
import 'package:shop/common/widgets/icons/circular_icon.dart';
import 'package:shop/common/widgets/layouts/grid_layouts.dart';
import 'package:shop/common/widgets/loader/animation_loader.dart';
import 'package:shop/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:shop/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:shop/features/shop/controllers/product/favourite_controller.dart';

import 'package:shop/navigation_menu.dart';
import 'package:shop/utils/constants/images.dart';
import 'package:shop/utils/helpers/cloud_helper_functions.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';
import '../../models/product_model.dart';


class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: UAppBar(
        title: Text("WishList", style: Theme.of(context).textTheme.headlineMedium,),
        action: [
          UCircularIcon(
            icon: Iconsax.add,
            onPressed: ()=> NavigationController.instance.selectedIndex.value = 0,)
        ],
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(USizes.defaultSpace),
          child: Obx(
              ()=> FutureBuilder(
                future: FavouriteController.instance.getFavouriteProducts() ,
                builder: (context,snapshot){
                  final nothingFound = UAnimationLoader(
                      text: 'WishList is empty....',
                    animation: UImages.pencilAnimation,
                    showActionButton: true,
                    actionText: 'Let"s add some thing ',
                    onActionPressed: ()=>NavigationController.instance.selectedIndex.value = 0 ,
                  );
                  final loader =UVerticalProductShimmer(itemCount: 6,);
                  final widget = UCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot,loader: loader,nothingFound: nothingFound);
                  if(widget != null) return widget;
                  List<ProductModel> products = snapshot.data!;
                 return UGridLayout(
                    itemCount: products.length,
                    itemBuilder: (context,index)=>
                        UProductCardVertical
                          (product: products[index]),
                  );
                }
            ),
          ),
        ),
      ),
    );
  }
}
