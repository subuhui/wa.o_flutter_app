import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/order_detail_model.dart';
import '../controllers/order_detail_controller.dart';
import '../state/order_detail_actions.dart';

/// 订单状态横幅卡片 (高频倒计时隔离组件)
/// 💡 关键设计：通过 select 局部下沉监听 status 和 remainingTimeFormatted，
/// 倒计时每秒跳动时，仅有本组件毫秒级重绘，下方的地址、商品、费用明细全部 0 次重绘！
class OrderStatusHeader extends ConsumerWidget {
  final String orderId;
  final OrderDetailActions actions;

  const OrderStatusHeader({
    super.key,
    required this.orderId,
    required this.actions,
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

    // 渐变背景色配置
    final (bgColors, icon, iconColor) = switch (status) {
      OrderStatus.unpaid => (
          [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
          Icons.access_time_filled,
          Colors.white,
        ),
      OrderStatus.paid => (
          [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
          Icons.inventory_2,
          Colors.white,
        ),
      OrderStatus.shipped => (
          [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
          Icons.local_shipping,
          Colors.white,
        ),
      OrderStatus.completed => (
          [const Color(0xFF00C9FF), const Color(0xFF92FE9D)],
          Icons.check_circle,
          Colors.white,
        ),
      OrderStatus.cancelled => (
          [const Color(0xFF8E9EAB), const Color(0xFFEEF2F3)],
          Icons.cancel,
          Colors.white70,
        ),
      OrderStatus.unknown => (
          [Colors.grey.shade400, Colors.grey.shade600],
          Icons.help,
          Colors.white,
        ),
    };

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.darkSurface, const Color(0xFF334155)]
              : bgColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: bgColors.first.withValues(alpha: 0.25),
            blurRadius: 10.r,
            offset: Offset(0, 4.w),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 28.w, color: iconColor),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  status.title,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.w),
          Text(
            status == OrderStatus.unpaid
                ? '请在 $remainingTime 内完成支付，超时订单将自动关闭'
                : status.desc,
            style: TextStyle(fontSize: 13.sp, color: Colors.white70),
          ),
          Divider(color: Colors.white24, height: 24.w),
          // 💡 演示切换工具栏：方便在界面上即时查看 5 种状态下的动态 UI 流转
          Text(
            '【调试面板】点击下方标签快速切换订单状态：',
            style: TextStyle(
                fontSize: 11.sp,
                color: Colors.white60,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.w),
          Wrap(
            spacing: 6.w,
            runSpacing: 6.w,
            children: OrderStatus.values
                .where((e) => e != OrderStatus.unknown)
                .map((targetStatus) {
              final isSelected = targetStatus == status;
              return InkWell(
                onTap: () => actions.onSwitchMockStatus(targetStatus),
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.w),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.black26,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    targetStatus.title,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : Colors.white,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
