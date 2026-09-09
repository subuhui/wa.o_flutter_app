import 'package:flutter/foundation.dart';
import '../../data/models/order_detail_model.dart';

/// 底部操作栏按钮枚举 (UI展示样式与动作归属)
enum OrderBottomButtonType {
  cancel('cancel', '取消订单', isPrimary: false),
  payNow('pay', '立即支付', isPrimary: true),
  remindShipment('remind', '催促发货', isPrimary: false),
  viewLogistics('logistics', '查看物流', isPrimary: false),
  confirmReceipt('confirm', '确认收货', isPrimary: true),
  reorder('reorder', '再次购买', isPrimary: true),
  deleteOrder('delete', '删除订单', isPrimary: false),
  contactSupport('support', '联系客服', isPrimary: false);

  final String key;
  final String label;
  final bool isPrimary;

  const OrderBottomButtonType(this.key, this.label, {required this.isPrimary});
}

/// 订单详情 UI 交互回调聚合包 (Actions Bundle)
/// 💡 页面所有用户动作以普通回调形式聚合在此，子组件纯无脑调用，零 Riverpod 依赖！
@immutable
class OrderDetailActions {
  // 页面生命周期与加载
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;

  // 订单核心业务流程
  final VoidCallback onPayNow;
  final ValueChanged<String> onCancelOrder; // 接收取消原因
  final VoidCallback onConfirmReceipt;
  final VoidCallback onRemindShipment;
  final VoidCallback onReorder;

  // 辅助能力与跳转
  final VoidCallback onViewLogistics;
  final VoidCallback onContactSupport;
  final ValueChanged<String> onCopyOrderSn;

  // 局部 UI 交互 (展开/折叠)
  final VoidCallback onToggleExpandProducts;

  // 演示专用：实时切换订单 Mock 状态
  final ValueChanged<OrderStatus> onSwitchMockStatus;

  const OrderDetailActions({
    required this.onRefresh,
    required this.onRetry,
    required this.onPayNow,
    required this.onCancelOrder,
    required this.onConfirmReceipt,
    required this.onRemindShipment,
    required this.onReorder,
    required this.onViewLogistics,
    required this.onContactSupport,
    required this.onCopyOrderSn,
    required this.onToggleExpandProducts,
    required this.onSwitchMockStatus,
  });
}
