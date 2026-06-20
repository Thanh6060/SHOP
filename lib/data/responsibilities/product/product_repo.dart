import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shop/utils/constants/keys.dart';
import 'package:shop/utils/helpers/helper_function.dart';

import '../../../features/shop/models/product_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../services/cloudinary_services.dart';
import 'package:dio/dio.dart ' as dio;

class ProductRepo extends GetxController{
  static ProductRepo get instance => Get.find();
  final _database = FirebaseFirestore.instance;
  final _cloudinaryServices = Get.put(CloudinaryServices());
  Future<void> uploadProducts(List<ProductModel> products) async{
    try {
      for(ProductModel product in products){
        final Map<String,String> uploadingImageMap = {};


        File thumbnailFile = await UHelperFunctions.assetToFile(product.thumbnail);
        dio.Response response =  await _cloudinaryServices.uploadImage(thumbnailFile, UKeys.productsFolder);


        if(response.statusCode == 200){
          String url = response.data['url'];
          uploadingImageMap[product.thumbnail] = url;
          product.thumbnail = url;
        }
        if(product.images != null && product.images!.isNotEmpty){
          List<String> imageUrls = [];
          for(String image in product.images!){
            File imageFile = await UHelperFunctions.assetToFile(image);
            dio.Response response =  await _cloudinaryServices.uploadImage(imageFile, UKeys.productsFolder);


            if(response.statusCode == 200){
              imageUrls.add(response.data['url']);
            }
          }
          if(product.productVariations != null && product.productVariations!.isNotEmpty){

            for(int i=0; i< product.images!.length; i++){
              uploadingImageMap[product.images![i]] = imageUrls[i];
            }

            for(final variation in product.productVariations!){
              final match = uploadingImageMap.entries.firstWhere(
                  (entry) => entry.key == variation.image,
                orElse: ()=> const MapEntry('', ''),
              );
              if(match.key.isNotEmpty){
                variation.image = match.value;
              }
            }
          }

         product.images!.clear();
          product.images!.assignAll(imageUrls);

        }
      await  _database.collection(UKeys.productsCollection).doc(product.id).set(product.toJson());
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
  Future<List<ProductModel>> fetchAllProduct()async {
    try{
      final query = await _database.collection(UKeys.productsCollection).get();

      if(query.docs.isNotEmpty){
        List<ProductModel> products = query.docs.map((document)=> ProductModel.fromSnapshot(document)).toList();
        return products;
      }
      return [];

    } on FirebaseException catch(e){
      throw UFirebaseException(e.code).message;
    } on FormatException catch(_){
      throw UFormatException();
    } on PlatformException catch(e){
      throw UPlatformException(e.code).message;
    }catch(e){
      print('lỗi : $e');
      throw "Something went wrong. Please try again";
    }

  }
  Future<ProductModel> fetchSingleProduct(String productId)async {
    try{
      final query = await _database.collection(UKeys.productsCollection).doc(productId).get();
      if(query.id .isNotEmpty){
        ProductModel product = ProductModel.fromSnapshot(query);
        return product;
      }
      return ProductModel.empty();

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
  Future<List<ProductModel>> fetchFeaturedProducts() async{
    try {


     final query = await _database.collection(UKeys.productsCollection).where('isFeatured',isEqualTo: true).limit(4).get();



     if(query.docs.isNotEmpty){
     List<ProductModel> products =   query.docs.map((document)=>ProductModel.fromSnapshot(document)).toList();
    return products;
     }
     return [];
      




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
  Future<List<ProductModel>> fetchAllFeaturedProducts() async{
    try {


      final query = await _database.collection(UKeys.productsCollection).where('isFeatured',isEqualTo: true).get();


      if(query.docs.isNotEmpty){
        List<ProductModel> products =   query.docs.map((document)=>ProductModel.fromSnapshot(document)).toList();
        return products;
      }
      return [];





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
  Future<List<ProductModel>> fetchProductsByQuery(Query query) async{
    try {


      final querySnapshot = await query.get();


      if(querySnapshot.docs.isNotEmpty){
        List<ProductModel> products =   querySnapshot.docs.map((document)=>ProductModel.fromQuerySnapshot(document)).toList();
        return products;
      }
      return [];





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

  Future<List<ProductModel>> getProductsForBrand({required String brandId,int limit = -1}) async {
    try {

      final query = (limit == -1 || limit <= 0)
          ? await _database.collection(UKeys.productsCollection).where('brand.id',isEqualTo: brandId).get()
          : await _database.collection(UKeys.productsCollection).where('brand.id',isEqualTo: brandId).limit(limit).get()
      ;


      if(query.docs.isNotEmpty){
        List<ProductModel> products =   query.docs.map((document)=>ProductModel.fromSnapshot(document)).toList();
        return products;
      }
      return [];
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
  Future<List<ProductModel>> getProductsForCategory({required String categoryId,int? limit }) async {
    try {


      final productCategoryQuery = (limit != null && limit > 0)
          ? await _database.collection(UKeys.productCategoryCollection).where('categoryId',isEqualTo: categoryId).limit(limit).get()
          : await _database.collection(UKeys.productCategoryCollection).where('categoryId',isEqualTo: categoryId).get()

      ;


      List<String> productIds = productCategoryQuery.docs
          .map((doc) => (doc.data()['productId'] ?? '').toString())
          .where((id) => id.isNotEmpty).toSet()
          .toList();


      productIds = productIds.where((e) => e.trim().isNotEmpty).toList();

      if (productIds.isEmpty) {

        return [];
      }

      if (productIds.length > 10) {
        productIds = productIds.sublist(0, 10);
      }

      final productQuery  = await _database.collection(UKeys.productsCollection).where(FieldPath.documentId,whereIn: productIds).get();





      List<ProductModel> products = productQuery.docs.map((doc)=>ProductModel.fromSnapshot(doc)).toList();

      return products;


    } on FirebaseException catch(e){
      throw UFirebaseException(e.code).message;
    } on FormatException catch(_){
      throw UFormatException();
    } on PlatformException catch(e){
      throw UPlatformException(e.code).message;
    }catch(e){
      print(' LỖI ĐÃ ĐƯỢC CHẶN TẠI REPO: $e');
      return [];
    }
  }

  Future<List<ProductModel>> getFavouriteProducts(List<String> productIds) async{
    try {
      if (productIds.isEmpty) return [];


      final query = await _database.collection(UKeys.productsCollection).where(FieldPath.documentId,whereIn: productIds).get();


      if(query.docs.isNotEmpty){
        List<ProductModel> products = query.docs.map((document)=>ProductModel.fromSnapshot(document)).toList();
        return products;
      }
      return [];





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