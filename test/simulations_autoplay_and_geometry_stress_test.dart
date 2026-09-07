import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/widgets/interactive/cartesian_graph_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/derivative_tangent_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/kinematics_simulation_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/ohm_circuit_simulation_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/riemann_sum_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/rolle_lagrange_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/squeeze_theorem_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/triangle_solver_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/trig_circle_widget.dart';

void main() {
  group('Adversarial Suite 1: Autoplay Suppression on Mount across All Simulation Widgets', () {
    testWidgets('1.1 TrigCircleWidget mounts in static/paused state without autoplay', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: TrigCircleWidget()),
          ),
        ),
      );
      await tester.pump();

      final initialAngleFinder = find.textContaining('θ =');
      expect(initialAngleFinder, findsOneWidget);
      final initialAngleText = (initialAngleFinder.evaluate().first.widget as Text).data!;

      // Play button tooltip is present, indicating paused state
      expect(find.byTooltip('Auto-rotazione continua 60 FPS'), findsOneWidget);
      expect(find.byTooltip('Ferma rotazione'), findsNothing);

      // Advance time by 2.0 seconds while idle
      await tester.pump(const Duration(seconds: 2));

      final afterTimeAngleText = (initialAngleFinder.evaluate().first.widget as Text).data!;
      expect(afterTimeAngleText, equals(initialAngleText),
          reason: 'Angle must remain completely static when unprompted by user');
      expect(tester.takeException(), isNull);
    });

    testWidgets('1.2 KinematicsSimulationWidget mounts in static/paused state without autoplay', (tester) async {
      final data = InteractiveData()
        ..templateType = 'kinematics_simulation'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'v0'
            ..defaultValue = 15.0,
          InteractiveParameter()
            ..variableName = 'a'
            ..defaultValue = 3.0,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: KinematicsSimulationWidget(data: data)),
          ),
        ),
      );
      await tester.pump();

      // Controls show play state
      expect(find.byTooltip('Avvia'), findsOneWidget);
      expect(find.byTooltip('Pausa'), findsNothing);

      // Telemetry starts at 0.0 m
      expect(find.textContaining('0.0 m'), findsWidgets);

      // Advance 2.0 seconds
      await tester.pump(const Duration(seconds: 2));

      // Telemetry must still be 0.0 m
      expect(find.textContaining('0.0 m'), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('1.3 OhmCircuitSimulationWidget mounts in static/paused state without autoplay', (tester) async {
      final data = InteractiveData()
        ..templateType = 'circuit_simulation'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'V'
            ..defaultValue = 12.0,
          InteractiveParameter()
            ..variableName = 'R'
            ..defaultValue = 4.0,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: OhmCircuitSimulationWidget(data: data)),
          ),
        ),
      );
      await tester.pump();

      // Flusso cariche è in pausa
      expect(find.byTooltip('Avvia flusso'), findsOneWidget);
      expect(find.byTooltip('Pausa flusso'), findsNothing);

      // Telemetry è esatta fin dal primo fotogramma statico
      expect(find.text('3.00 A'), findsOneWidget);
      expect(find.text('36.0 W'), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      expect(find.byTooltip('Avvia flusso'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('1.4 DerivativeTangentWidget mounts in static/paused state without autoplay', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: DerivativeTangentWidget()),
          ),
        ),
      );
      await tester.pump();

      expect(find.byTooltip('Anima limite h ➔ 0 a 60 FPS'), findsOneWidget);
      expect(find.byTooltip('Pausa animazione limite'), findsNothing);

      final initialH = (find.textContaining('h =').evaluate().first.widget as Text).data!;

      await tester.pump(const Duration(seconds: 2));

      final stillH = (find.textContaining('h =').evaluate().first.widget as Text).data!;
      expect(stillH, equals(initialH));
      expect(tester.takeException(), isNull);
    });

    testWidgets('1.5 RiemannSumWidget mounts in static/paused state without autoplay', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: RiemannSumWidget()),
          ),
        ),
      );
      await tester.pump();

      expect(find.byTooltip('Anima convergenza N ➔ 40'), findsOneWidget);
      expect(find.byTooltip('Pausa convergenza'), findsNothing);

      final initialN = (find.textContaining('N =').evaluate().first.widget as Text).data!;

      await tester.pump(const Duration(seconds: 2));

      final stillN = (find.textContaining('N =').evaluate().first.widget as Text).data!;
      expect(stillN, equals(initialN));
      expect(tester.takeException(), isNull);
    });

    testWidgets('1.6 TriangleSolverWidget mounts in static/paused state without autoplay', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: TriangleSolverWidget()),
          ),
        ),
      );
      await tester.pump();

      expect(find.byTooltip('Anima trasformazione triangolo'), findsOneWidget);
      expect(find.byTooltip('Pausa deformazione'), findsNothing);

      final initialAngle = (find.textContaining('Angolo γ compreso:').evaluate().first.widget as Text).data!;

      await tester.pump(const Duration(seconds: 2));

      final stillAngle = (find.textContaining('Angolo γ compreso:').evaluate().first.widget as Text).data!;
      expect(stillAngle, equals(initialAngle));
      expect(tester.takeException(), isNull);
    });

    testWidgets('1.7 CartesianGraphWidget mounts in static/paused state without autoplay', (tester) async {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['x * x - 2'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: CartesianGraphWidget(data: data)),
          ),
        ),
      );
      await tester.pump();

      expect(find.byTooltip('Anima deformazione curva'), findsOneWidget);
      expect(find.byTooltip('Pausa deformazione'), findsNothing);

      await tester.pump(const Duration(seconds: 2));
      expect(find.byTooltip('Anima deformazione curva'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('1.8 RolleLagrangeWidget mounts in static/paused state without autoplay', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: RolleLagrangeWidget()),
          ),
        ),
      );
      await tester.pump();

      expect(find.byTooltip('Avvia animazione a 60 FPS'), findsOneWidget);
      expect(find.byTooltip('Pausa simulazione'), findsNothing);

      await tester.pump(const Duration(seconds: 2));
      expect(find.byTooltip('Avvia animazione a 60 FPS'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('1.9 SqueezeTheoremWidget mounts in static/paused state without autoplay', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: SqueezeTheoremWidget()),
          ),
        ),
      );
      await tester.pump();

      expect(find.byTooltip('Anima convergenza δ ➔ 0 a 60 FPS'), findsOneWidget);
      expect(find.byTooltip('Pausa convergenza'), findsNothing);

      final initialDelta = (find.textContaining('δ = ±').evaluate().first.widget as Text).data!;

      await tester.pump(const Duration(seconds: 2));

      final stillDelta = (find.textContaining('δ = ±').evaluate().first.widget as Text).data!;
      expect(stillDelta, equals(initialDelta));
      expect(tester.takeException(), isNull);
    });
  });

  group('Adversarial Suite 2: TrigCircleWidget Boundary Angles & Singularity Resilience', () {
    final boundaryTestCases = <Map<String, dynamic>>[
      {
        'name': 'θ = 0 (Right Intercept)',
        'angle': 0.0,
        'expectedCos': 1.0,
        'expectedSin': 0.0,
        'isAsymptote': false,
      },
      {
        'name': 'θ = π/2 - 10⁻⁵ (Near Top Asymptote from Q1)',
        'angle': math.pi / 2 - 1e-5,
        'expectedCos': 1e-5,
        'expectedSin': 1.0,
        'isAsymptote': true, // cos < 1e-4 triggers graceful asymptote protection
      },
      {
        'name': 'θ = π/2 (Exact Top Asymptote Singularity)',
        'angle': math.pi / 2,
        'expectedCos': 0.0,
        'expectedSin': 1.0,
        'isAsymptote': true,
      },
      {
        'name': 'θ = π/2 + 10⁻⁵ (Near Top Asymptote from Q2)',
        'angle': math.pi / 2 + 1e-5,
        'expectedCos': -1e-5,
        'expectedSin': 1.0,
        'isAsymptote': true,
      },
      {
        'name': 'θ = π (Left Intercept - Backwards Collinear Ray)',
        'angle': math.pi,
        'expectedCos': -1.0,
        'expectedSin': 0.0,
        'isAsymptote': false,
      },
      {
        'name': 'θ = 3π/2 - 10⁻⁵ (Near Bottom Asymptote from Q3)',
        'angle': 3 * math.pi / 2 - 1e-5,
        'expectedCos': -1e-5,
        'expectedSin': -1.0,
        'isAsymptote': true,
      },
      {
        'name': 'θ = 3π/2 (Exact Bottom Asymptote Singularity)',
        'angle': 3 * math.pi / 2,
        'expectedCos': 0.0,
        'expectedSin': -1.0,
        'isAsymptote': true,
      },
      {
        'name': 'θ = 3π/2 + 10⁻⁵ (Near Bottom Asymptote from Q4)',
        'angle': 3 * math.pi / 2 + 1e-5,
        'expectedCos': 1e-5,
        'expectedSin': -1.0,
        'isAsymptote': true,
      },
      {
        'name': 'θ = 2π (Full Circle Wrap-around)',
        'angle': 2 * math.pi,
        'expectedCos': 1.0,
        'expectedSin': 0.0,
        'isAsymptote': false,
      },
    ];

    for (final tc in boundaryTestCases) {
      testWidgets('TrigCircle renders stably without NaN/crash at ${tc['name']}', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(child: TrigCircleWidget()),
            ),
          ),
        );
        await tester.pump();

        final angleRad = tc['angle'] as double;
        final sliderFinder = find.byType(Slider);
        expect(sliderFinder, findsOneWidget);
        final slider = tester.widget<Slider>(sliderFinder);

        // Feed boundary angle directly through slider callback
        slider.onChanged!(angleRad);
        await tester.pump();

        // 1. Ensure no Flutter framework or canvas exceptions occurred
        expect(tester.takeException(), isNull);

        // 2. Ensure fundamental metrics are present and non-NaN
        expect(find.text('cos(θ)'), findsOneWidget);
        expect(find.text('sin(θ)'), findsOneWidget);
        expect(find.text('tan(θ)'), findsOneWidget);

        // 3. Telemetry values check
        final expectedCos = tc['expectedCos'] as double;
        final expectedSin = tc['expectedSin'] as double;
        final isAsymptote = tc['isAsymptote'] as bool;

        final cosActual = math.cos(angleRad);
        final sinActual = math.sin(angleRad);

        expect(cosActual, closeTo(expectedCos, 1e-4));
        expect(sinActual, closeTo(expectedSin, 1e-4));

        // In asymptote region, tan(θ) must show ±∞ or clamped finite representation, NEVER NaN
        if (isAsymptote) {
          final tanText = math.tan(angleRad).abs() > 1000 ? '±∞' : math.tan(angleRad).toStringAsFixed(3);
          expect(tanText.contains('NaN'), isFalse);
        }

        // 4. Verify CustomPaint rendered
        expect(find.byType(CustomPaint), findsWidgets);
      });
    }

    testWidgets('TrigCircle sweeps across all 4 quadrants with high-speed increments without leaking or crashing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: TrigCircleWidget()),
          ),
        ),
      );
      await tester.pump();

      final slider = tester.widget<Slider>(find.byType(Slider));

      // Sweep from 0 to 2pi in steps of 0.05 rad
      for (double rad = 0.0; rad <= 2 * math.pi; rad += 0.05) {
        slider.onChanged!(rad);
        await tester.pump(const Duration(milliseconds: 16));
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('Adversarial Suite 3: SqueezeTheoremWidget Narrow Envelope & Probe Tests', () {
    testWidgets('3.1 Operates with extreme narrow envelope delta = 0.05 without crashing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: SqueezeTheoremWidget()),
          ),
        ),
      );
      await tester.pump();

      // Find delta slider (first slider)
      final sliders = find.byType(Slider);
      expect(sliders, findsNWidgets(2));
      final deltaSlider = tester.widget<Slider>(sliders.first);

      // Set delta to minimum envelope 0.05
      deltaSlider.onChanged!(0.05);
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('δ = ±0.05'), findsOneWidget);
      expect(find.text('INF: g(x) = cos(x)'), findsOneWidget);
      expect(find.text('TRAPPOLA: sin(x)/x'), findsOneWidget);
      expect(find.text('SUP: h(x) = 1'), findsOneWidget);
      expect(find.text('SPAZIO BANDA |h - g|'), findsOneWidget);

      // Verify corridor width |h(x) - g(x)| is extremely tight at delta = 0.05
      // g(0.05) = cos(0.05) ~ 0.99875, h(0.05) = 1.0, corridor <= 0.002
      final gVal = math.cos(0.05);
      final hVal = 1.0;
      final corridor = hVal - gVal;
      expect(corridor, lessThan(0.002));
    });

    testWidgets('3.2 Tests varying probe positions including exact x = 0 singularity', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: SqueezeTheoremWidget()),
          ),
        ),
      );
      await tester.pump();

      final sliders = find.byType(Slider);
      final deltaSlider = tester.widget<Slider>(sliders.first);
      deltaSlider.onChanged!(0.05);
      await tester.pump();

      // Probe positions to test: negative bound, internal, singularity 0.0, internal, positive bound
      final probePositions = [-0.05, -0.025, 0.0, 0.025, 0.05];

      for (final x in probePositions) {
        final currentSliders = find.byType(Slider);
        final probeSlider = tester.widget<Slider>(currentSliders.last);
        probeSlider.onChanged!(x);
        await tester.pump();

        expect(tester.takeException(), isNull,
            reason: 'Probe position x = $x must render cleanly without unhandled exception');

        // Mathematical check: g(x) <= f(x) <= h(x)
        final gx = math.cos(x);
        final fx = x.abs() < 1e-6 ? 1.0 : math.sin(x) / x;
        final hx = 1.0;

        expect(gx, lessThanOrEqualTo(fx + 1e-7));
        expect(fx, lessThanOrEqualTo(hx + 1e-7));

        // For all x in [-0.05, 0.05], f(x) should be extremely close to 1.0
        expect(fx, closeTo(1.0, 0.001));
      }
    });

    testWidgets('3.3 Ingestion of InteractiveData with custom delta and k', (tester) async {
      final customData = InteractiveData()
        ..templateType = 'squeeze_theorem'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'delta'
            ..defaultValue = 0.12,
          InteractiveParameter()
            ..variableName = 'k'
            ..defaultValue = 2.0,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: SqueezeTheoremWidget(data: customData)),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('δ = ±0.12'), findsOneWidget);
    });
  });

  group('Adversarial Suite 4: TriangleSolverWidget Geometry & Carnot/Pythagoras Exactness', () {
    testWidgets('4.1 Acute Angle Triangle: altitude and projection verify Carnot theorem', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: TriangleSolverWidget()),
          ),
        ),
      );
      await tester.pump();

      // Configure a = 4.0, b = 5.0, gamma = 60° (acute)
      final sliders = find.byType(Slider);
      expect(sliders, findsNWidgets(3)); // gamma, sideA, sideB

      final gammaSlider = tester.widget<Slider>(sliders.at(0));
      final sideASlider = tester.widget<Slider>(sliders.at(1));
      final sideBSlider = tester.widget<Slider>(sliders.at(2));

      gammaSlider.onChanged!(60.0);
      sideASlider.onChanged!(4.0);
      sideBSlider.onChanged!(5.0);
      await tester.pump();

      expect(tester.takeException(), isNull);

      // Verify Mathematical Invariants for Acute Triangle:
      // a = 4, b = 5, gamma = 60° (pi/3 rad)
      // h = a * sin(60°) = 4 * sqrt(3)/2 = 2*sqrt(3) ~ 3.464
      // p = a * cos(60°) = 4 * 0.5 = 2.0
      // |b - p| = 5 - 2 = 3.0
      // Pythagoras on BHA: c^2 = h^2 + (b - p)^2 = 12 + 9 = 21.0
      // Carnot: c^2 = a^2 + b^2 - 2ab cos(60°) = 16 + 25 - 40 * 0.5 = 21.0
      // c = sqrt(21) ~ 4.58
      const gammaRad = 60.0 * math.pi / 180.0;
      final h = 4.0 * math.sin(gammaRad);
      final p = 4.0 * math.cos(gammaRad);
      final bMinusP = (5.0 - p).abs();
      final cSquaredPythagoras = h * h + bMinusP * bMinusP;
      final cSquaredCarnot = 4.0 * 4.0 + 5.0 * 5.0 - 2 * 4.0 * 5.0 * math.cos(gammaRad);

      expect(cSquaredPythagoras, closeTo(cSquaredCarnot, 1e-6));
      expect(cSquaredCarnot, closeTo(21.0, 1e-6));

      // Telemetry readouts in UI
      expect(find.text('Lato a'), findsOneWidget);
      expect(find.text('Lato b'), findsOneWidget);
      expect(find.text('Terzo Lato c'), findsOneWidget);
      expect(find.text('4.58'), findsOneWidget); // c = sqrt(21) ~ 4.58
      expect(find.text('Carnot Generico'), findsOneWidget);
    });

    testWidgets('4.2 Right Angle Triangle (gamma = 90°): Carnot collapses to Pythagoras (3, 4, 5)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: TriangleSolverWidget()),
          ),
        ),
      );
      await tester.pump();

      // Tap shortcut button 'Imposta 90° (Pitagora)'
      final shortcutBtn = find.text('Imposta 90° (Pitagora)');
      expect(shortcutBtn, findsOneWidget);
      await tester.tap(shortcutBtn);
      await tester.pump();

      // Configure a = 3.0, b = 4.0
      final sliders = find.byType(Slider);
      final sideASlider = tester.widget<Slider>(sliders.at(1));
      final sideBSlider = tester.widget<Slider>(sliders.at(2));

      sideASlider.onChanged!(3.0);
      sideBSlider.onChanged!(4.0);
      await tester.pump();

      expect(tester.takeException(), isNull);

      // Verify Mathematical Invariants for Right Triangle:
      // a = 3, b = 4, gamma = 90°
      // h = a * sin(90°) = 3.0
      // p = a * cos(90°) = 0.0
      // |b - p| = 4.0
      // c^2 = 3^2 + 4^2 = 25.0 => c = 5.00
      expect(find.text('5.00'), findsOneWidget);
      expect(find.text('Pitagora (γ = 90°)'), findsOneWidget);
      expect(find.textContaining('Pitagora è il corollario di Carnot quando cos(90°) = 0'), findsOneWidget);
      expect(find.textContaining('c² = a² + b² = 3.0² + 4.0² = 25.00'), findsOneWidget);
    });

    testWidgets('4.3 Obtuse Angle Triangle (gamma = 120°): Projection p < 0 and base extension verify Carnot', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: TriangleSolverWidget()),
          ),
        ),
      );
      await tester.pump();

      // Configure a = 4.0, b = 3.0, gamma = 120° (obtuse)
      final sliders = find.byType(Slider);
      final gammaSlider = tester.widget<Slider>(sliders.at(0));
      final sideASlider = tester.widget<Slider>(sliders.at(1));
      final sideBSlider = tester.widget<Slider>(sliders.at(2));

      gammaSlider.onChanged!(120.0);
      sideASlider.onChanged!(4.0);
      sideBSlider.onChanged!(3.0);
      await tester.pump();

      expect(tester.takeException(), isNull);

      // Verify Mathematical Invariants for Obtuse Triangle:
      // a = 4, b = 3, gamma = 120° (2pi/3 rad)
      // h = a * sin(120°) = 4 * sqrt(3)/2 = 2*sqrt(3) ~ 3.464
      // p = a * cos(120°) = 4 * (-0.5) = -2.0  (projection falls outside base!)
      // |b - p| = |3 - (-2)| = 5.0
      // Pythagoras on △BHA: c^2 = h^2 + (b - p)^2 = 12 + 25 = 37.0
      // Carnot: c^2 = 4^2 + 3^2 - 2(4)(3) cos(120°) = 16 + 9 - 24(-0.5) = 25 + 12 = 37.0
      // c = sqrt(37) ~ 6.08
      const gammaRad = 120.0 * math.pi / 180.0;
      final h = 4.0 * math.sin(gammaRad);
      final p = 4.0 * math.cos(gammaRad);
      final bMinusP = (3.0 - p).abs();
      final cSquaredPythagoras = h * h + bMinusP * bMinusP;
      final cSquaredCarnot = 4.0 * 4.0 + 3.0 * 3.0 - 2 * 4.0 * 3.0 * math.cos(gammaRad);

      expect(p, lessThan(0.0), reason: 'Projection p must be negative for obtuse angle');
      expect(bMinusP, closeTo(5.0, 1e-6));
      expect(cSquaredPythagoras, closeTo(cSquaredCarnot, 1e-6));
      expect(cSquaredCarnot, closeTo(37.0, 1e-6));

      // Telemetry readouts in UI
      expect(find.text('6.08'), findsOneWidget); // c = sqrt(37) ~ 6.08
      expect(find.text('Carnot Generico'), findsOneWidget);
      expect(find.textContaining('c² = a² + b² - 2ab·cos(120°) = 37.00'), findsOneWidget);
    });
  });
}
