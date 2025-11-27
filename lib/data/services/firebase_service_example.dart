/// Firebase Service 使用示例
///
/// 此文件展示如何使用 FirebaseService 进行各种数据库操作

import 'package:money_track/data/services/firebase_service.dart';
import 'package:money_track/data/models/expense_model.dart';

class FirebaseServiceExample {
  final FirebaseService _firebaseService = FirebaseService();

  /// 示例1: 添加消费记录
  Future<void> exampleAddExpense() async {
    final expense = Expense(
      type: ExpenseType.catering,
      amount: 50.5,
      description: '午餐',
      date: DateTime.now(),
    );

    try {
      final id = await _firebaseService.createExpense(expense);
      print('消费记录已添加，ID: $id');
    } catch (e) {
      print('添加失败: $e');
    }
  }

  /// 示例2: 批量添加消费记录
  Future<void> exampleBatchAddExpenses() async {
    final expenses = [
      Expense(
        type: ExpenseType.catering,
        amount: 30.0,
        description: '早餐',
        date: DateTime.now(),
      ),
      Expense(
        type: ExpenseType.transportation,
        amount: 15.0,
        description: '地铁',
        date: DateTime.now(),
      ),
      Expense(
        type: ExpenseType.shopping,
        amount: 200.0,
        description: '购物',
        date: DateTime.now(),
      ),
    ];

    try {
      await _firebaseService.createExpensesBatch(expenses);
      print('批量添加成功');
    } catch (e) {
      print('批量添加失败: $e');
    }
  }

  /// 示例3: 获取所有消费记录
  Future<void> exampleFetchAllExpenses() async {
    try {
      final expenses = await _firebaseService.fetchExpenses();
      print('获取到 ${expenses.length} 条消费记录');
      for (final expense in expenses) {
        print('${expense.formattedDate}: ${expense.description} - ${expense.formattedAmount}');
      }
    } catch (e) {
      print('获取失败: $e');
    }
  }

  /// 示例4: 根据日期范围获取消费记录
  Future<void> exampleFetchByDateRange() async {
    final startDate = DateTime(2024, 1, 1);
    final endDate = DateTime.now();

    try {
      final expenses = await _firebaseService.fetchExpensesByDateRange(
        startDate,
        endDate,
      );
      print('日期范围内有 ${expenses.length} 条消费记录');
    } catch (e) {
      print('获取失败: $e');
    }
  }

  /// 示例5: 根据类型获取消费记录
  Future<void> exampleFetchByType() async {
    try {
      final expenses = await _firebaseService.fetchExpensesByType(
        ExpenseType.catering.id,
      );
      print('餐饮类消费记录有 ${expenses.length} 条');
    } catch (e) {
      print('获取失败: $e');
    }
  }

  /// 示例6: 获取单个消费记录
  Future<void> exampleFetchById(String id) async {
    try {
      final expense = await _firebaseService.fetchExpenseById(id);
      if (expense != null) {
        print('找到消费记录: ${expense.description}');
      } else {
        print('未找到该消费记录');
      }
    } catch (e) {
      print('获取失败: $e');
    }
  }

  /// 示例7: 实时监听所有消费记录（Stream）
  void exampleStreamExpenses() {
    _firebaseService.streamExpenses().listen(
      (expenses) {
        print('实时更新: 当前有 ${expenses.length} 条消费记录');
      },
      onError: (error) {
        print('监听错误: $error');
      },
    );
  }

  /// 示例8: 实时监听指定日期范围的消费记录（Stream）
  void exampleStreamByDateRange() {
    final startDate = DateTime(2024, 1, 1);
    final endDate = DateTime.now();

    _firebaseService.streamExpensesByDateRange(startDate, endDate).listen(
      (expenses) {
        print('实时更新: 日期范围内有 ${expenses.length} 条消费记录');
      },
      onError: (error) {
        print('监听错误: $error');
      },
    );
  }

  /// 示例9: 更新消费记录
  Future<void> exampleUpdateExpense(String id) async {
    try {
      final expense = await _firebaseService.fetchExpenseById(id);
      if (expense != null) {
        final updatedExpense = expense.copyWith(
          amount: 100.0,
          description: '更新后的描述',
        );
        await _firebaseService.updateExpense(updatedExpense);
        print('消费记录已更新');
      }
    } catch (e) {
      print('更新失败: $e');
    }
  }

  /// 示例10: 部分更新消费记录
  Future<void> exampleUpdateExpenseFields(String id) async {
    try {
      await _firebaseService.updateExpenseFields(id, {
        'amount': 80.0,
        'description': '部分更新的描述',
      });
      print('消费记录字段已更新');
    } catch (e) {
      print('更新失败: $e');
    }
  }

