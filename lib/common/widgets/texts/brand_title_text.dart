import 'package:flutter/material.dart';
import 'package:shop/utils/constants/enums.dart';

class UBrandTitleText extends StatelessWidget {
  const UBrandTitleText({
    super.key,
    this.color,
    required this.title,
     this.maxLines = 1
    , this.textAlign = TextAlign.center,
    this.branchTextSize = TextSizes.small,
  });
  final Color? color;
  final String title;
  final int maxLines;
  final TextAlign? textAlign;
  final TextSizes branchTextSize;
  @override
  Widget build(BuildContext context) {
    return Text(title,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: branchTextSize == TextSizes.small
          ? Theme.of(context).textTheme.labelMedium!.apply(color: color)
          : branchTextSize == TextSizes.medium
          ? Theme.of(context).textTheme.bodyLarge
          : branchTextSize == TextSizes.large ? Theme.of(context).textTheme.titleLarge
          : Theme.of(context).textTheme.bodyMedium,
    );
  }
}