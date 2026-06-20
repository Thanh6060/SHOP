import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/common/styles/padding.dart';
import 'package:shop/common/widgets/appbar/appbar.dart';
import 'package:shop/common/widgets/texts/section_heading.dart';
import 'package:shop/features/personalization/controllers/user_controller.dart';
import 'package:shop/features/personalization/screen/change_name/change_name.dart';

import 'package:shop/features/personalization/screen/change_user_id/change_user_id.dart';
import 'package:shop/features/personalization/screen/edit_profile/widgets/user_detail_row.dart';
import 'package:shop/features/personalization/screen/edit_profile/widgets/user_profile_with_edit_icon.dart';
import 'package:shop/utils/constants/sizes.dart';

import '../change_email/change_email.dart';
import '../change_gender/change_gender.dart';
import '../change_phone_number/change_phone_number.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: UAppBar(showBackArrow: true,title: Text("Edit Profile",style: Theme.of(context).textTheme.titleMedium,),),
      body: SingleChildScrollView(
        child: Padding(
            padding: UPadding.screenPadding,
          child: Column(
            children: [
              UserProfileWithEditIcon(),
              SizedBox(height: USizes.spaceBtwSections,),
              Divider(),
              SizedBox(height: USizes.spaceBtwItems),
              USectionHeading(title: "Account Settings", showActionButton: false,),
              SizedBox(height: USizes.spaceBtwItems),

              UserDetailRow(title: "Name", value: controller.user.value.fullName, onTap: ()=>Get.to(()=>ChangeNameScreen())),
              UserDetailRow(title: "UserName", value: controller.user.value.username, onTap: ()=>Get.to(()=>ChangeNameScreen())),
              SizedBox(height: USizes.spaceBtwItems),
              Divider(),
              SizedBox(height: USizes.spaceBtwItems),
              USectionHeading(title: "Profile Settings", showActionButton: false,),
              SizedBox(height: USizes.spaceBtwItems),
              UserDetailRow(title: 'User ID', value: controller.user.value.id, onTap: () => Get.to(()=>ChangeUserIdScreen())),
              UserDetailRow(title: 'Email', value: controller.user.value.email, onTap: () => Get.to(()=>ChangeEmailScreen())),
             UserDetailRow(title: 'Phone Number', value: ' ${controller.user.value.phoneNumber}', onTap: () => Get.to(()=>ChangePhoneNumber())),
              UserDetailRow(title: 'Gender', value: 'Male', onTap: () => Get.to(()=>ChangeGenderScreen())),
              SizedBox(height: USizes.spaceBtwSections),
              Center(
                child: TextButton(
                  onPressed: controller.deleteAccountWarningPopup,
                  child: const Text(
                    'Close Account',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
