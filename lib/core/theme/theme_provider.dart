import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';
import '../storage/mmkv_util.dart';

/// 主题模式状态控制器
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(_initialThemeMode);

  static ThemeMode get _initialThemeMode {
    final savedMode = MmkvUtil.getString(AppConstants.keyThemeMode);
    switch (savedMode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  /// 切换主题模式
  void setThemeMode(ThemeMode mode) {
    state = mode;
    final modeStr = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
    };
    MmkvUtil.putString(AppConstants.keyThemeMode, modeStr);
  }

  /// 在亮色与暗色之间切换
  void toggleTheme() {
    if (state == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }
}

/// 主题模式 Provider
final themeModeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
