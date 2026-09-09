import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            '订单信息',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.w),
          // 订单编号 + 复制按钮
          Row(
            children: [
              Text(
                '订单编号',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.lightTextSecondary,
                ),
              ),
              const Spacer(),
              Text(
                order.orderSn,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 8.w),
              InkWell(
                onTap: () => onCopyOrderSn(order.orderSn),
                borderRadius: BorderRadius.circular(4.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    '复制',
                    style: TextStyle(fontSize: 11.sp, color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.w),
          _buildInfoRow('创建时间', order.createTime),
          if (order.payTime != null) ...[
            SizedBox(height: 8.w),
            _buildInfoRow('支付时间', order.payTime!),
          ],
          if (order.deliveryTime != null) ...[
            SizedBox(height: 8.w),
            _buildInfoRow('发货时间', order.deliveryTime!),
          ],
          if (order.logisticsSn != null) ...[
            SizedBox(height: 8.w),
            _buildInfoRow(
              '物流单号',
              '${order.logisticsCompany ?? ''} ${order.logisticsSn}',
            ),
          ],
          SizedBox(height: 8.w),
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
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.lightTextSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
