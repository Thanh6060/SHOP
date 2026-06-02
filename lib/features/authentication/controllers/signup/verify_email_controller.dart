import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shop/common/widgets/screen/success_screen.dart';
import 'package:shop/data/responsibilities/authentication_repo.dart';
import 'package:shop/utils/popups/snackbar_helpers.dart';

import '../../../../utils/constants/images.dart';
import '../../../../utils/constants/texts.dart';

class VerifyEmailController extends GetxController{
  static VerifyEmailController get instance => Get.find();
  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }
  Future<void> sendEmailVerification() async{
    try {

      // await AuthenticationRepo.instance.sendEmailVerification();
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.sendEmailVerification();
        USnackBarHelpers.successSnackBar(
            title: 'Email sent',
            message: 'Please check your inbox and verify your email'
        );
      } else {

        USnackBarHelpers.errorSnackBar(
            title: 'Error',
            message: 'User session not found. Please Login again.'
        );
      }
     USnackBarHelpers.successSnackBar(title: 'Email sent',message: 'Please check your inbox and verify your email');
    }catch(e){
      USnackBarHelpers.errorSnackBar(title: 'Error',message: e.toString());
    }
  }
  // time verify email
  void setTimerForAutoRedirect(){
    Timer.periodic(Duration(seconds: 1), (timer) async{
     await FirebaseAuth.instance.currentUser!.reload();
     final user = FirebaseAuth.instance.currentUser;
     if(user?.emailVerified ?? false){
       timer.cancel();
       Get.off(()=>SuccessScreen(
           title: UTexts.accountCreatedTitle,
           subTitle: UTexts.accountCreatedSubTitle,
           image: UImages.successfulPaymentIcon,
           onTap: ()=> AuthenticationRepo.instance.screenRedirect(),
       ));
     }
    });
  }

  Future<void> checkEmailVerificationStatus()async{
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if(currentUser != null && currentUser.emailVerified){
        Get.off(()=>SuccessScreen(
          title: UTexts.accountCreatedTitle,
          subTitle: UTexts.accountCreatedSubTitle,
          image: UImages.successfulPaymentIcon,
          onTap: ()=> AuthenticationRepo.instance.screenRedirect(),
        ));
      }

    }catch(e){
        USnackBarHelpers.errorSnackBar(title: "ERROR",message: e.toString());
    }
  }
}