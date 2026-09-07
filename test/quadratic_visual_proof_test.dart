import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/widgets/interactive/interactive_template_factory.dart';
import 'package:laurentius/presentation/widgets/interactive/quadratic_visual_proof_widget.dart';

void main() {
  group('QuadraticVisualProofWidget Interactive & Geometric Tests', () {
    testWidgets('1. Starts with autoplay paused by default (R1 requirement)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: QuadraticVisualProofWidget(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verifica presenza del titolo e icona play (stato in pausa)
      expect(find.text('Dimostrazione Visiva: Formula Quadratica'), findsOneWidget);
      expect(find.byIcon(Icons.play_circle_fill), findsOneWidget);
      expect(find.byIcon(Icons.pause_circle_filled), findsNothing);
    });

    testWidgets('2. Navigates through all 5 proof steps with forward/back buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: QuadraticVisualProofWidget(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Step 1 iniziale
      expect(find.text('1. Area di partenza: x² + (b/a)x'), findsOneWidget);

      // Avanza a Step 2
      final nextButton = find.byIcon(Icons.arrow_forward_ios_rounded);
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.text('2. Taglio simmetrico a "L": due ali da b/(2a)x'), findsOneWidget);

      // Avanza a Step 3
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.text('3. Il tassello vuoto: spazio mancante b²/(4a²)'), findsOneWidget);

      // Avanza a Step 4
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.text('4. Completamento del Quadrato: aggiunta tassello'), findsOneWidget);

      // Avanza a Step 5
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.text('5. Risoluzione: lato = √(Δ/(4a²)) ➔ formula'), findsOneWidget);

      // Torna indietro a Step 4
      final prevButton = find.byIcon(Icons.arrow_back_ios_new_rounded);
      await tester.tap(prevButton);
      await tester.pumpAndSettle();
      expect(find.text('4. Completamento del Quadrato: aggiunta tassello'), findsOneWidget);
    });

    testWidgets('3. Switches between Geometric Dissection and Parabola & Symmetry views',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: QuadraticVisualProofWidget(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Dissezione Geometrica 2D'), findsOneWidget);

      // Clicca sul segmento "Parabola & Radici"
      await tester.tap(find.text('Parabola & Radici'));
      await tester.pumpAndSettle();

      expect(find.text('Piano Cartesiano & Simmetria'), findsOneWidget);
      // Lo StepNavigator non deve essere visibile in modalità parabola
      expect(find.text('1. Area di partenza: x² + (b/a)x'), findsNothing);
    });

    testWidgets('4. Computes correct telemetry: Delta, axis of symmetry and roots',
        (WidgetTester tester) async {
      // Con a = 1, b = 4, c = -5:
      // Delta = 4^2 - 4(1)(-5) = 16 + 20 = 36
      // Asse = -4 / (2*1) = -2.0
      // Radici: (-4 + 6)/2 = 1.0, (-4 - 6)/2 = -5.0
      final testData = InteractiveData()
        ..templateType = 'completing_square'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..defaultValue = 1.0,
          InteractiveParameter()
            ..variableName = 'b'
            ..defaultValue = 4.0,
          InteractiveParameter()
            ..variableName = 'c'
            ..defaultValue = -5.0,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: QuadraticVisualProofWidget(data: testData),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Δ > 0 (2 Radici Reali)'), findsOneWidget);
      expect(find.text('36.00'), findsOneWidget); // Delta
      expect(find.text('x = -2.00'), findsOneWidget); // Asse
      expect(find.text('x₁ = 1.00'), findsOneWidget);
      expect(find.text('x₂ = -5.00'), findsOneWidget);
    });

    testWidgets('5. Handles negative Delta gracefully without throwing',
        (WidgetTester tester) async {
      // a = 1, b = 2, c = 5 => Delta = 4 - 20 = -16 < 0
      final testData = InteractiveData()
        ..templateType = 'completing_square'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..defaultValue = 1.0,
          InteractiveParameter()
            ..variableName = 'b'
            ..defaultValue = 2.0,
          InteractiveParameter()
            ..variableName = 'c'
            ..defaultValue = 5.0,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: QuadraticVisualProofWidget(data: testData),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Δ < 0 (Nessuna Radice Reale)'), findsOneWidget);
      expect(find.text('-16.00'), findsOneWidget);
      expect(find.text('x₁ ∈ ℂ (non reale)'), findsOneWidget);
      expect(find.text('x₂ ∈ ℂ (non reale)'), findsOneWidget);
    });

    testWidgets('6. InteractiveTemplateFactory instantiates QuadraticVisualProofWidget',
        (WidgetTester tester) async {
      final data1 = InteractiveData()..templateType = 'completing_square';
      final widget1 = InteractiveTemplateFactory.buildWidget(data1);
      expect(widget1, isA<QuadraticVisualProofWidget>());

      final data2 = InteractiveData()..templateType = 'quadratic_visual';
      final widget2 = InteractiveTemplateFactory.buildWidget(data2);
      expect(widget2, isA<QuadraticVisualProofWidget>());

      final data3 = InteractiveData()..templateType = 'dimostrazione_quadratica';
      final widget3 = InteractiveTemplateFactory.buildWidget(data3);
      expect(widget3, isA<QuadraticVisualProofWidget>());
    });
  });
}
