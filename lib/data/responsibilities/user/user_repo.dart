
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shop/data/responsibilities/authentication_repo.dart';
import 'package:shop/data/services/cloudinary_services.dart';
import 'package:shop/features/authentication/model/user_model.dart';

import 'package:shop/utils/constants/keys.dart';

import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import 'package:dio/dio.dart' as dio;

class UserRepo extends GetxController{
  static UserRepo get instance => Get.find();
  final _database = FirebaseFirestore.instance;
  final _cloudinaryServices = Get.put(CloudinaryServices());

  Future<void> saveUserRecord(UserModel user) async{
    try{
     await _database.collection(UKeys.userCollection).doc(user.id).set(user.toJson());

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

  Future<UserModel> fetchUserDetails()async{
    try{
     final documentSnapShot = await _database.collection(UKeys.userCollection).doc(AuthenticationRepo.instance.currentUser!.uid).get();

     if(documentSnapShot.exists){
       UserModel user = UserModel.fromSnapshot(documentSnapShot);
       return user;
     }
     return UserModel.empty();


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
  Future<void> updateSingleField(Map<String,dynamic>  map )async{
    try{

      await _database.collection(UKeys.userCollection).doc(AuthenticationRepo.instance.currentUser!.uid).update(map);



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
  Future<void> removeUserRecord(String userId )async{
    try{
     await _database.collection(UKeys.userCollection).doc(userId).delete();



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
  Future<dio.Response> uploadImage(File image) async{
    try{
     dio.Response response = await _cloudinaryServices.uploadImage(image, UKeys.profileFolder );
      return response;

    }catch(e){

      throw "Failed to upload profile picture. Please TRY AGAIN";
    }
  }
  Future<dio.Response> deleteProfilePicture(String publicId)async{
    try {

      dio.Response response = await _cloudinaryServices.deleteImage(publicId);
      return response;
    }catch(e){
      throw ' Something went wrong.PLEASE TRY AGAIN';

    }
  }
}