# 导航栏组件使用指南

## 概述

项目包含了完整的顶部导航栏和底部导航栏组件，提供了多种样式和使用方式。

## 文件位置

- `lib/widgets/app_bars.dart` - 顶部导航栏组件
- `lib/widgets/bottom_navigation_bars.dart` - 底部导航栏组件

## 顶部导航栏组件

### 1. TopNavigationBar - 基础顶部导航栏

**特性：**
- 可自定义标题
- 可添加操作按钮
- 可显示返回按钮
- 支持自定义前导图标

**使用示例：**

```dart
// 基础使用
Scaffold(
  appBar: TopNavigationBar(
    title: '我的页面',
  ),
  body: ...,
)

// 带返回按钮
Scaffold(
  appBar: TopNavigationBar(
    title: '详情页',
    showBackButton: true,
  ),
)

// 自定义操作按钮
Scaffold(
  appBar: TopNavigationBar(
    title: '设置',
    actions: [
      IconButton(
        icon: Icon(Icons.save),
        onPressed: () => print('保存'),
      ),
    ],
  ),
)
```

### 2. ExpenseAppBar - 带筛选和分享功能的顶部栏

**特性：**
- 内置筛选功能
- 内置分享功能
- 自动显示应用名称
- 集成消费类型筛选对话框

**使用示例：**

```dart
Scaffold(
  appBar: ExpenseAppBar(),
  body: ...,
)

// 自定义筛选和分享回调
Scaffold(
  appBar: ExpenseAppBar(
    onFilterTap: () => print('自定义筛选'),
    onShareTap: () => print('自定义分享'),
  ),
)
```

**功能说明：**
- **筛选按钮**: 点击显示消费类型筛选对话框
- **分享按钮**: 点击显示分享选项（图片、Excel、PDF）

### 3. ExpenseSummaryBar - 消费摘要栏

**特性：**
- 显示日期选择器
- 显示支出金额
- 显示结余金额
- 集成日期范围选择功能

**使用示例：**

```dart
Column(
  children: [
    ExpenseSummaryBar(),
    Expanded(
      child: ListView(...),
    ),
  ],
)

// 自定义日期选择回调
ExpenseSummaryBar(
  onDateTap: () => print('自定义日期选择'),
)
```

## 底部导航栏组件

### 1. AppBottomNavigationBar - 基础底部导航栏

**特性：**
- 支持自定义导航项
- 支持 SVG 图标
- 支持普通 Icon
- 简洁的样式

**使用示例：**

```dart
final navController = Get.put(NavigationController());

Scaffold(
  body: ...,
  bottomNavigationBar: Obx(() => AppBottomNavigationBar(
    currentIndex: navController.selectedIndex.value,
    onTap: navController.changeIndex,
    items: [
      BottomNavItem(
        label: '首页',
        icon: Icons.home,
      ),
      BottomNavItem(
        label: '分类',
        svgPath: 'assets/icons/category.svg',
      ),
      BottomNavItem(
        label: '我的',
        icon: Icons.person,
        activeIcon: Icons.person_rounded,
      ),
    ],
  )),
)
```

### 2. AnimatedBottomNavigationBar - 带动画的底部导航栏

**特性：**
- 所有基础功能
- 图标缩放动画
- 文字渐变动画
- 更流畅的交互体验

**使用示例：**

```dart
Scaffold(
  body: ...,
  bottomNavigationBar: AnimatedBottomNavigationBar(
    currentIndex: currentIndex,
    onTap: (index) => setState(() => currentIndex = index),
    items: AppBottomNavItems.items,
  ),
)
```

### 3. MaterialBottomNavigationBar - Material Design 风格

**特性：**
- 使用原生 BottomNavigationBar
- Material Design 规范
- 自动集成 NavigationController

**使用示例：**

```dart
Scaffold(
  body: ...,
  bottomNavigationBar: MaterialBottomNavigationBar(),
)
```

## BottomNavItem 数据模型

**属性：**
```dart
class BottomNavItem {
  final String label;          // 标签文字
  final IconData? icon;        // 普通图标
  final IconData? activeIcon;  // 选中时的图标
  final String? svgPath;       // SVG 图标路径
}
```

**注意：** `icon` 和 `svgPath` 至少要提供一个。

## 预定义导航项

项目提供了预定义的导航项：

```dart
AppBottomNavItems.items
```

