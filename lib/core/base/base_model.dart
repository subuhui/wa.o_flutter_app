import 'dart:convert';

/// 数据实体解析函数签名
typedef FromJson<T> = T Function(Map<String, dynamic> json);

/// 实体转 JSON 函数签名
typedef ToJson<T> = Map<String, dynamic> Function(T entity);

/// 应用程序数据模型基类规范
abstract class BaseModel {
  const BaseModel();

  /// 序列化为 Map 对象
  Map<String, dynamic> toJson();

  /// 序列化为 JSON 格式字符串
  String toJsonString() => jsonEncode(toJson());
}
