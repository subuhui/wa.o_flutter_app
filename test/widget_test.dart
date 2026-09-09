import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_demo/core/base/base_page.dart';
import 'package:ui_demo/core/network/app_exceptions.dart';
import 'package:ui_demo/core/theme/app_theme.dart';
import 'package:ui_demo/core/widgets/app_refresher.dart';
import 'package:ui_demo/core/widgets/app_state_layout.dart';
import 'package:ui_demo/features/home/data/models/demo_post.dart';
import 'package:ui_demo/features/home/presentation/views/demo_stateful_page.dart';

void main() {
  group('基础架构单元测试与小部件测试', () {
    test('DemoPost JSON 序列化与反序列化测试', () {
      final json = {
        'id': 100,
        'title': '测试标题',
        'body': '测试内容描述',
      };
      final post = DemoPost.fromJson(json);
      expect(post.id, 100);
      expect(post.title, '测试标题');
      expect(post.body, '测试内容描述');

      final serialized = post.toJson();
      expect(serialized['id'], 100);
      expect(serialized['title'], '测试标题');
    });

    test('ViewState 状态流转与布尔判断测试', () {
      const initial = ViewState<int>.initial();
      expect(initial.isInitial, isTrue);
      expect(initial.isLoading, isFalse);

      const loading = ViewState<int>.loading();
      expect(loading.isLoading, isTrue);

      const success = ViewState<int>.success(42);
      expect(success.isSuccess, isTrue);
      expect(success.data, 42);

      const empty = ViewState<int>.empty(errorMessage: '无数据');
      expect(empty.isEmpty, isTrue);

      const error = ViewState<int>.error('发生错误', errorCode: 500);
      expect(error.isError, isTrue);
      expect(error.errorCode, 500);
      expect(error.errorMessage, '发生错误');
    });

    test('AppException 异常类型测试', () {
      const ex = NetworkException('网络异常');
      expect(ex.message, '网络异常');
      expect(ex, isA<AppException>());

      const authEx = UnauthorizedException('未认证', code: 401);
      expect(authEx.code, 401);
    });

    Widget buildTestApp({required Widget child, ThemeData? theme}) {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, _) => MaterialApp(
          theme: theme ?? AppTheme.lightTheme,
          home: child,
        ),
      );
    }

    testWidgets('AppStateLayout 成功状态正常展示子组件', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const Scaffold(
            body: AppStateLayout(
              status: ViewStatus.success,
              child: Text('核心业务内容展示'),
            ),
          ),
        ),
      );

      expect(find.text('核心业务内容展示'), findsOneWidget);
    });

    testWidgets('AppStateLayout 错误状态展示重试按钮并响应点击', (WidgetTester tester) async {
      bool retryClicked = false;

      await tester.pumpWidget(
        buildTestApp(
          theme: AppTheme.lightTheme,
          child: Scaffold(
            body: AppStateLayout(
              status: ViewStatus.error,
              errorMessage: '加载失败，请重试',
              onRetry: () {
                retryClicked = true;
              },
              child: const Text('核心内容'),
            ),
          ),
        ),
      );

      expect(find.text('加载失败，请重试'), findsOneWidget);
      expect(find.text('点击重试'), findsOneWidget);

      await tester.tap(find.text('点击重试'));
      await tester.pump();

      expect(retryClicked, isTrue);
    });

    testWidgets('AppRefresher 正常渲染子组件内容', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestApp(
          theme: AppTheme.lightTheme,
          child: const Scaffold(
            body: AppRefresher(
              child: Text('可刷新列表内容'),
            ),
          ),
        ),
      );

      expect(find.text('可刷新列表内容'), findsOneWidget);
    });

    testWidgets('BaseScaffold 正常渲染标题、安全底部与主体内容', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestApp(
          theme: AppTheme.lightTheme,
          child: const BaseScaffold(
            title: '测试页面标题',
            bottomBar: Text('固定安全底部栏'),
            body: Text('页面主体'),
          ),
        ),
      );

      expect(find.text('测试页面标题'), findsOneWidget);
      expect(find.text('固定安全底部栏'), findsOneWidget);
      expect(find.text('页面主体'), findsOneWidget);
    });

    testWidgets('DemoStatefulPage 基于 BaseConsumerState 正常渲染与自增交互',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: buildTestApp(
            child: const DemoStatefulPage(),
          ),
        ),
      );

      expect(find.text('BaseState 示例页面'), findsOneWidget);
      expect(find.text('本地状态计数值: 1'), findsOneWidget);
      expect(find.text('安全底部提交按钮'), findsOneWidget);

      await tester.tap(find.text('自增计数'));
      await tester.pump();

      expect(find.text('本地状态计数值: 2'), findsOneWidget);
    });

    test('BaseModel.toJsonString 序列化测试', () {
      const post = DemoPost(id: 1, title: '标题', body: '正文');
      final jsonStr = post.toJsonString();
      expect(jsonStr.contains('"id":1'), isTrue);
      expect(jsonStr.contains('"title":"标题"'), isTrue);
    });

    testWidgets('BaseDialog 组件正常渲染标题、内容与确定按钮', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestApp(
          theme: AppTheme.lightTheme,
          child: const Scaffold(
            body: BaseDialog(
              title: '测试弹窗标题',
              content: '测试弹窗说明内容',
              confirmText: '我知道了',
            ),
          ),
        ),
      );

      expect(find.text('测试弹窗标题'), findsOneWidget);
      expect(find.text('测试弹窗说明内容'), findsOneWidget);
      expect(find.text('我知道了'), findsOneWidget);
    });

    testWidgets('BaseBottomSheet 组件正常渲染标题与内容', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestApp(
          theme: AppTheme.lightTheme,
          child: const Scaffold(
            body: BaseBottomSheet(
              title: '测试抽屉标题',
              child: Text('抽屉核心内容'),
            ),
          ),
        ),
      );

      expect(find.text('测试抽屉标题'), findsOneWidget);
      expect(find.text('抽屉核心内容'), findsOneWidget);
    });
  });
}
