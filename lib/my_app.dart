import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/bindings/bindings.dart';

import 'package:shop/routes/app_routes.dart';


import 'package:shop/utils/theme/theme.dart';

import 'loading.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      themeMode: ThemeMode.system,
      theme: UAppTheme.lightTheme,
      darkTheme: UAppTheme.darkTheme,
      getPages: UAppRoutes.screens,
      initialBinding: UBindings(),
      home: LoadingScreen(),
    );
  }
}

