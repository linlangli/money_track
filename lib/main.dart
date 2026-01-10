import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'pages/home_page.dart';
import 'firebase_options.dart';
import 'controllers/auth_controller.dart';
import 'utils/firebase_debug_helper.dart';
import 'utils/analytics_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化日期格式化
  debugPrint('📅 [初始化] 开始初始化日期格式化...');
  await initializeDateFormatting('zh_CN', null);
  debugPrint('✅ [初始化] 日期格式化初始化完成');

  // 初始化 Firebase
  try {
    debugPrint('🔥 [Firebase] 开始初始化 Firebase...');
    debugPrint('🔥 [Firebase] 当前平台: ${defaultTargetPlatform.name}');

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    debugPrint('✅ [Firebase] Firebase 初始化成功');

    // 初始化 Firebase Analytics
    debugPrint('📊 [Analytics] 初始化 Firebase Analytics...');
    await AnalyticsHelper.initialize();

    // 发送应用启动事件
    await AnalyticsHelper.logAppStart();
    debugPrint('✅ [Analytics] Analytics 初始化完成并发送 app_start 事件');

    // 打印 Firebase 配置信息
    FirebaseDebugHelper.printFirebaseConfig();

    // 配置 Firestore 离线持久化
    debugPrint('💾 [Firestore] 配置离线持久化...');
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    debugPrint('✅ [Firestore] Firestore 配置完成');

    // 检查 Firestore 数据库是否存在
    await FirebaseDebugHelper.checkFirestoreExists();

    // 打印网络诊断信息
    FirebaseDebugHelper.printNetworkDiagnostics();

    // 检查 Firestore 连接状态
    debugPrint('');
    debugPrint('═══════════════════════════════════════════════════════');
    debugPrint('🔥 开始 Firestore 连接测试');
    debugPrint('═══════════════════════════════════════════════════════');
    await FirebaseDebugHelper.checkFirestoreConnection();
    debugPrint('═══════════════════════════════════════════════════════');
    debugPrint('🔥 Firestore 连接测试结束');
    debugPrint('═══════════════════════════════════════════════════════');
    debugPrint('');

    // 检查 Auth 状态
    FirebaseDebugHelper.checkAuthState();

    // 监听 Auth 状态变化
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint('👤 [Auth] 用户未登录');
      } else {
        debugPrint('👤 [Auth] 用户已登录:');
        debugPrint('   - UID: ${user.uid}');
        debugPrint('   - Email: ${user.email ?? "未设置"}');
        debugPrint('   - 邮箱验证: ${user.emailVerified ? "已验证" : "未验证"}');
        debugPrint('   - 显示名称: ${user.displayName ?? "未设置"}');
      }
    });

  } catch (e, stackTrace) {
    debugPrint('❌ [Firebase] Firebase 初始化失败: $e');
    debugPrint('❌ [Firebase] 堆栈跟踪: $stackTrace');
  }

  // 初始化 AuthController
  debugPrint('🎮 [控制器] 初始化 AuthController...');
  Get.put(AuthController());
  debugPrint('✅ [控制器] AuthController 初始化完成');

  debugPrint('🚀 [启动] 启动应用...');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      locale: const Locale('zh', 'CN'),
      // 添加 Analytics 导航观察器，自动追踪页面浏览
      navigatorObservers: [
        AnalyticsHelper.observer,
      ],
    );
  }
}
