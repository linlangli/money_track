import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/expense_model.dart';

/// Firebase服务类 - 处理与Firebase Firestore的数据交互
class FirebaseService {
  // Firestore实例
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 集合名称
  static const String _expensesCollection = 'expenses';
  static const String _usersCollection = 'users';

  // 用户ID - 从Firebase Auth获取真实用户ID
  String get _userId => _auth.currentUser?.uid ?? 'default_user';

  /// 获取当前用户的消费记录集合引用
  CollectionReference<Map<String, dynamic>> get _userExpensesRef {
    return _firestore
        .collection(_usersCollection)
        .doc(_userId)
        .collection(_expensesCollection);
  }

  // ==================== 读取数据方法 ====================

  /// 获取所有消费记录
  /// 返回按日期降序排列的消费记录列表
  Future<List<Expense>> fetchExpenses() async {
    try {
      final querySnapshot = await _userExpensesRef
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Expense.fromJson({
                ...doc.data(),
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      throw Exception('获取消费记录失败: $e');
    }
  }

  /// 根据日期范围获取消费记录
  /// [startDate] 开始日期
  /// [endDate] 结束日期
  Future<List<Expense>> fetchExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final querySnapshot = await _userExpensesRef
          .where('date',
              isGreaterThanOrEqualTo: startDate.toIso8601String())
          .where('date', isLessThanOrEqualTo: endDate.toIso8601String())
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Expense.fromJson({
                ...doc.data(),
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      throw Exception('获取指定日期范围的消费记录失败: $e');
    }
  }

  /// 根据类型获取消费记录
  /// [typeId] 消费类型ID
  Future<List<Expense>> fetchExpensesByType(String typeId) async {
    try {
      final querySnapshot = await _userExpensesRef
          .where('type', isEqualTo: typeId)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Expense.fromJson({
                ...doc.data(),
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      throw Exception('获取指定类型的消费记录失败: $e');
    }
  }

  /// 获取单个消费记录
  /// [id] 消费记录ID
  Future<Expense?> fetchExpenseById(String id) async {
    try {
      final docSnapshot = await _userExpensesRef.doc(id).get();

      if (!docSnapshot.exists) {
        return null;
      }

      return Expense.fromJson({
        ...docSnapshot.data()!,
        'id': docSnapshot.id,
      });
    } catch (e) {
      throw Exception('获取消费记录失败: $e');
    }
  }

  /// 实时监听所有消费记录
  /// 返回一个Stream，可以实时接收数据更新
  Stream<List<Expense>> streamExpenses() {
    try {
      return _userExpensesRef
          .orderBy('date', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Expense.fromJson({
                    ...doc.data(),
                    'id': doc.id,
                  }))
              .toList());
    } catch (e) {
      throw Exception('监听消费记录失败: $e');
    }
  }

  /// 实时监听指定日期范围的消费记录
  Stream<List<Expense>> streamExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    try {
      return _userExpensesRef
          .where('date',
              isGreaterThanOrEqualTo: startDate.toIso8601String())
          .where('date', isLessThanOrEqualTo: endDate.toIso8601String())
          .orderBy('date', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Expense.fromJson({
                    ...doc.data(),
                    'id': doc.id,
                  }))
              .toList());
    } catch (e) {
      throw Exception('监听指定日期范围的消费记录失败: $e');
    }
  }

  // ==================== 写入数据方法 ====================

  /// 添加新的消费记录
  /// [expense] 消费记录对象
  /// 返回创建的文档ID
  Future<String> createExpense(Expense expense) async {
    try {
      final docRef = await _userExpensesRef.add(expense.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('添加消费记录失败: $e');
    }
  }

  /// 批量添加消费记录
  /// [expenses] 消费记录列表
  Future<void> createExpensesBatch(List<Expense> expenses) async {
    try {
      final batch = _firestore.batch();

      for (final expense in expenses) {
        final docRef = _userExpensesRef.doc();
        batch.set(docRef, expense.toJson());
      }

      await batch.commit();
    } catch (e) {
      throw Exception('批量添加消费记录失败: $e');
    }
  }

  /// 更新消费记录
  /// [expense] 包含更新后数据的消费记录对象
  Future<void> updateExpense(Expense expense) async {
    try {
      await _userExpensesRef.doc(expense.id).update(expense.toJson());
    } catch (e) {
      throw Exception('更新消费记录失败: $e');
    }
  }

  /// 部分更新消费记录
  /// [id] 消费记录ID
  /// [data] 需要更新的字段Map
  Future<void> updateExpenseFields(String id, Map<String, dynamic> data) async {
    try {
      await _userExpensesRef.doc(id).update(data);
    } catch (e) {
      throw Exception('更新消费记录字段失败: $e');
    }
  }

  /// 删除消费记录
  /// [id] 消费记录ID
  Future<void> deleteExpense(String id) async {
    try {
      await _userExpensesRef.doc(id).delete();
    } catch (e) {
      throw Exception('删除消费记录失败: $e');
    }
  }

  /// 批量删除消费记录
  /// [ids] 消费记录ID列表
  Future<void> deleteExpensesBatch(List<String> ids) async {
    try {
      final batch = _firestore.batch();

      for (final id in ids) {
        batch.delete(_userExpensesRef.doc(id));
      }

      await batch.commit();
    } catch (e) {
      throw Exception('批量删除消费记录失败: $e');
    }
  }

  /// 删除指定日期范围内的所有消费记录
  /// [startDate] 开始日期
  /// [endDate] 结束日期
  Future<void> deleteExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final querySnapshot = await _userExpensesRef
          .where('date',
              isGreaterThanOrEqualTo: startDate.toIso8601String())
          .where('date', isLessThanOrEqualTo: endDate.toIso8601String())
          .get();

      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('删除指定日期范围的消费记录失败: $e');
    }
  }

