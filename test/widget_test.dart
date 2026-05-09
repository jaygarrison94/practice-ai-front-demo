import 'package:flutter_test/flutter_test.dart';
import 'package:practice_ai_front_demo/main.dart';

void main() {
  testWidgets('App smoke test - should display app name', (tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pump();
    expect(find.byType(MyApp), findsOneWidget);
  });
}
