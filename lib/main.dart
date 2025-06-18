import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/start_screen.dart';
import 'services/game_settings_service.dart';

void main() async {
  // 确保 Flutter 绑定已初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 创建并加载设置服务
  final gameSettingsService = GameSettingsService();
  await gameSettingsService.loadSettings();

  // 使用 ChangeNotifierProvider 将设置服务注入到应用中
  runApp(
    ChangeNotifierProvider.value(
      value: gameSettingsService,
      child: const BladeClashApp(),
    ),
  );
}

class BladeClashApp extends StatelessWidget {
  const BladeClashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '神将GO (Blade Clash)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const StartScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
