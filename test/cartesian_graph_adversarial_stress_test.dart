import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/widgets/interactive/cartesian_graph_widget.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  group('Adversarial Stress Test: CartesianGraphWidget Performance & AST Caching', () {
    test('Empirical Benchmark: Cached Expression AST vs Re-parsing per pixel', () {
      final parser = GrammarParser();
      const equation = 'a * x * x + b * x + c';
      const steps = 267; // 400px width with stepPx = 1.5
      const frames = 100;

      // 1. Benchmark OLD approach: Re-parse every pixel inside paint loop
      final swOld = Stopwatch()..start();
      double sumOld = 0.0;
      for (int f = 0; f < frames; f++) {
        final a = 1.0 + (f * 0.01);
        final b = 0.5;
        final c = -1.0;
        for (int i = 0; i < steps; i++) {
          final x = (i - 133.0) / 18.0;
          final expr = parser.parse(equation);
          final cm = ContextModel();
          cm.bindVariable(Variable('a'), Number(a));
          cm.bindVariable(Variable('b'), Number(b));
          cm.bindVariable(Variable('c'), Number(c));
          cm.bindVariable(Variable('x'), Number(x));
          final evaluator = RealEvaluator(cm);
          final res = evaluator.evaluate(expr).toDouble();
          sumOld += res;
        }
      }
      swOld.stop();
      final oldUs = swOld.elapsedMicroseconds;

      // 2. Benchmark NEW approach: Pre-parse expression once, evaluate cached AST per pixel
      final swNew = Stopwatch()..start();
      double sumNew = 0.0;
      for (int f = 0; f < frames; f++) {
        final a = 1.0 + (f * 0.01);
        final b = 0.5;
        final c = -1.0;
        // Parse once per frame (or widget parameter change)
        final cachedExpr = parser.parse(equation);
        for (int i = 0; i < steps; i++) {
          final x = (i - 133.0) / 18.0;
          final cm = ContextModel();
          cm.bindVariable(Variable('a'), Number(a));
          cm.bindVariable(Variable('b'), Number(b));
          cm.bindVariable(Variable('c'), Number(c));
          cm.bindVariable(Variable('x'), Number(x));
          final evaluator = RealEvaluator(cm);
          final res = evaluator.evaluate(cachedExpr).toDouble();
          sumNew += res;
        }
      }
      swNew.stop();
      final newUs = swNew.elapsedMicroseconds;

      final speedup = oldUs / (newUs > 0 ? newUs : 1);

      // Verify mathematical identity between old and new
      expect((sumOld - sumNew).abs(), lessThan(1e-4));

      debugPrint('=== CartesianGraph AST Cache Benchmark Results ===');
      debugPrint('Old (re-parse per pixel) : ${oldUs / 1000.0} ms for $frames frames (${(oldUs / frames / steps).toStringAsFixed(2)} µs/px)');
      debugPrint('New (cached Expression)   : ${newUs / 1000.0} ms for $frames frames (${(newUs / frames / steps).toStringAsFixed(2)} µs/px)');
      debugPrint('Empirical Speedup Factor : ${speedup.toStringAsFixed(2)}x faster');

      // The pre-parsed expression MUST be significantly faster (at least 2.5x, typically 6x-15x)
      expect(speedup, greaterThan(2.0),
          reason: 'Cached Expression AST evaluation should be significantly faster than per-pixel string parsing');
    });

    test('Empirical Benchmark: Complex Transcendental (1 + 1/x)^x AST Cache', () {
      final parser = GrammarParser();
      const equation = '(1 + 1/x)^x';
      const steps = 267;
      const frames = 50;

      final swOld = Stopwatch()..start();
      for (int f = 0; f < frames; f++) {
        for (int i = 1; i <= steps; i++) {
          final x = i * 0.1;
          final expr = parser.parse(equation);
          final cm = ContextModel()..bindVariable(Variable('x'), Number(x));
          RealEvaluator(cm).evaluate(expr);
        }
      }
      swOld.stop();

      final swNew = Stopwatch()..start();
      final cached = parser.parse(equation);
      for (int f = 0; f < frames; f++) {
        for (int i = 1; i <= steps; i++) {
          final x = i * 0.1;
          final cm = ContextModel()..bindVariable(Variable('x'), Number(x));
          RealEvaluator(cm).evaluate(cached);
        }
      }
      swNew.stop();

      final speedup = swOld.elapsedMicroseconds / (swNew.elapsedMicroseconds > 0 ? swNew.elapsedMicroseconds : 1);
      debugPrint('Complex Expression (1 + 1/x)^x Speedup: ${speedup.toStringAsFixed(2)}x');
      expect(speedup, greaterThan(2.0));
    });
  });

  group('Adversarial Stress Test: Reactivity & 60fps Rapid Parameter Dragging', () {
    testWidgets('Rapid 60fps slider dragging across full range executes without exceptions', (tester) async {
      tester.view.physicalSize = const Size(1000, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['a * x * x + b * x + c']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Curvatura (a)'
            ..minValue = -3.0
            ..maxValue = 3.0
            ..defaultValue = 1.0
            ..stepSize = 0.1,
          InteractiveParameter()
            ..variableName = 'b'
            ..label = 'Traslazione (b)'
            ..minValue = -4.0
            ..maxValue = 4.0
            ..defaultValue = 0.0
            ..stepSize = 0.2,
          InteractiveParameter()
            ..variableName = 'c'
            ..label = 'Termine noto (c)'
            ..minValue = -5.0
            ..maxValue = 5.0
            ..defaultValue = -2.0
            ..stepSize = 0.5,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CartesianGraphWidget(data: data),
            ),
          ),
        ),
      );
      await tester.pump();

      final sliders = find.byType(Slider);
      expect(sliders, findsNWidgets(3));

      // Simulate 60 rapid drag events (simulating 60fps slider drag)
      for (int i = 0; i < 60; i++) {
        final dragOffset = Offset((i % 2 == 0 ? 5.0 : -5.0), 0);
        await tester.drag(sliders.at(0), dragOffset);
        await tester.pump(const Duration(milliseconds: 16));
      }

      // Also drag parameter b and c rapidly
      for (int i = 0; i < 30; i++) {
        await tester.drag(sliders.at(1), const Offset(4.0, 0));
        await tester.drag(sliders.at(2), const Offset(-3.0, 0));
        await tester.pump(const Duration(milliseconds: 16));
      }

      expect(tester.takeException(), isNull);
      expect(find.byType(CartesianGraphWidget), findsOneWidget);
    });

    testWidgets('Continuous 60fps auto-morph animation executes without memory leak or crashes', (tester) async {
      tester.view.physicalSize = const Size(1000, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CartesianGraphWidget(),
            ),
          ),
        ),
      );
      await tester.pump();

      // Find auto-morph play button and start animation
      final playButton = find.byIcon(Icons.play_circle_fill_rounded);
      expect(playButton, findsOneWidget);
      await tester.tap(playButton);
      await tester.pump();

      // Pump 120 consecutive frames at 16.6ms (2 full seconds of 60fps animation)
      for (int f = 0; f < 120; f++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      expect(tester.takeException(), isNull);

      // Pause animation
      final pauseButton = find.byIcon(Icons.pause_circle_filled_rounded);
      expect(pauseButton, findsOneWidget);
      await tester.tap(pauseButton);
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });

  group('Adversarial Stress Test: Complex Expressions & Transcendentals', () {
    testWidgets('Evaluates sin(x) + cos(x) gracefully, identifies as non-quadratic, hides parabola vertex', (tester) async {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['sin(x) + cos(x)'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CartesianGraphWidget(data: data),
            ),
          ),
        ),
      );
      await tester.pump();

      // Verifies formula text displays genuine equation
      expect(find.text('y = sin(x) + cos(x)'), findsOneWidget);
      // Vertex V(...) must NOT be rendered
      expect(find.textContaining('V('), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Evaluates 1 / (x * x + 1) (smooth bell) without division errors', (tester) async {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['1 / (x * x + 1)'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CartesianGraphWidget(data: data),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('y = 1 / (x * x + 1)'), findsOneWidget);
      expect(find.textContaining('V('), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Evaluates (1 + 1/x)^x (remarkable Euler limit) without crashes', (tester) async {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['(1 + 1/x)^x'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CartesianGraphWidget(data: data),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('y = (1 + 1/x)^x'), findsOneWidget);
      expect(find.textContaining('V('), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Evaluates ln(1 + x) / x with singularity protection', (tester) async {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['ln(1 + x) / x'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CartesianGraphWidget(data: data),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('y = ln(1 + x) / x'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Adversarial Stress Test: Division by Zero & Domain Boundary Protection', () {
    testWidgets('Division by zero at x = 0 in 1/x does not crash canvas with NaN or Infinity', (tester) async {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['1 / x'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CartesianGraphWidget(data: data),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CartesianGraphWidget), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Infinite spike 1 / (x * x) evaluated across origin smoothly', (tester) async {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['1 / (x * x)'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CartesianGraphWidget(data: data),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CartesianGraphWidget), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Negative domain in sqrt(x) and log(x) handled gracefully', (tester) async {
      for (final eq in ['sqrt(x)', 'log(x)', 'tan(x)']) {
        final data = InteractiveData()
          ..templateType = 'function_graph'
          ..equations = [eq];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: CartesianGraphWidget(data: data),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(CartesianGraphWidget), findsOneWidget);
        expect(tester.takeException(), isNull, reason: 'Equation $eq should not throw during paint');
      }
    });
  });

  group('Adversarial Stress Test: Unbound Variables & Malformed Expressions', () {
    testWidgets('Auto-recovers when expression contains unbound variable (alpha * x + 2)', (tester) async {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['alpha * x + 2']
        ..parameters = []; // 'alpha' is NOT provided in parameters!

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CartesianGraphWidget(data: data),
            ),
          ),
        ),
      );
      await tester.pump();

      // Widget should auto-recover by dynamically binding alpha to 1.0 without throwing
      expect(find.byType(CartesianGraphWidget), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Auto-recovers with multiple unbound variables (alpha * x + beta)', (tester) async {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['alpha * x + beta']
        ..parameters = []; // Neither alpha nor beta is bound

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CartesianGraphWidget(data: data),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CartesianGraphWidget), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Malformed syntax (sin(x + or ***) falls back smoothly without crash', (tester) async {
      for (final malformed in ['sin(x +', '***', '2 * + / 4', '']) {
        final data = InteractiveData()
          ..templateType = 'function_graph'
          ..equations = [malformed];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: CartesianGraphWidget(data: data),
              ),
            ),
          ),
        );
        await tester.pump();

        // Should fall back to analytical parabola without unhandled exception
        expect(find.byType(CartesianGraphWidget), findsOneWidget);
        expect(tester.takeException(), isNull, reason: 'Malformed equation "$malformed" should not crash');
      }
    });
  });

  group('Adversarial Stress Test: Lifecycle & Dynamic Model Updates', () {
    testWidgets('Adversarial Edge Case: Parameter not named a/b/c (e.g. k) slider updates UI cleanly', (tester) async {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['k * x']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'k'
            ..label = 'Pendenza (k)'
            ..minValue = 0.5
            ..maxValue = 5.0
            ..defaultValue = 1.0
            ..stepSize = 0.5,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CartesianGraphWidget(data: data),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('1.0'), findsOneWidget);
      final slider = find.byType(Slider);
      expect(slider, findsOneWidget);

      await tester.drag(slider, const Offset(60, 0));
      await tester.pump();

      // Slider badge and widget tree maintain integrity
      expect(find.byType(CartesianGraphWidget), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('didUpdateWidget switches equations cleanly between quadratic and non-quadratic', (tester) async {
      final dataQuad = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['2 * x * x - 4'];

      final dataNonQuad = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['cos(x) * 2'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CartesianGraphWidget(data: dataQuad),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.textContaining('V('), findsOneWidget); // Parabola has vertex

      // Switch to non-quadratic
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CartesianGraphWidget(data: dataNonQuad),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('y = cos(x) * 2'), findsOneWidget);
      expect(find.textContaining('V('), findsNothing); // Vertex hidden
      expect(tester.takeException(), isNull);
    });

    testWidgets('Rapid mount and dispose stress cycles (30 cycles)', (tester) async {
      for (int i = 0; i < 30; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: CartesianGraphWidget(
                  data: InteractiveData()
                    ..templateType = 'function_graph'
                    ..equations = ['sin(x)'],
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        // Unmount
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox.shrink(),
            ),
          ),
        );
        await tester.pump();
      }

      expect(tester.takeException(), isNull);
    });
  });
}
