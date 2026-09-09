import 'package:dio/dio.dart';

/// 应用程序自定义异常基类
abstract class AppException implements Exception {
  final String message;
  final int? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => 'AppException(code: $code, message: $message)';

  /// 将 DioException 转换为统一的业务级 AppException
  factory AppException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException('网络连接超时，请检查网络设置后重试');
      case DioExceptionType.badCertificate:
        return const CertificateException('证书校验失败，连接不安全');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final statusMessage = error.response?.statusMessage;
        switch (statusCode) {
          case 400:
            return BadRequestException(statusMessage ?? '请求参数有误', code: 400);
          case 401:
            return const UnauthorizedException('登录已失效，请重新登录', code: 401);
          case 403:
            return const ForbiddenException('暂无访问权限', code: 403);
          case 404:
            return const NotFoundException('请求资源不存在', code: 404);
          case 500:
          case 502:
          case 503:
            return ServerException('服务器开小差了，请稍后重试', code: statusCode);
          default:
            return ServerException(
              statusMessage ?? '服务器响应异常 ($statusCode)',
              code: statusCode,
            );
        }
      case DioExceptionType.cancel:
        return const RequestCancelledException('请求已取消');
      case DioExceptionType.connectionError:
        return const NetworkException('网络连接异常，请检查网络连接');
      case DioExceptionType.unknown:
      default:
        return const UnknownException('网络请求未知错误，请稍后重试');
    }
  }
}

/// 超时异常
class TimeoutException extends AppException {
  const TimeoutException(super.message, {super.code});
}

/// 网络连接异常
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

/// 400 请求错误
class BadRequestException extends AppException {
  const BadRequestException(super.message, {super.code});
}

/// 401 未认证异常
class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message, {super.code});
}

/// 403 无权限
class ForbiddenException extends AppException {
  const ForbiddenException(super.message, {super.code});
}

/// 404 路径不存在
class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.code});
}

/// 500+ 服务器内部异常
class ServerException extends AppException {
  const ServerException(super.message, {super.code});
}

/// 请求取消
class RequestCancelledException extends AppException {
  const RequestCancelledException(super.message, {super.code});
}

/// 证书错误
class CertificateException extends AppException {
  const CertificateException(super.message, {super.code});
}

/// 业务逻辑异常 (API 返回了 200，但 business code != success)
class BusinessException extends AppException {
  final dynamic data;
  const BusinessException(super.message, {super.code, this.data});
}

/// 数据反序列化/解析异常
class ParseException extends AppException {
  const ParseException(super.message, {super.code});
}

/// 未知异常
class UnknownException extends AppException {
  const UnknownException(super.message, {super.code});
}
