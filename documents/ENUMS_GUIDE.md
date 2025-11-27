# 枚举管理指南

## 概述

项目使用统一的枚举文件 `lib/core/enums/app_enums.dart` 来管理所有枚举类型，提供类型安全和易于维护的代码结构。

## 枚举列表

### 1. BottomNavTab - 底部导航栏标签

**用途**: 管理底部导航栏的所有标签页

**枚举值**:
- `list` - 消费列表
- `chart` - 消费图表
- `menu` - 菜单

**属性和方法**:
```dart
String get label        // 获取标签名称
String get iconPath     // 获取图标路径
int get index          // 获取索引
static BottomNavTab fromIndex(int index)  // 根据索引获取枚举
static List<BottomNavTab> get all        // 获取所有标签
```

**使用示例**:
```dart
// 使用枚举
BottomNavTab currentTab = BottomNavTab.list;

// 获取属性
print(currentTab.label);      // 输出: "列表"
print(currentTab.iconPath);   // 输出: "assets/icons/..."
print(currentTab.index);      // 输出: 0

// 遍历所有标签
for (var tab in BottomNavTab.all) {
  print('${tab.label}: ${tab.iconPath}');
}

// 从索引获取
BottomNavTab tab = BottomNavTab.fromIndex(1);  // chart
```

### 2. TopNavAction - 顶部导航栏操作

**用途**: 管理顶部导航栏的操作按钮

**枚举值**:
- `filter` - 筛选
- `share` - 分享
- `settings` - 设置
- `search` - 搜索

**属性**:
```dart
String? get iconPath    // 获取图标路径（如果有）
```

**使用示例**:
```dart
TopNavAction action = TopNavAction.filter;

// 检查是否有图标
if (action.iconPath != null) {
  // 显示 SVG 图标
  SvgPicture.asset(action.iconPath!);
} else {
  // 显示默认图标
  Icon(Icons.filter_list);
}
```

### 3. ExpenseCategory - 消费类型

**用途**: 管理所有消费类型

**枚举值**:
- `catering` - 餐饮
- `transportation` - 交通
- `shopping` - 购物
- `communication` - 通讯

**属性和方法**:
```dart
String get name         // 获取类型名称
String get iconPath     // 获取图标路径
static List<ExpenseCategory> get all  // 获取所有类型
```

**使用示例**:
```dart
// 创建消费记录
ExpenseCategory category = ExpenseCategory.catering;

// 显示类型信息
Container(
  child: Column(
    children: [
      Image.asset(category.iconPath),
      Text(category.name),
    ],
  ),
);

// 下拉选择器
DropdownButton<ExpenseCategory>(
  value: selectedCategory,
  items: ExpenseCategory.all.map((category) {
    return DropdownMenuItem(
      value: category,
      child: Text(category.name),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      selectedCategory = value!;
    });
  },
);
```

### 4. AppRoute - 页面路由

**用途**: 管理应用中的所有路由

**枚举值**:
- `home` - 主页
- `expenseList` - 消费列表
- `expenseChart` - 消费图表
- `addExpense` - 添加消费
- `expenseDetail` - 消费详情
- `settings` - 设置

**属性**:
```dart
String get name    // 获取路由名称
```

**使用示例**:
```dart
// 使用 GetX 导航
Get.toNamed(AppRoute.addExpense.name);

// 配置路由表
GetMaterialApp(
  getPages: [
    GetPage(
      name: AppRoute.home.name,
      page: () => HomePage(),
    ),
    GetPage(
      name: AppRoute.addExpense.name,
      page: () => AddExpensePage(),
    ),
  ],
);
```

### 5. DateFilterRange - 日期筛选范围

**用途**: 管理日期筛选的预设范围

**枚举值**:
- `today` - 今天
- `yesterday` - 昨天
- `thisWeek` - 本周
- `thisMonth` - 本月
- `thisYear` - 本年
- `last7Days` - 最近7天
- `last30Days` - 最近30天
- `custom` - 自定义

**属性**:
```dart
String get label    // 获取范围名称
```

**使用示例**:
```dart
DateFilterRange range = DateFilterRange.thisMonth;

// 显示筛选按钮
Wrap(
  children: DateFilterRange.values.map((range) {
    return FilterChip(
      label: Text(range.label),
      selected: selectedRange == range,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            selectedRange = range;
          });
        }
      },
    );
  }).toList(),
);

// 根据范围获取日期
DateRange getDateRange(DateFilterRange range) {
  switch (range) {
    case DateFilterRange.today:
      return DateRange.today;
    case DateFilterRange.thisWeek:
      return DateRange.thisWeek;
    case DateFilterRange.thisMonth:
      return DateRange.thisMonth;
    // ... 其他情况
    case DateFilterRange.custom:
      return customDateRange;
  }
}
```

### 6. SortOrder - 排序方式

**用途**: 管理列表排序方式

**枚举值**:
- `dateDesc` - 按日期降序（最新在前）
- `dateAsc` - 按日期升序（最旧在前）
- `amountDesc` - 按金额降序（最大在前）
- `amountAsc` - 按金额升序（最小在前）

**属性**:
```dart
String get label    // 获取排序名称
```

