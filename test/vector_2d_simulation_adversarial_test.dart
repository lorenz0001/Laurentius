import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/widgets/interactive/vector_2d_simulation_widget.dart';

Widget _wrapSimulation(Widget child, {double width = 400}) {
  return MaterialApp(
    theme: ThemeData.dark(),
    home: Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: width,
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  group('Vector2DSimulationWidget Adversarial & Stress Test Suite (M2)', () {
    // ========================================================================
    // 1. GESTURES & INTERACTIVE TOUCH CONTROLS
    // ========================================================================
    group('1. Gestures & Direct Touch Controls Across Quadrants', () {
      testWidgets('1.1 Dragging vector v1 across all 4 quadrants updates coordinates smoothly without exceptions', (tester) async {
        await tester.pumpWidget(_wrapSimulation(const Vector2DSimulationWidget()));
        await tester.pump();

        // Initially v1 is (3.0, 2.0) in Quadrant 1
        expect(find.textContaining('v₁ = (3.0, 2.0)'), findsOneWidget);

        final canvasFinder = find.byWidgetPredicate((w) => w is CustomPaint && w.painter.runtimeType.toString().contains('Vector2D'));
        final canvasTopLeft = tester.getTopLeft(canvasFinder);
        final canvasSize = tester.getSize(canvasFinder);
        final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
        final scale = (canvasSize.height / 12.0).clamp(18.0, 26.0);

        // Compute screen offset of v1 head (3.0, 2.0)
        final pStart = center + Offset(3.0 * scale, -2.0 * scale);
        final gesture = await tester.startGesture(canvasTopLeft + pStart);
        await tester.pump();

        // Drag to Quadrant 2: (-3.0, 2.0)
        final pQ2 = center + Offset(-3.0 * scale, -2.0 * scale);
        await gesture.moveTo(canvasTopLeft + pQ2);
        await tester.pump();
        expect(find.textContaining('v₁ = (-3.0, 2.0)'), findsOneWidget);
        expect(tester.takeException(), isNull);

        // Drag to Quadrant 3: (-3.0, -2.0)
        final pQ3 = center + Offset(-3.0 * scale, 2.0 * scale);
        await gesture.moveTo(canvasTopLeft + pQ3);
        await tester.pump();
        expect(find.textContaining('v₁ = (-3.0, -2.0)'), findsOneWidget);
        expect(tester.takeException(), isNull);

        // Drag to Quadrant 4: (3.0, -2.0)
        final pQ4 = center + Offset(3.0 * scale, 2.0 * scale);
        await gesture.moveTo(canvasTopLeft + pQ4);
        await tester.pump();
        expect(find.textContaining('v₁ = (3.0, -2.0)'), findsOneWidget);
        expect(tester.takeException(), isNull);

        // Drag back to Quadrant 1: (3.0, 2.0)
        await gesture.moveTo(canvasTopLeft + pStart);
        await tester.pump();
        expect(find.textContaining('v₁ = (3.0, 2.0)'), findsOneWidget);

        await gesture.up();
        await tester.pump();
        expect(tester.takeException(), isNull);
      });

      testWidgets('1.2 Snap-to-integer assist snaps within 0.15 and retains fractional values otherwise', (tester) async {
        await tester.pumpWidget(_wrapSimulation(const Vector2DSimulationWidget()));
        await tester.pump();

        final canvasFinder = find.byWidgetPredicate((w) => w is CustomPaint && w.painter.runtimeType.toString().contains('Vector2D'));
        final canvasTopLeft = tester.getTopLeft(canvasFinder);
        final canvasSize = tester.getSize(canvasFinder);
        final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
        final scale = (canvasSize.height / 12.0).clamp(18.0, 26.0);

        final pStart = center + Offset(3.0 * scale, -2.0 * scale);
        final gesture = await tester.startGesture(canvasTopLeft + pStart);
        await tester.pump();

        // Drag to (2.08, 1.93): distance to integer (2.0, 2.0) is < 0.15 -> should SNAP to (2.0, 2.0)
        final pSnap = center + Offset(2.08 * scale, -1.93 * scale);
        await gesture.moveTo(canvasTopLeft + pSnap);
        await tester.pump();
        expect(find.textContaining('v₁ = (2.0, 2.0)'), findsOneWidget);

        // Drag to (2.40, 1.60): distance to nearest integers is >= 0.15 -> should NOT snap, should preserve fraction
        final pNoSnap = center + Offset(2.40 * scale, -1.60 * scale);
        await gesture.moveTo(canvasTopLeft + pNoSnap);
        await tester.pump();
        // Telemetry must show fractional coordinates
        expect(find.textContaining('v₁ = (2.4, 1.6)'), findsOneWidget);

        await gesture.up();
        await tester.pump();
        expect(tester.takeException(), isNull);
      });

      testWidgets('1.3 Boundary clamping strictly confines dragged coordinates to [-5.0, 5.0]', (tester) async {
        await tester.pumpWidget(_wrapSimulation(const Vector2DSimulationWidget()));
        await tester.pump();

        final canvasFinder = find.byWidgetPredicate((w) => w is CustomPaint && w.painter.runtimeType.toString().contains('Vector2D'));
        final canvasTopLeft = tester.getTopLeft(canvasFinder);
        final canvasSize = tester.getSize(canvasFinder);
        final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
        final scale = (canvasSize.height / 12.0).clamp(18.0, 26.0);

        final pStart = center + Offset(3.0 * scale, -2.0 * scale);
        final gesture = await tester.startGesture(canvasTopLeft + pStart);
        await tester.pump();

        // Drag far beyond top-right boundary: (10.0, 10.0) in Cartesian
        final pFarPositive = center + Offset(10.0 * scale, -10.0 * scale);
        await gesture.moveTo(canvasTopLeft + pFarPositive);
        await tester.pump();
        expect(find.textContaining('v₁ = (5.0, 5.0)'), findsOneWidget);

        // Drag far beyond bottom-left boundary: (-6.0, -6.0) in Cartesian (clamped to [-5.0, -5.0])
        final pFarNegative = center + Offset(-6.0 * scale, 6.0 * scale);
        await gesture.moveTo(canvasTopLeft + pFarNegative);
        await tester.pump();
        expect(find.textContaining('v₁ = (-5.0, -5.0)'), findsOneWidget);

        await gesture.up();
        await tester.pump();
        expect(tester.takeException(), isNull);
      });

      testWidgets('1.4 Dual vector dragging in Addition mode updates v2 and sum vector dynamically', (tester) async {
        final data = InteractiveData()..templateType = 'vector_addition';
        await tester.pumpWidget(_wrapSimulation(Vector2DSimulationWidget(data: data)));
        await tester.pump();

        // Default v1 = (3, 2), v2 = (-1, 3), sum = (2, 5)
        expect(find.textContaining('Risultante s = v₁ + v₂ = (2.0, 5.0)'), findsOneWidget);

        final canvasFinder = find.byWidgetPredicate((w) => w is CustomPaint && w.painter.runtimeType.toString().contains('Vector2D'));
        final canvasTopLeft = tester.getTopLeft(canvasFinder);
        final canvasSize = tester.getSize(canvasFinder);
        final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
        final scale = (canvasSize.height / 12.0).clamp(18.0, 26.0);

        // Drag v2 (-1.0, 3.0) to (1.0, -1.0)
        final pV2Start = center + Offset(-1.0 * scale, -3.0 * scale);
        final gesture = await tester.startGesture(canvasTopLeft + pV2Start);
        await tester.pump();

        final pV2End = center + Offset(1.0 * scale, 1.0 * scale);
        await gesture.moveTo(canvasTopLeft + pV2End);
        await tester.pump();

        // New sum s = (3.0, 2.0) + (1.0, -1.0) = (4.0, 1.0)
        expect(find.textContaining('Risultante s = v₁ + v₂ = (4.0, 1.0)'), findsOneWidget);

        await gesture.up();
        await tester.pump();
        expect(tester.takeException(), isNull);
      });
    });

    // ========================================================================
    // 2. MATHEMATICAL INVARIANTS & EDGE CASES
    // ========================================================================
    group('2. Mathematical Invariants & Edge Cases', () {
      testWidgets('2.1 Collinear vectors (det = 0) display warning banner and collapse shaded area cleanly', (tester) async {
        final data = InteractiveData()
          ..templateType = 'span_2d'
          ..parameters = [
            InteractiveParameter()..variableName = 'vx'..defaultValue = 2.0,
            InteractiveParameter()..variableName = 'vy'..defaultValue = 1.0,
            InteractiveParameter()..variableName = 'v2x'..defaultValue = 4.0,
            InteractiveParameter()..variableName = 'v2y'..defaultValue = 2.0,
          ];
        // det = 2*2 - 1*4 = 0.00
        await tester.pumpWidget(_wrapSimulation(Vector2DSimulationWidget(data: data)));
        await tester.pump();

        // Verify warning banner
        expect(find.textContaining('Attenzione: Vettori Collineari (det = 0)'), findsOneWidget);
        expect(find.textContaining('Lo Span degenera in una retta (sottospazio 1D)!'), findsOneWidget);

        // Area should be 0.00
        expect(find.text('0.00'), findsWidgets);

        // Verify no paint crashes or NaN exceptions
        expect(tester.takeException(), isNull);
      });

      testWidgets('2.2 Antiparallel collinear vectors (det = 0) trigger warning banner', (tester) async {
        final data = InteractiveData()
          ..templateType = 'span_2d'
          ..parameters = [
            InteractiveParameter()..variableName = 'vx'..defaultValue = 1.0,
            InteractiveParameter()..variableName = 'vy'..defaultValue = -2.0,
            InteractiveParameter()..variableName = 'v2x'..defaultValue = -2.0,
            InteractiveParameter()..variableName = 'v2y'..defaultValue = 4.0,
          ];
        // det = 1*4 - (-2)*(-2) = 4 - 4 = 0.00
        await tester.pumpWidget(_wrapSimulation(Vector2DSimulationWidget(data: data)));
        await tester.pump();

        expect(find.textContaining('Attenzione: Vettori Collineari (det = 0)'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('2.3 Zero vector (0, 0) handles normalization, angle, and rendering safely without division by zero', (tester) async {
        final data = InteractiveData()
          ..templateType = 'vector_2d'
          ..parameters = [
            InteractiveParameter()..variableName = 'vx'..defaultValue = 0.0,
            InteractiveParameter()..variableName = 'vy'..defaultValue = 0.0,
          ];
        await tester.pumpWidget(_wrapSimulation(Vector2DSimulationWidget(data: data)));
        await tester.pump();

        // Verify telemetry safe defaults
        expect(find.textContaining('v₁ = (0.0, 0.0)'), findsOneWidget);
        expect(find.text('0.00'), findsWidgets); // Norm ||v1|| = 0.00
        expect(find.textContaining('0.0° (0.00 rad)'), findsOneWidget); // Angle theta = 0.0
        expect(find.textContaining('v₁ = 0.0 e₁ + 0.0 e₂'), findsOneWidget);

        // Verify canvas renders null-point circle without throwing NaN
        expect(tester.takeException(), isNull);
      });

      testWidgets('2.4 Double zero vectors (0, 0) in Span mode do not divide by zero in 1D subspace rendering', (tester) async {
        final data = InteractiveData()
          ..templateType = 'span_2d'
          ..parameters = [
            InteractiveParameter()..variableName = 'vx'..defaultValue = 0.0,
            InteractiveParameter()..variableName = 'vy'..defaultValue = 0.0,
            InteractiveParameter()..variableName = 'v2x'..defaultValue = 0.0,
            InteractiveParameter()..variableName = 'v2y'..defaultValue = 0.0,
          ];
        await tester.pumpWidget(_wrapSimulation(Vector2DSimulationWidget(data: data)));
        await tester.pump();

        expect(find.textContaining('Attenzione: Vettori Collineari'), findsOneWidget);
        expect(find.textContaining('(0.0, 0.0)'), findsWidgets);
        expect(tester.takeException(), isNull);
      });

      testWidgets('2.5 Orthogonal vectors (det != 0, dot = 0) verify full span area and exact Pythagorean norm', (tester) async {
        // Mode 1: Addition with orthogonal vectors (3, 0) and (0, 4)
        final dataAddition = InteractiveData()
          ..templateType = 'vector_addition'
          ..parameters = [
            InteractiveParameter()..variableName = 'v1x'..defaultValue = 3.0,
            InteractiveParameter()..variableName = 'v1y'..defaultValue = 0.0,
            InteractiveParameter()..variableName = 'v2x'..defaultValue = 0.0,
            InteractiveParameter()..variableName = 'v2y'..defaultValue = 4.0,
          ];
        await tester.pumpWidget(_wrapSimulation(Vector2DSimulationWidget(data: dataAddition)));
        await tester.pump();

        // ||v1|| = 3.00, ||v2|| = 4.00, ||v1 + v2|| = sqrt(3^2 + 4^2) = 5.00
        expect(find.text('3.00'), findsOneWidget);
        expect(find.text('4.00'), findsOneWidget);
        expect(find.text('5.00'), findsOneWidget);
        expect(find.textContaining('s = v₁ + v₂ = (3.0, 4.0)'), findsOneWidget);

        // Mode 2: Span with orthogonal vectors (3, 0) and (0, 4)
        final dataSpan = InteractiveData()
          ..templateType = 'span_2d'
          ..parameters = [
            InteractiveParameter()..variableName = 'vx'..defaultValue = 3.0,
            InteractiveParameter()..variableName = 'vy'..defaultValue = 0.0,
            InteractiveParameter()..variableName = 'v2x'..defaultValue = 0.0,
            InteractiveParameter()..variableName = 'v2y'..defaultValue = 4.0,
          ];
        await tester.pumpWidget(_wrapSimulation(Vector2DSimulationWidget(data: dataSpan)));
        await tester.pump();

        // det = 3*4 - 0*0 = 12.00, Area = 12.00
        expect(find.text('12.00'), findsWidgets);
        expect(find.textContaining('Linearmente Indipendenti: Span(v₁, v₂) = ℝ²'), findsOneWidget);
        expect(find.textContaining('Area = 12.00'), findsOneWidget);
      });

      testWidgets('2.6 Negative scalar multipliers invert direction and compute resultant w correctly', (tester) async {
        final data = InteractiveData()
          ..templateType = 'span_2d'
          ..parameters = [
            InteractiveParameter()..variableName = 'vx'..defaultValue = 2.0,
            InteractiveParameter()..variableName = 'vy'..defaultValue = 1.0,
            InteractiveParameter()..variableName = 'v2x'..defaultValue = -1.0,
            InteractiveParameter()..variableName = 'v2y'..defaultValue = 2.0,
            InteractiveParameter()..variableName = 'c1'..defaultValue = -2.0,
            InteractiveParameter()..variableName = 'c2'..defaultValue = -1.5,
          ];
        await tester.pumpWidget(_wrapSimulation(Vector2DSimulationWidget(data: data)));
        await tester.pump();

        // w = -2*(2, 1) + -1.5*(-1, 2) = (-4 + 1.5, -2 - 3) = (-2.5, -5.0)
        expect(find.textContaining('(-2.5, -5.0)'), findsOneWidget);

        // Preset chips test: tap c=(2, -1)
        final chipPreset = find.text('c=(2, -1)');
        expect(chipPreset, findsOneWidget);
        await tester.ensureVisible(chipPreset);
        await tester.tap(chipPreset);
        await tester.pump();

        // w = 2*(2, 1) + -1*(-1, 2) = (4 + 1, 2 - 2) = (5.0, 0.0)
        expect(find.textContaining('(5.0, 0.0)'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    // ========================================================================
    // 3. LAYOUT RESILIENCE ON COMPACT VIEWPORTS
    // ========================================================================
    group('3. Layout Resilience on Compact Viewports', () {
      testWidgets('3.1 No RenderFlex overflow on compact 360x640 viewport across all 3 modes', (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(_wrapSimulation(const Vector2DSimulationWidget(), width: 360));
        await tester.pump();
        expect(tester.takeException(), isNull);

        // Mode 1: Components
        expect(find.text('Componenti'), findsOneWidget);
        expect(tester.takeException(), isNull);

        // Mode 2: Addition
        await tester.tap(find.text('Somma'));
        await tester.pump();
        expect(find.text('Parallelogramma'), findsOneWidget);
        expect(tester.takeException(), isNull);

        // Mode 3: Span & Base
        await tester.tap(find.text('Span & Base'));
        await tester.pump();
        expect(find.text('Determinante det(v₁,v₂)'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('3.2 No RenderFlex overflow on 400x800 viewport across all 3 modes', (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(_wrapSimulation(const Vector2DSimulationWidget(), width: 400));
        await tester.pump();
        expect(tester.takeException(), isNull);

        // Test mode switches
        await tester.tap(find.text('Somma'));
        await tester.pump();
        expect(tester.takeException(), isNull);

        await tester.tap(find.text('Span & Base'));
        await tester.pump();
        expect(tester.takeException(), isNull);
      });
    });

    // ========================================================================
    // 4. ADVERSARIAL STRESS & ROBUSTNESS FUZZING
    // ========================================================================
    group('4. Adversarial Stress & Robustness Fuzzing', () {
      testWidgets('4.1 Extreme numeric parameters clamp safely without unhandled exception', (tester) async {
        final data = InteractiveData()
          ..templateType = 'span_2d'
          ..parameters = [
            InteractiveParameter()..variableName = 'vx'..defaultValue = 1e6,
            InteractiveParameter()..variableName = 'vy'..defaultValue = -1e6,
            InteractiveParameter()..variableName = 'v2x'..defaultValue = 99999.0,
            InteractiveParameter()..variableName = 'v2y'..defaultValue = -88888.0,
            InteractiveParameter()..variableName = 'c1'..defaultValue = 50.0,
            InteractiveParameter()..variableName = 'c2'..defaultValue = -50.0,
          ];
        await tester.pumpWidget(_wrapSimulation(Vector2DSimulationWidget(data: data)));
        await tester.pump();

        // Coordinates should be clamped to +/- 5.0 and scalars to +/- 3.0
        expect(find.textContaining('(5.0, -5.0)'), findsWidgets);
        expect(tester.takeException(), isNull);
      });

      testWidgets('4.2 Rapid stress mode toggling does not corrupt state or ticker', (tester) async {
        await tester.pumpWidget(_wrapSimulation(const Vector2DSimulationWidget()));
        await tester.pump();

        final tabs = [find.text('Somma'), find.text('Span & Base'), find.text('Componenti')];

        for (int i = 0; i < 15; i++) {
          await tester.tap(tabs[i % 3]);
          await tester.pump(const Duration(milliseconds: 16));
        }

        expect(tester.takeException(), isNull);
      });

      testWidgets('4.3 Touch pan start automatically interrupts auto-rotation gracefully', (tester) async {
        await tester.pumpWidget(_wrapSimulation(const Vector2DSimulationWidget()));
        await tester.pump();

        // Start auto-rotation
        final playButton = find.byTooltip('Auto-rotazione vettori');
        await tester.tap(playButton);
        await tester.pump();
        expect(find.byTooltip('Ferma rotazione'), findsOneWidget);

        // Start a pan touch on the canvas
        final canvasFinder = find.byWidgetPredicate((w) => w is CustomPaint && w.painter.runtimeType.toString().contains('Vector2D'));
        final canvasCenter = tester.getCenter(canvasFinder);
        final gesture = await tester.startGesture(canvasCenter);
        await tester.pump();

        // Auto-rotation must be stopped by user interaction
        expect(find.byTooltip('Auto-rotazione vettori'), findsOneWidget);

        await gesture.up();
        await tester.pump();
        expect(tester.takeException(), isNull);
      });
    });
  });
}
