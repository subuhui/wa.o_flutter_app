import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_demo/core/base/base_page.dart';
import 'package:ui_demo/core/router/route_paths.dart';
import 'package:ui_demo/core/theme/app_colors.dart';
import 'package:ui_demo/core/theme/theme_provider.dart';
import 'package:ui_demo/features/home/presentation/widgets/home_feature_card.dart';

/// 应用功能概览页，只保留分类入口，具体演示在各自页面完成。
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(
      themeModeProvider.select((mode) => mode == ThemeMode.dark),
    );

    return BaseScaffold(
      title: 'UI Demo',
      actions: [
        IconButton(
          tooltip: isDark ? '切换到亮色模式' : '切换到暗色模式',
          onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
        ),
      ],
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 24.w),
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.primarySoft,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color:
                    isDark ? AppColors.darkDivider : AppColors.primarySurface,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.w,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Flutter 基础能力',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 16.w),
                Text(
                  '按场景找到需要的示例',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.w),
                Text(
                  '状态管理、基础组件与系统能力已分类整理，首页不再堆叠所有操作。',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.w),
          const _SectionTitle(
            title: '功能分类',
            description: '选择一个主题继续浏览',
          ),
          SizedBox(height: 12.w),
          HomeFeatureCard(
            icon: Icons.view_list_outlined,
            title: '数据与状态',
            description: '分页列表、刷新、加载、空态与异常态',
            onTap: () => context.push(RoutePaths.dataDemo),
          ),
          SizedBox(height: 12.w),
          HomeFeatureCard(
            icon: Icons.widgets_outlined,
            title: '基础组件',
            description: 'BaseState 页面、统一弹窗与底部面板',
            onTap: () => context.push(RoutePaths.componentDemo),
          ),
          SizedBox(height: 12.w),
          HomeFeatureCard(
            icon: Icons.phone_android_outlined,
            title: '系统能力',
            description: '设备信息、相机权限与外部浏览器',
            onTap: () => context.push(RoutePaths.systemDemo),
          ),
          SizedBox(height: 24.w),
          const _SectionTitle(
            title: '业务示例',
            description: '查看完整页面结构与交互',
          ),
          SizedBox(height: 12.w),
          HomeFeatureCard(
            icon: Icons.receipt_long_outlined,
            title: '订单详情',
            description: 'State + Actions 架构与底部操作区',
            onTap: () => context.push(RoutePaths.orderDetail),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String description;

  const _SectionTitle({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            description,
            textAlign: TextAlign.right,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
