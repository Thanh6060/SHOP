import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/custom_shapes/primary_header_container.dart';

import '../../../../../common/widgets/images/user_proflie_logo.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/user_controller.dart';

class UProfilePrimaryHeader extends StatelessWidget {
  const UProfilePrimaryHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
     Get.put(UserController(), permanent: true);
    return Stack(
      children: [
        SizedBox(height: USizes.profilePrimaryHeaderHeight +60,),
        UPrimaryHeaderContainer(
          height: USizes.profilePrimaryHeaderHeight,
          child: Container(),

        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            child: UserProfileLogo(),
          ),
        ),



      ],
    );
  }
}

