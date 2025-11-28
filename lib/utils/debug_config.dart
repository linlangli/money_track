/// 调试配置
class DebugConfig {
  /// 是否使用假数据进行调试
  static const bool useMockData = true;

  /// 是否显示调试日志
  static const bool showDebugLogs = true;

  /// 是否显示性能监控
  static const bool showPerformance = false;

  /// 调试用假数据配置
  static const mockDataDays = 60; // 生成多少天的假数据
  static const mockDailyRecordsMin = 1; // 每天最少记录数
  static const mockDailyRecordsMax = 4; // 每天最多记录数

  /// 打印调试日志
  static void log(String message) {
    if (showDebugLogs) {
      print('🐛 [DEBUG] $message');
    }
  }

  /// 打印信息日志
  static void info(String message) {
    if (showDebugLogs) {
      print('ℹ️  [INFO] $message');
    }
  }

  /// 打印成功日志
  static void success(String message) {
    if (showDebugLogs) {
      print('✅ [SUCCESS] $message');
    }
  }

  /// 打印警告日志
  static void warn(String message) {
    if (showDebugLogs) {
      print('⚠️  [WARN] $message');
    }
  }

  /// 打印错误日志
  static void error(String message) {
    print('❌ [ERROR] $message');
  }
}

