import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shop/features/shop/models/brand_category_model.dart';
import 'package:shop/features/shop/models/brand_model.dart';

import '../../../utils/constants/keys.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../../utils/helpers/helper_function.dart';
import '../../services/cloudinary_services.dart';
import 'package:dio/dio.dart' as dio;

class BrandRepo  extends GetxController{
  static BrandRepo get instance => Get.find();
  final _database = FirebaseFirestore.instance;
  final _cloudinaryServices = Get.put(CloudinaryServices());
  Future<void> uploadBrands(List<BrandModel> brands) async{
    try {

      for(final brand in brands){

        File imageBrand = await UHelperFunctions.assetToFile(brand.image);

        dio.Response response = await _cloudinaryServices.uploadImage(imageBrand, UKeys.brandsFolder);

        if(response.statusCode == 200){

          brand.image = response.data['url'];
        }


        await _database.collection(UKeys.brandsCollection).doc(brand.id).set(brand.toJson());



      }

    } on FirebaseException catch(e){
      throw UFirebaseException(e.code).message;
    } on FormatException catch(_){
      throw UFormatException();
    } on PlatformException catch(e){
      throw UPlatformException(e.code).message;
    }catch(e){

      rethrow ;
    }
  }
  Future<List<BrandModel>> fetchBrands() async{
    try{

      final query = await _database.collection(UKeys.brandsCollection).get();



      if(query.docs.isNotEmpty){
        List<BrandModel> brands = query.docs.map((document)=>BrandModel.fromSnapshot(document)).toList();

        return brands;
      }
      return [];


    } on FirebaseException catch(e){
      throw UFirebaseException(e.code).message;
    } on FormatException catch(_){
      throw UFormatException();
    } on PlatformException catch(e){
      throw UPlatformException(e.code).message;
    }catch(e,s){

      rethrow;
    }
  }

  Future<List<BrandModel>> fetchBrandsForCategory(String categoryId) async{
    try{

      final brandCategoryQuery = await _database.collection(UKeys.brandCategoryCollection).where('categoryId',isEqualTo:categoryId ).get();



      List<BrandCategoryModel> brandCategories = brandCategoryQuery.docs.map((doc)=> BrandCategoryModel.fromSnapshot(doc)).toList();

      if (brandCategoryQuery.docs.isEmpty) return [];
      List<String> brandIds =
      brandCategories
          .map((e) => e.brandId.toString())
          .toSet()
          .toList();
      if (brandIds.isEmpty) return [];

      final allBrands = await _database
          .collection(UKeys.brandsCollection)
          .limit(3)
          .get();


      final brandsQuery = await _database.collection(UKeys.brandsCollection).where(FieldPath.documentId,whereIn: brandIds).get();

      List<BrandModel> brands = brandsQuery.docs.map((doc)=> BrandModel.fromSnapshot(doc)).toList();
      return brands;


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