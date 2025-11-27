# Firebase 快速配置指南

## 1. Firebase 项目配置

### 1.1 在 Firebase Console 中创建项目

1. 访问 [Firebase Console](https://console.firebase.google.com/)
2. 创建新项目或选择现有项目
3. 添加 iOS 和 Android 应用

### 1.2 配置 Firestore 数据库

1. 在 Firebase Console 中，进入 **Firestore Database**
2. 点击 **创建数据库**
3. 选择 **测试模式** 或 **生产模式**
   - 测试模式：允许所有读写（仅用于开发）
   - 生产模式：需要配置安全规则

### 1.3 配置 Firestore 安全规则

在 Firebase Console 的 Firestore 规则编辑器中，添加以下规则：

#### 测试环境规则（允许所有访问）
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

#### 生产环境规则（推荐）
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 用户只能访问自己的数据
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 2. 项目集成

### 2.1 依赖项已配置

以下依赖已在 `pubspec.yaml` 中配置：
```yaml
dependencies:
  firebase_core: ^4.2.1
  cloud_firestore: ^6.1.0
```

### 2.2 Firebase 初始化

Firebase 已在 `main.dart` 中初始化：
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

## 3. 启用 Firebase 数据源

### 3.1 在 ExpenseRepository 中启用

编辑 `lib/data/repositories/expense_repository.dart`：

```dart
class ExpenseRepository {
  // ...
  
  // 设置为 true 启用 Firebase
  final bool _useFirebase = true;  // ✅ 启用 Firebase
  
  // ...
}
```

### 3.2 配置用户ID（可选）

如果使用 Firebase Authentication，更新 `lib/data/services/firebase_service.dart`：

```dart
class FirebaseService {
  // ...
  
  // 方式1：使用固定用户ID（当前默认）
  String get _userId => 'default_user';
  
  // 方式2：从 Firebase Auth 获取（推荐）
  // String get _userId => FirebaseAuth.instance.currentUser?.uid ?? 'default_user';
  
  // ...
}
```

## 4. 启用离线持久化（可选但推荐）

在 `main.dart` 的 Firebase 初始化后添加：

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // 启用 Firestore 离线持久化
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  
  runApp(const MyApp());
}
```

## 5. 基本使用

### 5.1 通过 Repository 使用（推荐）

```dart
class ExpenseController extends GetxController {
  final ExpenseRepository _repository = ExpenseRepository();
  
  // 获取消费记录（自动从 Firebase 获取）
  Future<void> loadExpenses() async {
    final expenses = await _repository.getExpenses(forceRefresh: true);
    // 处理数据...
  }
  
  // 添加消费记录（自动同步到 Firebase）
  Future<void> addExpense(Expense expense) async {
    await _repository.addExpense(expense);
  }
}
```

### 5.2 直接使用 FirebaseService

```dart
class MyController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  
  // 实时监听数据
  @override
  void onInit() {
    super.onInit();
    _firebaseService.streamExpenses().listen((expenses) {
      // UI 自动更新
      this.expenses.value = expenses;
    });
  }
}
```

## 6. 测试 Firebase 连接

### 6.1 添加测试数据

在应用中运行以下代码测试：

```dart
final firebaseService = FirebaseService();

// 添加测试数据
final testExpense = Expense(
  type: ExpenseType.catering,
  amount: 50.0,
  description: '测试消费',
  date: DateTime.now(),
);

try {
  final id = await firebaseService.createExpense(testExpense);
  print('✅ Firebase 连接成功！记录ID: $id');
} catch (e) {
  print('❌ Firebase 连接失败: $e');
}
```

### 6.2 检查 Firebase Console

1. 打开 Firebase Console
2. 进入 Firestore Database
3. 查看 `users/default_user/expenses` 集合
4. 应该能看到刚才添加的测试数据

## 7. 常见问题

### 问题1: "FirebaseException: [cloud_firestore/permission-denied]"

**原因**: Firestore 安全规则限制了访问

**解决方案**: 
1. 检查 Firebase Console 中的安全规则
2. 在开发阶段可以临时使用测试模式规则
3. 确保用户ID正确

### 问题2: 数据不显示

**原因**: 可能是网络问题或初始化未完成

**解决方案**:
1. 检查网络连接
2. 确保 `Firebase.initializeApp()` 已完成
3. 检查 Firebase Console 中是否有数据

### 问题3: iOS 编译错误

**原因**: iOS 最低部署版本要求

**解决方案**:
已在 `ios/Podfile` 中配置为 iOS 15.0：
```ruby
platform :ios, '15.0'
```

### 问题4: Android 编译错误

**解决方案**:
确保 `android/app/build.gradle.kts` 中配置了正确的 minSdkVersion：
```kotlin
minSdk = 21  // Firebase 最低要求
```

## 8. 性能优化建议

### 8.1 使用索引

对于复杂查询，在 Firebase Console 中创建索引。

示例：如果经常按日期和类型查询：
```
集合: users/{userId}/expenses
字段: date (升序), type (升序)
```

### 8.2 限制查询结果

```dart
// 获取最近 30 天的数据
final startDate = DateTime.now().subtract(Duration(days: 30));
final expenses = await firebaseService.fetchExpensesByDateRange(
  startDate,
  DateTime.now(),
);
```

### 8.3 使用 Stream 而不是轮询

```dart
// ✅ 推荐：使用 Stream
firebaseService.streamExpenses().listen((data) {
  // 实时更新
});

// ❌ 不推荐：定时刷新
Timer.periodic(Duration(seconds: 5), (_) {
  firebaseService.fetchExpenses();
});
```

## 9. 数据迁移

### 9.1 从本地存储迁移到 Firebase

如果已有本地数据，可以使用以下代码迁移：

```dart
Future<void> migrateLocalDataToFirebase() async {
  final localStorageService = LocalStorageService();
  final firebaseService = FirebaseService();
  
  // 获取本地数据
  final localExpenses = await localStorageService.loadExpenses();
  
  // 批量上传到 Firebase
  await firebaseService.createExpensesBatch(localExpenses);
  
  print('迁移完成！共迁移 ${localExpenses.length} 条记录');
}
```

## 10. 监控和调试

### 10.1 启用 Firebase 调试日志

在 `main.dart` 中添加：

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // ...
  
  // 启用调试日志
  if (kDebugMode) {
    FirebaseFirestore.setLoggingEnabled(true);
  }
  
  // ...
}
```

### 10.2 使用 Firebase Emulator（本地开发）

```dart
void main() async {
  // ...
  
  // 连接到本地 Firestore Emulator
  if (kDebugMode) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }
  
  // ...
}
```

## 11. 下一步

1. ✅ 配置完成后，运行应用测试 Firebase 连接
2. ✅ 查看 [FIREBASE_SERVICE_GUIDE.md](FIREBASE_SERVICE_GUIDE.md) 了解详细的 API 使用方法
3. ✅ 查看 [firebase_service_example.dart](../lib/data/services/firebase_service_example.dart) 获取代码示例
4. ✅ 根据需要配置 Firebase Authentication
5. ✅ 在生产环境前，配置正确的安全规则

## 相关资源

- [Firebase 官方文档](https://firebase.google.com/docs)
- [FlutterFire 文档](https://firebase.flutter.dev/)
- [Firestore 数据建模最佳实践](https://firebase.google.com/docs/firestore/data-model)
- [Firestore 安全规则指南](https://firebase.google.com/docs/firestore/security/get-started)

