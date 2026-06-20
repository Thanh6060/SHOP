import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../shop/controllers/promo_code/promo_code_controller.dart';

class MyCouponsScreen extends StatelessWidget {
  const MyCouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PromoCodeController());

    // Tự động tải danh sách mã từ kho Firebase của user khi mở trang
    controller.fetchMyCoupons();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ví Voucher Của Tôi"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        // Trạng thái đang tải dữ liệu từ Firebase
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Trạng thái ví rỗng
        if (controller.myCoupons.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(USizes.defaultSpace),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.card_giftcard, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: USizes.spaceBtwItems),
                  Text(
                    "Ví voucher trống rỗng!",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: USizes.spaceBtwItems / 2),
                  const Text(
                    "Hãy tích lũy hoàn thành đủ 5 đơn hàng thành công để nhận ngay mã thưởng Random độc quyền từ hệ thống nhé.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        // Danh sách hiển thị Voucher dạng vé xé (Ticket Shape) chuyên nghiệp
        return ListView.builder(
          itemCount: controller.myCoupons.length,
          padding: const EdgeInsets.all(USizes.defaultSpace),
          itemBuilder: (context, index) {
            final coupon = controller.myCoupons[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3), width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    // Cột bên trái: Hình ảnh/Icon nhận diện vé quà tặng
                    Container(
                      color: Colors.green,
                      width: 80,
                      height: 90,
                      child: const Icon(Icons.confirmation_num, color: Colors.white, size: 36),
                    ),

                    // Cột ở giữa: Thông tin chi tiết mã
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              coupon.code,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green, letterSpacing: 1),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              coupon.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Cột bên phải: Nút "Áp dụng" nhanh
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          // HÀNH ĐỘNG KHI BẤM NÚT:
                          // 1. Gán chuỗi mã này vào ô TextField trong bộ nhớ GetX
                          controller.promoCode.value = coupon.code;
                          // 2. Quay lại màn hình Checkout trước đó
                          Get.back();
                          // 3. Tự động chạy hàm Apply kích hoạt giảm trừ tiền luôn cho user
                          controller.applyPromoCode();
                        },
                        child: const Text("Dùng ngay", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}