包含：
1. 消费列表（SVG 图标）
2. 消费图表（SVG 图标）
3. 添加消费（Icon 图标）

## 完整使用示例

### 示例 1: 主页集成

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navController = Get.put(NavigationController());
    
    return Scaffold(
      appBar: ExpenseAppBar(),
      body: Obx(() => _pages[navController.selectedIndex.value]),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        currentIndex: navController.selectedIndex.value,
        onTap: navController.changeIndex,
        items: AppBottomNavItems.items,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddExpensePage()),
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### 示例 2: 详情页

```dart
class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: '消费详情',
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => print('编辑'),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => print('删除'),
          ),
        ],
      ),
      body: ...,
    );
  }
}
```

### 示例 3: 自定义导航项

```dart
final customItems = [
  BottomNavItem(
    label: '首页',
    icon: Icons.home,
    activeIcon: Icons.home_rounded,
  ),
  BottomNavItem(
    label: '搜索',
    svgPath: 'assets/icons/search.svg',
  ),
  BottomNavItem(
    label: '通知',
    icon: Icons.notifications_outlined,
    activeIcon: Icons.notifications,
  ),
  BottomNavItem(
    label: '我的',
    icon: Icons.person_outline,
    activeIcon: Icons.person,
  ),
];

AnimatedBottomNavigationBar(
  currentIndex: currentIndex,
  onTap: onIndexChanged,
  items: customItems,
)
```

## 样式自定义

### 修改颜色

在 `app_colors.dart` 中修改：
```dart
static const Color primary = Color(0xFFYOURCOLOR);
```

### 修改高度

```dart
// app_bars.dart
Size get preferredSize => const Size.fromHeight(YOUR_HEIGHT);

// bottom_navigation_bars.dart
SizedBox(
  height: YOUR_HEIGHT,
  child: ...,
)
```

## 与 GetX 集成

导航栏组件完全集成了 GetX：

1. **状态管理**: 使用 `NavigationController`
2. **路由**: 使用 `Get.to()` 和 `Get.back()`
3. **对话框**: 使用 `Get.dialog()`
4. **提示**: 使用 `Get.snackbar()` 或 `context.showSnackBar()`

## 扩展方法支持

导航栏组件使用了项目的扩展方法：

```dart
// 高度和宽度
16.heightBox
8.widthBox

// 圆角
20.radius

// 内边距
16.paddingAll

// 文本主题
context.textTheme.bodyMedium

// 显示提示
context.showSnackBar('提示信息')
```

## 最佳实践

### 1. 使用 NavigationController

```dart
// 初始化（只需一次）
final navController = Get.put(NavigationController());

// 监听变化
Obx(() => Widget)

// 修改索引
navController.changeIndex(index)
```

### 2. 悬浮按钮配合

```dart
floatingActionButton: Obx(() {
  // 在某些页面隐藏
  if (navController.selectedIndex.value == 2) {
    return const SizedBox.shrink();
  }
  return FloatingActionButton(...);
})
```

### 3. 页面切换

```dart
final pages = [Page1(), Page2(), Page3()];

body: Obx(() => pages[navController.selectedIndex.value])
```

## 性能优化

1. **使用 const**: 尽可能使用 const 构造函数
2. **避免重建**: 使用 Obx 只包裹需要响应的部分
3. **图标缓存**: SVG 图标会自动缓存
4. **延迟加载**: 页面内容可以使用懒加载

## 故障排除

### 问题 1: SVG 图标不显示

**解决方案：**
- 检查文件路径是否正确
- 确保 pubspec.yaml 中已添加 assets
- 运行 `flutter pub get`

### 问题 2: 导航状态不更新

**解决方案：**
- 确保使用 Obx 包裹响应式部分
- 确保 NavigationController 已正确初始化
- 使用 `.value` 访问响应式变量

### 问题 3: 扩展方法报错

**解决方案：**
- 导入扩展: `import 'core/extensions/extensions.dart'`
- 检查是否有命名冲突

## 总结

这套导航栏组件提供了：
- ✅ 3 种顶部导航栏样式
- ✅ 3 种底部导航栏样式
- ✅ 完整的筛选和分享功能
- ✅ 动画效果支持
- ✅ GetX 完全集成
- ✅ 扩展方法支持
- ✅ 易于自定义

根据你的需求选择合适的组件即可！

