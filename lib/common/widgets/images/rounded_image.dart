import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

class URoundedImage extends StatelessWidget {
  const URoundedImage({
    super.key,
    this.width,
    this.height,
    this.applyImageRadius = true,
    this.border,
    this.fit = BoxFit.contain,
    this.padding,
    this.borderRadius = USizes.md,
    this.onTap,
    required this.imageUrl,
    this.isNetworkImage = false,
    this.backgroundColor
  });
  final double? width, height;
  final bool applyImageRadius;
  final BoxBorder? border;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final VoidCallback? onTap;
  final String imageUrl;
  final bool isNetworkImage;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
            borderRadius: applyImageRadius ? BorderRadius.circular(borderRadius) : BorderRadius.zero,
            child: isNetworkImage
                ? CachedNetworkImage(
              imageUrl: imageUrl,
              errorWidget: (context,url,error)=> Icon(Icons.error),
            ) : Image(image: AssetImage(imageUrl),fit: fit,)),
      ),
    );
  }
}