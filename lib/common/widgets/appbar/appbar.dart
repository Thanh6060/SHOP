import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/device_helpers.dart';
import '../../../utils/helpers/helper_function.dart';
import 'package:get/get.dart';

class UAppBar extends StatelessWidget implements PreferredSizeWidget{
  const UAppBar({super.key,
    this.title,
    this.showBackArrow = false,
    this.leadingIcon, this.action,
    this.leadingOnPressed});
  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? action;
  final  VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
    bool dark = UHelperFunctions.isDarkMode(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: USizes.md),
      child: AppBar(
        automaticallyImplyLeading: false,
        // leading

        leading: showBackArrow ?
        IconButton(onPressed: ()=>Get.back(), icon: Icon(Iconsax.arrow_left, color: dark ? UColors.white : UColors.dark,)) :
        leadingIcon != null
            ? IconButton(onPressed: leadingOnPressed, icon: Icon(leadingIcon))
            : null,
        title: title,
        actions: action,
      ),
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(UDeviceHelper.getAppBarHeight());

}