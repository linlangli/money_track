import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/expense_model.dart';
import '../../data/repositories/expense_repository.dart';
import '../../utils/debug_config.dart';

class ExpenseController extends GetxController {
  final ExpenseRepository _repository = ExpenseRepository();

  // Observable state
  final RxList<Expense> expenses = <Expense>[].obs;
  final RxList<DailyExpense> dailyExpenses = <DailyExpense>[].obs;
  final Rx<double> balance = 0.0.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Filter state
  final Rx<ExpenseType?> selectedType = Rx<ExpenseType?>(null);
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    // 根据调试配置决定加载真实数据还是假数据
    if (DebugConfig.useMockData) {
      loadMockData();
    } else {
      loadExpenses();
      loadBalance();
    }
  }

  /// 生成假数据用于调试数据可视化面板
  void loadMockData() {
    DebugConfig.info('开始加载假数据...');

    final now = DateTime.now();
    final mockExpenses = <Expense>[];
    final random = Random(42); // 固定种子保证数据一致性

    // 生成过去N天的支出数据
    for (int i = 0; i < DebugConfig.mockDataDays; i++) {
      final date = DateTime(now.year, now.month, now.day - i, 12, 0);

      // 每天生成随机数量的支出记录
      final dailyCount = DebugConfig.mockDailyRecordsMin +
          random.nextInt(DebugConfig.mockDailyRecordsMax - DebugConfig.mockDailyRecordsMin + 1);

      for (int j = 0; j < dailyCount; j++) {
        final type = ExpenseType.allTypes[random.nextInt(ExpenseType.allTypes.length)];

        // 根据类型生成更真实的金额分布
        double amount;
        switch (type.id) {
          case 'catering':
            // 餐饮: 15-150元，集中在30-80
            amount = 15 + random.nextDouble() * 135;
            if (random.nextDouble() > 0.3) {
              amount = 30 + random.nextDouble() * 50;
            }
            break;
          case 'transportation':
            // 交通: 5-100元，集中在10-40
            amount = 5 + random.nextDouble() * 95;
            if (random.nextDouble() > 0.2) {
              amount = 10 + random.nextDouble() * 30;
            }
            break;
          case 'shopping':
            // 购物: 50-500元，偶尔有大额
            amount = 50 + random.nextDouble() * 450;
            if (random.nextDouble() > 0.8) {
              amount = 200 + random.nextDouble() * 800; // 偶尔的大额购物
            }
            break;
          case 'communication':
            // 通讯: 10-100元
            amount = 10 + random.nextDouble() * 90;
            break;
          default:
            amount = 20 + random.nextDouble() * 80;
        }

        mockExpenses.add(Expense(
          id: 'mock_${i}_$j',
          type: type,
          amount: double.parse(amount.toStringAsFixed(2)),
          description: '${type.name} - 测试数据 #${mockExpenses.length + 1}',
          date: date.subtract(Duration(hours: j * 2, minutes: random.nextInt(60))),
        ));
      }
    }

    // 设置假数据
    expenses.value = mockExpenses;
    balance.value = 10000.00 - mockExpenses.fold(0.0, (sum, e) => sum + e.amount);

    // 应用过滤器分组
    _applyFilters();

    // 输出统计信息
    final currentMonthTotal = _getCurrentMonthTotal();
    final lastMonthTotal = _getLastMonthTotal();
    final changePercent = lastMonthTotal > 0
        ? ((currentMonthTotal - lastMonthTotal) / lastMonthTotal * 100).toStringAsFixed(1)
        : '0.0';

    DebugConfig.success('假数据加载完成！');
    DebugConfig.log('总记录数: ${mockExpenses.length} 条');
    DebugConfig.log('本月支出: ¥${currentMonthTotal.toStringAsFixed(2)}');
    DebugConfig.log('上月支出: ¥${lastMonthTotal.toStringAsFixed(2)}');
    DebugConfig.log('环比变化: $changePercent%');
    DebugConfig.log('当前余额: ¥${balance.value.toStringAsFixed(2)}');

    // 输出各类型统计
    final typeStats = getExpenseByType();
    DebugConfig.log('--- 支出分类统计 ---');
    typeStats.forEach((type, amount) {
      final percent = (amount / currentMonthTotal * 100).toStringAsFixed(1);
      DebugConfig.log('${type.name}: ¥${amount.toStringAsFixed(2)} ($percent%)');
    });
  }

  /// 获取当前月份总支出（用于调试）
  double _getCurrentMonthTotal() {
    final now = DateTime.now();
    return expenses.where((e) =>
      e.date.year == now.year && e.date.month == now.month
    ).fold(0.0, (sum, e) => sum + e.amount);
  }

  /// 获取上个月总支出（用于调试）
  double _getLastMonthTotal() {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1);
    return expenses.where((e) =>
      e.date.year == lastMonth.year && e.date.month == lastMonth.month
    ).fold(0.0, (sum, e) => sum + e.amount);
  }

  // Load expenses
  Future<void> loadExpenses({bool forceRefresh = false}) async {
    try {
      isLoading.value = true;
      error.value = '';

      final loadedExpenses = await _repository.getExpenses(
        forceRefresh: forceRefresh,
      );
      expenses.value = loadedExpenses;
      _applyFilters();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Add expense
  Future<void> addExpense(Expense expense) async {
    try {
      await _repository.addExpense(expense);
      expenses.add(expense);

      // Update balance
      balance.value -= expense.amount;
      await _repository.updateBalance(balance.value);

      _applyFilters();
      Get.back(); // Close add expense dialog
      Get.snackbar(
        '成功',
        '消费已添加',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        '错误',
        '添加失败: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
    }
  }

  // Delete expense
  Future<void> deleteExpense(String id) async {
    try {
      final expense = expenses.firstWhere((e) => e.id == id);
      await _repository.deleteExpense(id);
      expenses.removeWhere((e) => e.id == id);

      // Update balance
      balance.value += expense.amount;
      await _repository.updateBalance(balance.value);

      _applyFilters();
      Get.snackbar(
        '成功',
        '消费已删除',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        '错误',
        '删除失败: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
    }
  }

  // Load balance
  Future<void> loadBalance() async {
    try {
      balance.value = await _repository.getBalance();
    } catch (e) {
      // Ignore error
    }
  }

  // Apply filters
  void _applyFilters() {
    var filtered = List<Expense>.from(expenses);

    // Filter by date range
    if (startDate.value != null || endDate.value != null) {
      filtered = _repository.filterByDateRange(
        filtered,
        startDate.value,
        endDate.value,
      );
    }

    // Filter by type
    if (selectedType.value != null) {
      filtered = _repository.filterByType(filtered, selectedType.value);
    }

    // Group by date
    dailyExpenses.value = _repository.getDailyExpenses(filtered);
  }

  // Set filter type
  void setFilterType(ExpenseType? type) {
    selectedType.value = type;
    _applyFilters();
  }

  // Set date range filter
  void setDateRange(DateTime? start, DateTime? end) {
    startDate.value = start;
    endDate.value = end;
    _applyFilters();
  }

  // Reset filters
  void resetFilters() {
    selectedType.value = null;
    startDate.value = null;
    endDate.value = null;
    _applyFilters();
  }

  // Get total expense
  double get totalExpense {
    return dailyExpenses.fold(
      0,
      (sum, daily) => sum + daily.totalAmount,
    );
  }

  // Get expense by type statistics
  Map<ExpenseType, double> getExpenseByType() {
    final Map<ExpenseType, double> typeExpenses = {};

    for (final daily in dailyExpenses) {
      for (final expense in daily.expenses) {
        typeExpenses[expense.type] =
            (typeExpenses[expense.type] ?? 0) + expense.amount;
      }
    }

    return typeExpenses;
  }
}

