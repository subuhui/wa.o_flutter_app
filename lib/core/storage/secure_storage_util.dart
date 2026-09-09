import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/log_util.dart';

/// 系统钥匙串 / 安全存储工具类 (用于存放敏感 Token 或凭证)
class SecureStorageUtil {
  SecureStorageUtil._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// 写入安全数据
  static Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e, stack) {
      LogUtil.e('SecureStorage write error: $e', error: e, stackTrace: stack);
    }
  }

  /// 读取安全数据
  static Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e, stack) {
      LogUtil.e('SecureStorage read error: $e', error: e, stackTrace: stack);
      return null;
    }
  }

  /// 删除指定键
  static Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e, stack) {
      LogUtil.e('SecureStorage delete error: $e', error: e, stackTrace: stack);
    }
  }

  /// 清空所有安全数据
  static Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e, stack) {
      LogUtil.e('SecureStorage deleteAll error: $e',
          error: e, stackTrace: stack);
    }
  }
}
