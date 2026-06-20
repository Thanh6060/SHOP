
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop/common/styles/shadow.dart';
import 'package:shop/features/shop/screens/search_store/search_store.dart';
import 'package:shop/utils/helpers/helper_function.dart';
import '../../../utils/constants/colors.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/texts.dart';
import 'mic.dart';

class USearchBar extends StatelessWidget {
 const USearchBar({
    super.key,
   this.searchController,
 });
 final TextEditingController? searchController;


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Mic());
    bool dark = UHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: ()=> Get.to(SearchStoreScreen(),
      arguments: (controller.textSpeech.value == 'Press the button to start speaking' || controller.textSpeech.value == 'Listening...')
          ? ''
          : controller.textSpeech.value
      ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Iconsax.search_normal, color: UColors.darkerGrey,),
              SizedBox(width: USizes.spaceBtwItems,),
              Expanded(
                child: Obx(() {
                  final text = controller.textSpeech.value;
                  final bool isDefaultText = text == 'Press the button to start speaking' || text == 'Listening...' || text.isEmpty;

                  return Text(
                    isDefaultText ? UTexts.searchBarTitle : text,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: dark ? UColors.light : UColors.darkerGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ) ?? TextStyle(color: dark ? Colors.white : Colors.black54, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                }),
              ),
              Obx(()
              => SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: ()=> controller.onListen(),

                    icon: Icon(controller.isListening.value ?  Icons.mic : Icons.mic_none,size: 18,)),
              ),

              )
            ],
          ),
        ),
      ),
    );
  }
}