import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/storage/mmkv_util.dart';
import 'core/utils/device_util.dart';
import 'core/utils/log_util.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // 1. 初始化 MMKV 本地高性能键值持久化
      await MmkvUtil.init();

      // 2. 初始化设备与包信息
      await DeviceUtil.init();

      // 2. 捕获 Flutter 框架级未处理异常
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        LogUtil.e(
          'Flutter Framework Error: ${details.exceptionAsString()}',
          error: details.exception,
          stackTrace: details.stack,
        );
      };

      // 3. 启动应用，外层注入全局 ProviderScope
      runApp(
        const ProviderScope(
          child: MyApp(),
        ),
      );
    },
    (error, stackTrace) {
      // 4. 捕获 Dart 异步未处理全局异常
      LogUtil.e('Uncaught Async Error: $error',
          error: error, stackTrace: stackTrace);
    },
  );
}
