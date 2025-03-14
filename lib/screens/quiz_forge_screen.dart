import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import './quiz_display_screen.dart';

import 'package:uuid/uuid.dart';

import '../services/plant_advisor_service.dart';
import '../services/ad_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizForgeScreen extends StatefulWidget {
  const QuizForgeScreen({super.key});

  @override
  State<QuizForgeScreen> createState() => _QuizForgeScreenState();
}

class _QuizForgeScreenState extends State<QuizForgeScreen> {
  final TextEditingController _topicController = TextEditingController();
  String _selectedSubject = 'Mathematics';
  String _selectedGrade = 'Middle School';
  String _selectedDifficulty = 'Normal';
  int _selectedQuestionCount = 10;
  final AdService _adService = AdService();

  // 预定义选项改为英文
  final List<String> _subjects = [
    'Mathematics',
    'English',
    'Physics',
    'Chemistry',
    'Biology',
    'History',
    'Geography',
    'Politics'
  ];
  final List<String> _grades = [
    'Primary School',
    'Middle School',
    'High School',
    'University'
  ];
  final List<String> _difficulties = ['Easy', 'Normal', 'Hard'];
  final List<int> _questionCounts = [5, 10, 15, 20];

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _difficultyController = TextEditingController();
  List<QuizQuestion>? _questions;
  bool _isGenerating = false;
  bool _isQuizCompleted = false;
  int? _score;
  late PlantAdvisorService _plantAdvisorService;

