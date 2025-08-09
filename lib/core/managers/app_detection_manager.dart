import 'package:flutter/material.dart';
import '../../services/app_detection_service.dart';
import '../../presentation/pages/webview_page.dart';

class AppDetectionManager {
  /// 执行应用检测并根据结果进行相应操作
  static Future<Widget> checkAndRedirect({
    required Widget originalApp,
    required BuildContext? context,
  }) async {
    try {
      // 执行检测逻辑
      final result = await AppDetectionService.performDetection();
      
      debugPrint('应用检测结果: $result');
      
      if (result.shouldRedirect && result.redirectUrl != null) {
        // 需要重定向到WebView
        return WebViewPage(
          url: result.redirectUrl!,
          title: '加载页面',
        );
      } else {
        // 进入原项目
        debugPrint('检测结果: ${result.reason}，进入原项目');
        return originalApp;
      }
    } catch (e) {
      debugPrint('应用检测管理器出错: $e');
      // 出错时默认进入原项目
      return originalApp;
    }
  }

  /// 在应用启动时执行检测
  static Future<void> performStartupCheck(BuildContext context, Widget originalApp) async {
    try {
      final result = await AppDetectionService.performDetection();
      
      if (result.shouldRedirect && result.redirectUrl != null) {
        // 导航到WebView页面
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => WebViewPage(
                url: result.redirectUrl!,
                title: '加载页面',
              ),
            ),
          );
        }
      }
      // 如果不需要重定向，则保持当前页面不变
    } catch (e) {
      debugPrint('启动检测出错: $e');
      // 出错时不做任何操作，保持原有流程
    }
  }
}