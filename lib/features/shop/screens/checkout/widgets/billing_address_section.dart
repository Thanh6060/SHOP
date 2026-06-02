import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/common/widgets/texts/section_heading.dart';
import 'package:shop/features/personalization/controllers/address_controller.dart';
import 'package:shop/utils/constants/sizes.dart';

import '../../../../../utils/constants/colors.dart';

class UBillingAddressSection extends StatelessWidget {
  const UBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());
    controller.getAllAddresses();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        USectionHeading(title: "Billing Address",buttonTitle: "Change",onPressed: ()=>controller.selectedNewAddressBottomSheet(context),),
        Obx((){
          final address = controller.selectedAddress.value;
          if(address.id.isEmpty){
            return Text('Select Address');
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(address.name, style: Theme.of(context).textTheme.titleLarge,),
              SizedBox(height: USizes.spaceBtwItems/2,),
              Row(
                children: [
                  Icon(Icons.phone,size: USizes.iconSm,color: UColors.darkGrey,),
                  SizedBox(width: USizes.spaceBtwItems,),
                  Text(address.phoneNumber),
                ],
              ),
              SizedBox(height: USizes.spaceBtwItems/2,),
              Row(
                children: [
                  Icon(Icons.location_history,size: USizes.iconSm,color: UColors.darkGrey,),
                  SizedBox(width: USizes.spaceBtwItems,),
                  Expanded(child: Text(address.toString(),softWrap: true,)),
                ],
              )
            ],
          );
        })
        

      ],
    );
  }
}
