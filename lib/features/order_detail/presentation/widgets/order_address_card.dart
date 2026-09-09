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
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on,
              size: 20.w,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      address.recipientName,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      address.recipientPhone,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.w),
                Text(
                  address.fullAddress,
                  style: TextStyle(fontSize: 13.sp, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
