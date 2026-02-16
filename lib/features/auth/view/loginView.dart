import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:quickseatreservation/app/constants/AppImages.dart';
import 'package:quickseatreservation/app/routes/AppRoutes.dart';
import 'package:quickseatreservation/app/theme/AppColors.dart';
import 'package:quickseatreservation/app/theme/AppSizes.dart';
import 'package:quickseatreservation/app/theme/AppSpacing.dart';
import 'package:quickseatreservation/app/theme/AppTextStyles.dart';
import 'package:quickseatreservation/app/widget/common/CustomButton.dart';
import 'package:quickseatreservation/app/widget/common/CustomInputTextField.dart';
import 'package:provider/provider.dart';
import 'package:quickseatreservation/features/auth/viewModel/auth_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(AuthViewModel authViewModel) async {
    if (_formKey.currentState!.validate()) {
      final success = await authViewModel.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login Successful"),
              backgroundColor: Colors.green,
            ),
          );
          context.goNamed(AppRouteNames.mainHome);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authViewModel.error ?? "Login failed"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,

          body: Center(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.spaceXl.w),
              children: [
                Gap(AppSpacing.space6xl.h),
                // Logo
                Image.asset(
                  height: AppSizes.profileImageHeightXl,
                  AppImages.appLogo,
                ),
                Gap(AppSpacing.spaceLg.h),
                // App Name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "QuickSeat",
                      style: AppTextStyle.displaySmallStyle(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    Gap(AppSpacing.spaceSm.h),
                    Text(
                      "STAFF PORTAL",
                      style: AppTextStyle.labelMediumStyle(context).copyWith(
                        letterSpacing: 2.0,
                        color: AppColors.subTitle,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Gap(AppSpacing.spaceXl.h),

                // Login Card
                Container(
                  padding: EdgeInsets.all(32.w),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "Welcome back",
                          style: AppTextStyle.headlineSmallStyle(
                            context,
                          ).copyWith(color: AppColors.text),
                        ),
                        Gap(AppSpacing.spaceSm.h),
                        Text(
                          "Please enter your credentials to manage your floor.",
                          style: AppTextStyle.bodyMediumStyle(
                            context,
                          ).copyWith(color: AppColors.subTitle, height: 1.5),
                        ),
                        Gap(AppSpacing.spaceXl.h),

                        // Email Input
                        Text(
                          "BUSINESS EMAIL",
                          style: AppTextStyle.labelSmallStyle(context).copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.subTitle,
                          ),
                        ),
                        Gap(AppSpacing.spaceSm.h),
                        CustomInputTextField(
                          controller: _emailController,
                          hintText: "name@restaurant.com",
                          isEmail: true,
                          filled: true,
                          fillColor: AppColors.textFieldFillLight,
                          prefixIcon: Icon(
                            Icons.alternate_email,
                            color: AppColors.subTitle,
                            size: 20.sp,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return "Enter a valid email address";
                            }
                            return null;
                          },
                        ),

                        Gap(AppSpacing.spaceXl.h),

                        // Password Input
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "PASSWORD",
                              style: AppTextStyle.labelSmallStyle(context)
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.subTitle,
                                  ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                "Forgot?",
                                style: AppTextStyle.labelSmallStyle(context)
                                    .copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Gap(AppSpacing.spaceSm.h),
                        CustomInputTextField(
                          controller: _passwordController,
                          hintText: "••••••••",
                          isPassword: true,
                          obscureText: !_isPasswordVisible,
                          showVisibilityToggle: true,
                          onVisibilityToggle: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          filled: true,
                          fillColor: AppColors.textFieldFillLight,
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: AppColors.subTitle,
                            size: 20.sp,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),

                        Gap(AppSpacing.spaceXl.h),

                        // Login Button
                        CustomButton(
                          title: "Login",
                          isLoading: authViewModel.isLoading,
                          onTap: () => _handleLogin(authViewModel),
                          gradient: AppColors.primaryGradient,
                          textColor: Colors.white,
                          width: double.infinity,
                          suffixIcon: authViewModel.isLoading
                              ? null
                              : Icon(
                                  Icons.arrow_forward,
                                  size: 18.sp,
                                  color: Colors.white,
                                ),
                        ),

                        Gap(AppSpacing.spaceXl.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              size: 16.sp,
                              color: AppColors.subTitle,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Secure Employee Access Only",
                              style: AppTextStyle.captionStyle(
                                context,
                              ).copyWith(color: AppColors.subTitle),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
