# 项目文件结构说明

## 完整文件树

```
money_track/
├── lib/
│   ├── main.dart                              # 应用入口
│   │
│   ├── core/                                  # 核心功能模块
│   │   ├── constants/                         # 常量定义
│   │   │   ├── app_colors.dart               # 应用颜色常量
│   │   │   └── app_strings.dart              # 应用字符串常量（国际化）
│   │   └── theme/                             # 主题配置
│   │       └── app_theme.dart                # 应用主题定义
│   │
│   ├── data/                                  # 数据层
│   │   ├── models/                            # 数据模型
│   │   │   └── expense_model.dart            # 消费模型（Expense, ExpenseType, DailyExpense）
│   │   ├── repositories/                      # 数据仓库
│   │   │   └── expense_repository.dart       # 消费数据仓库（统一数据访问接口）
│   │   └── services/                          # 服务层
│   │       ├── api_service.dart              # API 服务（网络请求）
│   │       └── local_storage_service.dart    # 本地存储服务（SharedPreferences）
│   │
│   ├── controllers/                           # 控制器层（GetX）
│   │   ├── expense_controller.dart           # 消费控制器（业务逻辑）
│   │   └── navigation_controller.dart        # 导航控制器
│   │
│   ├── pages/                                 # 页面
│   │   ├── home_page.dart                    # 主页（底部导航）
│   │   ├── expense_list/                      # 消费列表模块
│   │   │   └── expense_list_page.dart        # 消费列表页
│   │   ├── expense_chart/                     # 消费图表模块
│   │   │   └── expense_chart_page.dart       # 消费图表页
│   │   └── add_expense/                       # 添加消费模块
│   │       └── add_expense_page.dart         # 添加消费页
│   │
│   ├── widgets/                               # 通用组件
│   │   ├── loading_widget.dart               # 加载动画组件
│   │   ├── error_widget.dart                 # 错误提示组件
│   │   └── expense_item_card.dart            # 消费卡片组件
│   │
│   └── utils/                                 # 工具类
│       └── demo_data_helper.dart             # 演示数据初始化
│
├── assets/                                    # 资源文件
│   ├── icons/                                 # SVG 图标
│   │   ├── icon_ expend_type_ catering.svg   # 餐饮图标
│   │   ├── icon_ expend_type_communication.svg # 通讯图标
│   │   ├── icon_ expend_type_shopping.svg    # 购物图标
│   │   ├── icon_ expend_type_transportation.svg # 交通图标
│   │   ├── icon_date_select.svg              # 日期选择图标
│   │   ├── icon_expend_warning.svg           # 消费警告图标
│   │   ├── icon_navigation_expend_chart.svg  # 图表导航图标
│   │   ├── icon_navigation_expend_list.svg   # 列表导航图标
│   │   ├── icon_navigation_menu.svg          # 菜单图标
│   │   └── icon_navigation_share.svg         # 分享图标
│   ├── images/                                # 图片资源
│   │   └── empty_normal.svg                  # 空状态图片
│   └── fonts/                                 # 字体文件
│       ├── MuyaoSoftbrush.ttf                # 柔美手写体
│       └── ZhanKuQingKeHuangYouTi.ttf        # 站酷青可黄油体
│
├── android/                                   # Android 平台代码
├── ios/                                       # iOS 平台代码
├── web/                                       # Web 平台代码
├── macos/                                     # macOS 平台代码
├── windows/                                   # Windows 平台代码
│
├── test/                                      # 测试文件
│   └── widget_test.dart                      # 组件测试
│
├── pubspec.yaml                               # 项目配置和依赖
├── pubspec.lock                               # 依赖锁定文件
├── analysis_options.yaml                      # 代码分析配置
├── README.md                                  # 项目说明文档
├── QUICKSTART.md                              # 快速开始指南
└── FILE_STRUCTURE.md                          # 本文件
```

## 文件说明

### 核心文件

#### `lib/main.dart`
- 应用程序入口
- 初始化 GetX
- 初始化国际化
- 可选初始化演示数据

#### `lib/core/constants/app_colors.dart`
- 定义应用所有颜色常量
- 主题色、文字色、类型色等
- 图表配色方案

#### `lib/core/constants/app_strings.dart`
- 定义应用所有文本常量
- 支持国际化扩展
- 错误提示、标签、按钮文本等

#### `lib/core/theme/app_theme.dart`
- Material Design 主题配置
- AppBar、Card、Button 等组件样式
- 文本主题、输入框主题等

### 数据层

#### `lib/data/models/expense_model.dart`
**包含三个主要类：**
- `ExpenseType`: 消费类型枚举（餐饮、交通、购物、通讯）
- `Expense`: 消费记录模型
- `DailyExpense`: 每日消费汇总模型

