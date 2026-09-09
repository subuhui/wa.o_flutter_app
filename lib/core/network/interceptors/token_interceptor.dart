import 'package:dio/dio.dart';
import '../../constants/app_constants.dart';
import '../../storage/mmkv_util.dart';
import '../../utils/device_util.dart';

/// 身份认证 Token 与设备特征注入拦截器
class TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 从 MMKV 中读取 Token
    final token = MmkvUtil.getString(AppConstants.keyToken);
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // 注入标准设备与版本特征 Header (便于服务端日志追踪与排错)
    options.headers['App-Version'] = DeviceUtil.appVersion;
    options.headers['Build-Number'] = DeviceUtil.buildNumber;
    options.headers['Platform'] = 'flutter';
    options.headers['Device-Model'] = DeviceUtil.deviceModel;
    options.headers['OS-Version'] = DeviceUtil.osVersion;

    super.onRequest(options, handler);
  }
}
