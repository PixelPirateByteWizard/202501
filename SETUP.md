# 排序物語 - 快速启动指南

## 环境要求

- Flutter SDK 3.1.0 或更高版本
- Dart SDK
- Android Studio 或 VS Code (推荐安装Flutter插件)

## 快速开始

1. **检查Flutter环境**
   ```bash
   flutter doctor
   ```

2. **获取依赖**
   ```bash
   flutter pub get
   ```

3. **运行应用**
   ```bash
   # 在模拟器或真机上运行
   flutter run
   
   # 或者指定设备
   flutter run -d <device_id>
   ```

4. **构建发布版本**
   ```bash
   # Android APK
   flutter build apk --release
   
   # iOS (需要Mac环境)
   flutter build ios --release
   ```

## 项目结构说明

- `lib/main.dart` - 应用入口点
- `lib/models/` - 数据模型定义
- `lib/services/` - 业务逻辑服务
- `lib/widgets/` - 可复用UI组件
- `lib/screens/` - 页面级组件
- `lib/utils/` - 工具类和常量

## 开发调试

- 使用 `flutter run --debug` 启动调试模式
- 在IDE中设置断点进行调试
- 使用 `flutter logs` 查看日志输出
- 使用 `r` 热重载，`R` 热重启

## 常见问题

1. **依赖问题**: 运行 `flutter clean && flutter pub get`
2. **构建失败**: 检查Flutter版本和SDK配置
3. **模拟器问题**: 确保Android/iOS模拟器正常运行

## 游戏特色

- 流畅的液体动画效果
- 直观的触摸交互
- 渐进式难度设计
- 本地进度保存
- 响应式UI设计

享受游戏吧！🎮