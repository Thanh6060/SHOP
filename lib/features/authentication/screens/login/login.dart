import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/common/styles/padding.dart';
import 'package:shop/features/authentication/controllers/login/login_controller.dart';

import 'package:shop/features/authentication/screens/login/widgets/login_form.dart';
import 'package:shop/features/authentication/screens/login/widgets/login_header.dart';

import 'package:shop/utils/constants/sizes.dart';


import '../../../../common/widgets/button/social_buttons.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../utils/constants/texts.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: UPadding.screenPadding,
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
        
              ULoginHeader(),
              SizedBox(height: USizes.spaceBtwSections,),
        
              ULoginForm(),
              SizedBox(height: USizes.spaceBtwSections,),
        
              UFormDivider(title: UTexts.orSignInWith,),
              SizedBox(height: USizes.spaceBtwSections,),
        
              USocialButtons()
            ],
          ),
        
        
        ),
      ),
    );
  }
}








