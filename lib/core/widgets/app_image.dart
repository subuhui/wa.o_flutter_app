import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';

/// 全局统一图片渲染组件 (支持网络缓存、本地资源与 SVG 矢量图)
class AppImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (url.endsWith('.svg')) {
      if (url.startsWith('http://') || url.startsWith('https://')) {
        imageWidget = SvgPicture.network(
          url,
          width: width,
          height: height,
          fit: fit,
        );
      } else {
        imageWidget = SvgPicture.asset(
          url,
          width: width,
          height: height,
          fit: fit,
        );
      }
    } else if (url.startsWith('http://') || url.startsWith('https://')) {
      imageWidget = CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, _) =>
            placeholder ??
            Container(
              width: width,
              height: height,
              color: AppColors.lightDivider,
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                ),
              ),
            ),
        errorWidget: (context, _, __) =>
            errorWidget ??
            Container(
              width: width,
              height: height,
              color: AppColors.lightDivider,
              child: const Icon(
                Icons.broken_image_outlined,
                color: AppColors.lightTextHint,
                size: 24,
              ),
            ),
      );
    } else {
      imageWidget = Image.asset(
        url,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, _, __) =>
            errorWidget ??
            Container(
              width: width,
              height: height,
              color: AppColors.lightDivider,
              child: const Icon(
                Icons.broken_image_outlined,
                color: AppColors.lightTextHint,
                size: 24,
              ),
            ),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
