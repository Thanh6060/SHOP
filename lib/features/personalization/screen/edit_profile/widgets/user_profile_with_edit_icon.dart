import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop/common/widgets/icons/circular_icon.dart';
import 'package:shop/common/widgets/images/user_proflie_logo.dart';
import 'package:shop/features/personalization/controllers/user_controller.dart';

class UserProfileWithEditIcon extends StatelessWidget {
  const UserProfileWithEditIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Stack(
      children: [
        Center(child: UserProfileLogo(),),
        Obx(
    (){
      if (controller.isProfileUploading.value){
        return SizedBox();
    }
      return  Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(child: UCircularIcon(icon: Iconsax.edit,onPressed: controller.updateProfilePicture,),));
    }
        )
      ],
    );
  }
}
