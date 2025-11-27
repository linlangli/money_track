/// 底部导航栏标签枚举
enum BottomNavTab {
  /// 消费列表
  list,

  /// 消费图表
  chart;

  /// 获取标签名称
  String get label {
    switch (this) {
      case BottomNavTab.list:
        return '列表';
      case BottomNavTab.chart:
        return '图表';
    }
  }

  /// 获取图标路径
  String get iconPath {
    switch (this) {
      case BottomNavTab.list:
        return 'assets/icons/icon_navigation_expend_list.svg';
      case BottomNavTab.chart:
        return 'assets/icons/icon_navigation_expend_chart.svg';
    }
  }

  /// 根据索引获取枚举
  static BottomNavTab fromIndex(int index) {
    switch (index) {
      case 0:
        return BottomNavTab.list;
      case 1:
        return BottomNavTab.chart;
      default:
        return BottomNavTab.list;
    }
  }

  /// 获取所有标签
  static List<BottomNavTab> get all => [list, chart];
}

/// 顶部导航栏操作枚举
enum TopNavAction {
  /// 筛选
  filter,

  /// 分享
  share,

  /// 菜单
  menu,

  /// 设置
  settings,

  /// 搜索
  search;

  /// 获取名称
  String get label {
    switch (this) {
      case TopNavAction.filter:
        return '筛选';
      case TopNavAction.share:
        return '分享';
      case TopNavAction.menu:
        return '菜单';
      case TopNavAction.settings:
        return '设置';
      case TopNavAction.search:
        return '搜索';
    }
  }

  /// 获取图标路径（SVG）
  String? get iconPath {
    switch (this) {
      case TopNavAction.share:
        return 'assets/icons/icon_navigation_share.svg';
      case TopNavAction.menu:
        return 'assets/icons/icon_navigation_menu.svg';
      case TopNavAction.filter:
      case TopNavAction.settings:
      case TopNavAction.search:
        return null; // 使用 Material Icons
    }
  }

  /// 获取 Material Icon（当 iconPath 为 null 时使用）
  String? get materialIcon {
    switch (this) {
      case TopNavAction.filter:
        return 'filter_list';
      case TopNavAction.settings:
        return 'settings';
      case TopNavAction.search:
        return 'search';
      case TopNavAction.share:
      case TopNavAction.menu:
        return null; // 使用 SVG
    }
  }
}

/// 消费类型枚举（如果需要统一管理）
enum ExpenseCategory {
  /// 餐饮
  catering,

  /// 交通
  transportation,

  /// 购物
  shopping,

  /// 通讯
  communication;

  /// 获取类型名称
  String get name {
    switch (this) {
      case ExpenseCategory.catering:
        return '餐饮';
      case ExpenseCategory.transportation:
        return '交通';
      case ExpenseCategory.shopping:
        return '购物';
      case ExpenseCategory.communication:
        return '通讯';
    }
  }

  /// 获取图标路径
  String get iconPath {
    switch (this) {
      case ExpenseCategory.catering:
        return 'assets/icons/icon_expend_type_ catering.svg';
      case ExpenseCategory.transportation:
        return 'assets/icons/icon_expend_type_transportation.svg';
      case ExpenseCategory.shopping:
        return 'assets/icons/icon_expend_type_shopping.svg';
      case ExpenseCategory.communication:
        return 'assets/icons/icon_expend_type_communication.svg';
    }
  }

  /// 获取所有类型
  static List<ExpenseCategory> get all => [
        catering,
        transportation,
        shopping,
        communication,
      ];
}

/// 页面路由枚举
enum AppRoute {
  /// 主页
  home,

  /// 消费列表
  expenseList,

  /// 消费图表
  expenseChart,

  /// 添加消费
  addExpense,

  /// 消费详情
  expenseDetail,

  /// 设置
  settings;

  /// 获取路由名称
  String get name {
    switch (this) {
      case AppRoute.home:
        return '/';
      case AppRoute.expenseList:
        return '/expense_list';
      case AppRoute.expenseChart:
        return '/expense_chart';
      case AppRoute.addExpense:
        return '/add_expense';
      case AppRoute.expenseDetail:
        return '/expense_detail';
      case AppRoute.settings:
        return '/settings';
    }
  }
}

/// 日期筛选范围枚举
enum DateFilterRange {
  /// 今天
  today,

  /// 昨天
  yesterday,

  /// 本周
  thisWeek,

  /// 本月
  thisMonth,

  /// 本年
  thisYear,

  /// 最近7天
  last7Days,

  /// 最近30天
  last30Days,

  /// 自定义
  custom;

  /// 获取名称
  String get label {
    switch (this) {
      case DateFilterRange.today:
        return '今天';
      case DateFilterRange.yesterday:
        return '昨天';
      case DateFilterRange.thisWeek:
        return '本周';
      case DateFilterRange.thisMonth:
        return '本月';
      case DateFilterRange.thisYear:
        return '本年';
      case DateFilterRange.last7Days:
        return '最近7天';
      case DateFilterRange.last30Days:
        return '最近30天';
      case DateFilterRange.custom:
        return '自定义';
    }
  }
}

/// 排序方式枚举
enum SortOrder {
  /// 按日期降序（最新在前）
  dateDesc,

  /// 按日期升序（最旧在前）
  dateAsc,

  /// 按金额降序（最大在前）
  amountDesc,

  /// 按金额升序（最小在前）
  amountAsc;

  /// 获取名称
  String get label {
    switch (this) {
      case SortOrder.dateDesc:
        return '日期降序';
      case SortOrder.dateAsc:
        return '日期升序';
      case SortOrder.amountDesc:
        return '金额降序';
      case SortOrder.amountAsc:
        return '金额升序';
    }
  }
}

