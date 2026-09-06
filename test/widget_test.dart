import 'package:flutter_test/flutter_test.dart';

import 'package:laurentius/main.dart';

void main() {
  testWidgets('HomeScreen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LaurentiusApp());

    expect(find.text('Brilliant OS'), findsWidgets);
  });
}
