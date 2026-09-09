import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/base/base_page.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/toast_util.dart';
import '../../../../core/widgets/app_refresher.dart';
import '../../../../core/widgets/app_state_layout.dart';
import '../controllers/order_detail_controller.dart';
import '../state/order_detail_actions.dart';
import '../widgets/order_address_card.dart';
import '../widgets/order_bottom_action_bar.dart';
import '../widgets/order_info_card.dart';
import '../widgets/order_price_card.dart';
import '../widgets/order_product_section.dart';
import '../widgets/order_status_header.dart';

/// 订单详情页面
/// 💡 核心设计规范落地：
/// 1. OrderDetailPage 是本功能唯一的 ConsumerWidget (充当 Riverpod 与 UI 的适配层)；
/// 2. 负责把 Notifier 的方法引用打包成 OrderDetailActions 传递给纯 UI 层；
/// 3. 子组件全面纯化（StatelessWidget），彻底消除 Widget 树中到处乱窜的 ref.read 与 ref.watch！
class OrderDetailPage extends ConsumerWidget {
  final String orderId;

  const OrderDetailPage({super.key, this.orderId = 'OD20260909001'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(orderDetailControllerProvider(orderId).notifier);

    // 💡 1. 组装 Actions 回调包 (直接绑定控制器的方法引用，天然闭包，参数清晰)
    final actions = OrderDetailActions(
      onRefresh: () => notifier.loadDetail(showLoading: false),
      onRetry: () => notifier.loadDetail(showLoading: true),
      onPayNow: notifier.payNow,
      onCancelOrder: notifier.cancelOrder,
      onConfirmReceipt: notifier.confirmReceipt,
      onRemindShipment: notifier.remindShipment,
      onReorder: notifier.reorder,
      onViewLogistics: () => ToastUtil.show('正在获取顺丰速运实时包裹路由...'),
      onContactSupport: () => ToastUtil.show('已为您连接自营店铺金牌客服'),
      onCopyOrderSn: notifier.copyOrderSn,
      onToggleExpandProducts: notifier.toggleExpandProducts,
      onSwitchMockStatus: notifier.switchMockStatus,
    );

    // 💡 2. 仅在顶层监听页面整体加载态与数据实体
    final isInitialLoading = ref.watch(
      orderDetailControllerProvider(orderId).select((s) => s.isInitialLoading),
    );
    final errorMessage = ref.watch(
      orderDetailControllerProvider(orderId).select((s) => s.errorMessage),
    );
    final order = ref.watch(
      orderDetailControllerProvider(orderId).select((s) => s.order),
    );

    // 计算页面加载五态
    final status = isInitialLoading
        ? ViewStatus.loading
        : errorMessage != null
            ? ViewStatus.error
            : order != null
                ? ViewStatus.success
                : ViewStatus.empty;

    return BaseScaffold(
      title: '订单详情 (State+Actions)',
      // 💡 固定安全底部栏：已自适应 iPhone 底部安全区域
      bottomBar: OrderBottomActionBar(orderId: orderId, actions: actions),
      body: AppStateLayout(
        status: status,
        errorMessage: errorMessage,
        onRetry: actions.onRetry,
        child: order == null
            ? const SizedBox.shrink()
            : AppRefresher(
                onRefresh: actions.onRefresh,
                child: ListView(
                  padding: EdgeInsets.only(bottom: 24.w),
                  children: [
                    // 1. 顶部架构说明卡片 (用于技术演示对照)
                    _buildArchitectureTip(context),

                    // 2. 状态横幅与倒计时 (局部监听倒计时，不引起整页重绘)
                    OrderStatusHeader(orderId: orderId, actions: actions),

                    // 3. 收货地址 (纯 StatelessWidget)
                    OrderAddressCard(address: order.address),

                    // 4. 商品清单 (局部监听展开/折叠状态)
                    Consumer(
                      builder: (context, ref, _) {
                        final isExpanded = ref.watch(
                          orderDetailControllerProvider(orderId)
                              .select((s) => s.isProductsExpanded),
                        );
                        final displayedItems = ref.watch(
                          orderDetailControllerProvider(orderId)
                              .select((s) => s.displayedProducts),
                        );
                        final hasMultiple = ref.watch(
                          orderDetailControllerProvider(orderId)
                              .select((s) => s.hasMultipleProducts),
                        );
                        final hiddenCount = ref.watch(
                          orderDetailControllerProvider(orderId)
                              .select((s) => s.hiddenProductsCount),
                        );

                        return OrderProductSection(
                          items: displayedItems,
                          isExpanded: isExpanded,
                          hasMultipleProducts: hasMultiple,
                          hiddenCount: hiddenCount,
                          onToggleExpand: actions.onToggleExpandProducts,
                        );
                      },
                    ),

                    // 5. 费用明细 (纯 StatelessWidget)
                    OrderPriceCard(priceBreakdown: order.priceBreakdown),

                    // 6. 订单信息与一键复制 (纯 StatelessWidget)
                    OrderInfoCard(
                      order: order,
                      onCopyOrderSn: actions.onCopyOrderSn,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildArchitectureTip(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 0),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.tips_and_updates, size: 18.w, color: AppColors.primary),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              '架构范式：Riverpod 到 Page 为止，UI 子组件均为纯 StatelessWidget。动作由 OrderDetailActions 回调包统一分发，倒计时通过 select 隔离秒级局部重绘。',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.primary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
