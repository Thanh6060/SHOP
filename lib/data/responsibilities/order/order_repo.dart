import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shop/data/responsibilities/authentication_repo.dart';

import '../../../features/authentication/model/order_model.dart';
import '../../../utils/constants/keys.dart';

class  OrderRepo  extends GetxController{
  static OrderRepo get instance => Get.find();
  final _database =  FirebaseFirestore.instance;
  Future<void> saveOrder(OrderModel order) async{
    try{
      await _database.collection(UKeys.userCollection).doc(order.userId).collection(UKeys.ordersCollection).add(order.toJson());

    }catch(e){
      throw 'Something went wrong while saving order information';
    }

  }
  Future<List<OrderModel>> fetchUserOrders() async{
    try{
      final userId = AuthenticationRepo.instance.currentUser!.uid;
      if(userId.isEmpty) throw 'Unable to find information';
      final query = await _database.collection(UKeys.userCollection).doc(userId).collection(UKeys.ordersCollection).get();

      if(query.docs.isNotEmpty){
        List<OrderModel> orders = query.docs.map((doc)=> OrderModel.fromSnapshot(doc)).toList();
      return orders;
      }

      return [];
    }catch(e){
      throw 'Something went wrong while order information';

    }
  }
}