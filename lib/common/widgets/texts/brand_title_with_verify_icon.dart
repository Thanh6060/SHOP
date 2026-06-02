import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop/utils/constants/enums.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import 'brand_title_text.dart';

class UBranchTitleWithVerifyIcon extends StatelessWidget {
  const UBranchTitleWithVerifyIcon({
    super.key,
    required this.title,
    this.maxLines =1,
    this.textColor,
    this.iconColor = UColors.primary,
    this.textAlign = TextAlign.center,
   this.branchTextSize =  TextSizes.small,
  });
  final String title;
  final int maxLines;
  final Color? textColor, iconColor;
  final TextAlign? textAlign;
  final TextSizes branchTextSize;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: UBrandTitleText(
            title: title,
            maxLines: maxLines,
            textAlign: textAlign,
            branchTextSize: branchTextSize,
            color: textColor,
          ),
        ),
        SizedBox(width: USizes.xs,),
        Icon(Iconsax.verify5, color: UColors.primary, size: USizes.iconXs,),
      ],
    );
  }
}