import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../features/personalization/screen/profile/widgets/coupons.dart';
import '../../../features/shop/controllers/promo_code/promo_code_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';


import '../custom_shapes/rounded_container.dart';

class UPromoCodeField extends StatelessWidget {
  const UPromoCodeField({
    super.key,

  });



  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PromoCodeController());
    final textController = TextEditingController(text: controller.promoCode.value);


    return Obx((){
      textController.text = controller.promoCode.value;
      textController.selection = TextSelection.fromPosition(TextPosition(offset: textController.text.length));
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          URoundedContainer(
            showBorder: true,
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.only(left: USizes.md,top: USizes.sm,right: USizes.sm,bottom: USizes.sm),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.card_giftcard,color: Colors.grey.shade400,),
                  onPressed: ()=> Get.to(()=>MyCouponsScreen()),
                ),
                Flexible(child:
                TextFormField(
                  controller: textController,
                  onChanged: controller.onPromoChanged,
                  decoration:
                  InputDecoration(hintText: 'Enter promo code?',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),)),

                SizedBox(
                    width: 80.0,
                    child: Obx(
                          ()=> ElevatedButton(
                        onPressed: controller.appliedPromoCode.value.id.isNotEmpty ? null :  controller.promoCode.value.isEmpty ? null : controller.applyPromoCode,
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
                        ),
                        child: controller.isLoading.value
                            ? SizedBox(width: USizes.lg,height: USizes.lg, child: CircularProgressIndicator(color: UColors.white,))
                            : Text(controller.appliedPromoCode.value.id.isEmpty ? "Apply" : "Applied"),

                      ),
                    )),



              ],
            ),
          ),
        ],
      );
    }

    );
  }
}