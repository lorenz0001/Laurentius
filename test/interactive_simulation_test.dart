import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/widgets/algebraic_proof_widget.dart';
import 'package:laurentius/presentation/widgets/category_style.dart';
import 'package:laurentius/presentation/widgets/interactive/cartesian_graph_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/derivative_tangent_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/interactive_template_factory.dart';
import 'package:laurentius/presentation/widgets/interactive/kinematics_simulation_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/ohm_circuit_simulation_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/riemann_sum_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/triangle_solver_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/trig_circle_widget.dart';
import 'package:laurentius/presentation/widgets/prerequisites_section_widget.dart';

void main() {
  group('InteractiveTemplateFactory Tests', () {
    test('Returns OhmCircuitSimulationWidget for circuit_simulation', () {
      final data = InteractiveData()
        ..templateType = 'circuit_simulation'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'V'
            ..defaultValue = 12.0,
          InteractiveParameter()
            ..variableName = 'R'
            ..defaultValue = 6.0,
        ];
      final widget = InteractiveTemplateFactory.buildWidget(data);
      expect(widget, isA<OhmCircuitSimulationWidget>());
    });

    test('Returns KinematicsSimulationWidget for kinematics_simulation', () {
      final data = InteractiveData()
        ..templateType = 'kinematics_simulation'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'v0'
            ..defaultValue = 5.0,
          InteractiveParameter()
            ..variableName = 'a'
            ..defaultValue = 2.0,
        ];
      final widget = InteractiveTemplateFactory.buildWidget(data);
      expect(widget, isA<KinematicsSimulationWidget>());
    });

    test('Returns CartesianGraphWidget for function_graph', () {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['a * x * x + b * x + c'];
      final widget = InteractiveTemplateFactory.buildWidget(data);
      expect(widget, isA<CartesianGraphWidget>());
    });

    test('Returns TrigCircleWidget for trig_circle', () {
      final data = InteractiveData()..templateType = 'trig_circle';
      final widget = InteractiveTemplateFactory.buildWidget(data);
      expect(widget, isA<TrigCircleWidget>());
    });

    test('Returns TriangleSolverWidget for triangle_solver', () {
      final data = InteractiveData()..templateType = 'triangle_solver';
      final widget = InteractiveTemplateFactory.buildWidget(data);
      expect(widget, isA<TriangleSolverWidget>());
    });

    test('Returns DerivativeTangentWidget for derivative_tangent', () {
      final data = InteractiveData()..templateType = 'derivative_tangent';
      final widget = InteractiveTemplateFactory.buildWidget(data);
      expect(widget, isA<DerivativeTangentWidget>());
    });

    test('Returns RiemannSumWidget for riemann_sum', () {
      final data = InteractiveData()..templateType = 'riemann_sum';
      final widget = InteractiveTemplateFactory.buildWidget(data);
      expect(widget, isA<RiemannSumWidget>());
    });

    test('Returns null for null interactive data (pure math nodes)', () {
      final widget = InteractiveTemplateFactory.buildWidget(null);
      expect(widget, isNull);
    });
  });

  group('CategoryStyle Tests', () {
    test('Provides distinct colors for STEM categories', () {
      final mathStyle = CategoryStyle.forCategory('Matematica');
      final chemStyle = CategoryStyle.forCategory('Chimica');
      final eleStyle = CategoryStyle.forCategory('Elettrotecnica');
      final physStyle = CategoryStyle.forCategory('Fisica');

      expect(mathStyle.primary, isNot(equals(chemStyle.primary)));
      expect(chemStyle.primary, isNot(equals(eleStyle.primary)));
      expect(physStyle.primary, isNot(equals(mathStyle.primary)));
    });
  });

  group('PrerequisitesSectionWidget Tests', () {
    testWidgets('Renders cross-disciplinary badge when subjects differ', (
      tester,
    ) async {
      final mathNode = KnowledgeNode()
        ..serverId = 'mat_log_01'
        ..title = 'Logaritmi ed Esponenziali'
        ..category = 'Matematica';

      final chemNode = KnowledgeNode()
        ..serverId = 'chem_ph_01'
        ..title = 'Calcolo del pH'
        ..category = 'Chimica';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrerequisitesSectionWidget(
              currentNode: chemNode,
              prerequisites: [mathNode],
            ),
          ),
        ),
      );

      expect(find.text('Logaritmi ed Esponenziali'), findsOneWidget);
      expect(find.textContaining('INTERDISCIPLINARE'), findsOneWidget);
    });
  });

  group('AlgebraicProofWidget Corollary Tests', () {
    testWidgets('Renders corollary badge for corollary steps', (tester) async {
      final steps = [
        ProofStep()
          ..description = 'Primo passaggio di introduzione.'
          ..latexEquation = r'v = v_0 + a t',
        ProofStep()
          ..description = 'Corollario: Formula di Torricelli senza tempo.'
          ..latexEquation = r'v^2 = v_0^2 + 2 a \Delta x',
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AlgebraicProofWidget(proofSteps: steps),
            ),
          ),
        ),
      );

      // Sblocca il secondo passaggio (il corollario)
      await tester.tap(find.text('Mostra tutti'));
      await tester.pumpAndSettle();

      expect(find.text('COROLLARIO DEDOTTO'), findsOneWidget);
    });
  });

  group('KinematicsSimulationWidget Tests', () {
    testWidgets('Renders car simulation, telemetry and sliders', (
      tester,
    ) async {
      final data = InteractiveData()
        ..templateType = 'kinematics_simulation'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'v0'
            ..defaultValue = 5.0,
          InteractiveParameter()
            ..variableName = 'a'
            ..defaultValue = 2.0,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: KinematicsSimulationWidget(data: data),
            ),
          ),
        ),
      );

      expect(find.text('Simulatore Cinematica (MRUA)'), findsOneWidget);
      expect(find.text('SPAZIO (x)'), findsOneWidget);
      expect(find.text('VELOCITÀ (v)'), findsOneWidget);
      expect(
        find.textContaining('Torricelli', skipOffstage: false),
        findsWidgets,
      );
    });
  });

  group('CartesianGraphWidget Tests', () {
    testWidgets('Renders 2D cartesian graph and formula', (tester) async {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['a * x * x + b * x + c'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CartesianGraphWidget(data: data),
            ),
          ),
        ),
      );

      expect(find.text('Grafico Cartesiano Dinamico'), findsOneWidget);
      expect(find.text('EQUAZIONE CORRENTE:'), findsOneWidget);
    });
  });

  group('TrigCircleWidget Tests', () {
    testWidgets('Renders trigonometric circle and telemetry', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: TrigCircleWidget()),
          ),
        ),
      );

      expect(find.text('Circonferenza Goniometrica'), findsOneWidget);
      expect(find.text('cos(θ)'), findsOneWidget);
      expect(find.text('sin(θ)'), findsOneWidget);
      expect(find.text('tan(θ)'), findsOneWidget);
      expect(find.textContaining('Identità Fondamentale'), findsOneWidget);
    });
  });

  group('TriangleSolverWidget Tests', () {
    testWidgets('Renders triangle solver and Pythagorean / Carnot checks', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: TriangleSolverWidget()),
          ),
        ),
      );

      expect(find.text('Geometria del Triangolo & Carnot'), findsOneWidget);
      expect(find.text('Lato a'), findsOneWidget);
      expect(find.text('Lato b'), findsOneWidget);
      expect(find.text('Terzo Lato c'), findsOneWidget);
      expect(find.text('Area'), findsOneWidget);
    });
  });

  group('DerivativeTangentWidget Tests', () {
    testWidgets('Renders difference quotient and tangent limit', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: DerivativeTangentWidget()),
          ),
        ),
      );

      expect(find.text('Rapporto Incrementale & Tangente'), findsOneWidget);
      expect(find.text('Secante: Δy / h'), findsOneWidget);
      expect(find.text('Derivata: f\'(x₀)'), findsOneWidget);
    });
  });

  group('RiemannSumWidget Tests', () {
    testWidgets('Renders Riemann sum rectangles and convergence telemetry', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: RiemannSumWidget()),
          ),
        ),
      );

      expect(find.text('Integrale di Riemann'), findsOneWidget);
      expect(find.text('Somma Riemann: Σ'), findsOneWidget);
      expect(find.text('Integrale Esatto: ∫'), findsOneWidget);
    });
  });
}
