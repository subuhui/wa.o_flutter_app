import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui_demo/core/base/base_page.dart';
import 'package:ui_demo/core/widgets/app_state_layout.dart';
import 'package:ui_demo/features/home/presentation/controllers/home_controller.dart';
import 'package:ui_demo/features/home/presentation/widgets/home_post_list.dart';

/// 分页列表与页面状态演示。
class DataDemoPage extends ConsumerWidget {
  const DataDemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(
      homeControllerProvider.select((state) => state.status),
    );
    final errorMessage = ref.watch(
      homeControllerProvider.select((state) => state.errorMessage),
    );
    final controller = ref.read(homeControllerProvider.notifier);

    return BaseScaffold(
      title: '数据与状态',
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '页面状态演示',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 4.w),
                Text(
                  '切换状态后可通过刷新或重试恢复真实列表。',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                SizedBox(height: 12.w),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.w,
                  children: [
                    _DemoAction(
                      icon: Icons.refresh,
                      label: '刷新',
                      onPressed: controller.loadPosts,
                    ),
                    _DemoAction(
                      icon: Icons.hourglass_top,
                      label: '加载反馈',
                      onPressed: controller.simulateSubmit,
                    ),
                    _DemoAction(
                      icon: Icons.inbox_outlined,
                      label: '空态',
                      onPressed: controller.mockEmpty,
                    ),
                    _DemoAction(
                      icon: Icons.error_outline,
                      label: '异常态',
                      onPressed: controller.mockError,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: AppStateLayout(
              status: status,
              errorMessage: errorMessage,
              onRetry: controller.loadPosts,
              child: const HomePostList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _DemoAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18.w),
      label: Text(label),
    );
  }
}
