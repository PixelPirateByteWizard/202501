# 摘星猫 (Luvimestra)

一个基于Flutter开发的AI聊天和音频娱乐应用。

## App Store审核问题回复

### 关于Guideline 2.5.4 - Performance - Software Requirements的问题

**问题描述：**
App Store审核团队指出我们的应用在Info.plist中声明了audio后台模式支持，但无法在后台播放音频内容。

**回复邮件模板：**

---

**主题：** Re: Guideline 2.5.4 - Performance - Software Requirements - 摘星猫 App

尊敬的App Store审核团队，

感谢您对我们应用"摘星猫"的审核反馈。

关于Guideline 2.5.4的问题，我们理解您的关切。我们的应用确实包含音频播放功能，具体包括：

1. **音乐播放功能** - 用户可以播放内置的背景音乐
2. **电台功能** - 用户可以收听在线电台流媒体
3. **AI语音对话** - 计划中的语音交互功能

**当前状态说明：**
我们承认当前版本的后台音频播放功能尚未完全实现。为了符合App Store的要求，我们将采取以下措施之一：

**选项1：移除后台音频声明**
- 从Info.plist中移除`audio`后台模式声明
- 应用将仅在前台播放音频

**选项2：完善后台音频功能**
- 实现完整的后台音频播放功能
- 添加媒体控制中心集成
- 确保音频在后台持续播放

我们倾向于选择选项1，因为我们的核心功能是AI聊天，音频播放是辅助功能。我们将在下一个版本中移除不必要的后台音频声明。

**技术细节：**
- 应用主要功能：AI角色聊天、平行时空探索
- 音频功能：前台音乐播放、电台收听
- 不需要后台音频播放来维持核心用户体验

我们将立即提交一个更新版本，移除Info.plist中的audio后台模式声明，以确保应用符合App Store的要求。

如果您需要任何额外的信息或澄清，请随时联系我们。

此致
敬礼

摘星猫开发团队
[您的联系邮箱]
[日期]

---

## 技术解决方案

### 方案1：移除后台音频声明（推荐）

需要修改 `ios/Runner/Info.plist` 文件，移除以下内容：

```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>  <!-- 移除这一行 -->
    <string>fetch</string>
    <string>processing</string>
    <string>remote-notification</string>
</array>
```

### 方案2：实现完整的后台音频播放

如果选择保留后台音频功能，需要：

1. **实现音频会话管理**
```dart
import 'package:audio_session/audio_session.dart';

// 在音频播放前设置音频会话
final session = await AudioSession.instance;
await session.configure(AudioSessionConfiguration.music());
```

2. **添加媒体控制中心支持**
```dart
import 'package:audio_service/audio_service.dart';

// 实现AudioHandler来处理媒体控制
class MyAudioHandler extends BaseAudioHandler {
  // 实现播放控制方法
}
```

3. **确保后台播放连续性**
```dart
// 在AudioPlayer中设置后台播放
await _audioPlayer.setAudioSource(
  AudioSource.uri(Uri.parse(url)),
  preload: true,
);
```

## 当前应用功能

- ✅ AI角色聊天
- ✅ 平行时空探索
- ✅ 前台音乐播放
- ✅ 电台收听
- ❌ 后台音频播放（需要实现或移除声明）

## 开发环境

- Flutter 3.x
- Dart 3.x
- iOS 12.0+
- Android API 21+

## 依赖包

- `audioplayers: ^6.0.0` - 音频播放
- `flutter/material.dart` - UI框架
- 其他依赖见 `pubspec.yaml`

## 构建说明

```bash
# 获取依赖
flutter pub get

# iOS构建
flutter build ios --release

# Android构建
flutter build apk --release
```

## 联系信息

如有技术问题或需要支持，请联系开发团队。