  // ==================== 统计数据方法 ====================

  /// 获取总消费金额
  Future<double> getTotalExpenses() async {
    try {
      final querySnapshot = await _userExpensesRef.get();
      double total = 0;

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        total += (data['amount'] as num).toDouble();
      }

      return total;
    } catch (e) {
      throw Exception('获取总消费金额失败: $e');
    }
  }

  /// 获取指定日期范围的总消费金额
  Future<double> getTotalExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final expenses = await fetchExpensesByDateRange(startDate, endDate);
      return expenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
    } catch (e) {
      throw Exception('获取指定日期范围的总消费金额失败: $e');
    }
  }

  /// 获取各类型消费统计
  /// 返回Map，key为类型ID，value为该类型的总金额
  Future<Map<String, double>> getExpensesByTypeStatistics() async {
    try {
      final querySnapshot = await _userExpensesRef.get();
      final Map<String, double> statistics = {};

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final typeId = data['type'] as String;
        final amount = (data['amount'] as num).toDouble();

        statistics[typeId] = (statistics[typeId] ?? 0) + amount;
      }

      return statistics;
    } catch (e) {
      throw Exception('获取各类型消费统计失败: $e');
    }
  }

  /// 获取消费记录总数
  Future<int> getExpensesCount() async {
    try {
      final querySnapshot = await _userExpensesRef.get();
      return querySnapshot.size;
    } catch (e) {
      throw Exception('获取消费记录总数失败: $e');
    }
  }

  // ==================== 用户数据方法 ====================

  /// 获取用户余额
  Future<double> getUserBalance() async {
    try {
      final userDoc = await _firestore.collection(_usersCollection).doc(_userId).get();

      if (!userDoc.exists) {
        return 0.0;
      }

      final data = userDoc.data();
      return (data?['balance'] as num?)?.toDouble() ?? 0.0;
    } catch (e) {
      throw Exception('获取用户余额失败: $e');
    }
  }

  /// 更新用户余额
  /// [balance] 新的余额
  Future<void> updateUserBalance(double balance) async {
    try {
      await _firestore.collection(_usersCollection).doc(_userId).set(
        {'balance': balance},
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('更新用户余额失败: $e');
    }
  }

  /// 清空所有数据（谨慎使用）
  /// 删除当前用户的所有消费记录
  Future<void> clearAllExpenses() async {
    try {
      final querySnapshot = await _userExpensesRef.get();
      final batch = _firestore.batch();

      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('清空所有消费记录失败: $e');
    }
  }
}

