import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop/features/authentication/controllers/login/login_controller.dart';
import 'package:shop/features/authentication/screens/forgot_password/forgot_password.dart';

import 'package:shop/utils/validators/validation.dart';

import '../../../../../common/widgets/button/elevated_button.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/texts.dart';
import '../../signup/signup.dart';
class ULoginForm extends StatelessWidget {
  const ULoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = LoginController.instance;
    return Form(
      key: controller.loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller.email,
            validator: (value)=>UValidator.validateEmail(value),
            decoration: InputDecoration(prefixIcon: Icon(Iconsax.direct_right), labelText: UTexts.email),
          ),
          SizedBox(height: USizes.spaceBtwInputFields,),

          Obx(
            ()=> TextFormField(
              controller: controller.password,
              validator: (value)=>UValidator.validateEmptyText("Password",value),
              obscureText: controller.isPasswordVisible.value,
              decoration: InputDecoration(
                  prefixIcon: Icon(Iconsax.password_check),
                  labelText: UTexts.password,
                  suffixIcon: IconButton(
                    onPressed: ()=>controller.isPasswordVisible.toggle(),
                    icon: Icon(controller.isPasswordVisible.value ? Iconsax.eye_slash : Iconsax.eye),),
              ),
            ),
          ),
          SizedBox(height: USizes.spaceBtwInputFields/2,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Obx(()=> Checkbox(value: controller.rememberMe.value, onChanged: (value)=>controller.rememberMe.toggle())),
                  Text(UTexts.rememberMe)
                ],
              ),
              // forgot password
              TextButton(
                  onPressed: ()=> Get.to(()=>ForgotPasswordScreen()),
                  child: Text(UTexts.forgetPassword))
            ],

          ),
          SizedBox(height: USizes.spaceBtwSections,),
          // sign up

          UElevatedButton(onPressed: controller.loginWithEmailAndPassword, child: Text(UTexts.signIn)),
          SizedBox(height: USizes.spaceBtwItems/2,),

          SizedBox(
            width: double.infinity,
              child: OutlinedButton(onPressed: ()=>Get.to(()=>SignupScreen()), child: Text(UTexts.createAccount))),


        ],
      ),
    );
  }
}