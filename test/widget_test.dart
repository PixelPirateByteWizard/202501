import 'package:flutter_test/flutter_test.dart';
import 'package:sort_game/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SortGameApp());

    // Verify that the game screen loads
    expect(find.text('第 1 關'), findsOneWidget);
    expect(find.text('獲得空瓶'), findsOneWidget);
    expect(find.text('消除一杯'), findsOneWidget);
    expect(find.text('撤退一步'), findsOneWidget);
  });
}