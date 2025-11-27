import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/expense_model.dart';
import '../../data/repositories/expense_repository.dart';

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
    loadExpenses();
    loadBalance();
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

