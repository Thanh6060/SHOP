import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shop/common/styles/padding.dart';

import 'package:shop/common/widgets/button/social_buttons.dart';
import 'package:shop/common/widgets/login_signup/form_divider.dart';
import 'package:shop/features/authentication/controllers/signup/signup_controller.dart';
import 'package:shop/features/authentication/screens/signup/widgets/signup_form.dart';

import 'package:shop/utils/constants/sizes.dart';

import '../../../../utils/constants/texts.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SignupController());
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
            padding: UPadding.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //header
              Text(UTexts.signupTitle,style: Theme.of(context).textTheme.headlineMedium,),
              SizedBox(height: USizes.spaceBtwSections,),
              // form
              USignupForm(),
              SizedBox(height: USizes.spaceBtwSections,),
              // divider
              UFormDivider(title: UTexts.orSignInWith),
              SizedBox(height: USizes.spaceBtwSections,),
              // footer
              USocialButtons()
            ],
          ),

        ),
      ),
    );
  }
}


