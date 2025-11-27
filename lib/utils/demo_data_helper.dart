import '../data/models/expense_model.dart';
import '../data/repositories/expense_repository.dart';

class DemoDataHelper {
  static final ExpenseRepository _repository = ExpenseRepository();

  static Future<void> initializeDemoData() async {
    // Check if data already exists
    final existingExpenses = await _repository.getExpenses();
    if (existingExpenses.isNotEmpty) {
      return; // Don't initialize if data exists
    }

    // Initialize balance
    await _repository.updateBalance(10000.0);

    // Create demo expenses
    final now = DateTime.now();
    final demoExpenses = [
      Expense(
        type: ExpenseType.catering,
        amount: 58.5,
        description: '午餐 - 川菜馆',
        date: DateTime(now.year, now.month, now.day, 12, 30),
      ),
      Expense(
        type: ExpenseType.transportation,
        amount: 15.0,
        description: '地铁出行',
        date: DateTime(now.year, now.month, now.day, 9, 0),
      ),
      Expense(
        type: ExpenseType.shopping,
        amount: 299.0,
        description: '购买T恤',
        date: DateTime(now.year, now.month, now.day - 1, 15, 20),
      ),
      Expense(
        type: ExpenseType.communication,
        amount: 50.0,
        description: '手机话费充值',
        date: DateTime(now.year, now.month, now.day - 1, 10, 0),
      ),
      Expense(
        type: ExpenseType.catering,
        amount: 85.0,
        description: '晚餐 - 日料',
        date: DateTime(now.year, now.month, now.day - 2, 19, 0),
      ),
      Expense(
        type: ExpenseType.transportation,
        amount: 25.0,
        description: '打车回家',
        date: DateTime(now.year, now.month, now.day - 2, 22, 30),
      ),
      Expense(
        type: ExpenseType.shopping,
        amount: 128.0,
        description: '买书',
        date: DateTime(now.year, now.month, now.day - 3, 14, 0),
      ),
      Expense(
        type: ExpenseType.catering,
        amount: 32.0,
        description: '星巴克咖啡',
        date: DateTime(now.year, now.month, now.day - 3, 10, 30),
      ),
    ];

    // Save all demo expenses
    for (final expense in demoExpenses) {
      await _repository.addExpense(expense);
    }
  }
}

