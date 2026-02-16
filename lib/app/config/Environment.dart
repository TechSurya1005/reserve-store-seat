import 'package:quickseatreservation/core/network/app_url.dart';

class Environment {
  static late final bool isProduction;
  static late final String apiUrl;
  static late final String appVersion;

  /// Call at app startup before runApp()
  static Future<void> init({
    required bool production,
    required String version,
  }) async {
    isProduction = production;
    appVersion = version;
    apiUrl = production ? AppUrl.baseUrlProd : AppUrl.baseUrlDev;
  }
}
