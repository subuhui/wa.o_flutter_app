import 'package:flutter/material.dart';

/// 统一色彩调色板定义
class AppColors {
  AppColors._();

  // 主题核心色彩 (Brand Colors)
  static const Color primary = Color(0xFF2563EB); // 经典科技蓝
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryStrong = Color(0xFF3B82F6);
  static const Color primaryPressed = Color(0xFF2563EB);
  static const Color primarySoft = Color(0xFFEFF6FF);
  static const Color primarySurface = Color(0xFFDBEAFE);
  static const Color primaryDarkTheme = Color(0xFF93C5FD);

  static const Color secondary = Color(0xFF10B981); // 辅助翠绿
  static const Color accent = Color(0xFFF59E0B); // 强调琥珀黄

  // 功能反馈色彩 (Feedback Colors)
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFEA580C);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF0284C7);

  // 亮色中性色 (Light Neutral Colors)
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Colors.white;
  static const Color lightCard = Colors.white;
  static const Color lightDivider = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextHint = Color(0xFF94A3B8);

  // 暗色中性色 (Dark Neutral Colors)
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkDivider = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextHint = Color(0xFF64748B);
}
