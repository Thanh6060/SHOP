


import 'dart:async';

import 'package:get/get.dart';
import 'package:shop/data/services/branch_services.dart';
import 'package:shop/features/shop/controllers/product/product_controller.dart';
import 'package:shop/features/shop/models/product_model.dart';
import 'package:shop/features/shop/screens/product_details/product_details.dart';
import 'package:shop/utils/constants/keys.dart';
import 'package:shop/utils/helpers/network_manager.dart';
import 'package:shop/utils/popups/snackbar_helpers.dart';

class HomeController extends GetxController  {
  static HomeController get instance => Get.find();

  late final StreamSubscription<Map> _brandSubscription;

  @override
  void onInit() {
    initBranchSubscription();

    super.onInit();
  }
  Future<void> initBranchSubscription() async{
    bool isConnected = await NetworkManager.instance.isConnected();
    if(!isConnected){
      USnackBarHelpers.errorSnackBar(title: 'No internet', message: 'Please check your internet');
      return;
    }
    _brandSubscription = BranchServices.instance.trackLink((data) async{
      if(data[UKeys.productId] == null) return;
      String productId = UKeys.productId;
    ProductModel product = await ProductController.instance.getSingleProducts(productId);

    Get.to(()=> ProductDetailsScreen(product: product));

    });
  }

  @override
  void dispose() {
    _brandSubscription?.cancel();
    super.dispose();
  }
  



}