**使用示例**:
```dart
SortOrder currentOrder = SortOrder.dateDesc;

// 排序菜单
PopupMenuButton<SortOrder>(
  icon: Icon(Icons.sort),
  onSelected: (order) {
    setState(() {
      currentOrder = order;
    });
    sortExpenses(order);
  },
  itemBuilder: (context) {
    return SortOrder.values.map((order) {
      return PopupMenuItem(
        value: order,
        child: Text(order.label),
      );
    }).toList();
  },
);

// 应用排序
void sortExpenses(SortOrder order) {
  switch (order) {
    case SortOrder.dateDesc:
      expenses.sort((a, b) => b.date.compareTo(a.date));
      break;
    case SortOrder.dateAsc:
      expenses.sort((a, b) => a.date.compareTo(b.date));
      break;
    case SortOrder.amountDesc:
      expenses.sort((a, b) => b.amount.compareTo(a.amount));
      break;
    case SortOrder.amountAsc:
      expenses.sort((a, b) => a.amount.compareTo(b.amount));
      break;
  }
}
```

## 完整使用示例

### 示例 1: 带底部导航的主页

```dart
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BottomNavTab _currentTab = BottomNavTab.list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_currentTab.label)),
      body: _buildBody(),
      bottomNavigationBar: AppBottomNavigationBar(
        currentTab: _currentTab,
        onTabChanged: (tab) {
          setState(() {
            _currentTab = tab;
          });
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentTab) {
      case BottomNavTab.list:
        return ExpenseListPage();
      case BottomNavTab.chart:
        return ExpenseChartPage();
      case BottomNavTab.menu:
        return MenuPage();
    }
  }
}
```

### 示例 2: 消费类型选择

```dart
class AddExpensePage extends StatefulWidget {
  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  ExpenseCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('添加消费')),
      body: Column(
        children: [
          // 类型选择
          Text('选择消费类型:'),
          Wrap(
            spacing: 8,
            children: ExpenseCategory.all.map((category) {
              final isSelected = _selectedCategory == category;
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(category.iconPath, width: 20),
                    SizedBox(width: 4),
                    Text(category.name),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
```

### 示例 3: 综合筛选

```dart
class FilterPage extends StatefulWidget {
  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  ExpenseCategory? _selectedCategory;
  DateFilterRange _dateRange = DateFilterRange.thisMonth;
  SortOrder _sortOrder = SortOrder.dateDesc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('筛选')),
      body: ListView(
        children: [
          // 消费类型筛选
          ListTile(
            title: Text('消费类型'),
            subtitle: Text(_selectedCategory?.name ?? '全部'),
            onTap: _showCategoryPicker,
          ),
          
          // 日期范围筛选
          ListTile(
            title: Text('日期范围'),
            subtitle: Text(_dateRange.label),
            onTap: _showDateRangePicker,
          ),
          
          // 排序方式
          ListTile(
            title: Text('排序方式'),
            subtitle: Text(_sortOrder.label),
            onTap: _showSortOrderPicker,
          ),
          
          // 应用按钮
          ElevatedButton(
            onPressed: _applyFilter,
            child: Text('应用筛选'),
          ),
        ],
      ),
    );
  }

  void _applyFilter() {
    // 应用筛选逻辑
    print('Category: ${_selectedCategory?.name}');
    print('Date Range: ${_dateRange.label}');
    print('Sort Order: ${_sortOrder.label}');
    
    // 执行筛选和排序
    // ...
  }
}
```

## 最佳实践

### 1. 使用枚举而不是字符串或整数

❌ **不推荐**:
```dart
String currentTab = 'list';
int tabIndex = 0;
```

✅ **推荐**:
```dart
BottomNavTab currentTab = BottomNavTab.list;
```

### 2. 使用 switch 而不是 if-else

❌ **不推荐**:
```dart
if (tab == BottomNavTab.list) {
  return ExpenseListPage();
} else if (tab == BottomNavTab.chart) {
  return ExpenseChartPage();
}
```

✅ **推荐**:
```dart
switch (tab) {
  case BottomNavTab.list:
    return ExpenseListPage();
  case BottomNavTab.chart:
    return ExpenseChartPage();
  case BottomNavTab.menu:
    return MenuPage();
}
```

### 3. 在枚举中封装相关数据

✅ **推荐** - 将图标、名称等数据封装在枚举中:
```dart
enum BottomNavTab {
  list,
  chart,
  menu;
  
  String get label { /* ... */ }
  String get iconPath { /* ... */ }
}
```

### 4. 使用枚举进行类型安全的比较

✅ **类型安全**:
```dart
if (currentTab == BottomNavTab.list) {
  // 编译时类型检查
}
```

## 添加新枚举

如果需要添加新的枚举类型，在 `app_enums.dart` 中添加：

```dart
/// 新的枚举类型
enum MyNewEnum {
  value1,
  value2,
  value3;
  
  // 添加必要的属性和方法
  String get label {
    switch (this) {
      case MyNewEnum.value1:
        return '值1';
      // ...
    }
  }
}
```

## 总结

使用统一的枚举管理可以带来以下好处：

- ✅ **类型安全**: 编译时检查，避免拼写错误
- ✅ **易于维护**: 集中管理，修改方便
- ✅ **代码清晰**: 枚举名称更具语义性
- ✅ **重构友好**: IDE 支持重构操作
- ✅ **避免魔法数字**: 不使用硬编码的整数或字符串

查看完整示例: `lib/examples/enum_usage_examples.dart`

