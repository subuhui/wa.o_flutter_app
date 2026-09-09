import '../../../../core/base/base_repository.dart';
import '../../../../core/network/dio_client.dart';
import '../models/order_detail_model.dart';

/// 订单详情数据仓储层
class OrderDetailRepository extends BaseRepository {
  OrderDetailRepository([DioClient? dioClient])
      : super(dioClient ?? DioClient());

  /// 模拟拉取订单详情
  Future<OrderDetailModel> fetchOrderDetail(String orderId) async {
    // 模拟网络延迟 400ms
    await Future<void>.delayed(const Duration(milliseconds: 400));

    return OrderDetailModel(
      orderId: orderId,
      orderSn: 'SN20260909987654321',
      status: OrderStatus.unpaid,
      createTime: '2026-09-09 13:30:15',
      address: const ShippingAddress(
        recipientName: '张三丰',
        recipientPhone: '138****8888',
        provinceCityRegion: '广东省深圳市南山区',
        detailedAddress: '科技园南区高新南一道 88 号大厦 16 层',
      ),
      items: const [
        OrderItem(
          id: 101,
          title: 'Apple iPhone 16 Pro Max 钛金属双卡双待 5G 手机',
          spec: '原色钛金属 / 512GB / 官方标配',
          price: 9999.00,
          quantity: 1,
          imageUrl:
              'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=200',
        ),
        OrderItem(
          id: 102,
          title: 'MagSafe 磁吸透明手机保护壳 (支持无线快充)',
          spec: '全透防摔款 / 环保材质',
          price: 399.00,
          quantity: 1,
          imageUrl:
              'https://images.unsplash.com/photo-1601593346740-925612772716?w=200',
        ),
        OrderItem(
          id: 103,
          title: '35W 双 USB-C 端口紧凑型电源适配器充电头',
          spec: '折叠插脚 / 白色',
          price: 299.00,
          quantity: 2,
          imageUrl:
              'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=200',
        ),
      ],
      priceBreakdown: const PriceBreakdown(
        goodsTotal: 10996.00,
        shippingFee: 0.00,
        couponDiscount: 500.00,
        pointsDiscount: 50.00,
        actualPayment: 10446.00,
      ),
      logisticsCompany: '顺丰速运',
      logisticsSn: 'SF139882910398',
    );
  }

  /// 模拟立即支付操作
  Future<bool> payOrder(String orderId) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return true;
  }

  /// 模拟取消订单
  Future<bool> cancelOrder(String orderId, String reason) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return true;
  }

  /// 模拟确认收货
  Future<bool> confirmReceipt(String orderId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return true;
  }

  /// 模拟提醒发货
  Future<bool> remindShipment(String orderId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return true;
  }
}
