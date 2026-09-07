import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/data/catalog/algebra_catalog.dart';
import 'package:laurentius/data/catalog/arithmetic_catalog.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/widgets/interactive/live_equation_widget.dart';

void main() {
  group('LiveEquationWidget Variable Binding & Auto-Discovery Resilience', () {
    testWidgets('LiveEquationWidget with NO parameters provided for a + b does NOT throw Variable not bound', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..equations = ['a + b'];
      // Note: data.parameters is null!

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LiveEquationWidget(data: data),
            ),
          ),
        ),
      );
      await tester.pump();

      // Should not contain error message
      expect(find.textContaining('Impossibile calcolare'), findsNothing);
      expect(find.textContaining('Variable not bound'), findsNothing);

      // Sliders for both discovered variables 'a' and 'b' should be generated
      expect(find.textContaining('Variabile (a)'), findsOneWidget);
      expect(find.textContaining('Variabile (b)'), findsOneWidget);
    });

    testWidgets('LiveEquationWidget with partial parameters (only b provided for a + b)', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..equations = ['a + b']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'b'
            ..label = 'Parametro B'
            ..defaultValue = 10.0
            ..minValue = 0.0
            ..maxValue = 20.0,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LiveEquationWidget(data: data),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.textContaining('Impossibile calcolare'), findsNothing);
      expect(find.textContaining('Variable not bound'), findsNothing);
      expect(find.text('Parametro B'), findsOneWidget);
      expect(find.textContaining('Variabile (a)'), findsOneWidget);
    });

    testWidgets('ArithmeticCatalog fallback nodes mount cleanly in LiveEquationWidget', (tester) async {
      for (final node in ArithmeticCatalog.getAllNodes()) {
        final data = node.interactiveData;
        if (data == null) continue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: LiveEquationWidget(data: data),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(find.textContaining('Impossibile calcolare'), findsNothing,
            reason: 'Failed for arithmetic node: ${node.serverId}');
        expect(find.textContaining('Variable not bound'), findsNothing,
            reason: 'Unbound variable in arithmetic node: ${node.serverId}');
      }
    });

    testWidgets('AlgebraCatalog fallback nodes with live_equation mount cleanly', (tester) async {
      for (final node in AlgebraCatalog.getAllNodes()) {
        final data = node.interactiveData;
        if (data == null || data.templateType != 'live_equation') continue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: LiveEquationWidget(data: data),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(find.textContaining('Impossibile calcolare'), findsNothing,
            reason: 'Failed for algebra node: ${node.serverId}');
        expect(find.textContaining('Variable not bound'), findsNothing,
            reason: 'Unbound variable in algebra node: ${node.serverId}');
      }
    });
  });
}
