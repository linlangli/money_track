# 扩展方法使用指南

## 导入扩展

```dart
// 导入所有扩展
import 'package:money_track/core/extensions/extensions.dart';

// 或者按需导入
import 'package:money_track/core/extensions/widget_extensions.dart';
import 'package:money_track/core/extensions/screen_extensions.dart';
```

## 1. Widget 扩展使用示例

### 点击事件

```dart
// 使用 onTap
Text('点击我')
  .onTap(() => print('clicked'));

// 使用 inkTap（带水波纹效果）
Container(...)
  .inkTap(() => print('clicked'), borderRadius: BorderRadius.circular(8));

// 长按事件
Text('长按我')
  .onLongPress(() => print('long pressed'));
```

### 内边距和外边距

```dart
// 各种内边距
Text('Hello')
  .paddingAll(16)                  // 所有方向 16
  .paddingHorizontal(20)           // 水平 20
  .paddingVertical(10)             // 垂直 10
  .paddingLeft(5)                  // 左边 5
  .paddingTop(8);                  // 上边 8

// 外边距
Container(...)
  .marginAll(16)
  .marginHorizontal(20);
```

### 尺寸和布局

```dart
// 设置尺寸
Container(...)
  .width(100)
  .height(50)
  .size(100, 50);

// 居中
Text('居中文本').center();

// 对齐
Text('右对齐').align(Alignment.centerRight);

// 扩展填充
Container(...).expanded(flex: 2);
```

### 样式效果

```dart
// 圆角
Container(...).cornerRadius(12);

// 背景色
Text('Hello').backgroundColor(Colors.blue);

// 阴影
Container(...).shadow(
  color: Colors.black26,
  blurRadius: 10,
  offset: Offset(0, 4),
);

// 透明度
Container(...).opacity(0.5);

// 显示/隐藏
Container(...).visible(isVisible);
```

### 卡片效果

```dart
Container(...)
  .card(
    elevation: 4,
    borderRadius: BorderRadius.circular(12),
    margin: EdgeInsets.all(16),
  );
```

### 滚动

```dart
Column(
  children: [...]
).scrollable();
```

## 2. 屏幕适配扩展

### 获取屏幕信息

```dart
// 在 BuildContext 中使用
@override
Widget build(BuildContext context) {
  final width = context.screenWidth;
  final height = context.screenHeight;
  final statusBar = context.statusBarHeight;
  
  // 判断设备类型
  if (context.isPhone) {
    // 手机布局
  }
  
  if (context.isTablet) {
    // 平板布局
  }
  
  // 判断方向
  if (context.isLandscape) {
    // 横屏布局
  }
}
```

### 屏幕适配

```dart
// 根据设计稿适配（设计稿宽度 375）
double adaptedWidth = context.wp(100);  // 100 在 375 设计稿中的实际宽度
double adaptedHeight = context.hp(50);   // 50 在 812 设计稿中的实际高度
double adaptedFont = context.sp(16);     // 字体大小适配

// 或者使用数值扩展（全局适配）
Container(
  width: 100.w,      // 宽度适配
  height: 50.h,      // 高度适配
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 16.sp),  // 字体适配
  ),
);

// 快捷创建间距
12.widthBox,      // SizedBox(width: 12)
16.heightBox,     // SizedBox(height: 16)
10.horizontalSpace, // 水平间距
8.verticalSpace,    // 垂直间距
```

### 便捷方法

```dart
// 关闭键盘
context.hideKeyboard();

// 显示 SnackBar
context.showSnackBar('操作成功');

// 获取主题
final theme = context.theme;
final textTheme = context.textTheme;
final colorScheme = context.colorScheme;
```

### 响应式布局

```dart
// 根据屏幕尺寸返回不同值
final columns = Responsive.value(
  context,
  mobile: 1,
  tablet: 2,
  desktop: 3,
);

// 判断设备类型
if (Responsive.isMobile(context)) {
  // 移动端布局
}
```

## 3. 字符串扩展

### 验证

```dart
final email = 'test@example.com';
if (email.isEmail) {
  print('有效的邮箱');
}

final phone = '13800138000';
if (phone.isPhoneNumber) {
  print('有效的手机号');
}

// 其他验证
'123'.isNumeric;           // 是否只包含数字
'abc'.isAlpha;             // 是否只包含字母
'abc123'.isAlphaNumeric;   // 是否只包含字母和数字
'https://...'.isURL;       // 是否是有效 URL
```

