# Money Track - 记账本

一个简洁现代的 Flutter 记账应用，帮助你轻松跟踪日常消费。

## 📱 功能特性

### 1. 消费列表
- 按日期分组显示消费记录
- 显示消费类型、描述和金额
- 支持下拉刷新
- 实时显示支出金额和结余
- 支持按日期筛选
- 支持删除消费记录

### 2. 消费图表统计
- 消费类别占比饼图
- 消费趋势折线图（最近7天）
- 消费类别排行
- 总支出和平均消费统计
- 直观的数据可视化

### 3. 消费添加
- 快速添加消费记录
- 支持选择消费类型
- 输入消费金额和描述
- 自定义消费日期和时间
- 表单验证确保数据完整性

### 4. 筛选和分享
- 按消费类型筛选
- 按日期范围筛选
- 分享消费报告（开发中）

### 5. 精美设计
- 遵循 Material Design 规范
- 流畅的动画效果
- 优雅的加载动画
- 友好的错误提示页面
- 响应式布局

## 🎨 设计规范

### 主题色
- 金黄色 (#FFD700) - 主色调
- 黑色 (#000000) - 文字和图标
- 白色 (#FFFFFF) - 背景
- 粉红色 (#EA655C) - 强调色

### 消费类型配色
- 餐饮: #FF6B6B
- 交通: #4ECDC4
- 购物: #FFBE0B
- 通讯: #95E1D3

## 🏗️ 项目架构

```
lib/
├── core/                           # 核心功能
│   ├── constants/                  # 常量定义
│   │   ├── app_colors.dart        # 颜色常量
│   │   └── app_strings.dart       # 字符串常量
│   └── theme/                      # 主题配置
│       └── app_theme.dart         # 应用主题
├── data/                           # 数据层
│   ├── models/                     # 数据模型
│   │   └── expense_model.dart     # 消费模型
│   ├── repositories/               # 数据仓库
│   │   └── expense_repository.dart # 消费数据仓库
│   └── services/                   # 服务层
│       ├── api_service.dart       # API 服务
│       └── local_storage_service.dart # 本地存储服务
├── controllers/                    # 控制器（GetX）
│   ├── expense_controller.dart    # 消费控制器
│   └── navigation_controller.dart # 导航控制器
├── pages/                          # 页面
│   ├── home_page.dart             # 主页
│   ├── expense_list/              # 消费列表页
│   │   └── expense_list_page.dart
│   ├── expense_chart/             # 消费图表页
│   │   └── expense_chart_page.dart
│   └── add_expense/               # 添加消费页
│       └── add_expense_page.dart
├── widgets/                        # 通用组件
│   ├── loading_widget.dart        # 加载组件
│   ├── error_widget.dart          # 错误组件
│   └── expense_item_card.dart     # 消费卡片组件
└── main.dart                       # 应用入口

```

## 📦 技术栈

### 核心框架
- **Flutter**: ^3.8.1
- **Dart SDK**: ^3.8.1

### 状态管理
- **GetX** (^4.6.6): 轻量级的状态管理、路由和依赖注入

### 数据可视化
- **fl_chart** (^0.68.0): 漂亮的图表库

### 国际化
- **intl** (^0.19.0): 日期格式化和国际化支持

### 数据存储
- **shared_preferences** (^2.2.2): 本地数据持久化

### 网络请求
- **dio** (^5.4.0): 强大的 HTTP 客户端

### UI 组件
- **flutter_svg** (^2.0.9): SVG 图标支持

## 🚀 快速开始

### 环境要求
- Flutter SDK >= 3.8.1
- Dart SDK >= 3.8.1
- iOS 12.0+ / Android 5.0+

### 安装步骤

1. **克隆项目**
```bash
git clone <repository-url>
cd money_track
```

2. **安装依赖**
```bash
flutter pub get
```

3. **运行应用**
```bash
# iOS 模拟器
flutter run -d ios

# Android 模拟器
flutter run -d android

# Chrome 浏览器（开发模式）
flutter run -d chrome
```

### 构建发布版本

**Android APK**
```bash
flutter build apk --release
```

**iOS IPA**
```bash
flutter build ios --release
```

## 📂 数据结构

### Expense（消费记录）
```dart
{
  "id": "唯一标识符",
  "type": "消费类型（catering/transportation/shopping/communication）",
  "amount": 123.45,
  "description": "消费描述",
  "date": "2024-01-01T12:00:00.000Z"
}
```

### ExpenseType（消费类型）
```dart
{
  "id": "类型ID",
  "name": "类型名称",
  "iconPath": "图标路径"
}
```

## 💾 数据存储

### 本地存储
使用 `shared_preferences` 存储所有消费记录和余额信息。数据以 JSON 格式保存。

### 网络同步（可选）
项目包含 API 服务层，支持与后端服务器同步数据。需要配置 `ApiService` 中的 `baseUrl`。

## 🎯 核心功能实现

### 状态管理
使用 GetX 进行状态管理，实现响应式数据绑定：
- `ExpenseController`: 管理消费数据和业务逻辑
- `NavigationController`: 管理底部导航状态

### 数据流
```
UI Layer (Pages/Widgets)
    ↓↑
Controllers (GetX)
    ↓↑
Repository Layer
    ↓↑
Services (Local Storage / API)
```

### 筛选功能
- 按消费类型筛选
- 按日期范围筛选
- 支持组合筛选
- 实时更新统计数据

### 图表展示
- **饼图**: 展示各类别消费占比
- **折线图**: 展示最近7天消费趋势
- 支持自定义颜色和样式

## 🎨 自定义字体

项目使用了两种自定义字体：
- **MuyaoSoftbrush**: 柔美手写体
- **ZhanKuQingKeHuangYouTi**: 站酷青可黄油体

字体文件位于 `assets/fonts/` 目录。

## 🔧 配置说明

### API 配置
编辑 `lib/data/services/api_service.dart`：
```dart
static const String baseUrl = 'https://your-api-url.com';
```

### 主题配置
编辑 `lib/core/constants/app_colors.dart` 自定义应用配色。

### 语言配置
编辑 `lib/core/constants/app_strings.dart` 修改应用文案。

## 📱 支持的平台

- ✅ iOS
- ✅ Android
- ✅ Web
- ✅ macOS
- ✅ Windows

## 🐛 调试

### 查看日志
```bash
flutter logs
```

### 热重载
```bash
# 在运行中的应用按 'r'
r
```

### 热重启
```bash
# 在运行中的应用按 'R'
R
```

## 📝 开发规范

### 代码风格
遵循 [Effective Dart](https://dart.dev/guides/language/effective-dart) 规范。

### 文件命名
- 文件名使用 snake_case
- 类名使用 PascalCase
- 变量和函数使用 camelCase

### 提交规范
```
feat: 新功能
fix: 修复bug
docs: 文档更新
style: 代码格式调整
refactor: 重构
test: 测试相关
chore: 构建/工具相关
```

## 🔜 待开发功能

- [ ] 收入记录功能
- [ ] 预算管理
- [ ] 数据导出（CSV/Excel）
- [ ] 分享功能完善
- [ ] 数据备份和恢复
- [ ] 多账本支持
- [ ] 标签系统
- [ ] 消费提醒
- [ ] 更多图表类型
- [ ] 深色模式

## 📄 开源协议

MIT License

## 👥 贡献

欢迎提交 Issue 和 Pull Request！

## 📧 联系方式

如有问题或建议，请通过以下方式联系：
- 提交 Issue
- 发送邮件

---

**Made with ❤️ using Flutter**

