import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wa_o_flutter/core/base/base_page.dart';
import 'package:wa_o_flutter/core/utils/device_util.dart';
import 'package:wa_o_flutter/core/utils/permission_util.dart';
import 'package:wa_o_flutter/core/utils/toast_util.dart';
import 'package:wa_o_flutter/core/utils/url_util.dart';

/// 设备、权限与外部应用能力演示。
class SystemDemoPage extends StatelessWidget {
  const SystemDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseScaffold(
      title: '系统能力',
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.phone_android,
                  size: 32.w,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DeviceUtil.appName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.w),
                      Text(
                        'v${DeviceUtil.appVersion} · ${DeviceUtil.deviceModel}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.w),
          Text(
            '可用操作',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.w),
          _SystemActionTile(
            icon: Icons.info_outline,
            title: '查看设备信息',
            description: '以轻提示展示应用版本与设备型号',
            onTap: () {
              ToastUtil.show(
                '${DeviceUtil.appName} v${DeviceUtil.appVersion} (${DeviceUtil.deviceModel})',
              );
            },
          ),
          SizedBox(height: 12.w),
          const _SystemActionTile(
            icon: Icons.camera_alt_outlined,
            title: '申请相机权限',
            description: '触发系统相机权限申请流程',
            onTap: PermissionUtil.requestCamera,
          ),
          SizedBox(height: 12.w),
          _SystemActionTile(
            icon: Icons.open_in_browser,
            title: '打开 Flutter 官网',
            description: '使用系统浏览器打开外部链接',
            onTap: () => UrlUtil.launchBrowser('https://flutter.dev'),
          ),
        ],
      ),
    );
  }
}

class _SystemActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _SystemActionTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        minTileHeight: 72.w,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
        leading: Icon(icon, size: 24.w, color: theme.colorScheme.primary),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
