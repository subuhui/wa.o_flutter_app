import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/order_detail_model.dart';

/// 订单编号与时间信息卡片 (纯 StatelessWidget，零 Riverpod 依赖)
class OrderInfoCard extends StatelessWidget {
  final OrderDetailModel order;
  final ValueChanged<String> onCopyOrderSn;

  const OrderInfoCard({
    super.key,
    required this.order,
    required this.onCopyOrderSn,
  });

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
            '订单信息',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // 订单编号 + 复制按钮
          Row(
            children: [
              const Text(
                '订单编号',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.lightTextSecondary,
                ),
              ),
              const Spacer(),
              Text(
                order.orderSn,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => onCopyOrderSn(order.orderSn),
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '复制',
                    style: TextStyle(fontSize: 11, color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow('创建时间', order.createTime),
          if (order.payTime != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow('支付时间', order.payTime!),
          ],
          if (order.deliveryTime != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow('发货时间', order.deliveryTime!),
          ],
          if (order.logisticsSn != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              '物流单号',
              '${order.logisticsCompany ?? ''} ${order.logisticsSn}',
            ),
          ],
          const SizedBox(height: 8),
          _buildInfoRow('发票信息', '电子发票 (个人)'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
