import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Firebase Analytics 埋点工具类
/// 统一管理所有埋点事件
class AnalyticsHelper {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// 初始化 Analytics
  static Future<void> initialize() async {
    try {
      // 启用 Analytics 数据收集
      await _analytics.setAnalyticsCollectionEnabled(true);
      debugPrint('✅ [Analytics] Firebase Analytics 已启用');

      // 设置默认事件参数（所有事件都会带上）
      await _analytics.setDefaultEventParameters({
        'app_version': '1.0.0',
        'platform': defaultTargetPlatform.name,
      });

      debugPrint('✅ [Analytics] 默认参数已设置');
    } catch (e) {
      debugPrint('❌ [Analytics] 初始化失败: $e');
    }
  }

  /// ========== 应用生命周期事件 ==========

  /// 应用启动
  static Future<void> logAppStart() async {
    try {
      await _analytics.logEvent(
        name: 'app_start',
        parameters: {
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      debugPrint('📊 [Analytics] 事件: app_start');
    } catch (e) {
      debugPrint('❌ [Analytics] logAppStart 失败: $e');
    }
  }

  /// 应用打开（每次从后台恢复）
  static Future<void> logAppOpen() async {
    try {
      await _analytics.logAppOpen();
      debugPrint('📊 [Analytics] 事件: app_open');
    } catch (e) {
      debugPrint('❌ [Analytics] logAppOpen 失败: $e');
    }
  }

  /// ========== 页面浏览事件 ==========

  /// 记录页面浏览
  static Future<void> logScreenView(String screenName, {String? screenClass}) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
      debugPrint('📊 [Analytics] 页面浏览: $screenName');
    } catch (e) {
      debugPrint('❌ [Analytics] logScreenView 失败: $e');
    }
  }

  /// ========== 消费记录事件 ==========

