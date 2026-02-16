import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickseatreservation/app/responsive/ResponsiveUtil.dart';
import 'package:quickseatreservation/app/responsive/screen_type.dart';
import 'package:quickseatreservation/app/theme/AppColors.dart';

class AppTextStyle {
  static Color _textColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? AppColors.textDark
      : AppColors.text;

  static double responsiveFontSize(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    final screenType = ResponsiveUtil.getScreenType(context);
    switch (screenType) {
      case AppScreenType.mobile:
        return mobile.sp;
      case AppScreenType.tablet:
        return tablet.sp;
      case AppScreenType.desktop:
        return desktop.sp;
      default:
        return mobile.sp;
    }
  }

  static double _scale(BuildContext context) =>
      ResponsiveUtil.getFontScale(context);

  static TextStyle _base(
    BuildContext context, {
    required double size,
    FontWeight weight = FontWeight.w400,
    double letterSpacing = 0.2,
    double height = 1.125,
  }) {
    return TextStyle(
      fontFamily: 'Roboto',
      color: _textColor(context),
      fontSize: size * _scale(context),
      fontWeight: weight,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle displayLargeStyle(BuildContext context) => _base(
    context,
    size: responsiveFontSize(context, mobile: 32, tablet: 36, desktop: 40),
    weight: FontWeight.w700,
  );

  static TextStyle displayMediumStyle(BuildContext context) => _base(
    context,
    size: responsiveFontSize(context, mobile: 26, tablet: 30, desktop: 34),
    weight: FontWeight.w700,
  );

  static TextStyle displaySmallStyle(BuildContext context) => _base(
    context,
    size: responsiveFontSize(context, mobile: 22, tablet: 24, desktop: 28),
    weight: FontWeight.w700,
  );

  static TextStyle headlineLargeStyle(BuildContext context) => _base(
    context,
    size: responsiveFontSize(context, mobile: 24, tablet: 26, desktop: 30),
    weight: FontWeight.w800,
  );

  static TextStyle headlineMediumStyle(BuildContext context) => _base(
    context,
    size: responsiveFontSize(context, mobile: 20, tablet: 22, desktop: 24),
    weight: FontWeight.w800,
  );

  static TextStyle headlineSmallStyle(BuildContext context) => _base(
    context,
    size: responsiveFontSize(context, mobile: 18, tablet: 20, desktop: 22),
    weight: FontWeight.w800,
  );

  static TextStyle titleLargeStyle(BuildContext context) => _base(
    context,
    size: responsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
    weight: FontWeight.w600,
  );

  static TextStyle titleMediumStyle(BuildContext context) => _base(
    context,
    size: responsiveFontSize(context, mobile: 14, tablet: 16, desktop: 18),
    weight: FontWeight.w500,
  );

  static TextStyle titleSmallStyle(BuildContext context) => _base(
    context,
    size: responsiveFontSize(context, mobile: 13, tablet: 14, desktop: 15),
    weight: FontWeight.w500,
  );

  static TextStyle bodyLargeStyle(BuildContext context) => _base(
    context,
    size: responsiveFontSize(context, mobile: 14, tablet: 15, desktop: 16),
  );

  static TextStyle bodyMediumStyle(BuildContext context) => _base(
    context,
    size: responsiveFontSize(context, mobile: 13, tablet: 14, desktop: 15),
  );

  static TextStyle bodySmallStyle(BuildContext context) => _base(
    context,
    size: responsiveFontSize(context, mobile: 11, tablet: 12, desktop: 13),
  );

  static TextStyle labelLargeStyle(BuildContext context) => _base(
    context,
    size: responsiveFontSize(context, mobile: 14, tablet: 15, desktop: 16),
    weight: FontWeight.w600,
  );

  static TextStyle labelMediumStyle(BuildContext context) => _base(
    context,
    size: responsiveFontSize(context, mobile: 13, tablet: 14, desktop: 15),
  );

  static TextStyle labelSmallStyle(BuildContext context) => _base(
    context,
    size: responsiveFontSize(context, mobile: 11, tablet: 12, desktop: 13),
  );

  static TextStyle buttonStyle(BuildContext context) => _base(
    context,
    size: responsiveFontSize(context, mobile: 15, tablet: 16, desktop: 17),
    weight: FontWeight.w600,
  );

  static TextStyle captionStyle(BuildContext context) => _base(
    context,
    size: responsiveFontSize(context, mobile: 11, tablet: 12, desktop: 13),
  );

  static TextStyle overlineStyle(BuildContext context) => _base(
    context,
    size: responsiveFontSize(context, mobile: 10, tablet: 11, desktop: 12),
    weight: FontWeight.w500,
  );

  static TextStyle customStyle(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
    FontWeight weight = FontWeight.w400,
    double height = 1.25,
    double letterSpacing = 0.2,
  }) {
    return _base(
      context,
      size: responsiveFontSize(
        context,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      ),
      weight: weight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}
