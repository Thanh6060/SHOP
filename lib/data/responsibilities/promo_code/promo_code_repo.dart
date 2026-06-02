import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../features/shop/models/promo_code_model.dart';
import '../../../utils/constants/keys.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class PromoCodeRepo extends GetxController{
  static PromoCodeRepo get instance => Get.find();
  final _database = FirebaseFirestore.instance;
  Future<void> uploadPromoCode(List<PromoCodeModel> promoCodes) async{
    try{
      for(final promoCode in promoCodes){
        await _database.collection(UKeys.promoCodesCollection).doc(promoCode.id).set(promoCode.toJson());
      }
    } on FirebaseException catch(e){
      throw UFirebaseException(e.code).message;
    } on FormatException catch(_){
      throw UFormatException();
    } on PlatformException catch(e){
      throw UPlatformException(e.code).message;
    }catch(e){
      throw "Something went wrong. Please try again";
    }
  }

  Future<PromoCodeModel> fetchSinglePromCode(String code) async{
    try{
      final query = await _database.collection(UKeys.promoCodesCollection).where('code',isEqualTo: code).get();
      if(query.docs.isNotEmpty){
        PromoCodeModel promoCode = PromoCodeModel.fromSnapshot(query.docs.first);
        return promoCode;
      }
      return PromoCodeModel.empty();


    } on FirebaseException catch(e){
      throw UFirebaseException(e.code).message;
    } on FormatException catch(_){
      throw UFormatException();
    } on PlatformException catch(e){
      throw UPlatformException(e.code).message;
    }catch(e){
      throw "Something went wrong. Please try again";
    }

  }

  Future<void> updateSingleField(PromoCodeModel promoCode,String key,dynamic value) async{
    try{
     await _database.collection(UKeys.promoCodesCollection).doc(promoCode.id).update({key: value});

    } on FirebaseException catch(e){
      throw UFirebaseException(e.code).message;
    } on FormatException catch(_){
      throw UFormatException();
    } on PlatformException catch(e){
      throw UPlatformException(e.code).message;
    }catch(e){
      throw "Something went wrong. Please try again";
    }
  }
}