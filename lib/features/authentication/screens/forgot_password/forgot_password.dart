import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop/common/styles/padding.dart';
import 'package:shop/common/widgets/button/elevated_button.dart';
import 'package:shop/features/authentication/controllers/forgot_password_controller/forgot_password_controller.dart';

import 'package:shop/utils/constants/sizes.dart';
import 'package:shop/utils/constants/texts.dart';
import 'package:get/get.dart';
import 'package:shop/utils/validators/validation.dart';
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: UPadding.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title
              Text(UTexts.forgetPasswordTitle,style: Theme.of(context).textTheme.headlineMedium,),
              // subtitle
              SizedBox(height: USizes.spaceBtwItems/2,),
              Text(UTexts.forgetPasswordSubTitle,style: Theme.of(context).textTheme.labelMedium,),
              SizedBox(height: USizes.spaceBtwSections*2,),
              // form
              Column(
                children: [
                  Form(
                    key: controller.forgotPasswordFormKey,
                    child: TextFormField(
                      controller: controller.email,
                      validator: (value)=>UValidator.validateEmail(value),
                      decoration: InputDecoration(
                        labelText: UTexts.email,
                        prefixIcon: Icon(Iconsax.direct_right),
                      ),
                    ),
                  ),
                  SizedBox(height: USizes.spaceBtwItems,),
                  UElevatedButton(onPressed: controller.sendPasswordResetEmail, child: Text(UTexts.submit))
                ],
              )

        
            ],
          ),
        ),
      ),
    );
  }
}
