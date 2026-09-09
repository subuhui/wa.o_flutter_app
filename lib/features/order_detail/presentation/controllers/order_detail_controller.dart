import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/log_util.dart';
import '../../../../core/utils/toast_util.dart';
import '../../data/models/order_detail_model.dart';
import '../../data/repositories/order_detail_repository.dart';
import '../state/order_detail_state.dart';

/// 仓储层 Provider
final orderDetailRepositoryProvider = Provider<OrderDetailRepository>((ref) {
  return OrderDetailRepository();
});

/// 订单详情控制器 Provider (按 orderId 隔离，页面退出自动销毁)
final orderDetailControllerProvider = StateNotifierProvider.autoDispose
    .family<OrderDetailController, OrderDetailState, String>(
  (ref, orderId) {
    final repo = ref.watch(orderDetailRepositoryProvider);
    return OrderDetailController(orderId, repo);
  },
);

/// 订单详情业务控制器
class OrderDetailController extends StateNotifier<OrderDetailState> {
  final String orderId;
  final OrderDetailRepository _repository;
  Timer? _countdownTimer;

  OrderDetailController(this.orderId, this._repository)
      : super(const OrderDetailState()) {
    loadDetail();
  }

  /// 拉取订单详情
  Future<void> loadDetail({bool showLoading = true}) async {
    try {
      if (showLoading) {
        state = state.copyWith(isInitialLoading: true, errorMessage: null);
      }

      final data = await _repository.fetchOrderDetail(orderId);

      state = state.copyWith(
        order: data,
        isInitialLoading: false,
        errorMessage: null,
      );

      // 如果是待付款订单，启动支付倒计时 (默认剩余 14分59秒 = 899秒)
      if (data.status == OrderStatus.unpaid) {
        _startCountdown(899);
      } else {
        _stopCountdown();
      }
    } catch (e, stack) {
      LogUtil.e('加载订单详情失败', error: e, stackTrace: stack);
      state = state.copyWith(
        isInitialLoading: false,
        errorMessage: '加载订单详情失败，请点击重试',
      );
    }
  }

  /// 启动支付倒计时 (秒级更新)
  void _startCountdown(int initialSeconds) {
    _stopCountdown();
    state = state.copyWith(remainingPaySeconds: initialSeconds);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final nextSeconds = state.remainingPaySeconds - 1;
      if (nextSeconds <= 0) {
        timer.cancel();
        // 倒计时结束，自动流转为已取消
        if (state.order != null) {
          state = state.copyWith(
            remainingPaySeconds: 0,
            order: state.order!.copyWith(status: OrderStatus.cancelled),
          );
          ToastUtil.show('支付超时，订单已自动关闭');
        }
      } else {
        state = state.copyWith(remainingPaySeconds: nextSeconds);
      }
    });
  }

  /// 停止倒计时
  void _stopCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    state = state.copyWith(remainingPaySeconds: 0);
  }

  /// 立即支付 (操作级独立 Loading)
  Future<void> payNow() async {
    if (state.isOperating('pay')) return;

    _addOperation('pay');
    try {
      final success = await _repository.payOrder(orderId);
      if (success && mounted) {
        _stopCountdown();
        final updatedOrder = state.order?.copyWith(
          status: OrderStatus.paid,
          payTime: '2026-09-09 13:35:00',
        );
        state = state.copyWith(order: updatedOrder);
        ToastUtil.showSuccess('支付成功！商家将尽快为您发货');
      }
    } catch (e) {
      ToastUtil.showError('支付失败，请稍后重试');
    } finally {
      _removeOperation('pay');
    }
  }

  /// 取消订单
  Future<void> cancelOrder(String reason) async {
    if (state.isOperating('cancel')) return;

    _addOperation('cancel');
    try {
      final success = await _repository.cancelOrder(orderId, reason);
      if (success && mounted) {
        _stopCountdown();
        final updatedOrder = state.order?.copyWith(
          status: OrderStatus.cancelled,
        );
        state = state.copyWith(order: updatedOrder);
        ToastUtil.showSuccess('订单已成功取消');
      }
    } catch (e) {
      ToastUtil.showError('取消失败，请稍后重试');
    } finally {
      _removeOperation('cancel');
    }
  }

  /// 确认收货
  Future<void> confirmReceipt() async {
    if (state.isOperating('confirm')) return;

    _addOperation('confirm');
    try {
      final success = await _repository.confirmReceipt(orderId);
      if (success && mounted) {
        final updatedOrder = state.order?.copyWith(
          status: OrderStatus.completed,
        );
        state = state.copyWith(order: updatedOrder);
        ToastUtil.showSuccess('已确认收货，感谢您的评价！');
      }
    } catch (e) {
      ToastUtil.showError('操作失败，请重试');
    } finally {
      _removeOperation('confirm');
    }
  }

  /// 催促发货
  Future<void> remindShipment() async {
    if (state.isOperating('remind')) return;

    _addOperation('remind');
    try {
      await _repository.remindShipment(orderId);
      ToastUtil.showSuccess('已通知仓库加急处理，请耐心等待');
    } catch (e) {
      ToastUtil.showError('提醒失败，请重试');
    } finally {
      _removeOperation('remind');
    }
  }

  /// 再次购买
  void reorder() {
    ToastUtil.showSuccess('商品已为您自动加入购物车');
  }

  /// 复制订单编号
  void copyOrderSn(String sn) {
    Clipboard.setData(ClipboardData(text: sn));
    ToastUtil.showSuccess('订单编号已复制');
  }

  /// 展开 / 收起商品项
  void toggleExpandProducts() {
    state = state.copyWith(isProductsExpanded: !state.isProductsExpanded);
  }

  /// 演示辅助：在界面上快速切换 Mock 订单状态
  void switchMockStatus(OrderStatus newStatus) {
    if (state.order == null) return;
    final updated = state.order!.copyWith(status: newStatus);
    state = state.copyWith(order: updated);

    if (newStatus == OrderStatus.unpaid) {
      _startCountdown(899);
    } else {
      _stopCountdown();
    }
    ToastUtil.show('状态已切换为: ${newStatus.title}');
  }

  void _addOperation(String key) {
    final next = Set<String>.from(state.runningOperations)..add(key);
    state = state.copyWith(runningOperations: next);
  }

  void _removeOperation(String key) {
    final next = Set<String>.from(state.runningOperations)..remove(key);
    state = state.copyWith(runningOperations: next);
  }

  @override
  void dispose() {
    _stopCountdown();
    super.dispose();
  }
}
