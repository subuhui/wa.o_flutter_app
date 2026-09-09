import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_demo/core/base/base_pagination_notifier.dart';
import 'package:ui_demo/core/base/view_state.dart';
import 'package:ui_demo/core/utils/toast_util.dart';
import 'package:ui_demo/features/home/data/models/demo_post.dart';
import 'package:ui_demo/features/home/data/repositories/demo_repo.dart';

/// 首页状态控制器 (直接继承 BasePaginationNotifier，零样板代码实现全套分页与刷新)
class HomeController extends BasePaginationNotifier<DemoPost> {
  final DemoRepository _repository;

  HomeController(this._repository) : super(const ViewState.initial()) {
    initFetch();
  }

  /// 核心实现：提供分页拉取实现，基类全自动维护页码与列表流转
  @override
  Future<List<DemoPost>> fetchPage(int page, int pageSize) {
    return _repository.getPosts(page: page, limit: pageSize);
  }

  /// 兼容刷新别名
  Future<void> loadPosts() => initFetch();

  /// 模拟触发空数据状态
  void mockEmpty() {
    safeUpdateState(const ViewState.empty(errorMessage: '暂未检索到任何数据'));
  }

  /// 模拟触发错误异常状态
  void mockError() {
    safeUpdateState(
      const ViewState.error('模拟服务器发生异常 (500)，请点击下方按钮重试', errorCode: 500),
    );
  }

  /// 模拟耗时异步操作 (带全局防连击菊花 Loading)
  Future<void> simulateSubmit() async {
    ToastUtil.showLoading(msg: '正在同步数据...');
    await Future<void>.delayed(const Duration(seconds: 2));
    ToastUtil.dismissLoading();
    ToastUtil.showSuccess('数据同步成功！');
  }
}

/// 首页控制器 Provider
final homeControllerProvider =
    StateNotifierProvider<HomeController, ViewState<List<DemoPost>>>((ref) {
  final repo = ref.watch(demoRepoProvider);
  return HomeController(repo);
});
