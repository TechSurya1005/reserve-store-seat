import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:quickseatreservation/app/routes/AppRoutes.dart';
import 'package:quickseatreservation/app/theme/AppColors.dart';
import 'package:quickseatreservation/app/theme/AppSpacing.dart';
import 'package:quickseatreservation/app/theme/AppTextStyles.dart';

import 'package:quickseatreservation/app/widget/common/CustomButton.dart';
import 'package:quickseatreservation/app/widget/common/CustomInputTextField.dart';
import 'package:provider/provider.dart';
import '../viewModels/layout_view_model.dart';

class LayOutView extends StatefulWidget {
  const LayOutView({super.key});

  @override
  State<LayOutView> createState() => _LayOutViewState();
}

class _LayOutViewState extends State<LayOutView> {
  final TextEditingController _tableNumberController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();

  @override
  void dispose() {
    _tableNumberController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Layout & Operations",
          style: AppTextStyle.headlineSmallStyle(
            context,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.spaceMd),
        child: Column(
          children: [
            _buildStoreDashboardBanner(context),
            const Gap(AppSpacing.spaceLg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildActionCard(
                    context,
                    title: "Create Time Slots",
                    subtitle: "Schedule new sessions",
                    icon: Icons.update,
                    gradient: LinearGradient(
                      colors: [Color(0xFF6F42C1), Color(0xFFD63384)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    isLight: false,
                    onTap: () => _showCreateTimeSlotsBottomSheet(context),
                  ),
                ),
                const Gap(AppSpacing.spaceMd),
                Expanded(
                  child: _buildActionCard(
                    context,
                    title: "Create Tables",
                    subtitle: "Design floor layout",
                    icon: Icons.table_restaurant,
                    gradient: LinearGradient(
                      colors: [Color(0xFF2D6CDF), Color(0xFFE664A5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    isLight: false,
                    onTap: () => _showCreateTablesBottomSheet(context),
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.spaceMd),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildActionCard(
                    context,
                    title: "View Time Slots",
                    subtitle: "Manage schedules",
                    icon: Icons.calendar_today,
                    iconColor: Colors.blue,
                    backgroundColor: Colors.white,
                    isLight: true,
                    onTap: () {
                      context.read<LayoutViewModel>().fetchTimeSlots();
                      context.pushNamed(AppRouteNames.manageSlots);
                    },
                  ),
                ),
                const Gap(AppSpacing.spaceMd),
                Expanded(
                  child: _buildActionCard(
                    context,
                    title: "View Table Lists",
                    subtitle: "Inventory status",
                    icon: Icons.list,
                    iconColor: Colors.blue,
                    backgroundColor: Colors.white,
                    isLight: true,
                    onTap: () {
                      context.read<LayoutViewModel>().fetchTables();
                      context.pushNamed(AppRouteNames.manageTables);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateTablesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Add New Table",
                  style: AppTextStyle.headlineSmallStyle(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Gap(AppSpacing.spaceMd),
            Text(
              "Table Number / ID",
              style: AppTextStyle.bodyMediumStyle(
                context,
              ).copyWith(color: AppColors.subTitle),
            ),
            const Gap(AppSpacing.spaceXs),
            CustomInputTextField(
              controller: _tableNumberController,
              hintText: "e.g. 15 or A1",
              fillColor: AppColors.scaffoldBackground,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            const Gap(AppSpacing.spaceMd),
            Text(
              "Seating Capacity",
              style: AppTextStyle.bodyMediumStyle(
                context,
              ).copyWith(color: AppColors.subTitle),
            ),
            const Gap(AppSpacing.spaceXs),
            CustomInputTextField(
              controller: _capacityController,
              hintText: "Number of guests",
              fillColor: AppColors.scaffoldBackground,
              filled: true,
              suffixIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_drop_up,
                    size: 18,
                    color: AppColors.subTitle,
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 18,
                    color: AppColors.subTitle,
                  ),
                ],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            const Gap(AppSpacing.spaceLg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: AppColors.border),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Gap(AppSpacing.spaceMd),
                Expanded(
                  child: Consumer<LayoutViewModel>(
                    builder: (context, viewModel, child) {
                      return CustomButton(
                        title: viewModel.isLoading ? "Saving..." : "Save Table",
                        onTap: viewModel.isLoading
                            ? null
                            : () async {
                                final name = _tableNumberController.text;
                                final size =
                                    int.tryParse(_capacityController.text) ?? 0;
                                if (name.isNotEmpty && size > 0) {
                                  final success = await viewModel.createTable(
                                    area: "indoor", // Default or add a selector
                                    name: name,
                                    size: size,
                                  );

                                  if (!context.mounted) return;

                                  if (success) {
                                    _tableNumberController.clear();
                                    _capacityController.clear();
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          viewModel.error ??
                                              "Failed to save table",
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                        gradient: LinearGradient(
                          colors: [Color(0xFF2D6CDF), Color(0xFFD63384)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        textColor: Colors.white,
                        borderRadius: 12,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateTimeSlotsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        bool autoEnable = true;
        int hour = 8;
        int minute = 30;
        bool isAm = true;

        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Add New Slot",
                        style: AppTextStyle.headlineSmallStyle(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Gap(AppSpacing.spaceMd),
                  Text(
                    "Time Selection",
                    style: AppTextStyle.bodyMediumStyle(
                      context,
                    ).copyWith(color: AppColors.subTitle),
                  ),
                  const Gap(AppSpacing.spaceMd),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTimeColumn(
                          value: hour.toString().padLeft(2, '0'),
                          onUp: () {
                            setState(() {
                              hour = hour == 12 ? 1 : hour + 1;
                            });
                          },
                          onDown: () {
                            setState(() {
                              hour = hour == 1 ? 12 : hour - 1;
                            });
                          },
                        ),
                        const Gap(AppSpacing.spaceMd),
                        Text(
                          ":",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(AppSpacing.spaceMd),
                        _buildTimeColumn(
                          value: minute.toString().padLeft(2, '0'),
                          onUp: () {
                            setState(() {
                              minute = minute == 59 ? 0 : minute + 1;
                            });
                          },
                          onDown: () {
                            setState(() {
                              minute = minute == 0 ? 59 : minute - 1;
                            });
                          },
                        ),
                        const Gap(AppSpacing.spaceLg),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => setState(() => isAm = true),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isAm ? Colors.white : null,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: isAm
                                        ? [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 2,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Text(
                                    "AM",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isAm
                                          ? Colors.black
                                          : AppColors.subTitle,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => isAm = false),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: !isAm ? Color(0xFF8B5CF6) : null,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "PM",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: !isAm
                                          ? Colors.white
                                          : AppColors.subTitle,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(AppSpacing.spaceLg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Auto-enable slot",
                        style: AppTextStyle.bodyLargeStyle(
                          context,
                        ).copyWith(fontWeight: FontWeight.w500),
                      ),
                      Switch(
                        value: autoEnable,
                        onChanged: (val) {
                          setState(() {
                            autoEnable = val;
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                    ],
                  ),
                  const Gap(AppSpacing.spaceLg),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: AppColors.border),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: AppColors.text,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Gap(AppSpacing.spaceMd),
                      Expanded(
                        child: Consumer<LayoutViewModel>(
                          builder: (context, viewModel, child) {
                            return CustomButton(
                              title: viewModel.isLoading
                                  ? "Saving..."
                                  : "Save Slot",
                              onTap: viewModel.isLoading
                                  ? null
                                  : () async {
                                      final time =
                                          "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${isAm ? 'AM' : 'PM'}";
                                      final success = await viewModel
                                          .createTimeSlot(
                                            slotName: time,
                                            active: autoEnable,
                                          );

                                      if (!context.mounted) return;

                                      if (success) {
                                        Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              viewModel.error ??
                                                  "Failed to save slot",
                                            ),
                                          ),
                                        );
                                      }
                                    },
                              gradient: LinearGradient(
                                colors: [Color(0xFF5A95F5), Color(0xFF8B5CF6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              textColor: Colors.white,
                              borderRadius: 12,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTimeColumn({
    required String value,
    required VoidCallback onUp,
    required VoidCallback onDown,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: onUp,
          icon: Icon(Icons.keyboard_arrow_up, color: AppColors.subTitle),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
        const Gap(4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        const Gap(4),
        IconButton(
          onPressed: onDown,
          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.subTitle),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildStoreDashboardBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spaceLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2D6CDF), Color(0xFFD63384)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Store Dashboard",
            style: AppTextStyle.headlineSmallStyle(
              context,
            ).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const Gap(AppSpacing.spaceSm),
          Text(
            "Manage your restaurant floor plan and booking windows.",
            style: AppTextStyle.bodyMediumStyle(
              context,
            ).copyWith(color: Colors.white.withOpacity(0.9), height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    LinearGradient? gradient,
    Color? backgroundColor,
    Color? iconColor,
    required bool isLight,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.spaceMd),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: gradient,
                color: isLight ? Color(0xFFE0F2FE) : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isLight ? (iconColor ?? Colors.blue) : Colors.white,
                size: 24,
              ),
            ),
            const Gap(AppSpacing.spaceMd),
            Text(
              title,
              style: AppTextStyle.titleMediumStyle(
                context,
              ).copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(AppSpacing.spaceXs),
            Text(
              subtitle,
              style: AppTextStyle.bodySmallStyle(
                context,
              ).copyWith(color: AppColors.subTitle),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.blue, size: 20),
            ),
            const Gap(AppSpacing.spaceMd),
            Expanded(
              child: Text(
                title,
                style: AppTextStyle.titleMediumStyle(
                  context,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.subTitle),
          ],
        ),
      ),
    );
  }
}
