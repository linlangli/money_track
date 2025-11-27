import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_track/pages/auth/login_page.dart';
import '../../controllers/auth_controller.dart';

/// 认证中间件
/// 检查用户是否已登录，未登录则跳转到登录页
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    // 如果用户未登录，重定向到登录页
    if (!authController.isLoggedIn) {
      return const RouteSettings(name: '/login');
    }

    return null;
  }
}

/// 认证包装器Widget
/// 包装需要认证的页面，未登录时显示登录提示
class AuthWrapper extends StatelessWidget {
  final Widget child;
  final bool requireAuth;

  const AuthWrapper({
    super.key,
    required this.child,
    this.requireAuth = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!requireAuth) {
      return child;
    }

    final authController = Get.find<AuthController>();

    return Obx(() {
      if (authController.isLoggedIn) {
        return child;
      } else {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  '请先登录',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '您需要登录后才能使用此功能',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const LoginPage());
                  },
                  child: const Text('去登录'),
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}

