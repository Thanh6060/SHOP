import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop/features/authentication/controllers/signup/signup_controller.dart';

import 'package:shop/features/authentication/screens/signup/widgets/privacy_policy_checkbox.dart';
import 'package:shop/utils/validators/validation.dart';

import '../../../../../common/widgets/button/elevated_button.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/texts.dart';

class USignupForm extends StatelessWidget {
  const USignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    return Form(
      key: controller.signUpFormKey,
      child: Column(
        children: [
          // first & last name
          Row(
            children: [
              // first name
              Expanded(
                  child: TextFormField(
                    controller: controller.firstName,
                    validator: (value)=>UValidator.validateEmptyText("First Name", value),
                decoration: InputDecoration(
                    labelText: UTexts.firstName,
                    prefixIcon: Icon(Iconsax.user)
                ),
              )),
              SizedBox(width: USizes.spaceBtwInputFields,),
              // last name
              Expanded(child: TextFormField(
                controller: controller.lastName,
                validator: (value)=>UValidator.validateEmptyText("Last Name", value),
                decoration: InputDecoration(
                    labelText: UTexts.lastName,
                    prefixIcon: Icon(Iconsax.user)
                ),)),
            ],
          ),
          // email
          SizedBox(height: USizes.spaceBtwInputFields,),
      // mail
          TextFormField(
            controller: controller.email,
            validator: (value)=>UValidator.validateEmail(value),
            decoration: InputDecoration(
              labelText: UTexts.email,
              prefixIcon: Icon(Iconsax.direct_right),
            ),
          ),
          // phone
          SizedBox(height: USizes.spaceBtwInputFields,),
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value)=>UValidator.validatePhoneNumber(value),
            decoration: InputDecoration(
              labelText: UTexts.phoneNumber,
              prefixIcon: CountryCodePicker(
                initialSelection: 'VN',
                favorite: const ['VN', '+84', 'US',],
                showDropDownButton: true,
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                alignLeft: false,
                onChanged: (country) {
                  controller.countryCode =
                      country.dialCode ?? "+84";
                },
              ),
            ),
          ),
          SizedBox(height: USizes.spaceBtwInputFields,),
          // password
          Obx(
    ()=> TextFormField(
      obscureText: !controller.isPasswordVisible.value,
              controller: controller.password,
              validator: (value)=>UValidator.validatePassword(value),
              decoration: InputDecoration(
                  prefixIcon: Icon(Iconsax.password_check),
                  labelText: UTexts.password,
                  suffixIcon: IconButton(onPressed: () => controller.isPasswordVisible.value = !controller.isPasswordVisible.value, icon: Icon(controller.isPasswordVisible.value ? Iconsax.eye_slash : Iconsax.eye)),
              ),
            ),
          ),
          SizedBox(height: USizes.spaceBtwInputFields/2,),
          // privacy policy
          UPrivacyPolicyCheckbox(),
          SizedBox(height: USizes.spaceBtwItems,),
          UElevatedButton(onPressed: controller.registerUser, child: Text(UTexts.createAccount))
        ],
      ),
    );
  }
}

