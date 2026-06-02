import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:shop/common/widgets/texts/section_heading.dart';
import 'package:shop/data/responsibilities/authentication_repo.dart';
import 'package:shop/features/personalization/screen/address/address.dart';
import 'package:shop/features/personalization/screen/profile/widgets/proflie_primary_header.dart';
import 'package:shop/features/personalization/screen/profile/widgets/setting_menu_title.dart';
import 'package:shop/features/personalization/screen/profile/widgets/user_profile_title.dart';
import 'package:shop/features/shop/screens/cart/cart.dart';
import 'package:shop/features/shop/screens/order/order.dart';

import 'package:shop/utils/constants/sizes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            UProfilePrimaryHeader(),

            Padding(
              padding: const EdgeInsets.all(USizes.defaultSpace),
              child: Column(
                children: [
                  UserProfileTitle(),
                  SizedBox(height: USizes.spaceBtwItems,),
                  USectionHeading(
                    title: "Account Setting",
                    showActionButton: false,
                  ),
                  SettingMenuTitle(
                    icon: Iconsax.safe_home,
                    title: "My address",
                    subtitle: "Set shopping delivery addresses",
                    onTap:()=> Get.to(()=>AddressScreen()),
                  ),
                  SettingMenuTitle(
                      icon: Iconsax.shopping_cart,
                      title: "My Cart",
                      subtitle: "Add, remove products and move to checkbox",
                    onTap: ()=>Get.to(()=>CartScreen()),
                  ),
                  SettingMenuTitle(
                      icon: Iconsax.bag_tick,
                      title: "My Orders",
                      subtitle: "In progress and Completed Orders",
                    onTap: ()=>Get.to(()=>OrderScreen()),
                  ),
                  SizedBox(height: USizes.spaceBtwSections,),
                  SizedBox(
                    width: double.infinity,
                      child: OutlinedButton(onPressed: AuthenticationRepo.instance.logout, child: Text("Logout"))),
                  SizedBox(height: USizes.spaceBtwSections,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}






