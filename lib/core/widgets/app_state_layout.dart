import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../base/view_state.dart';
import '../theme/app_colors.dart';

/// 通用页面状态切换布局组件 (根据 ViewStatus 自动展示不同画面)
class AppStateLayout extends StatelessWidget {
  final ViewStatus status;
  final Widget child;
  final VoidCallback? onRetry;
  final String? errorMessage;
  final String? emptyMessage;
  final Widget? loadingWidget;
  final Widget? emptyWidget;
  final Widget? errorWidget;

  const AppStateLayout({
    super.key,
    required this.status,
    required this.child,
    this.onRetry,
    this.errorMessage,
    this.emptyMessage,
    this.loadingWidget,
    this.emptyWidget,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case ViewStatus.initial:
      case ViewStatus.success:
        return child;
      case ViewStatus.loading:
        return loadingWidget ?? _buildDefaultLoading(context);
      case ViewStatus.empty:
        return emptyWidget ?? _buildDefaultEmpty(context);
      case ViewStatus.error:
        return errorWidget ?? _buildDefaultError(context);
    }
  }

  /// 默认加载中样式
  Widget _buildDefaultLoading(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator.adaptive(strokeWidth: 3.w),
          SizedBox(height: 16.w),
          Text(
            '加载中...',
            style:
                TextStyle(color: AppColors.lightTextSecondary, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  /// 默认空数据样式
  Widget _buildDefaultEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_rounded,
              size: 64.w,
              color: AppColors.lightTextHint,
            ),
            SizedBox(height: 16.w),
            Text(
              emptyMessage ?? '暂无相关数据',
              style: TextStyle(
                color: AppColors.lightTextSecondary,
                fontSize: 15.sp,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: 16.w),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh, size: 18.w),
                label: const Text('刷新看看'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 默认错误重试样式
  Widget _buildDefaultError(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.w,
              color: AppColors.error,
            ),
            SizedBox(height: 16.w),
            Text(
              errorMessage ?? '数据加载遇到问题',
              style: TextStyle(
                color: AppColors.lightTextPrimary,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.w),
            if (onRetry != null)
              FilledButton.icon(
                onPressed: onRetry,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                icon: Icon(Icons.refresh_rounded, size: 18.w),
                label: const Text('点击重试'),
              ),
          ],
        ),
      ),
    );
  }
}
