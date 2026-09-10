import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_image.dart';
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
    final primaryTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final brandColor =
        isDark ? AppColors.primaryDarkTheme : AppColors.primaryStrong;

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
              Icon(Icons.storefront_outlined, size: 20.w, color: brandColor),
              SizedBox(width: 8.w),
              Text(
                '官方自营旗舰店',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 16.sp,
                      color: primaryTextColor,
                    ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primaryDarkTheme.withValues(alpha: 0.14)
                      : AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  '极速发货',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: brandColor,
                  ),
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
              return KeyedSubtree(
                key: ValueKey<int>(item.id),
                child: _buildProductItem(
                  context,
                  item,
                  isDark: isDark,
                  primaryTextColor: primaryTextColor,
                  secondaryTextColor: secondaryTextColor,
                ),
              );
            },
          ),
          // 折叠/展开按钮
          if (hasMultipleProducts) ...[
            Divider(height: 20.w),
            Center(
              child: TextButton.icon(
                onPressed: onToggleExpand,
                style: TextButton.styleFrom(
                  foregroundColor: secondaryTextColor,
                  minimumSize: Size(44.w, 44.w),
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

  Widget _buildProductItem(
    BuildContext context,
    OrderItem item, {
    required bool isDark,
    required Color primaryTextColor,
    required Color secondaryTextColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppImage(
          url: item.imageUrl,
          width: 72.w,
          height: 72.w,
          borderRadius: BorderRadius.circular(8.r),
          errorWidget: _buildImageFallback(isDark),
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: primaryTextColor,
                    ),
              ),
              SizedBox(height: 4.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkBackground
                      : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  item.spec,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: secondaryTextColor,
                  ),
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
                      color: AppColors.primaryStrong,
                    ),
                  ),
                  Text(
                    'x${item.quantity}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageFallback(bool isDark) {
    return Container(
      width: 72.w,
      height: 72.w,
      color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 24.w,
        color: isDark ? AppColors.darkTextHint : AppColors.lightTextHint,
      ),
    );
  }
}
