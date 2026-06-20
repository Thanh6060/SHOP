import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shop/common/widgets/appbar/appbar.dart';

import '../../../../common/styles/padding.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/texts.dart';
import '../../../../utils/validators/validation.dart';
import '../../controllers/change_name_controller.dart';


class ChangePhoneNumber extends StatelessWidget {
  const ChangePhoneNumber({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangeNameController());
    return Scaffold(
      appBar: UAppBar(title: Text("Change Phone Number",style: Theme.of(context).textTheme.titleMedium,),showBackArrow: true,),
      body: SingleChildScrollView(
        child: Padding(
          padding: UPadding.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// [Text] - Heading
              Text(
                'Update your phone name to keep your profile accurate and personalized',
                style: Theme.of(context).textTheme.labelMedium,
              ), // Text
              SizedBox(height: USizes.spaceBtwSections),

              /// Form
              Form(
                key: controller.updateUserFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.phoneNumber,
                      validator: (value) => UValidator.validateEmptyText('Phone Number', value),
                      decoration: InputDecoration(
                        labelText: UTexts.phoneNumber,
                        prefixIcon: const Icon(Icons.phone),
                      ),
                    ), // TextFormField
                    SizedBox(height: USizes.spaceBtwInputFields),
                    ElevatedButton(
                      onPressed: controller.updateUserName, // Thêm logic lưu tại đây
                      child: const Text('Save'),
                    ),



                    /// Save Button

                  ],
                ),
              ),
              // Form
            ],
          ),
        ),
      ),
    );
  }
}
