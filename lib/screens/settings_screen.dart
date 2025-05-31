import 'package:flutter/material.dart';
import 'about_app_screen.dart';
import 'help_screen.dart';
import 'user_agreement_screen.dart';
import 'privacy_policy_screen.dart';
import 'feedback_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // 設置狀態
  bool _isVibrationEnabled = true;
  String _selectedDifficulty = 'Normal';

  final List<String> _difficulties = ['Easy', 'Normal', 'Hard', 'Hell'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/backgrounds_5.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildSettingsList(),
              ),
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Game Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.amber.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Game Settings'),
            const SizedBox(height: 16),
            _buildSwitchSetting(
              icon: Icons.vibration,
              title: 'Vibration',
              value: _isVibrationEnabled,
              onChanged: (value) {
                setState(() {
                  _isVibrationEnabled = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildDropdownSetting(
              icon: Icons.shield,
              title: 'Difficulty',
              value: _selectedDifficulty,
              items: _difficulties,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedDifficulty = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('About the Game'),
            const SizedBox(height: 16),
            _buildNavigationItem(
              icon: Icons.info_outline,
              title: 'About Dream Realm',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutAppScreen(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildNavigationItem(
              icon: Icons.help_outline,
              title: 'Help',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpScreen(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildNavigationItem(
              icon: Icons.description_outlined,
              title: 'User Agreement',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserAgreementScreen(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildNavigationItem(
              icon: Icons.security,
              title: 'Privacy Policy',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildNavigationItem(
              icon: Icons.feedback_outlined,
              title: 'Feedback & Suggestions',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FeedbackScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.amber,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchSetting({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.amber.shade200,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.amber,
          activeTrackColor: Colors.amber.withOpacity(0.3),
        ),
      ],
    );
  }

  Widget _buildDropdownSetting<T>({
    required IconData icon,
    required String title,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.amber.shade200,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.amber.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: DropdownButton<T>(
            value: value,
            onChanged: onChanged,
            underline: const SizedBox(),
            dropdownColor: Colors.black.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10),
            iconEnabledColor: Colors.amber,
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  item.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.amber.shade200,
        size: 20,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // Reset settings to default
              setState(() {
                _isVibrationEnabled = true;
                _selectedDifficulty = 'Normal';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Reset Settings'),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              // Save settings and navigate back
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Save Settings'),
          ),
        ],
      ),
    );
  }
}
