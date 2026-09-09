import 'package:flutter/material.dart';
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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          // 1. 顶部拖拽指示条
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 2. 标题栏与关闭按钮
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: titleWidget ??
                      Text(
                        title ?? '',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
                if (showCloseButton)
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
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
