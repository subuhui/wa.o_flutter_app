import 'package:url_launcher/url_launcher.dart';
import 'log_util.dart';
import 'toast_util.dart';

/// 外部链接与系统应用唤起工具类
class UrlUtil {
  UrlUtil._();

  /// 在外部浏览器中打开网页
  static Future<bool> launchBrowser(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ToastUtil.showError('无法打开该链接: $url');
        return false;
      }
    } catch (e) {
      LogUtil.e('UrlUtil launchBrowser error: $e');
      ToastUtil.showError('打开链接失败');
      return false;
    }
  }

  /// 拨打电话
  static Future<bool> makePhoneCall(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    } else {
      ToastUtil.showError('设备不支持拨打电话');
      return false;
    }
  }

  /// 发送邮件
  static Future<bool> sendEmail(String email,
      {String? subject, String? body}) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    } else {
      ToastUtil.showError('设备未安装邮件客户端');
      return false;
    }
  }

  /// 发送短信
  static Future<bool> sendSms(String phoneNumber, {String? body}) async {
    final uri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {
        if (body != null) 'body': body,
      },
    );
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    } else {
      ToastUtil.showError('设备不支持发送短信');
      return false;
    }
  }
}
