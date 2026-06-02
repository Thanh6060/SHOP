import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shop/data/responsibilities/authentication_repo.dart';
import 'package:shop/data/services/branch_services.dart';
import 'package:shop/utils/constants/keys.dart';


import 'firebase_options.dart';
import 'my_app.dart';

Future<void> main() async{
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await GetStorage.init();
  Get.put(BranchServices().initBranch());
  Stripe.publishableKey = UKeys.stripePublishableKey;


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value){
    Get.put(AuthenticationRepo());
  });

  await GoogleSignIn.instance.initialize(
    serverClientId: '266676887884-6r1bveu67r9ck4leub2kfo5kduje8g56.apps.googleusercontent.com',
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
      DevicePreview(
        enabled: true,
        builder: (context)=> const MyApp(),)
  );
}
