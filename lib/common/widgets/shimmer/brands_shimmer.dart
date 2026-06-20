




import 'package:flutter/material.dart';
import 'package:shop/common/widgets/shimmer/shimmer_effect.dart';


import '../../../utils/constants/sizes.dart';

class UBrandsShimmer extends StatelessWidget {
  const UBrandsShimmer({super.key,this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 49,
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(width: USizes.spaceBtwItems),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) => UShimmerEffect(width: USizes.brandCardWidth, height: USizes.brandCardHeight),
      ),
    );
  }
}
