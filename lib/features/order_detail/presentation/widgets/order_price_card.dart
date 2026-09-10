import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/order_detail_model.dart';

/// 订单费用明细卡片 (纯 StatelessWidget，零 Riverpod 依赖)
class OrderPriceCard extends StatelessWidget {
  final PriceBreakdown priceBreakdown;

  const OrderPriceCard({super.key, required this.priceBreakdown});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '费用明细',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 16.sp,
                  color: primaryTextColor,
                ),
          ),
          SizedBox(height: 12.w),
          _buildPriceRow(
            context,
            '商品总额',
            '¥${priceBreakdown.goodsTotal.toStringAsFixed(2)}',
            secondaryTextColor: secondaryTextColor,
          ),
          SizedBox(height: 8.w),
          _buildPriceRow(
            context,
            '运费',
            priceBreakdown.shippingFee == 0
                ? '免运费'
                : '¥${priceBreakdown.shippingFee.toStringAsFixed(2)}',
            secondaryTextColor: secondaryTextColor,
          ),
          if (priceBreakdown.couponDiscount > 0) ...[
            SizedBox(height: 8.w),
            _buildPriceRow(
              context,
              '优惠券抵扣',
              '-¥${priceBreakdown.couponDiscount.toStringAsFixed(2)}',
              secondaryTextColor: secondaryTextColor,
              valueColor: AppColors.success,
            ),
          ],
          if (priceBreakdown.pointsDiscount > 0) ...[
            SizedBox(height: 8.w),
            _buildPriceRow(
              context,
              '积分抵扣',
              '-¥${priceBreakdown.pointsDiscount.toStringAsFixed(2)}',
              secondaryTextColor: secondaryTextColor,
              valueColor: AppColors.success,
            ),
          ],
          Divider(height: 24.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '实付款',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryTextColor,
                    ),
              ),
              Text(
                '¥${priceBreakdown.actualPayment.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: brandColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    BuildContext context,
    String label,
    String value, {
    required Color secondaryTextColor,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: secondaryTextColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: valueColor ?? Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
