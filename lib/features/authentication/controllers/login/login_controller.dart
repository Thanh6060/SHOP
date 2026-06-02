import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shop/data/responsibilities/authentication_repo.dart';
import 'package:shop/features/personalization/controllers/user_controller.dart';
import 'package:shop/utils/constants/keys.dart';
import 'package:shop/utils/helpers/network_manager.dart';
import 'package:shop/utils/popups/full_screen_loader.dart';
import 'package:shop/utils/popups/snackbar_helpers.dart';

class LoginController extends GetxController{
  static LoginController get instance => Get.find();
  final email = TextEditingController();

  final password = TextEditingController();
  RxBool isPasswordVisible = false.obs;
  RxBool rememberMe = false.obs;
  final loginFormKey = GlobalKey<FormState>();
  final localStorage = GetStorage();
  @override
  void onInit() {
    email.text = localStorage.read(UKeys.rememberMeEmail) ?? '';
    password.text = localStorage.read(UKeys.rememberMePassword) ?? '';
    super.onInit();
  }

  Future<void> loginWithEmailAndPassword() async {
    try{
      UFullScreenLoader.openLoadingDialog("Logging you in >>>>");
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        UFullScreenLoader.stopLoading();
        USnackBarHelpers.warningSnackBar(title: "No Internet Connection");
        return;
      }
      // form
      if(loginFormKey.currentState!.validate()){
        UFullScreenLoader.stopLoading();
        return;
      }
      // save data if
      if(rememberMe.value){
          localStorage.write(UKeys.rememberMeEmail, email.text.trim());
          localStorage.write(UKeys.rememberMePassword, password.text.trim());
      }
      // login
      await AuthenticationRepo.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());
      UFullScreenLoader.stopLoading();
      AuthenticationRepo.instance.screenRedirect();
    }catch(e){
      UFullScreenLoader.stopLoading();
      USnackBarHelpers.errorSnackBar(title: "Login Failed",message: e.toString());

    }
  }

  Future<void> googleSignIn() async {
    try{
      // start
      UFullScreenLoader.openLoadingDialog("Logging in .... ");
      // check internet
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        UFullScreenLoader.stopLoading();
        USnackBarHelpers.warningSnackBar(title: "No internet connection");
        return;
      }

      // google auth
     UserCredential userCredential = await AuthenticationRepo.instance.signInWithGoogle();

      // save user
     await Get.put(UserController()).saveUserRecord(userCredential);

      // stop
      UFullScreenLoader.stopLoading();
      // redirect
      AuthenticationRepo.instance.screenRedirect();

    }catch(e){
        UFullScreenLoader.stopLoading();
        USnackBarHelpers.errorSnackBar(title: "Error", message: e.toString());
    }
  }

  Future<void> facebookSignIn() async{
    try{
      UFullScreenLoader.openLoadingDialog("Logging in .... ");
      // check internet
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected) {
        UFullScreenLoader.stopLoading();
        USnackBarHelpers.warningSnackBar(title: "No internet connection");
        return;
      }
      UserCredential userCredential = await AuthenticationRepo.instance.signInWithFacebook();

      // save user
      await Get.put(UserController()).saveUserRecord(userCredential);

      // stop
      UFullScreenLoader.stopLoading();
      // redirect
      AuthenticationRepo.instance.screenRedirect();


    }catch(e){
      UFullScreenLoader.stopLoading();
      USnackBarHelpers.errorSnackBar(title: "Error", message: e.toString());

    }
  }
}