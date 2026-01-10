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
                  padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
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
                style: context.textTheme.bodySmall,
              ),
              const Spacer(),
              Text(
                dailyExpense.formattedTotalAmount,
                style: context.textTheme.bodySmall,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/icon_expend_type_ catering.svg',
                width: 16,
                height: 16,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '午餐',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '-45.00',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.black  ,
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '2025年',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '12月',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: 2),
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
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '支出',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(height: 4),
              Text(
                '120.0',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '结余',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(height: 4),
              Text(
                '120.0',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}