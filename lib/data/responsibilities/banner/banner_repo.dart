import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shop/data/services/cloudinary_services.dart';
import 'package:shop/features/shop/models/banners_model.dart';
import 'package:shop/utils/helpers/helper_function.dart';

import '../../../utils/constants/keys.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import 'package:dio/dio.dart' as dio;

class BannerRepo  extends GetxController{
  static BannerRepo get instance => Get.find();
  final _database = FirebaseFirestore.instance;
  final _cloudinaryServices = Get.put(CloudinaryServices());
  Future<void> uploadBanner(List<BannerModel> banners) async{

    for (final banner in banners) {
     File image  = await UHelperFunctions.assetToFile(banner.imageUrl);
    dio.Response response = await  _cloudinaryServices.uploadImage(image, UKeys.bannersFolder);

    if(response.statusCode == 200 ){
      banner.imageUrl = response.data['url'];
    }
    await _database.collection(UKeys.bannerCollection).doc().set(banner.toJson());


    }
    try{


    } on FirebaseAuthException catch(e){
      throw UFirebaseAuthException(e.code).message;
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

  Future<List<BannerModel>> fetchActiveBanners() async{
    try{
      final query = await _database.collection(UKeys.bannerCollection).where('active',isEqualTo: true).get();
      if(query.docs.isNotEmpty){
        List<BannerModel> banners = query.docs.map((document)=>BannerModel.fromDocument(document)).toList();
      return banners;
      }
      return [];

    } on FirebaseAuthException catch(e){
      throw UFirebaseAuthException(e.code).message;
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