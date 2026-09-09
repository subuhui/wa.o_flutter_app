import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'log_util.dart';

/// 设备与应用版本信息工具类
class DeviceUtil {
  DeviceUtil._();

  static late final PackageInfo _packageInfo;
  static late final BaseDeviceInfo _deviceInfo;
  static bool _initialized = false;

  /// 初始化设备与包信息，在 main() 中调用
  static Future<void> init() async {
    if (_initialized) return;
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      final deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        _deviceInfo = await deviceInfoPlugin.androidInfo;
      } else if (Platform.isIOS) {
        _deviceInfo = await deviceInfoPlugin.iosInfo;
      } else {
        _deviceInfo = await deviceInfoPlugin.deviceInfo;
      }
      _initialized = true;
      LogUtil.d(
        'DeviceUtil initialized: appVersion=$appVersion, buildNumber=$buildNumber, deviceModel=$deviceModel',
      );
    } catch (e, stack) {
      LogUtil.e('DeviceUtil init failed: $e', error: e, stackTrace: stack);
    }
  }

  /// 应用名
  static String get appName => _packageInfo.appName;

  /// 应用包名 / Bundle ID
  static String get packageName => _packageInfo.packageName;

  /// 应用版本号 (如 1.0.0)
  static String get appVersion => _packageInfo.version;

  /// 应用构建号 (如 100)
  static String get buildNumber => _packageInfo.buildNumber;

  /// 设备型号 (如 iPhone 15 Pro / Pixel 8)
  static String get deviceModel {
    if (!_initialized) return 'Unknown';
    if (Platform.isAndroid && _deviceInfo is AndroidDeviceInfo) {
      final info = _deviceInfo as AndroidDeviceInfo;
      return '${info.brand} ${info.model}';
    } else if (Platform.isIOS && _deviceInfo is IosDeviceInfo) {
      final info = _deviceInfo as IosDeviceInfo;
      return info.utsname.machine;
    }
    return 'Unknown';
  }

  /// 系统版本
  static String get osVersion {
    if (!_initialized) return 'Unknown';
    if (Platform.isAndroid && _deviceInfo is AndroidDeviceInfo) {
      final info = _deviceInfo as AndroidDeviceInfo;
      return 'Android ${info.version.release} (SDK ${info.version.sdkInt})';
    } else if (Platform.isIOS && _deviceInfo is IosDeviceInfo) {
      final info = _deviceInfo as IosDeviceInfo;
      return 'iOS ${info.systemVersion}';
    }
    return Platform.operatingSystemVersion;
  }
}
