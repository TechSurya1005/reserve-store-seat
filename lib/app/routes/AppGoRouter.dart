import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickseatreservation/app/routes/AppRoutes.dart';
import 'package:quickseatreservation/core/models/NavigationModel.dart';
import 'package:quickseatreservation/features/auth/view/loginView.dart';
import 'package:quickseatreservation/features/bookTable/view/bookTableView.dart';
import 'package:quickseatreservation/features/checkTable/view/checkTable.dart';
import 'package:quickseatreservation/features/layouts/view/manageSlots.dart';
import 'package:quickseatreservation/features/layouts/view/manageTables.dart';
import 'package:quickseatreservation/features/mainHome/view/mainHomeView.dart';
import 'package:quickseatreservation/features/splash/view/splashView.dart';

class AppGoRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRouteNames.splash,
        builder: (context, state) => SplashView(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRouteNames.login,
        builder: (context, state) => LoginView(),
      ),
      GoRoute(
        path: AppRoutes.mainHome,
        name: AppRouteNames.mainHome,
        builder: (context, state) => MainHomeView(),
      ),
      GoRoute(
        path: AppRoutes.bookTable,
        name: AppRouteNames.bookTable,
        builder: (context, state) {
          final extra = state.extra;
          return BookTableView(
            navigationModel: extra is NavigationModel
                ? extra
                : NavigationModel(route: "Home"),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.checkTable,
        name: AppRouteNames.checkTable,
        builder: (context, state) {
          final extra = state.extra;
          return CheckTableView(
            navigationModel: extra is NavigationModel
                ? extra
                : NavigationModel(route: "Book Table"),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.manageSlots,
        name: AppRouteNames.manageSlots,
        builder: (context, state) => ManageSlotsView(),
      ),
      GoRoute(
        path: AppRoutes.manageTables,
        name: AppRouteNames.manageTables,
        builder: (context, state) => ManageTablesView(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("404 - Page Not Found"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 80,
            ),
            const SizedBox(height: 16),
            Text(
              "Oops! Page not found.",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "The route \"${state.uri.path}\" does not exist.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate back to home or splash
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: const Icon(Icons.home),
              label: const Text("Go to Home"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
