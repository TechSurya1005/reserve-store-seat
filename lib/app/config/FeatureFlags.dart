import 'package:quickseatreservation/core/prefs/PrefsHelper.dart';

enum FeatureKey { newDashboard, chatSupport }

class FeatureFlags {
  static final Map<FeatureKey, bool> defaults = {
    FeatureKey.newDashboard: false,
    FeatureKey.chatSupport: true,
  };

  static Future<void> init() async {
    for (var key in FeatureKey.values) {
      final value = PrefsHelper.getBool(key.name);
      if (value == null) {
        await PrefsHelper.setBool(key.name, defaults[key]!);
      }
    }
  }

  static Future<bool> isEnabled(FeatureKey key) async {
    return PrefsHelper.getBool(key.name) ?? defaults[key]!;
  }

  static Future<void> setFlag(FeatureKey key, bool value) async {
    await PrefsHelper.setBool(key.name, value);
  }
}
