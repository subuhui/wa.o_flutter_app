import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wa_o_flutter/core/base/base_repository.dart';
import 'package:wa_o_flutter/core/constants/api_constants.dart';
import 'package:wa_o_flutter/core/network/http_client_provider.dart';
import 'package:wa_o_flutter/features/home/data/models/demo_post.dart';

/// 首页数据仓库接口规范
abstract class DemoRepository {
  Future<List<DemoPost>> getPosts({int page = 1, int limit = 10});
}

/// 首页数据仓库实现 (继承自 BaseRepository)
class DemoRepositoryImpl extends BaseRepository implements DemoRepository {
  DemoRepositoryImpl(super.dioClient);

  @override
  Future<List<DemoPost>> getPosts({int page = 1, int limit = 10}) async {
    return safeApiCall(() async {
      final response = await dioClient.get<dynamic>(
        ApiConstants.samplePosts,
        queryParameters: {
          '_page': page,
          '_limit': limit,
        },
      );

      if (response is List) {
        return response
            .map((item) => DemoPost.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    });
  }
}

/// 仓库 Provider
final demoRepoProvider = Provider<DemoRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return DemoRepositoryImpl(dioClient);
});
