import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop/common/widgets/custom_shapes/rounded_container.dart';
import 'package:shop/features/authentication/model/order_model.dart';
import 'package:shop/features/shop/controllers/order/order_controller.dart';
import 'package:shop/utils/constants/colors.dart';
import 'package:shop/utils/constants/sizes.dart';
import 'package:shop/utils/helpers/helper_function.dart';

import '../../../../../utils/constants/enums.dart';
import 'map_ship.dart';

class DetailScreen extends StatelessWidget {
  final String orderId;

  const DetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final dark = UHelperFunctions.isDarkMode(context);
    final controller = Get.put(OrderController());


    final OrderModel? order = controller.allOrders.firstWhereOrNull((o) => o.id == orderId);


    if (order == null) {
      return Scaffold(
        backgroundColor: dark ? UColors.black : UColors.light,
        appBar: AppBar(
          title: const Text('Chi tiết đơn hàng'),
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_left),
            onPressed: () => Get.back(),
          ),
        ),
        body: const Center(
          child: Text(
            'Không tìm thấy dữ liệu đơn hàng.\nVui lòng kiểm tra lại!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }


    return Scaffold(
      backgroundColor: dark ? UColors.black : UColors.light,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left, color: dark ? UColors.white : UColors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Order Details',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(USizes.defaultSpace),
        child: Column(
          children: [

            URoundedContainer(
              showBorder: true,
              backgroundColor: dark ? UColors.dark : UColors.white,
              padding: const EdgeInsets.all(USizes.md),
              child: Row(
                children: [
                  URoundedContainer(
                    width: 50,
                    height: 50,
                    backgroundColor: UColors.primary.withOpacity(0.1),
                    child: const Icon(Iconsax.box, color: UColors.primary),
                  ),
                  const SizedBox(width: USizes.spaceBtwItems),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ID Number", style: Theme.of(context).textTheme.labelMedium),
                        Text(
                          order.id,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: UColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(USizes.cardRadiusSm),
                    ),
                    child: Text(
                      order.orderStatusText,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: UColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: USizes.spaceBtwItems),


            URoundedContainer(
              showBorder: true,
              backgroundColor: dark ? UColors.dark : UColors.white,
              padding: const EdgeInsets.all(USizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Details Order", style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: USizes.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailItem(context, "Payment Method", order.paymentMethod),
                      _buildDetailItem(context, "Total Amount", "\$${order.totalAmount}"),
                    ],
                  ),
                  const SizedBox(height: USizes.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailItem(context, "From (Order Date)", order.formattedOrderDate),
                      _buildDetailItem(context, "To (Delivery Date)", order.formattedDeliveryDate),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: USizes.spaceBtwItems),


            URoundedContainer(
              showBorder: true,
              backgroundColor: dark ? UColors.dark : UColors.white,
              padding: const EdgeInsets.all(USizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Shipping Status", style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: USizes.spaceBtwSections / 2),

                  _buildTimelineItem(context, "Moving from", "Order placed successfully", isPast: true),
                  _buildTimelineItem(context, "In transit", "Package is on the way to hub", isPast: order.orderStatusText.toLowerCase() != 'pending'),
                  _buildTimelineItem(context, "Out for delivery", "Courier is delivering", isPast: order.orderStatusText.toLowerCase() == 'delivered'),
                  _buildTimelineItem(context, "Delivery", order.formattedDeliveryDate, isLast: true, isPast: order.orderStatusText.toLowerCase() == 'delivered'),
                ],
              ),
            ),
            const SizedBox(height: USizes.spaceBtwSections),


            ElevatedButton(
              onPressed: () => Get.to(()=> MapShip()),
              style: ElevatedButton.styleFrom(
                backgroundColor: UColors.primary,
                minimumSize: Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
              ),
              child: Text("Live Tracking", style: TextStyle(color: UColors.white, fontWeight: FontWeight.bold)),
            ),
             SizedBox(height: USizes.spaceBtwItems / 2),
            if (order.status == OrderStatus.pending)
              OutlinedButton(
                onPressed: () {
                  Get.defaultDialog(
                    title: "Cancel Order",
                    middleText: "Are you sure you want to cancel this order?",
                    textConfirm: "Yes",
                    textCancel: "No",
                    confirmTextColor: Colors.white,
                    buttonColor: UColors.primary,
                    onConfirm: () {
                      Get.back();
                      controller.cancelOrder(order.id);
                    },
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 54),

                  side: const BorderSide(color: Colors.black38),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                ),
                child: const Text(
                    "Cancel Order",
                    style: TextStyle(color: UColors.primary, fontWeight: FontWeight.bold)
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium!.copyWith(color: UColors.darkGrey)),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, String title, String subtitle, {bool isLast = false, bool isPast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isPast ? UColors.primary : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: isPast ? UColors.primary : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: USizes.spaceBtwItems),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isPast ? (UHelperFunctions.isDarkMode(context) ? UColors.white : UColors.black) : UColors.darkGrey,
                ),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.labelMedium!.copyWith(color: UColors.darkGrey)),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}