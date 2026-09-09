import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_client.dart';

/// 全局 DioClient Provider
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});
