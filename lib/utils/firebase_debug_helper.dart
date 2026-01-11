import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Firebase 调试辅助类
/// 用于检查和打印 Firebase 配置和连接状态
class FirebaseDebugHelper {
  /// 打印 Firebase 配置信息
  static void printFirebaseConfig() {
    try {
      final app = Firebase.app();
      debugPrint('📋 [Firebase配置] Firebase 应用信息:');
      debugPrint('   - 应用名称: ${app.name}');
      debugPrint('   - 配置选项: ${app.options}');

      // 打印项目 ID
      debugPrint('   - Project ID: ${app.options.projectId}');

      // 打印 API Key
      debugPrint('   - API Key: ${_maskString(app.options.apiKey)}');

      // 打印 App ID
      debugPrint('   - App ID: ${app.options.appId}');

      // 打印 Messaging Sender ID
      debugPrint('   - Messaging Sender ID: ${app.options.messagingSenderId}');

      // 打印存储桶
      if (app.options.storageBucket != null) {
        debugPrint('   - Storage Bucket: ${app.options.storageBucket}');
      }

    } catch (e) {
      debugPrint('❌ [Firebase配置] 获取配置信息失败: $e');
    }
  }

  /// 检查 Firestore 连接状态
  static Future<void> checkFirestoreConnection() async {
    try {
      debugPrint('🔍 [Firestore] 检查 Firestore 连接...');

      final firestore = FirebaseFirestore.instance;

      // 获取 Firestore 设置
      final settings = firestore.settings;
      debugPrint('💾 [Firestore] 设置:');
      debugPrint('   - 持久化: ${settings.persistenceEnabled}');
      debugPrint('   - 缓存大小: ${settings.cacheSizeBytes == Settings.CACHE_SIZE_UNLIMITED ? "无限制" : "${settings.cacheSizeBytes} bytes"}');

      // 尝试写入测试数据（添加超时）
      debugPrint('📝 [Firestore] 尝试写入测试数据...');
      debugPrint('⏱️ [Firestore] 设置超时时间: 10秒');
      final testRef = firestore.collection('_debug_test').doc('connection_test');

      try {
        await testRef.set({
          'timestamp': FieldValue.serverTimestamp(),
          'test': true,
          'platform': defaultTargetPlatform.name,
        }).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            debugPrint('⏰ [Firestore] 写入操作超时！');
            throw TimeoutException('Firestore 写入操作超时（10秒）');
          },
        );

        debugPrint('✅ [Firestore] 写入测试数据成功');
      } catch (writeError) {
        debugPrint('❌ [Firestore] 写入失败: $writeError');

        // 分析写入错误
        if (writeError is TimeoutException) {
          debugPrint('💡 [Firestore] 写入超时原因分析:');
          debugPrint('   1. 网络连接不稳定或速度慢');
          debugPrint('   2. Firestore 规则可能限制了访问');
          debugPrint('   3. Firebase 项目配置可能有问题');
          debugPrint('');
          debugPrint('🔧 [Firestore] 建议解决方案:');
          debugPrint('   1. 检查网络连接');
          debugPrint('   2. 在 Firebase Console 中检查 Firestore 规则');
          debugPrint('   3. 确认项目 ID 和配置正确');
        }

        rethrow;
      }

      // 读取测试数据（添加超时）
      debugPrint('📖 [Firestore] 尝试读取测试数据...');
      debugPrint('⏱️ [Firestore] 设置超时时间: 10秒');

      try {
        final snapshot = await testRef.get(
          const GetOptions(source: Source.server),
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            debugPrint('⏰ [Firestore] 读取操作超时！');
            throw TimeoutException('Firestore 读取操作超时（10秒）');
          },
        );

