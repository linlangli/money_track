import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense_model.dart';

class LocalStorageService {
  static const String _expensesKey = 'expenses';
  static const String _balanceKey = 'balance';

  Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = expenses.map((e) => e.toJson()).toList();
    await prefs.setString(_expensesKey, jsonEncode(jsonList));
  }

  Future<List<Expense>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_expensesKey);

    if (jsonString == null) {
      return [];
    }

    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((json) => Expense.fromJson(json)).toList();
  }

  Future<void> addExpense(Expense expense) async {
    final expenses = await loadExpenses();
    expenses.add(expense);
    await saveExpenses(expenses);
  }

  Future<void> deleteExpense(String id) async {
    final expenses = await loadExpenses();
    expenses.removeWhere((expense) => expense.id == id);
    await saveExpenses(expenses);
  }

  Future<void> updateExpense(Expense expense) async {
    final expenses = await loadExpenses();
    final index = expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      expenses[index] = expense;
      await saveExpenses(expenses);
    }
  }

  Future<void> saveBalance(double balance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_balanceKey, balance);
  }

  Future<double> loadBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_balanceKey) ?? 0.0;
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

