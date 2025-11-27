import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:money_track/widgets/calendar/date_picker_dialog.dart';
import '../../controllers/expense_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/extensions/extensions.dart';
import '../../widgets/error_widget.dart' as custom;
import '../../widgets/loading_widget.dart';

class ExpenseListPage extends StatelessWidget {
  const ExpenseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ExpenseController controller = Get.find();

    return Column(
      children: [
        // 顶部摘要栏
        _buildSummaryInfo(context),
        // 消费列表
        Expanded(
          child: Obx(() {
              if (controller.isLoading.value &&
                  controller.dailyExpenses.isEmpty) {
                return const LoadingWidget(message: '加载中...');
              }

              if (controller.error.value.isNotEmpty &&
                  controller.dailyExpenses.isEmpty) {
                return custom.ErrorWidget(
                  message: controller.error.value,
                  onRetry: () => controller.loadExpenses(forceRefresh: true),
                );
              }

              if (controller.dailyExpenses.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 80,
                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                      16.heightBox,
                      Text(
                        AppStrings.emptyExpense,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.loadExpenses(forceRefresh: true),
                color: AppColors.primary,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: controller.dailyExpenses.length,
                  itemBuilder: (context, index) {
                    final dailyExpense = controller.dailyExpenses[index];
                    return _buildDailyExpenseGroup(
                      context,
                      dailyExpense,
                      controller,
                    );
                  },
                ),
              );
            }),
        ),
      ],
    );
  }

  Widget _buildDailyExpenseGroup(
    BuildContext context,
    dailyExpense,
    ExpenseController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 日期标题
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Text(
                dailyExpense.formattedDate,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                dailyExpense.formattedTotalAmount,
                style: context.textTheme.titleMedium?.copyWith(
                  color: AppColors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // 消费记录列表
        ...dailyExpense.expenses.map((expense) {
          return _buildExpanseItem();
        }),
      ],
    );
  }

  Widget _buildExpanseItem() {
    return Column(
      children: [
        Divider(height: 1, color: AppColors.divider),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/icon_expense_food.svg',
                width: 32,
                height: 32,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '午餐',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '12:30 PM',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '-45.00',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 28),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '2015',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '12',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(width: 4),
                IgnorePointer(
                  child: SvgPicture.asset(
                    'assets/icons/icon_date_select.svg',
                    width: 14,
                    height: 14,
                  ),
                ),
              ],
            ).button(onTap: () async {
              await CustomDatePickerDialog.show(context);
            }),
          ],
        ),
        Spacer(flex: 1),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '支出',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            SizedBox(height: 4),
            Text(
              '120',
              style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
            ),
          ],
        ),
        Spacer(flex: 1),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '结余',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            SizedBox(height: 4),
            Text(
              '32',
              style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
            ),
          ],
        ),
        SizedBox(width: 28),
      ],
    );
  }
}