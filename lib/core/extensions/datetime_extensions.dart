import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// DateTime 扩展方法
extension DateTimeExtensions on DateTime {
  /// 格式化为字符串（默认格式：yyyy-MM-dd）
  String format([String pattern = 'yyyy-MM-dd']) {
    return DateFormat(pattern).format(this);
  }

  /// 格式化为日期字符串
  String get toDateString => format('yyyy-MM-dd');

  /// 格式化为时间字符串
  String get toTimeString => format('HH:mm:ss');

  /// 格式化为日期时间字符串
  String get toDateTimeString => format('yyyy-MM-dd HH:mm:ss');

  /// 格式化为中文日期
  String get toChineseDate => format('yyyy年MM月dd日');

  /// 格式化为中文日期时间
  String get toChineseDateTime => format('yyyy年MM月dd日 HH:mm');

  /// 格式化为相对时间（刚刚、1分钟前等）
  String get toRelativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return '刚刚';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}周前';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}个月前';
    } else {
      return '${(difference.inDays / 365).floor()}年前';
    }
  }

  /// 是否是今天
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// 是否是昨天
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// 是否是明天
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// 是否是本周
  bool get isThisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    return isAfter(weekStart) && isBefore(weekEnd);
  }

  /// 是否是本月
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// 是否是本年
  bool get isThisYear {
    return year == DateTime.now().year;
  }

  /// 获取星期几（1-7，周一到周日）
  int get dayOfWeek => weekday;

  /// 获取星期几的中文名称
  String get weekdayName {
    const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return weekdays[weekday - 1];
  }

  /// 获取月份的中文名称
  String get monthName {
    const months = [
      '一月',
      '二月',
      '三月',
      '四月',
      '五月',
      '六月',
      '七月',
      '八月',
      '九月',
      '十月',
      '十一月',
      '十二月'
    ];
    return months[month - 1];
  }

  /// 获取该月的第一天
  DateTime get firstDayOfMonth => DateTime(year, month, 1);

  /// 获取该月的最后一天
  DateTime get lastDayOfMonth => DateTime(year, month + 1, 0);

  /// 获取该周的第一天（周一）
  DateTime get firstDayOfWeek => subtract(Duration(days: weekday - 1));

  /// 获取该周的最后一天（周日）
  DateTime get lastDayOfWeek => add(Duration(days: 7 - weekday));

  /// 获取该年的第一天
  DateTime get firstDayOfYear => DateTime(year, 1, 1);

  /// 获取该年的最后一天
  DateTime get lastDayOfYear => DateTime(year, 12, 31);

  /// 是否是闰年
  bool get isLeapYear {
    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  }

  /// 获取该月的天数
  int get daysInMonth {
    return DateTime(year, month + 1, 0).day;
  }

  /// 添加工作日（跳过周末）
  DateTime addWorkdays(int days) {
    DateTime result = this;
    int addedDays = 0;

    while (addedDays < days.abs()) {
      result = result.add(Duration(days: days > 0 ? 1 : -1));
      if (result.weekday != DateTime.saturday &&
          result.weekday != DateTime.sunday) {
        addedDays++;
      }
    }

    return result;
  }

  /// 是否是工作日
  bool get isWorkday {
    return weekday != DateTime.saturday && weekday != DateTime.sunday;
  }

  /// 是否是周末
  bool get isWeekend {
    return weekday == DateTime.saturday || weekday == DateTime.sunday;
  }

  /// 获取时间戳（秒）
  int get timestampSeconds => millisecondsSinceEpoch ~/ 1000;

  /// 获取时间戳（毫秒）
  int get timestampMilliseconds => millisecondsSinceEpoch;

  /// 复制并修改日期
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  /// 设置为当天的开始时间（00:00:00）
  DateTime get startOfDay => DateTime(year, month, day);

  /// 设置为当天的结束时间（23:59:59）
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// 是否在某个日期之后（只比较日期，不比较时间）
  bool isAfterDate(DateTime other) {
    return startOfDay.isAfter(other.startOfDay);
  }

  /// 是否在某个日期之前（只比较日期，不比较时间）
  bool isBeforeDate(DateTime other) {
    return startOfDay.isBefore(other.startOfDay);
  }

  /// 是否与某个日期相同（只比较日期，不比较时间）
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// 计算年龄
  int get age {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  /// 转换为本地时间
  DateTime get toLocalTime => toLocal();

  /// 转换为 UTC 时间
  DateTime get toUtcTime => toUtc();

  /// 获取季度（1-4）
  int get quarter => ((month - 1) ~/ 3) + 1;

  /// 获取该季度的第一天
  DateTime get firstDayOfQuarter {
    final firstMonthOfQuarter = ((quarter - 1) * 3) + 1;
    return DateTime(year, firstMonthOfQuarter, 1);
  }

  /// 获取该季度的最后一天
  DateTime get lastDayOfQuarter {
    final lastMonthOfQuarter = quarter * 3;
    return DateTime(year, lastMonthOfQuarter + 1, 0);
  }
}

/// 可空 DateTime 扩展
extension NullableDateTimeExtensions on DateTime? {
  /// 格式化为字符串，如果为 null 则返回默认值
  String formatOrDefault(String defaultValue, [String pattern = 'yyyy-MM-dd']) {
    return this != null ? this!.format(pattern) : defaultValue;
  }

  /// 是否为 null
  bool get isNull => this == null;

  /// 是否不为 null
  bool get isNotNull => this != null;
}

/// 时间范围
class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange(this.start, this.end);

  /// 天数
  int get days => end.difference(start).inDays + 1;

  /// 是否包含某个日期
  bool contains(DateTime date) {
    return date.isAfter(start.subtract(const Duration(days: 1))) &&
        date.isBefore(end.add(const Duration(days: 1)));
  }

  /// 今天
  static DateRange get today {
    final now = DateTime.now();
    return DateRange(now.startOfDay, now.endOfDay);
  }

  /// 昨天
  static DateRange get yesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return DateRange(yesterday.startOfDay, yesterday.endOfDay);
  }

  /// 本周
  static DateRange get thisWeek {
    final now = DateTime.now();
    return DateRange(now.firstDayOfWeek, now.lastDayOfWeek);
  }

  /// 本月
  static DateRange get thisMonth {
    final now = DateTime.now();
    return DateRange(now.firstDayOfMonth, now.lastDayOfMonth);
  }

  /// 本年
  static DateRange get thisYear {
    final now = DateTime.now();
    return DateRange(now.firstDayOfYear, now.lastDayOfYear);
  }

  /// 最近7天
  static DateRange get last7Days {
    final end = DateTime.now();
    final start = end.subtract(const Duration(days: 6));
    return DateRange(start.startOfDay, end.endOfDay);
  }

  /// 最近30天
  static DateRange get last30Days {
    final end = DateTime.now();
    final start = end.subtract(const Duration(days: 29));
    return DateRange(start.startOfDay, end.endOfDay);
  }
}

