import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shop/data/services/cloudinary_services.dart';
import 'package:shop/features/shop/models/category_model.dart';
import 'package:shop/features/shop/models/product_category_model.dart';
import 'package:shop/utils/constants/keys.dart';
import 'package:shop/utils/helpers/helper_function.dart';


import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import 'package:dio/dio.dart' as dio;

class CategoryRepo extends GetxController{
  static CategoryRepo get instance => Get.find();
  final _database = FirebaseFirestore.instance;
  final _cloudinaryServices = Get.put(CloudinaryServices());
  Future<void> uploadBrandCategory(List<CategoryModel> brandCategories) async{
    try{
      for(final brandCategory in brandCategories) {
        await _database.collection(UKeys.brandsCollection).doc().set(
            brandCategory.toJson());
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

  Future<void> uploadProductCategory(List<ProductCategoryModel> productCategories) async{
    try{
      for(final productCategory in productCategories) {
        await _database.collection(UKeys.productCategoryCollection).doc().set(
            productCategory.toJson());

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

  Future<void> uploadCategories(List<CategoryModel> categories) async{
    try {

      for(final category in categories){
       File image = await UHelperFunctions.assetToFile(category.image);
       dio.Response response = await _cloudinaryServices.uploadImage(image, UKeys.categoryFolder);
       if(response.statusCode == 200){
         category.image = response.data['url'];
       }
       await _database.collection(UKeys.categoryCollection).doc(category.id).set(category.toJson());
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

  Future<List<CategoryModel>> getAllCategories() async{
    try{
     final query = await _database.collection(UKeys.categoryCollection).get();
     if(query.docs.isNotEmpty){
       List<CategoryModel> categories = query.docs.map((document)=>CategoryModel.fromSnapshot(document)).toList();

       return categories;
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

  Future<List<CategoryModel>> getSubCategories(String categoryId) async{
    try{
      final query = await _database.collection(UKeys.categoryCollection).where('parentId',isEqualTo: categoryId).get();
      if(query.docs.isNotEmpty){
        List<CategoryModel> categories = query.docs.map((document)=>CategoryModel.fromSnapshot(document)).toList();

        return categories;
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