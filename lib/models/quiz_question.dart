class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  String? selectedAnswer;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    this.selectedAnswer,
  });

  bool get isCorrect => selectedAnswer == options[correctOptionIndex];
}
