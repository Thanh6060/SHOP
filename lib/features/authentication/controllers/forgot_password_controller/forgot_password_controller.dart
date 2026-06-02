import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shop/data/responsibilities/authentication_repo.dart';
import 'package:shop/features/authentication/screens/forgot_password/reset_password.dart';
import 'package:shop/utils/helpers/network_manager.dart';
import 'package:shop/utils/popups/full_screen_loader.dart';
import 'package:shop/utils/popups/snackbar_helpers.dart';

class ForgotPasswordController extends GetxController{
  static ForgotPasswordController get instance => Get.find();
  final email = TextEditingController();
  final forgotPasswordFormKey = GlobalKey<FormState>();
  Future<void> sendPasswordResetEmail()async{
    try {
      UFullScreenLoader.openLoadingDialog("Processing your request>>>>");
      bool isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        UFullScreenLoader.stopLoading();
        USnackBarHelpers.warningSnackBar(title: "No internet connection");
        return;
      }
      if(forgotPasswordFormKey.currentState!.validate()){
        UFullScreenLoader.stopLoading();
        return;
      }
      AuthenticationRepo.instance.sendPasswordResetEmail(email.text.trim());
      UFullScreenLoader.stopLoading();
      USnackBarHelpers.successSnackBar(title: "Email sent",message: "Email sent link to reset your password");
      
      Get.to(()=>ResetPasswordScreen(email: email.text.trim(),));
    }catch(e){
      UFullScreenLoader.stopLoading();
      USnackBarHelpers.errorSnackBar(title: "Failed Forgot Password",message: e.toString());

    }
  }
  Future<void> resendPasswordResetEmail()async{
    try {
      UFullScreenLoader.openLoadingDialog("Processing your request>>>>");
      bool isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        UFullScreenLoader.stopLoading();
        USnackBarHelpers.warningSnackBar(title: "No internet connection");
        return;
      }

      AuthenticationRepo.instance.sendPasswordResetEmail(email.text);
      UFullScreenLoader.stopLoading();
      USnackBarHelpers.successSnackBar(title: "Email sent",message: "Email sent link to reset your password");


    }catch(e){
      UFullScreenLoader.stopLoading();
      USnackBarHelpers.errorSnackBar(title: "Failed Forgot Password",message: e.toString());

    }
  }
}