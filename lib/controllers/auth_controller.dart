import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/services/auth_service.dart';

/// 认证控制器
/// 管理用户认证状态和相关操作
class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // 当前用户
  final Rx<User?> _user = Rx<User?>(null);
  User? get user => _user.value;

  // 是否已登录
  bool get isLoggedIn => _user.value != null;

  // 当前用户ID
  String? get userId => _user.value?.uid;

  // 当前用户邮箱
  String? get userEmail => _user.value?.email;

  // 当前用户显示名称
  String? get displayName => _user.value?.displayName;

  // 是否正在加载
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 监听认证状态变化
    _user.bindStream(_authService.authStateChanges);
  }

  // ==================== 注册 ====================

  /// 使用邮箱和密码注册
  Future<bool> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      isLoading.value = true;

      await _authService.registerWithEmailPassword(
        email: email,
        password: password,
        displayName: displayName,
      );

      Get.snackbar(
        '注册成功',
        '欢迎加入！已发送验证邮件到您的邮箱',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        '注册失败',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== 登录 ====================

  /// 使用邮箱和密码登录
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      await _authService.signInWithEmailPassword(
        email: email,
        password: password,
      );

      Get.snackbar(
        '登录成功',
        '欢迎回来！',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        '登录失败',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== 登出 ====================

  /// 登出
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _authService.signOut();

      Get.snackbar(
        '已登出',
        '期待您的再次光临',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        '登出失败',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== 密码管理 ====================

  /// 发送密码重置邮件
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      isLoading.value = true;

      await _authService.sendPasswordResetEmail(email);

      Get.snackbar(
        '发送成功',
        '密码重置邮件已发送，请查收',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        '发送失败',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// 更新密码
  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      isLoading.value = true;

      await _authService.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      Get.snackbar(
        '更新成功',
        '密码已更新',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        '更新失败',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== 用户资料 ====================

  /// 更新显示名称
  Future<bool> updateDisplayName(String displayName) async {
    try {
      isLoading.value = true;

      await _authService.updateDisplayName(displayName);

      Get.snackbar(
        '更新成功',
        '显示名称已更新',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        '更新失败',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// 获取用户资料
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      return await _authService.getUserProfile();
    } catch (e) {
      Get.snackbar(
        '获取失败',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  /// 更新用户资料
  Future<bool> updateUserProfile(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;

      await _authService.updateUserProfile(data);

      Get.snackbar(
        '更新成功',
        '资料已更新',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        '更新失败',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== 邮箱验证 ====================

  /// 发送邮箱验证邮件
  Future<bool> sendEmailVerification() async {
    try {
      await _authService.sendEmailVerification();

      Get.snackbar(
        '发送成功',
        '验证邮件已发送',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        '发送失败',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  /// 检查邮箱是否已验证
  Future<bool> isEmailVerified() async {
    return await _authService.isEmailVerified();
  }

  // ==================== 账户删除 ====================

  /// 删除账户
  Future<bool> deleteAccount(String password) async {
    try {
      isLoading.value = true;

      await _authService.deleteAccount(password);

      Get.snackbar(
        '删除成功',
        '账户已删除',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        '删除失败',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}

