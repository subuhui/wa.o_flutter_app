import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// 全局 Toast 与 Loading 提示工具类 (基于 flutter_smart_dialog，无需 BuildContext)
class ToastUtil {
  ToastUtil._();

  /// 纯文本 Toast 提示
  static void show(
    String message, {
    Duration displayTime = const Duration(milliseconds: 2000),
    Alignment alignment = Alignment.bottomCenter,
  }) {
    if (message.isEmpty) return;
    SmartDialog.showToast(
      message,
      displayTime: displayTime,
      alignment: alignment,
    );
  }

  /// 成功提示 (带图标/绿色强调)
  static void showSuccess(
    String message, {
    Duration displayTime = const Duration(milliseconds: 2000),
  }) {
    if (message.isEmpty) return;
    SmartDialog.showToast(
      message,
      displayTime: displayTime,
      builder: (context) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.r,
                offset: Offset(0, 2.w),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 20.w),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 错误提示 (带图标/红色强调)
  static void showError(
    String message, {
    Duration displayTime = const Duration(milliseconds: 2500),
  }) {
    if (message.isEmpty) return;
    SmartDialog.showToast(
      message,
      displayTime: displayTime,
      builder: (context) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
          decoration: BoxDecoration(
            color: const Color(0xFFD32F2F).withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.r,
                offset: Offset(0, 2.w),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20.w),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 警告提示
  static void showWarning(String message) {
    if (message.isEmpty) return;
    SmartDialog.showToast(
      message,
      builder: (context) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
          decoration: BoxDecoration(
            color: const Color(0xFFED6C02).withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.r,
                offset: Offset(0, 2.w),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: Colors.white, size: 20.w),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 显示全局加载中遮罩 (防重复点击)
  static void showLoading(
      {String msg = '加载中...', bool clickMaskDismiss = false}) {
    SmartDialog.showLoading<void>(
      msg: msg,
      clickMaskDismiss: clickMaskDismiss,
    );
  }

  /// 关闭加载中遮罩
  static void dismissLoading() {
    SmartDialog.dismiss<void>(status: SmartStatus.loading);
  }

  /// 关闭所有弹窗
  static void dismissAll() {
    SmartDialog.dismiss<void>();
  }
}
