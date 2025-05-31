import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/vibration_service.dart';
import '../services/storage_service.dart';
import 'game_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // Service instances
  final VibrationService _vibrationService = VibrationService();

  // Settings state
  bool _isMusicEnabled = true;
  bool _isSoundEnabled = true;
  bool _isVibrationEnabled = true;

  // High score records
  int _highScore = 0;
  int _maxWave = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
    _initServices();
  }

  Future<void> _initServices() async {
    // Initialize vibration service
    await _vibrationService.init();

    // Load settings
    final settings = await StorageService.loadSettings();

    // Load high score and max wave
    final highScore = await StorageService.loadHighScore();
    final maxWave = await StorageService.loadMaxWave();

    setState(() {
      _isMusicEnabled = settings['musicEnabled'] as bool;
      _isSoundEnabled = settings['soundEnabled'] as bool;
      _isVibrationEnabled = settings['vibrationEnabled'] as bool;
      _highScore = highScore;
      _maxWave = maxWave;
    });
  }

  Future<void> _updateSettings() async {
    // Update settings
    await _vibrationService.setVibrationEnabled(_isVibrationEnabled);

    // Save settings
    await StorageService.saveSettings({
      'musicEnabled': _isMusicEnabled,
      'soundEnabled': _isSoundEnabled,
      'vibrationEnabled': _isVibrationEnabled,
      'difficulty': 'normal', // Default difficulty
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startGame() {
    if (_isVibrationEnabled) {
      _vibrationService.shortVibrate();
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GameScreen()),
    );
  }

  void _showSettingsDialog() {
    if (_isVibrationEnabled) {
      _vibrationService.shortVibrate();
    }

    showDialog(
      context: context,
      builder: (context) => _buildSettingsDialog(),
    );
  }

  void _showInstructionsDialog() {
    if (_isVibrationEnabled) {
      _vibrationService.shortVibrate();
    }

    showDialog(
      context: context,
      builder: (context) => _buildInstructionsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppConstants.startScreenGradient,
        ),
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: child,
            );
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Game title
                _buildGameTitle(),

                const SizedBox(height: 40),

                // High score and max wave
                _buildStats(),

                const SizedBox(height: 40),

                // Start game button
                _buildMenuButton(
                  icon: Icons.play_arrow,
                  label: 'Start Cultivation',
                  onTap: _startGame,
                  isLarge: true,
                ),

                const SizedBox(height: 20),

                // Settings and instructions buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildMenuButton(
                      icon: Icons.settings,
                      label: 'Settings',
                      onTap: _showSettingsDialog,
                    ),
                    const SizedBox(width: 20),
                    _buildMenuButton(
                      icon: Icons.help_outline,
                      label: 'Cultivation Guide',
                      onTap: _showInstructionsDialog,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameTitle() {
    return Column(
      children: [
        // Main title
        Text(
          'Spirit Dream',
          style: AppConstants.headlineLarge.copyWith(
            fontSize: 60,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),

        const SizedBox(height: 8),

        // Subtitle
        Text(
          'Ascend to Immortality Through Cultivation',
          style: AppConstants.headlineMedium.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.amber.shade300,
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Text(
            'Cultivation Records',
            style: AppConstants.titleLarge.copyWith(
              color: Colors.amber.shade300,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatItem(
                'Highest Cultivation: $_highScore',
                Icons.stars,
              ),
              const SizedBox(width: 24),
              _buildStatItem(
                'Highest Tribulation: $_maxWave',
                Icons.flash_on,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String text, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.amber.shade400, size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppConstants.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLarge = false,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: AppConstants.darkTextColor,
        padding: EdgeInsets.symmetric(
          horizontal: isLarge ? 40 : 24,
          vertical: isLarge ? 16 : 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isLarge ? 30 : 20),
        ),
        elevation: isLarge ? 8 : 4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isLarge ? 28 : 20,
            color: Colors.brown.shade800,
          ),
          SizedBox(width: isLarge ? 12 : 8),
          Text(
            label,
            style: TextStyle(
              fontSize: isLarge ? 24 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsDialog() {
    // Create a temporary settings state
    bool tempMusicEnabled = _isMusicEnabled;
    bool tempSoundEnabled = _isSoundEnabled;
    bool tempVibrationEnabled = _isVibrationEnabled;

    return AlertDialog(
      backgroundColor: Colors.black87,
      title: Text(
        'Settings',
        style: AppConstants.titleLarge.copyWith(
          color: Colors.amber,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSwitchTile(
                icon: Icons.music_note,
                label: 'Background Music',
                value: tempMusicEnabled,
                onChanged: (value) {
                  setState(() {
                    tempMusicEnabled = value;
                  });
                },
              ),
              _buildSwitchTile(
                icon: Icons.volume_up,
                label: 'Sound Effects',
                value: tempSoundEnabled,
                onChanged: (value) {
                  setState(() {
                    tempSoundEnabled = value;
                  });
                },
              ),
              _buildSwitchTile(
                icon: Icons.vibration,
                label: 'Vibration',
                value: tempVibrationEnabled,
                onChanged: (value) {
                  setState(() {
                    tempVibrationEnabled = value;
                  });

                  // If vibration is enabled, trigger vibration
                  if (value) {
                    _vibrationService.shortVibrate();
                  }
                },
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Apply new settings
            setState(() {
              _isMusicEnabled = tempMusicEnabled;
              _isSoundEnabled = tempSoundEnabled;
              _isVibrationEnabled = tempVibrationEnabled;
            });
            _updateSettings();
            Navigator.of(context).pop();
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: value ? AppConstants.primaryColor : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppConstants.bodyLarge,
            ),
          ],
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppConstants.primaryColor,
        ),
      ],
    );
  }

  Widget _buildInstructionsDialog() {
    return AlertDialog(
      backgroundColor: Colors.black87,
      title: Text(
        'Cultivation Guide',
        style: AppConstants.titleLarge.copyWith(
          color: Colors.amber,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInstructionSection(
                title: 'Game Objective',
                content:
                    'Defeat various demons and monsters, improve cultivation level, break through tribulations, and embark on the path to immortality.',
              ),
              _buildInstructionSection(
                title: 'Basic Controls',
                content:
                    'Character is fixed in the center position, enemies appear from all sides. Character automatically casts spells at the nearest enemy.',
              ),
              _buildInstructionSection(
                title: 'Cultivation & Enlightenment',
                content:
                    'Defeat enemies to gain cultivation experience, accumulate cultivation to improve character realm. When enlightenment progress is full, you can achieve breakthrough and gain new abilities.',
              ),
              _buildInstructionSection(
                title: 'Spell Types',
                content:
                    'Lightning: Basic spell, can cause stun\nFire: Continuous burning effect\nFrost: Slows enemy speed\nSpirit Energy: Penetrates multiple enemies\nStorm: Knocks back enemies',
              ),
              _buildInstructionSection(
                title: 'Enemy Types',
                content:
                    'Ghost: Fast but fragile, chance to dodge\nDemon Beast: Strong but slow, has damage reduction\nEvil Cultivator: Balanced type, can summon clones\nVengeful Spirit: High damage, can be temporarily invincible\nDemon Lord: Powerful Boss, damage increases when enraged',
              ),
              _buildInstructionSection(
                title: 'Combo System',
                content:
                    'Defeating enemies consecutively increases combo count, providing cultivation experience bonuses',
              ),
              _buildInstructionSection(
                title: 'Tribulations',
                content:
                    'A Demon Lord appears every five waves, after defeating it you enter the next tribulation with increased difficulty',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildInstructionSection({
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppConstants.bodyLarge.copyWith(
              color: AppConstants.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: AppConstants.bodyMedium,
          ),
        ],
      ),
    );
  }
}
