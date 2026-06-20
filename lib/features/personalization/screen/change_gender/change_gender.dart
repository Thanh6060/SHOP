import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/common/styles/padding.dart';
import 'package:shop/common/widgets/appbar/appbar.dart';
import 'package:shop/features/personalization/controllers/change_name_controller.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/validators/validation.dart';

class ChangeGenderScreen extends StatelessWidget {
  const ChangeGenderScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(ChangeNameController());


    final genderOptions = ['Male', 'Female', 'Other'];


    if (controller.gender.text.isEmpty || !genderOptions.contains(controller.gender.text)) {
      controller.gender.text = 'Male';
    }

    return Scaffold(
      appBar: UAppBar(
        showBackArrow: true,
        title: Center(
          child: Text(
            "Update Gender",
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

              Text(
                'Select your gender to personalize your experience and profile accurate.',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              SizedBox(height: USizes.spaceBtwSections),


              Form(
                key: controller.updateUserFormKey,
                child: Column(
                  children: [

                    DropdownButtonFormField<String>(
                      value: controller.gender.text,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        prefixIcon: Icon(Icons.people_outline),
                      ),
                      items: genderOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          controller.gender.text = newValue;
                        }
                      },
                      validator: (value) => UValidator.validateEmptyText('Gender', value),
                    ),
                    SizedBox(height: USizes.spaceBtwSections),


                    ElevatedButton(
                      onPressed: () => controller.updateUserGender(),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}