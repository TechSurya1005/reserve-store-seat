import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickseatreservation/app/theme/AppColors.dart';

class MyTheme {
  MyTheme._();

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      brightness: Brightness.light,

      scaffoldBackgroundColor: AppColors.scaffoldBackground,

      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.accent,
        onSecondary: Colors.black,
        surface: AppColors.cardBackground,
        onSurface: AppColors.text,
        error: AppColors.errorColor,
        onError: Colors.white,
        outline: AppColors.border,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.scaffoldBackground,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.scaffoldBackground,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBackground,
        hintStyle: TextStyle(color: AppColors.subTitle),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),

      iconTheme: IconThemeData(color: AppColors.iconLightColor),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      brightness: Brightness.dark,

      scaffoldBackgroundColor: AppColors.darkScaffoldBackground,

      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.textDark,
        secondary: AppColors.accent,
        onSecondary: Colors.black,
        surface: AppColors.cardBackground,
        onSurface: AppColors.textDark,
        error: AppColors.errorColor,
        onError: Colors.white,
        outline: AppColors.border,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkCardBackground,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.darkCardBackground,
          statusBarIconBrightness: Brightness.light,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.secondary,
        hintStyle: TextStyle(color: AppColors.subTitle),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),

      iconTheme: IconThemeData(color: AppColors.iconDarkColor),
    );
  }
}
