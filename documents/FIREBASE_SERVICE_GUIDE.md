# Firebase Service 使用指南

## 概述

`FirebaseService` 是一个完整的 Firebase Firestore 数据访问层，提供了消费记录（Expense）的增删改查以及统计功能。

## 功能特性

### ✨ 核心功能

- **完整的 CRUD 操作**：创建、读取、更新、删除消费记录
- **批量操作**：支持批量添加和删除
- **实时数据流**：使用 Stream 实时监听数据变化
- **查询过滤**：按日期范围、类型等条件查询
- **统计功能**：总金额、类型统计、记录数等
- **用户余额管理**：读取和更新用户余额
- **错误处理**：完善的异常处理机制

## 数据结构

### Firestore 数据库结构

```
users (collection)
├── {userId} (document)
│   ├── balance: number
│   └── expenses (subcollection)
│       ├── {expenseId} (document)
│       │   ├── type: string
│       │   ├── amount: number
│       │   ├── description: string
│       │   └── date: string (ISO8601)
│       └── ...
```

## 使用方法

### 1. 初始化

```dart
import 'package:money_track/data/services/firebase_service.dart';

final firebaseService = FirebaseService();
```

### 2. 创建数据（Create）

#### 2.1 添加单条消费记录

```dart
// 创建消费对象
final expense = Expense(
  type: ExpenseType.catering,
  amount: 50.5,
  description: '午餐',
  date: DateTime.now(),
);

// 添加到 Firebase
try {
  final id = await firebaseService.createExpense(expense);
  print('成功添加，ID: $id');
} catch (e) {
  print('添加失败: $e');
}
```

#### 2.2 批量添加消费记录

```dart
final expenses = [
  Expense(type: ExpenseType.catering, amount: 30.0, description: '早餐', date: DateTime.now()),
  Expense(type: ExpenseType.transportation, amount: 15.0, description: '地铁', date: DateTime.now()),
  Expense(type: ExpenseType.shopping, amount: 200.0, description: '购物', date: DateTime.now()),
];

try {
  await firebaseService.createExpensesBatch(expenses);
  print('批量添加成功');
} catch (e) {
  print('批量添加失败: $e');
}
```

### 3. 读取数据（Read）

#### 3.1 获取所有消费记录

```dart
try {
  final expenses = await firebaseService.fetchExpenses();
  for (final expense in expenses) {
    print('${expense.formattedDate}: ${expense.description} - ${expense.formattedAmount}');
  }
} catch (e) {
  print('获取失败: $e');
}
```

#### 3.2 根据日期范围查询

```dart
final startDate = DateTime(2024, 1, 1);
final endDate = DateTime.now();

try {
  final expenses = await firebaseService.fetchExpensesByDateRange(startDate, endDate);
  print('找到 ${expenses.length} 条记录');
} catch (e) {
  print('查询失败: $e');
}
```

#### 3.3 根据类型查询

```dart
try {
  final expenses = await firebaseService.fetchExpensesByType(ExpenseType.catering.id);
  print('餐饮类消费: ${expenses.length} 条');
} catch (e) {
  print('查询失败: $e');
}
```

#### 3.4 获取单条记录

```dart
try {
  final expense = await firebaseService.fetchExpenseById('expense_id_here');
  if (expense != null) {
    print('找到记录: ${expense.description}');
  }
} catch (e) {
  print('获取失败: $e');
}
```

### 4. 实时监听（Stream）

#### 4.1 监听所有消费记录

```dart
// 返回一个 Stream，每当数据变化时会自动更新
final subscription = firebaseService.streamExpenses().listen(
  (expenses) {
    print('实时更新: 当前有 ${expenses.length} 条记录');
    // 更新 UI
  },
  onError: (error) {
    print('监听错误: $error');
  },
);

// 取消监听
subscription.cancel();
```

#### 4.2 监听日期范围内的记录

```dart
final startDate = DateTime(2024, 1, 1);
final endDate = DateTime.now();

firebaseService.streamExpensesByDateRange(startDate, endDate).listen(
  (expenses) {
    print('范围内记录: ${expenses.length} 条');
  },
);
```

