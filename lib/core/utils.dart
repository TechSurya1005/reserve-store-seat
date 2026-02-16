import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:quickseatreservation/app/theme/AppColors.dart';
import 'package:quickseatreservation/app/theme/AppRadius.dart';
import 'package:quickseatreservation/app/theme/AppTextStyles.dart';
import 'package:quickseatreservation/app/widget/common/LoaderWidget.dart';
import 'package:quickseatreservation/features/splash/view/splashView.dart';

class Utils {
  static Completer<void>? _completer;

  /// Returns the keyboard height, or 0 if keyboard is closed
  static double keyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  /// Check if keyboard is open
  static bool isKeyboardOpen(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  /// Shows loading dialog and returns Completer
  static Completer<void> showLoadingDialogue({
    required BuildContext context,
    Color loaderColor = Colors.blue,
    String? message,
    bool barrierDismissible = false,
  }) {
    _closeDialog(); // Close any existing

    _completer = Completer<void>();

    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => PopScope(
        canPop: barrierDismissible,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Container(
              height: 150,
              // ✅ Fixed height
              width: 150,
              // ✅ Fixed width
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: LoaderWidget(color: loaderColor),
            ),
          ),
        ),
      ),
    );

    return _completer!;
  }

  /// Auto close dialog
  static void autoCloseDialogue() {
    _closeDialog();
  }

  /// Manual close
  static void closeLoadingDialogue() {
    _closeDialog();
  }

  static void _closeDialog() {
    if (_completer != null && !_completer!.isCompleted) {
      _completer!.complete();
    }
    _completer = null;
  }

  static void showToast({
    required String message,
    Color bgColor = Colors.black87,
    Color textColor = Colors.white,
    ToastGravity gravity = ToastGravity.BOTTOM,
    int timeInSec = 2,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: timeInSec,
      backgroundColor: bgColor,
      textColor: textColor,
      fontSize: 14.0,
    );
  }

  static void showLogout({
    String? type,
    required BuildContext context,
    required VoidCallback onLogout,
    required VoidCallback onTapCancel,
    String title = "Logout",
    String message = "Are you sure you want to log out?",
    String cancelText = "Cancel",
    String logoutText = "Logout",
    bool showPrivacyPolicy = true,
    String? subMessage,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Essential to fit content size
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  height: 35,
                  width: 35,
                  colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
                  type == "logOut"
                      ? "assets/svgs/logOut.svg"
                      : "assets/svgs/delete.svg",
                ),
                Gap(20),
                // 1. Title
                Text(
                  textAlign: TextAlign.center,
                  title,
                  style: AppTextStyle.labelLargeStyle(context),
                ),
                Gap(20),

                // 2. Subtitle/Message
                Text(
                  textAlign: TextAlign.center,
                  message,
                  style: AppTextStyle.labelMediumStyle(context),
                ),
                Gap(subMessage != null ? 10 : 1),
                subMessage != null
                    ? Text(
                        textAlign: TextAlign.center,
                        subMessage,
                        style: AppTextStyle.labelSmallStyle(
                          context,
                        ).copyWith(color: AppColors.subTitle),
                      )
                    : Offstage(),
                Gap(20),
                // 3. Action Buttons (Row)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // Cancel Button
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: onTapCancel,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border: Border.all(
                                width: 1,
                                color: AppColors.successColor,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                textAlign: TextAlign.center,
                                "Cancel",
                                style: AppTextStyle.labelMediumStyle(
                                  context,
                                ).copyWith(color: Colors.green),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Logout
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: onLogout,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              color: AppColors.errorColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                textAlign: TextAlign.center,
                                type == "logOut" ? "Log Out" : "Delete",
                                style: AppTextStyle.labelMediumStyle(
                                  context,
                                ).copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showDialogue({
    required BuildContext context,
    String? type,
    String title = "Message",
    String? subtitle,
    String? image,
    Color? textColor,
    String? primaryText,
    String? secondaryText,
    VoidCallback? onTap,
    VoidCallback? onCancel,
    bool showActions = true,
    Color? bgColor,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: bgColor ?? Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ICON / IMAGE
                if (image != null)
                  SvgPicture.asset(
                    image,
                    height: 48,
                    width: 48,
                    colorFilter: textColor != null
                        ? ColorFilter.mode(textColor, BlendMode.srcIn)
                        : const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  )
                else
                  Icon(
                    _getDialogIcon(type),
                    size: 48,
                    color: _getDialogColor(type),
                  ),
                const SizedBox(height: 20),

                // TITLE
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.labelLargeStyle(
                    context,
                  ).copyWith(color: textColor ?? Colors.black),
                ),

                if (subtitle != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.labelMediumStyle(
                      context,
                    ).copyWith(color: AppColors.subTitle),
                  ),
                ],

                const SizedBox(height: 20),

                // ACTION BUTTONS
                if (showActions)
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: onCancel ?? () => Navigator.pop(context),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.successColor,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                secondaryText ?? "Cancel",
                                style: AppTextStyle.labelMediumStyle(
                                  context,
                                ).copyWith(color: AppColors.successColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: onTap ?? () => Navigator.pop(context),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _getDialogColor(type),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                primaryText ??
                                    _getPrimaryButtonText(type) ??
                                    "OK",
                                style: AppTextStyle.labelMediumStyle(
                                  context,
                                ).copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper for icon
  static IconData _getDialogIcon(String? type) {
    switch (type) {
      case "error":
        return Icons.error_outline;
      case "success":
        return Icons.check_circle_outline;
      case "warning":
        return Icons.warning_amber_rounded;
      case "logOut":
        return Icons.logout;
      case "delete":
        return Icons.delete_forever;
      default:
        return Icons.info_outline;
    }
  }

  // Helper for color
  static Color _getDialogColor(String? type) {
    switch (type) {
      case "error":
        return Colors.red;
      case "success":
        return Colors.green;
      case "warning":
        return Colors.orange;
      case "logOut":
        return Colors.red;
      case "delete":
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  // Default primary button text
  static String? _getPrimaryButtonText(String? type) {
    switch (type) {
      case "logOut":
        return "Log Out";
      case "delete":
        return "Delete";
      default:
        return null;
    }
  }

  void restartApp(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SplashView()),
      (route) => false,
    );
  }

  static void showFeatureDialogue({
    required BuildContext context,
    required String title,
    required String message,
    String? image,
    Color? textColor,
    String okText = "OK",
    VoidCallback? onOk,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.darkCardBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // IMAGE
                if (image != null) Image.asset(image, height: 55, width: 55),

                const SizedBox(height: 20),

                // TITLE
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.labelLargeStyle(context),
                ),

                const SizedBox(height: 10),

                // MESSAGE
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.labelMediumStyle(
                    context,
                  ).copyWith(color: AppColors.subTitle),
                ),

                const SizedBox(height: 25),

                // FULL WIDTH OK BUTTON
                SizedBox(
                  width: double.infinity,
                  child: InkWell(
                    onTap: onOk ?? () => Navigator.pop(context),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: AppColors.buttonGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        okText,
                        style: AppTextStyle.labelMediumStyle(
                          context,
                        ).copyWith(color: AppColors.text),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
