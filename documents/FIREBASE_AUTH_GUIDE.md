# Firebase Authentication 登录功能使用指南

## 概述

本项目已集成完整的 Firebase Authentication 登录系统，支持邮箱密码认证、用户资料管理、密码重置等功能。

## 🎯 已实现的功能

### ✅ 核心功能
1. **用户注册** - 邮箱密码注册
2. **用户登录** - 邮箱密码登录
3. **用户登出** - 安全登出
4. **忘记密码** - 邮箱重置密码
5. **修改密码** - 在线修改密码
6. **用户资料管理** - 查看和编辑资料
7. **邮箱验证** - 发送验证邮件
8. **账户删除** - 删除用户账户

### ✅ 附加特性
- 自动状态管理（使用 GetX）
- 用户认证状态监听
- Firestore 用户数据同步
- 离线持久化支持
- 错误处理和用户提示
- 表单验证

## 📁 文件结构

```
lib/
├── controllers/
│   └── auth_controller.dart           # 认证控制器
├── data/
│   └── services/
│       ├── auth_service.dart          # Firebase Auth 服务
│       └── firebase_service.dart      # Firestore 服务（已更新）
├── pages/
│   └── auth/
│       ├── login_page.dart            # 登录页面
│       ├── register_page.dart         # 注册页面
│       ├── forgot_password_page.dart  # 忘记密码页面
│       ├── profile_page.dart          # 用户资料页面
│       └── change_password_page.dart  # 修改密码页面
├── core/
│   └── middleware/
│       └── auth_middleware.dart       # 认证中间件
└── main.dart                          # 已更新，初始化认证
```

## 🚀 快速开始

### 1. Firebase Console 配置

#### 1.1 启用 Authentication

