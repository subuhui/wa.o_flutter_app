import 'package:flutter/material.dart';
import 'package:ui_demo/core/base/base_page.dart';

/// 示例详情页：演示 BaseConsumerStatefulWidget 与 BaseConsumerState 的继承使用
class DemoStatefulPage extends BaseConsumerStatefulWidget {
  const DemoStatefulPage({super.key});

  @override
  ConsumerState<DemoStatefulPage> createState() => _DemoStatefulPageState();
}

class _DemoStatefulPageState extends BaseConsumerState<DemoStatefulPage> {
  int _counter = 0;

  @override
  String get title => 'BaseState 示例页面';

  @override
  List<Widget>? buildActions() {
    return [
      IconButton(
        icon: const Icon(Icons.info_outline),
        onPressed: () => showToast('点击了详情信息'),
      ),
    ];
  }

  @override
  void initData() {
    // 💡 生命周期初始化回调 (在 initState 中被自动调用)
    _counter = 1;
  }

  @override
  Widget? buildBottomBar(BuildContext context) {
    // 💡 底部安全操作栏：自动垫高防遮挡
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: FilledButton(
        onPressed: () {
          showLoading(msg: '正在保存...');
          Future<void>.delayed(const Duration(seconds: 1), () {
            dismissLoading();
            showSuccess('保存成功！当前计数: $_counter');
          });
        },
        child: const Text('安全底部提交按钮'),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '此页面继承自 BaseConsumerStatefulWidget',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            '本地状态计数值: $_counter',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _counter++;
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('自增计数'),
          ),
        ],
      ),
    );
  }
}