### 格式化

```dart
// 首字母大写
'hello'.capitalize();  // 'Hello'

// 标题格式
'hello world'.toTitleCase();  // 'Hello World'

// 货币格式
'1234.56'.formatCurrency();  // '1,234.56'
'1234.56'.toCurrencyString();  // '¥1,234.56'
```

### 隐藏敏感信息

```dart
'13800138000'.maskPhoneNumber;  // '138****8000'
'110101199001011234'.maskIDCard;  // '110101********1234'
'test@example.com'.maskEmail;  // 'te***@example.com'
```

### 字符串处理

```dart
// 截取
'Hello World'.truncate(5);  // 'Hello...'

// 反转
'Hello'.reverse();  // 'olleH'

// 移除空格
'  hello  world  '.removeAllWhitespace();  // 'helloworld'

// 转换命名风格
'hello_world'.toCamelCase();  // 'helloWorld'
'helloWorld'.toSnakeCase();   // 'hello_world'
'HelloWorld'.toKebabCase();   // 'hello-world'

// 提取数字/字母
'abc123def456'.extractNumbers();  // '123456'
'abc123def456'.extractLetters();  // 'abcdef'
```

### 中文处理

```dart
'你好world'.containsChinese;  // true
'你好世界'.isAllChinese;      // true
'你好'.byteLength;            // 4（中文按2字节计算）
```

### 可空字符串

```dart
String? nullable = null;

if (nullable.isNullOrEmpty) {
  print('为空或 null');
}

final value = nullable.orDefault('默认值');  // 如果为 null 返回默认值
```

## 4. DateTime 扩展

### 格式化

```dart
final now = DateTime.now();

now.format('yyyy-MM-dd');           // '2024-01-01'
now.toDateString;                   // '2024-01-01'
now.toTimeString;                   // '12:30:45'
now.toChineseDate;                  // '2024年01月01日'
now.toChineseDateTime;              // '2024年01月01日 12:30'
now.toRelativeTime;                 // '刚刚' / '5分钟前' / '2天前'
```

### 判断

```dart
final date = DateTime.now();

date.isToday;        // 是否是今天
date.isYesterday;    // 是否是昨天
date.isTomorrow;     // 是否是明天
date.isThisWeek;     // 是否是本周
date.isThisMonth;    // 是否是本月
date.isThisYear;     // 是否是本年
date.isWorkday;      // 是否是工作日
date.isWeekend;      // 是否是周末
date.isLeapYear;     // 是否是闰年
```

### 获取信息

```dart
final date = DateTime.now();

date.weekdayName;           // '周一'
date.monthName;             // '一月'
date.firstDayOfMonth;       // 该月第一天
date.lastDayOfMonth;        // 该月最后一天
date.firstDayOfWeek;        // 该周第一天
date.lastDayOfWeek;         // 该周最后一天
date.daysInMonth;           // 该月天数
date.quarter;               // 季度（1-4）
date.age;                   // 计算年龄
```

### 日期操作

```dart
final date = DateTime.now();

// 日期开始/结束
date.startOfDay;  // 当天 00:00:00
date.endOfDay;    // 当天 23:59:59

// 复制并修改
date.copyWith(year: 2025, month: 12);

// 添加工作日（跳过周末）
date.addWorkdays(5);

// 比较日期（不比较时间）
date1.isSameDate(date2);
date1.isAfterDate(date2);
date1.isBeforeDate(date2);
```

### 日期范围

```dart
// 预定义范围
DateRange.today;       // 今天
DateRange.yesterday;   // 昨天
DateRange.thisWeek;    // 本周
DateRange.thisMonth;   // 本月
DateRange.thisYear;    // 本年
DateRange.last7Days;   // 最近7天
DateRange.last30Days;  // 最近30天

// 自定义范围
final range = DateRange(startDate, endDate);
range.days;                  // 天数
range.contains(someDate);    // 是否包含某个日期
```

## 5. 集合扩展

### List 扩展

