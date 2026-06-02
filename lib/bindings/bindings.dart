import 'package:get/get.dart';
import 'package:shop/features/personalization/controllers/address_controller.dart';

import 'package:shop/features/shop/controllers/product/variation_controller.dart';

import 'package:shop/utils/helpers/network_manager.dart';

class UBindings extends Bindings{
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(VariationController());
  //  Get.put(CheckoutController());
    Get.put(AddressController());
  }

}