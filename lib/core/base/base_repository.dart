import '../network/app_exceptions.dart';
import '../network/dio_client.dart';
import '../storage/mmkv_util.dart';
import '../utils/log_util.dart';
import 'base_model.dart';

/// 数据仓库基类 (提供标准网络解包安全调用与 MMKV 离线优先秒开缓存策略)
abstract class BaseRepository {
  final DioClient dioClient;

  BaseRepository(this.dioClient);

  /// 安全执行网络 API 调用，拦截底层错误并统一抛出 AppException
  Future<T> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } on AppException {
      rethrow;
    } catch (e, stack) {
      LogUtil.e('BaseRepository safeApiCall caught unknown error: $e',
          error: e, stackTrace: stack);
      throw UnknownException('网络请求发生未知异常: $e');
    }
  }

  /// 缓存优先策略 (Stale-While-Revalidate / 离线秒开) - 针对单对象
  ///
  /// 1. 若本地 MMKV 存在缓存，先执行 [onCacheLoaded] 回调使 UI 瞬间呈现，实现 0ms 白屏秒开；
  /// 2. 同时异步发起 [networkFetch] 请求最新数据；
  /// 3. 请求成功后自动覆写本地 MMKV 缓存并返回最新数据；
  /// 4. 若无网且有缓存，仍能保证用户正常浏览旧数据。
  Future<T> fetchWithCache<T>({
    required String cacheKey,
    required Future<T> Function() networkFetch,
    required FromJson<T> fromJson,
    required ToJson<T> toJson,
    void Function(T cachedData)? onCacheLoaded,
  }) async {
    // 1. 读取本地缓存
    final cached = MmkvUtil.getObject<T>(cacheKey, fromJson);
    if (cached != null && onCacheLoaded != null) {
      LogUtil.d('BaseRepository: Hit local cache for key: $cacheKey');
      onCacheLoaded(cached);
    }

    try {
      // 2. 发起远端网络请求
      final remoteData = await safeApiCall(networkFetch);
      // 3. 更新本地缓存
      MmkvUtil.putObject<T>(cacheKey, remoteData, toJson);
      return remoteData;
    } catch (e) {
      // 4. 若网络失败但本地有缓存，直接返回旧缓存，保全可用性
      if (cached != null) {
        LogUtil.w(
            'BaseRepository: Network failed, falling back to cache for key: $cacheKey');
        return cached;
      }
      rethrow;
    }
  }

  /// 缓存优先策略 (针对列表数据)
  Future<List<T>> fetchListWithCache<T>({
    required String cacheKey,
    required Future<List<T>> Function() networkFetch,
    required FromJson<T> fromJson,
    required ToJson<T> toJson,
    void Function(List<T> cachedList)? onCacheLoaded,
  }) async {
    final cachedList = MmkvUtil.getList<T>(cacheKey, fromJson);
    if (cachedList.isNotEmpty && onCacheLoaded != null) {
      LogUtil.d(
          'BaseRepository: Hit local list cache for key: $cacheKey (count: ${cachedList.length})');
      onCacheLoaded(cachedList);
    }

    try {
      final remoteList = await safeApiCall(networkFetch);
      if (remoteList.isNotEmpty) {
        MmkvUtil.putList<T>(cacheKey, remoteList, toJson);
      }
      return remoteList;
    } catch (e) {
      if (cachedList.isNotEmpty) {
        LogUtil.w(
            'BaseRepository: Network failed, falling back to list cache for key: $cacheKey');
        return cachedList;
      }
      rethrow;
    }
  }
}
