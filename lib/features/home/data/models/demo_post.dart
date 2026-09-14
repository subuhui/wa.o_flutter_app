import 'package:wa_o_flutter/core/base/base_model.dart';

/// 示例文章数据实体 (继承自 BaseModel)
class DemoPost extends BaseModel {
  final int id;
  final String title;
  final String body;

  const DemoPost({
    required this.id,
    required this.title,
    required this.body,
  });

  factory DemoPost.fromJson(Map<String, dynamic> json) {
    return DemoPost(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
    };
  }
}
