import 'dart:async';
import 'dart:ui';


import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';

import '../../features/shop/models/product_model.dart';
import '../../utils/constants/keys.dart';

class BranchServices extends GetxController {
  static BranchServices get instance => Get.find();


  Future<void> initBranch() async {
    await FlutterBranchSdk.init(enableLogging: true, branchAttributionLevel: BranchAttributionLevel.FULL);
  }


  Future<void> createLink(ProductModel product) async {
    try {
      BranchUniversalObject buo = BranchUniversalObject(
          canonicalIdentifier: 'product/${product.id}',
          title: product.title,
          imageUrl: product.thumbnail,
          contentDescription: product.description ?? '',
          publiclyIndex: true,
          locallyIndex: true,
          contentMetadata: BranchContentMetaData()..addCustomMetadata(UKeys.productId, product.id)

      );
      BranchLinkProperties lp = BranchLinkProperties(
        channel: 'app',
        feature: 'share_product',
      );
      await FlutterBranchSdk.showShareSheet(
        buo: buo,
        linkProperties: lp,
        messageText: 'My Share product',
      );
    }catch(e){
      throw ' Product cannot be shared';
    }
  }



  StreamSubscription<Map> trackLink(Function(Map<dynamic,dynamic>) onListen,
      {VoidCallback? onError}) {
    StreamSubscription<Map> streamSubscription = FlutterBranchSdk.listSession().listen((data)  {
      if (data.containsKey("+clicked_branch_link") &&
          data["+clicked_branch_link"] == true) {

        onListen(data);
      }
    }, onError: (error) {
      if(onError != null) onError();

    });
    return streamSubscription;
  }
}
