import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shop/data/responsibilities/user/user_repo.dart';
import 'package:shop/features/personalization/controllers/user_controller.dart';
import 'package:shop/navigation_menu.dart';
import 'package:shop/utils/helpers/network_manager.dart';
import 'package:shop/utils/popups/full_screen_loader.dart';
import 'package:shop/utils/popups/snackbar_helpers.dart';



class ChangeNameController extends GetxController{
  static ChangeNameController get instance => Get.find();
  final _userController = UserController.instance;
  final _userRepo = UserRepo.instance;
  final updateEmailFormKey = GlobalKey<FormState>();

  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final updateUserFormKey = GlobalKey<FormState>();
  final userId = TextEditingController();
  final email = TextEditingController();
 final phoneNumber = TextEditingController();
 final gender = TextEditingController();
 final username = TextEditingController();

  @override
  void onInit() {
    initializedNames();
    super.onInit();
  }
  void initializedNames(){
  firstname.text = _userController.user.value.firstName;
  lastname.text = _userController.user.value.lastName;
  userId.text = _userController.user.value.id;
  email.text = _userController.user.value.email;
  phoneNumber.text = _userController.user.value.phoneNumber;

  username.text = _userController.user.value.username;
  }
  // update user name
  Future<void> updateUserName() async{
    try{
      UFullScreenLoader.openLoadingDialog("We are updating your information....");
      bool isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        UFullScreenLoader.stopLoading();
        USnackBarHelpers.warningSnackBar(title: "No internet");
        return;
      }
      if(!updateUserFormKey.currentState!.validate()){
        UFullScreenLoader.stopLoading();
        return;
      }
      Map<String, dynamic> map = {"firstname":firstname.text,"lastname":lastname.text};
     await _userRepo.updateSingleField(map);
     _userController.user.value.firstName = firstname.text;
      _userController.user.value.lastName = lastname.text;
      UFullScreenLoader.stopLoading();
      Get.offAll(()=>NavigationMenu());
      USnackBarHelpers.successSnackBar(title: "Congratulation", message: "Your name has been updated");

      
    }catch(e){
      UFullScreenLoader.stopLoading();
      USnackBarHelpers.errorSnackBar(title: "Update Name Failed",message: e.toString());
    }
  }
  // update email
  Future<void> updateUserEmail() async {
    try {
      UFullScreenLoader.openLoadingDialog("We are updating your email....");
      bool isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UFullScreenLoader.stopLoading();
        USnackBarHelpers.warningSnackBar(title: "No internet");
        return;
      }

      if (!updateEmailFormKey.currentState!.validate()) {
        UFullScreenLoader.stopLoading();
        return;
      }


      Map<String, dynamic> map = {"email": email.text.trim()};
      await _userRepo.updateSingleField(map);


      _userController.user.value = _userController.user.value.copyWith(email: email.text.trim());
      _userController.user.refresh();

      UFullScreenLoader.stopLoading();
      Get.offAll(() => NavigationMenu());
      USnackBarHelpers.successSnackBar(title: "Congratulations", message: "Your email has been updated");

    } catch (e) {
      UFullScreenLoader.stopLoading();
      USnackBarHelpers.errorSnackBar(title: "Update Email Failed", message: e.toString());
    }
  }
  // update gender
  Future<void> updateUserGender() async {
    try {
      UFullScreenLoader.openLoadingDialog("We are updating your gender....");

      bool isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UFullScreenLoader.stopLoading();
        USnackBarHelpers.warningSnackBar(title: "No internet");
        return;
      }

      // Kiểm tra Form của giới tính (Dùng chung updateUserFormKey hoặc tạo key mới tùy bạn)
      if (!updateUserFormKey.currentState!.validate()) {
        UFullScreenLoader.stopLoading();
        return;
      }

      // Gửi giá trị từ controller gender lên Repo (ví dụ: "Male" hoặc "Female")
      Map<String, dynamic> map = {"gender": gender.text.trim()};
      await _userRepo.updateSingleField(map);

      // Cập nhật vào UserModel bằng hàm copyWith đã tạo ở bước trước
      _userController.user.value = _userController.user.value.copyWith(
        // Nếu biến gender trong UserModel của bạn bị báo đỏ, hãy xem "Lưu ý" ở cuối bài viết này
        gender: gender.text.trim(),
      );
      _userController.user.refresh();

      UFullScreenLoader.stopLoading();
      Get.offAll(() => const NavigationMenu());

      USnackBarHelpers.successSnackBar(
        title: "Congratulations",
        message: "Your gender has been updated.",
      );

    } catch (e) {
      UFullScreenLoader.stopLoading();
      USnackBarHelpers.errorSnackBar(title: "Update Gender Failed", message: e.toString());
    }
  }
  // update phone number
  Future<void> updatePhoneNumber() async{
    try{
      UFullScreenLoader.openLoadingDialog("We are updating your information....");
      bool isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        UFullScreenLoader.stopLoading();
        USnackBarHelpers.warningSnackBar(title: "No internet");
        return;
      }
      if(!updateUserFormKey.currentState!.validate()){
        UFullScreenLoader.stopLoading();
        return;
      }
      Map<String, dynamic> map = {"firstname":firstname.text,"lastname":lastname.text};
      await _userRepo.updateSingleField(map);
      _userController.user.value.firstName = firstname.text;
      _userController.user.value.lastName = lastname.text;
      UFullScreenLoader.stopLoading();
      Get.offAll(()=>NavigationMenu());
      USnackBarHelpers.successSnackBar(title: "Congratulation", message: "Your name has been updated");


    }catch(e){
      UFullScreenLoader.stopLoading();
      USnackBarHelpers.errorSnackBar(title: "Update Name Failed",message: e.toString());
    }
  }
  // update user id
  Future<void> updateUserId() async {
    try {
      UFullScreenLoader.openLoadingDialog("We are updating your User ID....");

      bool isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        UFullScreenLoader.stopLoading();
        USnackBarHelpers.warningSnackBar(title: "No internet");
        return;
      }

      // Kiểm tra tính hợp lệ của Form (Dùng chung updateUserFormKey)
      if (!updateUserFormKey.currentState!.validate()) {
        UFullScreenLoader.stopLoading();
        return;
      }

      // Gửi giá trị ID mới lên Repo (Key trong map phải khớp với database của bạn, ví dụ 'id' hoặc 'username')
      Map<String, dynamic> map = {"id": userId.text.trim()};
      await _userRepo.updateSingleField(map);

      // Cập nhật vào UserModel thông qua hàm copyWith
      _userController.user.value = _userController.user.value.copyWith(
        id: userId.text.trim(),
      );
      _userController.user.refresh();

      UFullScreenLoader.stopLoading();
      Get.offAll(() => const NavigationMenu());

      USnackBarHelpers.successSnackBar(
        title: "Congratulations",
        message: "Your User ID has been updated successfully.",
      );

    } catch (e) {
      UFullScreenLoader.stopLoading();
      USnackBarHelpers.errorSnackBar(title: "Update ID Failed", message: e.toString());
    }
  }



}