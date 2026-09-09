import 'package:dio/dio.dart';
import '../../utils/log_util.dart';

/// 网络请求/响应结构化日志拦截器
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    LogUtil.d(
      '🌐 [HTTP Request] --> ${options.method.toUpperCase()} ${options.uri}\n'
      'Headers: ${options.headers}\n'
      'Query: ${options.queryParameters}\n'
      'Body: ${options.data}',
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    LogUtil.d(
      '✅ [HTTP Response] <-- [${response.statusCode}] ${response.requestOptions.uri}\n'
      'Data: ${response.data}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    LogUtil.e(
      '❌ [HTTP Error] <-- [${err.response?.statusCode}] ${err.requestOptions.uri}\n'
      'Type: ${err.type}\n'
      'Message: ${err.message}\n'
      'Response: ${err.response?.data}',
      error: err,
    );
    super.onError(err, handler);
  }
}
