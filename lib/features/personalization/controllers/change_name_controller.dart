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

  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final updateUserFormKey = GlobalKey<FormState>();
  @override
  void onInit() {
    initializedNames();
    super.onInit();
  }
  void initializedNames(){
firstname.text = _userController.user.value.firstName;
lastname.text = _userController.user.value.lastName;
  }
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
}