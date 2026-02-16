import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:quickseatreservation/app/routes/AppRoutes.dart';
import 'package:quickseatreservation/app/theme/AppColors.dart';

import 'package:quickseatreservation/app/theme/AppSpacing.dart';
import 'package:quickseatreservation/app/theme/AppTextStyles.dart';
import 'package:quickseatreservation/app/widget/common/CustomButton.dart';
import 'package:quickseatreservation/app/widget/common/CustomInputTextField.dart';
import 'package:quickseatreservation/core/models/NavigationModel.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../layouts/viewModels/layout_view_model.dart';
import 'package:quickseatreservation/features/bookTable/viewModels/booking_view_model.dart';

class BookTableView extends StatefulWidget {
  final NavigationModel navigationModel;
  const BookTableView({super.key, required this.navigationModel});

  @override
  State<BookTableView> createState() => _BookTableViewState();
}

class _BookTableViewState extends State<BookTableView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _specialRequestsController =
      TextEditingController();
  DateTime _selectedDate = DateTime.now();

  int _selectedSlotIndex = -1; // No slot selected initially
  int _partySize = 4;
  late final TextEditingController _partySizeController = TextEditingController(
    text: "$_partySize",
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LayoutViewModel>().fetchTimeSlots();
      context.read<BookingViewModel>().clearSelectedTable();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _specialRequestsController.dispose();
    _partySizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        leading: TextButton.icon(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios, size: 16, color: Colors.lightBlue),
          label: Text(
            "Back",
            style: AppTextStyle.bodyLargeStyle(
              context,
            ).copyWith(color: Colors.lightBlue),
          ),
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
        ),
        leadingWidth: 80,
        title: Text(
          "New Reservation",
          style: AppTextStyle.titleLargeStyle(
            context,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // _buildRestaurantCard(context),
                    // const Gap(AppSpacing.spaceLg),
                    _buildGuestSection(context),
                    const Gap(AppSpacing.spaceLg),
                    _buildDateTimeSection(context),
                    const Gap(AppSpacing.spaceLg),
                    _buildPartySizeSection(context),
                    const Gap(AppSpacing.spaceMd),
                    _buildSelectedTableSection(context),
                    const Gap(100), // Space for bottom bar / toast
                  ],
                ),
              ),
            ),
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(
            "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=2070&auto=format&fit=crop",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              ),
            ),
          ),
          Positioned(
            bottom: AppSpacing.spaceMd,
            left: AppSpacing.spaceMd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "The Blue Terrace",
                  style: AppTextStyle.headlineSmallStyle(
                    context,
                  ).copyWith(color: Colors.white),
                ),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.white70, size: 14),
                    const Gap(4),
                    Text(
                      "Downtown Core, Suite 402",
                      style: AppTextStyle.bodySmallStyle(
                        context,
                      ).copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "GUEST INFORMATION",
            style: AppTextStyle.labelMediumStyle(context).copyWith(
              color: Colors.lightBlue,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const Gap(AppSpacing.spaceMd),
          CustomInputTextField(
            hintText: "Guest Name",
            controller: _nameController,
            fillColor: AppColors.scaffoldBackground,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          const Gap(AppSpacing.spaceMd),
          Text(
            "Phone Number",
            style: AppTextStyle.bodyMediumStyle(
              context,
            ).copyWith(color: AppColors.subTitle),
          ),
          const Gap(AppSpacing.spaceXs),
          CustomInputTextField(
            controller: _phoneController,
            hintText: "Enter Phone Number",
            isMobile: true,
            fillColor: AppColors.cardBackground,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            style: TextStyle(color: AppColors.text),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "DATE & TIME",
            style: AppTextStyle.labelMediumStyle(context).copyWith(
              color: Colors.lightBlue,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const Gap(AppSpacing.spaceMd),
          InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Colors.lightBlue,
                        onPrimary: Colors.white,
                        onSurface: AppColors.text,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.lightBlue,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (!mounted) return;

              if (picked != null && picked != _selectedDate) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spaceMd,
                vertical: AppSpacing.spaceSm,
              ),
              decoration: BoxDecoration(
                color: AppColors.scaffoldBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.lightBlue,
                    size: 20,
                  ),
                  const Gap(AppSpacing.spaceMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selected Date",
                          style: AppTextStyle.captionStyle(
                            context,
                          ).copyWith(color: AppColors.subTitle),
                        ),
                        Text(
                          DateFormat('EEEE, MMM d, y').format(_selectedDate),
                          style: AppTextStyle.titleMediumStyle(
                            context,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: AppColors.subTitle),
                ],
              ),
            ),
          ),
          const Gap(AppSpacing.spaceMd),
          Text(
            "Available Slots",
            style: AppTextStyle.bodyMediumStyle(
              context,
            ).copyWith(color: AppColors.subTitle),
          ),
          const Gap(AppSpacing.spaceSm),
          Consumer<LayoutViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return Skeletonizer(
                  enabled: true,
                  child: Wrap(
                    spacing: AppSpacing.spaceSm,
                    runSpacing: AppSpacing.spaceSm,
                    children: List.generate(
                      8,
                      (index) => Container(
                        width: (MediaQuery.of(context).size.width - 80) / 4,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                );
              }

              final activeSlots = viewModel.timeSlots
                  .where((s) => s.active)
                  .toList();

              if (activeSlots.isEmpty) {
                return Center(child: Text("No available slots for this date"));
              }

              return Wrap(
                spacing: AppSpacing.spaceSm,
                runSpacing: AppSpacing.spaceSm,
                children: List.generate(activeSlots.length, (index) {
                  final slot = activeSlots[index];
                  final isSelected = index == _selectedSlotIndex;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedSlotIndex = index;
                      });
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 80) / 4,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.lightBlue
                            : AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? Colors.lightBlue
                              : AppColors.border,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        slot.slotName,
                        style: AppTextStyle.labelMediumStyle(context).copyWith(
                          color: isSelected ? Colors.white : AppColors.text,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPartySizeSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "PARTY SIZE",
                style: AppTextStyle.labelMediumStyle(context).copyWith(
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_partySize > 1) {
                          setState(() {
                            _partySize--;
                            _partySizeController.text = "$_partySize";
                          });
                        }
                      },
                      icon: Icon(Icons.remove, color: Colors.lightBlue),
                      constraints: BoxConstraints(minWidth: 40),
                    ),
                    SizedBox(
                      width: 50,
                      child: TextFormField(
                        controller: _partySizeController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: AppTextStyle.titleLargeStyle(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          final int? newValue = int.tryParse(value);
                          if (newValue != null && newValue > 0) {
                            setState(() {
                              _partySize = newValue;
                            });
                          }
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _partySize++;
                          _partySizeController.text = "$_partySize";
                        });
                      },
                      icon: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.add, color: Colors.white, size: 16),
                      ),
                      constraints: BoxConstraints(minWidth: 40),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.spaceMd),
          Text(
            "Special Requests",
            style: AppTextStyle.bodyMediumStyle(
              context,
            ).copyWith(color: AppColors.subTitle),
          ),
          const Gap(AppSpacing.spaceSm),
          CustomInputTextField(
            controller: _specialRequestsController,
            hintText: "Allergies, birthday celebration, quiet table...",
            maxLines: 3,
            fillColor: AppColors.scaffoldBackground,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedTableSection(BuildContext context) {
    return Consumer<BookingViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.selectedTable == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(AppSpacing.spaceMd),
          decoration: BoxDecoration(
            color: Colors.lightBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.lightBlue.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.table_bar, color: Colors.lightBlue),
              const Gap(AppSpacing.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SELECTED TABLE",
                      style: AppTextStyle.labelSmallStyle(context).copyWith(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      viewModel.selectedTable!.name,
                      style: AppTextStyle.titleMediumStyle(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => viewModel.clearSelectedTable(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //   decoration: BoxDecoration(
          //     color: AppColors.darkCardBackground,
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   child: Row(
          //     children: [
          //       Container(
          //         padding: const EdgeInsets.all(4),
          //         decoration: const BoxDecoration(
          //           color: Colors.lightBlue,
          //           shape: BoxShape.circle,
          //         ),
          //         child: const Icon(Icons.check, size: 12, color: Colors.white),
          //       ),
          //       const Gap(8),
          //       const Expanded(
          //         child: Text(
          //           "Checking table availability...",
          //           style: TextStyle(color: Colors.white, fontSize: 13),
          //         ),
          //       ),
          //       const Text(
          //         "UNDO",
          //         style: TextStyle(
          //           color: Colors.lightBlue,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 12,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          const Gap(AppSpacing.spaceMd),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if (_nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter guest name"),
                        ),
                      );
                      return;
                    }
                    if (_phoneController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter phone number"),
                        ),
                      );
                      return;
                    }

                    final viewModel = context.read<LayoutViewModel>();
                    final activeSlots = viewModel.timeSlots
                        .where((s) => s.active)
                        .toList();

                    if (_selectedSlotIndex == -1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a time slot"),
                        ),
                      );
                      return;
                    }

                    final selectedSlot = activeSlots[_selectedSlotIndex];

                    context.pushNamed(
                      AppRouteNames.checkTable,
                      extra: NavigationModel(
                        route: "bookTable",
                        params: {
                          "date": DateFormat(
                            'yyyy-MM-dd',
                          ).format(_selectedDate),
                          "time": selectedSlot.slotName,
                          "slotId": selectedSlot.id,
                          "partySize": _partySize,
                          "specialRequests": _specialRequestsController.text,
                        },
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.lightBlue,
                    side: const BorderSide(color: Colors.lightBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Check Availability"),
                ),
              ),
              const Gap(AppSpacing.spaceMd),
              Expanded(
                child: Consumer<BookingViewModel>(
                  builder: (context, viewModel, child) {
                    return CustomButton(
                      title: "Confirm Reservation",
                      isLoading: viewModel.isLoading,
                      onTap: () async {
                        if (_nameController.text.trim().isEmpty ||
                            _phoneController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill in all guest details"),
                            ),
                          );
                          return;
                        }

                        if (viewModel.selectedTable == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select a table first"),
                            ),
                          );
                          return;
                        }

                        final layoutVM = context.read<LayoutViewModel>();
                        final activeSlots = layoutVM.timeSlots
                            .where((s) => s.active)
                            .toList();

                        if (_selectedSlotIndex == -1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select a time slot"),
                            ),
                          );
                          return;
                        }

                        final selectedSlot = activeSlots[_selectedSlotIndex];

                        final success = await viewModel.createBooking(
                          tableId: viewModel.selectedTable!.id!,
                          timeSlotId: selectedSlot.id!,
                          date: DateFormat('yyyy-MM-dd').format(_selectedDate),
                          partySize: _partySize,
                          customerName: _nameController.text,
                          customerPhone: _phoneController.text,
                          specialRequests: _specialRequestsController.text,
                        );

                        if (!context.mounted) return;

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Reservation Confirmed!"),
                            ),
                          );
                          viewModel.clearSelectedTable();
                          context.pop();
                        }
                      },
                      gradient: AppColors.ktGradient,
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
  }
}