  // 添加快速点击计数相关变量
  int _tapCount = 0;
  DateTime? _lastTapTime;

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
    _subjectController.dispose();
    _difficultyController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  Future<void> _generateQuiz() async {
    // 检查使用次数
    int usageCount = await _adService.getUsageCount();
    if (usageCount < 1) {
      _showWatchAdDialog();
      return;
    }
    
    // 消耗一次使用次数
    await _adService.decreaseUsageCount();
    
    if (_topicController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a specific topic')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      // 修改为英文提示
      final String prompt = '''
Please generate ${_selectedQuestionCount} multiple-choice questions about "${_topicController.text}" for ${_selectedGrade} ${_selectedSubject}.

Requirements:
1. Difficulty level: ${_selectedDifficulty}
2. Each question must strictly comply with ${_selectedGrade} ${_selectedSubject} curriculum standards
3. Questions must be directly related to "${_topicController.text}"
4. Each question must have 4 options with clear distinctions
5. Answers must be accurate and meet academic standards
6. All content must be in English

Question format:
Question
A. Option 1
B. Option 2
C. Option 3
D. Option 4
Correct answer index (0-3)
---

Note:
1. Separate questions with "---"
2. Output questions directly without any additional explanations
3. Options should be concise and unambiguous
4. Difficulty should match ${_selectedDifficulty} level standards
''';

      final response = await _plantAdvisorService.getPlantAdvice(prompt);
      final String content = response.content;

      // 解析 AI 生成的题目
      final List<QuizQuestion> questions = _parseAIGeneratedQuestions(content);

      if (questions.isNotEmpty) {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => QuizDisplayScreen(
                questions: questions,
                subject: _selectedSubject,
                topic: _topicController.text,
                difficulty: _selectedDifficulty,
              ),
            ),
          );
        }
      } else {
        throw Exception('题目解析失败，请重试');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('生成题目失败: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  List<QuizQuestion> _parseAIGeneratedQuestions(String content) {
    final List<QuizQuestion> questions = [];

    // 确保内容是UTF-8编码
    content = content.trim();

    // 使用正则表达式匹配题目块
    final questionBlocks = content
        .split(RegExp(r'\n*---\n*'))
        .where((block) => block.trim().isNotEmpty);

    for (String block in questionBlocks) {
      try {
        // 分割每行并移除空行
        final lines = block
            .split('\n')
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty)
            .toList();

        if (lines.length < 6) continue; // 跳过格式不正确的题目

        // 提取题目（移除可能的序号前缀）
        String question = lines[0].replaceFirst(RegExp(r'^\d+[\.\、]?\s*'), '');

        // 提取选项（移除A、B、C、D前缀）
        List<String> options = [];
        for (int i = 1; i <= 4; i++) {
          if (i < lines.length) {
            String option = lines[i].trim();
            // 移除选项字母前缀（支持多种格式：A. A、 A．等）
            option = option.replaceFirst(RegExp(r'^[A-D][\.\、\．]?\s*'), '');
            options.add(option);
          }
        }

        // 解析正确答案
        int correctOptionIndex = -1;
        final lastLine = lines.last.trim();

        // 尝试从最后一行提取答案索引
        if (lastLine.contains(RegExp(r'\d+'))) {
          // 直接包含数字的情况
          final match = RegExp(r'\d+').firstMatch(lastLine);
          if (match != null) {
            correctOptionIndex = int.parse(match.group(0)!);
          }
        } else {
          // 包含字母答案的情况（A/B/C/D）
          final match = RegExp(r'[A-D]').firstMatch(lastLine);
          if (match != null) {
            correctOptionIndex =
                match.group(0)!.codeUnitAt(0) - 'A'.codeUnitAt(0);
          }
        }

        // 验证答案索引是否有效
        if (correctOptionIndex >= 0 &&
            correctOptionIndex < 4 &&
            options.length == 4) {
          questions.add(QuizQuestion(
            id: const Uuid().v4(),
            question: question,
            options: options,
            correctOptionIndex: correctOptionIndex,
          ));
        }
      } catch (e) {
        print('解析题目失败: $e');
        continue;
      }
    }

    return questions;
  }

  void _submitQuiz() {
    if (_questions == null) return;

    int correctAnswers = _questions!.where((q) => q.isCorrect).length;
    int totalQuestions = _questions!.length;
    int score = (correctAnswers / totalQuestions * 100).round();

    setState(() {
      _score = score;
      _isQuizCompleted = true;
    });
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
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text(
            'Quiz Forge',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.help_outline,
                color: Colors.black,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('How to Use'),
                    content: const SingleChildScrollView(
                      child: Text(
                        '1. Select your subject and grade level\n'
                        '2. Enter a specific topic you want to study\n'
                        '3. Choose difficulty and number of questions\n'
                        '4. Click Generate to create your quiz\n\n'
                        'Tips: Be specific with your topic for better results!',
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
                      // Welcome Section
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
                                    Icons.school,
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
                                          'Create Your Quiz',
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
                                          'Customize your learning experience',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Basic Settings Card
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
                                'Basic Settings',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Select Subject',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(Icons.subject),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                value: _selectedSubject,
                                items: _subjects.map((String subject) {
                                  return DropdownMenuItem<String>(
                                    value: subject,
                                    child: Text(subject),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedSubject = newValue!;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Select Grade',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(Icons.school),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                value: _selectedGrade,
                                items: _grades.map((String grade) {
                                  return DropdownMenuItem<String>(
                                    value: grade,
                                    child: Text(grade),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedGrade = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Specific Requirements Card
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
                                'Quiz Configuration',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _topicController,
                                maxLength: 100,
                                decoration: InputDecoration(
                                  labelText: 'Topic/Knowledge Point',
                                  hintText:
                                      'e.g., Quadratic Equations, Newton\'s Laws',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(Icons.topic),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  counterText: '',
                                  helperText: 'Maximum 100 characters',
                                ),
                                textInputAction: TextInputAction.done,
                                onEditingComplete: () {
                                  FocusScope.of(context).unfocus();
                                },
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Difficulty Level',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(Icons.trending_up),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                value: _selectedDifficulty,
                                items: _difficulties.map((String difficulty) {
                                  return DropdownMenuItem<String>(
                                    value: difficulty,
                                    child: Text(difficulty),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedDifficulty = newValue!;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  labelText: 'Number of Questions',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon:
                                      const Icon(Icons.format_list_numbered),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                value: _selectedQuestionCount,
                                items: _questionCounts.map((int count) {
                                  return DropdownMenuItem<int>(
                                    value: count,
                                    child: Text('$count Questions'),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    _selectedQuestionCount = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // 固定在底部的按钮
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
                    onPressed: _isGenerating ? null : _generateQuiz,
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
                              Icons.quiz,
                              size: 24,
                            ),
                          ),
                        Text(
                          _isGenerating
                              ? 'Creating Your Quiz...'
                              : 'Create Quiz',
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
