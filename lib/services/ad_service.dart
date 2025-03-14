import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdService {
  static const MethodChannel _channel = MethodChannel('transmodel/advertise');
  
  // 单例模式
  static final AdService _instance = AdService._internal();
  
  factory AdService() {
    return _instance;
  }
  
  AdService._internal() {
    _initCallbacks();
  }
  
  void _initCallbacks() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'incentiveVideoCompleted':
          _onIncentiveVideoCompleted();
          break;
        case 'incentiveVideoFailed':
          _onIncentiveVideoFailed();
          break;
        default:
          break;
      }
    });
  }
  
  // 激励视频完成的回调
  void _onIncentiveVideoCompleted() {
    Fluttertoast.showToast(
      msg: "Reward received successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0
    );
    
    // 更新可用次数
    _updateUsageCount(10);
  }
  
  // 激励视频失败的回调
  void _onIncentiveVideoFailed() {
    Fluttertoast.showToast(
      msg: "Failed to get reward, please try again.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }
  
  // 更新使用次数
  Future<void> _updateUsageCount(int additionalCount) async {
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt('usage_count') ?? 5;
    await prefs.setInt('usage_count', count + additionalCount);
  }
  
  // 获取当前可用次数
  Future<int> getUsageCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('usage_count') ?? 5;
  }
  
  // 减少使用次数
  Future<void> decreaseUsageCount() async {
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt('usage_count') ?? 5;
    if (count > 0) {
      await prefs.setInt('usage_count', count - 1);
    }
  }
  
  // 显示横幅广告
  Future<void> displayBannerAd() async {
    try {
      await _channel.invokeMethod('displayBannerAd');
    } catch (e) {
      print('Error displaying banner ad: $e');
    }
  }
  
  // 隐藏横幅广告
  Future<void> concealBannerAd() async {
    try {
      await _channel.invokeMethod('concealBannerAd');
    } catch (e) {
      print('Error concealing banner ad: $e');
    }
  }
  
  // 展示插页广告
  Future<void> presentInterstitialAd() async {
    try {
      await _channel.invokeMethod('presentInterstitialAd');
    } catch (e) {
      print('Error presenting interstitial ad: $e');
    }
  }
  
  // 播放激励视频
  Future<void> playIncentiveVideo() async {
    try {
      await _channel.invokeMethod('playIncentiveVideo');
    } catch (e) {
      print('Error playing incentive video: $e');
    }
  }
  
  // 加载其他广告
  Future<void> loadOtherAd() async {
    try {
      await _channel.invokeMethod('loadOtherAd');
    } catch (e) {
      print('Error loading other ad: $e');
    }
  }
  
  // 广告测试相关方法
  Future<void> presentInterstitialAd1() async {
    try {
      await _channel.invokeMethod('presentInterstitialAd1');
    } catch (e) {
      print('Error presenting interstitial ad 1: $e');
    }
  }
  
  Future<void> presentInterstitialAd2() async {
    try {
      await _channel.invokeMethod('presentInterstitialAd2');
    } catch (e) {
      print('Error presenting interstitial ad 2: $e');
    }
  }
  
  Future<void> presentInterstitialAd3() async {
    try {
      await _channel.invokeMethod('presentInterstitialAd3');
    } catch (e) {
      print('Error presenting interstitial ad 3: $e');
    }
  }
  
  Future<void> playIncentiveVideo1() async {
    try {
      await _channel.invokeMethod('playIncentiveVideo1');
    } catch (e) {
      print('Error playing incentive video 1: $e');
    }
  }
  
  Future<void> playIncentiveVideo2() async {
    try {
      await _channel.invokeMethod('playIncentiveVideo2');
    } catch (e) {
      print('Error playing incentive video 2: $e');
    }
  }
  
  Future<void> playIncentiveVideo3() async {
    try {
      await _channel.invokeMethod('playIncentiveVideo3');
    } catch (e) {
      print('Error playing incentive video 3: $e');
    }
  }
} 