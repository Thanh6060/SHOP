import 'package:flutter/material.dart';
import 'package:shop/common/styles/padding.dart';


import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/texts.dart';
import '../../../utils/helpers/device_helpers.dart';
import '../button/elevated_button.dart';


class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.title, required this.subTitle, required this.image, required this.onTap});
  final String title, subTitle, image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,),
      body: SingleChildScrollView(
        child: Padding(
          padding: UPadding.screenPadding,
          child: Column(
            children: [
              Image.asset(image,height: UDeviceHelper.getScreenHeight(context)*0.6,),
              // title
              Text(title,style: Theme.of(context).textTheme.headlineMedium,textAlign: TextAlign.center),
              SizedBox(height: USizes.spaceBtwItems,),
              // subtitle

              Text(subTitle,style: Theme.of(context).textTheme.bodySmall,textAlign: TextAlign.center,),
              // continue
              SizedBox(height: USizes.spaceBtwSections,),

              UElevatedButton(onPressed: onTap, child: Text(UTexts.uContinue)),
            ],
          ),
        ),
      ),
    );
  }
}
