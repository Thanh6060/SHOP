import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/common/styles/padding.dart';
import 'package:shop/common/widgets/appbar/appbar.dart';
import 'package:shop/features/personalization/controllers/change_name_controller.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/texts.dart';
import '../../../../utils/validators/validation.dart';

class ChangeNameScreen extends StatelessWidget {
  const ChangeNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangeNameController());
    return Scaffold(
      appBar: UAppBar(showBackArrow: true,
      title: Center(
        child: Text("Update Name",style: Theme.of(context).textTheme.titleMedium,
        ),
      ),),
      body: SingleChildScrollView(
        child: Padding(
          padding: UPadding.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// [Text] - Heading
              Text(
                'Update your name to keep your profile accurate and personalized',
                style: Theme.of(context).textTheme.labelMedium,
              ), // Text
              SizedBox(height: USizes.spaceBtwSections),

              /// Form
              Form(
                key: controller.updateUserFormKey,
                child: Column(
                  children: [
                    /// First Name
                    TextFormField(
                      controller: controller.firstname,
                      validator: (value) => UValidator.validateEmptyText('First Name', value),
                      decoration: InputDecoration(
                        labelText: UTexts.firstName,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                    ), // TextFormField
                    SizedBox(height: USizes.spaceBtwInputFields),

                    /// Last Name
                    TextFormField(
                      controller: controller.lastname,
                      validator: (value) => UValidator.validateEmptyText('Last Name', value),
                      decoration: InputDecoration(
                        labelText: UTexts.lastName,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                    ), // TextFormField
                    SizedBox(height: USizes.spaceBtwSections),

                    /// Save Button
                    ElevatedButton(
                      onPressed: controller.updateUserName, // Thêm logic lưu tại đây
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
