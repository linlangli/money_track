# Firebase Analytics 埋点实施指南

## ✅ 已完成的工作

### 1. 添加依赖
```yaml
firebase_analytics: ^12.0.4
```

### 2. 创建 Analytics 工具类
- 文件：`lib/utils/analytics_helper.dart`
- 包含 20+ 个常用埋点方法
- 自动错误处理和日志输出

### 3. 初始化 Analytics
在 `lib/main.dart` 中：
- ✅ 导入 Analytics 工具类
- ✅ 初始化 Analytics
- ✅ 发送 app_start 事件
- ✅ 添加导航观察器（自动追踪页面浏览）

### 4. 在控制器中添加埋点
在 `lib/controllers/expense_controller.dart` 中：
- ✅ 添加消费记录埋点
- ✅ 删除消费记录埋点
- ✅ 筛选埋点
- ✅ 刷新埋点
- ✅ 错误埋点

## 📊 已实现的埋点事件

### 应用生命周期
| 事件名 | 触发时机 | 参数 |
|--------|----------|------|
| `app_start` | 应用启动 | timestamp, platform, app_version |
| `app_open` | 从后台恢复 | - |

### 页面浏览
| 事件名 | 触发时机 | 参数 |
|--------|----------|------|
| `screen_view` | 页面切换 | screen_name, screen_class |

**自动追踪**：通过 `FirebaseAnalyticsObserver` 自动记录所有页面浏览

### 消费记录操作
| 事件名 | 触发时机 | 参数 |
|--------|----------|------|
| `add_expense` | 添加消费 | amount, category, has_note, value, currency |
| `delete_expense` | 删除消费 | amount, category |
| `edit_expense` | 编辑消费 | old_amount, new_amount, category, amount_change |

### 数据筛选和查看
| 事件名 | 触发时机 | 参数 |
|--------|----------|------|
| `filter_expenses` | 筛选数据 | has_category, category, has_date_range, date_range |
| `view_chart` | 查看图表 | chart_type (pie/line/bar) |
| `view_stats` | 查看统计 | period, total_amount, expense_count |

### 用户行为
| 事件名 | 触发时机 | 参数 |
|--------|----------|------|
| `refresh` | 下拉刷新 | screen |
| `share` | 分享内容 | content_type, method |
| `search` | 搜索 | search_term |

### 用户认证
| 事件名 | 触发时机 | 参数 |
|--------|----------|------|
| `login` | 用户登录 | login_method |
| `sign_up` | 用户注册 | sign_up_method |

### 数据同步
| 事件名 | 触发时机 | 参数 |
|--------|----------|------|
| `data_sync` | 数据同步 | sync_type, record_count, success |

### 错误追踪
| 事件名 | 触发时机 | 参数 |
|--------|----------|------|
| `error_occurred` | 发生错误 | error_type, error_message, has_stack_trace |

## 🚀 运行和验证

### 步骤 1: 重新运行应用
```bash
# 方法 1: 在终端按 R 键（热重启）
R

# 方法 2: 完全重新运行
flutter run
```

### 步骤 2: 启用 Analytics 调试模式（可选）

#### iOS 模拟器
在 Xcode 中：
1. 打开 `ios/Runner.xcworkspace`
2. Product → Scheme → Edit Scheme
3. Run → Arguments → Arguments Passed On Launch
4. 添加：`-FIRAnalyticsDebugEnabled`

#### Android 模拟器
```bash
adb shell setprop debug.firebase.analytics.app com.example.moneyTrack
```

### 步骤 3: 查看实时事件

#### 方法 1: DebugView（推荐）
1. 访问：
   ```
   https://console.firebase.google.com/project/moneytrack-90239/analytics/app/ios:com.example.moneyTrack/debugview
   ```
2. 在设备上操作应用
3. 实时查看事件数据（需启用调试模式）

