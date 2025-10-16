import 'package:flutter_test/flutter_test.dart';
import 'package:clockworklegacy/services/onboarding_service.dart';

void main() {
  group('Onboarding Service Tests', () {
    late OnboardingService service;

    setUp(() {
      service = OnboardingService();
    });

    test('should return false for first time onboarding completion check', () async {
      // Reset to ensure clean state
      await service.resetOnboarding();
      
      final isComplete = await service.isOnboardingComplete();
      expect(isComplete, false);
    });

    test('should return true after completing onboarding', () async {
      await service.completeOnboarding();
      
      final isComplete = await service.isOnboardingComplete();
      expect(isComplete, true);
    });

    test('should detect first launch correctly', () async {
      await service.resetOnboarding();
      
      final isFirst = await service.isFirstLaunch();
      expect(isFirst, true);
      
      // Second call should return false
      final isSecond = await service.isFirstLaunch();
      expect(isSecond, false);
    });

    test('should reset onboarding state correctly', () async {
      // Complete onboarding first
      await service.completeOnboarding();
      expect(await service.isOnboardingComplete(), true);
      
      // Reset and check
      await service.resetOnboarding();
      expect(await service.isOnboardingComplete(), false);
      expect(await service.isFirstLaunch(), true);
    });
  });
}