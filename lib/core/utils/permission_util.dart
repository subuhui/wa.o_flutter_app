import 'package:permission_handler/permission_handler.dart';
import 'toast_util.dart';

/// 动态系统权限申请工具类
class PermissionUtil {
  PermissionUtil._();

  /// 检查并请求相机权限
  static Future<bool> requestCamera() async {
    return _request(Permission.camera, rationale: '需要相机权限以拍摄照片或扫描二维码');
  }

  /// 检查并请求相册/照片权限
  static Future<bool> requestPhotos() async {
    return _request(Permission.photos, rationale: '需要访问您的相册以选取图片');
  }

  /// 检查并请求存储权限
  static Future<bool> requestStorage() async {
    return _request(Permission.storage, rationale: '需要文件存储权限以保存文件');
  }

  /// 检查并请求通知权限
  static Future<bool> requestNotification() async {
    return _request(Permission.notification, rationale: '需要通知权限以便接收关键提醒');
  }

  /// 打开系统应用设置页
  static Future<bool> openSettings() async {
    return openAppSettings();
  }

  /// 统一处理权限请求状态
  static Future<bool> _request(Permission permission,
      {String? rationale}) async {
    final status = await permission.status;

    if (status.isGranted || status.isLimited) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      if (rationale != null) {
        ToastUtil.showWarning('$rationale，请前往系统设置中开启');
      }
      await openAppSettings();
      return false;
    }

    final result = await permission.request();
    if (result.isGranted || result.isLimited) {
      return true;
    } else {
      if (rationale != null) {
        ToastUtil.showWarning(rationale);
      }
      return false;
    }
  }
}
