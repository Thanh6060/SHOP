import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop/features/personalization/controllers/user_controller.dart';


import '../../edit_profile/edit_profile_screen.dart';

class UserProfileTitle extends StatelessWidget {
  const UserProfileTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Obx(()=> Text(controller.user.value.fullName,style: Theme.of(context).textTheme.headlineSmall,)),
      subtitle: Obx(()=> Text(controller.user.value.email,style: Theme.of(context).textTheme.bodyMedium)),
      trailing: IconButton(onPressed: ()=>Get.to(()=>EditProfileScreen()), icon: Icon(Iconsax.edit)),
    );
  }
}