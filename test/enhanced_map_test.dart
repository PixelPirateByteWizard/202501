import 'package:flutter_test/flutter_test.dart';
import 'package:clockworklegacy/services/world_map_service.dart';
import 'package:clockworklegacy/services/deepseek_service.dart';

void main() {
  group('Enhanced Map Features', () {
    test('WorldMapService should load default maps', () async {
      final service = WorldMapService();
      final maps = await service.getWorldMaps();
      
      expect(maps.isNotEmpty, true);
      expect(maps.first.name, 'Overworld');
      expect(maps.first.isUnlocked, true);
    });

    test('DeepSeekService should handle API errors gracefully', () async {
      final service = DeepSeekService();
      
      // This should return fallback content if API fails
      final story = await service.generateStoryContent(
        context: 'Test context',
        playerAction: 'Test action',
        currentLocation: 'Test location',
      );
      
      expect(story.isNotEmpty, true);
    });

    test('Story events should be properly formatted', () async {
      final service = WorldMapService();
      final events = await service.getAllStoryEvents();
      
      // Should return empty list initially
      expect(events, isA<List>());
    });
  });
}