#### 方法 2: 实时数据
1. 访问：
   ```
   https://console.firebase.google.com/project/moneytrack-90239/analytics/app/ios:com.example.moneyTrack/realtime
   ```
2. 查看最近 30 分钟的活跃用户

#### 方法 3: 事件报告
1. 访问：
   ```
   https://console.firebase.google.com/project/moneytrack-90239/analytics/app/ios:com.example.moneyTrack/events
   ```
2. 查看历史事件数据（**24 小时延迟**）

### 步骤 4: 验证埋点

在应用中执行以下操作，然后在 Firebase Console 查看：

1. ✅ **启动应用** → 应看到 `app_start` 事件
2. ✅ **浏览页面** → 应看到 `screen_view` 事件
3. ✅ **添加消费** → 应看到 `add_expense` 事件
4. ✅ **删除消费** → 应看到 `delete_expense` 事件
5. ✅ **筛选数据** → 应看到 `filter_expenses` 事件
6. ✅ **下拉刷新** → 应看到 `refresh` 事件

## 📝 查看日志

应用运行时会输出 Analytics 相关日志：

```
✅ [Analytics] Firebase Analytics 已启用
✅ [Analytics] 默认参数已设置
📊 [Analytics] 事件: app_start
📊 [Analytics] 页面浏览: HomePage
📊 [Analytics] 事件: add_expense - catering: ¥50.0
📊 [Analytics] 事件: filter_expenses
```

## ⚠️ 重要说明

### 数据延迟
- **DebugView**: 实时显示（需启用调试模式）
- **实时数据**: 几分钟延迟
- **事件报告**: **24 小时延迟**

### 调试模式限制
- 只在开发设备上启用
- 不会污染生产数据
- 需要手动启动参数

### 数据采样
- 免费版 Firebase 可能对数据采样
- 升级到 Firebase Blaze 计划可获取完整数据

## 🎯 后续优化建议

### 1. 添加更多业务埋点
```dart
// 在需要的地方调用
await AnalyticsHelper.logCustomEvent(
  eventName: 'feature_used',
  parameters: {
    'feature_name': 'budget_management',
    'user_type': 'premium',
  },
);
```

### 2. 设置用户属性
```dart
// 用户登录后设置
await AnalyticsHelper.setUserId(user.uid);
await AnalyticsHelper.setUserProperty(
  name: 'user_type',
  value: 'free',
);
```

### 3. 追踪用户价值
```dart
// 在消费金额大的地方
await AnalyticsHelper.logCustomEvent(
  eventName: 'high_value_expense',
  parameters: {
    'amount': 1000,
    'category': 'shopping',
  },
);
```

### 4. 漏斗分析
定义用户流程：
1. `view_home` → 查看首页
2. `click_add_button` → 点击添加按钮
3. `select_category` → 选择类别
4. `add_expense` → 完成添加

在 Firebase Console 中创建漏斗，分析用户转化率。

## 📚 相关资源

- [Firebase Analytics 文档](https://firebase.google.com/docs/analytics)
- [Flutter Firebase Analytics](https://firebase.flutter.dev/docs/analytics/overview)
- [Analytics 最佳实践](https://firebase.google.com/docs/analytics/best-practices)
- [事件命名规范](https://firebase.google.com/docs/analytics/events)

## 🐛 常见问题

### Q: 为什么看不到数据？
A: 
1. 确认应用已运行并触发事件
2. 检查日志是否有埋点输出
3. 等待 10-30 分钟（实时数据）
4. 启用调试模式使用 DebugView

### Q: 如何测试埋点是否生效？
A:
1. 启用调试模式
2. 使用 DebugView 实时查看
3. 在应用中执行操作
4. 立即在 DebugView 看到事件

### Q: 生产环境需要修改吗？
A:
- **不需要**！调试模式只在开发设备生效
- 生产应用会自动发送正常数据

---

**最后更新：** 2026-01-10  
**状态：** ✅ 已完成并可测试  

