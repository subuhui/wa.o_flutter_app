import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.storefront_outlined,
                  size: 18.w, color: AppColors.primary),
              SizedBox(width: 8.w),
              Text(
                '官方自营旗舰店',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  '极速发货',
                  style: TextStyle(fontSize: 10.sp, color: AppColors.primary),
                ),
              ),
            ],
          ),
          Divider(height: 20.w),
          // 商品列表
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.w),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildProductItem(item, isDark);
            },
          ),
          // 折叠/展开按钮
          if (hasMultipleProducts) ...[
            Divider(height: 20.w),
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
                  size: 18.w,
                ),
                label: Text(
                  isExpanded ? '收起商品' : '展开剩余 $hiddenCount 件商品',
                  style: TextStyle(fontSize: 12.sp),
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
          width: 72.w,
          height: 72.w,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBackground : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),
          ),
          child: Icon(Icons.devices, size: 32.w, color: Colors.grey),
        ),
        SizedBox(width: 12.w),
        // 标题、规格与价格
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.black.withAlpha(8),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  item.spec,
                  style: TextStyle(
                      fontSize: 11.sp, color: AppColors.lightTextSecondary),
                ),
              ),
              SizedBox(height: 6.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '¥${item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
                  ),
                  Text(
                    'x${item.quantity}',
                    style: TextStyle(
                        fontSize: 12.sp, color: AppColors.lightTextSecondary),
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
