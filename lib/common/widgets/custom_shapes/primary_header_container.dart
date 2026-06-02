import 'package:flutter/material.dart';
import 'package:shop/common/widgets/custom_shapes/rounded_edges_container.dart';
import 'package:shop/utils/constants/sizes.dart';

import 'circular_container.dart';

import '../../../utils/constants/colors.dart';


class UPrimaryHeaderContainer extends StatelessWidget {
  const UPrimaryHeaderContainer({
    super.key,
    required this.child,
    required this.height,
  });
  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return URoundedEdgesContainer(
      child: Container(
        height: height,
        color: UColors.primary,
        child: Stack(
          children: [
            Positioned(
              top: -150,
              height: -160,
              child: UCircularContainer(
                height:  USizes.homePrimaryHeaderHeight,
                width:  USizes.homePrimaryHeaderHeight,
                backgroundColor: UColors.white.withValues(alpha: 0.1),
              ),
            ),
            Positioned(
              top: 50,
              height: -250,
              child: UCircularContainer(
                height:  USizes.homePrimaryHeaderHeight,
                width:  USizes.homePrimaryHeaderHeight,
                backgroundColor: UColors.white.withValues(alpha: 0.1),
              ),
            ),
            child
          ],
        ),
      ),
    );
  }
}


