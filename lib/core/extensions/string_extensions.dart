/// 字符串扩展方法
extension StringExtensions on String {
  /// 是否为空或null
  bool get isNullOrEmpty => isEmpty;

  /// 是否不为空
  bool get isNotNullOrEmpty => isNotEmpty;

  /// 首字母大写
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// 首字母小写
  String uncapitalize() {
    if (isEmpty) return this;
    return '${this[0].toLowerCase()}${substring(1)}';
  }

  /// 转换为标题格式（每个单词首字母大写）
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// 移除所有空格
  String removeAllWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// 是否是有效的邮箱
  bool get isEmail {
    return RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    ).hasMatch(this);
  }

  /// 是否是有效的手机号（中国大陆）
  bool get isPhoneNumber {
    return RegExp(r'^1[3-9]\d{9}$').hasMatch(this);
  }

  /// 是否是有效的身份证号
  bool get isIDCard {
    return RegExp(r'^\d{17}[\dXx]$').hasMatch(this);
  }

  /// 是否只包含数字
  bool get isNumeric {
    return RegExp(r'^\d+$').hasMatch(this);
  }

  /// 是否只包含字母
  bool get isAlpha {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(this);
  }

  /// 是否只包含字母和数字
  bool get isAlphaNumeric {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  }

  /// 是否是有效的 URL
  bool get isURL {
    return RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    ).hasMatch(this);
  }

  /// 是否是有效的 IPv4 地址
  bool get isIPv4 {
    return RegExp(
      r'^(\d{1,3}\.){3}\d{1,3}$',
    ).hasMatch(this);
  }

  /// 转换为 int
  int? toInt() {
    return int.tryParse(this);
  }

  /// 转换为 double
  double? toDouble() {
    return double.tryParse(this);
  }

  /// 转换为 DateTime
  DateTime? toDateTime() {
    return DateTime.tryParse(this);
  }

  /// 反转字符串
  String reverse() {
    return split('').reversed.join();
  }

  /// 截取字符串（带省略号）
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$ellipsis';
  }

  /// 移除 HTML 标签
  String removeHtmlTags() {
    return replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// 是否包含（忽略大小写）
  bool containsIgnoreCase(String other) {
    return toLowerCase().contains(other.toLowerCase());
  }

  /// 替换（忽略大小写）
  String replaceIgnoreCase(String from, String replace) {
    return replaceAll(RegExp(from, caseSensitive: false), replace);
  }

  /// 统计字符出现次数
  int countOccurrences(String char) {
    return split('').where((c) => c == char).length;
  }

  /// 是否是回文
  bool get isPalindrome {
    final normalized = toLowerCase().removeAllWhitespace();
    return normalized == normalized.reverse();
  }

  /// 转换为驼峰命名
  String toCamelCase() {
    return split('_')
        .asMap()
        .map((index, word) =>
            MapEntry(index, index == 0 ? word : word.capitalize()))
        .values
        .join('');
  }

  /// 转换为蛇形命名
  String toSnakeCase() {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }

  /// 转换为短横线命名
  String toKebabCase() {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '-${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^-'), '');
  }

  /// 隐藏手机号中间4位
  String get maskPhoneNumber {
    if (length != 11) return this;
    return replaceRange(3, 7, '****');
  }

  /// 隐藏身份证号中间部分
  String get maskIDCard {
    if (length != 18) return this;
    return replaceRange(6, 14, '********');
  }

  /// 隐藏邮箱地址
  String get maskEmail {
    if (!isEmail) return this;
    final parts = split('@');
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return this;
    return '${name.substring(0, 2)}***@$domain';
  }

  /// 格式化金额（添加千位分隔符）
  String formatCurrency() {
    final number = toDouble();
    if (number == null) return this;
    return number.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
  }

  /// 格式化为货币字符串（带货币符号）
  String toCurrencyString({String symbol = '¥'}) {
    return '$symbol${formatCurrency()}';
  }

  /// 计算字符串的字节长度（中文算2个字节）
  int get byteLength {
    int length = 0;
    for (int i = 0; i < this.length; i++) {
      int charCode = codeUnitAt(i);
      if (charCode < 128) {
        length += 1;
      } else {
        length += 2;
      }
    }
    return length;
  }

  /// 按字节截取字符串
  String truncateByBytes(int maxBytes, {String ellipsis = '...'}) {
    int byteCount = 0;
    int charIndex = 0;

    for (int i = 0; i < length; i++) {
      int charCode = codeUnitAt(i);
      byteCount += (charCode < 128) ? 1 : 2;

      if (byteCount > maxBytes) {
        break;
      }
      charIndex = i + 1;
    }

    if (charIndex < length) {
      return '${substring(0, charIndex)}$ellipsis';
    }
    return this;
  }

  /// 移除首尾空格并压缩中间连续空格为单个空格
  String normalizeWhitespace() {
    return trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// 是否包含中文字符
  bool get containsChinese {
    return RegExp(r'[\u4e00-\u9fa5]').hasMatch(this);
  }

  /// 是否全是中文字符
  bool get isAllChinese {
    return RegExp(r'^[\u4e00-\u9fa5]+$').hasMatch(this);
  }

  /// 提取所有数字
  String extractNumbers() {
    return replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// 提取所有字母
  String extractLetters() {
    return replaceAll(RegExp(r'[^a-zA-Z]'), '');
  }

  /// 生成指定长度的随机字符串
  static String random(int length,
      {bool useNumbers = true,
      bool useLetters = true,
      bool useUpperCase = true}) {
    const numbers = '0123456789';
    const lowercaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    const uppercaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    String chars = '';
    if (useNumbers) chars += numbers;
    if (useLetters) {
      chars += lowercaseLetters;
      if (useUpperCase) chars += uppercaseLetters;
    }

    if (chars.isEmpty) chars = numbers + lowercaseLetters;

    return List.generate(
      length,
      (index) => chars[(DateTime.now().millisecondsSinceEpoch + index) % chars.length],
    ).join();
  }
}

/// 可空字符串扩展
extension NullableStringExtensions on String? {
  /// 是否为 null 或空
  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }

  /// 是否不为 null 且不为空
  bool get isNotNullOrEmpty {
    return this != null && this!.isNotEmpty;
  }

  /// 获取非空值，如果为 null 或空则返回默认值
  String orDefault(String defaultValue) {
    return isNotNullOrEmpty ? this! : defaultValue;
  }

  /// 如果为 null 或空则返回 null，否则返回原值
  String? get orNull {
    return isNotNullOrEmpty ? this : null;
  }
}

