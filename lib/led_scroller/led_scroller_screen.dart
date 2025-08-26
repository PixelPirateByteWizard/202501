import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import 'message_model.dart';
import 'led_scroller_controller.dart';
import 'fullscreen_led_page.dart';

class LedScrollerScreen extends StatefulWidget {
  const LedScrollerScreen({super.key});

  @override
  State<LedScrollerScreen> createState() => _LedScrollerScreenState();
}

class _LedScrollerScreenState extends State<LedScrollerScreen>
    with SingleTickerProviderStateMixin {
  final LedScrollerController _controller = LedScrollerController();
  final TextEditingController _textController = TextEditingController();

  late Message _currentMessage;
  late AnimationController _animationController;
  bool _isScrolling = false;
  static const MethodChannel _channel = MethodChannel('verzephronix/ads');
  int _availableCredits = 0; // 简单次数计数

  // Color options
  final List<Color> _textColors = [
    AppConstants.stardustGold,
    AppConstants.cosmicBlue,
    AppConstants.nebulaPurple,
    Colors.red,
    Colors.green,
    Colors.white,
  ];

  final List<Color> _backgroundColors = [
    Colors.black,
    AppConstants.spaceIndigo700,
    AppConstants.spaceIndigo900,
    const Color(0xFF1A237E),
  ];

  int _selectedTextColorIndex = 0;
  int _selectedBackgroundColorIndex = 0;
  double _scrollSpeed = 5.0;

  @override
  void initState() {
    super.initState();

    // Initialize with default message
    _textController.text = 'GO TEAM! 🔥 DEFENSE! 💪 WIN THIS! 🏆';
    _currentMessage = Message.create(
      text: _textController.text,
      textColor: _colorToHex(_textColors[_selectedTextColorIndex]),
      backgroundColor: _colorToHex(
        _backgroundColors[_selectedBackgroundColorIndex],
      ),
      scrollSpeed: _scrollSpeed,
    );

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: _controller.calculateAnimationDuration(_currentMessage),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Convert Color to hex string
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }

  // Convert hex string to Color - keeping for potential future use
  // Color _hexToColor(String hex) {
  //   hex = hex.replaceAll('#', '');
  //   return Color(int.parse('FF$hex', radix: 16));
  // }

  void _updateMessage() {
    setState(() {
      _currentMessage = _controller.createMessage(
        text: _textController.text,
        textColor: _colorToHex(_textColors[_selectedTextColorIndex]),
        backgroundColor: _colorToHex(
          _backgroundColors[_selectedBackgroundColorIndex],
        ),
        scrollSpeed: _scrollSpeed,
      );

      // Update animation duration based on new message
      _animationController.duration = _controller.calculateAnimationDuration(
        _currentMessage,
      );
    });
  }

  void _toggleScrolling() {
    setState(() {
      _isScrolling = !_isScrolling;

      if (_isScrolling) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    });
  }

  Future<void> _handleFullScreenWithRewardFlow() async {
    if (_availableCredits > 0) {
      _availableCredits -= 1;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FullscreenLedPage(
            message: _currentMessage,
            textColor: _textColors[_selectedTextColorIndex],
            backgroundColor: _backgroundColors[_selectedBackgroundColorIndex],
          ),
        ),
      );
      return;
    }

    // 弹窗出现前先显示横幅，确保同步出现
    try { await _channel.invokeMethod('showBanner'); } catch (_) {}

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('No Credits Available'),
          content: const Text(
              'You have no available uses. Watch a video to earn a credit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Watch Video'),
            ),
          ],
        );
      },
    );
    // 关闭弹窗后隐藏横幅（与弹窗一起消失）
    try { await _channel.invokeMethod('hideBanner'); } catch (_) {}

    if (confirmed != true) {
      return; // 取消
    }

    bool watched = false;
    try {
      final res = await _channel.invokeMethod('presentRewarded');
      if (res is bool) {
        watched = res;
      }
    } catch (_) {}

    if (watched) {
      _availableCredits += 1;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Congrats! You earned a credit.')),
        );
      }
      // 自动进入全屏
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FullscreenLedPage(
            message: _currentMessage,
            textColor: _textColors[_selectedTextColorIndex],
            backgroundColor: _backgroundColors[_selectedBackgroundColorIndex],
          ),
        ),
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No reward received.')),
        );
      }
      // 不进入全屏
    }
  }

  void _selectTemplate(String templateText) {
    setState(() {
      _textController.text = templateText;
      _updateMessage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside of text fields
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Text(
                      AppConstants.ledScroller,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.text_fields,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // LED Display preview
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: _backgroundColors[_selectedBackgroundColorIndex],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppConstants.cosmicBlue.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.cosmicBlue.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: -5,
                        // inset is not supported in Flutter's BoxShadow
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Stack(
                          children: [
                            // Scrolling text
                            if (_isScrolling)
                              Positioned(
                                left:
                                    -100 +
                                    (_animationController.value *
                                        (MediaQuery.of(context).size.width +
                                            100)),
                                top: 0,
                                bottom: 0,
                                child: Center(
                                  child: Text(
                                    _currentMessage.text,
                                    style: TextStyle(
                                      color:
                                          _textColors[_selectedTextColorIndex],
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                            // Static text when not scrolling
                            if (!_isScrolling)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Text(
                                    _currentMessage.text,
                                    style: TextStyle(
                                      color:
                                          _textColors[_selectedTextColorIndex],
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Message configuration card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Custom Message',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _textController,
                          maxLength: 100,
                          maxLines: 2,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            hintText: 'Enter your message (max 100 chars)',
                            counterText: '',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => _updateMessage(),
                        ),
                        const SizedBox(height: 16),

                        // Text color selection
                        Text('Text Color', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _textColors.length,
                            itemBuilder: (context, index) {
                              final isSelected =
                                  index == _selectedTextColorIndex;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedTextColorIndex = index;
                                    _updateMessage();
                                  });
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: _textColors[index],
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: _textColors[index]
                                                  .withOpacity(0.5),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Background color selection
                        Text('Background', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _backgroundColors.length,
                            itemBuilder: (context, index) {
                              final isSelected =
                                  index == _selectedBackgroundColorIndex;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedBackgroundColorIndex = index;
                                    _updateMessage();
                                  });
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: _backgroundColors[index],
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: Colors.white.withOpacity(
                                                0.5,
                                              ),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Speed slider
                        Text('Speed', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Slider(
                          min: 1,
                          max: 10,
                          divisions: 9,
                          value: _scrollSpeed,
                          activeColor: theme.colorScheme.secondary,
                          inactiveColor: theme.colorScheme.primary.withOpacity(
                            0.3,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _scrollSpeed = value;
                              _updateMessage();
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // Action buttons
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _toggleScrolling,
                            icon: Icon(
                              _isScrolling ? Icons.pause : Icons.play_arrow,
                            ),
                            label: Text(
                              _isScrolling
                                  ? 'Stop Scrolling'
                                  : 'Start Scrolling',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.secondary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _handleFullScreenWithRewardFlow,
                            icon: const Icon(Icons.fullscreen),
                            label: const Text('Full Screen Mode'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Templates
                Text(
                  'Templates',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                  children: AppConstants.ledTemplates.entries.map((entry) {
                    return Card(
                      child: InkWell(
                        onTap: () => _selectTemplate(entry.value),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.value,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                entry.key,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onBackground
                                      .withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
