import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:quickseatreservation/app/constants/AppImages.dart';
import 'package:quickseatreservation/app/routes/AppRoutes.dart';
import 'package:quickseatreservation/app/theme/AppSizes.dart';
import 'package:quickseatreservation/app/theme/AppTextStyles.dart';

import 'package:quickseatreservation/app/constants/AppKeys.dart';
import 'package:quickseatreservation/core/prefs/PrefsHelper.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    initialLoad();
  }

  Future<void> initialLoad() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return; // 🔒 important

    final isLoggedIn = PrefsHelper.getBool(AppKeys.isLoggedIn) ?? false;

    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (isLoggedIn || firebaseUser != null) {
      context.goNamed(AppRouteNames.mainHome);
    } else {
      context.goNamed(AppRouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              height: AppSizes.profileImageHeightXxxl,
              // width: AppSizes.profileImageHeightXl,
              AppImages.appLogo,
            ),
          ),
          Text(
            textAlign: TextAlign.center,
            'QuickSeat Reservation',
            style: AppTextStyle.headlineMediumStyle(context),
          ),
        ],
      ),
    );
  }
}
