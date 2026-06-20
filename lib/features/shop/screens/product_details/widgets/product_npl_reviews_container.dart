import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:shop/common/widgets/texts/section_heading.dart';
import 'package:shop/utils/constants/sizes.dart';
import '../../../controllers/review/product_review_npl_controller.dart';

class UProductNLPReviewsContainer extends StatelessWidget {
  const UProductNLPReviewsContainer({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductReviewNLPController());


    controller.streamReviewSummary(productId);
    controller.streamComments(productId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const USectionHeading(title: "Phân tích từ khách hàng ✨", showActionButton: false),
        const SizedBox(height: USizes.spaceBtwItems),

        Obx(() {
          if (controller.reviewSummary.value == null) return const SizedBox.shrink();
          final data = controller.reviewSummary.value!;
          return Container();
        }),


        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 18, child: Icon(Icons.person)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller.commentController,
                      decoration: const InputDecoration(
                        hintText: "Write a comment...",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Obx(() => controller.isSubmitting.value
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                      : IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () => controller.sendComment(productId),
                  )),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(child: const Text("Đánh giá sao: ", style: TextStyle(fontSize: 12, color: Colors.grey))),
                  Obx(() => RatingBar.builder(
                    initialRating: controller.selectedRating.value,
                    minRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: 18,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) => controller.selectedRating.value = rating,
                  )),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 24),


        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => Text("Comments (${controller.commentsList.length})", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            const Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                SizedBox(width: 4),
                Text("4.8 (24)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            )
          ],
        ),
        const SizedBox(height: 16),

        Obx(() {
          if (controller.isLoading.value && controller.commentsList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.commentsList.isEmpty) {
            return const Center(child: Text("Chưa có bình luận nào. Hãy là người đầu tiên!"));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.commentsList.length,
            itemBuilder: (context, index) {
              final commentData = controller.commentsList[index];
              return Container(

                margin: const EdgeInsets.only(bottom: 8),

                padding: const EdgeInsets.only(top: 8, bottom: 16),

                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(

                      color: Colors.grey.shade200,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: commentData['profilePicture'] != ''
                                  ? NetworkImage(commentData['profilePicture'])
                                  : null,
                              child: commentData['profilePicture'] == '' ? const Icon(Icons.person, size: 16) : null,
                            ),
                            const SizedBox(width: 10),
                            Text(commentData['username'] ?? 'User', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(width: 4),
                            const Icon(Icons.check_circle, color: Colors.blue, size: 14),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_horiz, color: Colors.grey),
                          onPressed: () {

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  title: const Text("Xóa bình luận?"),
                                  content: const Text("Bạn có chắc chắn muốn xóa vĩnh viễn bình luận này không?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
                                    ),
                                    TextButton(
                                      onPressed: () {

                                        Navigator.pop(context);
                                      },
                                      child: const Text("Xóa", style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 6),
                    RatingBarIndicator(
                      rating: (commentData['rating'] ?? 5.0).toDouble(),
                      itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 14.0,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      commentData['comment'] ?? '',
                      style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ],
    );
  }
}