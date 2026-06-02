import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop/common/styles/padding.dart';
import 'package:shop/common/widgets/appbar/appbar.dart';

import 'package:shop/features/personalization/controllers/address_controller.dart';
import 'package:shop/features/personalization/models/address_model.dart';

import 'package:shop/features/personalization/screen/address/add_new_address.dart';
import 'package:shop/features/personalization/screen/address/widgets/single_address.dart';
import 'package:shop/utils/constants/sizes.dart';
import 'package:shop/utils/helpers/cloud_helper_functions.dart';


import '../../../../utils/constants/colors.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());

    return Scaffold(
      appBar: UAppBar(showBackArrow: true,title: Text("Address",style: Theme.of(context).textTheme.headlineMedium,),),
      body: SingleChildScrollView(
        child: Padding(

          padding: UPadding.screenPadding,
          child: Obx(
              ()=> FutureBuilder(
                key: Key(controller.refreshData.value.toString()),
                future: controller.getAllAddresses(),
                builder: (context,snapshot){

                  final widget = UCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, );
                  if(widget != null) return widget;

                  List<AddressModel> addresses = snapshot.data!;

                return ListView.separated(
                  shrinkWrap: true,
                     physics: NeverScrollableScrollPhysics(),

                     separatorBuilder: (context,index)=>SizedBox(height: USizes.spaceBtwItems,),
                     itemCount: addresses.length,
                     itemBuilder: (context,index){
                       return USingleAddress(
                         onTap: ()=>controller.selectAddress(addresses[index]),


                         address: addresses[index],
                       );
                     }
                 );
                }
            ),
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>Get.to(()=>AddNewAddressScreen()),
        backgroundColor: UColors.primary,
        child: Icon(Iconsax.add,color: Colors.white,),
      ),
    );
  }
}


