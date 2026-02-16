import 'package:quickseatreservation/app/extensions/themeExtension.dart';
import 'package:quickseatreservation/app/theme/AppRadius.dart';
import 'package:quickseatreservation/app/theme/AppTextStyles.dart';
import 'package:quickseatreservation/app/theme/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final String? initialValue;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool autoFocus;
  final bool readOnly;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final int? minLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final Color? fillColor;
  final bool filled;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? errorStyle;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final bool? isUserName;
  final bool? isMobile;
  final bool? isOnlyNumber;
  final bool? isEmail;
  final bool? isPassword;
  final bool? isDescription;
  final bool showVisibilityToggle;
  final VoidCallback? onVisibilityToggle;

  const CustomInputTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.errorText,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.autoFocus = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.inputFormatters,
    this.contentPadding,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.fillColor,
    this.filled = false,
    this.style,
    this.hintStyle,
    this.labelStyle,
    this.errorStyle,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.isUserName,
    this.isMobile,
    this.isOnlyNumber,
    this.isEmail,
    this.isPassword,
    this.isDescription,
    this.showVisibilityToggle = false,
    this.onVisibilityToggle,
  });

  @override
  State<CustomInputTextField> createState() => _CustomInputTextFieldState();
}

class _CustomInputTextFieldState extends State<CustomInputTextField> {
  late FocusNode _focusNode;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() => isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPasswordField =
        widget.isPassword == true || widget.showVisibilityToggle;
    final bool showEyeButton = isPasswordField && widget.showVisibilityToggle;

    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      keyboardType: _getKeyboardType(),
      textInputAction: widget.textInputAction,
      obscureText: widget.obscureText,
      autofocus: widget.autoFocus,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      maxLines: _getMaxLines(),
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      focusNode: _focusNode,
      textAlign: widget.textAlign,
      textCapitalization: widget.textCapitalization,
      inputFormatters: _getInputFormatters(),
      decoration: _buildDecoration(context, showEyeButton),
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      validator: widget.validator ?? (value) => _getDefaultValidator(value),
      style: widget.style ?? AppTextStyle.bodyMediumStyle(context),
    );
  }

  InputDecoration _buildDecoration(BuildContext context, bool showEyeButton) {
    return InputDecoration(
      hintText: widget.hintText ?? _getDefaultHint(),
      labelText: widget.labelText,
      errorText: widget.errorText,
      prefixIcon: widget.prefixIcon ?? _getDefaultPrefixIcon(),
      suffixIcon: _buildSuffixIcon(showEyeButton),
      contentPadding: widget.contentPadding ?? const EdgeInsets.all(16),
      border: widget.border ?? _getDefaultBorder(),
      enabledBorder: widget.enabledBorder ?? _getDefaultBorder(),
      focusedBorder: widget.focusedBorder ?? _getDefaultFocusedBorder(),
      errorBorder: widget.errorBorder ?? _getDefaultErrorBorder(),
      disabledBorder: _getDefaultDisabledBorder(),
      filled: widget.filled,
      fillColor: widget.fillColor ?? _getFillColor(context),
      hintStyle: widget.hintStyle ?? _getDefaultHintStyle(context),
      labelStyle: widget.labelStyle ?? _getDefaultLabelStyle(context),
      errorStyle: widget.errorStyle ?? _getDefaultErrorStyle(context),
      errorMaxLines: 2,
      counterText: '',
    );
  }

  Widget? _buildSuffixIcon(bool showEyeButton) {
    if (showEyeButton) {
      return IconButton(
        icon: Icon(
          widget.obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.hintColor,
        ),
        onPressed: widget.onVisibilityToggle,
      );
    }
    return widget.suffixIcon;
  }

  // === Default Values & Auto Configuration ===
  TextInputType _getKeyboardType() {
    if (widget.isEmail == true) return TextInputType.emailAddress;
    if (widget.isMobile == true) return TextInputType.phone;
    if (widget.isOnlyNumber == true) return TextInputType.number;
    if (widget.isDescription == true) return TextInputType.multiline;
    return widget.keyboardType;
  }

  int _getMaxLines() {
    if (widget.isDescription == true) return 4;
    return widget.maxLines;
  }

  List<TextInputFormatter>? _getInputFormatters() {
    if (widget.isOnlyNumber == true) {
      return [FilteringTextInputFormatter.digitsOnly];
    }
    if (widget.isMobile == true) {
      return [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ];
    }
    return widget.inputFormatters;
  }

  String _getDefaultHint() {
    if (widget.isUserName == true) return 'Enter your username';
    if (widget.isEmail == true) return 'Enter your email';
    if (widget.isMobile == true) return 'Enter your phone number';
    if (widget.isPassword == true) return 'Enter your password';
    if (widget.isDescription == true) return 'Enter description';
    return 'Enter text';
  }

  Widget? _getDefaultPrefixIcon() {
    final color = isFocused ? AppColors.primary : AppColors.hintColor;
    if (widget.isUserName == true) {
      return Icon(Icons.person_outline, color: color);
    }
    // if (widget.isEmail == true) {
    //   return Icon(Icons.email_outlined, color: color);
    // }
    if (widget.isMobile == true) {
      return Icon(Icons.phone_outlined, color: color);
    }
    if (widget.isPassword == true) {
      return Icon(Icons.lock_outline, color: color);
    }
    return widget.prefixIcon;
  }

  InputBorder _getDefaultBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: BorderSide(color: AppColors.textFieldBorder, width: 1),
    );
  }

  InputBorder _getDefaultFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: BorderSide(color: AppColors.primary, width: 1),
    );
  }

  InputBorder _getDefaultErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: BorderSide(color: AppColors.errorColor),
    );
  }

  InputBorder _getDefaultDisabledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.6)),
    );
  }

  Color _getFillColor(BuildContext context) {
    return context.isDarkTheme ? AppColors.textFieldFillDark : Colors.white;
  }

  TextStyle _getDefaultHintStyle(BuildContext context) {
    return AppTextStyle.bodyMediumStyle(
      context,
    ).copyWith(color: AppColors.hintColor);
  }

  TextStyle _getDefaultLabelStyle(BuildContext context) {
    return AppTextStyle.bodyMediumStyle(
      context,
    ).copyWith(color: AppColors.text, fontWeight: FontWeight.w500);
  }

  TextStyle _getDefaultErrorStyle(BuildContext context) {
    return AppTextStyle.bodySmallStyle(
      context,
    ).copyWith(color: AppColors.errorColor);
  }

  // ✅ Fixed: Correct return type for validator
  String? _getDefaultValidator(String? value) {
    if (widget.isEmail == true && value != null && value.isNotEmpty) {
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        return 'Please enter a valid email address';
      }
    }
    if (widget.isMobile == true && value != null && value.isNotEmpty) {
      if (value.length != 10) {
        return 'Please enter a valid 10-digit phone number';
      }
    }
    if (widget.isPassword == true && value != null && value.isNotEmpty) {
      if (value.length < 6) {
        return 'Password must be at least 6 characters';
      }
    }
    return null;
  }
}
