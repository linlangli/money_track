# API 文档

## 概述

本文档描述了 Money Track 应用的主要 API 和数据接口。

## 数据模型

### ExpenseType (消费类型)

```dart
class ExpenseType {
  final String id;          // 类型唯一标识
  final String name;        // 类型显示名称
  final String iconPath;    // 图标路径
}
```

**预定义类型：**
- `catering` - 餐饮
- `transportation` - 交通
- `shopping` - 购物
- `communication` - 通讯

**方法：**
```dart
// 根据 ID 获取类型
ExpenseType? fromId(String id)

// 序列化
Map<String, dynamic> toJson()

// 反序列化
ExpenseType.fromJson(Map<String, dynamic> json)
```

### Expense (消费记录)

```dart
class Expense {
  final String id;              // 唯一标识
  final ExpenseType type;       // 消费类型
  final double amount;          // 消费金额
  final String description;     // 消费描述
  final DateTime date;          // 消费日期时间
}
```

**属性：**
```dart
String get formattedAmount     // 格式化金额 "¥123.45"
String get formattedDate       // 格式化日期 "2024-01-01"
String get formattedTime       // 格式化时间 "12:30"
```

**方法：**
```dart
// 序列化
Map<String, dynamic> toJson()

// 反序列化
Expense.fromJson(Map<String, dynamic> json)

// 复制并修改
Expense copyWith({...})
```

### DailyExpense (每日消费)

```dart
class DailyExpense {
  final DateTime date;           // 日期
  final List<Expense> expenses;  // 当日所有消费
}
```

**属性：**
```dart
double get totalAmount              // 当日总金额
String get formattedDate           // 格式化日期 "01月01日 星期一"
String get formattedTotalAmount    // 格式化总金额 "¥123.45"
```

## 服务层

### LocalStorageService (本地存储)

**功能：** 使用 SharedPreferences 进行本地数据持久化

**方法：**

```dart
// 保存所有消费记录
Future<void> saveExpenses(List<Expense> expenses)

// 加载所有消费记录
Future<List<Expense>> loadExpenses()

// 添加单条消费记录
Future<void> addExpense(Expense expense)

// 删除消费记录
Future<void> deleteExpense(String id)

// 更新消费记录
Future<void> updateExpense(Expense expense)

// 保存余额
Future<void> saveBalance(double balance)

// 加载余额
Future<double> loadBalance()

// 清除所有数据
Future<void> clearAll()
```

**数据格式：**
```json
{
  "expenses": [
    {
      "id": "1234567890",
      "type": "catering",
      "amount": 58.5,
      "description": "午餐",
      "date": "2024-01-01T12:30:00.000Z"
    }
  ],
  "balance": 10000.0
}
```

### ApiService (网络 API)

**功能：** 使用 Dio 进行网络请求（可选）

**配置：**
```dart
static const String baseUrl = 'https://api.example.com';
```

**方法：**

```dart
// 获取所有消费记录
Future<List<Expense>> fetchExpenses()

// 创建消费记录
Future<Expense> createExpense(Expense expense)

// 删除消费记录
Future<void> deleteExpense(String id)

// 更新消费记录
Future<Expense> updateExpense(Expense expense)
```

**请求示例：**

```http
GET /expenses
Response: [Expense, ...]

POST /expenses
Body: Expense JSON
Response: Expense

PUT /expenses/:id
Body: Expense JSON
Response: Expense

DELETE /expenses/:id
Response: Success
```

### ExpenseRepository (数据仓库)

**功能：** 统一的数据访问接口，整合本地和网络数据

**方法：**

```dart
// 获取消费记录
Future<List<Expense>> getExpenses({bool forceRefresh = false})

// 添加消费记录
Future<void> addExpense(Expense expense)

// 删除消费记录
Future<void> deleteExpense(String id)

// 更新消费记录
Future<void> updateExpense(Expense expense)

// 获取余额
Future<double> getBalance()

// 更新余额
Future<void> updateBalance(double balance)

// 按日期范围筛选
List<Expense> filterByDateRange(
  List<Expense> expenses,
  DateTime? startDate,
  DateTime? endDate,
)

// 按类型筛选
List<Expense> filterByType(
  List<Expense> expenses,
  ExpenseType? type,
)

// 按日期分组
Map<DateTime, List<Expense>> groupByDate(List<Expense> expenses)

// 获取每日消费列表
List<DailyExpense> getDailyExpenses(List<Expense> expenses)
```

**数据流：**
```
forceRefresh=true  → API → Local Storage → Return
forceRefresh=false → Local Storage → Return
```

## 控制器

### ExpenseController

**功能：** 管理消费数据和业务逻辑

**响应式属性：**

```dart
RxList<Expense> expenses                  // 所有消费记录
RxList<DailyExpense> dailyExpenses       // 分组后的每日消费
Rx<double> balance                        // 当前余额
RxBool isLoading                          // 加载状态
RxString error                            // 错误信息
Rx<ExpenseType?> selectedType            // 选中的筛选类型
Rx<DateTime?> startDate                  // 筛选开始日期
Rx<DateTime?> endDate                    // 筛选结束日期
```

**方法：**

```dart
// 加载消费记录
Future<void> loadExpenses({bool forceRefresh = false})

// 添加消费
Future<void> addExpense(Expense expense)

// 删除消费
Future<void> deleteExpense(String id)

// 加载余额
Future<void> loadBalance()

// 设置类型筛选
void setFilterType(ExpenseType? type)

// 设置日期范围筛选
void setDateRange(DateTime? start, DateTime? end)

// 重置筛选
void resetFilters()
```

**计算属性：**

```dart
// 总消费金额
double get totalExpense

// 按类型统计消费
Map<ExpenseType, double> getExpenseByType()
```

