

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';


import 'package:shop/data/responsibilities/user/user_repo.dart';
import 'package:shop/features/authentication/screens/login/login.dart';
import 'package:shop/features/authentication/screens/onboarding/onboarding.dart';
import 'package:shop/features/authentication/screens/signup/verify_email.dart';
import 'package:shop/features/personalization/controllers/user_controller.dart';
import 'package:shop/navigation_menu.dart';
import 'package:shop/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:shop/utils/exceptions/format_exceptions.dart';
import 'package:shop/utils/exceptions/platform_exceptions.dart';



import '../../utils/exceptions/firebase_exceptions.dart';



class AuthenticationRepo extends GetxController{
  static AuthenticationRepo get instance => Get.find();





  final localStorage = GetStorage();
  final storage = GetStorage('userId');
  final _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
  @override
  void onReady() {
      FlutterNativeSplash.remove();
      screenRedirect();




  }
  Future<void> screenRedirect( ) async{
    final user = _auth.currentUser;
    if(user != null ){
      if(user.emailVerified){
        Get.offAll(()=>NavigationMenu());
        await GetStorage.init(user.uid);
      }else{
        Get.offAll(()=>VerifyEmailScreen(email: user.email,));
      }
    }else{
      localStorage.writeIfNull("isFirstTime", true);
      localStorage.read("isFirstTime") != true
          ? Get.offAll(()=> LoginScreen())
          : Get.offAll(()=> OnboardingScreen());
    }

  }

  Future<UserCredential> registerUser(String email,String password) async {
    try{
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return userCredential;
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

  Future<UserCredential> loginWithEmailAndPassword(String email,String password) async {
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
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
  Future<UserCredential> signInWithFacebook() async{
    try{
      final FacebookLoginResult result = await FacebookLogin().logIn(permissions: [FacebookPermission.publicProfile,FacebookPermission.email]);
      final FacebookAccessToken accessToken = result.accessToken!;
      final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.token);
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential;


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
  Future<UserCredential> signInWithGoogle() async {
    try{
      final GoogleSignInAccount googleAccount = await GoogleSignIn.instance.authenticate();

     final GoogleSignInAuthentication googleAuth = googleAccount.authentication;


     final OAuthCredential credential = GoogleAuthProvider.credential(
       idToken: googleAuth.idToken,
       accessToken: null
     );


    UserCredential userCredential = await _auth.signInWithCredential(credential);
    return userCredential;


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
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser!.sendEmailVerification();

    }on FirebaseAuthException catch(e){
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
  Future<void> sendPasswordResetEmail(String email) async {
    try {
    await _auth.sendPasswordResetEmail(email: email);

    }on FirebaseAuthException catch(e){
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
  Future<void> reAuthenticateEmailAndPassword(String email,String password) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
      await currentUser!.reauthenticateWithCredential(credential);


    }on FirebaseAuthException catch(e){
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
  Future<void> logout() async {
    try {
     await FirebaseAuth.instance.signOut();
     await GoogleSignIn.instance.signOut();
     Get.offAll(()=>LoginScreen());

    }on FirebaseAuthException catch(e){
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

  Future<void> deleteAccount() async {
    try {
      await UserRepo.instance.removeUserRecord(currentUser!.uid);
      String publicId = UserController.instance.user.value.publicId;
      if(publicId.isNotEmpty){
        UserRepo.instance.deleteProfilePicture(publicId);
      }
      await _auth.currentUser?.delete();



    }on FirebaseAuthException catch(e){
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