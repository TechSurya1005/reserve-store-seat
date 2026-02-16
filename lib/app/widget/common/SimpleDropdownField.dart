import 'package:quickseatreservation/app/extensions/themeExtension.dart';
import 'package:quickseatreservation/app/theme/AppRadius.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:quickseatreservation/app/theme/AppColors.dart';
import 'package:quickseatreservation/app/theme/AppSpacing.dart';
import 'package:quickseatreservation/app/theme/AppTextStyles.dart';

class SimpleDropdownField extends StatelessWidget {
  final List<String> items;
  final String selectedValue;
  final bool? filled;
  final Color? fillColor;
  final ValueChanged<String> onChanged;

  const SimpleDropdownField({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.filled = true,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      items: (filter, loadProps) => items,
      selectedItem: selectedValue,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          filled: filled,
          fillColor: fillColor ?? _getFillColor(context),
          contentPadding: const EdgeInsets.all(AppSpacing.spaceLg),

          // Same as CustomInputTextField
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.buttonSmall),
            borderSide: BorderSide(
              color: AppColors.textFieldBorder,
              width: 0.7,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.buttonSmall),
            borderSide: BorderSide(
              color: AppColors.textFieldBorder,
              width: 0.7,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.buttonSmall),
            borderSide: BorderSide(color: AppColors.primary, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            borderSide: BorderSide(color: AppColors.errorColor),
          ),
        ),
      ),
      popupProps: PopupProps.menu(
        showSelectedItems: true,
        fit: FlexFit.loose,

        containerBuilder: (context, popupWidget) {
          return Theme(
            data: Theme.of(context).copyWith(
              splashColor: AppColors.premium.withValues(alpha: 0.1),
              highlightColor: AppColors.premium,
              hoverColor: Colors.transparent,
            ),
            child: popupWidget,
          );
        },

        itemBuilder: (context, item, isSelected, isDisabled) {
          final bool selected = item == selectedValue;
          return Container(
            margin: const EdgeInsets.all(AppSpacing.spaceXs),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spaceMd,
              vertical: AppSpacing.spaceSm,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.accentLight
                  : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppRadius.buttonSmall),
            ),
            child: Text(
              item,
              style: AppTextStyle.labelMediumStyle(context).copyWith(
                color: AppColors.text,
                fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          );
        },
      ),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }

  Color _getFillColor(BuildContext context) {
    return context.isDarkTheme ? AppColors.textFieldFillDark : Colors.white;
  }
}
