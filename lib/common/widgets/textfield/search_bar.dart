import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop/common/styles/shadow.dart';
import 'package:shop/features/shop/screens/search_store/search_store.dart';
import 'package:shop/utils/helpers/helper_function.dart';
import '../../../utils/constants/colors.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/texts.dart';

class USearchBar extends StatelessWidget {
  const USearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    bool dark = UHelperFunctions.isDarkMode(context);
    return Positioned(
      bottom: 0,
      right: USizes.spaceBtwSections,
      left: USizes.spaceBtwSections,
      child: GestureDetector(
        onTap: ()=> Get.to(SearchStoreScreen()),
        child: Hero(
          tag: 'search_animation',
          child: Container(
            height: USizes.searchBarHeight,
            padding: EdgeInsets.symmetric(horizontal: USizes.md),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(USizes.borderRadiusLg),
                color: dark ? UColors.dark : UColors.light,

                boxShadow: UShadow.searchBarShadow,
            ),
            child: Row(
              children: [
                Icon(Iconsax.search_normal, color: UColors.darkerGrey,),
                SizedBox(width: USizes.spaceBtwItems,),
                Text(UTexts.searchBarTitle, style: Theme.of(context).textTheme.bodySmall,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}