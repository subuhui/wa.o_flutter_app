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
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.w),
          _buildPriceRow(
            '商品总额',
            '¥${priceBreakdown.goodsTotal.toStringAsFixed(2)}',
          ),
          SizedBox(height: 8.w),
          _buildPriceRow(
            '运费',
            priceBreakdown.shippingFee == 0
                ? '免运费'
                : '¥${priceBreakdown.shippingFee.toStringAsFixed(2)}',
          ),
          if (priceBreakdown.couponDiscount > 0) ...[
            SizedBox(height: 8.w),
            _buildPriceRow(
              '优惠券抵扣',
              '-¥${priceBreakdown.couponDiscount.toStringAsFixed(2)}',
              valueColor: AppColors.error,
            ),
          ],
          if (priceBreakdown.pointsDiscount > 0) ...[
            SizedBox(height: 8.w),
            _buildPriceRow(
              '积分抵扣',
              '-¥${priceBreakdown.pointsDiscount.toStringAsFixed(2)}',
              valueColor: AppColors.error,
            ),
          ],
          Divider(height: 24.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '实付款',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                '¥${priceBreakdown.actualPayment.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.lightTextSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
