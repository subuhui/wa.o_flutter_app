import '../constants/api_constants.dart';

/// 统一 API 响应结构体包装类
class ApiResponse<T> {
  final int code;
  final String message;
  final T? data;

  const ApiResponse({
    required this.code,
    required this.message,
    this.data,
  });

  /// 是否为成功返回
  bool get isSuccess => code == ApiConstants.successCode || code == 0;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic dataJson)? fromJsonT,
  }) {
    final rawCode = json['code'] ?? json['status'] ?? ApiConstants.successCode;
    final int code =
        rawCode is int ? rawCode : int.tryParse(rawCode.toString()) ?? 0;
    final String message = (json['message'] ?? json['msg'] ?? '').toString();
    final dynamic rawData = json['data'] ?? json['result'];

    T? parsedData;
    if (rawData != null && fromJsonT != null) {
      parsedData = fromJsonT(rawData);
    } else if (rawData is T) {
      parsedData = rawData;
    }

    return ApiResponse<T>(
      code: code,
      message: message,
      data: parsedData,
    );
  }

  Map<String, dynamic> toJson(
      {Map<String, dynamic> Function(T value)? toJsonT}) {
    return {
      'code': code,
      'message': message,
      'data': data != null && toJsonT != null ? toJsonT(data as T) : data,
    };
  }

  @override
  String toString() =>
      'ApiResponse(code: $code, message: $message, data: $data)';
}
