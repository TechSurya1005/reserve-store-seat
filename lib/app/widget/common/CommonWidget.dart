import 'package:flutter/material.dart';
import 'package:quickseatreservation/app/theme/AppTextStyles.dart';

class CommonWidget {
  // Required field label with asterisk
  static Widget labelWithRequired(
    String text,
    BuildContext context, {
    TextStyle? style,
    bool? isRequired,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          overflow: TextOverflow.visible,
          maxLines: 3,
          text,
          style: style ?? AppTextStyle.labelMediumStyle(context),
        ),
        isRequired == true
            ? Text(
                " *",
                style: (style ?? AppTextStyle.labelMediumStyle(context))
                    .copyWith(color: Colors.red),
              )
            : Offstage(),
      ],
    );
  }

  // Different sizes ke liye
  static Widget labelSmallWithRequired(
    String text,
    BuildContext context, {
    bool? isRequired,
  }) {
    return labelWithRequired(
      text,
      context,
      isRequired: isRequired,
      style: AppTextStyle.labelSmallStyle(context),
    );
  }

  static Widget labelMediumWithRequired(
    String text,
    BuildContext context, {
    bool? isRequired,
  }) {
    return labelWithRequired(
      text,
      context,
      isRequired: isRequired,
      style: AppTextStyle.labelMediumStyle(context),
    );
  }

  static Widget labelLargeWithRequired(
    String text,
    BuildContext context, {
    bool? isRequired,
  }) {
    return labelWithRequired(
      text,
      context,
      isRequired: isRequired,
      style: AppTextStyle.labelLargeStyle(context),
    );
  }

  static Widget labelXSmallWithRequired(
    String text,
    BuildContext context, {
    bool? isRequired,
  }) {
    return labelWithRequired(
      text,
      context,
      isRequired: isRequired,
      style: AppTextStyle.captionStyle(context),
    );
  }

  // Custom style ke saath
  static Widget labelWithRequiredCustom(
    String text,
    BuildContext context,
    TextStyle textStyle, {
    bool? isRequired,
  }) {
    return labelWithRequired(text, context, style: textStyle);
  }
}
