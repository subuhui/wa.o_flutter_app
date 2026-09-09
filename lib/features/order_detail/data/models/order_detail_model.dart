import 'package:flutter/foundation.dart';
import '../../../../core/base/base_model.dart';

/// 订单核心状态机枚举
enum OrderStatus {
  unpaid('待付款', '请在规定时间内完成支付'),
  paid('待发货', '商家正在全力备货中'),
  shipped('待收货', '商品正在飞速派送中'),
  completed('已完成', '感谢您的信任，期待再次光临'),
  cancelled('已取消', '订单已超时或用户主动取消'),
  unknown('未知状态', '');

  final String title;
  final String desc;

  const OrderStatus(this.title, this.desc);
}

/// 订单商品项模型
class OrderItem extends BaseModel {
  final int id;
  final String title;
  final String spec; // 规格属性，例如 "暗夜黑 / 512GB"
  final double price;
  final int quantity;
  final String imageUrl;

  const OrderItem({
    required this.id,
    required this.title,
    required this.spec,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      spec: json['spec'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 1,
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'spec': spec,
        'price': price,
        'quantity': quantity,
        'imageUrl': imageUrl,
      };
}

/// 收货地址模型
class ShippingAddress extends BaseModel {
  final String recipientName;
  final String recipientPhone;
  final String provinceCityRegion;
  final String detailedAddress;

  const ShippingAddress({
    required this.recipientName,
    required this.recipientPhone,
    required this.provinceCityRegion,
    required this.detailedAddress,
  });

  String get fullAddress => '$provinceCityRegion $detailedAddress';

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      recipientName: json['recipientName'] as String? ?? '',
      recipientPhone: json['recipientPhone'] as String? ?? '',
      provinceCityRegion: json['provinceCityRegion'] as String? ?? '',
      detailedAddress: json['detailedAddress'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'recipientName': recipientName,
        'recipientPhone': recipientPhone,
        'provinceCityRegion': provinceCityRegion,
        'detailedAddress': detailedAddress,
      };
}

/// 订单价格与优惠明细模型
class PriceBreakdown extends BaseModel {
  final double goodsTotal; // 商品总价
  final double shippingFee; // 运费
  final double couponDiscount; // 优惠券抵扣
  final double pointsDiscount; // 积分抵扣
  final double actualPayment; // 实付金额

  const PriceBreakdown({
    required this.goodsTotal,
    required this.shippingFee,
    required this.couponDiscount,
    required this.pointsDiscount,
    required this.actualPayment,
  });

  factory PriceBreakdown.fromJson(Map<String, dynamic> json) {
    return PriceBreakdown(
      goodsTotal: (json['goodsTotal'] as num?)?.toDouble() ?? 0.0,
      shippingFee: (json['shippingFee'] as num?)?.toDouble() ?? 0.0,
      couponDiscount: (json['couponDiscount'] as num?)?.toDouble() ?? 0.0,
      pointsDiscount: (json['pointsDiscount'] as num?)?.toDouble() ?? 0.0,
      actualPayment: (json['actualPayment'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'goodsTotal': goodsTotal,
        'shippingFee': shippingFee,
        'couponDiscount': couponDiscount,
        'pointsDiscount': pointsDiscount,
        'actualPayment': actualPayment,
      };
}

/// 订单详情完整业务实体
@immutable
class OrderDetailModel extends BaseModel {
  final String orderId;
  final String orderSn; // 订单编号
  final OrderStatus status;
  final String createTime;
  final String? payTime;
  final String? deliveryTime;
  final ShippingAddress address;
  final List<OrderItem> items;
  final PriceBreakdown priceBreakdown;
  final String? logisticsCompany;
  final String? logisticsSn;

  const OrderDetailModel({
    required this.orderId,
    required this.orderSn,
    required this.status,
    required this.createTime,
    this.payTime,
    this.deliveryTime,
    required this.address,
    required this.items,
    required this.priceBreakdown,
    this.logisticsCompany,
    this.logisticsSn,
  });

  OrderDetailModel copyWith({
    String? orderId,
    String? orderSn,
    OrderStatus? status,
    String? createTime,
    String? payTime,
    String? deliveryTime,
    ShippingAddress? address,
    List<OrderItem>? items,
    PriceBreakdown? priceBreakdown,
    String? logisticsCompany,
    String? logisticsSn,
  }) {
    return OrderDetailModel(
      orderId: orderId ?? this.orderId,
      orderSn: orderSn ?? this.orderSn,
      status: status ?? this.status,
      createTime: createTime ?? this.createTime,
      payTime: payTime ?? this.payTime,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      address: address ?? this.address,
      items: items ?? this.items,
      priceBreakdown: priceBreakdown ?? this.priceBreakdown,
      logisticsCompany: logisticsCompany ?? this.logisticsCompany,
      logisticsSn: logisticsSn ?? this.logisticsSn,
    );
  }

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      orderId: json['orderId'] as String? ?? '',
      orderSn: json['orderSn'] as String? ?? '',
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.unknown,
      ),
      createTime: json['createTime'] as String? ?? '',
      payTime: json['payTime'] as String?,
      deliveryTime: json['deliveryTime'] as String?,
      address: ShippingAddress.fromJson(
        json['address'] as Map<String, dynamic>? ?? {},
      ),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      priceBreakdown: PriceBreakdown.fromJson(
        json['priceBreakdown'] as Map<String, dynamic>? ?? {},
      ),
      logisticsCompany: json['logisticsCompany'] as String?,
      logisticsSn: json['logisticsSn'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'orderSn': orderSn,
        'status': status.name,
        'createTime': createTime,
        'payTime': payTime,
        'deliveryTime': deliveryTime,
        'address': address.toJson(),
        'items': items.map((e) => e.toJson()).toList(),
        'priceBreakdown': priceBreakdown.toJson(),
        'logisticsCompany': logisticsCompany,
        'logisticsSn': logisticsSn,
      };
}
