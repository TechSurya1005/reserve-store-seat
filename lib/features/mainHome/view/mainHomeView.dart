import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:quickseatreservation/app/theme/AppColors.dart';
import 'package:quickseatreservation/app/theme/AppSizes.dart';
import 'package:quickseatreservation/app/theme/AppSpacing.dart';
import 'package:quickseatreservation/app/theme/AppTextStyles.dart';
import 'package:quickseatreservation/features/bookings/view/bookingsView.dart';
import 'package:quickseatreservation/features/layouts/view/layOutView.dart';
import 'package:quickseatreservation/features/mainHome/viewModel/mainHomeViewModel.dart';

class MainHomeView extends StatelessWidget {
  const MainHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MainHomeViewModel>(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        // show exit confirmation
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.exit_to_app, color: Colors.red),
                Gap(AppSpacing.spaceSm),
                Text(
                  'Ready to Leave?',
                  style: AppTextStyle.labelMediumStyle(context),
                ),
              ],
            ),
            content: Text(
              'You’re about to close the app.\nAre you sure you want to exit now?',
              style: AppTextStyle.labelSmallStyle(context),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(
                  'Cancel',
                  style: AppTextStyle.labelSmallStyle(context),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(
                  'Exit',
                  style: AppTextStyle.labelSmallStyle(
                    context,
                  ).copyWith(color: AppColors.errorColor),
                ),
              ),
            ],
          ),
        );
        if (shouldExit == true) {
          // exit(0);
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: PageView(
          controller: viewModel.pageController,
          pageSnapping: false,
          allowImplicitScrolling: false,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            viewModel.onPageChanged(index);
          },
          children: [BookingsView(), LayOutView()],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            border: Border(top: BorderSide(color: AppColors.border, width: 1)),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Consumer<MainHomeViewModel>(
            builder: (context, mainHomeController, child) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.spaceSm),
                  child: Row(
                    children: [
                      Expanded(
                        child: _BottomNavItem(
                          icon: 'assets/svg/calender.svg',
                          label: 'Bookings',
                          index: 0,
                          currentIndex: viewModel.navIndex,
                          onTap: () => viewModel.setNavIndex(0),
                          bgColors: Colors.red,
                        ),
                      ),
                      Expanded(
                        child: _BottomNavItem(
                          icon: 'assets/svg/layout_outline.svg',
                          label: 'Layouts',
                          index: 1,
                          currentIndex: viewModel.navIndex,
                          onTap: () => viewModel.setNavIndex(1),
                          bgColors: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final String icon;
  final String label;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;
  final Color bgColors;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
    required this.bgColors,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;
    final color = isSelected ? AppColors.buttonPrimary : AppColors.subTitle;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              width: AppSizes.iconLg,
              height: AppSizes.iconLg,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
