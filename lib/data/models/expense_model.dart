import 'package:intl/intl.dart';

class ExpenseType {
  final String id;
  final String name;
  final String iconPath;

  const ExpenseType({
    required this.id,
    required this.name,
    required this.iconPath,
  });

  static const ExpenseType catering = ExpenseType(
    id: 'catering',
    name: '餐饮',
    iconPath: 'assets/icons/icon_expend_type_catering.svg',
  );

  static const ExpenseType transportation = ExpenseType(
    id: 'transportation',
    name: '交通',
    iconPath: 'assets/icons/icon_expend_type_transportation.svg',
  );

  static const ExpenseType shopping = ExpenseType(
    id: 'shopping',
    name: '购物',
    iconPath: 'assets/icons/icon_expend_type_shopping.svg',
  );

  static const ExpenseType communication = ExpenseType(
    id: 'communication',
    name: '通讯',
    iconPath: 'assets/icons/icon_expend_type_communication.svg',
  );

  static const List<ExpenseType> allTypes = [
    catering,
    transportation,
    shopping,
    communication,
  ];

  static ExpenseType? fromId(String id) {
    try {
      return allTypes.firstWhere((type) => type.id == id);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconPath': iconPath,
    };
  }

  factory ExpenseType.fromJson(Map<String, dynamic> json) {
    return ExpenseType(
      id: json['id'] as String,
      name: json['name'] as String,
      iconPath: json['iconPath'] as String,
    );
  }
}

class Expense {
  final String id;
  final ExpenseType type;
  final double amount;
  final String description;
  final DateTime date;

  Expense({
    String? id,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  String get formattedAmount => '¥${amount.toStringAsFixed(2)}';

  String get formattedDate => DateFormat('yyyy-MM-dd').format(date);

  String get formattedTime => DateFormat('HH:mm').format(date);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.id,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      type: ExpenseType.fromId(json['type'] as String) ?? ExpenseType.catering,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Expense copyWith({
    String? id,
    ExpenseType? type,
    double? amount,
    String? description,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }
}

class DailyExpense {
  final DateTime date;
  final List<Expense> expenses;

  DailyExpense({
    required this.date,
    required this.expenses,
  });

  double get totalAmount {
    return expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  String get formattedDate => DateFormat('MM月dd日 EEEE', 'zh_CN').format(date);

  String get formattedTotalAmount => '¥${totalAmount.toStringAsFixed(2)}';
}

