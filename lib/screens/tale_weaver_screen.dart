import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/plant_advisor_service.dart';
import '../services/ad_service.dart';
import './story_display_screen.dart';

class TaleWeaverScreen extends StatefulWidget {
  const TaleWeaverScreen({super.key});

  @override
  State<TaleWeaverScreen> createState() => _TaleWeaverScreenState();
}

class _TaleWeaverScreenState extends State<TaleWeaverScreen> {
  final TextEditingController _themeController = TextEditingController();
  String _selectedGender = 'Boy';
  String _selectedAgeGroup = '3-6 years';
  String _selectedDuration = '5 minutes';
  String _selectedTheme = 'Adventure';
  String _selectedMoralValue = 'Kindness';
  bool _isGenerating = false;
  String? _generatedStory;
  late PlantAdvisorService _plantAdvisorService;
  final AdService _adService = AdService();
  
  // 添加快速点击计数相关变量
  int _tapCount = 0;
  DateTime? _lastTapTime;

  final List<String> _ageGroups = ['3-6 years', '7-9 years', '10-12 years'];

  final List<String> _durations = ['5 minutes', '10 minutes', '15 minutes'];

  final List<String> _themes = [
    'Adventure',
    'Fantasy',
    'Animals',
    'Friendship',
    'Family',
    'Nature',
    'Magic'
  ];

  final List<String> _moralValues = [
    'Kindness',
    'Honesty',
    'Courage',
    'Responsibility',
    'Sharing',
    'Respect',
    'Perseverance'
  ];

  final List<String> _genders = ['Boy', 'Girl'];

  @override
  void initState() {
    super.initState();
    _initService();
  }

  Future<void> _initService() async {
    final prefs = await SharedPreferences.getInstance();
    _plantAdvisorService = PlantAdvisorService(prefs);
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  Future<void> _generateStory() async {
    // 检查使用次数
    int usageCount = await _adService.getUsageCount();
    if (usageCount < 1) {
      _showWatchAdDialog();
      return;
    }
    
    // 消耗一次使用次数
    await _adService.decreaseUsageCount();
    
    setState(() {
      _isGenerating = true;
      _generatedStory = null;
    });

    try {
      final String prompt = '''
Please create a bedtime story with the following specifications:

For: $_selectedGender
Age Group: $_selectedAgeGroup
Duration: $_selectedDuration
Theme: $_selectedTheme
Moral Value: $_selectedMoralValue
Additional Elements: ${_themeController.text}

Requirements:
1. Start with a creative and engaging title for the story
2. The story should be engaging and appropriate for a $_selectedGender in the $_selectedAgeGroup age group
3. Include a clear moral lesson about $_selectedMoralValue
4. Use age-appropriate language and concepts
5. Create a calming and peaceful narrative suitable for bedtime
6. Ensure the story has a positive and uplifting ending
7. Include descriptive but soothing language
8. Avoid any scary or disturbing elements
9. Make the story length appropriate for $_selectedDuration reading time
10. Include elements that would particularly interest a $_selectedGender

Please format the story with:
- Title at the beginning (preceded by "TITLE: ")
- Clear paragraphs
- Simple dialogue
- Engaging descriptions
- A gentle conclusion
''';

      final response = await _plantAdvisorService.getPlantAdvice(prompt);
      String content = response.content;
      String title = 'Bedtime Story';
      String story = content;

      // 解析标题和故事内容
      if (content.contains('TITLE:')) {
        final parts = content.split('\n');
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].trim().startsWith('TITLE:')) {
            title = parts[i].replaceFirst('TITLE:', '').trim();
            story = parts.sublist(i + 1).join('\n').trim();
            break;
          }
        }
      }

      setState(() {
        _generatedStory = story;
        _isGenerating = false;
      });

