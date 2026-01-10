import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/firebase_debug_helper.dart';
import '../controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Firebase 测试和调试页面
class FirebaseTestPage extends StatefulWidget {
  const FirebaseTestPage({super.key});

  @override
  State<FirebaseTestPage> createState() => _FirebaseTestPageState();
}

class _FirebaseTestPageState extends State<FirebaseTestPage> {
  final AuthController _authController = Get.find<AuthController>();
  String _testResult = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 启动时自动运行诊断
    _runFullDiagnostics();
  }

  /// 运行完整诊断
  Future<void> _runFullDiagnostics() async {
    setState(() {
      _isLoading = true;
      _testResult = '正在运行 Firebase 诊断...\n';
    });

    await FirebaseDebugHelper.printFullDiagnostics();

    setState(() {
      _isLoading = false;
      _testResult += '\n✅ 诊断完成！请查看控制台日志。';
    });
  }

  /// 测试匿名登录
  Future<void> _testAnonymousSignIn() async {
    setState(() {
      _isLoading = true;
      _testResult = '正在测试匿名登录...\n';
    });

    try {
      await FirebaseDebugHelper.testAnonymousSignIn();
      setState(() {
        _testResult += '✅ 匿名登录测试完成！请查看控制台日志。\n';
      });
    } catch (e) {
      setState(() {
        _testResult += '❌ 匿名登录失败: $e\n';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 测试 Firestore 连接
  Future<void> _testFirestoreConnection() async {
    setState(() {
      _isLoading = true;
      _testResult = '正在测试 Firestore 连接...\n';
    });

    try {
      await FirebaseDebugHelper.checkFirestoreConnection();
      setState(() {
        _testResult += '✅ Firestore 连接测试完成！请查看控制台日志。\n';
      });
    } catch (e) {
      setState(() {
        _testResult += '❌ Firestore 连接失败: $e\n';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 打印当前用户信息
  void _printCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    String result = '当前用户信息:\n';

    if (user == null) {
      result += '❌ 未登录\n';
    } else {
      result += '✅ 已登录\n';
      result += '  - UID: ${user.uid}\n';
      result += '  - Email: ${user.email ?? "未设置"}\n';
      result += '  - 显示名称: ${user.displayName ?? "未设置"}\n';
      result += '  - 邮箱验证: ${user.emailVerified ? "已验证" : "未验证"}\n';
      result += '  - 匿名用户: ${user.isAnonymous ? "是" : "否"}\n';
    }

    setState(() {
      _testResult = result;
    });

    FirebaseDebugHelper.checkAuthState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase 调试'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 当前用户状态卡片
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '当前用户状态',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => Text(
                          _authController.isLoggedIn
                              ? '✅ 已登录\nUID: ${_authController.userId}\nEmail: ${_authController.userEmail}'
                              : '❌ 未登录',
                          style: const TextStyle(fontSize: 14),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 测试按钮
            const Text(
              '测试功能',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: _isLoading ? null : _runFullDiagnostics,
              icon: const Icon(Icons.bug_report),
              label: const Text('运行完整诊断'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testFirestoreConnection,
              icon: const Icon(Icons.cloud),
              label: const Text('测试 Firestore 连接'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testAnonymousSignIn,
              icon: const Icon(Icons.person_outline),
              label: const Text('测试匿名登录'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: _isLoading ? null : _printCurrentUser,
              icon: const Icon(Icons.person),
              label: const Text('打印当前用户信息'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),

            // 测试结果显示
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),

            if (_testResult.isNotEmpty)
              Card(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '测试结果',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _testResult,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // 提示信息
            Card(
              color: Colors.blue[50],
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 提示',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• 所有测试日志都会输出到控制台\n'
                      '• 使用 "flutter logs" 或 IDE 控制台查看详细日志\n'
                      '• 检查 Firebase Console 确认项目配置\n'
                      '• 确保网络连接正常',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

