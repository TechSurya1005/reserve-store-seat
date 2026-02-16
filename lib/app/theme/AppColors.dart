import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2D6CDF);
  static const Color primaryDark = Color(0xFF1A4FA0);
  static const Color primaryLight = Color(0xFF5A95F5);

  static const Color secondary = Color(0xFF6F42C1);
  static const Color secondaryLight = Color(0xFF8E65D6);
  static const Color secondaryDark = Color(0xFF5A32A3);

  static const Color accent = Color(0xFFD63384);
  static const Color accentLight = Color(0xFFE664A5);
  static const Color accentDark = Color(0xFFAB2368);

  static const Color scaffoldBackground = Color(0xFFF6F8FC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color darkScaffoldBackground = Color(0xFF0F172A);
  static const Color darkCardBackground = Color(0xFF1E293B);
  static const Color disableColor = Color(0xFFB0B7C3);

  static const Color chipButtonPrimary = Color(0xFFF1F5F9);

  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = accent;
  static const Color buttonSuccess = Color(0xFF22C55E);
  static const Color buttonPurple = Color(0xFF8B5CF6);

  static const Color buttonText = Colors.white;
  static const Color buttonTextDark = Colors.black;

  static const Color shadow = Color(0x140E0E0E);
  static const Color shadowDark = Color(0x33000000);
  static const Color shadowLight = Color(0x0A000000);

  static const Color text = Color(0xFF0F172A);
  static const Color textDark = Colors.white;
  static const Color subTitle = Color(0xFF64748B);
  static const Color hintColor = Color(0xFF94A3B8);

  static const Color border = Color(0xFFE2E8F0);
  static const Color textFieldBorder = Color(0xFFCBD5E1);

  static const Color textFieldFillLight = Color(0xFFF8FAFC);
  static const Color textFieldFillDark = Color(0xFF1E293B);

  static const Gradient ktGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, secondary, accent],
  );

  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryDark, accentDark],
  );

  static const Gradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentLight, accentDark],
  );

  static const Color iconLightColor = Color(0xFF0F172A);
  static const Color iconDarkColor = Colors.white;

  static const Color online = Color(0xFF22C55E);
  static const Color offline = Color(0xFF94A3B8);
  static const Color premium = Color(0xFFFACC15);

  static const Color favorite = Color(0xFFEF4444);

  static const Color successColor = Color(0xFF22C55E);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);
}
