/// 页面通用五态枚举
enum ViewStatus {
  initial,
  loading,
  success,
  empty,
  error,
}

/// 统一泛型页面状态封装
class ViewState<T> {
  final ViewStatus status;
  final T? data;
  final String? errorMessage;
  final int? errorCode;

  const ViewState({
    required this.status,
    this.data,
    this.errorMessage,
    this.errorCode,
  });

  /// 初始状态
  const ViewState.initial()
      : status = ViewStatus.initial,
        data = null,
        errorMessage = null,
        errorCode = null;

  /// 加载中状态 (可附带当前已有的旧数据以供骨架屏展示)
  const ViewState.loading({this.data})
      : status = ViewStatus.loading,
        errorMessage = null,
        errorCode = null;

  /// 成功状态
  const ViewState.success(this.data)
      : status = ViewStatus.success,
        errorMessage = null,
        errorCode = null;

  /// 空数据状态
  const ViewState.empty({this.errorMessage = '暂无相关数据'})
      : status = ViewStatus.empty,
        data = null,
        errorCode = null;

  /// 失败/异常状态
  const ViewState.error(this.errorMessage, {this.errorCode, this.data})
      : status = ViewStatus.error;

  /// 快捷状态判断
  bool get isInitial => status == ViewStatus.initial;
  bool get isLoading => status == ViewStatus.loading;
  bool get isSuccess => status == ViewStatus.success;
  bool get isEmpty => status == ViewStatus.empty;
  bool get isError => status == ViewStatus.error;

  ViewState<T> copyWith({
    ViewStatus? status,
    T? data,
    String? errorMessage,
    int? errorCode,
  }) {
    return ViewState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  @override
  String toString() =>
      'ViewState(status: $status, data: $data, error: $errorMessage)';
}
