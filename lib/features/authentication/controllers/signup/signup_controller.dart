import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shop/data/responsibilities/authentication_repo.dart';
import 'package:shop/data/responsibilities/user/user_repo.dart';
import 'package:shop/features/authentication/model/user_model.dart';
import 'package:shop/features/authentication/screens/signup/verify_email.dart';
import 'package:shop/utils/helpers/network_manager.dart';
import 'package:shop/utils/popups/snackbar_helpers.dart';

import '../../../../utils/popups/full_screen_loader.dart';

class SignupController extends GetxController{
  static SignupController get instance => Get.find();
  final signUpFormKey = GlobalKey<FormState>();
  RxBool isPasswordVisible = false.obs;
  RxBool privacyPolicy = false.obs;
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();

  Future<void> registerUser() async {
    try{
      // form validate
      if(!signUpFormKey.currentState!.validate()) {
        return;
      }
      // privacy policy
      if(!privacyPolicy.value){
        UFullScreenLoader.stopLoading();
        USnackBarHelpers.warningSnackBar(title: "Accept Privacy Policy",message: "In order to create account, you must have to read and accept the Privacy Policy & Terms of Use. ");
        return;
      }
      // start loading
      UFullScreenLoader.openLoadingDialog("We are processing your information...");
      // check internet connect
      bool isConnect = await NetworkManager.instance.isConnected();
      if(!isConnect){
        UFullScreenLoader.stopLoading();
        USnackBarHelpers.warningSnackBar(title: "No Internet", message: "Please check your connection.");
        return;

      }



      // register user
    UserCredential userCredential = await AuthenticationRepo.instance.registerUser(email.text.trim(),password.text.trim());
    UserModel userModel = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text,
        lastName: lastName.text,
        username: '${firstName.text}${lastName.text}716283',
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: "");
    final userRepository = Get.put(UserRepo());
    await userRepository.saveUserRecord(userModel);

    USnackBarHelpers.successSnackBar(title: "Congratulation", message: "Your account has been created! Verify email to continue");
    UFullScreenLoader.stopLoading();
    // redirect to verify email
      Get.to(()=>VerifyEmailScreen(email: email.text,));
    }catch(e){
      UFullScreenLoader.stopLoading();
        USnackBarHelpers.errorSnackBar(title: "Error",message: e.toString());
    }
  }
}