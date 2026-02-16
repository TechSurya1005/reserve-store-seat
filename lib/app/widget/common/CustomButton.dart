import 'package:quickseatreservation/app/theme/AppColors.dart';
import 'package:quickseatreservation/app/theme/AppRadius.dart';
import 'package:quickseatreservation/app/theme/AppSizes.dart';
import 'package:quickseatreservation/app/theme/AppSpacing.dart';
import 'package:quickseatreservation/app/theme/AppTextStyles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? height;
  final double? width;
  final double borderRadius;
  final bool isExpanded;
  final bool isLoading;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isDisabled;

  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.height,
    this.width,
    this.borderRadius = AppRadius.button,
    this.isExpanded = false,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isExpanded ? double.infinity : width,
      height: height ?? AppSizes.buttonHeightMd,
      child: ElevatedButton(
        onPressed: isDisabled || isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.transparent,
          foregroundColor: _getTextColor(context),
          disabledBackgroundColor: AppColors.hintColor.withValues(alpha: 0.3),
          disabledForegroundColor: AppColors.text.withValues(alpha: 0.5),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: _getBorderColor(context),
              width: AppRadius.md,
            ),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: _getGradient(context),
            color: gradient == null
                ? (isDisabled ? AppColors.disableColor : backgroundColor)
                : null,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Container(
            constraints: BoxConstraints(
              minWidth: isExpanded ? double.infinity : 0,
              minHeight: height ?? AppSizes.buttonHeightMd,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.spaceLg,
              vertical: AppSpacing.spaceSm,
            ),
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
                    width: AppSizes.iconSm,
                    height: AppSizes.iconSm,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _getTextColor(context),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (prefixIcon != null) ...[
                        prefixIcon!,
                        SizedBox(width: AppSpacing.spaceSm),
                      ],
                      Text(
                        title,
                        style: AppTextStyle.buttonStyle(context).copyWith(
                          color: _getTextColor(context),
                          fontWeight: FontWeight.w600,
                          fontSize: AppSpacing.spaceLg,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (suffixIcon != null) ...[
                        SizedBox(width: AppSpacing.spaceSm),
                        suffixIcon!,
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Gradient? _getGradient(BuildContext context) {
    if (backgroundColor != null) return null;
    if (isDisabled) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.grey.shade400, Colors.grey.shade500],
      );
    }

    return gradient ?? AppColors.ktGradient; // default fallback
  }

  Color _getTextColor(BuildContext context) {
    if (isDisabled) return AppColors.textDark;
    return textColor ?? AppColors.textDark;
  }

  Color _getBorderColor(BuildContext context) {
    if (isDisabled) return AppColors.border;
    return borderColor ?? Colors.transparent;
  }
}
