import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickseatreservation/app/theme/themController.dart';

extension ThemeContext on BuildContext {
  bool get isDarkTheme => Provider.of<ThemeController>(this).isDark;
}
