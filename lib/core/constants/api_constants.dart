/// API 相关常量定义
class ApiConstants {
  ApiConstants._();

  /// 基础 URL 配置 (支持通过环境变量或配置切换)
  static const String devBaseUrl = 'https://jsonplaceholder.typicode.com';
  static const String prodBaseUrl = 'https://jsonplaceholder.typicode.com';

  /// 当前生效的 Base URL
  static String baseUrl = devBaseUrl;

  /// 超时时间设置
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);

  /// 状态码规范
  static const int successCode = 200;
  static const int unauthorizedCode = 401;
  static const int forbiddenCode = 403;
  static const int notFoundCode = 404;
  static const int serverErrorCode = 500;

  /// 接口路径示例
  static const String samplePosts = '/posts';
  static const String sampleUsers = '/users';
}