#### `lib/data/services/local_storage_service.dart`
**本地存储服务：**
- 使用 SharedPreferences 持久化数据
- 保存/读取消费记录
- 保存/读取余额
- 数据清除功能

#### `lib/data/services/api_service.dart`
**网络 API 服务：**
- 使用 Dio 进行网络请求
- CRUD 操作（增删改查）
- 错误处理
- 请求拦截器

#### `lib/data/repositories/expense_repository.dart`
**数据仓库层：**
- 统一数据访问接口
- 本地存储优先，网络同步
- 数据过滤和分组
- 离线支持

### 控制器层

#### `lib/controllers/expense_controller.dart`
**消费业务逻辑控制器：**
- 管理消费数据状态
- 加载、添加、删除消费
- 数据筛选（按类型、日期）
- 统计计算

#### `lib/controllers/navigation_controller.dart`
**导航状态控制器：**
- 管理底部导航栏状态
- 切换页面

### 页面层

#### `lib/pages/home_page.dart`
**主页：**
- 底部导航栏
- 页面切换
- 顶部工具栏（筛选、分享）
- 悬浮添加按钮

#### `lib/pages/expense_list/expense_list_page.dart`
**消费列表页：**
- 按日期分组展示消费
- 顶部汇总信息
- 下拉刷新
- 日期筛选
- 删除确认

#### `lib/pages/expense_chart/expense_chart_page.dart`
**消费图表页：**
- 总支出卡片
- 消费类别饼图
- 消费趋势折线图
- 类别排行列表

#### `lib/pages/add_expense/add_expense_page.dart`
**添加消费页：**
- 金额输入（大字体突出）
- 类型选择（图标+文字）
- 描述输入
- 日期时间选择
- 表单验证

### 组件层

#### `lib/widgets/loading_widget.dart`
**加载动画组件：**
- 脉动动画效果
- 自定义加载提示文字
- 使用钱包图标

#### `lib/widgets/error_widget.dart`
**错误提示组件：**
- 显示错误图片
- 错误信息
- 重试按钮

#### `lib/widgets/expense_item_card.dart`
**消费卡片组件：**
- 类型图标和颜色
- 消费描述和时间
- 消费金额突出显示
- 删除按钮

### 工具类

#### `lib/utils/demo_data_helper.dart`
**演示数据初始化：**
- 创建示例消费数据
- 初始化余额
- 仅在首次运行时执行

## 数据流向

```
用户操作
    ↓
Pages (UI 层)
    ↓
Controllers (业务逻辑)
    ↓
Repository (数据仓库)
    ↓
Services (本地/网络)
    ↓
Models (数据模型)
```

## 状态管理

使用 GetX 进行响应式状态管理：
- `.obs` - 创建响应式变量
- `Obx()` - 监听状态变化并自动更新 UI
- `Get.put()` - 依赖注入
- `Get.find()` - 查找控制器实例
- `Get.to()` - 页面导航
- `Get.back()` - 返回上一页
- `Get.snackbar()` - 显示提示信息
- `Get.dialog()` - 显示对话框

## 关键技术点

### 1. 响应式 UI
所有 UI 使用 `Obx()` 包裹，自动响应数据变化。

### 2. 本地持久化
使用 SharedPreferences 存储 JSON 格式数据。

### 3. 数据可视化
使用 fl_chart 绘制饼图和折线图。

### 4. SVG 图标
使用 flutter_svg 加载矢量图标，支持动态着色。

### 5. 日期处理
使用 intl 包格式化日期，支持中文显示。

### 6. 表单验证
使用 Form 和 TextFormField 进行输入验证。

### 7. 动画效果
使用 AnimationController 实现加载动画。

## 扩展建议

### 添加新的消费类型
1. 在 `expense_model.dart` 中添加新的 ExpenseType
2. 在 `app_colors.dart` 中添加对应颜色
3. 准备对应的 SVG 图标
4. 更新 UI 中的颜色映射逻辑

### 添加新页面
1. 在 `lib/pages/` 下创建新目录
2. 创建页面文件
3. 在 `home_page.dart` 或其他页面添加导航

### 添加新功能
1. 在对应的 Controller 中添加业务逻辑
2. 在 Repository 中添加数据操作
3. 在 UI 层调用 Controller 方法

### 数据库升级
可以考虑从 SharedPreferences 升级到 SQLite：
- 添加 sqflite 依赖
- 创建数据库服务类
- 实现表结构和 CRUD 操作
- 在 Repository 中切换存储实现

## 性能优化建议

1. **图片优化**: 使用 cached_network_image 缓存网络图片
2. **列表优化**: ListView.builder 已实现懒加载
3. **状态优化**: 避免不必要的 Obx 嵌套
4. **内存管理**: 及时 dispose 控制器和动画
5. **包大小**: 使用 --split-per-abi 构建不同架构的 APK

---

更新日期: 2024-01-01

