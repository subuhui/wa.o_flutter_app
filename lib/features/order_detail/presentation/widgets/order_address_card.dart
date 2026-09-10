import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/order_detail_model.dart';

/// 收货地址展示卡片 (纯 StatelessWidget，零 Riverpod 依赖)
class OrderAddressCard extends StatelessWidget {
  final ShippingAddress address;

  const OrderAddressCard({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final brandColor =
        isDark ? AppColors.primaryDarkTheme : AppColors.primaryStrong;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primaryDarkTheme.withValues(alpha: 0.14)
                  : AppColors.primarySurface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on,
              size: 20.w,
              color: brandColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8.w,
                  runSpacing: 4.w,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      address.recipientName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 16.sp,
                            color: primaryTextColor,
                          ),
                    ),
                    Text(
                      address.recipientPhone,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                            color: secondaryTextColor,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 6.w),
                Text(
                  address.fullAddress,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        color: primaryTextColor,
                        height: 1.4,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
