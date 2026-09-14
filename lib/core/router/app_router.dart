import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/views/component_demo_page.dart';
import '../../features/home/presentation/views/data_demo_page.dart';
import '../../features/home/presentation/views/demo_stateful_page.dart';
import '../../features/home/presentation/views/home_page.dart';
import '../../features/home/presentation/views/system_demo_page.dart';
import '../../features/order_detail/presentation/views/order_detail_page.dart';
import 'route_paths.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// 全局路由 Provider (基于 GoRouter)
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RoutePaths.home,
    debugLogDiagnostics: true,
    observers: [
      FlutterSmartDialog.observer, // 让 SmartDialog 监听路由跳转
    ],
    routes: [
      GoRoute(
        path: RoutePaths.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RoutePaths.dataDemo,
        builder: (context, state) => const DataDemoPage(),
      ),
      GoRoute(
        path: RoutePaths.componentDemo,
        builder: (context, state) => const ComponentDemoPage(),
      ),
      GoRoute(
        path: RoutePaths.systemDemo,
        builder: (context, state) => const SystemDemoPage(),
      ),
      GoRoute(
        path: RoutePaths.detail,
        builder: (context, state) => const DemoStatefulPage(),
      ),
      GoRoute(
        path: RoutePaths.orderDetail,
        builder: (context, state) => const OrderDetailPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('页面未找到')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('404: ${state.error?.message ?? "页面不存在"}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RoutePaths.home),
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    ),
  );
});
