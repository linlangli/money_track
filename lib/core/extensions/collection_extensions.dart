import 'package:flutter/material.dart';

/// List 扩展方法
extension ListExtensions<T> on List<T> {
  /// 安全获取元素（超出索引返回 null）
  T? getOrNull(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }

  /// 安全获取元素（超出索引返回默认值）
  T getOrDefault(int index, T defaultValue) {
    return getOrNull(index) ?? defaultValue;
  }

  /// 是否不为空
  bool get isNotNullOrEmpty => isNotEmpty;

  /// 第一个元素（安全）
  T? get firstOrNull => isEmpty ? null : first;

  /// 最后一个元素（安全）
  T? get lastOrNull => isEmpty ? null : last;

  /// 随机获取一个元素
  T? get random {
    if (isEmpty) return null;
    return this[(DateTime.now().millisecondsSinceEpoch % length)];
  }

  /// 分块处理
  List<List<T>> chunk(int size) {
    List<List<T>> chunks = [];
    for (int i = 0; i < length; i += size) {
      int end = (i + size < length) ? i + size : length;
      chunks.add(sublist(i, end));
    }
    return chunks;
  }

  /// 去重
  List<T> unique() {
    return toSet().toList();
  }

  /// 根据条件去重
  List<T> uniqueBy<E>(E Function(T element) by) {
    final seen = <E>{};
    return where((element) => seen.add(by(element))).toList();
  }

  /// 根据条件分组
  Map<K, List<T>> groupBy<K>(K Function(T element) keySelector) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keySelector(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }

  /// 求和（数字列表）
  num sum() {
    if (isEmpty) return 0;
    return fold(0, (prev, element) => prev + (element as num));
  }

  /// 求平均值（数字列表）
  double average() {
    if (isEmpty) return 0;
    return sum() / length;
  }

  /// 最大值（数字列表）
  T? max() {
    if (isEmpty) return null;
    return reduce((curr, next) =>
        (curr as Comparable).compareTo(next as Comparable) > 0 ? curr : next);
  }

  /// 最小值（数字列表）
  T? min() {
    if (isEmpty) return null;
    return reduce((curr, next) =>
        (curr as Comparable).compareTo(next as Comparable) < 0 ? curr : next);
  }

  /// 根据条件查找第一个元素
  T? firstWhereOrNull(bool Function(T element) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }

  /// 根据条件查找最后一个元素
  T? lastWhereOrNull(bool Function(T element) test) {
    try {
      return lastWhere(test);
    } catch (e) {
      return null;
    }
  }

  /// 交换两个元素的位置
  void swap(int index1, int index2) {
    if (index1 >= 0 && index1 < length && index2 >= 0 && index2 < length) {
      final temp = this[index1];
      this[index1] = this[index2];
      this[index2] = temp;
    }
  }

  /// 移动元素
  void move(int from, int to) {
    if (from >= 0 && from < length && to >= 0 && to < length) {
      final element = removeAt(from);
      insert(to, element);
    }
  }

  /// 随机打乱
  void shuffle() {
    for (int i = length - 1; i > 0; i--) {
      final j = DateTime.now().millisecondsSinceEpoch % (i + 1);
      swap(i, j);
    }
  }

  /// 分割为两个列表
  (List<T>, List<T>) partition(bool Function(T element) test) {
    final matches = <T>[];
    final nonMatches = <T>[];
    for (final element in this) {
      if (test(element)) {
        matches.add(element);
      } else {
        nonMatches.add(element);
      }
    }
    return (matches, nonMatches);
  }
}

/// Map 扩展方法
extension MapExtensions<K, V> on Map<K, V> {
  /// 是否不为空
  bool get isNotNullOrEmpty => isNotEmpty;

  /// 反转键值
  Map<V, K> get reverse {
    return map((key, value) => MapEntry(value, key));
  }

  /// 根据值获取键
  K? keyForValue(V value) {
    for (final entry in entries) {
      if (entry.value == value) return entry.key;
    }
    return null;
  }

  /// 安全获取值
  V? getOrNull(K key) {
    return containsKey(key) ? this[key] : null;
  }

  /// 安全获取值（带默认值）
  V getOrDefault(K key, V defaultValue) {
    return getOrNull(key) ?? defaultValue;
  }

  /// 筛选
  Map<K, V> whereKey(bool Function(K key) test) {
    return Map.fromEntries(entries.where((entry) => test(entry.key)));
  }

  /// 根据值筛选
  Map<K, V> whereValue(bool Function(V value) test) {
    return Map.fromEntries(entries.where((entry) => test(entry.value)));
  }

  /// 映射键
  Map<K2, V> mapKeys<K2>(K2 Function(K key, V value) transform) {
    return Map.fromEntries(
        entries.map((e) => MapEntry(transform(e.key, e.value), e.value)));
  }

  /// 映射值
  Map<K, V2> mapValues<V2>(V2 Function(K key, V value) transform) {
    return Map.fromEntries(
        entries.map((e) => MapEntry(e.key, transform(e.key, e.value))));
  }
}

/// Set 扩展方法
extension SetExtensions<T> on Set<T> {
  /// 是否不为空
  bool get isNotNullOrEmpty => isNotEmpty;

  /// 安全获取第一个元素
  T? get firstOrNull => isEmpty ? null : first;

  /// 安全获取最后一个元素
  T? get lastOrNull => isEmpty ? null : last;

  /// 转换为 List
  List<T> toList() => List<T>.from(this);
}

/// Iterable 扩展方法
extension IterableExtensions<T> on Iterable<T> {
  /// 使用分隔符连接
  String joinWith(String separator, String Function(T element) toString) {
    return map(toString).join(separator);
  }

  /// 在元素之间插入分隔符
  Iterable<T> intersperse(T separator) sync* {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      yield iterator.current;
      while (iterator.moveNext()) {
        yield separator;
        yield iterator.current;
      }
    }
  }

  /// 在元素之间插入 Widget
  List<Widget> separatedBy(Widget separator) {
    final list = <Widget>[];
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      list.add(iterator.current as Widget);
      while (iterator.moveNext()) {
        list.add(separator);
        list.add(iterator.current as Widget);
      }
    }
    return list;
  }

  /// 统计满足条件的元素个数
  int countWhere(bool Function(T element) test) {
    return where(test).length;
  }

  /// 所有元素都满足条件
  bool every(bool Function(T element) test) {
    for (final element in this) {
      if (!test(element)) return false;
    }
    return true;
  }

  /// 至少有一个元素满足条件
  bool any(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return true;
    }
    return false;
  }

  /// 没有元素满足条件
  bool none(bool Function(T element) test) {
    return !any(test);
  }
}

