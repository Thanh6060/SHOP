import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart'; // Thay bằng Icons.chevron_right nếu dự án không dùng Iconsax

class UserDetailRow extends StatelessWidget {
  const UserDetailRow({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
    this.icon = Iconsax.arrow_right_1, // Icon mặc định ở cuối hàng
  });

  final String title;
  final String value;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0), // Khoảng cách đệm trên dưới mỗi dòng
        child: Row(
          children: [
            // Cột tiêu đề chiếm 3 phần không gian
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey, // Chữ màu xám mờ giống thiết kế
                ) ??
                    const TextStyle(color: Colors.grey, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Cột giá trị thông tin chiếm 5 phần không gian
            Expanded(
              flex: 5,
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ) ??
                    const TextStyle(color: Colors.black87, fontSize: 14),
                overflow: TextOverflow.ellipsis, // Tự động cắt chuỗi bằng dấu "..." nếu quá dài (như Email)
              ),
            ),

            // Icon mũi tên chỉ hướng ở cuối hàng
            Icon(
              icon,
              size: 18,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
