import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/toast_util.dart';
import 'base_scaffold.dart';
import 'view_state.dart';

/// 具备生命周期抽象的 StatefulWidget 页面基类 (Vanilla Flutter)
abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({super.key});
}

/// 具备页面状态机、通用 AppBar、安全底部及便捷弹窗的 State 基类
abstract class BaseState<T extends BaseStatefulWidget> extends State<T> {
  /// 页面标题
  String? get title => null;

  /// 自定义标题组件
  Widget? get titleWidget => null;

  /// 自定义 AppBar (优先于默认 CustomAppBar)
  PreferredSizeWidget? buildAppBar() => null;

  /// 是否显示 AppBar
  bool get showAppBar => true;

  /// 导航栏右侧按钮
  List<Widget>? buildActions() => null;

  /// 导航栏左侧组件
  Widget? buildLeading() => null;

  /// 标题是否居中
  bool get centerTitle => true;

  /// 是否启用顶部安全区
  bool get safeTop => true;

  /// 是否启用底部安全区
  bool get safeBottom => true;

  /// 点击空白区域自动收起键盘
  bool get autoUnfocus => true;

  /// 页面背景颜色
  Color? get backgroundColor => null;

  /// 键盘弹起是否缩放防止遮挡
  bool get resizeToAvoidBottomInset => true;

  /// 页面五态枚举 (可通过覆写绑定动态状态)
  ViewStatus get pageStatus => ViewStatus.success;

  /// 错误文案
  String? get errorMessage => null;

  /// 空数据文案
  String? get emptyMessage => null;

  /// 重试回调
  VoidCallback? get onRetry => null;

  /// 底部固定操作栏 (如“立即支付”、“提交订单”，自动垫高安全区域)
  Widget? buildBottomBar(BuildContext context) => null;

  /// 悬浮按钮
  Widget? buildFloatingActionButton() => null;

  /// 构建页面主体核心内容
  Widget buildBody(BuildContext context);

  /// 页面生命周期初始化回调 (在 initState 中触发)
  void initData() {}

  /// 页面卸载回调 (在 dispose 中触发)
  void disposeData() {}

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    disposeData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: title,
      titleWidget: titleWidget,
      appBar: buildAppBar(),
      showAppBar: showAppBar,
      actions: buildActions(),
      leading: buildLeading(),
      centerTitle: centerTitle,
      safeTop: safeTop,
      safeBottom: safeBottom,
      autoUnfocus: autoUnfocus,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      status: pageStatus,
      errorMessage: errorMessage,
      emptyMessage: emptyMessage,
      onRetry: onRetry,
      bottomBar: buildBottomBar(context),
      floatingActionButton: buildFloatingActionButton(),
      body: buildBody(context),
    );
  }

  // ================= 便捷反馈工具方法 =================

  /// 显示全局加载中遮罩
  void showLoading({String msg = '加载中...'}) => ToastUtil.showLoading(msg: msg);

  /// 隐藏加载中遮罩
  void dismissLoading() => ToastUtil.dismissLoading();

  /// 弹出普通 Toast 提示
  void showToast(String msg) => ToastUtil.show(msg);

  /// 弹出成功 Toast
  void showSuccess(String msg) => ToastUtil.showSuccess(msg);

  /// 弹出错误 Toast
  void showError(String msg) => ToastUtil.showError(msg);

  /// 弹出警告 Toast
  void showWarning(String msg) => ToastUtil.showWarning(msg);
}

/// 具备生命周期抽象的 Riverpod ConsumerStatefulWidget 页面基类
abstract class BaseConsumerStatefulWidget extends ConsumerStatefulWidget {
  const BaseConsumerStatefulWidget({super.key});
}

/// 具备 Riverpod 响应能力的 BaseConsumerState 基类
abstract class BaseConsumerState<T extends BaseConsumerStatefulWidget>
    extends ConsumerState<T> {
  /// 页面标题
  String? get title => null;

  /// 自定义标题组件
  Widget? get titleWidget => null;

  /// 自定义 AppBar (优先于默认 CustomAppBar)
  PreferredSizeWidget? buildAppBar() => null;

  /// 是否显示 AppBar
  bool get showAppBar => true;

  /// 导航栏右侧按钮
  List<Widget>? buildActions() => null;

  /// 导航栏左侧组件
  Widget? buildLeading() => null;

  /// 标题是否居中
  bool get centerTitle => true;

  /// 是否启用顶部安全区
  bool get safeTop => true;

  /// 是否启用底部安全区
  bool get safeBottom => true;

  /// 点击空白区域自动收起键盘
  bool get autoUnfocus => true;

  /// 页面背景颜色
  Color? get backgroundColor => null;

  /// 键盘弹起是否缩放防止遮挡
  bool get resizeToAvoidBottomInset => true;

  /// 页面五态枚举 (可通过覆写绑定动态状态)
  ViewStatus get pageStatus => ViewStatus.success;

  /// 错误文案
  String? get errorMessage => null;

  /// 空数据文案
  String? get emptyMessage => null;

  /// 重试回调
  VoidCallback? get onRetry => null;

  /// 底部固定操作栏 (如“立即支付”、“提交订单”，自动垫高安全区域)
  Widget? buildBottomBar(BuildContext context) => null;

  /// 悬浮按钮
  Widget? buildFloatingActionButton() => null;

  /// 构建页面主体核心内容
  Widget buildBody(BuildContext context);

  /// 页面生命周期初始化回调 (在 initState 中触发)
  void initData() {}

  /// 页面卸载回调 (在 dispose 中触发)
  void disposeData() {}

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    disposeData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: title,
      titleWidget: titleWidget,
      appBar: buildAppBar(),
      showAppBar: showAppBar,
      actions: buildActions(),
      leading: buildLeading(),
      centerTitle: centerTitle,
      safeTop: safeTop,
      safeBottom: safeBottom,
      autoUnfocus: autoUnfocus,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      status: pageStatus,
      errorMessage: errorMessage,
      emptyMessage: emptyMessage,
      onRetry: onRetry,
      bottomBar: buildBottomBar(context),
      floatingActionButton: buildFloatingActionButton(),
      body: buildBody(context),
    );
  }

  // ================= 便捷反馈工具方法 =================

  /// 显示全局加载中遮罩
  void showLoading({String msg = '加载中...'}) => ToastUtil.showLoading(msg: msg);

  /// 隐藏加载中遮罩
  void dismissLoading() => ToastUtil.dismissLoading();

  /// 弹出普通 Toast 提示
  void showToast(String msg) => ToastUtil.show(msg);

  /// 弹出成功 Toast
  void showSuccess(String msg) => ToastUtil.showSuccess(msg);

  /// 弹出错误 Toast
  void showError(String msg) => ToastUtil.showError(msg);

  /// 弹出警告 Toast
  void showWarning(String msg) => ToastUtil.showWarning(msg);
}
