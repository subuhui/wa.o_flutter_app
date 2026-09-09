import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

/// 全局统一半屏底部抽屉组件 (BaseBottomSheet)
class BaseBottomSheet extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget child;
  final bool showCloseButton;
  final bool safeBottom;
  final double? maxHeight;
  final Color? backgroundColor;

  const BaseBottomSheet({
    super.key,
    this.title,
    this.titleWidget,
    required this.child,
    this.showCloseButton = true,
    this.safeBottom = true,
    this.maxHeight,
    this.backgroundColor,
  });

  /// 静态快速弹出底部抽屉
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    Widget? titleWidget,
    bool showCloseButton = true,
    bool isScrollControlled = true,
    double? maxHeight,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BaseBottomSheet(
          title: title,
          titleWidget: titleWidget,
          showCloseButton: showCloseButton,
          maxHeight: maxHeight,
          backgroundColor: backgroundColor,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? (screenHeight * 0.85),
      ),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isDark ? AppColors.darkSurface : AppColors.lightSurface),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.w),
          // 1. 顶部拖拽指示条
          Container(
            width: 40.w,
            height: 4.w,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // 2. 标题栏与关闭按钮
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
            child: Row(
              children: [
                Expanded(
                  child: titleWidget ??
                      Text(
                        title ?? '',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
                if (showCloseButton)
                  IconButton(
                    icon: Icon(Icons.close, size: 20.w),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),

          // 3. 抽屉核心内容
          Flexible(child: child),

          // 4. 安全底部间距防遮挡
          if (safeBottom) SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}
