import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:quickseatreservation/app/theme/AppColors.dart';
import 'package:quickseatreservation/app/theme/AppSpacing.dart';
import 'package:quickseatreservation/app/theme/AppTextStyles.dart';
import 'package:quickseatreservation/app/widget/common/CustomButton.dart';
import 'package:quickseatreservation/core/models/NavigationModel.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:intl/intl.dart';
import 'package:quickseatreservation/features/bookTable/viewModels/booking_view_model.dart';

class CheckTableView extends StatefulWidget {
  final NavigationModel navigationModel;
  const CheckTableView({super.key, required this.navigationModel});

  @override
  State<CheckTableView> createState() => _CheckTableViewState();
}

class _CheckTableViewState extends State<CheckTableView> {
  late final String _date;
  late final String _slotId;
  late final String _timeLabel;
  late final int _partySize;

  @override
  void initState() {
    super.initState();
    final params = widget.navigationModel.params ?? {};
    _date = params['date']?.toString() ?? '';
    _slotId = params['slotId']?.toString() ?? '';
    _timeLabel = params['time']?.toString() ?? '';
    _partySize = (params['partySize'] as int?) ?? 1;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingViewModel>().fetchAvailableTables(
        date: _date,
        slotId: _slotId,
        partySize: _partySize,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.lightBlue, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Available Tables",
          style: AppTextStyle.headlineSmallStyle(
            context,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.tune, color: Colors.lightBlue),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchSummary(context),
            const Gap(AppSpacing.spaceMd),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spaceMd,
              ),
              child: Consumer<BookingViewModel>(
                builder: (context, viewModel, child) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${viewModel.availableTables.length} tables found nearby",
                      style: AppTextStyle.bodyMediumStyle(
                        context,
                      ).copyWith(color: AppColors.subTitle),
                    ),
                  );
                },
              ),
            ),
            const Gap(AppSpacing.spaceSm),
            Expanded(
              child: Consumer<BookingViewModel>(
                builder: (context, viewModel, child) {
                  return Skeletonizer(
                    enabled: viewModel.isLoading,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppSpacing.spaceMd),
                      itemCount: viewModel.isLoading
                          ? 3
                          : viewModel.availableTables.length,
                      itemBuilder: (context, index) {
                        if (viewModel.isLoading) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _TableCard(
                              tableName: "Table XX",
                              seats: "Seats 4 people",
                              timeLabel: _timeLabel,
                              onConfirm: () {},
                            ),
                          );
                        }
                        final table = viewModel.availableTables[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _TableCard(
                            tableName: table.name,
                            seats: "Seats ${table.size} people",
                            timeLabel: _timeLabel,
                            onConfirm: () {
                              viewModel.setSelectedTable(table);
                              context.pop();
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSummary(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.spaceMd),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 16,
            color: Colors.lightBlue,
          ),
          const Gap(8),
          Text(
            () {
              if (_date.isEmpty) return "Select Date";
              try {
                return DateFormat('MMM dd, yyyy').format(DateTime.parse(_date));
              } catch (e) {
                return "Invalid Date";
              }
            }(),
            style: AppTextStyle.bodyMediumStyle(
              context,
            ).copyWith(color: AppColors.subTitle),
          ),
          const Gap(16),
          Container(width: 1, height: 20, color: AppColors.border),
          const Gap(16),
          Icon(Icons.people_outline, size: 16, color: Colors.lightBlue),
          const Gap(8),
          Text(
            "$_partySize People",
            style: AppTextStyle.bodyMediumStyle(
              context,
            ).copyWith(color: AppColors.subTitle),
          ),
          const Gap(16),
          Container(width: 1, height: 20, color: AppColors.border),
          const Gap(16),
          Icon(Icons.access_time, size: 16, color: Colors.lightBlue),
          const Gap(8),
          Text(
            _timeLabel,
            style: AppTextStyle.bodyMediumStyle(
              context,
            ).copyWith(color: AppColors.subTitle),
          ),
        ],
      ),
    );
  }

  Widget _buildFloorPlanCard(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(
            "https://images.unsplash.com/photo-1564013799919-ab600027ffc6?auto=format&fit=crop&q=80&w=1000",
          ), // Placeholder floor plan
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Can't decide?",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  "View Floor Plan",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.map_outlined, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableCard extends StatefulWidget {
  final String tableName;
  final String seats;
  final String timeLabel;
  final VoidCallback onConfirm;

  const _TableCard({
    required this.tableName,
    required this.seats,
    required this.timeLabel,
    required this.onConfirm,
  });

  @override
  State<_TableCard> createState() => _TableCardState();
}

class _TableCardState extends State<_TableCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.tableName,
                style: AppTextStyle.titleLargeStyle(
                  context,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Available",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const Gap(4),
          Row(
            children: [
              Icon(Icons.chair_outlined, size: 14, color: AppColors.subTitle),
              const Gap(4),
              Text(
                widget.seats,
                style: AppTextStyle.bodySmallStyle(
                  context,
                ).copyWith(color: AppColors.subTitle),
              ),
            ],
          ),
          const Gap(16),
          const Gap(16),
          Text(
            "SELECTED TIME SLOT",
            style: AppTextStyle.labelSmallStyle(context).copyWith(
              color: AppColors.subTitle,
              letterSpacing: 1.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.timeLabel,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Gap(16),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              onTap: widget.onConfirm,
              gradient: AppColors.ktGradient,
              title: "Confirm Selection",
            ),
          ),
        ],
      ),
    );
  }
}