**使用示例：**

```dart
// 注入控制器
final controller = Get.put(ExpenseController());

// 监听数据变化
Obx(() => Text(controller.totalExpense.toString()))

// 添加消费
controller.addExpense(expense);

// 设置筛选
controller.setFilterType(ExpenseType.catering);
controller.setDateRange(startDate, endDate);

// 重置筛选
controller.resetFilters();
```

### NavigationController

**功能：** 管理底部导航栏状态

**响应式属性：**

```dart
RxInt selectedIndex  // 当前选中的页面索引
```

**方法：**

```dart
// 切换页面
void changeIndex(int index)
```

**使用示例：**

```dart
// 注入控制器
final navController = Get.put(NavigationController());

// 监听状态
Obx(() => BottomNavigationBar(
  currentIndex: navController.selectedIndex.value,
  onTap: navController.changeIndex,
))
```

## 页面 API

### HomePage

**路由：** 默认主页

**参数：** 无

**功能：**
- 底部导航栏
- 页面切换
- 筛选对话框
- 分享功能

### ExpenseListPage

**功能：**
- 显示消费列表
- 下拉刷新
- 日期筛选
- 删除确认

**依赖控制器：** ExpenseController

### ExpenseChartPage

**功能：**
- 总支出统计
- 饼图展示
- 折线图展示
- 类别排行

**依赖控制器：** ExpenseController

### AddExpensePage

**路由：** 通过 FAB 或底部导航打开

**功能：**
- 添加消费表单
- 表单验证
- 保存消费

**依赖控制器：** ExpenseController

## 工具函数

### DemoDataHelper

```dart
// 初始化演示数据
static Future<void> initializeDemoData()
```

**注意：** 仅在首次运行且无数据时执行

## 常量定义

### AppColors

```dart
static const Color primary = Color(0xFFFFD700);      // 金黄色
static const Color black = Color(0xFF000000);        // 黑色
static const Color white = Color(0xFFFFFFFF);        // 白色
static const Color pink = Color(0xFFEA655C);         // 粉红色
static const Color catering = Color(0xFFFF6B6B);     // 餐饮
static const Color transportation = Color(0x4ECDC4);  // 交通
static const Color shopping = Color(0xFFFFBE0B);     // 购物
static const Color communication = Color(0xFF95E1D3); // 通讯
```

### AppStrings

**应用相关：**
- `appName` - 应用名称

**导航相关：**
- `navExpenseList` - 列表
- `navExpenseChart` - 图表
- `navAddExpense` - 添加

**标签：**
- `dateLabel` - 日期
- `expenseLabel` - 支出
- `balanceLabel` - 结余

**类型：**
- `typeCatering` - 餐饮
- `typeTransportation` - 交通
- `typeShopping` - 购物
- `typeCommunication` - 通讯

## GetX 相关 API

### 依赖注入

```dart
// 注入单例
Get.put(ExpenseController());

// 查找实例
final controller = Get.find<ExpenseController>();

// 延迟注入
Get.lazyPut(() => ExpenseController());
```

### 路由导航

```dart
// 跳转页面
Get.to(() => AddExpensePage());

// 返回
Get.back();

// 替换当前页面
Get.off(() => HomePage());

// 清除所有并跳转
Get.offAll(() => HomePage());
```

### 对话框和提示

```dart
// Snackbar
Get.snackbar(
  '标题',
  '内容',
  snackPosition: SnackPosition.BOTTOM,
  duration: Duration(seconds: 2),
);

// Dialog
Get.dialog(AlertDialog(...));

// BottomSheet
Get.bottomSheet(Widget);
```

### 响应式编程

```dart
// 创建响应式变量
final count = 0.obs;
final list = <String>[].obs;
final user = Rx<User?>(null);

// 监听变化
Obx(() => Text(count.toString()))

// 更新值
count.value = 1;
list.add('item');
user.value = User();
```

## 错误处理

### 网络错误

```dart
try {
  await apiService.fetchExpenses();
} on DioException catch (e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      // 处理超时
      break;
    case DioExceptionType.badResponse:
      // 处理服务器错误
      break;
    default:
      // 其他错误
  }
}
```

### 本地存储错误

```dart
try {
  await localStorageService.loadExpenses();
} catch (e) {
  // 返回空列表或默认值
  return [];
}
```

## 性能优化建议

### 1. 列表优化

```dart
// 使用 ListView.builder
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

### 2. const 构造函数

```dart
// 尽可能使用 const
const Text('Hello')
const SizedBox(height: 16)
```

### 3. 避免过度重建

```dart
// 只监听需要的数据
Obx(() => Text(controller.count.toString()))

// 而不是
Obx(() => ComplexWidget(controller: controller))
```

### 4. 图片缓存

```dart
// 使用 cached_network_image 缓存网络图片
CachedNetworkImage(imageUrl: url)
```

## 测试

### 单元测试示例

```dart
test('Expense 模型测试', () {
  final expense = Expense(
    type: ExpenseType.catering,
    amount: 50.0,
    description: '午餐',
    date: DateTime.now(),
  );
  
  expect(expense.amount, 50.0);
  expect(expense.type.id, 'catering');
});
```

### Widget 测试示例

```dart
testWidgets('ExpenseItemCard 显示测试', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ExpenseItemCard(expense: testExpense),
    ),
  );
  
  expect(find.text('午餐'), findsOneWidget);
  expect(find.text('¥50.00'), findsOneWidget);
});
```

## 版本历史

### v1.0.0 (2024-01-01)
- ✅ 初始版本发布
- ✅ 实现所有核心功能
- ✅ 完整的文档

---

**文档版本**: 1.0.0  
**最后更新**: 2024-01-01  
**维护者**: Money Track Team

