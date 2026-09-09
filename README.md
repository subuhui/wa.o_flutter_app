# wa.o_flutter_app

<p align="center">
  <strong>基于 Flutter 3.47 + Riverpod 的现代化企业级跨平台工程架构与状态流转实战脚手架</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.47.0-02569B?logo=flutter" alt="Flutter 3.47" />
  <img src="https://img.shields.io/badge/Dart-3.13.0-0175C2?logo=dart" alt="Dart 3.13" />
  <img src="https://img.shields.io/badge/State_Management-Riverpod_2.6.1-purple" alt="Riverpod" />
  <img src="https://img.shields.io/badge/Router-GoRouter_14.8.1-blue" alt="GoRouter" />
  <img src="https://img.shields.io/badge/Network-Dio_5.8.0-green" alt="Dio" />
  <img src="https://img.shields.io/badge/Storage-MMKV_3.4.0-orange" alt="MMKV" />
  <img src="https://img.shields.io/badge/Analysis-Strict_Mode_Pass-success" alt="Analysis Strict" />
</p>

---

## 📖 项目简介

`wa.o_flutter_app` 是一套兼具**高性能、高可维护性、零框架强耦合**特性的 Flutter 企业级工程标准脚手架。

本项目重点攻克了中大型 Flutter 应用中状态管理混乱、子组件依赖蔓延、频繁无谓重绘等痛点，确立并落地了核心架构哲学：

> **“隔离 Riverpod，而不是继承 Riverpod；Riverpod 到 Page 为止，UI 子组件尽可能全是纯 Flutter StatelessWidget，通过不可变 State + Actions 回调包驱动。”**

---

## ✨ 核心特性与工程亮点

### 1. ⚡ State + Actions 复杂页面状态流转（以订单详情实战为例）
- **UI 彻底纯化**：页面内部所有的子卡片组件均为标准 `StatelessWidget`，不持有 `WidgetRef`，不 import 任何状态管理包，通过 `Actions` 回调包以原生函数引用触发业务操作。
- **高频倒计时局部阻断重绘**：通过 `ref.watch(provider.select(...))` 纳秒级切片，15 分钟待支付倒计时（每秒跳动）被完全隔离在头部组件内，页面其他所有的地址卡片、商品列表、费用明细全部 **0 次重绘**！
- **操作级独立 Loading (`runningOperations`)**：摒弃粗暴的全屏大菊花遮罩，点击“立即支付”或“确认收货”时，仅对应按钮内部展示小型进度指示器，用户可继续浏览页面。
- **计算属性原子收敛**：动态按钮推导（`availableActions`）、剩余时间格式化（`remainingTimeFormatted`）、商品隐藏数量等全部收敛在 `OrderDetailState` 的 `getters` 中，UI 纯粹无脑渲染。

### 2. 🌐 工业级网络通信层 (Networking)
- 基于 **Dio 5.8** 深度封装，包含全套拦截器流水线：
  - `TokenInterceptor`：自动注入 JWT Token，支持无感过期换票机制。
  - `LoggingInterceptor`：格式化输出请求路径、Query 参数、Request Body、响应耗时与数据。
  - `ErrorInterceptor`：捕获 HTTP 400/401/403/404/500、连接超时、SSL 异常并转换为强类型 `AppException`。
- 提供统一包装类 `ApiResponse<T>` 与标准泛型安全解包 `safeApiCall`。

### 3. 💾 离线优先双模存储 (Storage)
- **Tencent MMKV**：采用 mmap 内存映射技术的高性能键值存储（性能比传统 `SharedPreferences` 快 100 倍以上），内置支持 `Stale-While-Revalidate` 离线优先秒开缓存策略。
- **Flutter Secure Storage**：集成 Keychain (iOS) 与 KeyStore/EncryptedSharedPreferences (Android)，专门用于用户敏感凭据与 Token 加密存储。

### 4. 🏗️ 标准化基类与组件规范 (Base Components)
- **`BaseScaffold`**：统一集成自定义 AppBar、自适应 iPhone 底部安全区域（`bottomBar`）、点击空白处自动收起软键盘、页面加载五态（初始、加载中、成功、空数据、错误重试）。
- **`BaseState / BaseConsumerState`**：自动释放 Controller/FocusNode、提供页面级软键盘收起、挂载通用 App 状态机。
- **`BaseDialog / BaseBottomSheet`**：自适应暗黑模式的统一设计规范确认对话框与半屏抽屉面板。
- **`AppRefresher`**：集成 **EasyRefresh 3.5.1**，提供高度平滑的阻尼下拉刷新与上拉分页能力。

### 5. 🛠️ 严格静态类型分析与质量保障
- 开启最高级别静态分析规则（`strict-casts: true`, `strict-inference: true`, `strict-raw-types: true`）。
- 全量自动化单元测试与部件测试 100% 通过。

---

## 📂 项目目录结构

