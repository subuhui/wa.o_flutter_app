import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/app_exceptions.dart';
import '../utils/log_util.dart';
import '../utils/toast_util.dart';
import 'view_state.dart';

/// 通用页面业务状态控制器基类 (基于 StateNotifier<ViewState<T>>)
abstract class BaseStateNotifier<T> extends StateNotifier<ViewState<T>> {
  BaseStateNotifier([super.state = const ViewState.initial()]);

  /// 安全更新状态 (避免组件卸载后调用报错)
  void safeUpdateState(ViewState<T> newState) {
    if (mounted) {
      state = newState;
    }
  }

  /// 通用异步安全执行器
  /// - [action]: 异步数据获取操作
  /// - [showGlobalLoading]: 是否弹出全局不可点击的 Loading 遮罩菊花 (适合提交表单/删除)
  /// - [showErrorToast]: 出错时是否自动弹出 Toast 错误提示
  /// - [checkEmpty]: 自定义空数据判断逻辑
  Future<T?> runSafeAsync(
    Future<T> Function() action, {
    bool showGlobalLoading = false,
    bool showErrorToast = true,
    bool Function(T data)? checkEmpty,
  }) async {
    try {
      if (showGlobalLoading) {
        ToastUtil.showLoading();
      } else {
        safeUpdateState(ViewState.loading(data: state.data));
      }

      final result = await action();

      if (showGlobalLoading) {
        ToastUtil.dismissLoading();
      }

      // 判断空数据
      final isDataEmpty = checkEmpty != null
          ? checkEmpty(result)
          : (result is List && result.isEmpty);

      if (isDataEmpty) {
        safeUpdateState(const ViewState.empty());
      } else {
        safeUpdateState(ViewState.success(result));
      }

      return result;
    } on AppException catch (e, stack) {
      if (showGlobalLoading) ToastUtil.dismissLoading();
      LogUtil.e('AppException caught in BaseStateNotifier: ${e.message}',
          error: e, stackTrace: stack);
      safeUpdateState(
          ViewState.error(e.message, errorCode: e.code, data: state.data));
      if (showErrorToast) {
        ToastUtil.showError(e.message);
      }
      return null;
    } catch (e, stack) {
      if (showGlobalLoading) ToastUtil.dismissLoading();
      LogUtil.e('Unknown error in BaseStateNotifier: $e',
          error: e, stackTrace: stack);
      final msg = e.toString();
      safeUpdateState(ViewState.error(msg, data: state.data));
      if (showErrorToast) {
        ToastUtil.showError('操作失败，请稍后重试');
      }
      return null;
    }
  }
}
