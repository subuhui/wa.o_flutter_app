import 'package:dio/dio.dart';
import '../../constants/app_constants.dart';
import '../../storage/mmkv_util.dart';
import '../../utils/toast_util.dart';
import '../app_exceptions.dart';

/// 全局异常统一捕获与处理拦截器
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 统一转换为业务级 AppException
    final appException = AppException.fromDioException(err);

    // 针对 401 进行 Token 清理与鉴权处理
    if (appException is UnauthorizedException) {
      MmkvUtil.remove(AppConstants.keyToken);
      ToastUtil.showError(appException.message);
      // 可在此处发送事件通知或路由重定向至登录页
    }

    // 将原始异常包装后继续向下传递
    super.onError(err, handler);
  }
}
