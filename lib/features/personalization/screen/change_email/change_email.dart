import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/common/styles/padding.dart';
import 'package:shop/common/widgets/appbar/appbar.dart';


import '../../../../utils/constants/sizes.dart';

import '../../../../utils/validators/validation.dart';
import '../../controllers/change_name_controller.dart';

class ChangeEmailScreen extends StatelessWidget {
  const ChangeEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(ChangeNameController());

    return Scaffold(
      appBar: UAppBar(
        showBackArrow: true,
        title: Center(
          child: Text(
            "Update Email",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: UPadding.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// [Text] - Heading
              Text(
                'Update your email address to ensure your account security and receive important notifications.',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              SizedBox(height: USizes.spaceBtwSections),

              /// Form
              Form(
                key: controller.updateEmailFormKey,
                child: Column(
                  children: [
                    /// New Email Input
                    TextFormField(
                      controller: controller.email,
                      validator: (value) => UValidator.validateEmail(value),
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'New Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    SizedBox(height: USizes.spaceBtwSections),

                    /// Save Button
                    ElevatedButton(
                      onPressed: () => controller.updateUserEmail(),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ), // Form
            ],
          ),
        ),
      ),
    );
  }
}