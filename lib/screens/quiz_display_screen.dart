import 'package:flutter/material.dart';
import '../models/quiz_question.dart';

class QuizDisplayScreen extends StatefulWidget {
  final List<QuizQuestion> questions;
  final String subject;
  final String topic;
  final String difficulty;

  const QuizDisplayScreen({
    super.key,
    required this.questions,
    required this.subject,
    required this.topic,
    required this.difficulty,
  });

  @override
  State<QuizDisplayScreen> createState() => _QuizDisplayScreenState();
}

class _QuizDisplayScreenState extends State<QuizDisplayScreen> {
  bool _isQuizCompleted = false;
  int? _score;

  void _submitQuiz() {
    int correctAnswers = widget.questions.where((q) => q.isCorrect).length;
    int totalQuestions = widget.questions.length;
    int score = (correctAnswers / totalQuestions * 100).round();

    setState(() {
      _score = score;
      _isQuizCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.subject,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              widget.topic,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('How to Use'),
                  content: const SingleChildScrollView(
                    child: Text(
                      '1. Read each question carefully\n'
                      '2. Select your answer from the options provided\n'
                      '3. Submit the quiz when you\'re done\n'
                      '4. Review your score and correct answers\n\n'
                      'Tip: Take your time to think about each answer!',
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
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text(
              'New Quiz',
              style: TextStyle(color: Colors.white),
            ),
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
            // Quiz Info Card
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.quiz,
                      size: 32,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.speed,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Difficulty: ${widget.difficulty}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${widget.questions.length} Questions',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Questions List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: widget.questions.length,
                itemBuilder: (context, index) {
                  final question = widget.questions[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SelectableText(
                                  question.question,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: List.generate(
                              question.options.length,
                              (optionIndex) {
                                final option = question.options[optionIndex];
                                final isSelected =
                                    question.selectedAnswer == option;
                                final isCorrect = _isQuizCompleted &&
                                    optionIndex == question.correctOptionIndex;
                                final isWrong = _isQuizCompleted &&
                                    isSelected &&
                                    optionIndex != question.correctOptionIndex;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isCorrect
                                          ? Colors.green
                                          : isWrong
                                              ? Colors.red
                                              : Colors.grey.shade300,
                                    ),
                                    color: isCorrect
                                        ? Colors.green.withOpacity(0.1)
                                        : isWrong
                                            ? Colors.red.withOpacity(0.1)
                                            : isSelected
                                                ? Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.1)
                                                : Colors.transparent,
                                  ),
                                  child: RadioListTile<String>(
                                    title: Text(
                                      '${String.fromCharCode(65 + optionIndex)}. $option',
                                      style: TextStyle(
                                        color: isCorrect
                                            ? Colors.green
                                            : isWrong
                                                ? Colors.red
                                                : null,
                                        fontWeight: (isCorrect || isWrong)
                                            ? FontWeight.bold
                                            : null,
                                      ),
                                    ),
                                    value: option,
                                    groupValue: question.selectedAnswer,
                                    onChanged: _isQuizCompleted
                                        ? null
                                        : (value) {
                                            setState(() {
                                              question.selectedAnswer = value;
                                            });
                                          },
                                    activeColor: Theme.of(context).primaryColor,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Bottom Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                child: _isQuizCompleted && _score != null
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _score! >= 80
                                    ? Icons.emoji_events
                                    : _score! >= 60
                                        ? Icons.star
                                        : Icons.psychology,
                                size: 32,
                                color: _score! >= 80
                                    ? Colors.amber
                                    : _score! >= 60
                                        ? Colors.blue
                                        : Colors.purple,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Score: $_score%',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: _score! >= 80
                                          ? Colors.amber.shade700
                                          : _score! >= 60
                                              ? Colors.blue
                                              : Colors.purple,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildScoreDetail(
                                icon: Icons.check_circle,
                                color: Colors.green,
                                count: widget.questions
                                    .where((q) => q.isCorrect)
                                    .length,
                                label: 'Correct',
                              ),
                              Container(
                                height: 24,
                                width: 1,
                                color: Colors.grey.shade300,
                              ),
                              _buildScoreDetail(
                                icon: Icons.cancel,
                                color: Colors.red,
                                count: widget.questions
                                    .where((q) => !q.isCorrect)
                                    .length,
                                label: 'Incorrect',
                              ),
                            ],
                          ),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: _submitQuiz,
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
                            Container(
                              margin: const EdgeInsets.only(right: 12),
                              child: const Icon(
                                Icons.check_circle,
                                size: 24,
                              ),
                            ),
                            const Text(
                              'Submit Quiz',
                              style: TextStyle(
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
    );
  }

  Widget _buildScoreDetail({
    required IconData icon,
    required Color color,
    required int count,
    required String label,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          '$label: $count',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
