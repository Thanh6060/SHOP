


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop/common/styles/padding.dart';
import 'package:shop/common/widgets/button/elevated_button.dart';
import 'package:shop/features/authentication/controllers/forgot_password_controller/forgot_password_controller.dart';
import 'package:shop/features/authentication/screens/login/login.dart';
import 'package:get/get.dart';
import 'package:shop/utils/constants/images.dart';
import 'package:shop/utils/constants/sizes.dart';
import 'package:shop/utils/constants/texts.dart';
import 'package:shop/utils/helpers/device_helpers.dart';


class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email});
final String email;
  @override
  Widget build(BuildContext context) {
    final controller = ForgotPasswordController.instance;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyActions: false,
        actions: [
          IconButton(onPressed: ()=>Get.offAll(()=>LoginScreen()), icon: Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: UPadding.screenPadding,
          child: Column(
            children: [
              // image
              Image.asset(UImages.mailSentImage,height: UDeviceHelper.getScreenHeight(context)*0.4,),
              // title
              SizedBox(height: USizes.spaceBtwItems,),
              Text(UTexts.resetPasswordTitle,style: Theme.of(context).textTheme.headlineMedium,),
              // email
              SizedBox(height: USizes.spaceBtwItems,),
              Text(email, style: Theme.of(context).textTheme.bodyMedium,),
              // subtitle
              SizedBox(height: USizes.spaceBtwItems,),
              Text(UTexts.resetPasswordSubTitle,style: Theme.of(context).textTheme.bodySmall,textAlign: TextAlign.center,),
              // done
              SizedBox(height: USizes.spaceBtwItems,),
              UElevatedButton(onPressed: ()=>Get.offAll(()=>LoginScreen()), child: Text(UTexts.done)),
              // resend email
              SizedBox(
                width: double.infinity,
                  child: TextButton(onPressed: controller.resendPasswordResetEmail, child: Text(UTexts.resendEmail))),
          
            ],
          ),
        ),
      ),
    );
  }
}
