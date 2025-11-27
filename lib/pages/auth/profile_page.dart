import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_track/core/constants/app_colors.dart';
import '../../controllers/auth_controller.dart';
import 'change_password_page.dart';

/// 用户资料页面
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('个人资料'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        final user = _authController.user;
        if (user == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_off,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text('未登录'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('返回'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // 用户头像和基本信息
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 头像
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: user.photoURL != null && user.photoURL!.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                user.photoURL!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person,
                                    size: 50,
                                    color: AppColors.primary,
                                  );
                                },
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 50,
                              color: AppColors.primary,
                            ),
                    ),
                    const SizedBox(height: 16),
                    // 用户名
                    Text(
                      user.displayName ?? '未设置用户名',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 邮箱
                    Text(
                      user.email ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 邮箱验证状态
                    if (!user.emailVerified)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.warning_amber,
                              size: 16,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '邮箱未验证',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () async {
                                await _authController.sendEmailVerification();
                              },
                              child: const Text(
                                '发送验证邮件',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 功能列表
              Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.edit,
                      title: '编辑资料',
                      onTap: () {
                        _showEditProfileDialog();
                      },
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.lock_outline,
                      title: '修改密码',
                      onTap: () {
                        Get.to(() => const ChangePasswordPage());
                      },
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      title: '关于',
                      onTap: () {
                        _showAboutDialog();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 登出按钮
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final confirm = await Get.dialog<bool>(
                      AlertDialog(
                        title: const Text('确认登出'),
                        content: const Text('确定要登出吗？'),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(result: false),
                            child: const Text('取消'),
                          ),
                          TextButton(
                            onPressed: () => Get.back(result: true),
                            child: const Text('确定'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await _authController.signOut();
                      if (mounted) {
                        Get.back();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '登出',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: AppColors.catering,
      indent: 56,
    );
  }

  void _showEditProfileDialog() {
    final displayNameController = TextEditingController(
      text: _authController.displayName,
    );

    Get.dialog(
      AlertDialog(
        title: const Text('编辑资料'),
        content: TextField(
          controller: displayNameController,
          decoration: const InputDecoration(
            labelText: '用户名',
            hintText: '请输入用户名',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              final newName = displayNameController.text.trim();
              if (newName.isNotEmpty) {
                await _authController.updateDisplayName(newName);
                Get.back();
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('关于'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('记账助手'),
            SizedBox(height: 8),
            Text('版本: 1.0.0'),
            SizedBox(height: 8),
            Text('帮助您轻松管理个人财务'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