#### 4.3 在 GetX Controller 中使用 Stream

```dart
class ExpenseController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  final expenses = <Expense>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    // 订阅实时数据流
    _firebaseService.streamExpenses().listen(
      (data) {
        expenses.value = data;  // 自动更新 UI
      },
      onError: (error) {
        Get.snackbar('错误', '数据加载失败: $error');
      },
    );
  }
}
```

### 5. 更新数据（Update）

#### 5.1 更新整个记录

```dart
final updatedExpense = expense.copyWith(
  amount: 100.0,
  description: '更新后的描述',
);

try {
  await firebaseService.updateExpense(updatedExpense);
  print('更新成功');
} catch (e) {
  print('更新失败: $e');
}
```

#### 5.2 部分更新（只更新特定字段）

```dart
try {
  await firebaseService.updateExpenseFields('expense_id', {
    'amount': 80.0,
    'description': '新的描述',
  });
  print('字段更新成功');
} catch (e) {
  print('更新失败: $e');
}
```

### 6. 删除数据（Delete）

#### 6.1 删除单条记录

```dart
try {
  await firebaseService.deleteExpense('expense_id');
  print('删除成功');
} catch (e) {
  print('删除失败: $e');
}
```

#### 6.2 批量删除

```dart
final idsToDelete = ['id1', 'id2', 'id3'];

try {
  await firebaseService.deleteExpensesBatch(idsToDelete);
  print('批量删除成功');
} catch (e) {
  print('删除失败: $e');
}
```

#### 6.3 删除日期范围内的记录

```dart
final startDate = DateTime(2024, 1, 1);
final endDate = DateTime(2024, 1, 31);

try {
  await firebaseService.deleteExpensesByDateRange(startDate, endDate);
  print('范围内记录已删除');
} catch (e) {
  print('删除失败: $e');
}
```

### 7. 统计功能

#### 7.1 获取总消费金额

```dart
try {
  final total = await firebaseService.getTotalExpenses();
  print('总消费: ¥${total.toStringAsFixed(2)}');
} catch (e) {
  print('获取失败: $e');
}
```

#### 7.2 获取日期范围内的总消费

```dart
final startDate = DateTime(2024, 1, 1);
final endDate = DateTime.now();

try {
  final total = await firebaseService.getTotalExpensesByDateRange(startDate, endDate);
  print('范围内总消费: ¥${total.toStringAsFixed(2)}');
} catch (e) {
  print('获取失败: $e');
}
```

#### 7.3 获取各类型消费统计

```dart
try {
  final statistics = await firebaseService.getExpensesByTypeStatistics();
  statistics.forEach((typeId, amount) {
    print('$typeId: ¥${amount.toStringAsFixed(2)}');
  });
  // 输出示例:
  // catering: ¥500.50
  // transportation: ¥200.00
  // shopping: ¥1000.00
} catch (e) {
  print('获取失败: $e');
}
```

#### 7.4 获取记录总数

```dart
try {
  final count = await firebaseService.getExpensesCount();
  print('共有 $count 条消费记录');
} catch (e) {
  print('获取失败: $e');
}
```

### 8. 用户余额管理

#### 8.1 获取用户余额

```dart
try {
  final balance = await firebaseService.getUserBalance();
  print('当前余额: ¥${balance.toStringAsFixed(2)}');
} catch (e) {
  print('获取失败: $e');
}
```

#### 8.2 更新用户余额

```dart
try {
  await firebaseService.updateUserBalance(1000.0);
  print('余额已更新');
} catch (e) {
  print('更新失败: $e');
}
```

### 9. 其他操作

#### 9.1 清空所有消费记录（谨慎使用）

```dart
try {
  await firebaseService.clearAllExpenses();
  print('所有记录已清空');
} catch (e) {
  print('清空失败: $e');
}
```

## 在 ExpenseRepository 中的集成

`FirebaseService` 已经集成到 `ExpenseRepository` 中，通过 `_useFirebase` 标志控制：

