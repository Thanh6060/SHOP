import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:shop/features/authentication/screens/onboarding/widgets/onboarding_next_button.dart';
import 'package:shop/features/authentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:shop/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:shop/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';
import 'package:shop/utils/constants/images.dart';

import 'package:shop/utils/constants/sizes.dart';
import 'package:shop/utils/constants/texts.dart';



import '../../controllers/onboarding/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(OnBoardingController());
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: USizes.defaultSpace),
        child: Stack(
          children: [
            PageView(
              controller: controller.pageController,
              onPageChanged: controller.updatePageIndicator,
              children: [
                OnboardingPage(animation: UImages.onboarding1Animation,title: UTexts.onBoardingTitle1,subtitle: UTexts.onBoardingSubTitle1,),
                OnboardingPage(animation: UImages.onboarding2Animation,title: UTexts.onBoardingTitle2,subtitle: UTexts.onBoardingSubTitle2),
                OnboardingPage(animation: UImages.onboarding3Animation,title: UTexts.onBoardingTitle3,subtitle: UTexts.onBoardingSubTitle3),
              ],
            ),
        
            OnboardingDotNavigation(),
            
            OnboardingNextButton(),
            
            OnboardingSkipButton()
          ],
        ),
      ),
    );
  }
}










