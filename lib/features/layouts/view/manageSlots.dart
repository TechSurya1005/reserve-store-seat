import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:quickseatreservation/app/theme/AppColors.dart';
import 'package:quickseatreservation/app/theme/AppSpacing.dart';
import 'package:quickseatreservation/app/theme/AppTextStyles.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../domain/entities/time_slot_entity.dart';
import '../viewModels/layout_view_model.dart';

class ManageSlotsView extends StatefulWidget {
  const ManageSlotsView({super.key});

  @override
  State<ManageSlotsView> createState() => _ManageSlotsViewState();
}

class _ManageSlotsViewState extends State<ManageSlotsView> {
  late DateTime _selectedDate;
  late List<DateTime> _dates;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _generateDates();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LayoutViewModel>().fetchTimeSlots();
    });
  }

  void _generateDates() {
    DateTime now = DateTime.now();
    // Get total days in currently viewed month
    int daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    _dates = List.generate(daysInMonth, (index) {
      return DateTime(now.year, now.month, index + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Manage Slots",
              style: AppTextStyle.headlineSmallStyle(
                context,
              ).copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              "QUICKSEAT HOST",
              style: AppTextStyle.overlineStyle(context).copyWith(
                color: Colors.lightBlue,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month, color: Colors.lightBlue),
            onPressed: () {},
          ),
          const Gap(AppSpacing.spaceSm),
        ],
      ),
      body: Column(
        children: [
          // _buildHorizontalCalendar(),
          Expanded(
            child: Consumer<LayoutViewModel>(
              builder: (context, viewModel, child) {
                final displaySlots = viewModel.isLoading
                    ? List.generate(
                        5,
                        (index) => _buildSlotCard(
                          context,
                          time: "00:00 PM",
                          status: "Loading Seats...",
                          isEnabled: true,
                        ),
                      )
                    : viewModel.timeSlots.isEmpty
                    ? [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.spaceLg),
                            child: Text("No time slots available"),
                          ),
                        ),
                      ]
                    : viewModel.timeSlots
                          .map(
                            (slot) => _buildSlotCard(
                              context,
                              slot: slot,
                              time: slot.slotName,
                              status: slot.active ? "Active" : "Disabled",
                              isEnabled: slot.active,
                              statusColor: slot.active
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          )
                          .toList();

                return Skeletonizer(
                  enabled: viewModel.isLoading,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.spaceMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "TIME SLOTS",
                              style: AppTextStyle.labelLargeStyle(context)
                                  .copyWith(
                                    color: AppColors.subTitle,
                                    letterSpacing: 1.0,
                                  ),
                            ),
                          ],
                        ),
                        const Gap(AppSpacing.spaceMd),
                        ...displaySlots,
                        const Gap(100), // Bottom padding for scrolling
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCalendar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _dates.length,
        itemBuilder: (context, index) {
          DateTime date = _dates[index];
          bool isSelected = DateUtils.isSameDay(date, _selectedDate);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
            },
            child: Container(
              width: 70,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [Color(0xFF2D6CDF), Color(0xFFD63384)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: isSelected ? null : Border.all(color: AppColors.border),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : AppColors.subTitle,
                      fontSize: 14,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSlotCard(
    BuildContext context, {
    TimeSlotEntity? slot,
    required String time,
    required String status,
    required bool isEnabled,
    Color? statusColor,
    bool isDashed = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDashed ? Colors.transparent : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDashed
            ? Border.all(color: AppColors.border, width: 1.5)
            : null,
        boxShadow: isDashed
            ? null
            : [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isEnabled ? Color(0xFFE0F2FE) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isEnabled ? Icons.access_time_filled : Icons.block,
                color: isEnabled ? Colors.lightBlue : AppColors.disableColor,
                size: 24,
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: AppTextStyle.titleLargeStyle(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: isEnabled
                          ? AppColors.text
                          : AppColors.disableColor,
                    ),
                  ),
                  const Gap(4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (statusColor ?? Colors.grey).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor ?? AppColors.subTitle,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isEnabled,
              onChanged: slot == null
                  ? null
                  : (val) {
                      context.read<LayoutViewModel>().toggleSlotStatus(
                        slot,
                        val,
                      );
                    },
              activeThumbColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
