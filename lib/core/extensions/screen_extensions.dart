import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// 屏幕尺寸适配扩展
extension ScreenExtensions on BuildContext {
  /// 获取屏幕宽度
  double get screenWidth => MediaQuery.of(this).size.width;

  /// 获取屏幕高度
  double get screenHeight => MediaQuery.of(this).size.height;

  /// 获取状态栏高度
  double get statusBarHeight => MediaQuery.of(this).padding.top;

  /// 获取底部安全区域高度
  double get bottomBarHeight => MediaQuery.of(this).padding.bottom;

  /// 获取设备像素比
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;


  /// 关闭键盘
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  /// 显示 SnackBar
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
      ),
    );
  }

  /// 根据设计稿宽度适配（设计稿宽度默认 375）
  double wp(double width, {double designWidth = 375}) {
    return screenWidth * width / designWidth;
  }

  /// 根据设计稿高度适配（设计稿高度默认 812）
  double hp(double height, {double designHeight = 812}) {
    return screenHeight * height / designHeight;
  }

  /// 字体大小适配
  double sp(double fontSize, {double designWidth = 375}) {
    return screenWidth * fontSize / designWidth;
  }

  /// 是否是小屏幕（宽度小于 360）
  bool get isSmallScreen => screenWidth < 360;

  /// 是否是中等屏幕（宽度在 360 到 600 之间）
  bool get isMediumScreen => screenWidth >= 360 && screenWidth < 600;

  /// 是否是大屏幕（宽度大于等于 600）
  bool get isLargeScreen => screenWidth >= 600;

  /// 是否是平板
  bool get isTablet => screenWidth >= 600;

  /// 是否是手机
  bool get isPhone => screenWidth < 600;

  /// 是否是横屏
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  /// 是否是竖屏
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  /// 获取键盘高度
  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;

  /// 键盘是否显示
  bool get isKeyboardVisible => keyboardHeight > 0;
}

/// 数值屏幕适配扩展
extension NumExtensions on num {
  /// 宽度适配
  double get w {
    final width = ui.PlatformDispatcher.instance.views.first.physicalSize.width /
        ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
    return width * this / 375;
  }

  /// 高度适配
  double get h {
    final height =
        ui.PlatformDispatcher.instance.views.first.physicalSize.height /
            ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
    return height * this / 812;
  }

  /// 字体大小适配
  double get sp {
    final width = ui.PlatformDispatcher.instance.views.first.physicalSize.width /
        ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
    return width * this / 375;
  }

  /// 转换为 SizedBox（宽度）
  Widget get widthBox => SizedBox(width: toDouble());

  /// 转换为 SizedBox（高度）
  Widget get heightBox => SizedBox(height: toDouble());

  /// 转换为水平间距
  Widget get horizontalSpace => SizedBox(width: toDouble());

  /// 转换为垂直间距
  Widget get verticalSpace => SizedBox(height: toDouble());

  /// 转换为 EdgeInsets.all
  EdgeInsets get paddingAll => EdgeInsets.all(toDouble());

  /// 转换为 EdgeInsets.symmetric(horizontal)
  EdgeInsets get paddingHorizontal =>
      EdgeInsets.symmetric(horizontal: toDouble());

  /// 转换为 EdgeInsets.symmetric(vertical)
  EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: toDouble());

  /// 转换为 BorderRadius.circular
  BorderRadius get radius => BorderRadius.circular(toDouble());

  /// 转换为 Radius.circular
  Radius get circular => Radius.circular(toDouble());

  /// 转换为 Duration(milliseconds)
  Duration get milliseconds => Duration(milliseconds: toInt());

  /// 转换为 Duration(seconds)
  Duration get seconds => Duration(seconds: toInt());

  /// 转换为 Duration(minutes)
  Duration get minutes => Duration(minutes: toInt());

  /// 转换为 Duration(hours)
  Duration get hours => Duration(hours: toInt());

  /// 转换为 Duration(days)
  Duration get days => Duration(days: toInt());
}

/// 响应式布局辅助类
class Responsive {
  /// 获取响应式值
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200 && desktop != null) {
      return desktop;
    } else if (width >= 600 && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  /// 是否是移动设备
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  /// 是否是平板
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  /// 是否是桌面
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }
}

