import '../models/expense_model.dart';
import '../services/local_storage_service.dart';
import '../services/api_service.dart';
import '../services/firebase_service.dart';

class ExpenseRepository {
  final LocalStorageService _localStorageService = LocalStorageService();
  final ApiService _apiService = ApiService();
  final FirebaseService _firebaseService = FirebaseService();

  // 是否使用Firebase作为主要数据源
  final bool _useFirebase = true;

  // Fetch expenses from local storage first, then sync with Firebase if needed
  Future<List<Expense>> getExpenses({bool forceRefresh = false}) async {
    try {
      if (forceRefresh) {
        // Try to fetch from Firebase first if enabled
        if (_useFirebase) {
          try {
            final expenses = await _firebaseService.fetchExpenses();
            await _localStorageService.saveExpenses(expenses);
            return expenses;
          } catch (e) {
            // Firebase failed, try API fallback
            final expenses = await _apiService.fetchExpenses();
            await _localStorageService.saveExpenses(expenses);
            return expenses;
          }
        } else {
          // Use API service
          final expenses = await _apiService.fetchExpenses();
          await _localStorageService.saveExpenses(expenses);
          return expenses;
        }
      } else {
        // Load from local storage
        return await _localStorageService.loadExpenses();
      }
    } catch (e) {
      // If all remote sources fail, fallback to local storage
      return await _localStorageService.loadExpenses();
    }
  }

  /// 实时监听消费记录（仅Firebase）
  Stream<List<Expense>> streamExpenses() {
    return _firebaseService.streamExpenses();
  }

  /// 实时监听指定日期范围的消费记录（仅Firebase）
  Stream<List<Expense>> streamExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _firebaseService.streamExpensesByDateRange(startDate, endDate);
  }

  Future<void> addExpense(Expense expense) async {
    // Save to local storage first
    await _localStorageService.addExpense(expense);

    // Try to sync with Firebase
    if (_useFirebase) {
      try {
        await _firebaseService.createExpense(expense);
      } catch (e) {
        // Ignore Firebase errors for now, data is already in local storage
      }
    } else {
      // Try to sync with API
      try {
        await _apiService.createExpense(expense);
      } catch (e) {
        // Ignore API errors for now
      }
    }
  }

  Future<void> deleteExpense(String id) async {
    await _localStorageService.deleteExpense(id);

    if (_useFirebase) {
      try {
        await _firebaseService.deleteExpense(id);
      } catch (e) {
        // Ignore Firebase errors
      }
    } else {
      try {
        await _apiService.deleteExpense(id);
      } catch (e) {
        // Ignore API errors
      }
    }
  }

  Future<void> updateExpense(Expense expense) async {
    await _localStorageService.updateExpense(expense);

    if (_useFirebase) {
      try {
        await _firebaseService.updateExpense(expense);
      } catch (e) {
        // Ignore Firebase errors
      }
    } else {
      try {
        await _apiService.updateExpense(expense);
      } catch (e) {
        // Ignore API errors
      }
    }
  }

  Future<double> getBalance() async {
    if (_useFirebase) {
      try {
        return await _firebaseService.getUserBalance();
      } catch (e) {
        // Fallback to local storage
        return await _localStorageService.loadBalance();
      }
    }
    return await _localStorageService.loadBalance();
  }

  Future<void> updateBalance(double balance) async {
    await _localStorageService.saveBalance(balance);

    if (_useFirebase) {
      try {
        await _firebaseService.updateUserBalance(balance);
      } catch (e) {
        // Ignore Firebase errors
      }
    }
  }

  /// 获取总消费金额
  Future<double> getTotalExpenses() async {
    if (_useFirebase) {
      try {
        return await _firebaseService.getTotalExpenses();
      } catch (e) {
        // Fallback to local calculation
        final expenses = await _localStorageService.loadExpenses();
        return expenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
      }
    }
    final expenses = await _localStorageService.loadExpenses();
    return expenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
  }

  /// 获取各类型消费统计
  Future<Map<String, double>> getExpensesByTypeStatistics() async {
    if (_useFirebase) {
      try {
        return await _firebaseService.getExpensesByTypeStatistics();
      } catch (e) {
        // Fallback to local calculation
        final expenses = await _localStorageService.loadExpenses();
        final Map<String, double> statistics = {};
        for (final expense in expenses) {
          statistics[expense.type.id] =
              (statistics[expense.type.id] ?? 0) + expense.amount;
        }
        return statistics;
      }
    }
    final expenses = await _localStorageService.loadExpenses();
    final Map<String, double> statistics = {};
    for (final expense in expenses) {
      statistics[expense.type.id] =
          (statistics[expense.type.id] ?? 0) + expense.amount;
    }
    return statistics;
  }

  // Filter expenses by date range
  List<Expense> filterByDateRange(
    List<Expense> expenses,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    if (startDate == null && endDate == null) {
      return expenses;
    }

    return expenses.where((expense) {
      if (startDate != null && expense.date.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && expense.date.isAfter(endDate)) {
        return false;
      }
      return true;
    }).toList();
  }

  // Filter expenses by type
  List<Expense> filterByType(List<Expense> expenses, ExpenseType? type) {
    if (type == null) {
      return expenses;
    }
    return expenses.where((expense) => expense.type.id == type.id).toList();
  }

  // Group expenses by date
  Map<DateTime, List<Expense>> groupByDate(List<Expense> expenses) {
    final Map<DateTime, List<Expense>> grouped = {};

    for (final expense in expenses) {
      final date = DateTime(expense.date.year, expense.date.month, expense.date.day);
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(expense);
    }

    return grouped;
  }

  // Get daily expenses sorted by date
  List<DailyExpense> getDailyExpenses(List<Expense> expenses) {
    final grouped = groupByDate(expenses);
    final dailyExpenses = grouped.entries
        .map((entry) => DailyExpense(date: entry.key, expenses: entry.value))
        .toList();

    dailyExpenses.sort((a, b) => b.date.compareTo(a.date));
    return dailyExpenses;
  }
}

