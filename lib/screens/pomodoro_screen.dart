import 'dart:async';
import 'package:flutter/material.dart';
import '../models/pomodoro_model.dart';
import '../utils/time_utils.dart';
import '../utils/storage_utils.dart';
import '../widgets/timer_widget.dart';
import '../app.dart'; // Add import for app.dart
import 'package:shared_preferences/shared_preferences.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({Key? key}) : super(key: key);

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  // Pomodoro timer states
  PomodoroSettings settings =
      PomodoroSettings(); // Initialize with default values
  bool _isSettingsLoaded = false;
  Timer? _timer;
  int _currentTime = 0; // in seconds
  int _totalTime = 0; // in seconds
  TimerMode _timerMode = TimerMode.work;
  String _timerStatus = 'Start Working';
  bool _isPlaying = false;
  int _cyclesCompleted = 0;
  int _totalFocusSeconds = 0;

  // Sound and vibration settings
  bool _soundEnabled = true;
  bool _vibrationEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadNotificationSettings();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    try {
      final loadedSettings = await StorageUtils.getPomodoroSettings();
      setState(() {
        settings = loadedSettings;
        _isSettingsLoaded = true;
        _resetTimer(TimerMode.work);
      });
    } catch (e) {
      setState(() {
        _isSettingsLoaded = true;
        _resetTimer(TimerMode.work);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load settings: $e')),
      );
    }
  }

  Future<void> _loadNotificationSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _soundEnabled = prefs.getBool('sound_enabled') ?? true;
        _vibrationEnabled = prefs.getBool('vibration_enabled') ?? false;
      });
    } catch (e) {
      // Fallback to defaults if loading fails
    }
  }

  Future<void> _saveNotificationSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sound_enabled', _soundEnabled);
      await prefs.setBool('vibration_enabled', _vibrationEnabled);
    } catch (e) {
      // Handle errors silently
    }
  }

  void _resetTimer(TimerMode mode, {bool resetCycles = false}) {
    _timer?.cancel();
    if (resetCycles) {
      setState(() {
        _cyclesCompleted = 0;
      });
    }

    setState(() {
      _timerMode = mode;
      _isPlaying = false;

      // Set timer duration based on mode
      switch (mode) {
        case TimerMode.work:
          _currentTime = settings.workDuration * 60;
          _totalTime = settings.workDuration * 60;
          _timerStatus = 'Start Working';
          break;
        case TimerMode.shortBreak:
          _currentTime = settings.breakDuration * 60;
          _totalTime = settings.breakDuration * 60;
          _timerStatus = 'Take a Break';
          break;
        case TimerMode.longBreak:
          _currentTime = settings.longBreakDuration * 60;
          _totalTime = settings.longBreakDuration * 60;
          _timerStatus = 'Long Break';
          break;
      }
    });
  }

  void _startTimer() {
    setState(() {
      _isPlaying = true;
      _timerStatus = _timerMode == TimerMode.work
          ? 'Focusing...'
          : (_timerMode == TimerMode.shortBreak
              ? 'Break Time...'
              : 'Long Break...');
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentTime > 0) {
          _currentTime--;
          if (_timerMode == TimerMode.work) {
            _totalFocusSeconds++;
          }
        } else {
          _onTimerFinished();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _timerStatus = 'Paused';
    });
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _pauseTimer();
    } else {
      _startTimer();
    }
  }

  void _skipTimer() {
    _onTimerFinished();
  }

  void _onTimerFinished() {
    _timer?.cancel();

    if (_timerMode == TimerMode.work) {
      // Record completed session
      final session = PomodoroSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Pomodoro #${_cyclesCompleted + 1}',
        duration: formatTime(_totalTime),
        completedAt: DateTime.now(),
      );
      StorageUtils.savePomodoroSession(session);

      // Show notification about session recorded
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Session recorded! Check the History tab.'),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'View History',
            onPressed: () {
              DysphorApp.navigateToTab(2);
            },
          ),
        ),
      );

      setState(() {
        _cyclesCompleted++;
      });

      // Determine which break to take
      if (_cyclesCompleted % settings.sessionsBeforeLongBreak == 0) {
        _resetTimer(TimerMode.longBreak);
      } else {
        _resetTimer(TimerMode.shortBreak);
      }
    } else {
      // Break finished, start work
      _resetTimer(TimerMode.work);
    }
  }

  void _toggleSound() {
    setState(() {
      _soundEnabled = !_soundEnabled;
    });
    _saveNotificationSettings();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_soundEnabled ? 'Sound enabled' : 'Sound disabled'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _toggleVibration() {
    setState(() {
      _vibrationEnabled = !_vibrationEnabled;
    });
    _saveNotificationSettings();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            _vibrationEnabled ? 'Vibration enabled' : 'Vibration disabled'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showQuickSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF24263A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Quick Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildQuickToggle(
                    'Sound',
                    _soundEnabled,
                    (value) {
                      setState(() {
                        _soundEnabled = value;
                      });
                      this.setState(() {
                        _soundEnabled = value;
                      });
                    },
                    Icons.volume_up,
                  ),
                  const SizedBox(height: 12),
                  _buildQuickToggle(
                    'Vibration',
                    _vibrationEnabled,
                    (value) {
                      setState(() {
                        _vibrationEnabled = value;
                      });
                      this.setState(() {
                        _vibrationEnabled = value;
                      });
                    },
                    Icons.vibration,
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _resetTimer(TimerMode.work, resetCycles: true);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF7F5AF0)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Reset Timer'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showCycleSettings(BuildContext context) {
    final List<Map<String, dynamic>> presetModes = [
      {
        'name': 'Classic Pomodoro',
        'work': 25,
        'break': 5,
        'longBreak': 15,
        'sessions': 4,
        'icon': Icons.timer_outlined,
      },
      {
        'name': 'Short Focus',
        'work': 15,
        'break': 3,
        'longBreak': 10,
        'sessions': 4,
        'icon': Icons.hourglass_bottom,
      },
      {
        'name': 'Long Focus',
        'work': 45,
        'break': 8,
        'longBreak': 20,
        'sessions': 3,
        'icon': Icons.access_time_filled,
      },
      {
        'name': 'Custom',
        'work': settings.workDuration,
        'break': settings.breakDuration,
        'longBreak': settings.longBreakDuration,
        'sessions': settings.sessionsBeforeLongBreak,
        'icon': Icons.tune,
      },
    ];

    int workDuration = settings.workDuration;
    int breakDuration = settings.breakDuration;
    int longBreakDuration = settings.longBreakDuration;
    int sessionsBeforeLongBreak = settings.sessionsBeforeLongBreak;
    String selectedPreset = 'Custom';

    // Find if current settings match a preset
    for (var preset in presetModes) {
      if (preset['work'] == settings.workDuration &&
          preset['break'] == settings.breakDuration &&
          preset['longBreak'] == settings.longBreakDuration &&
          preset['sessions'] == settings.sessionsBeforeLongBreak) {
        selectedPreset = preset['name'];
        break;
      }
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Color(0xFF24263A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Pomodoro Cycle Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          const Text(
                            'Preset Modes',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: presetModes.length,
                              itemBuilder: (context, index) {
                                final preset = presetModes[index];
                                final isSelected =
                                    selectedPreset == preset['name'];

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedPreset = preset['name'];
                                      workDuration = preset['work'];
                                      breakDuration = preset['break'];
                                      longBreakDuration = preset['longBreak'];
                                      sessionsBeforeLongBreak =
                                          preset['sessions'];
                                    });
                                  },
                                  child: Container(
                                    width: 110,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF7F5AF0)
                                              .withOpacity(0.2)
                                          : const Color(0xFF16161A),
                                      borderRadius: BorderRadius.circular(12),
                                      border: isSelected
                                          ? Border.all(
                                              color: const Color(0xFF7F5AF0),
                                              width: 2)
                                          : Border.all(
                                              color: Colors.transparent,
                                              width: 2),
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          preset['icon'],
                                          color: isSelected
                                              ? const Color(0xFF7F5AF0)
                                              : Colors.white70,
                                          size: 28,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          preset['name'],
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.white70,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${preset['work']}/${preset['break']}/${preset['longBreak']} min',
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white70
                                                : Colors.white38,
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Custom Settings',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDurationSetting(
                            'Work Duration',
                            workDuration,
                            (value) {
                              setState(() {
                                workDuration = value;
                                selectedPreset = 'Custom';
                              });
                            },
                            Icons.work_outline,
                          ),
                          const SizedBox(height: 12),
                          _buildDurationSetting(
                            'Break Duration',
                            breakDuration,
                            (value) {
                              setState(() {
                                breakDuration = value;
                                selectedPreset = 'Custom';
                              });
                            },
                            Icons.free_breakfast,
                          ),
                          const SizedBox(height: 12),
                          _buildDurationSetting(
                            'Long Break Duration',
                            longBreakDuration,
                            (value) {
                              setState(() {
                                longBreakDuration = value;
                                selectedPreset = 'Custom';
                              });
                            },
                            Icons.weekend,
                          ),
                          const SizedBox(height: 12),
                          _buildSessionsSetting(
                            'Sessions Before Long Break',
                            sessionsBeforeLongBreak,
                            (value) {
                              setState(() {
                                sessionsBeforeLongBreak = value;
                                selectedPreset = 'Custom';
                              });
                            },
                            Icons.repeat,
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white70,
                              side: const BorderSide(color: Colors.white30),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final newSettings = PomodoroSettings(
                                workDuration: workDuration,
                                breakDuration: breakDuration,
                                longBreakDuration: longBreakDuration,
                                sessionsBeforeLongBreak:
                                    sessionsBeforeLongBreak,
                              );

                              await StorageUtils.savePomodoroSettings(
                                  newSettings);

                              setState(() {
                                this.setState(() {
                                  settings = newSettings;
                                  _resetTimer(TimerMode.work,
                                      resetCycles: true);
                                });
                              });

                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Settings updated'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7F5AF0),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Apply'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQuickToggle(
    String label,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF7F5AF0),
            size: 22,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF7F5AF0),
            activeTrackColor: const Color(0xFF7F5AF0).withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationSetting(
    String label,
    int value,
    Function(int) onChanged,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF7F5AF0),
            size: 22,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF24263A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 18),
                  color: Colors.white70,
                  onPressed: value > 1 ? () => onChanged(value - 1) : null,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '$value min',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 18),
                  color: Colors.white70,
                  onPressed: value < 120 ? () => onChanged(value + 1) : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsSetting(
    String label,
    int value,
    Function(int) onChanged,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF7F5AF0),
            size: 22,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF24263A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 18),
                  color: Colors.white70,
                  onPressed: value > 1 ? () => onChanged(value - 1) : null,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  width: 45,
                  alignment: Alignment.center,
                  child: Text(
                    '$value',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 18),
                  color: Colors.white70,
                  onPressed: value < 10 ? () => onChanged(value + 1) : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addTestSession() async {
    // Create a test session
    final session = PomodoroSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Test Session #${DateTime.now().second}',
      duration: formatTime(settings.workDuration * 60),
      completedAt: DateTime.now(),
    );

    // Save to storage
    await StorageUtils.savePomodoroSession(session);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test session added! Check the History tab.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16161A),
      appBar: AppBar(
        title: const Text(
          'Pomodoro Timer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF16161A),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: () => _showCycleSettings(context),
          ),
        ],
      ),
      body: !_isSettingsLoaded
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7F5AF0)),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    TimerWidget(
                      currentTime: _currentTime,
                      totalTime: _totalTime,
                      timerMode: _timerMode,
                      status: _timerStatus,
                      isPlaying: _isPlaying,
                      onPlayPause: _togglePlayPause,
                      onReset: () =>
                          _resetTimer(TimerMode.work, resetCycles: true),
                      onSkip: _skipTimer,
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF24263A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF2CB67D),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Completed Sessions',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '$_cyclesCompleted/${settings.sessionsBeforeLongBreak}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF24263A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.timer,
                                color: Color(0xFF7F5AF0),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Total Focus Time',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            formatTotalFocusTime(_totalFocusSeconds),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
