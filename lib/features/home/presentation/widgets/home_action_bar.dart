import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_demo/core/base/base_page.dart';
import 'package:ui_demo/core/router/route_paths.dart';
import 'package:ui_demo/core/theme/theme_provider.dart';
import 'package:ui_demo/core/utils/device_util.dart';
import 'package:ui_demo/core/utils/permission_util.dart';
import 'package:ui_demo/core/utils/toast_util.dart';
import 'package:ui_demo/core/utils/url_util.dart';
import '../controllers/home_controller.dart';

/// 首页操作栏独立子组件 (展示与事件触发，内部使用 ref.read，绝不引起不必要的父级重绘)
class HomeActionBar extends ConsumerWidget {
  const HomeActionBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 仅监听当前主题是否为暗色，用于切换图标显示
    final isDark =
        ref.watch(themeModeProvider.select((mode) => mode == ThemeMode.dark));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ActionChip(
            avatar: Icon(isDark ? Icons.light_mode : Icons.dark_mode, size: 16),
            label: Text(isDark ? '切亮色' : '切暗色'),
            onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
          ),
          ActionChip(
            avatar: const Icon(Icons.refresh, size: 16),
            label: const Text('刷新数据'),
            onPressed: () =>
                ref.read(homeControllerProvider.notifier).loadPosts(),
          ),
          ActionChip(
            avatar: const Icon(Icons.hourglass_top, size: 16),
            label: const Text('全局菊花'),
            onPressed: () =>
                ref.read(homeControllerProvider.notifier).simulateSubmit(),
          ),
          ActionChip(
            avatar: const Icon(Icons.inbox_outlined, size: 16),
            label: const Text('模拟空态'),
            onPressed: () =>
                ref.read(homeControllerProvider.notifier).mockEmpty(),
          ),
          ActionChip(
            avatar: const Icon(Icons.error_outline, size: 16),
            label: const Text('模拟异常'),
            onPressed: () =>
                ref.read(homeControllerProvider.notifier).mockError(),
          ),
          ActionChip(
            avatar: const Icon(Icons.phone_iphone, size: 16),
            label: const Text('设备信息'),
            onPressed: () {
              ToastUtil.show(
                '${DeviceUtil.appName} v${DeviceUtil.appVersion} (${DeviceUtil.deviceModel})',
              );
            },
          ),
          ActionChip(
            avatar: const Icon(Icons.camera_alt_outlined, size: 16),
            label: const Text('申请相机'),
            onPressed: () => PermissionUtil.requestCamera(),
          ),
          ActionChip(
            avatar: const Icon(Icons.open_in_browser, size: 16),
            label: const Text('打开官网'),
            onPressed: () => UrlUtil.launchBrowser('https://flutter.dev'),
          ),
          ActionChip(
            avatar: const Icon(Icons.layers_outlined, size: 16),
            label: const Text('BaseState页'),
            onPressed: () => context.push(RoutePaths.detail),
          ),
          ActionChip(
            avatar: const Icon(Icons.receipt_long, size: 16),
            label: const Text('订单详情(State+Actions)'),
            onPressed: () => context.push(RoutePaths.orderDetail),
          ),
          ActionChip(
            avatar: const Icon(Icons.chat_bubble_outline, size: 16),
            label: const Text('BaseDialog'),
            onPressed: () {
              BaseDialog.show<void>(
                title: '确认操作',
                content: '这是一个基于 BaseDialog 规范搭建的统一风格弹窗，支持暗黑模式自适应。',
                onConfirm: () => ToastUtil.showSuccess('点击了确定'),
              );
            },
          ),
          ActionChip(
            avatar: const Icon(Icons.vertical_align_bottom, size: 16),
            label: const Text('Base抽屉'),
            onPressed: () {
              BaseBottomSheet.show<void>(
                context: context,
                title: '系统面板 (BaseBottomSheet)',
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('底部半屏抽屉，已自动适配安全底部防遮挡。'),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('关闭抽屉'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
