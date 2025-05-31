import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/storage_service.dart';
import '../services/vibration_service.dart';
import 'game_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _titleAnimation;
  bool _isSettingsOpen = false;
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _vibrationEnabled = true;
  String _difficulty = 'normal';

  int _highScore = 0;
  int _maxWave = 0;

  // 振動服務
  final VibrationService _vibrationService = VibrationService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
    _loadSettings();
    _loadStats();
  }

  Future<void> _loadSettings() async {
    final settings = await StorageService.loadSettings();
    setState(() {
      _soundEnabled = settings['soundEnabled'] as bool;
      _musicEnabled = settings['musicEnabled'] as bool;
      _vibrationEnabled = settings['vibrationEnabled'] as bool;
      _difficulty = settings['difficulty'] as String;
    });

    // 设置振动
    await _vibrationService.setVibrationEnabled(_vibrationEnabled);
  }

  Future<void> _loadStats() async {
    final highScore = await StorageService.loadHighScore();
    final maxWave = await StorageService.loadMaxWave();
    setState(() {
      _highScore = highScore;
      _maxWave = maxWave;
    });
  }

  Future<void> _saveSettings() async {
    await StorageService.saveSettings({
      'soundEnabled': _soundEnabled,
      'musicEnabled': _musicEnabled,
      'vibrationEnabled': _vibrationEnabled,
      'difficulty': _difficulty,
    });

    // 更新振动设置
    await _vibrationService.setVibrationEnabled(_vibrationEnabled);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppConstants.startScreenGradient,
        ),
        child: Stack(
          children: [
            _buildBackgroundImage(),
            _isSettingsOpen ? _buildSettingsPanel() : _buildMainContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.3,
        child: Container(
          color: const Color(0xFF052E16),
          child: const Center(
            child: Icon(
              Icons.landscape,
              size: 200,
              color: Color(0xFFA7F3D0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return AnimatedBuilder(
      animation: _titleAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _titleAnimation.value,
          child: Transform.translate(
            offset: Offset(0, (1 - _titleAnimation.value) * 50),
            child: child,
          ),
        );
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppConstants.appName,
              style: AppConstants.headlineLarge.copyWith(fontSize: 56),
            ),
            const SizedBox(height: 16),
            Text(
              '踏上修行之路，抵禦萬千邪魔。',
              style: AppConstants.bodyLarge.copyWith(
                color: Colors.green.shade200,
              ),
            ),
            if (_maxWave > 0) ...[
              const SizedBox(height: 16),
              Text(
                '最高修為: $_highScore | 最高劫數: $_maxWave',
                style: AppConstants.bodyMedium.copyWith(
                  color: Colors.amber.shade200,
                ),
              ),
            ],
            const SizedBox(height: 40),
            _buildMainButton(
              text: '開始試煉',
              icon: Icons.play_arrow,
              onTap: _startGame,
            ),
            const SizedBox(height: 16),
            _buildMainButton(
              text: '玄境設定',
              icon: Icons.settings,
              isSecondary: true,
              onTap: () {
                if (_vibrationEnabled) {
                  _vibrationService.shortVibrate();
                }
                setState(() {
                  _isSettingsOpen = true;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
    bool isSecondary = false,
  }) {
    return ElevatedButton(
      onPressed: () {
        if (_vibrationEnabled) {
          _vibrationService.shortVibrate();
        }
        onTap();
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
        backgroundColor: isSecondary
            ? Colors.grey.shade800.withOpacity(0.8)
            : AppConstants.primaryColor,
        foregroundColor:
            isSecondary ? Colors.white : AppConstants.darkTextColor,
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        elevation: 8,
        shadowColor: isSecondary
            ? Colors.black45
            : AppConstants.primaryColor.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSecondary ? Colors.grey.shade600 : const Color(0xFFFDE68A),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildSettingsPanel() {
    return Center(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppConstants.primaryColor.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '玄境設定',
                  style: AppConstants.headlineMedium.copyWith(fontSize: 24),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    if (_vibrationEnabled) {
                      _vibrationService.shortVibrate();
                    }
                    setState(() {
                      _isSettingsOpen = false;
                    });
                    _saveSettings();
                  },
                ),
              ],
            ),
            const Divider(color: Colors.grey),
            const SizedBox(height: 16),
            _buildSettingSwitch(
              text: '音效',
              value: _soundEnabled,
              onChanged: (value) {
                setState(() {
                  _soundEnabled = value;
                });
                if (_vibrationEnabled) {
                  _vibrationService.shortVibrate();
                }
              },
            ),
            _buildSettingSwitch(
              text: '音樂',
              value: _musicEnabled,
              onChanged: (value) {
                setState(() {
                  _musicEnabled = value;
                });
                if (_vibrationEnabled) {
                  _vibrationService.shortVibrate();
                }
              },
            ),
            _buildSettingSwitch(
              text: '震動',
              value: _vibrationEnabled,
              onChanged: (value) {
                if (_vibrationEnabled) {
                  _vibrationService.shortVibrate();
                }
                setState(() {
                  _vibrationEnabled = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildDifficultySelector(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_vibrationEnabled) {
                  _vibrationService.shortVibrate();
                }
                setState(() {
                  _isSettingsOpen = false;
                });
                _saveSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: AppConstants.darkTextColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text('確認'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSwitch({
    required String text,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: AppConstants.bodyLarge),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppConstants.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('難度', style: AppConstants.bodyLarge),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDifficultyButton('簡單', 'easy'),
            _buildDifficultyButton('普通', 'normal'),
            _buildDifficultyButton('困難', 'hard'),
          ],
        ),
      ],
    );
  }

  Widget _buildDifficultyButton(String label, String value) {
    final isSelected = _difficulty == value;

    return ElevatedButton(
      onPressed: () {
        if (_vibrationEnabled) {
          _vibrationService.shortVibrate();
        }
        setState(() {
          _difficulty = value;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? AppConstants.primaryColor : Colors.grey.shade800,
        foregroundColor: isSelected ? AppConstants.darkTextColor : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(label),
    );
  }

  void _startGame() {
    if (_vibrationEnabled) {
      _vibrationService.shortVibrate();
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const GameScreen(),
      ),
    );
  }
}
