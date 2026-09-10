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
            '订单信息',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 16.sp,
                  color: primaryTextColor,
                ),
          ),
          SizedBox(height: 12.w),
          // 订单编号 + 复制按钮
          Row(
            children: [
              SizedBox(
                width: 72.w,
                child: Text(
                  '订单编号',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: secondaryTextColor,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  order.orderSn,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: primaryTextColor,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              TextButton(
                onPressed: () => onCopyOrderSn(order.orderSn),
                style: TextButton.styleFrom(
                  foregroundColor: brandColor,
                  minimumSize: Size(44.w, 44.w),
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  '复制',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.w),
          _buildInfoRow(
            context,
            '创建时间',
            order.createTime,
            secondaryTextColor: secondaryTextColor,
          ),
          if (order.payTime != null) ...[
            SizedBox(height: 8.w),
            _buildInfoRow(
              context,
              '支付时间',
              order.payTime!,
              secondaryTextColor: secondaryTextColor,
            ),
          ],
          if (order.deliveryTime != null) ...[
            SizedBox(height: 8.w),
            _buildInfoRow(
              context,
              '发货时间',
              order.deliveryTime!,
              secondaryTextColor: secondaryTextColor,
            ),
          ],
          if (order.logisticsSn != null) ...[
            SizedBox(height: 8.w),
            _buildInfoRow(
              context,
              '物流单号',
              '${order.logisticsCompany ?? ''} ${order.logisticsSn}',
              secondaryTextColor: secondaryTextColor,
            ),
          ],
          SizedBox(height: 8.w),
          _buildInfoRow(
            context,
            '发票信息',
            '电子发票 (个人)',
            secondaryTextColor: secondaryTextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    required Color secondaryTextColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 72.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: secondaryTextColor,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