1. 登录 [Firebase Console](https://console.firebase.google.com/)
2. 选择您的项目
3. 点击左侧菜单的 **Authentication**
4. 点击 **开始使用**
5. 在 **Sign-in method** 标签页中，启用 **电子邮件/密码** 提供商

#### 1.2 配置 Firestore 安全规则

在 Firebase Console 的 **Firestore Database** > **规则** 中，更新规则：

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 用户只能访问自己的数据
    match /users/{userId} {
      // 允许用户读取和写入自己的资料
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // 用户的消费记录
      match /expenses/{expenseId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

### 2. 测试登录功能

运行应用后：

1. **注册新账户**
   - 点击顶部导航栏的登录图标
   - 点击"创建新账户"
   - 填写用户名、邮箱和密码
   - 点击"注册"

2. **登录**
   - 输入注册的邮箱和密码
   - 点击"登录"

3. **查看资料**
   - 登录后，点击顶部导航栏的用户图标
   - 查看和编辑个人资料

## 💻 使用方法

### 基本使用

#### 1. 在页面中使用 AuthController

```dart
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class MyPage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (authController.isLoggedIn) {
        return Text('欢迎, ${authController.displayName}');
      } else {
        return Text('请先登录');
      }
    });
  }
}
```

#### 2. 监听认证状态

```dart
// 在 Controller 或 Widget 中监听
authController.user.listen((user) {
  if (user != null) {
    print('用户已登录: ${user.email}');
  } else {
    print('用户未登录');
  }
});
```

#### 3. 执行登录操作

```dart
// 登录
final success = await authController.signInWithEmail(
  email: 'user@example.com',
  password: 'password123',
);

if (success) {
  // 登录成功
  Get.snackbar('成功', '欢迎回来！');
}
```

#### 4. 执行注册操作

```dart
// 注册
final success = await authController.registerWithEmail(
  email: 'newuser@example.com',
  password: 'password123',
  displayName: '新用户',
);

if (success) {
  // 注册成功
  Get.snackbar('成功', '注册成功！');
}
```

#### 5. 登出

```dart
await authController.signOut();
```

### 高级功能

#### 1. 获取用户资料

```dart
final profile = await authController.getUserProfile();
if (profile != null) {
  print('余额: ${profile['balance']}');
  print('注册时间: ${profile['createdAt']}');
}
```

#### 2. 更新用户资料

```dart
await authController.updateUserProfile({
  'balance': 1000.0,
  'customField': 'value',
});
```

#### 3. 修改密码

```dart
final success = await authController.updatePassword(
  currentPassword: 'oldPassword',
  newPassword: 'newPassword123',
);
```

#### 4. 发送密码重置邮件

```dart
await authController.sendPasswordResetEmail('user@example.com');
```

#### 5. 删除账户

```dart
final success = await authController.deleteAccount('password123');
```

### 使用认证中间件

#### 方式1: 在 GetX 路由中使用

```dart
GetPage(
  name: '/protected',
  page: () => ProtectedPage(),
  middlewares: [AuthMiddleware()],
)
```

#### 方式2: 包装需要认证的页面

```dart
Widget build(BuildContext context) {
  return AuthWrapper(
    requireAuth: true,
    child: YourProtectedPage(),
  );
}
```

## 🔧 配置选项

### 自定义用户数据结构

在 `auth_service.dart` 的 `_createUserDocument` 方法中修改：

```dart
Future<void> _createUserDocument({
  required String userId,
  required String email,
  String? displayName,
}) async {
  await _firestore.collection(_usersCollection).doc(userId).set({
    'email': email,
    'displayName': displayName ?? '',
    'photoURL': '',
    'balance': 0.0,
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
    'lastLoginAt': FieldValue.serverTimestamp(),
    // 添加自定义字段
    'customField1': 'value1',
    'customField2': 'value2',
  });
}
```

### 自定义错误消息

在 `auth_service.dart` 的 `_handleAuthException` 方法中修改：

```dart
String _handleAuthException(FirebaseAuthException e) {
  switch (e.code) {
    case 'email-already-in-use':
      return '该邮箱已被注册';
    // 添加更多错误处理
    case 'custom-error-code':
      return '自定义错误消息';
    default:
      return '认证失败: ${e.message ?? e.code}';
  }
}
```

## 📊 Firestore 数据结构

### 用户文档结构

```
users (collection)
├── {userId} (document)
│   ├── email: string
│   ├── displayName: string
│   ├── photoURL: string
│   ├── balance: number
│   ├── createdAt: timestamp
│   ├── updatedAt: timestamp
│   ├── lastLoginAt: timestamp
│   └── expenses (subcollection)
│       ├── {expenseId} (document)
│       │   ├── type: string
│       │   ├── amount: number
│       │   ├── description: string
│       │   └── date: string
│       └── ...
```

## 🎨 UI 组件

### 登录页面 (LoginPage)
- 邮箱输入框
- 密码输入框（可显示/隐藏）
- 登录按钮（带加载状态）
- 忘记密码链接
- 注册链接

### 注册页面 (RegisterPage)
- 用户名输入框
- 邮箱输入框
- 密码输入框
- 确认密码输入框
- 注册按钮（带加载状态）

### 用户资料页面 (ProfilePage)
- 用户头像显示
- 用户名和邮箱显示
- 邮箱验证状态
- 编辑资料功能
- 修改密码功能
- 登出按钮

### 修改密码页面 (ChangePasswordPage)
- 当前密码输入框
- 新密码输入框
- 确认新密码输入框
- 确认修改按钮

## 🔐 安全最佳实践

### 1. 密码强度要求

当前密码最低要求为 6 位，可以在表单验证中增强：

```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return '请输入密码';
  }
  if (value.length < 8) {
    return '密码至少8位';
  }
  if (!value.contains(RegExp(r'[A-Z]'))) {
    return '密码必须包含大写字母';
  }
  if (!value.contains(RegExp(r'[0-9]'))) {
    return '密码必须包含数字';
  }
  return null;
}
```

### 2. 强制邮箱验证

在需要验证邮箱的功能中添加检查：

```dart
if (!await authController.isEmailVerified()) {
  Get.snackbar('提示', '请先验证您的邮箱');
  return;
}
```

### 3. 重新认证敏感操作

对于修改密码、删除账户等敏感操作，已实现重新认证机制。

## 📱 完整使用示例

### 示例1: 登录流程

```dart
class LoginExample extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> handleLogin() async {
    final success = await authController.signInWithEmail(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (success) {
      // 登录成功，导航到主页
      Get.offAll(() => HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(controller: emailController),
          TextField(controller: passwordController, obscureText: true),
          ElevatedButton(
            onPressed: handleLogin,
            child: Text('登录'),
          ),
        ],
      ),
    );
  }
}
```

### 示例2: 条件显示内容

```dart
class ConditionalContent extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (authController.isLoggedIn) {
        return Column(
          children: [
            Text('欢迎, ${authController.displayName}'),
            Text('邮箱: ${authController.userEmail}'),
            ElevatedButton(
              onPressed: () => authController.signOut(),
              child: Text('登出'),
            ),
          ],
        );
      } else {
        return ElevatedButton(
          onPressed: () => Get.to(() => LoginPage()),
          child: Text('登录'),
        );
      }
    });
  }
}
```

### 示例3: 自动导航

```dart
class AuthNavigation extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    
    // 监听认证状态变化
    ever(authController._user, (User? user) {
      if (user == null) {
        // 用户登出，导航到登录页
        Get.offAll(() => LoginPage());
      } else {
        // 用户登录，导航到主页
        Get.offAll(() => HomePage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}
```

## 🐛 故障排查

### 问题1: "Target of URI doesn't exist" 错误

**解决方案**: 
```bash
flutter clean
flutter pub get
cd ios && pod install
```

### 问题2: 无法登录，显示 "网络连接失败"

**检查事项**:
1. 确认设备/模拟器有网络连接
2. 检查 Firebase Console 中 Authentication 是否已启用
3. 检查 `google-services.json` (Android) 和 `GoogleService-Info.plist` (iOS) 是否正确配置

### 问题3: 注册后无法在 Firestore 中看到用户数据

**解决方案**: 检查 Firestore 安全规则是否正确配置，允许写入操作。

### 问题4: iOS 编译错误

**解决方案**:
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
```

## 🔄 数据同步

### Firebase Auth ↔ Firestore 同步

系统自动在以下情况同步数据：

1. **注册时**: 创建 Firestore 用户文档
2. **登录时**: 更新最后登录时间
3. **更新资料时**: 同步到 Firestore
4. **删除账户时**: 删除 Firestore 用户文档和相关数据

### 获取实时用户ID

`FirebaseService` 已更新，自动使用当前登录用户的 ID：

```dart
// 在 firebase_service.dart 中
String get _userId => _auth.currentUser?.uid ?? 'default_user';
```

这意味着所有 Firestore 操作都会自动关联到当前登录的用户。

## 📚 API 参考

### AuthController 方法

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `registerWithEmail` | `email`, `password`, `displayName?` | `Future<bool>` | 注册新用户 |
| `signInWithEmail` | `email`, `password` | `Future<bool>` | 登录 |
| `signOut` | - | `Future<void>` | 登出 |
| `sendPasswordResetEmail` | `email` | `Future<bool>` | 发送密码重置邮件 |
| `updatePassword` | `currentPassword`, `newPassword` | `Future<bool>` | 修改密码 |
| `updateDisplayName` | `displayName` | `Future<bool>` | 更新显示名称 |
| `getUserProfile` | - | `Future<Map?>` | 获取用户资料 |
| `updateUserProfile` | `data` | `Future<bool>` | 更新用户资料 |
| `deleteAccount` | `password` | `Future<bool>` | 删除账户 |

### AuthController 属性

| 属性 | 类型 | 说明 |
|------|------|------|
| `isLoggedIn` | `bool` | 是否已登录 |
| `user` | `User?` | 当前用户对象 |
| `userId` | `String?` | 当前用户ID |
| `userEmail` | `String?` | 当前用户邮箱 |
| `displayName` | `String?` | 当前用户显示名称 |
| `isLoading` | `RxBool` | 是否正在加载 |

## 🎓 学习资源

- [Firebase Authentication 文档](https://firebase.google.com/docs/auth)
- [FlutterFire Auth 文档](https://firebase.flutter.dev/docs/auth/overview)
- [GetX 状态管理](https://github.com/jonataslaw/getx)

## 📝 总结

Firebase Authentication 登录功能已完全集成到您的记账应用中！现在您可以：

✅ 用户注册和登录
✅ 用户资料管理
✅ 密码管理
✅ 安全的数据隔离（每个用户只能访问自己的数据）
✅ 实时认证状态监听
✅ 完整的错误处理

开始使用登录功能，让您的应用更加安全和个性化！

