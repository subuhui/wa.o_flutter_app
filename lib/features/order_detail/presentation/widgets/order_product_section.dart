import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/order_detail_model.dart';

/// 订单商品清单模块 (支持折叠/展开动画，纯 StatelessWidget)
class OrderProductSection extends StatelessWidget {
  final List<OrderItem> items;
  final bool isExpanded;
  final bool hasMultipleProducts;
  final int hiddenCount;
  final VoidCallback onToggleExpand;

  const OrderProductSection({
    super.key,
    required this.items,
    required this.isExpanded,
    required this.hasMultipleProducts,
    required this.hiddenCount,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.storefront_outlined,
                  size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text(
                '官方自营旗舰店',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '极速发货',
                  style: TextStyle(fontSize: 10, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          // 商品列表
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildProductItem(item, isDark);
            },
          ),
          // 折叠/展开按钮
          if (hasMultipleProducts) ...[
            const Divider(height: 20),
            Center(
              child: TextButton.icon(
                onPressed: onToggleExpand,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.lightTextSecondary,
                  visualDensity: VisualDensity.compact,
                ),
                icon: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 18,
                ),
                label: Text(
                  isExpanded ? '收起商品' : '展开剩余 $hiddenCount 件商品',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProductItem(OrderItem item, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 商品图片占位卡片
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBackground : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),
          ),
          child: const Icon(Icons.devices, size: 32, color: Colors.grey),
        ),
        const SizedBox(width: 12),
        // 标题、规格与价格
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.black.withAlpha(8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item.spec,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.lightTextSecondary),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '¥${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
                  ),
                  Text(
                    'x${item.quantity}',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.lightTextSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
