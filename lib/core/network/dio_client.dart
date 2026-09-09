import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'app_exceptions.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/token_interceptor.dart';

/// 网络客户端 Dio 封装
class DioClient {
  late final Dio _dio;

  DioClient({BaseOptions? options, List<Interceptor>? customInterceptors}) {
    _dio = Dio(
      options ??
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: ApiConstants.connectTimeout,
            receiveTimeout: ApiConstants.receiveTimeout,
            sendTimeout: ApiConstants.sendTimeout,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            responseType: ResponseType.json,
          ),
    );

    // 默认拦截器链：Token -> Logging -> Error
    _dio.interceptors.addAll([
      TokenInterceptor(),
      LoggingInterceptor(),
      ErrorInterceptor(),
      if (customInterceptors != null) ...customInterceptors,
    ]);
  }

  Dio get dio => _dio;

  /// GET 请求
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? decoder,
  }) async {
    return _sendRequest<T>(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      decoder: decoder,
    );
  }

  /// POST 请求
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? decoder,
  }) async {
    return _sendRequest<T>(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      decoder: decoder,
    );
  }

  /// PUT 请求
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? decoder,
  }) async {
    return _sendRequest<T>(
      () => _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      decoder: decoder,
    );
  }

  /// DELETE 请求
  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? decoder,
  }) async {
    return _sendRequest<T>(
      () => _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      decoder: decoder,
    );
  }

  /// 统一处理请求执行与异常解包
  Future<T> _sendRequest<T>(
    Future<Response<dynamic>> Function() request, {
    T Function(dynamic data)? decoder,
  }) async {
    try {
      final response = await request();
      final data = response.data;

      if (decoder != null) {
        return decoder(data);
      }
      return data as T;
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException(e.toString());
    }
  }
}
