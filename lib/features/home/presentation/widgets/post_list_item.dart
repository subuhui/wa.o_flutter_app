import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ui_demo/core/theme/app_colors.dart';
import 'package:ui_demo/core/utils/toast_util.dart';
import 'package:ui_demo/core/widgets/app_image.dart';
import '../../data/models/demo_post.dart';

/// 独立子组件：单条文章卡片 (集成 Slidable 侧滑菜单与 AppImage 图片缓存)
class PostListItem extends StatelessWidget {
  final DemoPost post;

  const PostListItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(post.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              ToastUtil.showSuccess('已将 #${post.id} 加入收藏');
            },
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            icon: Icons.star_outline,
            label: '收藏',
          ),
          SlidableAction(
            onPressed: (context) {
              ToastUtil.show('已删除 #${post.id}');
            },
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: '删除',
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 文章缩略图 (带缓存)
              AppImage(
                url: 'https://picsum.photos/seed/${post.id}/120/120',
                width: 56,
                height: 56,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(width: 12),
              // 文章主体信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '#${post.id}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            post.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      post.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.lightTextSecondary,
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
