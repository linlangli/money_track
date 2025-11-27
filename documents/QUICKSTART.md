# 快速开始指南

## 第一次运行

### 1. 检查 Flutter 环境
```bash
flutter doctor
```

### 2. 安装依赖
```bash
flutter pub get
```

### 3. 启用演示数据（可选）
如果想要快速查看应用效果，可以在 `lib/main.dart` 中取消注释以下行：
```dart
// 取消注释这一行
await DemoDataHelper.initializeDemoData();
```

### 4. 运行应用

**iOS 模拟器：**
```bash
flutter run -d ios
```

**Android 模拟器：**
```bash
flutter run -d android
```

**Chrome 浏览器：**
```bash
flutter run -d chrome
```

## 项目结构说明

```
lib/
├── core/                    # 核心功能（常量、主题）
├── data/                    # 数据层（模型、仓库、服务）
├── controllers/             # 状态管理（GetX 控制器）
├── pages/                   # 页面
├── widgets/                 # 通用组件
├── utils/                   # 工具类
└── main.dart               # 应用入口
```

## 主要功能

### 1. 查看消费列表
- 启动应用后默认显示消费列表
- 按日期分组显示
- 下拉刷新数据
- 点击顶部日期筛选按钮选择日期范围

### 2. 查看统计图表
- 点击底部导航栏的"图表"按钮
- 查看消费类别占比饼图
- 查看最近7天消费趋势
- 查看消费类别排行

### 3. 添加消费
- 点击右下角的 ➕ 按钮
- 输入消费金额
- 选择消费类型（餐饮、交通、购物、通讯）
- 输入消费描述
- 选择消费日期和时间
- 点击保存

### 4. 筛选功能
- 点击顶部右侧的筛选图标
- 选择消费类型进行筛选
- 或选择"全部类型"查看所有消费

### 5. 删除消费
- 在消费列表中，点击每条消费右侧的删除图标
- 确认删除

## 常见问题

### 应用无法运行？
1. 确保 Flutter 环境已正确安装：`flutter doctor`
2. 清理项目：`flutter clean`
3. 重新获取依赖：`flutter pub get`
4. 重新运行：`flutter run`

### SVG 图标不显示？
确保 `assets/icons/` 目录下有对应的 SVG 文件，文件名需要与代码中的路径匹配。

### 数据不持久化？
数据使用 `shared_preferences` 存储在本地，卸载应用会清除数据。

### 如何修改主题颜色？
编辑 `lib/core/constants/app_colors.dart` 文件中的颜色常量。

### 如何修改界面文字？
编辑 `lib/core/constants/app_strings.dart` 文件中的字符串常量。

## 开发技巧

### 热重载
在应用运行时，修改代码后按 `r` 进行热重载，无需重启应用。

### 热重启
如果热重载无效，按 `R` 进行热重启。

### 查看日志
```bash
flutter logs
```

### 构建发布版本
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 下一步

- 尝试添加更多消费类型
- 自定义图表样式
- 添加数据导出功能
- 实现云端数据同步

## 需要帮助？

如有问题，请查看：
- [Flutter 官方文档](https://flutter.dev/docs)
- [GetX 文档](https://pub.dev/packages/get)
- [项目 Issue](https://github.com/your-repo/issues)

---

祝你使用愉快！✨

