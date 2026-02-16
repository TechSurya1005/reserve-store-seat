import 'package:flutter/material.dart';
import 'package:quickseatreservation/app/theme/AppColors.dart';
import 'package:quickseatreservation/app/theme/AppRadius.dart';

class AppDecorations {
  static BoxDecoration topRoundedContainer({
    Color? color,
    double radius = AppRadius.lg,
  }) {
    return BoxDecoration(
      color: color ?? Colors.grey.shade50,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      ),
    );
  }

  static BoxDecoration allRoundedContainer({
    Color? color,
    double radius = AppRadius.md,
  }) {
    return BoxDecoration(
      color: color ?? AppColors.cardBackground,
      borderRadius: BorderRadius.circular(radius),
    );
  }

  static BoxDecoration commonCardDecoration({
    double borderRadius = AppRadius.xl,
    Color backgroundColor = AppColors.cardBackground,
    Color borderColor = AppColors.border,
    double borderWidth = 1.0,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: backgroundColor,
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: boxShadow ?? null,
    );
  }

  static BoxDecoration bottomRoundedContainer({
    Color? color,
    double radius = AppRadius.md,
  }) {
    return BoxDecoration(
      color: color ?? AppColors.darkScaffoldBackground,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      ),
    );
  }
}
