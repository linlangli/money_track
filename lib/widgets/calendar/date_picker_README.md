# 自定义日历选择器组件

一个简约美观的日历选择器弹窗组件，采用 Material Design 风格设计。

## 🎨 设计特点

- **主题色**：金黄色 (#FFBD27) 和黑色 (#000000)
- **风格**：符合 Material Design 规范，简约现代
- **交互**：流畅的动画效果，直观的用户体验
- **功能**：支持日期范围限制，高亮今日和选中日期

## 📦 组件文件

- `lib/widgets/date_picker_dialog.dart` - 日历选择器核心组件
- `lib/widgets/date_picker_example.dart` - 使用示例页面

## 🚀 使用方法

### 基础用法

```dart
import 'package:travel_track/widgets/date_picker_dialog.dart';

// 显示日历选择器
final selectedDate = await CustomDatePickerDialog.show(
  context,
  initialDate: DateTime.now(), // 初始选中日期（可选）
);

if (selectedDate != null) {
  print('选中的日期: $selectedDate');
}
```

### 带日期范围限制

```dart
final now = DateTime.now();

final selectedDate = await CustomDatePickerDialog.show(
  context,
  initialDate: now,
  firstDate: DateTime(now.year, now.month, 1), // 最早可选日期
  lastDate: DateTime(now.year, now.month + 3, 0), // 最晚可选日期
);
```

### 使用回调函数

```dart
CustomDatePickerDialog(
  initialDate: DateTime.now(),
  firstDate: DateTime(2020),
  lastDate: DateTime(2030),
  onDateSelected: (date) {
    print('选中日期: $date');
  },
);
```

## ✨ 功能特性

### 1. 日期选择
- 点击日期单元格选择日期
- 选中日期以金黄色圆形高亮显示
- 今天日期以金黄色边框标识

### 2. 月份切换
- 左右箭头按钮切换月份
- 显示当前年份和月份

### 3. 日期限制
- 支持设置最早和最晚可选日期
- 不可选日期显示为灰色且无法点击

### 4. 底部操作
- **取消按钮**：关闭弹窗，不保存选择
- **确定按钮**：确认选择并返回选中的日期

## 🎯 组件参数

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `initialDate` | `DateTime?` | 否 | 初始选中的日期，默认为今天 |
| `firstDate` | `DateTime?` | 否 | 最早可选日期，默认为 1900-01-01 |
| `lastDate` | `DateTime?` | 否 | 最晚可选日期，默认为 2100-12-31 |
| `onDateSelected` | `Function(DateTime)?` | 否 | 日期选择回调函数 |

## 📱 界面预览

组件包含以下元素：

```
┌─────────────────────────────────────┐
│  选择日期                    [X]     │
├─────────────────────────────────────┤
│  [<]      2025年 一月       [>]     │
├─────────────────────────────────────┤
│  一  二  三  四  五  六  日          │
├─────────────────────────────────────┤
│          1   2   3   4   5          │
│  6   7   8  (9) 10  11  12         │  (9) = 选中日期
│  13  14 [15] 16  17  18  19        │  [15] = 今天
│  20  21  22  23  24  25  26        │
│  27  28  29  30  31                │
├─────────────────────────────────────┤
│    [ 取消 ]        [ 确定 ]         │
└─────────────────────────────────────┘
```

## 🎨 样式定制

组件的主题色定义在 `_CustomDatePickerDialogState` 类中：

```dart
static const Color primaryColor = Color(0xFFFFBD27);  // 主色 - 金黄色
static const Color textColor = Color(0xFF000000);     // 文本色 - 黑色
static const Color subtextColor = Color(0xFF666666);  // 次要文本 - 灰色
static const Color backgroundColor = Color(0xFFFFFFFF); // 背景 - 白色
static const Color dividerColor = Color(0xFFEEEEEE);  // 分割线 - 浅灰
```

如需修改主题色，可以直接编辑这些常量值。

## 📝 示例代码

完整的使用示例请参考 `date_picker_example.dart` 文件。

运行示例：
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => DatePickerExample()),
);
```

## 🔧 依赖

组件依赖以下 Flutter 包（已在项目中）：
- `flutter/material.dart` - Material Design 组件
- `intl` - 日期格式化（示例页面使用）

## 💡 最佳实践

1. **初始日期**：建议设置 `initialDate` 以提供更好的用户体验
2. **日期范围**：根据业务需求合理设置 `firstDate` 和 `lastDate`
3. **错误处理**：检查返回值是否为 null（用户可能取消选择）
4. **日期格式化**：使用 `intl` 包格式化显示日期

```dart
import 'package:intl/intl.dart';

final date = await CustomDatePickerDialog.show(context);
if (date != null) {
  final formattedDate = DateFormat('yyyy年MM月dd日').format(date);
  print(formattedDate); // 输出: 2025年11月15日
}
```

## 🌟 特色亮点

1. ✅ **Material Design** - 完全遵循 Material Design 设计规范
2. ✅ **简约美观** - 清晰的视觉层次，舒适的配色方案
3. ✅ **易于使用** - 简单的 API，一行代码即可调用
4. ✅ **高度灵活** - 支持日期范围限制和回调函数
5. ✅ **性能优化** - 使用 GridView.builder 优化渲染性能
6. ✅ **完全可定制** - 所有样式常量都可轻松修改

## 📞 使用场景

- 旅行日期选择
- 预订系统
- 日程管理
- 活动报名
- 任意需要日期输入的场景

---

**作者**: Travel Track Team  
**版本**: 1.0.0  
**最后更新**: 2025-11-15

