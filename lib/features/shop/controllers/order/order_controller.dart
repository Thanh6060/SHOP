
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
import '../promo_code/promo_code_controller.dart';

class  OrderController  extends GetxController{
  static OrderController get instance => Get.find();
  final cartController = CartController.instance;

  final addressController = AddressController.instance;
  final _repository = Get.put(OrderRepo());
  RxList allOrders = <OrderModel>[].obs;


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
          id: DateTime.now().millisecondsSinceEpoch.toString(),
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



      final promoController = Get.put(PromoCodeController(), permanent: true);
      await promoController.checkAndGenerateRewardPromoCode();
      UFullScreenLoader.stopLoading();
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
      allOrders.assignAll(orders);
      return orders;

    }catch(e){
      USnackBarHelpers.errorSnackBar(title: 'Failed',message: e.toString());
      return [];
    }
  }

  // Hàm xử lý hủy đơn hàng
  // Hàm xử lý hủy đơn hàng (Đã sửa lỗi đồng bộ ID và Enum State)
  Future<void> cancelOrder(String orderId) async {
    try {
      // 1. Mở vòng xoay loading
      UFullScreenLoader.openLoadingDialog('Canceling your order....');

      // 2. Tìm đơn hàng trong bộ nhớ local dựa vào mã orderId truyền từ UI sang
      final targetOrder = allOrders.firstWhereOrNull((o) => o.id == orderId);

      if (targetOrder == null) {
        throw 'Không tìm thấy dữ liệu đơn hàng trong hệ thống.';
      }

      // 3. Gọi Repository để cập nhật trạng thái lên Firebase
      // CHỖ SỬA: Dùng targetOrder.id đồng bộ trực tiếp với ID Firestore
      // và dùng OrderStatus.cancelled.name thay cho chuỗi 'cancelled' viết tay
      await OrderRepo.instance.updateOrderStatus(targetOrder.id, OrderStatus.cancelled.name);

      // 4. Cập nhật UI cục bộ (Local State) bằng copyWith
      final index = allOrders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        allOrders[index] = allOrders[index].copyWith(status: OrderStatus.cancelled);
        // Thông báo cho GetX cập nhật lại toàn bộ giao diện màn hình
        allOrders.refresh();
      }

      // 5. Đóng loading dialog
      Get.back();

      // 6. Hiển thị thông báo thành công
      USnackBarHelpers.successSnackBar(
          title: 'Success',
          message: 'Your order has been cancelled successfully.'
      );

      // 7. Quay trở lại màn hình trước đó
      Get.back();

    } catch (e) {
      Get.back(); // Đóng loading nếu xảy ra sự cố
      USnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}