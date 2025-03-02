import 'story.dart';

class ChapterNarrative {
  final String title;
  final String prelude;
  final String review;
  final List<Story> initialStories;

  ChapterNarrative({
    required this.title,
    required this.prelude,
    required this.review,
    required this.initialStories,
  });
}
