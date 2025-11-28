# 假数据调试指南

## 🎯 目的

为数据可视化面板提供丰富的假数据，方便调试和测试各种数据展示场景。

## 🔧 使用方式

### 1. 启用/禁用假数据

编辑 `lib/utils/debug_config.dart`：

```dart
class DebugConfig {
  /// 是否使用假数据进行调试
  static const bool useMockData = true;  // 👈 改为 false 使用真实数据
}
```

### 2. 配置假数据参数

在 `debug_config.dart` 中可以调整：

```dart
static const mockDataDays = 60;           // 生成多少天的数据
static const mockDailyRecordsMin = 1;     // 每天最少记录数
static const mockDailyRecordsMax = 4;     // 每天最多记录数
```

### 3. 查看调试日志

假数据加载时会在控制台输出详细统计信息：

```
ℹ️  [INFO] 开始加载假数据...
✅ [SUCCESS] 假数据加载完成！
🐛 [DEBUG] 总记录数: 150 条
🐛 [DEBUG] 本月支出: ¥3250.50
🐛 [DEBUG] 上月支出: ¥2890.00
🐛 [DEBUG] 环比变化: +12.5%
🐛 [DEBUG] 当前余额: ¥6749.50
🐛 [DEBUG] --- 支出分类统计 ---
🐛 [DEBUG] 餐饮: ¥1200.00 (36.9%)
🐛 [DEBUG] 交通: ¥800.00 (24.6%)
🐛 [DEBUG] 购物: ¥900.00 (27.7%)
🐛 [DEBUG] 通讯: ¥350.50 (10.8%)
```

## 📊 假数据特点

### 数据量
- **时间跨度**: 过去60天（可配置）
- **每天记录**: 1-4条随机（可配置）
- **总记录数**: 约150-240条

### 金额分布（更真实的模拟）

#### 餐饮 🍜
- **常规**: 30-80元（70%概率）
- **全范围**: 15-150元
- **描述**: 早餐、午餐、晚餐、下午茶等

#### 交通 🚗
- **常规**: 10-40元（80%概率）
- **全范围**: 5-100元
- **描述**: 地铁、公交、打车、加油等

#### 购物 🛍️
- **常规**: 50-500元
- **大额**: 200-1000元（20%概率）
- **描述**: 日用品、衣服、电子产品等

#### 通讯 📱
- **范围**: 10-100元
- **描述**: 话费、流量、宽带等

### 数据分布策略

1. **使用固定随机种子** (`Random(42)`)
   - 保证每次运行生成相同的数据
   - 便于重现问题和测试

2. **真实的金额分布**
   - 不是均匀分布，更符合实际消费习惯
   - 餐饮和交通频率高、金额小
   - 购物频率低、偶尔有大额

3. **时间分布**
   - 覆盖当月和上月（用于环比对比）
   - 每条记录有精确的时间戳
   - 时间间隔随机，更自然

## 🎨 测试场景

假数据设计可以测试以下场景：

### ✅ 支出环比
- [x] 本月有支出数据
- [x] 上月有支出数据
- [x] 环比增长/下降都能看到
- [x] 百分比计算正确

### ✅ 预算进度
- [x] 不同的使用率（30%-90%）
- [x] 进度条颜色变化
- [x] 日均可用金额计算

### ✅ 支出折线图
- [x] 近7天都有数据
- [x] 数据有起伏
- [x] Y轴自动缩放

### ✅ 支出类型饼状图
- [x] 4种类型都有数据
- [x] 占比不同
- [x] 排序正确

## 🔍 调试技巧

### 1. 控制台输出
在 `debug_config.dart` 中控制日志开关：
```dart
static const bool showDebugLogs = true;
```

### 2. 性能监控
```dart
static const bool showPerformance = true;
```

### 3. 自定义假数据
修改 `expense_controller.dart` 中的 `loadMockData()` 方法：
- 调整金额范围
- 修改记录数量
- 改变类型分布

### 4. 快速切换
```dart
// 方式1: 修改配置文件
DebugConfig.useMockData = true;

// 方式2: 在 controller 中临时修改
if (true) {  // 👈 快速开关
  loadMockData();
} else {
  loadExpenses();
}
```

## 📝 示例：测试特定场景

### 测试预算超支
```dart
void loadMockData() {
  // ... 生成大量高额支出
  balance.value = -500.00;  // 负余额
}
```

### 测试空数据
```dart
void loadMockData() {
  expenses.value = [];
  balance.value = 10000.00;
  _applyFilters();
}
```

### 测试单一类型
```dart
void loadMockData() {
  final type = ExpenseType.catering;  // 只生成餐饮
  // ...
}
```

## ⚠️ 注意事项

1. **发布前记得关闭**
   ```dart
   static const bool useMockData = false;  // 生产环境必须为 false
   ```

2. **不要提交到 Git**
   - 可以将 `debug_config.dart` 加入 `.gitignore`
   - 或者确保发布前检查配置

3. **数据一致性**
   - 使用固定随机种子保证可重现
   - 便于团队协作和问题排查

## 🚀 快速开始

1. **启用假数据**
   ```dart
   // lib/utils/debug_config.dart
   static const bool useMockData = true;
   ```

2. **运行应用**
   ```bash
   flutter run
   ```

3. **切换到图表页**
   - 点击底部导航的"图表"标签
   - 查看数据可视化面板

4. **查看控制台**
   - 观察假数据加载日志
   - 确认数据统计正确

5. **测试各种场景**
   - 修改配置参数
   - 热重载 (r) 或重启 (R)
   - 观察效果变化

## 📚 相关文件

- `lib/utils/debug_config.dart` - 调试配置
- `lib/controllers/expense_controller.dart` - 假数据生成逻辑
- `lib/pages/dashboard/dashboard_page.dart` - 数据可视化面板
- `lib/data/models/expense_model.dart` - 数据模型

## 🎉 效果

启用假数据后，你将看到：
- 📊 **支出环比**: 本月 ¥3250，上月 ¥2890，↑ 12.5%
- 💰 **预算进度**: 65% 使用率，进度条为黄色
- 📈 **近7日趋势**: 起伏的折线图
- 🥧 **支出分类**: 餐饮 37%、购物 28%、交通 25%、通讯 10%

完美适配数据可视化面板的所有功能！✨

