import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../controllers/expense_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/expense_model.dart';

class ExpenseChartPage extends StatelessWidget {
  const ExpenseChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ExpenseController controller = Get.find();

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.dailyExpenses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pie_chart_outline,
                    size: 80,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '暂无数据',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                // Total expense card
                _buildTotalExpenseCard(context, controller),
                const SizedBox(height: 24),

                // Category distribution
                _buildSectionTitle(context, AppStrings.categoryDistribution),
                const SizedBox(height: 16),
                _buildCategoryPieChart(context, controller),
                const SizedBox(height: 24),

                // Category list
                _buildCategoryList(context, controller),
                const SizedBox(height: 24),

                // Expense trend (last 7 days)
                _buildSectionTitle(context, AppStrings.expenseTrend),
                const SizedBox(height: 16),
                _buildTrendChart(context, controller),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTotalExpenseCard(BuildContext context, ExpenseController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.totalExpense,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.black.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '¥${controller.totalExpense.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatItem(
                context,
                '记录数',
                controller.expenses.length.toString(),
              ),
              const SizedBox(width: 32),
              _buildStatItem(
                context,
                '平均消费',
                '¥${(controller.totalExpense / (controller.dailyExpenses.isEmpty ? 1 : controller.dailyExpenses.length)).toStringAsFixed(2)}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.black.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCategoryPieChart(BuildContext context, ExpenseController controller) {
    final typeExpenses = controller.getExpenseByType();
    final total = typeExpenses.values.fold(0.0, (sum, amount) => sum + amount);

    if (total == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 50,
          sections: typeExpenses.entries.map((entry) {
            final percentage = (entry.value / total * 100);
            final color = _getTypeColor(entry.key);

            return PieChartSectionData(
              value: entry.value,
              title: '${percentage.toStringAsFixed(1)}%',
              color: color,
              radius: 80,
              titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, ExpenseController controller) {
    final typeExpenses = controller.getExpenseByType();
    final sortedEntries = typeExpenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
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
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  entry.key.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                Text(
                  '¥${entry.value.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTrendChart(BuildContext context, ExpenseController controller) {
    // Get last 7 days data
    final now = DateTime.now();
    final last7Days = List.generate(7, (index) {
      return DateTime(now.year, now.month, now.day - (6 - index));
    });

    final dailyTotals = last7Days.map((date) {
      final dailyExpense = controller.dailyExpenses.firstWhere(
        (de) => de.date.year == date.year &&
               de.date.month == date.month &&
               de.date.day == date.day,
        orElse: () => DailyExpense(date: date, expenses: []),
      );
      return dailyExpense.totalAmount;
    }).toList();

    final maxY = dailyTotals.reduce((a, b) => a > b ? a : b);

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY > 0 ? maxY / 4 : 100,
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < last7Days.length) {
                    final date = last7Days[value.toInt()];
                    return Text(
                      '${date.month}/${date.day}',
                      style: Theme.of(context).textTheme.bodySmall,
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
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: Theme.of(context).textTheme.bodySmall,
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
              spots: dailyTotals.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value);
              }).toList(),
              isCurved: true,
              color: AppColors.primary,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

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

