import 'package:flutter/material.dart';
import 'package:quickseatreservation/app/theme/AppColors.dart';
import 'package:quickseatreservation/app/theme/AppDecorations.dart';
import 'package:quickseatreservation/app/theme/AppSpacing.dart';
import 'package:quickseatreservation/app/theme/AppTextStyles.dart';
import 'package:quickseatreservation/app/widget/common/CommonWidget.dart';

class PickImageSheetWidget extends StatelessWidget {
  final VoidCallback? onTapCamera;
  final VoidCallback? onTapGallery;
  final VoidCallback? onTapFilePicker;
  final bool? isLoading;
  final bool? isAlsoForFile;
  const PickImageSheetWidget({
    super.key,
    this.onTapCamera,
    this.onTapGallery,
    this.onTapFilePicker,
    this.isLoading,
    this.isAlsoForFile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isAlsoForFile == true ? 280 : 200,
      decoration: AppDecorations.topRoundedContainer(
        color: AppColors.cardBackground,
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.spaceMd),
                child: CommonWidget.labelMediumWithRequired(
                  "Choose Image",
                  context,
                ),
              ),
              ListTile(
                onTap: onTapCamera,
                leading: CircleAvatar(
                  backgroundColor: AppColors.secondary,
                  child: Icon(Icons.camera),
                ),
                title: Text(
                  "Camera",
                  style: AppTextStyle.labelSmallStyle(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spaceMd,
                ),
                child: Divider(thickness: 0.5, color: AppColors.border),
              ),
              ListTile(
                onTap: onTapGallery,
                leading: CircleAvatar(
                  backgroundColor: AppColors.secondary,
                  child: Icon(Icons.image),
                ),
                title: Text(
                  "Gallery",
                  style: AppTextStyle.labelSmallStyle(context),
                ),
              ),
              if (isAlsoForFile == true)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.spaceMd,
                  ),
                  child: Divider(thickness: 0.5, color: AppColors.border),
                ),
              if (isAlsoForFile == true)
                ListTile(
                  onTap: onTapFilePicker,
                  leading: CircleAvatar(
                    backgroundColor: AppColors.secondary,
                    child: Icon(Icons.file_copy),
                  ),
                  title: Text(
                    "File",
                    style: AppTextStyle.labelSmallStyle(context),
                  ),
                ),
            ],
          ),
          if (isLoading!)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(
                  alpha: 0.5,
                ), // Fixed: .withOpacity()
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              ),
            )
          else
            Offstage(),
        ],
      ),
    );
  }
}
