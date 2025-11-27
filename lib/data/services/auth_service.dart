import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Firebase 认证服务类
/// 处理用户注册、登录、登出等认证功能
class AuthService {
  // Firebase Auth 实例
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 用户集合名称
  static const String _usersCollection = 'users';

  // ==================== 当前用户信息 ====================

  /// 获取当前登录的用户
  User? get currentUser => _auth.currentUser;

  /// 获取当前用户ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// 获取当前用户邮箱
  String? get currentUserEmail => _auth.currentUser?.email;

  /// 检查用户是否已登录
  bool get isLoggedIn => _auth.currentUser != null;

  /// 监听用户认证状态变化
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ==================== 邮箱密码认证 ====================

  /// 使用邮箱和密码注册新用户
  /// [email] 邮箱地址
  /// [password] 密码
  /// [displayName] 可选的用户显示名称
  /// 返回用户ID
  Future<String> registerWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      // 创建用户
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) {
        throw Exception('注册失败：无法创建用户');
      }

      // 更新用户显示名称
      if (displayName != null && displayName.isNotEmpty) {
        await user.updateDisplayName(displayName);
        await user.reload();
      }

      // 在 Firestore 中创建用户文档
      await _createUserDocument(
        userId: user.uid,
        email: email,
        displayName: displayName,
      );

      // 发送邮箱验证
      await sendEmailVerification();

      return user.uid;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('注册失败: $e');
    }
  }

  /// 使用邮箱和密码登录
  /// [email] 邮箱地址
  /// [password] 密码
  /// 返回用户ID
  Future<String> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) {
        throw Exception('登录失败：无法获取用户信息');
      }

      // 更新最后登录时间
      await _updateLastLoginTime(user.uid);

      return user.uid;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('登录失败: $e');
    }
  }

  /// 登出当前用户
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('登出失败: $e');
    }
  }

  // ==================== 邮箱验证 ====================

  /// 发送邮箱验证邮件
  Future<void> sendEmailVerification() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      throw Exception('发送验证邮件失败: $e');
    }
  }

  /// 检查邮箱是否已验证
  Future<bool> isEmailVerified() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return false;

      await user.reload();
      return _auth.currentUser?.emailVerified ?? false;
    } catch (e) {
      return false;
    }
  }

  // ==================== 密码管理 ====================

  /// 发送密码重置邮件
  /// [email] 邮箱地址
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('发送密码重置邮件失败: $e');
    }
  }

  /// 更新当前用户密码
  /// [currentPassword] 当前密码
  /// [newPassword] 新密码
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw Exception('未登录或邮箱为空');
      }

      // 重新认证用户
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // 更新密码
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('更新密码失败: $e');
    }
  }

  // ==================== 用户资料管理 ====================

  /// 更新用户显示名称
  /// [displayName] 新的显示名称
  Future<void> updateDisplayName(String displayName) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('未登录');
      }

      await user.updateDisplayName(displayName);
      await user.reload();

      // 同步到 Firestore
      await _firestore.collection(_usersCollection).doc(user.uid).update({
        'displayName': displayName,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('更新显示名称失败: $e');
    }
  }

  /// 更新用户头像URL
  /// [photoURL] 新的头像URL
  Future<void> updatePhotoURL(String photoURL) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('未登录');
      }

      await user.updatePhotoURL(photoURL);
      await user.reload();

      // 同步到 Firestore
      await _firestore.collection(_usersCollection).doc(user.uid).update({
        'photoURL': photoURL,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('更新头像失败: $e');
    }
  }

  /// 删除当前用户账户
  /// [password] 当前密码（用于重新认证）
  Future<void> deleteAccount(String password) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw Exception('未登录或邮箱为空');
      }

      // 重新认证用户
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      // 删除 Firestore 中的用户数据
      await _deleteUserData(user.uid);

      // 删除账户
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('删除账户失败: $e');
    }
  }

  // ==================== Firestore 用户数据管理 ====================

  /// 获取用户资料
  /// [userId] 用户ID，默认为当前用户
  Future<Map<String, dynamic>?> getUserProfile([String? userId]) async {
    try {
      final uid = userId ?? currentUserId;
      if (uid == null) return null;

      final doc = await _firestore.collection(_usersCollection).doc(uid).get();
      return doc.data();
    } catch (e) {
      throw Exception('获取用户资料失败: $e');
    }
  }

  /// 更新用户资料
  /// [data] 要更新的数据
  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final uid = currentUserId;
      if (uid == null) {
        throw Exception('未登录');
      }

      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection(_usersCollection).doc(uid).update(data);
    } catch (e) {
      throw Exception('更新用户资料失败: $e');
    }
  }

  // ==================== 私有辅助方法 ====================

  /// 在 Firestore 中创建用户文档
  Future<void> _createUserDocument({
    required String userId,
    required String email,
    String? displayName,
  }) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).set({
        'email': email,
        'displayName': displayName ?? '',
        'photoURL': '',
        'balance': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // 如果创建失败，不影响注册流程
      print('创建用户文档失败: $e');
    }
  }

  /// 更新最后登录时间
  Future<void> _updateLastLoginTime(String userId) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // 如果更新失败，不影响登录流程
      print('更新最后登录时间失败: $e');
    }
  }

  /// 删除用户数据
  Future<void> _deleteUserData(String userId) async {
    try {
      // 删除用户文档
      await _firestore.collection(_usersCollection).doc(userId).delete();

      // 删除用户的消费记录（批量删除）
      final expensesSnapshot = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .collection('expenses')
          .get();

      final batch = _firestore.batch();
      for (final doc in expensesSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      print('删除用户数据失败: $e');
    }
  }

  /// 处理 Firebase Auth 异常
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return '该邮箱已被注册';
      case 'invalid-email':
        return '邮箱格式不正确';
      case 'operation-not-allowed':
        return '操作不允许';
      case 'weak-password':
        return '密码强度太弱';
      case 'user-disabled':
        return '该账户已被禁用';
      case 'user-not-found':
        return '用户不存在';
      case 'wrong-password':
        return '密码错误';
      case 'invalid-credential':
        return '凭证无效';
      case 'account-exists-with-different-credential':
        return '该邮箱已使用其他方式注册';
      case 'invalid-verification-code':
        return '验证码无效';
      case 'invalid-verification-id':
        return '验证ID无效';
      case 'too-many-requests':
        return '请求过于频繁，请稍后再试';
      case 'network-request-failed':
        return '网络连接失败';
      default:
        return '认证失败: ${e.message ?? e.code}';
    }
  }
}

