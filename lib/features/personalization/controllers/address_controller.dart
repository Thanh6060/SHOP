
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/common/widgets/loader/circular_loader.dart';
import 'package:shop/common/widgets/texts/section_heading.dart';
import 'package:shop/data/responsibilities/address/address_repo.dart';
import 'package:shop/features/personalization/models/address_model.dart';
import 'package:shop/features/personalization/screen/address/add_new_address.dart';
import 'package:shop/features/personalization/screen/address/widgets/single_address.dart';
import 'package:shop/utils/constants/sizes.dart';
import 'package:shop/utils/helpers/cloud_helper_functions.dart';
import 'package:shop/utils/helpers/network_manager.dart';
import 'package:shop/utils/popups/full_screen_loader.dart';
import 'package:shop/utils/popups/snackbar_helpers.dart';

class AddressController extends GetxController{
  static AddressController get instance => Get.find();
  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final street = TextEditingController();
  final postalCode = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final country = TextEditingController();
  final _repository = Get.put(AddressRepo());
  Rx<AddressModel> selectedAddress = AddressModel.empty().obs;
  RxBool refreshData = false.obs;
  String countryCode = '+84';

  GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();
  Future<void> addNewAddress() async{
    try{
      UFullScreenLoader.openLoadingDialog('Storing Address....  ');
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        UFullScreenLoader.stopLoading();
        return;
      }
      if(!addressFormKey.currentState!.validate()){
        UFullScreenLoader.stopLoading();
        return;
      }
      AddressModel address = AddressModel(
          id: ''
          , name: name.text.trim(),
          phoneNumber: phoneNumber.text.trim(),
          street: street.text.trim(),
          postalCode: postalCode.text.trim(),
          city: city.text.trim(),

          state: state.text.trim(),
          country: country.text.trim(),
        dateTime: DateTime.now(),

      );
     String addressId = await _repository.addAddress(address);
     address.id = addressId;
     selectAddress(address);
     UFullScreenLoader.stopLoading();
     USnackBarHelpers.successSnackBar(title: 'Congratulations',message: 'Your address has been save successfully');
     refreshData.toggle();
     resetFormFields();
     Get.back();
    }catch(e){
  UFullScreenLoader.stopLoading();
  USnackBarHelpers.errorSnackBar(title: "Failed",message: e.toString());
    }
  }

  Future<List<AddressModel>> getAllAddresses() async{
    try{

     List<AddressModel> addresses = await _repository.fetchUserAddress();
     selectedAddress.value = addresses.firstWhere((address)=>address.selectedAddress,orElse: ()=> AddressModel.empty());
     return addresses;
    }catch(e){
      USnackBarHelpers.errorSnackBar(title: 'Failed',message: e.toString());
      return[];
    }
  }

  Future<void> selectAddress(AddressModel newSelectedAddress) async{
    try{
      Get.defaultDialog(
        title: '',
        onWillPop: () async => false,
        barrierDismissible: false,
        backgroundColor: Colors.transparent,
        content: UCircularLoader()
      );
      if(selectedAddress.value.id.isNotEmpty){
        await _repository.updateSelectedField(selectedAddress.value.id, false);
      }
      newSelectedAddress.selectedAddress = true;
      selectedAddress.value = newSelectedAddress;
      await _repository.updateSelectedField(selectedAddress.value.id, true);
      Get.back();
    }catch(e){
      Get.back();
      USnackBarHelpers.errorSnackBar(title: 'Failed',message: e.toString());

    }

  }
Future<void> selectedNewAddressBottomSheet(BuildContext context){
    return showModalBottomSheet(context: context, builder: (context)=> Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(USizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                USectionHeading(title: 'Select Address', showActionButton:  false,),
                SizedBox(height: USizes.spaceBtwItems,),
                FutureBuilder(
                    future: getAllAddresses(), builder: (context,snapshot){

                  final widget = UCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot);
                  if(widget != null) return widget;

                  return ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context,index)=>SizedBox(height: USizes.spaceBtwItems,),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context,index)=>
                          USingleAddress(
                            address: snapshot.data![index],
                            onTap:(){
                              selectAddress(snapshot.data![index]);
                            Get.back();}


                          ),


                  );
                }),
                SizedBox(height: USizes.spaceBtwSections,)
              ],
            ),
          ),
        ),
        Positioned(
          bottom: USizes.defaultSpace,
            left: USizes.defaultSpace * 2,
            right: USizes.defaultSpace * 2,
            child: ElevatedButton(onPressed: ()=>Get.to(()=> AddNewAddressScreen()), child: Text('Add New Address')))
      ],
    ));
}
  void resetFormFields(){
    name.clear();
    phoneNumber.clear();
    street.clear();
    postalCode.clear();
    city.clear();
    state.clear();

    addressFormKey.currentState!.reset();
  }

}