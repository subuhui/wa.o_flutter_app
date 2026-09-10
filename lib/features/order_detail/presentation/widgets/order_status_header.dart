import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/order_detail_model.dart';
import '../controllers/order_detail_controller.dart';

/// 订单状态横幅卡片 (高频倒计时隔离组件)
/// 💡 关键设计：通过 select 局部下沉监听 status 和 remainingTimeFormatted，
/// 倒计时每秒跳动时，仅有本组件毫秒级重绘，下方的地址、商品、费用明细全部 0 次重绘！
class OrderStatusHeader extends ConsumerWidget {
  final String orderId;

  const OrderStatusHeader({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(
      orderDetailControllerProvider(orderId).select((s) => s.status),
    );
    final remainingTime = ref.watch(
      orderDetailControllerProvider(orderId)
          .select((s) => s.remainingTimeFormatted),
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final (statusColor, icon) = switch (status) {
      OrderStatus.unpaid => (
          AppColors.warning,
          Icons.access_time_filled,
        ),
      OrderStatus.paid => (
          AppColors.primaryStrong,
          Icons.inventory_2,
        ),
      OrderStatus.shipped => (
          AppColors.info,
          Icons.local_shipping,
        ),
      OrderStatus.completed => (
          AppColors.success,
          Icons.check_circle,
        ),
      OrderStatus.cancelled => (
          isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          Icons.cancel,
        ),
      OrderStatus.unknown => (
          isDark ? AppColors.darkTextHint : AppColors.lightTextHint,
          Icons.help,
        ),
    };
    final surfaceColor =
        isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final primaryTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 6.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          statusColor.withValues(alpha: isDark ? 0.16 : 0.09),
          surfaceColor,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: statusColor.withValues(alpha: 0.32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24.w, color: statusColor),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 22.sp,
                            color: primaryTextColor,
                          ),
                    ),
                    if (status == OrderStatus.unpaid) ...[
                      SizedBox(height: 4.w),
                      Text(
                        '剩余支付时间 $remainingTime',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12.sp,
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.w),
          Text(
            status == OrderStatus.unpaid ? '请及时完成支付，超时后订单将自动关闭。' : status.desc,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  color: secondaryTextColor,
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }
}
