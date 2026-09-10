import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/toast_util.dart';
import '../controllers/order_detail_controller.dart';
import '../state/order_detail_actions.dart';
import 'order_cancel_dialog.dart';

/// 底部操作栏组件 (根据状态动态展示按钮，支持单个按钮独立 Loading)
/// 💡 仅监听 availableActions 和 runningOperations，倒计时每秒跳动绝不引起本组件重绘！
class OrderBottomActionBar extends ConsumerWidget {
  final String orderId;
  final OrderDetailActions actions;

  const OrderBottomActionBar({
    super.key,
    required this.orderId,
    required this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableActions = ref.watch(
      orderDetailControllerProvider(orderId).select((s) => s.availableActions),
    );
    final runningOps = ref.watch(
      orderDetailControllerProvider(orderId).select((s) => s.runningOperations),
    );

    if (availableActions.isEmpty) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
          ),
        ),
      ),
      child: Row(
        children: availableActions.indexed.map((entry) {
          final (index, buttonType) = entry;
          final isOperating = runningOps.contains(buttonType.key);
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: index == 0 ? 0 : 12.w),
              child: _buildButton(context, buttonType, isOperating),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    OrderBottomButtonType type,
    bool isOperating,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final label = Text(
      type.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
    );
    final child = Stack(
      alignment: Alignment.center,
      children: [
        Opacity(opacity: isOperating ? 0 : 1, child: label),
        if (isOperating)
          SizedBox(
            width: 18.w,
            height: 18.w,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
      ],
    );

    final onPressed = isOperating ? null : () => _handleAction(context, type);

    if (type.isPrimary) {
      return FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          minimumSize: Size.fromHeight(48.w),
          backgroundColor: AppColors.primaryPressed,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              isDark ? AppColors.darkDivider : AppColors.lightDivider,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8.w),
        ),
        child: child,
      );
    } else {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: Size.fromHeight(48.w),
          foregroundColor:
              isDark ? AppColors.primaryDarkTheme : AppColors.primaryPressed,
          side: BorderSide(
            width: 1.w,
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8.w),
        ),
        child: child,
      );
    }
  }

  void _handleAction(BuildContext context, OrderBottomButtonType type) {
    switch (type) {
      case OrderBottomButtonType.payNow:
        actions.onPayNow();
      case OrderBottomButtonType.cancel:
        OrderCancelDialog.show(context, onConfirm: actions.onCancelOrder);
      case OrderBottomButtonType.confirmReceipt:
        actions.onConfirmReceipt();
      case OrderBottomButtonType.remindShipment:
        actions.onRemindShipment();
      case OrderBottomButtonType.reorder:
        actions.onReorder();
      case OrderBottomButtonType.viewLogistics:
        actions.onViewLogistics();
      case OrderBottomButtonType.contactSupport:
        actions.onContactSupport();
      case OrderBottomButtonType.deleteOrder:
        ToastUtil.show('订单已成功删除');
    }
  }
}
