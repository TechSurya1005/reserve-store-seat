import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:quickseatreservation/app/theme/AppColors.dart';
import 'package:quickseatreservation/core/prefs/PrefsHelper.dart';
import 'app/config/Environment.dart';
import 'app/config/FeatureFlags.dart';
import 'firebase_options.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryDark,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
  );

  await PrefsHelper.init();

  await Environment.init(
    production: bool.fromEnvironment('dart.vm.product'),
    version: '1.0.0',
  );

  await FeatureFlags.init();
}
