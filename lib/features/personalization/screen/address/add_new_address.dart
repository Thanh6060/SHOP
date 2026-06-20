import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop/common/styles/padding.dart';
import 'package:shop/common/widgets/appbar/appbar.dart';
import 'package:shop/features/personalization/controllers/address_controller.dart';
import 'package:shop/utils/constants/sizes.dart';
import 'package:shop/utils/validators/validation.dart';

import '../../../../common/widgets/button/elevated_button.dart';

class AddNewAddressScreen extends StatelessWidget {
  const AddNewAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());
    return Scaffold(

      appBar: UAppBar(
        showBackArrow: true,title: Text("Add new Address",style: Theme.of(context).textTheme.headlineMedium,),),
      body: SingleChildScrollView(
        child: Padding(
            padding: UPadding.screenPadding,
            child: Form(
              key: controller.addressFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.name,
                    validator: (value)=>UValidator.validateEmptyText('name', value),
                    decoration: InputDecoration(prefixIcon: Icon(Iconsax.user),labelText: "Name"),),
                  SizedBox(height: USizes.spaceBtwInputFields,),
                  TextFormField(
                    controller: controller.phoneNumber,
                    validator: (value)=>UValidator.validateEmptyText('Phone Number', value),
                    decoration: InputDecoration(
                        prefixIcon: CountryCodePicker(
                          initialSelection: 'VN',
                          favorite: const ['VN', '+84', 'US',],
                          showDropDownButton: true,
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                          onChanged: (country) {
                            controller.countryCode =
                                country.dialCode ?? "+84";
                          },
                        ),labelText: "Phone Number"),),
                  SizedBox(height: USizes.spaceBtwInputFields,),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.street,
                          validator: (value)=>UValidator.validateEmptyText('Street', value),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Iconsax.building_31),labelText: "Street"),),
                      ),
                      SizedBox(width: USizes.spaceBtwInputFields,),

                      Expanded(
                        child: TextFormField(
                          controller: controller.postalCode,
                          validator: (value)=>UValidator.validateEmptyText('Post Code', value),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Iconsax.code),labelText: "PostCode"),),
                      ),
                    ],
                  ),
                  SizedBox(height: USizes.spaceBtwInputFields,),

                  Row(
                      children: [
                        Expanded(
              child: TextFormField(
                controller: controller.city,
                validator: (value)=>UValidator.validateEmptyText('City', value),
                decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.building),labelText: "City"),),
                        ),
                        SizedBox(width: USizes.spaceBtwInputFields,),

                        Expanded(
              child: TextFormField(
                controller: controller.state,
                validator: (value)=>UValidator.validateEmptyText('State', value),
                decoration: InputDecoration(

                    prefixIcon: Icon(Iconsax.activity),labelText: "State"),),
                        ),
                      ],
                    ),
                  SizedBox(height: USizes.spaceBtwInputFields,),

                  TextFormField(
                    controller: controller.country,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Country",
                      prefixIcon: Icon(Iconsax.global),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        onSelect: (country) {
                          controller.country.text =
                              country.name;
                        },
                      );
                    },
                  ),
                  SizedBox(height: USizes.spaceBtwSections,),

                  UElevatedButton(onPressed: controller.addNewAddress, child: Text("Save"))

                ],
              ),
            ),

        ),
      ),
    );
  }
}
