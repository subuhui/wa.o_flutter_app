import 'dart:convert';
import 'package:mmkv/mmkv.dart';
import '../utils/log_util.dart';

/// MMKV 高性能键值存储封装工具类
class MmkvUtil {
  MmkvUtil._();

  static MMKV? _mmkv;

  /// 初始化 MMKV，在 main() 中优先调用
  static Future<String> init() async {
    final rootDir = await MMKV.initialize();
    _mmkv = MMKV.defaultMMKV();
    LogUtil.d('MMKV initialized at: $rootDir');
    return rootDir;
  }

  static MMKV get instance {
    if (_mmkv == null) {
      throw StateError(
          'MmkvUtil is not initialized. Call MmkvUtil.init() in main().');
    }
    return _mmkv!;
  }

  // ================= 基础类型存取 =================

  /// 保存 String
  static bool putString(String key, String value) {
    return instance.encodeString(key, value);
  }

  /// 获取 String
  static String getString(String key, {String defaultValue = ''}) {
    return instance.decodeString(key) ?? defaultValue;
  }

  /// 保存 bool
  static bool putBool(String key, bool value) {
    return instance.encodeBool(key, value);
  }

  /// 获取 bool
  static bool getBool(String key, {bool defaultValue = false}) {
    return instance.decodeBool(key, defaultValue: defaultValue);
  }

  /// 保存 int
  static bool putInt(String key, int value) {
    return instance.encodeInt(key, value);
  }

  /// 获取 int
  static int getInt(String key, {int defaultValue = 0}) {
    return instance.decodeInt(key, defaultValue: defaultValue);
  }

  /// 保存 double
  static bool putDouble(String key, double value) {
    return instance.encodeDouble(key, value);
  }

  /// 获取 double
  static double getDouble(String key, {double defaultValue = 0.0}) {
    return instance.decodeDouble(key, defaultValue: defaultValue);
  }

  // ================= 复杂对象 / List 存取 (JSON) =================

  /// 保存自定义对象 (经由 json 序列化)
  static bool putObject<T>(
      String key, T value, Map<String, dynamic> Function(T obj) toJson) {
    try {
      final jsonStr = jsonEncode(toJson(value));
      return instance.encodeString(key, jsonStr);
    } catch (e, stack) {
      LogUtil.e('MmkvUtil putObject error: $e', stackTrace: stack);
      return false;
    }
  }

  /// 读取自定义对象 (经由 json 反序列化)
  static T? getObject<T>(
      String key, T Function(Map<String, dynamic> json) fromJson) {
    final jsonStr = instance.decodeString(key);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return fromJson(map);
    } catch (e, stack) {
      LogUtil.e('MmkvUtil getObject error: $e', stackTrace: stack);
      return null;
    }
  }

  /// 保存 List
  static bool putList<T>(
      String key, List<T> list, Map<String, dynamic> Function(T item) toJson) {
    try {
      final jsonList = list.map((item) => toJson(item)).toList();
      final jsonStr = jsonEncode(jsonList);
      return instance.encodeString(key, jsonStr);
    } catch (e, stack) {
      LogUtil.e('MmkvUtil putList error: $e', stackTrace: stack);
      return false;
    }
  }

  /// 读取 List
  static List<T> getList<T>(
      String key, T Function(Map<String, dynamic> json) fromJson) {
    final jsonStr = instance.decodeString(key);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e, stack) {
      LogUtil.e('MmkvUtil getList error: $e', stackTrace: stack);
      return [];
    }
  }

  // ================= 键管理与清理 =================

  /// 是否包含某键
  static bool containsKey(String key) {
    return instance.containsKey(key);
  }

  /// 移除指定键
  static void remove(String key) {
    instance.removeValue(key);
  }

  /// 清空所有数据
  static void clearAll() {
    instance.clearAll();
  }
}
