import 'package:flutter/material.dart';
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '费用明细',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildPriceRow(
            '商品总额',
            '¥${priceBreakdown.goodsTotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 8),
          _buildPriceRow(
            '运费',
            priceBreakdown.shippingFee == 0
                ? '免运费'
                : '¥${priceBreakdown.shippingFee.toStringAsFixed(2)}',
          ),
          if (priceBreakdown.couponDiscount > 0) ...[
            const SizedBox(height: 8),
            _buildPriceRow(
              '优惠券抵扣',
              '-¥${priceBreakdown.couponDiscount.toStringAsFixed(2)}',
              valueColor: AppColors.error,
            ),
          ],
          if (priceBreakdown.pointsDiscount > 0) ...[
            const SizedBox(height: 8),
            _buildPriceRow(
              '积分抵扣',
              '-¥${priceBreakdown.pointsDiscount.toStringAsFixed(2)}',
              valueColor: AppColors.error,
            ),
          ],
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '实付款',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                '¥${priceBreakdown.actualPayment.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
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
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.lightTextSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
