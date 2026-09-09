import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../theme/app_colors.dart';

/// 全局统一弹窗组件基类
class BaseDialog extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final String? content;
  final Widget? contentWidget;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool showCancel;
  final bool barrierDismissible;
  final Color? confirmColor;

  const BaseDialog({
    super.key,
    this.title,
    this.titleWidget,
    this.content,
    this.contentWidget,
    this.confirmText = '确定',
    this.cancelText = '取消',
    this.onConfirm,
    this.onCancel,
    this.showCancel = true,
    this.barrierDismissible = true,
    this.confirmColor,
  });

  /// 静态快速弹窗展示 (基于 SmartDialog，无需 context)
  static Future<T?> show<T>({
    String? title,
    Widget? titleWidget,
    String? content,
    Widget? contentWidget,
    String confirmText = '确定',
    String cancelText = '取消',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool showCancel = true,
    bool clickMaskDismiss = true,
    Color? confirmColor,
  }) {
    return SmartDialog.show<T>(
      clickMaskDismiss: clickMaskDismiss,
      builder: (context) {
        return BaseDialog(
          title: title,
          titleWidget: titleWidget,
          content: content,
          contentWidget: contentWidget,
          confirmText: confirmText,
          cancelText: cancelText,
          onConfirm: () {
            SmartDialog.dismiss<T>();
            onConfirm?.call();
          },
          onCancel: () {
            SmartDialog.dismiss<T>();
            onCancel?.call();
          },
          showCancel: showCancel,
          confirmColor: confirmColor,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        width: 310,
        margin: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            // 1. 标题栏
            if (titleWidget != null)
              titleWidget!
            else if (title != null && title!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // 2. 内容区
            const SizedBox(height: 12),
            if (contentWidget != null)
              contentWidget!
            else if (content != null && content!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  content!,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 24),
            const Divider(height: 1),

            // 3. 底部操作按钮栏
            Row(
              children: [
                if (showCancel) ...[
                  Expanded(
                    child: InkWell(
                      onTap: onCancel ?? () => SmartDialog.dismiss<void>(),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                      ),
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        child: Text(
                          cancelText,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? AppColors.darkTextHint
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 48,
                    color:
                        isDark ? AppColors.darkDivider : AppColors.lightDivider,
                  ),
                ],
                Expanded(
                  child: InkWell(
                    onTap: onConfirm ?? () => SmartDialog.dismiss<void>(),
                    borderRadius: BorderRadius.only(
                      bottomRight: const Radius.circular(16),
                      bottomLeft:
                          showCancel ? Radius.zero : const Radius.circular(16),
                    ),
                    child: Container(
                      height: 48,
                      alignment: Alignment.center,
                      child: Text(
                        confirmText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: confirmColor ?? AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
