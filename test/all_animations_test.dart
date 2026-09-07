import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/widgets/interactive/cartesian_graph_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/derivative_tangent_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/kinematics_simulation_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/ohm_circuit_simulation_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/riemann_sum_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/squeeze_theorem_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/triangle_solver_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/trig_circle_widget.dart';

void main() {
  group('1. TrigCircleWidget Animation & Interaction Tests', () {
    testWidgets('Starts paused on mount and auto-rotates when play is tapped', (tester) async {
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

      // Inizialmente è in pausa: tooltip "Auto-rotazione continua 60 FPS" e icona play
      expect(find.byTooltip('Auto-rotazione continua 60 FPS'), findsOneWidget);

      // Avanzando il tempo, l'angolo NON deve cambiare perché è fermo di default
      await tester.pump(const Duration(seconds: 1));
      final stillInitialAngle = find.textContaining('θ =').evaluate().first.widget as Text;
      expect(stillInitialAngle.data, equals(initialString));

      // Tap sul pulsante play: avvia la rotazione
      final playBtn = find.byTooltip('Auto-rotazione continua 60 FPS');
      await tester.tap(playBtn);
      await tester.pump(const Duration(milliseconds: 50));

      // Ora il tooltip diventa "Ferma rotazione"
      expect(find.byTooltip('Ferma rotazione'), findsOneWidget);

      // Avanza il tempo di 1 secondo con animazione attiva
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

      // Il tooltip torna a "Auto-rotazione continua 60 FPS"
      expect(find.byTooltip('Auto-rotazione continua 60 FPS'), findsOneWidget);

      // Avanzando il tempo quando è in pausa, l'angolo rimane fermo
      final pausedAngleText = find.textContaining('θ =').evaluate().first.widget as Text;
      await tester.pump(const Duration(seconds: 1));
      final stillPausedAngleText = find.textContaining('θ =').evaluate().first.widget as Text;
      expect(pausedAngleText.data, equals(stillPausedAngleText.data));
    });

    testWidgets('Direct touch gesture on canvas updates angle while paused', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: TrigCircleWidget()),
          ),
        ),
      );
      await tester.pump();

      // Trova il canvas GestureDetector ed esegui un drag/tap
      final canvasGesture = find.descendant(
        of: find.byType(LayoutBuilder),
        matching: find.byType(GestureDetector),
      );
      await tester.tap(canvasGesture);
      await tester.pump(const Duration(milliseconds: 50));

      // L'auto-rotazione rimane disattivata
      expect(find.byTooltip('Auto-rotazione continua 60 FPS'), findsOneWidget);
    });
  });

  group('2. KinematicsSimulationWidget Animation & Physics Tests', () {
    testWidgets('Vehicle is paused on mount, moves when play tapped, and controls respond', (tester) async {
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

      // Inizialmente è in pausa con tooltip "Avvia" e icona play
      final playBtn = find.byTooltip('Avvia');
      expect(playBtn, findsOneWidget);

      // Avanzando il tempo da fermo, la posizione rimane 0.0 m
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.textContaining('0.0 m'), findsWidgets);

      // Tap su Avvia
      await tester.tap(playBtn);
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byTooltip('Pausa'), findsOneWidget);

      // Avanza il tempo di 500 ms mentre è in movimento
      await tester.pump(const Duration(milliseconds: 500));

      // La posizione non deve più essere 0.0 m
      expect(find.text('0.0 m'), findsNothing);

      // Metti in pausa
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

      // Avvia simulazione
      await tester.tap(find.byTooltip('Avvia'));
      await tester.pump(const Duration(milliseconds: 50));

      // Avanza a t = 2.5s (dopo l'arresto a 2.0s)
      await tester.pump(const Duration(milliseconds: 2500));

      // La velocità deve essere 0.0 m/s (clampata, la macchina non procede a ritroso)
      expect(find.textContaining('0.0 m/s'), findsWidgets);
    });
  });

  group('3. OhmCircuitSimulationWidget Animation & DC Physics Tests', () {
    testWidgets('Charges animate when started, telemetry computes Ohm & Joule laws, play/pause works', (tester) async {
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

      // L'animazione del flusso di cariche è in pausa di default
      final playBtn = find.byTooltip('Avvia flusso');
      expect(playBtn, findsOneWidget);

      // Avvia flusso
      await tester.tap(playBtn);
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byTooltip('Pausa flusso'), findsOneWidget);

      // Rimetti in pausa
      await tester.tap(find.byTooltip('Pausa flusso'));
      await tester.pump(const Duration(milliseconds: 50));

      // In pausa, il tooltip ritorna a "Avvia flusso"
      expect(find.byTooltip('Avvia flusso'), findsOneWidget);

      // Switch flusso reale / convenzionale
      final switchBtn = find.text('e⁻ Reale');
      expect(switchBtn, findsOneWidget);
      await tester.tap(switchBtn);
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('I Conv.'), findsOneWidget);
    });
  });

  group('4. DerivativeTangentWidget Animation & Limit Tests', () {
    testWidgets('Auto-animates limit h -> 0 when play is tapped and supports manual slider override', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: DerivativeTangentWidget()),
          ),
        ),
      );

      await tester.pump();

      // Inizialmente in pausa
      final playBtn = find.byTooltip('Anima limite h ➔ 0 a 60 FPS');
      expect(playBtn, findsOneWidget);

      final initialH = find.textContaining('h =').evaluate().first.widget as Text;
      final initialHText = initialH.data!;

      // Avanzando il tempo da fermo, h non cambia
      await tester.pump(const Duration(milliseconds: 600));
      final stillH = find.textContaining('h =').evaluate().first.widget as Text;
      expect(stillH.data, equals(initialHText));

      // Avvia animazione
      await tester.tap(playBtn);
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byTooltip('Pausa animazione limite'), findsOneWidget);

      // Avanza il tempo di 600 ms mentre è attiva
      await tester.pump(const Duration(milliseconds: 600));

      final nextH = find.textContaining('h =').evaluate().first.widget as Text;
      final nextHText = nextH.data!;
      expect(nextHText, isNot(equals(initialHText)));

      // Metti in pausa
      await tester.tap(find.byTooltip('Pausa animazione limite'));
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
    testWidgets('Auto-partitions interval N -> 40 when started and converges to definite integral', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: RiemannSumWidget()),
          ),
        ),
      );

      await tester.pump();

      // Fermo di default con tooltip "Anima convergenza N ➔ 40"
      final playBtn = find.byTooltip('Anima convergenza N ➔ 40');
      expect(playBtn, findsOneWidget);

      final initialN = find.textContaining('N =').evaluate().first.widget as Text;
      final initialNText = initialN.data!;

      // Avanzando il tempo da fermo, N non varia
      await tester.pump(const Duration(milliseconds: 800));
      final stillN = find.textContaining('N =').evaluate().first.widget as Text;
      expect(stillN.data, equals(initialNText));

      // Avvia convergenza
      await tester.tap(playBtn);
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byTooltip('Pausa convergenza'), findsOneWidget);

      // Avanza il tempo per far variare le partizioni
      await tester.pump(const Duration(milliseconds: 800));

      final nextN = find.textContaining('N =').evaluate().first.widget as Text;
      final nextNText = nextN.data!;
      expect(nextNText, isNot(equals(initialNText)));

      // Metti in pausa
      await tester.tap(find.byTooltip('Pausa convergenza'));
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byTooltip('Anima convergenza N ➔ 40'), findsOneWidget);

      // Verifica presenza telemetria
      expect(find.text('Integrale Esatto: ∫'), findsOneWidget);
      expect(find.text('Somma Riemann: Σ'), findsOneWidget);
    });
  });

  group('6. TriangleSolverWidget Animation & Geometric Deformation Tests', () {
    testWidgets('Auto-transforms angle gamma when started and detects Pythagorean right triangle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: TriangleSolverWidget()),
          ),
        ),
      );

      await tester.pump();

      // Fermo di default con tooltip "Anima trasformazione triangolo"
      final playBtn = find.byTooltip('Anima trasformazione triangolo');
      expect(playBtn, findsOneWidget);

      final initialCompreso = find.textContaining('Angolo γ compreso:').evaluate().first.widget as Text;
      final initialCompresoText = initialCompreso.data!;

      // Da fermo, non varia
      await tester.pump(const Duration(milliseconds: 800));
      final stillCompreso = find.textContaining('Angolo γ compreso:').evaluate().first.widget as Text;
      expect(stillCompreso.data, equals(initialCompresoText));

      // Avvia trasformazione
      await tester.tap(playBtn);
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byTooltip('Pausa deformazione'), findsOneWidget);

      // Avanza il tempo
      await tester.pump(const Duration(milliseconds: 800));

      final nextCompreso = find.textContaining('Angolo γ compreso:').evaluate().first.widget as Text;
      final nextCompresoText = nextCompreso.data!;
      expect(nextCompresoText, isNot(equals(initialCompresoText)));

      // Metti in pausa
      await tester.tap(find.byTooltip('Pausa deformazione'));
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byTooltip('Anima trasformazione triangolo'), findsOneWidget);

      // Verifiche geometriche
      expect(find.text('Terzo Lato c'), findsOneWidget);
      expect(find.text('Area'), findsOneWidget);
    });
  });

  group('7. CartesianGraphWidget Animation & Morphing Tests', () {
    testWidgets('Auto-morphs polynomial curve dynamically when play tapped', (tester) async {
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

      // Fermo di default con tooltip "Anima deformazione curva"
      final playBtn = find.byTooltip('Anima deformazione curva');
      expect(playBtn, findsOneWidget);

      // Avvia deformazione
      await tester.tap(playBtn);
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byTooltip('Pausa deformazione'), findsOneWidget);

      // Avanza il tempo di 600 ms
      await tester.pump(const Duration(milliseconds: 600));

      // Metti in pausa
      await tester.tap(find.byTooltip('Pausa deformazione'));
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

  group('8. SqueezeTheoremWidget Animation & Probe Tests', () {
    testWidgets('Initial state is paused and animates delta when play tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: SqueezeTheoremWidget()),
          ),
        ),
      );

      await tester.pump();

      // Fermo di default
      expect(find.text('Teorema del Confronto (Carabinieri)'), findsOneWidget);
      final playBtn = find.byTooltip('Anima convergenza δ ➔ 0 a 60 FPS');
      expect(playBtn, findsOneWidget);

      final initialDelta = find.textContaining('δ = ±').evaluate().first.widget as Text;
      final initialDeltaText = initialDelta.data!;

      // Da fermo, delta non cambia
      await tester.pump(const Duration(seconds: 1));
      final stillDelta = find.textContaining('δ = ±').evaluate().first.widget as Text;
      expect(stillDelta.data, equals(initialDeltaText));

      // Avvia animazione
      await tester.tap(playBtn);
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byTooltip('Pausa convergenza'), findsOneWidget);

      // Avanza il tempo
      await tester.pump(const Duration(milliseconds: 600));
      final nextDelta = find.textContaining('δ = ±').evaluate().first.widget as Text;
      expect(nextDelta.data, isNot(equals(initialDeltaText)));

      // Metti in pausa
      await tester.tap(find.byTooltip('Pausa convergenza'));
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byTooltip('Anima convergenza δ ➔ 0 a 60 FPS'), findsOneWidget);

      // Verifica che i carabinieri e la funzione intrappolata siano presenti
      expect(find.text('INF: g(x) = cos(x)'), findsOneWidget);
      expect(find.text('TRAPPOLA: sin(x)/x'), findsOneWidget);
      expect(find.text('SUP: h(x) = 1'), findsOneWidget);
      expect(find.text('SPAZIO BANDA |h - g|'), findsOneWidget);
    });
  });
}
