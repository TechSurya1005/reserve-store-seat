import 'package:flutter/cupertino.dart';
import 'package:quickseatreservation/app/constants/AppKeys.dart';
import 'package:quickseatreservation/core/prefs/PrefsHelper.dart';

class ThemeController extends ChangeNotifier {
  bool _isDark = true;

  bool get isDark => _isDark;

  ThemeController() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _isDark = PrefsHelper.getBool(AppKeys.appTheme) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDark = !_isDark;
    await PrefsHelper.setBool(AppKeys.appTheme, _isDark);
    notifyListeners();
  }
}
