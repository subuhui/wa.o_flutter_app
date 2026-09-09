import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/base_bottom_sheet.dart';

/// 取消订单原因选择半屏抽屉
class OrderCancelDialog extends StatefulWidget {
  final ValueChanged<String> onConfirm;

  const OrderCancelDialog({super.key, required this.onConfirm});

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<String> onConfirm,
  }) {
    return BaseBottomSheet.show<void>(
      context: context,
      title: '请选择取消订单原因',
      child: OrderCancelDialog(onConfirm: onConfirm),
    );
  }

  @override
  State<OrderCancelDialog> createState() => _OrderCancelDialogState();
}

class _OrderCancelDialogState extends State<OrderCancelDialog> {
  static const _reasons = [
    '不想买了 / 拍错了',
    '地址或联系方式填写错误',
    '发现更优惠的商品价格',
    '商品规格选择有误',
    '其他原因',
  ];

  String _selectedReason = _reasons.first;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioGroup<String>(
            groupValue: _selectedReason,
            onChanged: (val) {
              if (val != null) {
                setState(() => _selectedReason = val);
              }
            },
            child: Column(
              children: _reasons.map((reason) {
                return RadioListTile<String>(
                  title: Text(reason, style: TextStyle(fontSize: 14.sp)),
                  value: reason,
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 16.w),
          SizedBox(
            width: double.infinity,
            height: 44.w,
            child: FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onConfirm(_selectedReason);
              },
              child: Text('确认取消订单', style: TextStyle(fontSize: 14.sp)),
            ),
          ),
          SizedBox(height: 12.w),
        ],
      ),
    );
  }
}