```text
lib/
├── app.dart                                # 应用顶级配置 (MaterialApp.router、主题、语言等)
├── main.dart                               # 应用程序入口
├── core/                                   # 全局核心基础库 (与业务无关)
│   ├── base/                               # 基础基类
│   │   ├── base_model.dart                 # 模型基类 (toJsonString 等)
│   │   ├── base_page.dart                  # 通用 Base 聚合导出头文件
│   │   ├── base_pagination_notifier.dart   # 通用分页控制器基类
│   │   ├── base_repository.dart            # 数据仓库基类 (含离线秒开缓存策略)
│   │   ├── base_scaffold.dart              # 通用页面脚手架 (安全底部/收起键盘/AppBar)
│   │   ├── base_state.dart                 # 通用 Widget State 生命周期基类
│   │   ├── base_state_notifier.dart        # 通用业务状态机基类
│   │   └── view_state.dart                 # 页面加载五态封装 (initial, loading, success, empty, error)
│   ├── constants/                          # 路由常量、API 接口常量、存储 Key
│   ├── network/                            # 网络模块 (DioClient, Interceptors, Exceptions)
│   ├── router/                             # 路由模块 (GoRouter 配置与路径映射)
│   ├── storage/                            # 本地存储 (MMKV, SecureStorage)
│   ├── theme/                              # 视觉设计系统 (色彩调色板, 主题规范, 字体层级)
│   ├── utils/                              # 通用工具 (LogUtil, ToastUtil, DeviceUtil, PermissionUtil 等)
│   └── widgets/                            # 全局通用展示组件 (AppRefresher, AppStateLayout, BaseDialog 等)
│
└── features/                               # 业务功能模块 (Clean Architecture)
    ├── home/                               # 首页基础能力演示
    │   ├── data/                           # 数据模型与仓储
    │   └── presentation/                   # 控制器、页面与独立子组件
    └── order_detail/                       # 订单详情核心业务实战 (State + Actions 范式)
        ├── data/
        │   ├── models/order_detail_model.dart       # 完整订单数据实体与状态机枚举
        │   └── repositories/order_detail_repository.dart # 数据仓储与 Mock 接口
        └── presentation/
            ├── controllers/order_detail_controller.dart  # 业务控制器 (管理秒级定时器与状态机)
            ├── state/
            │   ├── order_detail_state.dart          # 不可变页面状态 (含 getters 衍生计算)
            │   └── order_detail_actions.dart        # 动作回调聚合包 (Actions Bundle)
            ├── views/order_detail_page.dart         # 页面唯一 ConsumerWidget (Riverpod 适配层)
            └── widgets/                             # 纯 StatelessWidget 子组件集
                ├── order_status_header.dart         # 状态横幅 (局部精准监听倒计时)
                ├── order_address_card.dart          # 收货地址卡片
                ├── order_product_section.dart       # 商品清单卡片 (支持折叠展开)
                ├── order_price_card.dart            # 费用明细卡片
                ├── order_info_card.dart             # 订单编号与时间卡片 (一键复制)
                ├── order_bottom_action_bar.dart     # 底部操作栏 (动态按钮与独立 Loading)
                └── order_cancel_dialog.dart         # 取消原因选择半屏抽屉
```

---

## 🚀 架构范式对比速查

### 传统 Riverpod 常见反模式 (MVVM / Controller RPC 风格)
```dart
// ❌ 痛点：每个子组件到处 ConsumerWidget，依赖 WidgetRef 并频繁 ref.read
class OrderItemButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      // 深度强耦合特定 Provider 和方法，子组件无法独立复用或脱离 Riverpod 测试
      onPressed: () => ref.read(orderProvider.notifier).payOrder(item.id),
      child: const Text('支付'),
    );
  }
}
```

### 本项目推荐范式 (State + Actions 回调包驱动)
```dart
// 1. 定义动作回调聚合包 (纯 Dart 类)
class OrderDetailActions {
  final VoidCallback onPayNow;
  final ValueChanged<String> onCancelOrder;
  final VoidCallback onConfirmReceipt;
  ...
}

// 2. Page 作为唯一的 ConsumerWidget 进行方法引用绑定
class OrderDetailPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(orderDetailControllerProvider.notifier);

    final actions = OrderDetailActions(
      onPayNow: notifier.payNow,
      onCancelOrder: notifier.cancelOrder,
      onConfirmReceipt: notifier.confirmReceipt,
      ...
    );

    return BaseScaffold(
      body: OrderProductSection(actions: actions),
      bottomBar: OrderBottomActionBar(actions: actions),
    );
  }
}

// 3. 子组件是纯粹的 StatelessWidget，通过 actions 像调用普通回调一样使用
class OrderBottomActionBar extends StatelessWidget {
  final OrderDetailActions actions;
  ...
  onPressed: actions.onPayNow, // 零 Riverpod 依赖，清晰、可测、解耦
}
```

---

## 💻 本地开发与运行指南

### 环境要求
- **Flutter SDK**：`3.47.0` (推荐使用 [FVM](https://fvm.app/))
- **Dart SDK**：`3.13.0` 或更高

### 1. 依赖安装
```bash
# 使用 FVM (推荐)
fvm flutter pub get

# 或使用全局 Flutter
flutter pub get
```

### 2. 本地运行
```bash
# 启动项目调试 (可指定设备如 Chrome、macOS、iOS Simulator 或 Android Emulator)
fvm flutter run
```

### 3. 代码格式化与质量检查
```bash
# 格式化所有代码
fvm dart format .

# 执行严格静态代码分析 (0 issues found)
fvm flutter analyze
```

### 4. 运行全量自动化测试
```bash
# 执行所有单元测试与小部件测试 (15/15 Passed)
fvm flutter test
```

---

## 📄 开源许可证

本项目基于 [MIT License](LICENSE) 开源发布。
