import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_state_layout.dart';
import '../widgets/custom_app_bar.dart';
import 'view_state.dart';

/// 统一基础页面脚手架 (BaseScaffold)
///
/// 集成通用能力：
/// - 统一沉浸式 CustomAppBar 与自定义导航栏
/// - 内置 ViewStatus 通用五态切换 (Loading、Empty、Error点击重试、Success)
/// - 空白处点击自动收起键盘 (autoUnfocus)
/// - 安全顶部与安全底部区域包裹 (safeTop / safeBottom)
/// - 底部固定操作栏 (bottomBar，如提交按钮区) 自动防刘海/指示条遮挡
class BaseScaffold extends StatelessWidget {
  /// 导航栏标题
  final String? title;

  /// 自定义导航栏标题组件 (优先级高于 title)
  final Widget? titleWidget;

  /// 自定义 AppBar (如果传入则完全替换默认 CustomAppBar)
  final PreferredSizeWidget? appBar;

  /// 是否展示导航栏 (默认 true)
  final bool showAppBar;

  /// 导航栏右侧操作按钮
  final List<Widget>? actions;

  /// 导航栏左侧返回/自定义组件
  final Widget? leading;

  /// 标题是否居中 (默认 true)
  final bool centerTitle;

  /// 页面核心内容
  final Widget body;

  /// 页面通用五态状态 (默认为 ViewStatus.success 直接渲染 body)
  final ViewStatus status;

  /// 错误态展示文案
  final String? errorMessage;

  /// 空数据态展示文案
  final String? emptyMessage;

  /// 错误态/空态点击重试回调
  final VoidCallback? onRetry;

  /// 自定义加载中 Widget
  final Widget? loadingWidget;

  /// 自定义空数据 Widget
  final Widget? emptyWidget;

  /// 自定义错误 Widget
  final Widget? errorWidget;

  /// 底部固定区域 (如固定在底部的“立即下单”、“保存”按钮栏)
  final Widget? bottomBar;

  /// 底部操作栏背景色
  final Color? bottomBarColor;

  /// 是否启用顶部安全区 (默认 true)
  final bool safeTop;

  /// 是否启用底部安全区 (默认 true)
  final bool safeBottom;

  /// 点击空白区域是否自动收起键盘 (默认 true)
  final bool autoUnfocus;

  /// 页面背景颜色 (默认读取主题背景色)
  final Color? backgroundColor;

  /// 键盘弹出时是否自动调整尺寸防止遮挡 (默认 true)
  final bool resizeToAvoidBottomInset;

  /// 悬浮按钮
  final Widget? floatingActionButton;

  /// 悬浮按钮位置
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const BaseScaffold({
    super.key,
    this.title,
    this.titleWidget,
    this.appBar,
    this.showAppBar = true,
    this.actions,
    this.leading,
    this.centerTitle = true,
    required this.body,
    this.status = ViewStatus.success,
    this.errorMessage,
    this.emptyMessage,
    this.onRetry,
    this.loadingWidget,
    this.emptyWidget,
    this.errorWidget,
    this.bottomBar,
    this.bottomBarColor,
    this.safeTop = true,
    this.safeBottom = true,
    this.autoUnfocus = true,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    // 1. 构建 AppBar
    PreferredSizeWidget? resolvedAppBar;
    if (showAppBar) {
      resolvedAppBar = appBar ??
          CustomAppBar(
            title: title ?? '',
            titleWidget: titleWidget,
            actions: actions,
            leading: leading,
            centerTitle: centerTitle,
          );
    }

    // 2. 构建主内容 (结合 AppStateLayout 自动处理 5 态)
    Widget content = AppStateLayout(
      status: status,
      errorMessage: errorMessage,
      emptyMessage: emptyMessage,
      onRetry: onRetry,
      loadingWidget: loadingWidget,
      emptyWidget: emptyWidget,
      errorWidget: errorWidget,
      child: body,
    );

    // 3. 安全区域与底部操作栏组装
    if (bottomBar != null) {
      content = Column(
        children: [
          Expanded(child: content),
          _buildSafeBottomBar(context),
        ],
      );
    }

    // 4. SafeArea 处理
    content = SafeArea(
      top:
          safeTop && (resolvedAppBar == null), // 若有 AppBar，系统会自动处理顶部状态栏 padding
      bottom: safeBottom &&
          (bottomBar == null), // 若有 bottomBar，在 bottomBar 内部处理安全底部
      child: content,
    );

    // 5. 点击空白区域收起键盘
    if (autoUnfocus) {
      content = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: content,
      );
    }

    return Scaffold(
      appBar: resolvedAppBar,
      backgroundColor:
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: content,
    );
  }

  /// 构建具备安全底部防遮挡垫高的底部栏
  Widget _buildSafeBottomBar(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      color: bottomBarColor ??
          (isDark ? AppColors.darkSurface : AppColors.lightSurface),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: safeBottom ? bottomPadding : 0,
        ),
        child: bottomBar!,
      ),
    );
  }
}
