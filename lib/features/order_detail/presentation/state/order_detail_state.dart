import 'package:flutter/foundation.dart';
import '../../data/models/order_detail_model.dart';
import 'order_detail_actions.dart';

/// 订单详情页面的统一不可变状态
@immutable
class OrderDetailState {
  // 1. 核心业务快照 (接口返回的数据实体)
  final OrderDetailModel? order;
  final bool isInitialLoading; // 页面首次骨架屏加载
  final String? errorMessage; // 页面全局异常信息

  // 2. 局部交互状态 (UI-only state)
  final bool isProductsExpanded; // 商品超过2件时是否展开全部
  final int remainingPaySeconds; // 待支付倒计时秒数 (高频秒级变更)

  // 3. 按钮/操作级独立 Loading (哪个操作在执行，哪个按钮转圈，不干扰其他区域)
  final Set<String> runningOperations; // e.g. {'pay', 'cancel', 'confirm'}

  const OrderDetailState({
    this.order,
    this.isInitialLoading = true,
    this.errorMessage,
    this.isProductsExpanded = false,
    this.remainingPaySeconds = 0,
    this.runningOperations = const {},
  });

  // ---------------------------------------------------------------------------
  // 4. 衍生计算属性 (Derived Getters / Atomic Convergence)
  // 💡 复杂页面的核心！逻辑判断、时间格式化、动态按钮列表收敛在此，UI 无脑消费！
  // ---------------------------------------------------------------------------

  /// 当前订单状态
  OrderStatus get status => order?.status ?? OrderStatus.unknown;

  /// 格式化后的剩余支付时间，例如 "14分59秒"
  String get remainingTimeFormatted {
    if (remainingPaySeconds <= 0) return '00:00';
    final m = (remainingPaySeconds ~/ 60).toString().padLeft(2, '0');
    final s = (remainingPaySeconds % 60).toString().padLeft(2, '0');
    return '$m分$s秒';
  }

  /// 动态计算当前状态下底部栏应展示哪些操作按钮
  List<OrderBottomButtonType> get availableActions {
    if (order == null) return const [];
    return switch (status) {
      OrderStatus.unpaid => [
          OrderBottomButtonType.contactSupport,
          OrderBottomButtonType.cancel,
          OrderBottomButtonType.payNow,
        ],
      OrderStatus.paid => [
          OrderBottomButtonType.contactSupport,
          OrderBottomButtonType.remindShipment,
        ],
      OrderStatus.shipped => [
          OrderBottomButtonType.contactSupport,
          OrderBottomButtonType.viewLogistics,
          OrderBottomButtonType.confirmReceipt,
        ],
      OrderStatus.completed => [
          OrderBottomButtonType.deleteOrder,
          OrderBottomButtonType.reorder,
        ],
      OrderStatus.cancelled => [
          OrderBottomButtonType.deleteOrder,
          OrderBottomButtonType.reorder,
        ],
      OrderStatus.unknown => const [],
    };
  }

  /// 指定按钮是否正在执行操作中
  bool isOperating(String key) => runningOperations.contains(key);

  /// 是否有超过 2 件商品
  bool get hasMultipleProducts => (order?.items.length ?? 0) > 2;

  /// 当前实际向列表渲染的商品项 (未展开时折叠展示前2项)
  List<OrderItem> get displayedProducts {
    final all = order?.items ?? [];
    if (isProductsExpanded || all.length <= 2) {
      return all;
    }
    return all.take(2).toList();
  }

  /// 折叠时隐藏的商品数量
  int get hiddenProductsCount => (order?.items.length ?? 0) - 2;

  /// 实付总额快捷获取
  double get actualPayment => order?.priceBreakdown.actualPayment ?? 0.0;

  bool get isUnpaid => status == OrderStatus.unpaid;
  bool get isPaid => status == OrderStatus.paid;
  bool get isShipped => status == OrderStatus.shipped;
  bool get isCompleted => status == OrderStatus.completed;
  bool get isCancelled => status == OrderStatus.cancelled;

  // ---------------------------------------------------------------------------
  // 5. 不可变克隆 (copyWith)
  // ---------------------------------------------------------------------------
  OrderDetailState copyWith({
    OrderDetailModel? order,
    bool? isInitialLoading,
    String? errorMessage,
    bool? isProductsExpanded,
    int? remainingPaySeconds,
    Set<String>? runningOperations,
  }) {
    return OrderDetailState(
      order: order ?? this.order,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isProductsExpanded: isProductsExpanded ?? this.isProductsExpanded,
      remainingPaySeconds: remainingPaySeconds ?? this.remainingPaySeconds,
      runningOperations: runningOperations ?? this.runningOperations,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderDetailState &&
          runtimeType == other.runtimeType &&
          order == other.order &&
          isInitialLoading == other.isInitialLoading &&
          errorMessage == other.errorMessage &&
          isProductsExpanded == other.isProductsExpanded &&
          remainingPaySeconds == other.remainingPaySeconds &&
          setEquals(runningOperations, other.runningOperations);

  @override
  int get hashCode => Object.hash(
        order,
        isInitialLoading,
        errorMessage,
        isProductsExpanded,
        remainingPaySeconds,
        Object.hashAll(runningOperations),
      );
}
