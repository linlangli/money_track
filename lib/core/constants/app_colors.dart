import 'package:flutter/material.dart';

/// App color constants based on design requirements
class AppColors {
  AppColors._();

  // Primary colors from design
  static const Color primary = Color(0xFFFFD700); // 金黄色 Gold
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color pink = Color(0xFFEA655C); // 粉红色

  // Additional colors for UI elements
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = white;
  static const Color textPrimary = black;
  static const Color textSecondary = Color(0xFF666666);
  static const Color divider = Color(0xFFE0E0E0);

  // Expense type colors
  static const Color catering = Color(0xFFFF6B6B);
  static const Color transportation = Color(0xFF4ECDC4);
  static const Color shopping = Color(0xFFFFBE0B);
  static const Color communication = Color(0xFF95E1D3);

  // Chart colors
  static const List<Color> chartColors = [
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFFFFBE0B),
    Color(0xFF95E1D3),
    Color(0xFFF38181),
    Color(0xFFAA96DA),
  ];
}

