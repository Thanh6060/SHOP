import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/common/styles/padding.dart';
import 'package:shop/common/widgets/appbar/appbar.dart';
import 'package:shop/features/personalization/controllers/change_name_controller.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/validators/validation.dart';

class ChangeUserIdScreen extends StatelessWidget {
  const ChangeUserIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy controller dùng chung
    final controller = Get.put(ChangeNameController());

    return Scaffold(
      appBar: UAppBar(
        showBackArrow: true,
        title: Center(
          child: Text(
            "Change User ID",
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
              /// Heading
              Text(
                'Update your unique User ID. This ID is used to identify your account across the system.',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              SizedBox(height: USizes.spaceBtwSections),

              /// Form nhập ID
              Form(
                key: controller.updateUserFormKey,
                child: Column(
                  children: [
                    /// User ID Input
                    TextFormField(
                      controller: controller.userId, // Sử dụng biến userId có sẵn trong controller
                      validator: (value) => UValidator.validateEmptyText('User ID', value),
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'User ID / Username',
                        prefixIcon: Icon(Icons.tag), // Icon dấu thăng hoặc mã số
                      ),
                    ),
                    SizedBox(height: USizes.spaceBtwSections),

                    /// Button Save
                    ElevatedButton(
                      onPressed: () => controller.updateUserId(), // Gọi hàm update mới sửa ở trên
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