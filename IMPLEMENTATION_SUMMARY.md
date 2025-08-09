# 应用检测功能实现总结

## 已完成的功能

### ✅ 1. 时间戳检测
- 在 `AppDetectionService` 中实现了 `_isTimeValid()` 方法
- 检查当前设备时间是否大于指定的时间戳（2024-01-01 00:00:00 UTC）
- 可以通过修改 `_timestampThreshold` 常量来调整时间阈值

### ✅ 2. 应用安装检测
- **iOS平台**: 使用 URL Schemes 检测应用是否安装
  - 微信: `weixin://`
  - 抖音: `snssdk1128://`
  - 拼多多: `pinduoduo://`
  - TikTok: `musically://`
  - YouTube: `youtube://`
- **Android平台**: 预留了包名检测的接口
- 已在 iOS Info.plist 中添加了必要的 URL Schemes 查询权限

### ✅ 3. 网络连接检测
- 使用 `connectivity_plus` 包检测网络状态
- 实现了 `_waitForNetwork()` 方法，每隔1秒检测一次网络状态
- 只有在网络可用时才会请求API接口

### ✅ 4. API接口请求
- 请求 `https://www.aistarfire.xyz/api/config?id=6749630370`
- 解析返回的JSON数据，提取 `url` 字段
- 验证URL长度是否大于2个字符
- 包含超时处理（10秒）和错误处理

### ✅ 5. WebView页面
- 创建了 `WebViewPage` 组件用于显示从API获取的URL
- 包含加载状态指示器
- 支持页面刷新功能
- 动态更新页面标题
- 包含返回按钮和错误处理

### ✅ 6. 集成到主应用
- 在 `main.dart` 中集成了检测逻辑
- 创建了 `AppDetectionWrapper` 组件作为检测入口
- 应用启动时自动执行检测
- 根据检测结果决定显示原应用还是WebView

## 文件结构

```
lib/
├── services/
│   └── app_detection_service.dart          # 核心检测服务
├── core/
│   ├── managers/
│   │   └── app_detection_manager.dart      # 检测管理器
│   └── utils/
│       ├── app_detection_example.dart      # 使用示例
│       └── detection_test.dart             # 测试工具
├── presentation/
│   └── pages/
│       └── webview_page.dart               # WebView页面
└── main.dart                               # 主入口（已集成）

ios/Runner/Info.plist                       # iOS权限配置（已更新）
pubspec.yaml                                # 依赖配置（已更新）
```

## 使用方法

### 自动模式（已集成）
应用启动时会自动执行检测逻辑，无需额外代码。

### 手动调用
```dart
// 方法1: 检测并返回对应的Widget
final widget = await AppDetectionManager.checkAndRedirect(
  originalApp: YourOriginalApp(),
  context: context,
);

// 方法2: 启动时检测并自动跳转
await AppDetectionManager.performStartupCheck(context, originalApp);
```

## 配置选项

### 修改时间戳阈值
```dart
// 在 AppDetectionService 中修改
static const int _timestampThreshold = 1704067200; // 你的时间戳
```

### 修改API接口
```dart
// 在 AppDetectionService 中修改
static const String _apiUrl = 'https://your-api-url.com/config?id=xxx';
```

### 添加更多应用检测
```dart
// iOS URL Schemes
static const Map<String, String> _iosUrlSchemes = {
  'your-app-scheme://': '应用名称',
  // 添加更多...
};
```

## 依赖包

已添加到 `pubspec.yaml`:
- `connectivity_plus: ^6.0.5` - 网络连接检测
- `webview_flutter: ^4.9.0` - WebView功能
- `url_launcher: ^6.3.0` - URL启动和应用检测
- `http: ^1.4.0` - HTTP请求

## 权限配置

### iOS (已配置)
在 `ios/Runner/Info.plist` 中添加了:
- `LSApplicationQueriesSchemes` - URL Schemes查询权限
- `NSAppTransportSecurity` - 允许HTTP请求

## 测试建议

1. **时间戳测试**: 修改时间戳值测试不同时间条件
2. **应用检测测试**: 在安装/未安装目标应用的设备上测试
3. **网络测试**: 在不同网络环境下测试（WiFi、移动网络、无网络）
4. **API测试**: 测试API返回不同数据的情况
5. **WebView测试**: 测试不同URL的加载情况

## 调试信息

在Debug模式下，所有关键步骤都会输出日志信息，便于调试和问题排查。

## 注意事项

1. **iOS应用检测限制**: iOS 14+对URL Schemes检测有限制，需要在Info.plist中声明
2. **Android应用检测**: 如需完整的Android应用检测，建议添加 `device_apps` 包
3. **网络权限**: 确保应用有网络访问权限
4. **HTTPS**: 如果API使用HTTPS，确保证书有效；如果使用HTTP，需要配置允许明文传输

## 下一步优化建议

1. 添加缓存机制，避免重复检测
2. 添加更详细的错误处理和用户提示
3. 支持更多平台特定的应用检测方式
4. 添加配置文件支持，便于动态修改检测参数
5. 添加单元测试和集成测试

## 完成状态

✅ 所有核心功能已实现并集成到主应用中
✅ 支持iOS平台的应用检测
✅ 网络检测和重试机制已实现
✅ WebView页面已创建并可正常使用
✅ 权限配置已完成
✅ 文档和示例已提供

现在你可以直接运行应用，检测功能会在启动时自动执行！