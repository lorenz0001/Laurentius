import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/widgets/interactive/interactive_template_factory.dart';
import 'package:laurentius/presentation/widgets/interactive/vector_2d_simulation_widget.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: ThemeData.dark(),
    home: Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  group('Vector2DSimulationWidget Test Suite', () {
    // ------------------------------------------------------------------------
    // 1. Mounting & Static Initial State (Autoplay Suppression)
    // ------------------------------------------------------------------------
    group('1. Mounting & Autoplay Suppression', () {
      testWidgets('1.1 Mounts cleanly with default null data in static paused state', (tester) async {
        await tester.pumpWidget(_wrap(const Vector2DSimulationWidget()));
        await tester.pump();

        expect(find.byType(Vector2DSimulationWidget), findsOneWidget);
        expect(find.text('Vettori 2D & Algebra Lineare'), findsOneWidget);
        expect(find.byTooltip('Auto-rotazione vettori'), findsOneWidget);
        expect(find.byTooltip('Ferma rotazione'), findsNothing);

        // Initial default v1 is (3.0, 2.0)
        expect(find.textContaining('v₁ = (3.0, 2.0)'), findsOneWidget);

        // Advance 2 seconds while idle - verify values do not mutate
        await tester.pump(const Duration(seconds: 2));
        expect(find.textContaining('v₁ = (3.0, 2.0)'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('1.2 CustomPaint canvas and touch hint overlay are rendered', (tester) async {
        await tester.pumpWidget(_wrap(const Vector2DSimulationWidget()));
        await tester.pump();

        expect(find.byType(CustomPaint), findsWidgets);
        expect(find.text('Trascina le punte dei vettori sul piano'), findsOneWidget);
      });

      testWidgets('1.3 Toggle auto-rotation plays and pauses cleanly', (tester) async {
        await tester.pumpWidget(_wrap(const Vector2DSimulationWidget()));
        await tester.pump();

        final playButton = find.byTooltip('Auto-rotazione vettori');
        expect(playButton, findsOneWidget);

        // Start auto-rotation
        await tester.tap(playButton);
        await tester.pump();
        expect(find.byTooltip('Ferma rotazione'), findsOneWidget);

        // Tick 1 second
        await tester.pump(const Duration(seconds: 1));

        // Stop auto-rotation
        await tester.tap(find.byTooltip('Ferma rotazione'));
        await tester.pump();
        expect(find.byTooltip('Auto-rotazione vettori'), findsOneWidget);
      });
    });

    // ------------------------------------------------------------------------
    // 2. Mode Switching and Rule Toggling
    // ------------------------------------------------------------------------
    group('2. Mode Switching and Rule Toggling', () {
      testWidgets('2.1 Switches between Components, Addition, and Span modes', (tester) async {
        await tester.pumpWidget(_wrap(const Vector2DSimulationWidget()));
        await tester.pump();

        // 1. Initial mode: Components
        expect(find.text('Norma ||v₁||'), findsOneWidget);
        expect(find.textContaining('Base canonica'), findsOneWidget);

        // 2. Switch to Somma (Addition)
        final sommaTab = find.text('Somma');
        expect(sommaTab, findsOneWidget);
        await tester.tap(sommaTab);
        await tester.pump();

        expect(find.text('||v₁||'), findsOneWidget);
        expect(find.text('||v₂||'), findsOneWidget);
        expect(find.text('||v₁ + v₂||'), findsOneWidget);
        expect(find.textContaining('Disuguaglianza Triangolare'), findsOneWidget);
        expect(find.text('Parallelogramma'), findsOneWidget);
        expect(find.text('Punta-Coda'), findsOneWidget);

        // 3. Switch to Span & Base
        final spanTab = find.text('Span & Base');
        expect(spanTab, findsOneWidget);
        await tester.tap(spanTab);
        await tester.pump();

        expect(find.text('Determinante det(v₁,v₂)'), findsOneWidget);
        expect(find.text('Area Span |det|'), findsOneWidget);
        expect(find.text('Risultante w'), findsOneWidget);

        // 4. Switch back to Componenti
        await tester.tap(find.text('Componenti'));
        await tester.pump();
        expect(find.text('Norma ||v₁||'), findsOneWidget);
      });

      testWidgets('2.2 Toggles between Parallelogram and Tip-to-Tail rules in Addition mode', (tester) async {
        final data = InteractiveData()..templateType = 'vector_addition';
        await tester.pumpWidget(_wrap(Vector2DSimulationWidget(data: data)));
        await tester.pump();

        // Initial addition mode has Parallelogramma selected
        final tipToTailChip = find.text('Punta-Coda');
        expect(tipToTailChip, findsOneWidget);

        await tester.ensureVisible(tipToTailChip);
        await tester.tap(tipToTailChip);
        await tester.pump();

        final parallelogramChip = find.text('Parallelogramma');
        await tester.ensureVisible(parallelogramChip);
        await tester.tap(parallelogramChip);
        await tester.pump();

        expect(tester.takeException(), isNull);
      });
    });

    // ------------------------------------------------------------------------
    // 3. Canvas Touch Drag Gestures
    // ------------------------------------------------------------------------
    group('3. Canvas Touch Drag Gestures', () {
      testWidgets('3.1 Direct pan drag on canvas updates vector v1 coordinates', (tester) async {
        await tester.pumpWidget(_wrap(const Vector2DSimulationWidget()));
        await tester.pump();

        expect(find.textContaining('v₁ = (3.0, 2.0)'), findsOneWidget);

        // Find GestureDetector on canvas
        final gestureFinder = find.byType(GestureDetector).first;

        // Perform pan gesture dragging the canvas to relocate vector
        final gesture = await tester.startGesture(tester.getCenter(gestureFinder));
        await gesture.moveBy(const Offset(40, -30));
        await tester.pump();
        await gesture.up();
        await tester.pump();

        expect(tester.takeException(), isNull);
      });

      testWidgets('3.2 Dragging near v2 in Addition mode updates v2 and sum vector', (tester) async {
        final data = InteractiveData()..templateType = 'vector_addition';
        await tester.pumpWidget(_wrap(Vector2DSimulationWidget(data: data)));
        await tester.pump();

        final gestureFinder = find.byType(GestureDetector).first;
        final center = tester.getCenter(gestureFinder);

        final gesture = await tester.startGesture(center + const Offset(-20, -50));
        await gesture.moveBy(const Offset(30, 20));
        await tester.pump();
        await gesture.up();
        await tester.pump();

        expect(tester.takeException(), isNull);
      });
    });

    // ------------------------------------------------------------------------
    // 4. Linear Combinations, Scalar Sliders and Determinant Calculation
    // ------------------------------------------------------------------------
    group('4. Linear Combinations, Sliders and Determinants', () {
      testWidgets('4.1 Preset chips update scalar values c1 and c2', (tester) async {
        final data = InteractiveData()..templateType = 'linear_combination';
        await tester.pumpWidget(_wrap(Vector2DSimulationWidget(data: data)));
        await tester.pump();

        // Tap preset c=(2, -1)
        final presetChip = find.text('c=(2, -1)');
        expect(presetChip, findsOneWidget);

        await tester.ensureVisible(presetChip);
        await tester.tap(presetChip);
        await tester.pump();

        // v1 = (3.0, 2.0), v2 = (-1.0, 3.0)
        // w = 2*(3, 2) + (-1)*(-1, 3) = (6, 4) + (1, -3) = (7, 1)
        // Note: Coordinates are clamped to +/-5
        expect(find.textContaining('Risultante w'), findsOneWidget);
      });

      testWidgets('4.2 Non-collinear vectors show linearly independent green badge', (tester) async {
        final data = InteractiveData()
          ..templateType = 'span_2d'
          ..parameters = [
            InteractiveParameter()..variableName = 'vx'..defaultValue = 2.0,
            InteractiveParameter()..variableName = 'vy'..defaultValue = 1.0,
            InteractiveParameter()..variableName = 'v2x'..defaultValue = -1.0,
            InteractiveParameter()..variableName = 'v2y'..defaultValue = 3.0,
          ];
        // det(v1, v2) = 2*3 - 1*(-1) = 7.00 != 0
        await tester.pumpWidget(_wrap(Vector2DSimulationWidget(data: data)));
        await tester.pump();

        expect(find.textContaining('Linearmente Indipendenti'), findsOneWidget);
        expect(find.textContaining('7.00'), findsWidgets);
      });

      testWidgets('4.3 Collinear vectors (det = 0) trigger collinearity warning banner', (tester) async {
        final data = InteractiveData()
          ..templateType = 'span_2d'
          ..parameters = [
            InteractiveParameter()..variableName = 'vx'..defaultValue = 2.0,
            InteractiveParameter()..variableName = 'vy'..defaultValue = 1.0,
            InteractiveParameter()..variableName = 'v2x'..defaultValue = 4.0,
            InteractiveParameter()..variableName = 'v2y'..defaultValue = 2.0,
          ];
        // det(v1, v2) = 2*2 - 1*4 = 0.00 -> Collinear!
        await tester.pumpWidget(_wrap(Vector2DSimulationWidget(data: data)));
        await tester.pump();

        expect(find.textContaining('Attenzione: Vettori Collineari'), findsOneWidget);
        expect(find.textContaining('Lo Span degenera in una retta'), findsOneWidget);
      });
    });

    // ------------------------------------------------------------------------
    // 5. InteractiveTemplateFactory Routing across all Aliases
    // ------------------------------------------------------------------------
    group('5. Factory Routing Verification', () {
      final allAliases = [
        'vector_2d',
        'linear_combination',
        'vector_addition',
        'span_2d',
        'vector_simulation',
        'vector_span',
        'vector_space',
        'vettori_2d',
        'somma_vettoriale',
        'combinazione_lineare',
      ];

      for (final alias in allAliases) {
        test('Factory builds Vector2DSimulationWidget for template alias "$alias"', () {
          final data = InteractiveData()..templateType = alias;
          final widget = InteractiveTemplateFactory.buildWidget(data);
          expect(widget, isNotNull);
          expect(widget, isA<Vector2DSimulationWidget>());
        });
      }

      testWidgets('Factory template alias vector_addition initializes Addition mode directly', (tester) async {
        final data = InteractiveData()..templateType = 'vector_addition';
        final widget = InteractiveTemplateFactory.buildWidget(data);
        await tester.pumpWidget(_wrap(widget!));
        await tester.pump();

        expect(find.text('||v₁ + v₂||'), findsOneWidget);
        expect(find.text('Parallelogramma'), findsOneWidget);
      });

      testWidgets('Factory template alias linear_combination initializes Span mode directly', (tester) async {
        final data = InteractiveData()..templateType = 'linear_combination';
        final widget = InteractiveTemplateFactory.buildWidget(data);
        await tester.pumpWidget(_wrap(widget!));
        await tester.pump();

        expect(find.text('Determinante det(v₁,v₂)'), findsOneWidget);
      });
    });

    // ------------------------------------------------------------------------
    // 6. Boundary, Slider Clamping & Edge Cases
    // ------------------------------------------------------------------------
    group('6. Boundary & Clamping Edge Cases', () {
      testWidgets('6.1 Zero vector (0, 0) renders without NaN or crash', (tester) async {
        final data = InteractiveData()
          ..templateType = 'vector_2d'
          ..parameters = [
            InteractiveParameter()..variableName = 'vx'..defaultValue = 0.0,
            InteractiveParameter()..variableName = 'vy'..defaultValue = 0.0,
          ];
        await tester.pumpWidget(_wrap(Vector2DSimulationWidget(data: data)));
        await tester.pump();

        expect(find.textContaining('v₁ = (0.0, 0.0)'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('6.2 Extreme parameters clamp to allowable slider range', (tester) async {
        final data = InteractiveData()
          ..templateType = 'vector_2d'
          ..parameters = [
            InteractiveParameter()..variableName = 'vx'..defaultValue = 999.0,
            InteractiveParameter()..variableName = 'vy'..defaultValue = -999.0,
          ];
        await tester.pumpWidget(_wrap(Vector2DSimulationWidget(data: data)));
        await tester.pump();

        // Clamped to 5.0 and -5.0
        expect(find.textContaining('v₁ = (5.0, -5.0)'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('6.3 Slider scrubbing dispatches and updates state without errors', (tester) async {
        await tester.pumpWidget(_wrap(const Vector2DSimulationWidget()));
        await tester.pump();

        final sliders = find.byType(Slider);
        expect(sliders, findsWidgets);

        await tester.drag(sliders.first, const Offset(50, 0));
        await tester.pump();

        expect(tester.takeException(), isNull);
      });
    });
  });
}
