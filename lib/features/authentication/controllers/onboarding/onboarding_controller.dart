import "package:flutter/cupertino.dart";
import "package:get/get.dart";
import "package:get_storage/get_storage.dart";
import "package:shop/features/authentication/screens/login/login.dart";


class OnBoardingController extends GetxController{
  static OnBoardingController get instance => Get.find();

  final pageController = PageController();
  RxInt currentIndex = 0.obs;
  final storage = GetStorage();

  void updatePageIndicator(int index){
    currentIndex.value = index;
  }

  void dotNavigationClick(int index){
    currentIndex.value = index;
    pageController.jumpToPage(index);
  }

  void nextPage(){
    if(currentIndex.value == 2){
      storage.writeIfNull("isFirstTime", false);
      Get.offAll(()=>LoginScreen());
      return;
    }
    currentIndex.value++;
    pageController.jumpToPage((currentIndex.value));
  }

  void skipPage(){
    currentIndex.value = 2;
    pageController.jumpToPage(currentIndex.value);
  }
}