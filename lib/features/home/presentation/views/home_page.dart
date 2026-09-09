import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_demo/core/base/base_page.dart';
import 'package:ui_demo/core/theme/app_colors.dart';
import 'package:ui_demo/core/widgets/app_state_layout.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_action_bar.dart';
import '../widgets/home_post_list.dart';

/// 首页视图
/// 💡 采用 BaseScaffold 统一管理 AppBar、安全区域、键盘自动收起与安全底部栏
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: '基础架构演示',
      // 💡 演示：固定在页面底部的安全区域操作栏 (自动避开 iPhone 底部横条与刘海)
      bottomBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.lightDivider)),
        ),
        child: const Row(
          children: [
            Icon(Icons.shield_outlined, size: 18, color: AppColors.primary),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '已接入 BaseScaffold：安全底部与点击空白收起键盘已生效',
                style: TextStyle(
                    fontSize: 12, color: AppColors.lightTextSecondary),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 💡 1. 独立子组件：顶部操作按钮区
          const HomeActionBar(),
          const Divider(height: 1),

          // 💡 2. 使用 Consumer 局部下沉：仅让状态机与列表区域监听变更
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                // 💡 3. 使用 watch + select 精准监听关键字段，过滤掉不相干的属性变动
                final status = ref.watch(
                  homeControllerProvider.select((state) => state.status),
                );
                final errorMessage = ref.watch(
                  homeControllerProvider.select((state) => state.errorMessage),
                );

                return AppStateLayout(
                  status: status,
                  errorMessage: errorMessage,
                  onRetry: () =>
                      ref.read(homeControllerProvider.notifier).loadPosts(),
                  // 💡 4. 真正展示列表的内容拆分为独立组件 HomePostList
                  child: const HomePostList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
