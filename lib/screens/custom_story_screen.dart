import 'package:flutter/material.dart';
import '../models/chapter_narrative.dart';
import '../models/story.dart';
import 'game_levels/level_one.dart';

class CustomStoryScreen extends StatefulWidget {
  const CustomStoryScreen({super.key});

  @override
  State<CustomStoryScreen> createState() => _CustomStoryScreenState();
}

class _CustomStoryScreenState extends State<CustomStoryScreen> {
  final _titleController = TextEditingController();
  final _preludeController = TextEditingController();
  final _storyController = TextEditingController();
  final _reviewController = TextEditingController();
  final List<TextEditingController> _optionControllers = List.generate(
    3,
    (index) => TextEditingController(),
  );
  int _correctOptionIndex = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _preludeController.dispose();
    _storyController.dispose();
    _reviewController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bj/xybj1.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black54,
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAppBar(),
                const SizedBox(height: 20),
                _buildTextField(_titleController, '故事标题', maxLines: 1),
                const SizedBox(height: 16),
                _buildTextField(_preludeController, '故事序章', maxLines: 5),
                const SizedBox(height: 16),
                _buildTextField(_storyController, '第一个场景', maxLines: 5),
                const SizedBox(height: 16),
                ...List.generate(3, (index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              _optionControllers[index],
                              '选项 ${index + 1}',
                              maxLines: 1,
                            ),
                          ),
                          Radio<int>(
                            value: index,
                            groupValue: _correctOptionIndex,
                            onChanged: (value) {
                              setState(() {
                                _correctOptionIndex = value!;
                              });
                            },
                            fillColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.amber,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                }),
                const SizedBox(height: 16),
                _buildTextField(_reviewController, '故事结局', maxLines: 5),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _startCustomStory,
                  child: const Text(
                    '开始自定义故事',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'ZHSGuFeng',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const Expanded(
          child: Text(
            '创建自定义故事',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'ZHSGuFeng',
              color: Colors.amber,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.withOpacity(0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          color: Colors.amber,
          fontFamily: 'ZHSGuFeng',
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.amber.withOpacity(0.7),
            fontFamily: 'ZHSGuFeng',
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _startCustomStory() {
    final customNarrative = ChapterNarrative(
      title: _titleController.text,
      prelude: _preludeController.text,
      review: _reviewController.text,
      initialStories: [
        Story(
          content: _storyController.text,
          options: _optionControllers.map((c) => c.text).toList(),
          correctOption: _correctOptionIndex,
        ),
      ],
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LevelOne(
          levelId: -1, // 使用特殊ID表示自定义故事
          customNarrative: customNarrative,
        ),
      ),
    );
  }
}
