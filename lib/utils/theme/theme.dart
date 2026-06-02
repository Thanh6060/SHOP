import 'package:flutter/material.dart';
import 'package:shop/utils/theme/widgets/appbar_theme.dart';
import 'package:shop/utils/theme/widgets/bottom_sheet_theme.dart';
import 'package:shop/utils/theme/widgets/checkbox_theme.dart';
import 'package:shop/utils/theme/widgets/chip_theme.dart';
import 'package:shop/utils/theme/widgets/elevated_button_theme.dart';
import 'package:shop/utils/theme/widgets/outlined_button_theme.dart';
import 'package:shop/utils/theme/widgets/text_field_theme.dart';
import 'package:shop/utils/theme/widgets/text_theme.dart';

import '../constants/colors.dart';

class UAppTheme{
  UAppTheme._();
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Nunito',
    brightness: Brightness.light,
    primaryColor: UColors.primary,
    disabledColor: UColors.grey,
    textTheme: UTextTheme.lightTextTheme,
    chipTheme: UChipTheme.lightChipTheme,
    scaffoldBackgroundColor: UColors.white,
    appBarTheme: UAppBarTheme.lightAppBarTheme,
    checkboxTheme: UCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: UBottomSheetTheme.lightBottomSheetTheme,
   elevatedButtonTheme: UElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: UOutlinedButtonTheme.lightOutlinedButtonTheme,
   inputDecorationTheme: UTextFormFieldTheme.lightInputDecorationTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Nunito',
    brightness: Brightness.dark,
    primaryColor: UColors.primary,
    disabledColor: UColors.grey,
    textTheme: UTextTheme.darkTextTheme,
   chipTheme: UChipTheme.darkChipTheme,
    scaffoldBackgroundColor: UColors.black,
    appBarTheme: UAppBarTheme.darkAppBarTheme,
    checkboxTheme: UCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: UBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: UElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: UOutlinedButtonTheme.darkOutlinedButtonTheme,
   inputDecorationTheme: UTextFormFieldTheme.darkInputDecorationTheme,
  );
}