      if (_generatedStory != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryDisplayScreen(
              story: _generatedStory!,
              title: title,
              gender: _selectedGender,
              ageGroup: _selectedAgeGroup,
              theme: _selectedTheme,
              moralValue: _selectedMoralValue,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isGenerating = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate story: $e')),
        );
      }
    }
  }
  
  void _showWatchAdDialog() {
    _adService.displayBannerAd();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Usage Limit Reached'),
          content: const Text('You have 0 attempts left. Watch a video to get 10 more attempts?'),
          actions: [
            TextButton(
              onPressed: () {
                _adService.concealBannerAd();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _adService.concealBannerAd();
                _adService.playIncentiveVideo();
                Navigator.of(context).pop();
              },
              child: const Text('Watch Ad'),
            ),
          ],
        );
      },
    );
  }

  void _handleScreenTap() {
    final now = DateTime.now();
    if (_lastTapTime != null && now.difference(_lastTapTime!).inSeconds < 3) {
      setState(() {
        _tapCount++;
      });
      
      if (_tapCount >= 10) {
        _showAdTestDialog();
        _tapCount = 0;
      }
    } else {
      setState(() {
        _tapCount = 1;
      });
    }
    _lastTapTime = now;
  }
  
  void _showAdTestDialog() {
    _adService.loadOtherAd();
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black87,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Ad Test Panel",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 2.5,
                      children: [
                        _buildAdButton("展示插页1", () => _adService.presentInterstitialAd1()),
                        _buildAdButton("展示插页2", () => _adService.presentInterstitialAd2()),
                        _buildAdButton("展示插页3", () => _adService.presentInterstitialAd3()),
                        _buildAdButton("展示视频1", () => _adService.playIncentiveVideo1()),
                        _buildAdButton("展示视频2", () => _adService.playIncentiveVideo2()),
                        _buildAdButton("展示视频3", () => _adService.playIncentiveVideo3()),
                        _buildAdButton("展示横幅", () => _adService.displayBannerAd()),
                        _buildAdButton("隐藏横幅", () => _adService.concealBannerAd()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildAdButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        textStyle: const TextStyle(fontSize: 13),
      ),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _handleScreenTap(); // 添加处理屏幕点击的调用
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'TaleWeaver',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('How to Use TaleWeaver'),
                    content: const SingleChildScrollView(
                      child: Text(
                        '1. Select the gender of the listener\n'
                        '2. Choose the age group\n'
                        '3. Set the story duration\n'
                        '4. Pick a theme and moral value\n'
                        '5. Add any special elements you\'d like\n'
                        '6. Click Generate to create your bedtime story!\n\n'
                        'Tips: The story will be tailored based on your selections!',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Got it'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.1),
                Colors.white,
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Story Settings Card
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.auto_stories,
                                    size: 32,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Create Your Story',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                        ),
                                        const Text(
                                          'Customize your bedtime tale',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Gender Selection
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Story For',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: Icon(
                                    _selectedGender == 'Boy'
                                        ? Icons.face
                                        : Icons.face_3,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                value: _selectedGender,
                                items: _genders.map((String gender) {
                                  return DropdownMenuItem<String>(
                                    value: gender,
                                    child: Text(gender),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedGender = newValue!;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              // Age Group Selection
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Age Group',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(Icons.child_care),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                value: _selectedAgeGroup,
                                items: _ageGroups.map((String age) {
                                  return DropdownMenuItem<String>(
                                    value: age,
                                    child: Text(age),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedAgeGroup = newValue!;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              // Duration Selection
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Story Duration',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(Icons.timer),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                value: _selectedDuration,
                                items: _durations.map((String duration) {
                                  return DropdownMenuItem<String>(
                                    value: duration,
                                    child: Text(duration),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedDuration = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Theme and Values Card
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Story Elements',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              // Theme Selection
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Story Theme',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(Icons.category),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                value: _selectedTheme,
                                items: _themes.map((String theme) {
                                  return DropdownMenuItem<String>(
                                    value: theme,
                                    child: Text(theme),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedTheme = newValue!;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              // Moral Value Selection
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Moral Value',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(Icons.favorite),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                value: _selectedMoralValue,
                                items: _moralValues.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedMoralValue = newValue!;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              // Additional Elements Input
                              TextField(
                                controller: _themeController,
                                maxLength: 100,
                                decoration: InputDecoration(
                                  labelText: 'Additional Elements (Optional)',
                                  hintText:
                                      'e.g., dragons, space travel, magical forest',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(Icons.stars),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  counterText: '',
                                  helperText: 'Maximum 100 characters',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Generate Button
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, -4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: SafeArea(
                  child: ElevatedButton(
                    onPressed: _isGenerating ? null : _generateStory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isGenerating)
                          Container(
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.only(right: 12),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        else
                          Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: const Icon(
                              Icons.auto_stories,
                              size: 24,
                            ),
                          ),
                        Text(
                          _isGenerating
                              ? 'Creating Your Story...'
                              : 'Create Bedtime Story',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
