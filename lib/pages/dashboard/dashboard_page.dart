import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../controllers/expense_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/expense_model.dart';
import '../../core/extensions/extensions.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ExpenseController controller = Get.find();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.dailyExpenses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bar_chart_rounded,
                    size: 80,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  16.heightBox,
                  Text(
                    '暂无数据',
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                Text(
                  '数据看板',
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                24.heightBox,

                // 支出环比
                _buildMonthOverMonthCard(context, controller),
                16.heightBox,

                // 预算进度
                _buildBudgetProgressCard(context, controller),
                16.heightBox,

                // 支出折线图
                _buildExpenseTrendCard(context, controller),
                16.heightBox,

                // 支出类型饼状图
                _buildCategoryDistributionCard(context, controller),
              ],
            ),
          );
        }),
      ),
    );
  }

  // 支出环比卡片
  Widget _buildMonthOverMonthCard(BuildContext context, ExpenseController controller) {
    final currentMonthTotal = _getCurrentMonthTotal(controller);
    final lastMonthTotal = _getLastMonthTotal(controller);
    final change = currentMonthTotal - lastMonthTotal;
    final changePercentage = lastMonthTotal > 0
        ? (change / lastMonthTotal * 100)
        : 0.0;
    final isIncrease = change > 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.trending_up_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              12.widthBox,
              Text(
                '支出环比',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          20.heightBox,
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '本月支出',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    8.heightBox,
                    Text(
                      '¥${currentMonthTotal.toStringAsFixed(2)}',
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isIncrease
                      ? AppColors.pink.withValues(alpha: 0.1)
                      : Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 14,
                      color: isIncrease ? AppColors.pink : Colors.green,
                    ),
                    4.widthBox,
                    Text(
                      '${changePercentage.abs().toStringAsFixed(1)}%',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isIncrease ? AppColors.pink : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.heightBox,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '上月支出',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '¥${lastMonthTotal.toStringAsFixed(2)}',
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 预算进度卡片
  Widget _buildBudgetProgressCard(BuildContext context, ExpenseController controller) {
    final currentMonthTotal = _getCurrentMonthTotal(controller);
    final monthlyBudget = 5000.0; // 可以从设置中读取
    final progress = (currentMonthTotal / monthlyBudget).clamp(0.0, 1.0);
    final remaining = monthlyBudget - currentMonthTotal;
    final daysInMonth = DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
    final daysPassed = DateTime.now().day;
    final dailyBudget = remaining / (daysInMonth - daysPassed).clamp(1, daysInMonth);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.pink.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: AppColors.pink,
                  size: 20,
                ),
              ),
              12.widthBox,
              Text(
                '预算进度',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: progress > 0.9 ? AppColors.pink : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          20.heightBox,
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.background,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress > 0.9
                    ? AppColors.pink
                    : progress > 0.7
                        ? AppColors.primary
                        : Colors.green,
              ),
              minHeight: 12,
            ),
          ),
          16.heightBox,
          Row(
            children: [
              Expanded(
                child: _buildBudgetInfo(
                  context,
                  '已用',
                  '¥${currentMonthTotal.toStringAsFixed(0)}',
                  AppColors.pink,
                ),
              ),
              16.widthBox,
              Expanded(
                child: _buildBudgetInfo(
                  context,
                  '剩余',
                  '¥${remaining.clamp(0, monthlyBudget).toStringAsFixed(0)}',
                  Colors.green,
                ),
              ),
              16.widthBox,
              Expanded(
                child: _buildBudgetInfo(
                  context,
                  '日均可用',
                  '¥${dailyBudget.clamp(0, monthlyBudget).toStringAsFixed(0)}',
                  AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetInfo(BuildContext context, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          8.heightBox,
          Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // 支出折线图卡片
  Widget _buildExpenseTrendCard(BuildContext context, ExpenseController controller) {
    final last7Days = _getLast7DaysData(controller);
    final maxY = last7Days.fold<double>(0, (max, data) => data['amount'] > max ? data['amount'] : max);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.show_chart_rounded,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              12.widthBox,
              Text(
                '近7日趋势',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          20.heightBox,
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY > 0 ? maxY / 4 : 100,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.divider,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < last7Days.length) {
                          final date = last7Days[value.toInt()]['date'] as DateTime;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '${date.month}/${date.day}',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: last7Days.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value['amount']);
                    }).toList(),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.blue,
                          strokeWidth: 2,
                          strokeColor: AppColors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.withValues(alpha: 0.3),
                          Colors.blue.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                minY: 0,
                maxY: maxY > 0 ? maxY * 1.2 : 100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 支出类型饼状图卡片
  Widget _buildCategoryDistributionCard(BuildContext context, ExpenseController controller) {
    final typeExpenses = controller.getExpenseByType();
    final total = typeExpenses.values.fold(0.0, (sum, amount) => sum + amount);

    if (total == 0) {
      return const SizedBox.shrink();
    }

    final sortedEntries = typeExpenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.pie_chart_rounded,
                  color: Colors.purple,
                  size: 20,
                ),
              ),
              12.widthBox,
              Text(
                '支出分类',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          20.heightBox,
          Row(
            children: [
              // 饼状图
              SizedBox(
                width: 160,
                height: 160,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 45,
                    sections: sortedEntries.map((entry) {
                      final percentage = (entry.value / total * 100);
                      final color = _getTypeColor(entry.key);

                      return PieChartSectionData(
                        value: entry.value,
                        title: '${percentage.toStringAsFixed(0)}%',
                        color: color,
                        radius: 40,
                        titleStyle: context.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              24.widthBox,
              // 图例列表
              Expanded(
                child: Column(
                  children: sortedEntries.map((entry) {
                    final color = _getTypeColor(entry.key);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          8.widthBox,
                          Expanded(
                            child: Text(
                              entry.key.name,
                              style: context.textTheme.bodyMedium,
                            ),
                          ),
                          Text(
                            '¥${entry.value.toStringAsFixed(0)}',
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 辅助方法：获取当月总支出
  double _getCurrentMonthTotal(ExpenseController controller) {
    final now = DateTime.now();
    return controller.dailyExpenses
        .where((daily) =>
            daily.date.year == now.year &&
            daily.date.month == now.month)
        .fold(0.0, (sum, daily) => sum + daily.totalAmount);
  }

  // 辅助方法：获取上月总支出
  double _getLastMonthTotal(ExpenseController controller) {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1);
    return controller.dailyExpenses
        .where((daily) =>
            daily.date.year == lastMonth.year &&
            daily.date.month == lastMonth.month)
        .fold(0.0, (sum, daily) => sum + daily.totalAmount);
  }

  // 辅助方法：获取近7天数据
  List<Map<String, dynamic>> _getLast7DaysData(ExpenseController controller) {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final date = DateTime(now.year, now.month, now.day - (6 - index));
      final dailyExpense = controller.dailyExpenses.firstWhere(
        (de) => de.date.year == date.year &&
               de.date.month == date.month &&
               de.date.day == date.day,
        orElse: () => DailyExpense(date: date, expenses: []),
      );
      return {
        'date': date,
        'amount': dailyExpense.totalAmount,
      };
    });
  }

  // 辅助方法：根据类型获取颜色
  Color _getTypeColor(ExpenseType type) {
    switch (type.id) {
      case 'catering':
        return AppColors.catering;
      case 'transportation':
        return AppColors.transportation;
      case 'shopping':
        return AppColors.shopping;
      case 'communication':
        return AppColors.communication;
      default:
        return AppColors.primary;
    }
  }
}

