import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shop/common/styles/padding.dart';
import 'package:shop/common/widgets/appbar/appbar.dart';
import 'package:shop/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:shop/features/shop/controllers/product/all_products_controller.dart';
import 'package:shop/utils/helpers/cloud_helper_functions.dart';


import '../../../../common/widgets/products/sortable_products.dart';
import '../../models/product_model.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key,this.query,this.futureMethod,required this.title});
final Future<List<ProductModel>>? futureMethod;
final Query? query;
final String title;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllProductsController());
    return Scaffold(
      appBar: UAppBar(showBackArrow: true,
        title: Center(child: Text(title,style: Theme.of(context).textTheme.headlineMedium,)),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: UPadding.screenPadding,
          child: FutureBuilder(
              future: futureMethod ?? controller.fetchProductsByQuery(query),
              builder: (context,snapshot){
                const loader = UVerticalProductShimmer();
                final widget = UCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot,loader: loader);
                if(widget != null) return widget;
                List<ProductModel> products = snapshot.data!;
                return USortableProducts(products: products,);
              }
          ),

        ),

      ),
    );
  }
}


