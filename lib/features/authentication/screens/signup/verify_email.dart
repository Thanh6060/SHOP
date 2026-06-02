
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop/common/styles/padding.dart';
import 'package:shop/common/widgets/button/elevated_button.dart';

import 'package:shop/data/responsibilities/authentication_repo.dart';
import 'package:shop/features/authentication/controllers/signup/verify_email_controller.dart';

import 'package:get/get.dart';
import 'package:shop/utils/constants/images.dart';
import 'package:shop/utils/constants/sizes.dart';
import 'package:shop/utils/constants/texts.dart';
import 'package:shop/utils/helpers/device_helpers.dart';


class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, this.email});
  final String? email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyActions: false,
        actions: [
          IconButton(onPressed: AuthenticationRepo.instance.logout, icon: Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: UPadding.screenPadding,
          child: Column(
            children: [
              // image
              Image.asset(UImages.mailSentImage,height: UDeviceHelper.getScreenHeight(context)*0.6,),
              // title
              SizedBox(height: USizes.spaceBtwItems,),
              Text(UTexts.verifyEmailTitle,style: Theme.of(context).textTheme.headlineMedium,),
              // email
              SizedBox(height: USizes.spaceBtwItems,),
              Text(email ?? '', style: Theme.of(context).textTheme.bodyMedium,),
              // subtitle
              SizedBox(height: USizes.spaceBtwItems,),
              Text(UTexts.verifyEmailSubTitle,style: Theme.of(context).textTheme.bodySmall,textAlign: TextAlign.center,),
              // continue
              SizedBox(height: USizes.spaceBtwItems,),
              UElevatedButton(
                  onPressed: controller.checkEmailVerificationStatus,
                  child: Text(UTexts.uContinue)),
              // resend email
              SizedBox(
                  width: double.infinity,
                  child: TextButton(onPressed: controller.sendEmailVerification, child: Text(UTexts.resendEmail))),

            ],
          ),
        ),
      ),
    );
  }
}
