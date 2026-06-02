import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shop/data/responsibilities/authentication_repo.dart';
import 'package:shop/data/responsibilities/order/order_repo.dart';
import 'package:shop/features/personalization/controllers/address_controller.dart';
import 'package:shop/features/shop/controllers/cart/cart_controller.dart';
import 'package:shop/features/shop/controllers/checkout/checkout_controller.dart';
import 'package:shop/utils/popups/full_screen_loader.dart';
import 'package:shop/utils/popups/snackbar_helpers.dart';

import '../../../../common/widgets/screen/success_screen.dart';
import '../../../../navigation_menu.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/images.dart';
import '../../../authentication/model/order_model.dart';

class  OrderController  extends GetxController{
  static OrderController get instance => Get.find();
  final cartController = CartController.instance;

  final addressController = AddressController.instance;
  final _repository = Get.put(OrderRepo());

  Future<void> processOrder(double totalAmount) async{
    try  {
      UFullScreenLoader.openLoadingDialog('Processing your order....');
      String userId = AuthenticationRepo.instance.currentUser!.uid;
      if(userId.isEmpty) return;

      if(addressController.selectedAddress.value.id.isEmpty){
        USnackBarHelpers.warningSnackBar(title: 'No Address Selected',message: 'Please select an address');
        return;
      }

      OrderModel order = OrderModel(
          id: UniqueKey().toString(),
          status: OrderStatus.pending,
          items: cartController.cartItems.toList(),
          totalAmount: totalAmount,
          orderDate: DateTime.now(),
          userId: userId,
          paymentMethod: CheckoutController.instance.selectedPaymentMethod.value.name,
          address: addressController.selectedAddress.value,
        deliveryDate: DateTime.now()

      );
     await _repository.saveOrder(order);
     cartController.clearCart();
      Get.to(()=>SuccessScreen(
          title: "Payment Success!",
          subTitle: "Your item will be shipped soon",
          image: UImages.successfulPaymentIcon,
          onTap: ()=>Get.offAll(()=>NavigationMenu())));
    }catch(e){
      USnackBarHelpers.errorSnackBar(title: 'Order Failed',message: e.toString());

    }
  }

  Future<List<OrderModel>> fetchUserOrders() async{
    try{
      final orders =  await _repository.fetchUserOrders();
      return orders;

    }catch(e){
      USnackBarHelpers.errorSnackBar(title: 'Failed',message: e.toString());
      return [];
    }
  }
}