```dart
// 在 expense_repository.dart 中
final bool _useFirebase = true;  // 设置为 true 使用 Firebase

// 获取消费记录时会自动使用 Firebase
final expenses = await expenseRepository.getExpenses(forceRefresh: true);

// 添加消费时会同步到 Firebase
await expenseRepository.addExpense(expense);
```

## 最佳实践

### 1. 错误处理

始终使用 try-catch 块处理可能的错误：

```dart
try {
  final expenses = await firebaseService.fetchExpenses();
  // 处理数据
} catch (e) {
  // 显示错误消息给用户
  Get.snackbar('错误', '无法加载数据: $e');
}
```

### 2. 使用 Stream 实现实时更新

对于需要实时更新的页面，使用 Stream 代替定期轮询：

```dart
// ✅ 推荐：使用 Stream
firebaseService.streamExpenses().listen((expenses) {
  // UI 自动更新
});

// ❌ 不推荐：定期轮询
Timer.periodic(Duration(seconds: 5), (_) {
  firebaseService.fetchExpenses();
});
```

### 3. 批量操作提高性能

需要添加或删除多条记录时，使用批量操作：

```dart
// ✅ 推荐：批量操作
await firebaseService.createExpensesBatch(expensesList);

// ❌ 不推荐：循环单个操作
for (final expense in expensesList) {
  await firebaseService.createExpense(expense);  // 每次都是一个网络请求
}
```

### 4. 合理使用查询条件

避免获取不必要的数据：

```dart
// ✅ 推荐：使用日期范围查询
final thisMonth = await firebaseService.fetchExpensesByDateRange(
  DateTime(2024, 1, 1),
  DateTime(2024, 1, 31),
);

// ❌ 不推荐：获取所有数据再过滤
final all = await firebaseService.fetchExpenses();
final thisMonth = all.where((e) => e.date.month == 1).toList();
```

### 5. 及时取消 Stream 订阅

```dart
late StreamSubscription<List<Expense>> _subscription;

@override
void onInit() {
  super.onInit();
  _subscription = firebaseService.streamExpenses().listen(/*...*/);
}

@override
void onClose() {
  _subscription.cancel();  // 防止内存泄漏
  super.onClose();
}
```

## 注意事项

1. **用户ID配置**：目前使用固定的用户ID `'default_user'`，在生产环境中应该从 Firebase Authentication 获取真实的用户ID。

2. **Firestore 索引**：如果使用复合查询（如同时按 date 和 type 查询），可能需要在 Firebase Console 中创建索引。

3. **网络连接**：所有操作都需要网络连接，建议配合本地缓存使用（已在 `ExpenseRepository` 中实现）。

4. **安全规则**：确保在 Firebase Console 中配置好 Firestore 安全规则，防止未授权访问。

示例安全规则：
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

5. **数据备份**：定期备份重要数据，可以使用 Firebase 的自动备份功能。

## 性能优化建议

1. **使用分页**：对于大量数据，实现分页加载
2. **添加缓存**：使用本地缓存减少网络请求
3. **延迟加载**：只在需要时加载数据
4. **离线持久化**：启用 Firestore 的离线持久化功能

```dart
// 在 main.dart 中启用离线持久化
FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true,
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);
```

## 故障排查

### 问题1: "Permission denied" 错误

**原因**: Firestore 安全规则限制了访问

**解决方案**: 检查并更新 Firebase Console 中的安全规则

### 问题2: Stream 不更新

**原因**: 可能是网络问题或监听器被取消

**解决方案**: 检查网络连接，确保 StreamSubscription 没有被过早取消

### 问题3: 数据不同步

**原因**: 可能使用了不同的用户ID

**解决方案**: 确保所有操作使用相同的用户ID

## 相关文件

- `lib/data/services/firebase_service.dart` - Firebase 服务实现
- `lib/data/services/firebase_service_example.dart` - 使用示例
- `lib/data/repositories/expense_repository.dart` - 数据仓库（集成了 Firebase）
- `lib/data/models/expense_model.dart` - 数据模型

## 更多资源

- [Firebase Firestore 官方文档](https://firebase.google.com/docs/firestore)
- [FlutterFire 文档](https://firebase.flutter.dev/)
- [GetX 状态管理](https://github.com/jonataslaw/getx)

