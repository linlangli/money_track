# Firestore 连接故障排除指南

## 问题现象
应用卡在 "尝试写入测试数据..." 阶段，无法继续。

## 常见原因

### 1. Firestore 安全规则限制（最常见）⭐

**症状：** 写入操作超时或返回 permission-denied 错误

**解决方案：**

1. 打开 Firebase Console：https://console.firebase.google.com
2. 选择项目：`moneytrack-90239`
3. 左侧菜单选择 **Firestore Database**
4. 点击顶部 **规则** 标签
5. 将规则修改为测试模式（仅用于开发）：

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

6. 点击 **发布** 按钮
7. 等待规则发布完成（通常需要几秒钟）
8. 重新运行应用

**⚠️ 注意：** 测试模式规则允许任何人读写数据库，仅适用于开发环境！

**生产环境推荐规则：**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 用户数据
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // 消费记录
    match /expenses/{expenseId} {
      allow read, write: if request.auth != null;
    }
    
    // 调试集合（可选）
    match /_debug_test/{document=**} {
      allow read, write: if true;
    }
  }
}
```

### 2. Firestore 数据库未创建

**症状：** 错误信息包含 "not-found" 或 "NOT_FOUND"

**解决方案：**

1. 打开 Firebase Console
2. 选择项目 `moneytrack-90239`
3. 左侧菜单选择 **Firestore Database**
4. 如果看到 "创建数据库" 按钮，点击它
5. 选择数据库模式：
   - **生产模式**：需要配置安全规则
   - **测试模式**：30天内允许所有读写（推荐用于开发）
6. 选择数据库位置（推荐：asia-east1 或 asia-northeast1）
7. 点击 **启用**

### 3. 网络连接问题

**症状：** 
- 错误信息包含 "unavailable" 或 "UNAVAILABLE"
- 操作超时（10秒）

**解决方案：**

#### 检查网络连接

```bash
# macOS 终端执行
ping firestore.googleapis.com
curl https://firestore.googleapis.com
```

#### iOS 模拟器特殊情况

1. 模拟器使用 Mac 的网络连接
2. 确保 Mac 网络正常
3. 检查防火墙设置（系统偏好设置 > 安全性与隐私 > 防火墙）
4. 尝试禁用 VPN 或代理

#### 真机测试

1. 确保设备已连接到互联网
2. 尝试切换 Wi-Fi/蜂窝数据
3. 检查是否在受限网络环境中（企业网络、学校网络等）

### 4. Firebase 项目配置错误

**症状：** 各种初始化错误

**解决方案：**

1. 检查 `firebase_options.dart` 配置是否正确
2. 确认项目 ID 匹配：`moneytrack-90239`
3. 重新下载配置文件：
   - iOS：`GoogleService-Info.plist`
   - Android：`google-services.json`
4. 重新运行 Firebase CLI 配置：

```bash
flutterfire configure
```

## 调试日志说明

应用启动时会输出详细的调试信息，帮助诊断问题：

### 正常流程日志

```
🔥 [Firebase] 开始初始化 Firebase...
✅ [Firebase] Firebase 初始化成功
📋 [Firebase配置] Firebase 应用信息:
   - Project ID: moneytrack-90239
💾 [Firestore] 配置离线持久化...
✅ [Firestore] Firestore 配置完成
🔍 [Firestore] 检查 Firestore 连接...
📝 [Firestore] 尝试写入测试数据...
⏱️ [Firestore] 设置超时时间: 10秒
✅ [Firestore] 写入测试数据成功
📖 [Firestore] 尝试读取测试数据...
✅ [Firestore] 读取测试数据成功
🗑️ [Firestore] 清理测试数据完成
✅ [Firestore] Firestore 连接测试完成
```

### 错误日志分析

#### 超时错误

```
⏰ [Firestore] 写入操作超时！
⏰ [Firestore] 连接超时！
```

**原因：**
- Firestore 规则阻止了操作（静默拒绝）← **最常见**
- 网络速度慢或不稳定
- Firebase 项目配置问题

**解决：** 优先检查 Firestore 规则

#### 权限错误

```
🔒 [Firestore] 权限被拒绝！
❌ [Firestore] permission-denied
```

**原因：** Firestore 安全规则拒绝了访问

**解决：** 修改 Firestore 规则（见上文）

#### 网络错误

```
🌐 [Firestore] 网络不可用！
❌ [Firestore] unavailable
```

**原因：** 无法连接到 Firestore 服务器

**解决：** 检查网络连接

## 快速诊断清单

- [ ] Firebase 项目已创建：`moneytrack-90239`
- [ ] Firestore 数据库已启用
- [ ] Firestore 规则已设置（测试模式或自定义）
- [ ] 网络连接正常
- [ ] iOS/Android 配置文件已正确放置
- [ ] 依赖包已安装（`flutter pub get`）
- [ ] 应用已重新构建

## 验证 Firestore 连接

### 方法 1：使用应用调试日志

运行应用并查看控制台输出，应该看到：

```
✅ [Firestore] Firestore 连接测试完成
```

### 方法 2：在 Firebase Console 检查

1. 打开 Firestore Database
2. 查看 `_debug_test` 集合
3. 如果看到 `connection_test` 文档，说明连接成功
4. 该文档会自动删除

### 方法 3：手动测试写入

在应用代码中添加测试：

```dart
// 测试写入
await FirebaseFirestore.instance
  .collection('test')
  .add({
    'message': 'Hello Firestore',
    'timestamp': FieldValue.serverTimestamp(),
  });
```

## 常用命令

```bash
# 清理构建缓存
flutter clean

# 重新安装依赖
flutter pub get

# 查看日志
flutter logs

# 重新配置 Firebase
flutterfire configure

# iOS 清理 Pods
cd ios && pod deintegrate && pod install && cd ..

# 重新运行
flutter run
```

## 联系支持

如果以上方法都无法解决问题，请提供以下信息：

1. 完整的控制台日志输出
2. Firebase 项目 ID
3. 使用的平台（iOS/Android/Web）
4. Flutter 版本（`flutter --version`）
5. 网络环境（Wi-Fi/蜂窝数据/VPN）

## 相关资源

- [Firebase Console](https://console.firebase.google.com)
- [Firestore 安全规则文档](https://firebase.google.com/docs/firestore/security/get-started)
- [Flutter Firebase 插件](https://firebase.flutter.dev/)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli)

