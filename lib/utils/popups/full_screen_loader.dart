import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/widgets/loader/animation_loader.dart';

import '../constants/colors.dart';
import '../helpers/helper_function.dart';


class UFullScreenLoader {
  static void openLoadingDialog(String text) {
    showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (_) => PopScope(
            canPop: false,
            child: Container(
              color: UHelperFunctions.isDarkMode(Get.context!) ? UColors.dark : UColors.white,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  /// Extra Space
                  const SizedBox(height: 250),

                  /// Animation
                  UAnimationLoader(text: text)
                ],
              ),
            )));
  }

  static void stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