  /// 示例11: 删除消费记录
  Future<void> exampleDeleteExpense(String id) async {
    try {
      await _firebaseService.deleteExpense(id);
      print('消费记录已删除');
    } catch (e) {
      print('删除失败: $e');
    }
  }

  /// 示例12: 批量删除消费记录
  Future<void> exampleBatchDeleteExpenses(List<String> ids) async {
    try {
      await _firebaseService.deleteExpensesBatch(ids);
      print('批量删除成功');
    } catch (e) {
      print('批量删除失败: $e');
    }
  }

  /// 示例13: 删除指定日期范围的消费记录
  Future<void> exampleDeleteByDateRange() async {
    final startDate = DateTime(2024, 1, 1);
    final endDate = DateTime(2024, 1, 31);

    try {
      await _firebaseService.deleteExpensesByDateRange(startDate, endDate);
      print('指定日期范围的消费记录已删除');
    } catch (e) {
      print('删除失败: $e');
    }
  }

  /// 示例14: 获取总消费金额
  Future<void> exampleGetTotalExpenses() async {
    try {
      final total = await _firebaseService.getTotalExpenses();
      print('总消费金额: ¥${total.toStringAsFixed(2)}');
    } catch (e) {
      print('获取失败: $e');
    }
  }

  /// 示例15: 获取指定日期范围的总消费金额
  Future<void> exampleGetTotalByDateRange() async {
    final startDate = DateTime(2024, 1, 1);
    final endDate = DateTime.now();

    try {
      final total = await _firebaseService.getTotalExpensesByDateRange(
        startDate,
        endDate,
      );
      print('日期范围内总消费金额: ¥${total.toStringAsFixed(2)}');
    } catch (e) {
      print('获取失败: $e');
    }
  }

  /// 示例16: 获取各类型消费统计
  Future<void> exampleGetTypeStatistics() async {
    try {
      final statistics = await _firebaseService.getExpensesByTypeStatistics();
      print('各类型消费统计:');
      statistics.forEach((typeId, amount) {
        print('  $typeId: ¥${amount.toStringAsFixed(2)}');
      });
    } catch (e) {
      print('获取失败: $e');
    }
  }

  /// 示例17: 获取消费记录总数
  Future<void> exampleGetExpensesCount() async {
    try {
      final count = await _firebaseService.getExpensesCount();
      print('消费记录总数: $count');
    } catch (e) {
      print('获取失败: $e');
    }
  }

  /// 示例18: 获取用户余额
  Future<void> exampleGetUserBalance() async {
    try {
      final balance = await _firebaseService.getUserBalance();
      print('用户余额: ¥${balance.toStringAsFixed(2)}');
    } catch (e) {
      print('获取失败: $e');
    }
  }

  /// 示例19: 更新用户余额
  Future<void> exampleUpdateUserBalance() async {
    try {
      await _firebaseService.updateUserBalance(1000.0);
      print('用户余额已更新');
    } catch (e) {
      print('更新失败: $e');
    }
  }

  /// 示例20: 清空所有消费记录（谨慎使用）
  Future<void> exampleClearAllExpenses() async {
    try {
      await _firebaseService.clearAllExpenses();
      print('所有消费记录已清空');
    } catch (e) {
      print('清空失败: $e');
    }
  }

  /// 示例21: 在Controller中使用Stream实时监听
  /// 这个示例展示如何在GetX Controller中集成Stream
  void exampleUseStreamInController() {
    // 在Controller的onInit中订阅
    _firebaseService.streamExpenses().listen(
      (expenses) {
        // 更新UI数据
        // 例如: this.expenses.value = expenses;
        print('收到实时更新的数据');
      },
      onError: (error) {
        // 处理错误
        print('Stream错误: $error');
      },
    );
  }

  /// 示例22: 综合使用 - 添加消费并自动刷新列表
  Future<void> exampleAddAndRefresh() async {
    // 使用Stream监听，当添加新消费后会自动更新UI
    final subscription = _firebaseService.streamExpenses().listen(
      (expenses) {
        print('当前消费记录数: ${expenses.length}');
      },
    );

    // 添加新消费记录
    await Future.delayed(Duration(seconds: 1));
    final expense = Expense(
      type: ExpenseType.catering,
      amount: 88.88,
      description: '测试消费',
      date: DateTime.now(),
    );

    await _firebaseService.createExpense(expense);
    print('消费已添加，列表会自动更新');

    // 清理订阅
    await Future.delayed(Duration(seconds: 3));
    subscription.cancel();
  }
}