  /// 添加消费记录
  static Future<void> logAddExpense({
    required double amount,
    required String category,
    required bool hasNote,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'add_expense',
        parameters: {
          'amount': amount,
          'category': category,
          'has_note': hasNote,
          'value': amount, // 用于价值分析
          'currency': 'CNY',
        },
      );
      debugPrint('📊 [Analytics] 事件: add_expense - $category: ¥$amount');
    } catch (e) {
      debugPrint('❌ [Analytics] logAddExpense 失败: $e');
    }
  }

  /// 删除消费记录
  static Future<void> logDeleteExpense({
    required double amount,
    required String category,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'delete_expense',
        parameters: {
          'amount': amount,
          'category': category,
        },
      );
      debugPrint('📊 [Analytics] 事件: delete_expense - $category: ¥$amount');
    } catch (e) {
      debugPrint('❌ [Analytics] logDeleteExpense 失败: $e');
    }
  }

  /// 编辑消费记录
  static Future<void> logEditExpense({
    required double oldAmount,
    required double newAmount,
    required String category,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'edit_expense',
        parameters: {
          'old_amount': oldAmount,
          'new_amount': newAmount,
          'category': category,
          'amount_change': newAmount - oldAmount,
        },
      );
      debugPrint('📊 [Analytics] 事件: edit_expense');
    } catch (e) {
      debugPrint('❌ [Analytics] logEditExpense 失败: $e');
    }
  }

  /// ========== 筛选和查看事件 ==========

  /// 筛选消费记录
  static Future<void> logFilterExpenses({
    String? category,
    String? dateRange,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'filter_expenses',
        parameters: {
          'has_category': category != null,
          'category': category ?? 'all',
          'has_date_range': dateRange != null,
          'date_range': dateRange ?? 'all',
        },
      );
      debugPrint('📊 [Analytics] 事件: filter_expenses');
    } catch (e) {
      debugPrint('❌ [Analytics] logFilterExpenses 失败: $e');
    }
  }

  /// 查看图表
  static Future<void> logViewChart(String chartType) async {
    try {
      await _analytics.logEvent(
        name: 'view_chart',
        parameters: {
          'chart_type': chartType, // 'pie', 'line', 'bar'
        },
      );
      debugPrint('📊 [Analytics] 事件: view_chart - $chartType');
    } catch (e) {
      debugPrint('❌ [Analytics] logViewChart 失败: $e');
    }
  }

  /// 查看统计数据
  static Future<void> logViewStats({
    required String period, // 'today', 'week', 'month', 'year'
    required double totalAmount,
    required int expenseCount,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'view_stats',
        parameters: {
          'period': period,
          'total_amount': totalAmount,
          'expense_count': expenseCount,
        },
      );
      debugPrint('📊 [Analytics] 事件: view_stats - $period');
    } catch (e) {
      debugPrint('❌ [Analytics] logViewStats 失败: $e');
    }
  }

  /// ========== 用户行为事件 ==========

  /// 下拉刷新
  static Future<void> logRefresh(String screenName) async {
    try {
      await _analytics.logEvent(
        name: 'refresh',
        parameters: {
          'screen': screenName,
        },
      );
      debugPrint('📊 [Analytics] 事件: refresh - $screenName');
    } catch (e) {
      debugPrint('❌ [Analytics] logRefresh 失败: $e');
    }
  }

  /// 分享
  static Future<void> logShare({
    required String contentType,
    required String method,
  }) async {
    try {
      await _analytics.logShare(
        contentType: contentType,
        itemId: DateTime.now().millisecondsSinceEpoch.toString(),
        method: method,
      );
      debugPrint('📊 [Analytics] 事件: share - $contentType via $method');
    } catch (e) {
      debugPrint('❌ [Analytics] logShare 失败: $e');
    }
  }

  /// 搜索
  static Future<void> logSearch(String searchTerm) async {
    try {
      await _analytics.logSearch(searchTerm: searchTerm);
      debugPrint('📊 [Analytics] 事件: search - $searchTerm');
    } catch (e) {
      debugPrint('❌ [Analytics] logSearch 失败: $e');
    }
  }

  /// ========== 用户认证事件 ==========

  /// 登录
  static Future<void> logLogin(String method) async {
    try {
      await _analytics.logLogin(loginMethod: method);
      debugPrint('📊 [Analytics] 事件: login - $method');
    } catch (e) {
      debugPrint('❌ [Analytics] logLogin 失败: $e');
    }
  }

  /// 注册
  static Future<void> logSignUp(String method) async {
    try {
      await _analytics.logSignUp(signUpMethod: method);
      debugPrint('📊 [Analytics] 事件: sign_up - $method');
    } catch (e) {
      debugPrint('❌ [Analytics] logSignUp 失败: $e');
    }
  }

  /// ========== 数据同步事件 ==========

  /// 数据同步
  static Future<void> logDataSync({
    required String syncType, // 'upload', 'download', 'auto'
    required int recordCount,
    required bool success,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'data_sync',
        parameters: {
          'sync_type': syncType,
          'record_count': recordCount,
          'success': success,
        },
      );
      debugPrint('📊 [Analytics] 事件: data_sync - $syncType ($recordCount 条)');
    } catch (e) {
      debugPrint('❌ [Analytics] logDataSync 失败: $e');
    }
  }

  /// ========== 错误事件 ==========

  /// 记录错误
  static Future<void> logError({
    required String errorType,
    required String errorMessage,
    String? stackTrace,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'error_occurred',
        parameters: {
          'error_type': errorType,
          'error_message': errorMessage.substring(0, errorMessage.length > 100 ? 100 : errorMessage.length),
          'has_stack_trace': stackTrace != null,
        },
      );
      debugPrint('📊 [Analytics] 事件: error_occurred - $errorType');
    } catch (e) {
      debugPrint('❌ [Analytics] logError 失败: $e');
    }
  }

  /// ========== 用户属性 ==========

  /// 设置用户 ID
  static Future<void> setUserId(String userId) async {
    try {
      await _analytics.setUserId(id: userId);
      debugPrint('📊 [Analytics] 设置用户 ID: $userId');
    } catch (e) {
      debugPrint('❌ [Analytics] setUserId 失败: $e');
    }
  }

  /// 设置用户属性
  static Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      debugPrint('📊 [Analytics] 设置用户属性: $name = $value');
    } catch (e) {
      debugPrint('❌ [Analytics] setUserProperty 失败: $e');
    }
  }

  /// 批量设置用户属性
  static Future<void> setUserProperties(Map<String, String> properties) async {
    for (var entry in properties.entries) {
      await setUserProperty(name: entry.key, value: entry.value);
    }
  }

  /// ========== 自定义事件 ==========

  /// 通用自定义事件
  static Future<void> logCustomEvent({
    required String eventName,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: eventName,
        parameters: parameters,
      );
      debugPrint('📊 [Analytics] 自定义事件: $eventName');
    } catch (e) {
      debugPrint('❌ [Analytics] logCustomEvent 失败: $e');
    }
  }
}

