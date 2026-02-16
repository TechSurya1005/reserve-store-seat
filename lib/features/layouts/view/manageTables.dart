import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quickseatreservation/app/theme/AppColors.dart';
import 'package:quickseatreservation/app/theme/AppSpacing.dart';
import 'package:quickseatreservation/app/theme/AppTextStyles.dart';
import 'package:quickseatreservation/app/widget/common/CustomInputTextField.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../viewModels/layout_view_model.dart';

class ManageTablesView extends StatefulWidget {
  const ManageTablesView({super.key});

  @override
  State<ManageTablesView> createState() => _ManageTablesViewState();
}

class _ManageTablesViewState extends State<ManageTablesView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LayoutViewModel>().fetchTables();
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Table Management",
                  style: AppTextStyle.titleLargeStyle(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(Icons.restaurant_menu, size: 14, color: Colors.blue),
                    const Gap(4),
                    Text(
                      "QuickSeat Admin",
                      style: AppTextStyle.labelSmallStyle(
                        context,
                      ).copyWith(color: AppColors.subTitle, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.spaceMd),
            child: Column(
              children: [
                CustomInputTextField(
                  controller: _searchController,
                  hintText: "Search tables by number or capacity...",
                  prefixIcon: Icon(Icons.search, color: AppColors.subTitle),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<LayoutViewModel>(
              builder: (context, viewModel, child) {
                final displayTables = viewModel.isLoading
                    ? List.generate(
                        5,
                        (index) => _buildTableCard(context, null),
                      )
                    : viewModel.tables.isEmpty
                    ? [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.spaceLg),
                            child: Text("No tables found"),
                          ),
                        ),
                      ]
                    : viewModel.tables
                          .where((table) {
                            final query = _searchController.text.toLowerCase();
                            return table.name.toLowerCase().contains(query) ||
                                table.size.toString().contains(query);
                          })
                          .map((table) => _buildTableCard(context, table))
                          .toList();

                return Skeletonizer(
                  enabled: viewModel.isLoading,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spaceMd,
                    ),
                    itemCount: displayTables.length,
                    itemBuilder: (context, index) {
                      final item = displayTables[index];
                      return item;
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCard(BuildContext context, dynamic table) {
    if (table == null) {
      // Dummy data for skeletonizer
      return Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.spaceSm),
        padding: const EdgeInsets.all(AppSpacing.spaceMd),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(width: 40, height: 40, color: Colors.grey),
            const Gap(AppSpacing.spaceLg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 100, height: 16, color: Colors.grey),
                  const Gap(4),
                  Container(width: 60, height: 12, color: Colors.grey),
                ],
              ),
            ),
            Container(width: 60, height: 24, color: Colors.grey),
          ],
        ),
      );
    }

    final isAvailable = table.isActive;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.spaceSm),
      padding: const EdgeInsets.all(AppSpacing.spaceMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isAvailable ? Color(0xFFE0F2FE) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.table_restaurant,
              size: 22,
              color: isAvailable ? Colors.blue : Colors.grey.shade400,
            ),
          ),
          const Gap(AppSpacing.spaceLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  table.name,
                  style: AppTextStyle.titleMediumStyle(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
                const Gap(4),
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 16,
                      color: AppColors.subTitle,
                    ),
                    const Gap(6),
                    Text(
                      "${table.size} Seats",
                      style: AppTextStyle.bodySmallStyle(context).copyWith(
                        color: AppColors.subTitle,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isAvailable
                  ? Colors.green.withOpacity(0.12)
                  : Color(0xFFE1E7F0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isAvailable ? "Available" : "Occupied",
              style: TextStyle(
                color: isAvailable ? Colors.green.shade700 : Color(0xFF5C6B89),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
