import 'dart:async';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:ui_demo/core/theme/app_colors.dart';

/// 全局统一封装的下拉刷新与上拉加载组件 (基于 easy_refresh)
class AppRefresher extends StatelessWidget {
  final FutureOr<dynamic> Function()? onRefresh;
  final FutureOr<dynamic> Function()? onLoad;
  final Widget child;
  final EasyRefreshController? controller;
  final Header? header;
  final Footer? footer;
  final bool canRefresh;
  final bool canLoad;

  const AppRefresher({
    super.key,
    required this.child,
    this.onRefresh,
    this.onLoad,
    this.controller,
    this.header,
    this.footer,
    this.canRefresh = true,
    this.canLoad = true,
  });

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      controller: controller,
      header: header ??
          const ClassicHeader(
            dragText: '下拉刷新',
            armedText: '释放即可刷新',
            readyText: '正在刷新...',
            processingText: '正在刷新...',
            processedText: '刷新完成',
            noMoreText: '没有更多数据',
            failedText: '刷新失败',
            messageText: '最后更新于 %T',
            textStyle:
                TextStyle(fontSize: 13, color: AppColors.lightTextSecondary),
            messageStyle:
                TextStyle(fontSize: 11, color: AppColors.lightTextHint),
            iconTheme: IconThemeData(color: AppColors.primary, size: 20),
          ),
      footer: footer ??
          const ClassicFooter(
            dragText: '上拉加载更多',
            armedText: '释放即可加载',
            readyText: '正在加载...',
            processingText: '正在加载...',
            processedText: '加载完成',
            noMoreText: '没有更多数据了',
            failedText: '加载失败',
            messageText: '最后更新于 %T',
            textStyle:
                TextStyle(fontSize: 13, color: AppColors.lightTextSecondary),
            messageStyle:
                TextStyle(fontSize: 11, color: AppColors.lightTextHint),
            iconTheme: IconThemeData(color: AppColors.primary, size: 20),
          ),
      onRefresh: canRefresh ? onRefresh : null,
      onLoad: canLoad ? onLoad : null,
      child: child,
    );
  }
}
