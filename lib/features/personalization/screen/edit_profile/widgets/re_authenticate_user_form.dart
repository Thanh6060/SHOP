import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop/common/styles/padding.dart';
import 'package:shop/common/widgets/button/elevated_button.dart';
import 'package:shop/features/personalization/controllers/user_controller.dart';
import 'package:shop/utils/constants/sizes.dart';
import 'package:shop/utils/constants/texts.dart';
import 'package:shop/utils/validators/validation.dart';

import '../../../../../common/widgets/appbar/appbar.dart';

class ReAuthenticateUserForm extends StatelessWidget {
  const ReAuthenticateUserForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: UAppBar(showBackArrow: true,title: Text("Re-Authenticate User"),),
      body: SingleChildScrollView(
        child: Padding(padding: UPadding.screenPadding,
        child: Form(
          key: controller.reAuthFormKey,
            child: Column(
          children: [
            TextFormField(
              controller: controller.email,
              validator: UValidator.validateEmail,
              decoration: InputDecoration(prefixIcon: Icon(Iconsax.direct_right),labelText: UTexts.email),
            ),
            SizedBox(height: USizes.spaceBtwInputFields,),
            Obx(
              ()=> TextFormField(
                controller: controller.password,
                obscureText: controller.isPasswordVisible.value,
                validator: (value)=>UValidator.validateEmptyText("Password",value),
                decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.password_check),
                    labelText: UTexts.password,
                  suffixIcon: IconButton(onPressed: ()=>controller.isPasswordVisible.toggle(), icon: Icon(controller.isPasswordVisible.value ? Iconsax.eye_slash : Iconsax.eye))
                ),
              ),
            ),
            SizedBox(height: USizes.spaceBtwSections,),
            UElevatedButton(onPressed: controller.reAuthenticateUser, child: Text('Verify'))
          ],
        )),),
      ),
    );
  }
}
