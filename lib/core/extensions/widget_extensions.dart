import 'package:flutter/material.dart';

enum ButtonType {
  text,
  image,
}

/// Widget 扩展方法
extension WidgetExtensions on Widget {
  /// 添加点击事件
  Widget button(
      {GestureTapCallback? onTap,
        Color? color,
        double? width,
        double? height,
        ButtonType type = ButtonType.text}) {
    if (type == ButtonType.image) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: this,
      );
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
        child: this,
      ),
    );
  }

  /// 添加 InkWell 点击效果
  Widget inkTap(VoidCallback? onTap, {BorderRadius? borderRadius}) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: this,
    );
  }

  /// 添加长按事件
  Widget onLongPress(VoidCallback? onLongPress) {
    return GestureDetector(
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: this,
    );
  }

  /// 添加内边距
  Widget padding(EdgeInsetsGeometry padding) {
    return Padding(
      padding: padding,
      child: this,
    );
  }

  /// 添加对称内边距
  Widget paddingAll(double value) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  /// 添加水平内边距
  Widget paddingHorizontal(double value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: value),
      child: this,
    );
  }

  /// 添加垂直内边距
  Widget paddingVertical(double value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: value),
      child: this,
    );
  }

  /// 添加左边距
  Widget paddingLeft(double value) {
    return Padding(
      padding: EdgeInsets.only(left: value),
      child: this,
    );
  }

  /// 添加右边距
  Widget paddingRight(double value) {
    return Padding(
      padding: EdgeInsets.only(right: value),
      child: this,
    );
  }

  /// 添加上边距
  Widget paddingTop(double value) {
    return Padding(
      padding: EdgeInsets.only(top: value),
      child: this,
    );
  }

  /// 添加下边距
  Widget paddingBottom(double value) {
    return Padding(
      padding: EdgeInsets.only(bottom: value),
      child: this,
    );
  }

  /// 添加外边距
  Widget margin(EdgeInsetsGeometry margin) {
    return Container(
      margin: margin,
      child: this,
    );
  }

  /// 添加对称外边距
  Widget marginAll(double value) {
    return Container(
      margin: EdgeInsets.all(value),
      child: this,
    );
  }

  /// 添加水平外边距
  Widget marginHorizontal(double value) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: value),
      child: this,
    );
  }

  /// 添加垂直外边距
  Widget marginVertical(double value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: value),
      child: this,
    );
  }

  /// 设置宽度
  Widget width(double width) {
    return SizedBox(
      width: width,
      child: this,
    );
  }

  /// 设置高度
  Widget height(double height) {
    return SizedBox(
      height: height,
      child: this,
    );
  }

  /// 设置尺寸
  Widget size(double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  /// 设置圆角
  Widget cornerRadius(double radius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: this,
    );
  }

  /// 设置背景色
  Widget backgroundColor(Color color) {
    return Container(
      color: color,
      child: this,
    );
  }

  /// 添加阴影
  Widget shadow({
    Color color = Colors.black26,
    double blurRadius = 8.0,
    Offset offset = const Offset(0, 2),
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: blurRadius,
            offset: offset,
          ),
        ],
      ),
      child: this,
    );
  }

  /// 居中显示
  Widget center() {
    return Center(child: this);
  }

  /// 对齐
  Widget align(AlignmentGeometry alignment) {
    return Align(
      alignment: alignment,
      child: this,
    );
  }

  /// 显示/隐藏
  Widget visible(bool visible) {
    return Visibility(
      visible: visible,
      child: this,
    );
  }

  /// 透明度
  Widget opacity(double opacity) {
    return Opacity(
      opacity: opacity,
      child: this,
    );
  }

  /// 扩展填充
  Widget expanded({int flex = 1}) {
    return Expanded(
      flex: flex,
      child: this,
    );
  }

  /// Flexible
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) {
    return Flexible(
      flex: flex,
      fit: fit,
      child: this,
    );
  }

  /// 添加卡片效果
  Widget card({
    Color? color,
    double? elevation,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? margin,
  }) {
    return Card(
      color: color,
      elevation: elevation,
      shape: borderRadius != null
          ? RoundedRectangleBorder(borderRadius: borderRadius)
          : null,
      margin: margin,
      child: this,
    );
  }

  /// 添加安全区域
  Widget safeArea({
    bool top = true,
    bool bottom = true,
    bool left = true,
    bool right = true,
  }) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: this,
    );
  }

  /// 滚动
  Widget scrollable({
    Axis direction = Axis.vertical,
    ScrollPhysics? physics,
  }) {
    return SingleChildScrollView(
      scrollDirection: direction,
      physics: physics,
      child: this,
    );
  }

  /// Hero 动画
  Widget hero(String tag) {
    return Hero(
      tag: tag,
      child: this,
    );
  }
}

