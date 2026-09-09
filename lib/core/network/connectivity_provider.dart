import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 全局网络连接状态 Stream Provider
final connectivityStreamProvider =
    StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// 是否处于联网状态 Provider (有 Wi-Fi、移动蜂窝或以太网连接)
final isConnectedProvider = Provider<bool>((ref) {
  final connectivityAsync = ref.watch(connectivityStreamProvider);
  return connectivityAsync.when(
    data: (results) {
      return results.any((result) =>
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.ethernet);
    },
    loading: () => true, // 默认初始认为有网络，避免白屏
    error: (_, __) => true,
  );
});
