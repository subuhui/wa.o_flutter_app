import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wa_o_flutter/core/base/base_page.dart';
import 'package:wa_o_flutter/core/router/route_paths.dart';
import 'package:wa_o_flutter/core/utils/toast_util.dart';

/// 项目基础页面与弹层组件入口。
class ComponentDemoPage extends StatelessWidget {
  const ComponentDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: '基础组件',
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          const _PageIntro(
            title: '统一的页面与弹层体验',
            description: '每个示例独立触发，便于查看基础组件的职责与交互。',
          ),
          SizedBox(height: 20.w),
          _ComponentTile(
            icon: Icons.layers_outlined,
            title: 'BaseState 页面',
            description: '查看页面基类、本地状态与安全底部操作区',
            onTap: () => context.push(RoutePaths.detail),
          ),
          SizedBox(height: 12.w),
          _ComponentTile(
            icon: Icons.chat_bubble_outline,
            title: 'BaseDialog',
            description: '展示统一样式的确认弹窗',
            onTap: () {
              BaseDialog.show<void>(
                title: '确认操作',
                content: '这是一个基于 BaseDialog 搭建的统一风格弹窗，支持暗黑模式自适应。',
                onConfirm: () => ToastUtil.showSuccess('点击了确定'),
              );
            },
          ),
          SizedBox(height: 12.w),
          _ComponentTile(
            icon: Icons.vertical_align_bottom,
            title: 'BaseBottomSheet',
            description: '展示自动适配底部安全区的半屏面板',
            onTap: () {
              BaseBottomSheet.show<void>(
                context: context,
                title: '系统面板',
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('底部半屏面板已自动避让系统手势区域。'),
                      SizedBox(height: 16.w),
                      FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('关闭面板'),
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

class _PageIntro extends StatelessWidget {
  final String title;
  final String description;

  const _PageIntro({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.w),
        Text(
          description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ComponentTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ComponentTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Icon(icon, size: 28.w, color: theme.colorScheme.primary),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.w),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.chevron_right,
                size: 24.w,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
