import 'package:easy_refresh/easy_refresh.dart';
import '../utils/log_util.dart';
import '../utils/toast_util.dart';
import 'base_state_notifier.dart';
import 'view_state.dart';

/// 分页列表状态控制器基类 (全自动管理页码递增、EasyRefresh 下拉刷新、上拉加载更多及五态流转)
abstract class BasePaginationNotifier<T> extends BaseStateNotifier<List<T>> {
  int _currentPage = 1;
  bool _hasMore = true;

  BasePaginationNotifier([super.state = const ViewState.initial()]) {
    _currentPage = initialPage;
  }

  /// 初始页码 (默认从 1 开始，若后端接口为 0 基索引可覆写此属性)
  int get initialPage => 1;

  /// 每页拉取数量 (默认 10 条)
  int get pageSize => 10;

  /// 当前所处页码
  int get currentPage => _currentPage;

  /// 是否还有更多数据可拉取
  bool get hasMore => _hasMore;

  /// 抽象分页拉取接口：由具体子类实现网络/仓储层请求
  Future<List<T>> fetchPage(int page, int pageSize);

  /// 页面进入时的初始数据加载 (首屏)
  Future<void> initFetch({bool showGlobalLoading = false}) async {
    _currentPage = initialPage;
    _hasMore = true;

    await runSafeAsync(
      () async {
        final items = await fetchPage(_currentPage, pageSize);
        if (items.length < pageSize) {
          _hasMore = false;
        }
        return items;
      },
      showGlobalLoading: showGlobalLoading,
      checkEmpty: (items) => items.isEmpty,
    );
  }

  /// EasyRefresh 下拉刷新触发逻辑
  Future<IndicatorResult> onRefresh() async {
    try {
      _currentPage = initialPage;
      _hasMore = true;

      final items = await fetchPage(_currentPage, pageSize);

      if (items.isEmpty) {
        _hasMore = false;
        safeUpdateState(const ViewState.empty());
        return IndicatorResult.noMore;
      }

      if (items.length < pageSize) {
        _hasMore = false;
      }

      safeUpdateState(ViewState.success(items));
      return IndicatorResult.success;
    } catch (e, stack) {
      LogUtil.e('BasePaginationNotifier onRefresh failed: $e',
          error: e, stackTrace: stack);
      ToastUtil.showError('刷新失败，请稍后重试');
      return IndicatorResult.fail;
    }
  }

  /// EasyRefresh 上拉加载更多触发逻辑
  Future<IndicatorResult> onLoadMore() async {
    if (!_hasMore) {
      return IndicatorResult.noMore;
    }

    try {
      final nextPage = _currentPage + 1;
      final newItems = await fetchPage(nextPage, pageSize);

      if (newItems.isEmpty) {
        _hasMore = false;
        return IndicatorResult.noMore;
      }

      _currentPage = nextPage;
      final currentList = state.data ?? [];
      final updatedList = [...currentList, ...newItems];

      if (newItems.length < pageSize) {
        _hasMore = false;
      }

      safeUpdateState(ViewState.success(updatedList));
      return _hasMore ? IndicatorResult.success : IndicatorResult.noMore;
    } catch (e, stack) {
      LogUtil.e('BasePaginationNotifier onLoadMore failed: $e',
          error: e, stackTrace: stack);
      ToastUtil.showError('加载更多失败');
      return IndicatorResult.fail;
    }
  }

  // ================= 列表本地快速操作助手 =================

  /// 根据条件从当前列表中快速移除某项 (如侧滑删除)
  void removeItem(bool Function(T item) predicate) {
    final currentList = state.data;
    if (currentList == null || currentList.isEmpty) return;

    final newList = currentList.where((item) => !predicate(item)).toList();
    if (newList.isEmpty) {
      safeUpdateState(const ViewState.empty());
    } else {
      safeUpdateState(ViewState.success(newList));
    }
  }

  /// 在列表指定索引处插入新元素 (如顶部快速插入新发表动态)
  void insertItem(int index, T item) {
    final currentList = state.data ?? [];
    final newList = List<T>.from(currentList)..insert(index, item);
    safeUpdateState(ViewState.success(newList));
  }

  /// 更新列表中的特定元素 (如点赞数变更、修改收藏状态)
  void updateItem(
      bool Function(T item) predicate, T Function(T oldItem) updater) {
    final currentList = state.data;
    if (currentList == null || currentList.isEmpty) return;

    final newList = currentList.map((item) {
      return predicate(item) ? updater(item) : item;
    }).toList();

    safeUpdateState(ViewState.success(newList));
  }
}
