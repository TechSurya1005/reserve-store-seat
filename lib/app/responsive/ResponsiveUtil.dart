import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quickseatreservation/app/responsive/screen_type.dart';

class ScreenBreakpoints {
  static const double mobileMax = 767;
  static const double tabletMin = 768;
  static const double tabletMax = 1279;
  static const double desktopMin = 1280;
}

class ResponsiveUtil {
  static AppScreenType getScreenType(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    return _getScreenTypeFromWidth(width);
  }

  static AppScreenType getScreenTypeFromConstraints(
    BoxConstraints constraints,
  ) {
    final width = constraints.maxWidth;
    return _getScreenTypeFromWidth(width);
  }

  static AppScreenType _getScreenTypeFromWidth(double width) {
    if (width <= ScreenBreakpoints.mobileMax) {
      return AppScreenType.mobile;
    } else if (width >= ScreenBreakpoints.tabletMin &&
        width <= ScreenBreakpoints.tabletMax) {
      return AppScreenType.tablet;
    } else {
      return AppScreenType.desktop;
    }
  }

  static bool isVerticalLayout(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  static bool isHorizontalLayout(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  static bool isMobile(BuildContext context) =>
      getScreenType(context) == AppScreenType.mobile;

  static bool isTablet(BuildContext context) =>
      getScreenType(context) == AppScreenType.tablet;

  static bool isDesktop(BuildContext context) =>
      getScreenType(context) == AppScreenType.desktop;

  static bool isWeb(BuildContext context) => kIsWeb;

  static double getHorizontalPadding(BuildContext context) {
    final screenType = getScreenType(context);
    switch (screenType) {
      case AppScreenType.mobile:
        return 16.0;
      case AppScreenType.tablet:
        return 32.0;
      case AppScreenType.desktop:
        return 48.0;
      default:
        return 16.0;
    }
  }

  static int getGridColumns(
    BuildContext context, {
    int mobileColumns = 2,
    int tabletColumns = 3,
    int desktopColumns = 4,
  }) {
    final screenType = getScreenType(context);
    switch (screenType) {
      case AppScreenType.mobile:
        return mobileColumns;
      case AppScreenType.tablet:
        return tabletColumns;
      case AppScreenType.desktop:
        return desktopColumns;
      default:
        return mobileColumns;
    }
  }

  static double getMaxContentWidth(BuildContext context) {
    final screenType = getScreenType(context);
    switch (screenType) {
      case AppScreenType.mobile:
        return double.infinity;
      case AppScreenType.tablet:
        return 800;
      case AppScreenType.desktop:
        return 1200;
      default:
        return double.infinity;
    }
  }

  static double getFontScale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width <= ScreenBreakpoints.mobileMax) {
      return 1.0;
    } else if (width <= ScreenBreakpoints.tabletMax) {
      return 1.1;
    } else {
      return 1.2;
    }
  }
}

extension ResponsiveContext on BuildContext {
  AppScreenType get screenType => ResponsiveUtil.getScreenType(this);

  bool get isMobile => ResponsiveUtil.isMobile(this);

  bool get isTablet => ResponsiveUtil.isTablet(this);

  bool get isDesktop => ResponsiveUtil.isDesktop(this);

  bool get isPortrait => ResponsiveUtil.isVerticalLayout(this);

  bool get isLandscape => ResponsiveUtil.isHorizontalLayout(this);

  double get responsivePadding => ResponsiveUtil.getHorizontalPadding(this);

  double get maxContentWidth => ResponsiveUtil.getMaxContentWidth(this);
}
