import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quickseatreservation/features/bookTable/viewModels/booking_view_model.dart';
import 'package:quickseatreservation/features/layouts/viewModels/layout_view_model.dart';
import 'package:quickseatreservation/app/routes/AppRoutes.dart';
import 'package:quickseatreservation/app/theme/AppColors.dart';
import 'package:quickseatreservation/app/theme/AppSpacing.dart';
import 'package:quickseatreservation/app/theme/AppTextStyles.dart';
import 'package:quickseatreservation/app/widget/common/CustomButton.dart';
import 'package:quickseatreservation/core/models/NavigationModel.dart';
import 'package:quickseatreservation/features/bookTable/domain/entities/booking_entity.dart';

class BookingsView extends StatefulWidget {
  const BookingsView({super.key});

  @override
  State<BookingsView> createState() => _BookingsViewState();
}

class _BookingsViewState extends State<BookingsView> {
  String _activeFilter = "All";
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingViewModel>().fetchAllBookings();
      context.read<LayoutViewModel>().fetchInitialData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Consumer2<BookingViewModel, LayoutViewModel>(
          builder: (context, bookingVM, layoutVM, child) {
            final filteredBookings = bookingVM.filterBookings(
              _activeFilter,
              _searchQuery,
            );

            // Group by slotId
            Map<String, List<BookingEntity>> groupedBookings = {};
            for (var booking in filteredBookings) {
              if (!groupedBookings.containsKey(booking.timeSlotId)) {
                groupedBookings[booking.timeSlotId] = [];
              }
              groupedBookings[booking.timeSlotId]!.add(booking);
            }

            return RefreshIndicator(
              onRefresh: () => bookingVM.fetchAllBookings(),
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.spaceMd),
                children: [
                  _buildTopHeader(context),
                  const Gap(AppSpacing.spaceLg),
                  _buildSearchBar(context),
                  const Gap(AppSpacing.spaceLg),
                  _buildDateTabs(context),
                  const Gap(AppSpacing.spaceLg),

                  if (bookingVM.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (bookingVM.error != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "Error: ${bookingVM.error}",
                          style: const TextStyle(color: AppColors.errorColor),
                        ),
                      ),
                    )
                  else if (filteredBookings.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Column(
                          children: [
                            Text(
                              "No bookings found",
                              style: AppTextStyle.bodyMediumStyle(context),
                            ),
                            const Gap(10),
                            Text(
                              "Total fetched: ${bookingVM.allBookings.length}",
                              style: AppTextStyle.captionStyle(context),
                            ),
                            Text(
                              "Current Filter: $_activeFilter | Today: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
                              style: AppTextStyle.captionStyle(context),
                            ),
                            if (bookingVM.allBookings.isNotEmpty) ...[
                              const Gap(5),
                              Text(
                                "Fetched dates: ${bookingVM.allBookings.map((b) => b.date).toSet().toList().join(', ')}",
                                style: AppTextStyle.captionStyle(context),
                              ),
                            ],
                          ],
                        ),
                      ),
                    )
                  else
                    ...groupedBookings.entries.map((entry) {
                      final slotId = entry.key;
                      final bookings = entry.value;
                      final slots = layoutVM.timeSlots.where(
                        (s) => s.id == slotId,
                      );
                      final slotName = slots.isNotEmpty
                          ? slots.first.slotName
                          : "Unknown Slot";

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTimeSlotHeader(context, "$slotName SLOT"),
                          const Gap(AppSpacing.spaceSm),
                          ...bookings.map((booking) {
                            final tables = layoutVM.tables.where(
                              (t) => t.id == booking.tableId,
                            );
                            final tableName = tables.isNotEmpty
                                ? tables.first.name
                                : "Unknown";

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _BookingCard(
                                initials: booking.customerName.isNotEmpty
                                    ? booking.customerName
                                          .substring(0, 1)
                                          .toUpperCase()
                                    : "?",
                                name: booking.customerName,
                                phone: booking.customerPhone,
                                guests: "${booking.partySize} Guests",
                                table: tableName,
                                time: booking.date,
                                status: booking.status.toUpperCase(),
                                onCancel: () => _showCancelDialog(
                                  context,
                                  bookingVM,
                                  booking.id!,
                                ),
                                onSeat: () => bookingVM.seatGuest(booking.id!),
                              ),
                            );
                          }).toList(),
                          const Gap(AppSpacing.spaceLg),
                        ],
                      );
                    }).toList(),
                  const Gap(AppSpacing.space2xl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showCancelDialog(
    BuildContext context,
    BookingViewModel viewModel,
    String bookingId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Reservation?"),
        content: const Text(
          "Are you sure you want to cancel this booking? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Keep Booking"),
          ),
          TextButton(
            onPressed: () async {
              final success = await viewModel.cancelBooking(bookingId);
              if (context.mounted) {
                Navigator.pop(context);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Reservation cancelled")),
                  );
                }
              }
            },
            child: const Text(
              "Yes, Cancel",
              style: TextStyle(color: AppColors.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "QUICKSEAT STAFF",
              style: AppTextStyle.labelSmallStyle(context).copyWith(
                color: Colors.blue, // Approx match to image cyan-ish blue
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              "Reservations",
              style: AppTextStyle.displaySmallStyle(
                context,
              ).copyWith(color: AppColors.text, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const Spacer(),
        _buildIconBtn(
          context,
          Icons.notifications_none_rounded,
          isPrimary: false,
        ),
        const Gap(AppSpacing.spaceSm),
        _buildIconBtn(
          context,
          Icons.add,
          isPrimary: true,
          onTap: () {
            context.pushNamed(
              AppRouteNames.bookTable,
              extra: NavigationModel(route: "Home", params: {"isEdit": false}),
            );
          },
        ),
      ],
    );
  }

  Widget _buildIconBtn(
    BuildContext context,
    IconData icon, {
    required bool isPrimary,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isPrimary
              ? Colors.lightBlue
              : Colors.blue.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isPrimary ? Colors.white : Colors.blue,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search name or phone...",
                hintStyle: AppTextStyle.bodyMediumStyle(
                  context,
                ).copyWith(color: AppColors.subTitle),
                prefixIcon: const Icon(Icons.search, color: AppColors.subTitle),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const Gap(AppSpacing.spaceSm),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.tune, color: AppColors.text),
        ),
      ],
    );
  }

  Widget _buildDateTabs(BuildContext context) {
    return Row(
      children: [
        _buildTab(context, "All"),
        const Gap(AppSpacing.spaceSm),
        _buildTab(context, "Today"),
        const Gap(AppSpacing.spaceSm),
        _buildTab(context, "Tomorrow"),
        const Gap(AppSpacing.spaceSm),
        _buildTab(context, "Waitlist"),
      ],
    );
  }

  Widget _buildTab(BuildContext context, String text) {
    final bool isActive = _activeFilter == text;
    return InkWell(
      onTap: () {
        setState(() {
          _activeFilter = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.lightBlue : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.lightBlue.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          style: AppTextStyle.labelMediumStyle(context).copyWith(
            color: isActive ? Colors.white : AppColors.subTitle,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlotHeader(BuildContext context, String title) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyle.labelSmallStyle(context).copyWith(
            color: AppColors.subTitle,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        const Gap(AppSpacing.spaceSm),
        Expanded(
          child: Divider(
            color: AppColors.subTitle.withValues(alpha: 0.2),
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

class _BookingCard extends StatelessWidget {
  final String initials;
  final String name;
  final String phone;
  final String guests;
  final String table;
  final String time;
  final String status;
  final VoidCallback onCancel;
  final VoidCallback onSeat;

  const _BookingCard({
    required this.initials,
    required this.name,
    required this.phone,
    required this.guests,
    required this.table,
    required this.time,
    required this.status,
    required this.onCancel,
    required this.onSeat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.spaceMd),
      child: Column(
        children: [
          // Header Row
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.lightBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: AppTextStyle.titleLargeStyle(context).copyWith(
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Gap(AppSpacing.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyle.titleMediumStyle(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Gap(2),
                    Text(
                      phone,
                      style: AppTextStyle.bodyMediumStyle(
                        context,
                      ).copyWith(color: AppColors.subTitle),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(context, status),
            ],
          ),
          const Gap(AppSpacing.spaceLg),

          // Info Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoColumn(context, "PARTY", guests, Icons.people_outline),
              _buildInfoColumn(
                context,
                "TABLE",
                table,
                Icons.table_bar_outlined,
              ),
              _buildInfoColumn(context, "TIME", time, Icons.access_time),
            ],
          ),

          const Gap(AppSpacing.spaceLg),

          // Action Buttons
          Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomButton(
                  title: status == "SEATED" ? "Seated" : "Seat Now",
                  onTap: status == "SEATED" ? null : onSeat,
                  gradient: AppColors.ktGradient,
                ),
              ),
              const Gap(AppSpacing.spaceMd),
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: status == "CANCELLED" ? null : onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.errorColor,
                    side: BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "Cancel",
                    style: AppTextStyle.buttonStyle(context).copyWith(
                      color: status == "CANCELLED"
                          ? AppColors.subTitle
                          : AppColors.errorColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.successColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.successColor,
              shape: BoxShape.circle,
            ),
          ),
          const Gap(6),
          Text(
            text,
            style: AppTextStyle.captionStyle(context).copyWith(
              color: AppColors.successColor,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyle.captionStyle(context).copyWith(
              color: AppColors.subTitle.withValues(alpha: 0.7),
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              fontSize: 10,
            ),
          ),
          const Gap(4),
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.lightBlue),
              const Gap(4),
              Text(
                value,
                style: AppTextStyle.bodyLargeStyle(
                  context,
                ).copyWith(fontWeight: FontWeight.w600, color: AppColors.text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
