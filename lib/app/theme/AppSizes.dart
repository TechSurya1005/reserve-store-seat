import 'package:flutter/material.dart';

class AppSizes {
  // === Button Heights ===
  static const double buttonHeightXs = 32.0;
  static const double buttonHeightSm = 40.0;
  static const double buttonHeightMd = 48.0;
  static const double buttonHeightLg = 56.0;
  static const double buttonHeightXl = 64.0;

  // === TextField Heights ===
  static const double textFieldHeightSm = 40.0;
  static const double textFieldHeightMd = 48.0;
  static const double textFieldHeightLg = 56.0;

  // === AppBar Heights ===
  static const double appBarHeightMobile = 56.0;
  static const double appBarHeightTablet = 64.0;
  static const double appBarHeightDesktop = 72.0;

  // === Navigation Heights ===
  static const double bottomNavBarHeight = 56.0;
  static const double navBarItemHeight = 40.0;

  // === Dialog & Snackbar Heights ===
  static const double snackBarHeight = 48.0;

  // === Progress Indicator Heights ===
  static const double progressIndicatorSm = 16.0;
  static const double progressIndicatorMd = 24.0;
  static const double progressIndicatorLg = 32.0;
  static const double progressIndicatorXl = 40.0;

  // === Chip Heights ===
  static const double chipHeightSm = 24.0;
  static const double chipHeightMd = 32.0;
  static const double chipHeightLg = 40.0;

  // === Floating Action Button Heights ===
  static const double fabSizeSm = 40.0;
  static const double fabSizeMd = 56.0;
  static const double fabSizeLg = 64.0;

  // === Swipe Card Heights ===
  static const double swipeCardHeightMobile = 480.0;
  static const double swipeCardHeightTablet = 560.0;

  // === Action Button Heights (Like/Nope) ===
  static const double actionButtonHeightSm = 48.0;
  static const double actionButtonHeightMd = 56.0;
  static const double actionButtonHeightLg = 64.0;
  static const double actionButtonHeightXl = 72.0;

  // === Profile Image Heights ===
  static const double profileImageHeightXs = 40.0;
  static const double profileImageHeightSm = 60.0;
  static const double profileImageHeightMd = 80.0;
  static const double profileImageHeightLg = 100.0;
  static const double profileImageHeightXl = 120.0;
  static const double profileImageHeightXxl = 150.0;
  static const double profileImageHeightXxxl = 170.0;
  static const double profileImageHeightXxxxl = 200.0;
  static const double profileImageHeightXxxxxl = 250.0;

  // === Card Heights ===
  static const double cardHeightXs = 40.0;
  static const double cardHeightSm = 60.0;
  static const double cardHeightMd = 80.0;
  static const double cardHeightLg = 100.0;
  static const double cardHeightXl = 120.0;
  static const double cardHeightXxl = 150.0;
  static const double cardHeightXxxl = 170.0;
  static const double cardHeightXxxxl = 200.0;
  static const double cardHeightXxxxxl = 250.0;
  static const double cardHeightXxxxxxl = 300.0;

  // === Icon Sizes ===
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;
  static const double iconXxl = 40.0;
  static const double iconXxxl = 48.0;

  // === Responsive Height Helper ===
  static double responsiveHeight(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1024) return desktop;
    if (width > 600) return tablet;
    return mobile;
  }

  static double getAppBarHeight(BuildContext context) {
    return responsiveHeight(
      context,
      mobile: appBarHeightMobile,
      tablet: appBarHeightTablet,
      desktop: appBarHeightDesktop,
    );
  }

  static double getSwipeCardHeight(BuildContext context) {
    return responsiveHeight(
      context,
      mobile: swipeCardHeightMobile,
      tablet: swipeCardHeightTablet,
      desktop: swipeCardHeightTablet,
    );
  }
}