```dart
final list = [1, 2, 3, 4, 5];

// 安全获取
list.getOrNull(10);           // null（超出索引）
list.getOrDefault(10, 0);     // 0（默认值）
list.firstOrNull;             // 安全获取第一个
list.lastOrNull;              // 安全获取最后一个

// 数学运算（数字列表）
list.sum();      // 求和：15
list.average();  // 平均值：3.0
list.max();      // 最大值：5
list.min();      // 最小值：1

// 分块
[1,2,3,4,5].chunk(2);  // [[1,2], [3,4], [5]]

// 去重
[1,2,2,3,3,3].unique();  // [1,2,3]

// 分组
final users = [
  User(name: 'Alice', age: 20),
  User(name: 'Bob', age: 20),
  User(name: 'Charlie', age: 30),
];
users.groupBy((u) => u.age);  // {20: [Alice, Bob], 30: [Charlie]}

// 条件查找
list.firstWhereOrNull((e) => e > 10);  // null
list.lastWhereOrNull((e) => e > 3);    // 5

// 随机获取
list.random;  // 随机一个元素

// 分割
final (evens, odds) = list.partition((e) => e % 2 == 0);
// evens: [2, 4], odds: [1, 3, 5]
```

### Map 扩展

```dart
final map = {'a': 1, 'b': 2, 'c': 3};

// 安全获取
map.getOrNull('d');           // null
map.getOrDefault('d', 0);     // 0

// 根据值获取键
map.keyForValue(2);           // 'b'

// 反转键值
map.reverse;                  // {1: 'a', 2: 'b', 3: 'c'}

// 筛选
map.whereKey((k) => k != 'a');     // {'b': 2, 'c': 3}
map.whereValue((v) => v > 1);      // {'b': 2, 'c': 3}

// 映射
map.mapKeys((k, v) => k.toUpperCase());  // {'A': 1, 'B': 2, 'C': 3}
map.mapValues((k, v) => v * 2);          // {'a': 2, 'b': 4, 'c': 6}
```

### Iterable 扩展

```dart
final items = [1, 2, 3];

// 在元素之间插入分隔符
items.intersperse(0);  // [1, 0, 2, 0, 3]

// Widget 列表中插入分隔符
[Text('A'), Text('B'), Text('C')]
  .separatedBy(Divider());

// 统计满足条件的元素
items.countWhere((e) => e > 1);  // 2

// 条件判断
items.every((e) => e > 0);   // 所有都满足：true
items.any((e) => e > 2);     // 至少一个满足：true
items.none((e) => e > 5);    // 没有满足：true
```

## 实际应用示例

### 示例 1：优化的列表项

```dart
Widget buildListItem(Item item) {
  return Row(
    children: [
      Image.network(item.imageUrl)
        .width(60)
        .height(60)
        .cornerRadius(8),
      16.widthBox,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title),
          4.heightBox,
          Text(item.description)
            .opacity(0.6),
        ],
      ).expanded(),
      Text(item.price.toCurrencyString()),
    ],
  )
    .paddingAll(16)
    .card(elevation: 2)
    .onTap(() => onItemTap(item));
}
```

### 示例 2：响应式布局

```dart
Widget buildGrid(BuildContext context) {
  final columns = context.isPhone ? 2 : context.isTablet ? 3 : 4;
  
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: columns,
      childAspectRatio: 1.0,
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.h,
    ),
    itemBuilder: (context, index) => buildGridItem(index),
  ).paddingAll(16);
}
```

### 示例 3：日期筛选

```dart
Widget buildDateFilter() {
  return Wrap(
    spacing: 8,
    children: [
      buildFilterChip('今天', DateRange.today),
      buildFilterChip('本周', DateRange.thisWeek),
      buildFilterChip('本月', DateRange.thisMonth),
      buildFilterChip('最近7天', DateRange.last7Days),
    ],
  );
}
```

### 示例 4：表单验证

```dart
String? validateEmail(String? value) {
  if (value.isNullOrEmpty) {
    return '请输入邮箱';
  }
  if (!value!.isEmail) {
    return '请输入有效的邮箱地址';
  }
  return null;
}

String? validatePhone(String? value) {
  if (value.isNullOrEmpty) {
    return '请输入手机号';
  }
  if (!value!.isPhoneNumber) {
    return '请输入有效的手机号';
  }
  return null;
}
```

## 链式调用示例

```dart
// 组合多个扩展实现复杂布局
Container(
  child: Column(
    children: [
      Text('标题'),
      8.heightBox,
      Text('内容').opacity(0.7),
    ],
  )
    .paddingAll(16)
    .card(elevation: 2, borderRadius: BorderRadius.circular(12))
    .marginHorizontal(16)
    .marginVertical(8),
)
  .onTap(() => print('Tapped'))
  .hero('card-tag');
```

---

这些扩展方法可以让你的代码更加简洁、易读，提高开发效率！