        if (snapshot.exists) {
          debugPrint('✅ [Firestore] 读取测试数据成功');
          debugPrint('   - 数据: ${snapshot.data()}');
          debugPrint('   - 元数据: 来自服务器=${!snapshot.metadata.isFromCache}');
        } else {
          debugPrint('⚠️ [Firestore] 测试数据不存在');
        }
      } catch (readError) {
        debugPrint('❌ [Firestore] 读取失败: $readError');

        if (readError is TimeoutException) {
          debugPrint('💡 [Firestore] 读取超时，但写入可能已成功');
        }
      }

      // 删除测试数据
      try {
        await testRef.delete().timeout(const Duration(seconds: 5));
        debugPrint('🗑️ [Firestore] 清理测试数据完成');
      } catch (deleteError) {
        debugPrint('⚠️ [Firestore] 清理测试数据失败（可忽略）: $deleteError');
      }

      debugPrint('✅ [Firestore] Firestore 连接测试完成');

    } catch (e, stackTrace) {
      debugPrint('❌ [Firestore] Firestore 连接检查失败: $e');
      debugPrint('❌ [Firestore] 错误类型: ${e.runtimeType}');
      debugPrint('❌ [Firestore] 堆栈跟踪: $stackTrace');

      // 分析错误类型
      if (e.toString().contains('permission-denied') || e.toString().contains('PERMISSION_DENIED')) {
        debugPrint('');
        debugPrint('🔒 [Firestore] 权限被拒绝！');
        debugPrint('💡 [Firestore] 解决方案:');
        debugPrint('   1. 打开 Firebase Console: https://console.firebase.google.com');
        debugPrint('   2. 选择项目: moneytrack-90239');
        debugPrint('   3. 进入 Firestore Database');
        debugPrint('   4. 点击 "规则" 标签');
        debugPrint('   5. 修改规则为测试模式:');
        debugPrint('      rules_version = \'2\';');
        debugPrint('      service cloud.firestore {');
        debugPrint('        match /databases/{database}/documents {');
        debugPrint('          match /{document=**} {');
        debugPrint('            allow read, write: if true;');
        debugPrint('          }');
        debugPrint('        }');
        debugPrint('      }');
        debugPrint('   6. 发布规则');
        debugPrint('');
      } else if (e.toString().contains('unavailable') || e.toString().contains('UNAVAILABLE')) {
        debugPrint('');
        debugPrint('🌐 [Firestore] 网络不可用！');
        debugPrint('💡 [Firestore] 解决方案:');
        debugPrint('   1. 检查设备网络连接');
        debugPrint('   2. 检查防火墙设置');
        debugPrint('   3. 尝试使用 VPN');
        debugPrint('   4. 确认可以访问 firestore.googleapis.com');
        debugPrint('');
      } else if (e.toString().contains('not-found') || e.toString().contains('NOT_FOUND')) {
        debugPrint('');
        debugPrint('🔍 [Firestore] 项目未找到！');
        debugPrint('💡 [Firestore] 解决方案:');
        debugPrint('   1. 确认 Firebase 项目 ID: moneytrack-90239');
        debugPrint('   2. 确认已在 Firebase Console 中启用 Firestore');
        debugPrint('   3. 检查 firebase_options.dart 配置是否正确');
        debugPrint('');
      } else if (e is TimeoutException) {
        debugPrint('');
        debugPrint('⏰ [Firestore] 连接超时！');
        debugPrint('💡 [Firestore] 这通常意味着:');
        debugPrint('   1. 网络速度慢或不稳定');
        debugPrint('   2. Firestore 规则可能阻止了操作（静默拒绝）');
        debugPrint('   3. Firebase 项目可能未正确配置');
        debugPrint('');
        debugPrint('🔧 [Firestore] 建议:');
        debugPrint('   1. 检查 Firestore 规则（最常见原因）');
        debugPrint('   2. 尝试使用不同的网络');
        debugPrint('   3. 确认 Firestore 数据库已创建');
        debugPrint('');
      }
    }
  }

  /// 检查 Auth 状态
  static void checkAuthState() {
    try {
      debugPrint('🔐 [Auth] 检查认证状态...');

      final auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;

      if (currentUser == null) {
        debugPrint('👤 [Auth] 当前无用户登录');
        debugPrint('💡 [Auth] 提示: 可以尝试匿名登录或邮箱登录');
      } else {
        debugPrint('👤 [Auth] 当前用户信息:');
        debugPrint('   - UID: ${currentUser.uid}');
        debugPrint('   - Email: ${currentUser.email ?? "未设置"}');
        debugPrint('   - 显示名称: ${currentUser.displayName ?? "未设置"}');
        debugPrint('   - 邮箱验证: ${currentUser.emailVerified ? "已验证" : "未验证"}');
        debugPrint('   - 匿名用户: ${currentUser.isAnonymous ? "是" : "否"}');
        debugPrint('   - 创建时间: ${currentUser.metadata.creationTime}');
        debugPrint('   - 最后登录: ${currentUser.metadata.lastSignInTime}');
      }

    } catch (e) {
      debugPrint('❌ [Auth] 检查认证状态失败: $e');
    }
  }

  /// 测试匿名登录
  static Future<void> testAnonymousSignIn() async {
    try {
      debugPrint('🧪 [Auth] 测试匿名登录...');

      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      final user = userCredential.user;

      if (user != null) {
        debugPrint('✅ [Auth] 匿名登录成功');
        debugPrint('   - UID: ${user.uid}');
        debugPrint('   - 匿名用户: ${user.isAnonymous}');
      } else {
        debugPrint('❌ [Auth] 匿名登录失败: 用户为空');
      }

    } catch (e, stackTrace) {
      debugPrint('❌ [Auth] 匿名登录失败: $e');
      debugPrint('❌ [Auth] 错误类型: ${e.runtimeType}');
      debugPrint('❌ [Auth] 堆栈跟踪: $stackTrace');

      // 分析错误类型并提供解决方案
      final errorString = e.toString();

      if (errorString.contains('operation-not-allowed') ||
          errorString.contains('OPERATION_NOT_ALLOWED')) {
        debugPrint('');
        debugPrint('🔒 [Auth] 匿名登录未启用！');
        debugPrint('💡 [Auth] 解决方案:');
        debugPrint('   1. 打开 Firebase Console:');
        debugPrint('      https://console.firebase.google.com/project/moneytrack-90239/authentication/providers');
        debugPrint('   2. 点击 "Authentication" → "Sign-in method"');
        debugPrint('   3. 在 "匿名" 一栏中点击启用');
        debugPrint('   4. 保存设置');
        debugPrint('   5. 重新运行应用');
        debugPrint('');
      } else if (errorString.contains('internal-error') ||
                 errorString.contains('INTERNAL_ERROR')) {
        debugPrint('');
        debugPrint('⚠️ [Auth] Firebase 内部错误');
        debugPrint('💡 [Auth] 可能原因:');
        debugPrint('   1. 匿名登录功能未启用（最常见）');
        debugPrint('   2. Firebase 项目配置不正确');
        debugPrint('   3. 网络连接问题');
        debugPrint('   4. Firebase Auth 服务暂时不可用');
        debugPrint('');
        debugPrint('🔧 [Auth] 解决步骤:');
        debugPrint('   步骤 1: 检查并启用匿名登录');
        debugPrint('   ----------------------------------------');
        debugPrint('   访问: https://console.firebase.google.com/project/moneytrack-90239/authentication/providers');
        debugPrint('   在 "Sign-in method" 标签中启用 "匿名" 登录方式');
        debugPrint('');
        debugPrint('   步骤 2: 检查 Firebase 配置');
        debugPrint('   ----------------------------------------');
        debugPrint('   确认 firebase_options.dart 中的配置正确');
        debugPrint('   项目 ID: moneytrack-90239');
        debugPrint('');
        debugPrint('   步骤 3: 检查网络连接');
        debugPrint('   ----------------------------------------');
        debugPrint('   确认设备可以访问 Firebase 服务');
        debugPrint('');
      } else if (errorString.contains('network-request-failed') ||
                 errorString.contains('NETWORK_REQUEST_FAILED')) {
        debugPrint('');
        debugPrint('🌐 [Auth] 网络请求失败');
        debugPrint('💡 [Auth] 解决方案:');
        debugPrint('   1. 检查设备网络连接');
        debugPrint('   2. 确认可以访问 Firebase 服务');
        debugPrint('   3. 检查防火墙设置');
        debugPrint('');
      } else {
        debugPrint('');
        debugPrint('❓ [Auth] 未知错误');
        debugPrint('💡 [Auth] 建议:');
        debugPrint('   1. 检查 Firebase Console 中的 Authentication 设置');
        debugPrint('   2. 确认项目配置正确');
        debugPrint('   3. 查看完整错误信息并搜索解决方案');
        debugPrint('');
      }
    }
  }

  /// 打印所有 Firebase 诊断信息
  static Future<void> printFullDiagnostics() async {
    debugPrint('');
    debugPrint('═══════════════════════════════════════════════════════');
    debugPrint('🔥 Firebase 完整诊断开始');
    debugPrint('═══════════════════════════════════════════════════════');
    debugPrint('');

    printFirebaseConfig();
    debugPrint('');

    await checkFirestoreConnection();
    debugPrint('');

    checkAuthState();
    debugPrint('');

    debugPrint('═══════════════════════════════════════════════════════');
    debugPrint('🔥 Firebase 完整诊断结束');
    debugPrint('═══════════════════════════════════════════════════════');
    debugPrint('');
  }

  /// 测试 Firestore 写入用户数据
  static Future<void> testUserDataWrite(String userId) async {
    try {
      debugPrint('🧪 [Firestore] 测试用户数据写入...');
      debugPrint('   - 用户ID: $userId');

      final firestore = FirebaseFirestore.instance;
      final userDoc = firestore.collection('users').doc(userId);

      await userDoc.set({
        'lastActive': FieldValue.serverTimestamp(),
        'testWrite': true,
      }, SetOptions(merge: true));

      debugPrint('✅ [Firestore] 用户数据写入成功');

      // 尝试读取
      final snapshot = await userDoc.get();
      if (snapshot.exists) {
        debugPrint('✅ [Firestore] 用户数据读取成功');
        debugPrint('   - 数据: ${snapshot.data()}');
      }

    } catch (e, stackTrace) {
      debugPrint('❌ [Firestore] 用户数据写入失败: $e');
      debugPrint('❌ [Firestore] 堆栈跟踪: $stackTrace');
    }
  }

  /// 掩码敏感字符串（保留前后各3个字符）
  static String _maskString(String? str) {
    if (str == null || str.length <= 8) {
      return '***';
    }
    return '${str.substring(0, 3)}...${str.substring(str.length - 3)}';
  }

  /// 检查 Firestore 数据库是否已创建
  static Future<void> checkFirestoreExists() async {
    try {
      debugPrint('🔍 [Firestore] 检查数据库是否存在...');

      final firestore = FirebaseFirestore.instance;

      // 尝试列出集合（这个操作需要 Admin SDK，客户端无法执行）
      // 所以我们只能通过尝试写入来判断
      debugPrint('💡 [Firestore] 提示: 客户端无法直接检查数据库是否存在');
      debugPrint('💡 [Firestore] 将通过写入操作间接判断');
      debugPrint('');
      debugPrint('🔗 [Firestore] 请访问 Firebase Console:');
      debugPrint('   https://console.firebase.google.com/project/moneytrack-90239/firestore');
      debugPrint('');
      debugPrint('✅ [Firestore] 确认以下事项:');
      debugPrint('   1. Firestore 数据库已创建');
      debugPrint('   2. 选择了正确的数据库模式（生产模式或测试模式）');
      debugPrint('   3. 设置了正确的安全规则');
      debugPrint('');

    } catch (e) {
      debugPrint('❌ [Firestore] 检查失败: $e');
    }
  }

  /// 打印当前网络状态建议
  static void printNetworkDiagnostics() {
    debugPrint('');
    debugPrint('🌐 [网络诊断] 网络连接建议:');
    debugPrint('');
    debugPrint('📱 模拟器网络检查:');
    debugPrint('   - iOS 模拟器: 使用 Mac 的网络连接');
    debugPrint('   - 确认 Mac 可以访问 firestore.googleapis.com');
    debugPrint('');
    debugPrint('🔧 测试命令:');
    debugPrint('   ping firestore.googleapis.com');
    debugPrint('   curl https://firestore.googleapis.com');
    debugPrint('');
  }
}

