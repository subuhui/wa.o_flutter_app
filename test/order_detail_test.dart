import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wa_o_flutter/core/theme/app_theme.dart';
import 'package:wa_o_flutter/features/order_detail/data/models/order_detail_model.dart';
import 'package:wa_o_flutter/features/order_detail/data/repositories/order_detail_repository.dart';
import 'package:wa_o_flutter/features/order_detail/presentation/controllers/order_detail_controller.dart';
import 'package:wa_o_flutter/features/order_detail/presentation/state/order_detail_actions.dart';
import 'package:wa_o_flutter/features/order_detail/presentation/state/order_detail_state.dart';
import 'package:wa_o_flutter/features/order_detail/presentation/views/order_detail_page.dart';

void main() {
  group('订单详情 State + Actions 架构单元测试与部件测试', () {
    test('OrderDetailModel JSON 序列化与反序列化测试', () {
      final json = {
        'orderId': 'OD100',
        'orderSn': 'SN123456',
        'status': 'unpaid',
        'createTime': '2026-09-09 12:00:00',
        'address': {
          'recipientName': '李四',
          'recipientPhone': '13900001111',
          'provinceCityRegion': '北京市海淀区',
          'detailedAddress': '中关村南大街 1 号',
        },
        'items': [
          {
            'id': 1,
            'title': '测试商品',
            'spec': '黑色 / 128G',
            'price': 1999.0,
            'quantity': 1,
            'imageUrl': '',
          }
        ],
        'priceBreakdown': {
          'goodsTotal': 1999.0,
          'shippingFee': 0.0,
          'couponDiscount': 100.0,
          'pointsDiscount': 0.0,
          'actualPayment': 1899.0,
        },
      };

      final model = OrderDetailModel.fromJson(json);
      expect(model.orderId, 'OD100');
      expect(model.orderSn, 'SN123456');
      expect(model.status, OrderStatus.unpaid);
      expect(model.address.recipientName, '李四');
      expect(model.items.length, 1);
      expect(model.priceBreakdown.actualPayment, 1899.0);

      final serialized = model.toJson();
      expect(serialized['orderId'], 'OD100');
      expect(serialized['status'], 'unpaid');
    });

    test('OrderDetailState 衍生计算属性 (Getters) 测试', () {
      const emptyState = OrderDetailState();
      expect(emptyState.status, OrderStatus.unknown);
      expect(emptyState.remainingTimeFormatted, '00:00');
      expect(emptyState.availableActions, isEmpty);

      final stateWithSeconds = const OrderDetailState().copyWith(
        remainingPaySeconds: 899,
      );
      expect(stateWithSeconds.remainingTimeFormatted, '14分59秒');

      const order = OrderDetailModel(
        orderId: 'OD1',
        orderSn: 'SN1',
        status: OrderStatus.unpaid,
        createTime: '2026-09-09',
        address: ShippingAddress(
          recipientName: '张三',
          recipientPhone: '138',
          provinceCityRegion: 'A',
          detailedAddress: 'B',
        ),
        items: [
          OrderItem(
            id: 1,
            title: 'A',
            spec: 'S',
            price: 10,
            quantity: 1,
            imageUrl: '',
          ),
          OrderItem(
            id: 2,
            title: 'B',
            spec: 'S',
            price: 20,
            quantity: 1,
            imageUrl: '',
          ),
          OrderItem(
            id: 3,
            title: 'C',
            spec: 'S',
            price: 30,
            quantity: 1,
            imageUrl: '',
          ),
        ],
        priceBreakdown: PriceBreakdown(
          goodsTotal: 60,
          shippingFee: 0,
          couponDiscount: 0,
          pointsDiscount: 0,
          actualPayment: 60,
        ),
      );

      const state = OrderDetailState(
        order: order,
        isProductsExpanded: false,
        runningOperations: {'pay'},
      );

      expect(state.status, OrderStatus.unpaid);
      expect(state.isOperating('pay'), isTrue);
      expect(state.isOperating('cancel'), isFalse);
      expect(state.hasMultipleProducts, isTrue);
      expect(state.displayedProducts.length, 2); // 默认折叠展示前2项
      expect(state.hiddenProductsCount, 1);
      expect(
        state.availableActions.contains(OrderBottomButtonType.payNow),
        isTrue,
      );
      expect(
        state.availableActions.contains(OrderBottomButtonType.cancel),
        isTrue,
      );

      // 展开商品
      final expandedState = state.copyWith(isProductsExpanded: true);
      expect(expandedState.displayedProducts.length, 3);
    });

    test('OrderDetailController 状态流转与业务操作测试', () async {
      final repo = OrderDetailRepository();
      final controller = OrderDetailController('TEST_OD_001', repo);

      // 等待初始化 loadDetail 完成 (400ms)
      await Future<void>.delayed(const Duration(milliseconds: 450));

      expect(controller.state.order, isNotNull);
      expect(controller.state.status, OrderStatus.unpaid);
      expect(controller.state.remainingPaySeconds, greaterThan(0));

      // 测试折叠展开切换
      expect(controller.state.isProductsExpanded, isFalse);
      controller.toggleExpandProducts();
      expect(controller.state.isProductsExpanded, isTrue);

      // 测试 Mock 状态切换为待发货
      controller.switchMockStatus(OrderStatus.paid);
      expect(controller.state.status, OrderStatus.paid);
      expect(controller.state.remainingPaySeconds, 0); // 倒计时已停

      // 测试 Mock 状态切换为已发货
      controller.switchMockStatus(OrderStatus.shipped);
      expect(controller.state.status, OrderStatus.shipped);
      expect(
        controller.state.availableActions
            .contains(OrderBottomButtonType.confirmReceipt),
        isTrue,
      );

      // 测试确认收货
      await controller.confirmReceipt();
      expect(controller.state.status, OrderStatus.completed);
      expect(
        controller.state.availableActions
            .contains(OrderBottomButtonType.reorder),
        isTrue,
      );

      controller.dispose();
    });

    testWidgets('OrderDetailPage 正常加载与展示核心内容部件测试', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) => MaterialApp(
              theme: AppTheme.lightTheme,
              home: const OrderDetailPage(orderId: 'WIDGET_TEST_001'),
            ),
          ),
        ),
      );

      // 初始等待骨架加载完成
      await tester.pump(const Duration(milliseconds: 500));

      // 验证业务标题与状态预览入口
      expect(find.text('订单详情'), findsOneWidget);
      expect(find.byTooltip('切换订单状态'), findsOneWidget);

      // 验证订单状态横幅
      expect(find.text('待付款'), findsWidgets);

      // 验证收货地址
      expect(find.text('张三丰'), findsOneWidget);

      // 验证费用明细
      expect(find.text('费用明细'), findsOneWidget);
      expect(find.text('实付款'), findsOneWidget);

      // 验证底部操作栏按钮
      expect(find.text('立即支付'), findsOneWidget);
      expect(find.text('取消订单'), findsOneWidget);

      // 验证商品折叠按钮并测试点击展开
      expect(find.text('展开剩余 1 件商品'), findsOneWidget);
      await tester.tap(find.text('展开剩余 1 件商品'));
      await tester.pump();
      expect(find.text('收起商品'), findsOneWidget);

      // 卸载组件树并释放 EasyRefresh 与倒计时定时器
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    });
  });
}
