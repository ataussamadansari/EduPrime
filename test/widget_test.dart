import 'package:flutter_test/flutter_test.dart';
import 'package:ssvvostc/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EduPrimeApp());
    expect(find.byType(EduPrimeApp), findsOneWidget);
  });
}
