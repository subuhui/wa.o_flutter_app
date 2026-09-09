import 'package:flutter/material.dart';

/// App 全局基础常量配置
class AppConstants {
  AppConstants._();

  /// 应用基本信息
  static const String appName = 'UI Demo';
  static const String appVersion = '1.0.0';

  /// 屏幕适配设计稿基准尺寸 (宽 x 高，如 iPhone X: 375 x 812)
  static const Size designSize = Size(375, 812);

  /// MMKV 存储键名常量
  static const String keyToken = 'app_key_token';
  static const String keyRefreshToken = 'app_key_refresh_token';
  static const String keyThemeMode = 'app_key_theme_mode';
  static const String keyLocale = 'app_key_locale';
  static const String keyUserInfo = 'app_key_user_info';
  static const String keyIsFirstOpen = 'app_key_is_first_open';
}
