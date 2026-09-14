import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wa_o_flutter/core/widgets/app_refresher.dart';
import '../controllers/home_controller.dart';
import 'post_list_item.dart';

/// 独立子组件：文章列表容器 (采用 watch + select 精准监听，集成 EasyRefresh)
class HomePostList extends ConsumerWidget {
  const HomePostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 💡 仅在 posts 数据源改变时重构此列表组件
    final posts = ref.watch(
      homeControllerProvider.select((state) => state.data ?? []),
    );

    return AppRefresher(
      onRefresh: () => ref.read(homeControllerProvider.notifier).onRefresh(),
      onLoad: () => ref.read(homeControllerProvider.notifier).onLoadMore(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return PostListItem(key: ValueKey(post.id), post: post);
        },
      ),
    );
  }
}
