import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shop/data/responsibilities/authentication_repo.dart';
import 'package:shop/data/responsibilities/user/user_repo.dart';
import 'package:shop/features/authentication/model/user_model.dart';
import 'package:shop/features/authentication/screens/login/login.dart';
import 'package:shop/features/personalization/screen/edit_profile/widgets/re_authenticate_user_form.dart';

import 'package:shop/utils/constants/sizes.dart';
import 'package:shop/utils/helpers/network_manager.dart';
import 'package:shop/utils/popups/full_screen_loader.dart';
import 'package:shop/utils/popups/snackbar_helpers.dart';
import 'package:dio/dio.dart' as dio;

class UserController extends GetxController{
  static UserController get instance => Get.find();
  final _userRepo = Get.put(UserRepo());
  Rx<UserModel> user =  UserModel.empty().obs;
  RxBool profileLeading = false.obs;
  RxBool isProfileUploading = false.obs;
  final  email = TextEditingController();
  final password = TextEditingController();
  final reAuthFormKey = GlobalKey<FormState>();
  RxBool isPasswordVisible = false.obs;


  @override
  void onInit() {
    fetchUserDetails();
    super.onInit();
  }


  Future<void> saveUserRecord(UserCredential userCredential) async{
    try{
    await  fetchUserDetails();
    if(user.value.id.isEmpty){
      final nameParts = UserModel.nameParts(userCredential.user!.displayName);
      final username = '${userCredential.user!.displayName}2312637 ';
      UserModel userModel = UserModel(
          id: userCredential.user!.uid,
          firstName: nameParts[0],
          lastName: nameParts.length > 1 ? nameParts.sublist(1).join(" ") : '',
          username: username,
          email: userCredential.user!.email ?? '',
          phoneNumber:userCredential.user!.phoneNumber ?? '',
          profilePicture: userCredential.user!.photoURL ?? ''
      );
      await _userRepo.saveUserRecord(userModel);

    }


    }catch(e){
    USnackBarHelpers.warningSnackBar(title: "Data not saved", message: "Something went wrong while saving");
    }
  }

  Future<void> fetchUserDetails() async{
    try{
      profileLeading.value = true;
      UserModel user = await _userRepo.fetchUserDetails();
      this.user(user);
    }catch(e){

       user(UserModel.empty());
    }finally {
      profileLeading.value = false;
    }
  }
  void deleteAccountWarningPopup(){

    Get.defaultDialog(
      contentPadding: EdgeInsets.all(USizes.md),
      title: "Delete Account",
      middleText: "Are you sure you want to delete account permanently",
      confirm: ElevatedButton(
          onPressed: ()=> deleteUserAccount(),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red,side: BorderSide(color: Colors.red)),
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: USizes.lg),
        child: Text("Delete"),
      )),
      cancel: OutlinedButton(onPressed: ()=>Get.back(), child: Text("Cancel"))
    );

  }
  Future<void> deleteUserAccount() async{
    try{
      UFullScreenLoader.openLoadingDialog("Processing>>>");
      final authRepo = AuthenticationRepo.instance;
      final provider = authRepo.currentUser!.providerData.map((e)=>e.providerId).first;

      if(provider=="google.com"){
        await authRepo.signInWithGoogle();
        await authRepo.deleteAccount();
        UFullScreenLoader.stopLoading();
        Get.offAll(()=>LoginScreen());

      }else if(provider=="password"){
        UFullScreenLoader.stopLoading();
        Get.to(()=>ReAuthenticateUserForm());

      }

    }catch(e){
      UFullScreenLoader.stopLoading();
      USnackBarHelpers.errorSnackBar(title: "Error", message: e.toString());
    }

  }
  Future<void> reAuthenticateUser() async{
    try{

      UFullScreenLoader.openLoadingDialog("Processing>>>");
      bool isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        UFullScreenLoader.stopLoading();
        return;
      }
      if(!reAuthFormKey.currentState!.validate()){
        UFullScreenLoader.stopLoading();
        return;
      }
      await AuthenticationRepo.instance.reAuthenticateEmailAndPassword(email.text.trim(), password.text.trim());
      await AuthenticationRepo.instance.deleteAccount();
      UFullScreenLoader.stopLoading();
      Get.offAll(()=>LoginScreen());


    }catch(e){
      UFullScreenLoader.stopLoading();
      USnackBarHelpers.errorSnackBar(title: "Failed",message: e.toString());
    }
  }
  Future<void> updateProfilePicture() async{
    try{
      isProfileUploading.value = true;
    XFile? image = await  ImagePicker().pickImage(source: ImageSource.gallery,maxHeight: 512,maxWidth: 512);


    if(image==null){
      return;
    }
    File file = File(image.path);
    if(user.value.publicId.isNotEmpty){
      await _userRepo.deleteProfilePicture(user.value.publicId);
    }
    dio.Response response = await _userRepo.uploadImage(file);
    if(response.statusCode == 200){

      final data = response.data;
      final imageUrl = data['url'];
      final publicId = data['public_id'];

     await _userRepo.updateSingleField({'profilePicture':imageUrl, 'publicId':publicId});

     user.value.profilePicture = imageUrl;
      user.value.publicId = publicId;

      user.refresh();
    }else {
      throw 'Failed to upload profile picture. PLEASE TRY AGAIN';
    }
    }catch(e){
      USnackBarHelpers.errorSnackBar(title: 'Failed to upload profile picture. PLEASE TRY AGAIN',message: e.toString());

    }finally{
      isProfileUploading.value = false;
    }
  }

}