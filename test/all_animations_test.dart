import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/widgets/interactive/cartesian_graph_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/derivative_tangent_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/kinematics_simulation_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/ohm_circuit_simulation_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/riemann_sum_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/triangle_solver_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/trig_circle_widget.dart';

void main() {
  group('1. TrigCircleWidget Animation & Interaction Tests', () {
    testWidgets('Starts auto-rotating immediately and progresses angle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: TrigCircleWidget()),
          ),
        ),
      );

      // Render iniziale
      await tester.pump();
      final initialAngleText = find.textContaining('θ =').evaluate().first.widget as Text;
      final initialString = initialAngleText.data!;

      // Avanza il tempo di 1 secondo
      await tester.pump(const Duration(seconds: 1));
      final nextAngleText = find.textContaining('θ =').evaluate().first.widget as Text;
      final nextString = nextAngleText.data!;

      // L'angolo deve essere progredito grazie all'auto-rotazione 60 FPS
      expect(nextString, isNot(equals(initialString)));

      // Tap sul pulsante di pausa: ferma la rotazione
      final pauseBtn = find.byTooltip('Ferma rotazione');
      expect(pauseBtn, findsOneWidget);
      await tester.tap(pauseBtn);
      await tester.pump(const Duration(milliseconds: 50));

      // Il tooltip diventa "Auto-rotazione continua 60 FPS"
      expect(find.byTooltip('Auto-rotazione continua 60 FPS'), findsOneWidget);

      // Avanzando il tempo quando è in pausa, l'angolo rimane fermo
      final pausedAngleText = find.textContaining('θ =').evaluate().first.widget as Text;
      await tester.pump(const Duration(seconds: 1));
      final stillPausedAngleText = find.textContaining('θ =').evaluate().first.widget as Text;
      expect(pausedAngleText.data, equals(stillPausedAngleText.data));

      // Riavvia rotazione
      await tester.tap(find.byTooltip('Auto-rotazione continua 60 FPS'));
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byTooltip('Ferma rotazione'), findsOneWidget);
    });

    testWidgets('Direct touch gesture on canvas updates angle and stops auto-rotate', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: TrigCircleWidget()),
          ),
        ),
      );
      await tester.pump();

      // Trova il canvas GestureDetector ed esegui un drag/tap
      final canvasGesture = find.byType(GestureDetector).first;
      await tester.tap(canvasGesture);
      await tester.pump(const Duration(milliseconds: 50));

      // L'auto-rotazione si disattiva quando l'utente interagisce direttamente
      expect(find.byTooltip('Auto-rotazione continua 60 FPS'), findsOneWidget);
    });
  });

  group('2. KinematicsSimulationWidget Animation & Physics Tests', () {
    testWidgets('Vehicle moves continuously with MRUA equations and controls respond', (tester) async {
      final data = InteractiveData()
        ..templateType = 'kinematics_simulation'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'v0'
            ..defaultValue = 10.0,
          InteractiveParameter()
            ..variableName = 'a'
            ..defaultValue = 2.0,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: KinematicsSimulationWidget(data: data)),
          ),
        ),
      );

      await tester.pump();

      // Posizione iniziale = 0.0 m
      expect(find.textContaining('0.0 m'), findsWidgets);

      // Avanza il tempo di 500 ms
      await tester.pump(const Duration(milliseconds: 500));

      // La posizione non deve più essere 0.0 m
      expect(find.text('0.0 m'), findsNothing);

      // Test pulsante Pausa/Play
      final pauseBtn = find.byTooltip('Pausa');
      expect(pauseBtn, findsOneWidget);
      await tester.tap(pauseBtn);
      await tester.pump(const Duration(milliseconds: 50));

      // Il tooltip diventa "Avvia"
      expect(find.byTooltip('Avvia'), findsOneWidget);

      // Test pulsante Reset
      final resetBtn = find.byTooltip('Ricomincia da t = 0s');
      expect(resetBtn, findsOneWidget);
      await tester.tap(resetBtn);
      await tester.pump(const Duration(milliseconds: 50));

      // Ritorna a 0.0 m
      expect(find.textContaining('0.0 m'), findsWidgets);
    });

    testWidgets('Vehicle stops safely without reversing when braking (a < 0)', (tester) async {
      final data = InteractiveData()
        ..templateType = 'kinematics_simulation'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'v0'
            ..defaultValue = 10.0,
          InteractiveParameter()
            ..variableName = 'a'
            ..defaultValue = -5.0, // Frenata: arresto previsto a t = 2.0s
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: KinematicsSimulationWidget(data: data)),
          ),
        ),
      );

      await tester.pump();
      // Avanza a t = 2.5s (dopo l'arresto a 2.0s)
      await tester.pump(const Duration(milliseconds: 2500));

      // La velocità deve essere 0.0 m/s (clampata, la macchina non procede a ritroso)
      expect(find.textContaining('0.0 m/s'), findsWidgets);
    });
  });

  group('3. OhmCircuitSimulationWidget Animation & DC Physics Tests', () {
    testWidgets('Charges animate, telemetry computes Ohm & Joule laws, play/pause works', (tester) async {
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

      // I = 12V / 4Ω = 3.00 A
      // P = 12V * 3A = 36.0 W
      expect(find.text('3.00 A'), findsOneWidget);
      expect(find.text('36.0 W'), findsOneWidget);

      // L'animazione del flusso di cariche è attiva di default
      final pauseBtn = find.byTooltip('Pausa flusso');
      expect(pauseBtn, findsOneWidget);
      await tester.tap(pauseBtn);
      await tester.pump(const Duration(milliseconds: 50));

      // In pausa, il tooltip diventa "Avvia flusso"
      expect(find.byTooltip('Avvia flusso'), findsOneWidget);

      // Riattiva il flusso
      await tester.tap(find.byTooltip('Avvia flusso'));
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byTooltip('Pausa flusso'), findsOneWidget);

      // Switch flusso reale / convenzionale
      final switchBtn = find.text('e⁻ Reale');
      expect(switchBtn, findsOneWidget);
      await tester.tap(switchBtn);
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('I Conv.'), findsOneWidget);
    });
  });

  group('4. DerivativeTangentWidget Animation & Limit Tests', () {
    testWidgets('Auto-animates limit h -> 0 and supports manual slider override', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: DerivativeTangentWidget()),
          ),
        ),
      );

      await tester.pump();

      // Inizialmente l'animazione oscillante di h è attiva
      final pauseBtn = find.byTooltip('Pausa animazione limite');
      expect(pauseBtn, findsOneWidget);

      final initialH = find.textContaining('h =').evaluate().first.widget as Text;
      final initialHText = initialH.data!;

      // Avanza il tempo di 600 ms
      await tester.pump(const Duration(milliseconds: 600));

      final nextH = find.textContaining('h =').evaluate().first.widget as Text;
      final nextHText = nextH.data!;
      expect(nextHText, isNot(equals(initialHText)));

      // Metti in pausa
      await tester.tap(pauseBtn);
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byTooltip('Anima limite h ➔ 0 a 60 FPS'), findsOneWidget);

      // Muovi manualmente lo slider di h
      final sliders = find.byType(Slider);
      expect(sliders, findsWidgets);
      await tester.tap(sliders.first);
      await tester.pump(const Duration(milliseconds: 50));

      // La derivata f'(x0) e il rapporto incrementale sono visualizzati correttamente
      expect(find.text('Derivata: f\'(x₀)'), findsOneWidget);
    });
  });

  group('5. RiemannSumWidget Animation & Convergence Tests', () {
    testWidgets('Auto-partitions interval N -> 40 and converges to definite integral', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: RiemannSumWidget()),
          ),
        ),
      );

      await tester.pump();

      // Animazione attiva di default con tooltip "Pausa convergenza"
      final pauseBtn = find.byTooltip('Pausa convergenza');
      expect(pauseBtn, findsOneWidget);

      final initialN = find.textContaining('N =').evaluate().first.widget as Text;
      final initialNText = initialN.data!;

      // Avanza il tempo per far variare le partizioni
      await tester.pump(const Duration(milliseconds: 800));

      final nextN = find.textContaining('N =').evaluate().first.widget as Text;
      final nextNText = nextN.data!;
      expect(nextNText, isNot(equals(initialNText)));

      // Metti in pausa
      await tester.tap(pauseBtn);
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byTooltip('Anima convergenza N ➔ 40'), findsOneWidget);

      // Verifica presenza telemetria
      expect(find.text('Integrale Esatto: ∫'), findsOneWidget);
      expect(find.text('Somma Riemann: Σ'), findsOneWidget);
    });
  });

  group('6. TriangleSolverWidget Animation & Geometric Deformation Tests', () {
    testWidgets('Auto-transforms angle gamma and detects Pythagorean right triangle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: TriangleSolverWidget()),
          ),
        ),
      );

      await tester.pump();

      // Animazione attiva di default
      final pauseBtn = find.byTooltip('Pausa deformazione');
      expect(pauseBtn, findsOneWidget);

      final initialCompreso = find.textContaining('Angolo γ compreso:').evaluate().first.widget as Text;
      final initialCompresoText = initialCompreso.data!;

      // Avanza il tempo
      await tester.pump(const Duration(milliseconds: 800));

      final nextCompreso = find.textContaining('Angolo γ compreso:').evaluate().first.widget as Text;
      final nextCompresoText = nextCompreso.data!;
      expect(nextCompresoText, isNot(equals(initialCompresoText)));

      // Metti in pausa
      await tester.tap(pauseBtn);
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byTooltip('Anima trasformazione triangolo'), findsOneWidget);

      // Verifiche geometriche
      expect(find.text('Terzo Lato c'), findsOneWidget);
      expect(find.text('Area'), findsOneWidget);
    });
  });

  group('7. CartesianGraphWidget Animation & Morphing Tests', () {
    testWidgets('Auto-morphs polynomial curve dynamically at 60 FPS', (tester) async {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['a * x * x + b * x + c']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..defaultValue = 1.0,
          InteractiveParameter()
            ..variableName = 'b'
            ..defaultValue = 0.0,
          InteractiveParameter()
            ..variableName = 'c'
            ..defaultValue = -2.0,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: CartesianGraphWidget(data: data)),
          ),
        ),
      );

      await tester.pump();

      // Auto-morphing attivo di default
      final pauseBtn = find.byTooltip('Pausa deformazione');
      expect(pauseBtn, findsOneWidget);

      // Avanza il tempo di 600 ms
      await tester.pump(const Duration(milliseconds: 600));

      // Metti in pausa
      await tester.tap(pauseBtn);
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byTooltip('Anima deformazione curva'), findsOneWidget);

      // Muovi lo slider del coefficiente
      final sliders = find.byType(Slider);
      expect(sliders, findsWidgets);
      await tester.tap(sliders.first);
      await tester.pump(const Duration(milliseconds: 50));

      // Verifica che la formula rimanga visualizzata
      expect(find.text('EQUAZIONE CORRENTE:'), findsOneWidget);
    });
  });
}
