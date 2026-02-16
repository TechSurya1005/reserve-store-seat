import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'AppColors.dart';

class MyTextTheme {
  MyTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    displayLarge: _style(AppColors.text, 96.0, FontWeight.w100),
    displayMedium: _style(AppColors.text, 60.0, FontWeight.w300),
    displaySmall: _style(AppColors.text, 48.0, FontWeight.w400),

    headlineLarge: _style(AppColors.text, 34.0, FontWeight.w600),
    headlineMedium: _style(AppColors.text, 24.0, FontWeight.w600),
    headlineSmall: _style(AppColors.text, 20.0, FontWeight.w500),

    titleLarge: _style(AppColors.text, 18.0, FontWeight.w500),
    titleMedium: _style(AppColors.text, 16.0, FontWeight.w500),
    titleSmall: _style(AppColors.subTitle, 14.0, FontWeight.w400),

    bodyLarge: _style(AppColors.text, 16.0, FontWeight.w400),
    bodyMedium: _style(AppColors.text, 14.0, FontWeight.w400),
    bodySmall: _style(AppColors.subTitle, 12.0, FontWeight.w400),

    labelLarge: _style(AppColors.text, 14.0, FontWeight.w600),
    labelMedium: _style(AppColors.subTitle, 12.0, FontWeight.w500),
    labelSmall: _style(AppColors.hintColor, 10.0, FontWeight.w400),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: _style(AppColors.textDark, 96.0, FontWeight.w100),
    displayMedium: _style(AppColors.textDark, 60.0, FontWeight.w300),
    displaySmall: _style(AppColors.textDark, 48.0, FontWeight.w400),

    headlineLarge: _style(AppColors.textDark, 34.0, FontWeight.w600),
    headlineMedium: _style(AppColors.textDark, 24.0, FontWeight.w600),
    headlineSmall: _style(AppColors.textDark, 20.0, FontWeight.w500),

    titleLarge: _style(AppColors.textDark, 18.0, FontWeight.w500),
    titleMedium: _style(AppColors.textDark, 16.0, FontWeight.w500),
    titleSmall: _style(AppColors.subTitle, 14.0, FontWeight.w400),

    bodyLarge: _style(AppColors.textDark, 16.0, FontWeight.w400),
    bodyMedium: _style(AppColors.textDark, 14.0, FontWeight.w400),
    bodySmall: _style(AppColors.subTitle, 12.0, FontWeight.w400),

    labelLarge: _style(AppColors.textDark, 14.0, FontWeight.w600),
    labelMedium: _style(AppColors.subTitle, 12.0, FontWeight.w500),
    labelSmall: _style(AppColors.hintColor, 10.0, FontWeight.w400),
  );

  static TextStyle _style(
    Color color,
    double size, [
    FontWeight weight = FontWeight.normal,
    FontStyle style = FontStyle.normal,
  ]) {
    return TextStyle(
      fontFamily: "Roboto",
      color: color,
      fontSize: size.sp,
      fontWeight: weight,
      fontStyle: style,
      letterSpacing: 0.0,
    );
  }
}
