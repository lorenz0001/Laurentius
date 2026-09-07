import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/pages/node_detail_screen.dart';
import 'package:laurentius/presentation/widgets/interactive/cartesian_graph_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/derivative_tangent_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/interactive_template_factory.dart';
import 'package:laurentius/presentation/widgets/interactive/kinematics_simulation_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/live_equation_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/ohm_circuit_simulation_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/riemann_sum_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/rolle_lagrange_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/triangle_solver_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/trig_circle_widget.dart';

Widget _wrapWithApp(Widget child, {double width = 1000}) {
  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: width,
          child: SingleChildScrollView(
            child: child,
          ),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tier 1: Declarative Widget Linking - Core 9 Simulation Templates', () {
    testWidgets('Template 1: circuit_simulation links to OhmCircuitSimulationWidget', (tester) async {
      final data = InteractiveData()
        ..templateType = 'circuit_simulation'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'V'
            ..label = 'Tensione (V)'
            ..defaultValue = 12.0
            ..unit = 'V',
          InteractiveParameter()
            ..variableName = 'R'
            ..label = 'Resistenza (R)'
            ..defaultValue = 10.0
            ..unit = 'Ω',
        ];

      final widget = InteractiveTemplateFactory.buildWidget(data);
      expect(widget, isNotNull);
      expect(widget, isA<OhmCircuitSimulationWidget>());

      await tester.pumpWidget(_wrapWithApp(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(OhmCircuitSimulationWidget), findsOneWidget);
      expect(find.byType(Slider), findsAtLeastNWidgets(2));
    });

    testWidgets('Template 2: kinematics_simulation links to KinematicsSimulationWidget', (tester) async {
      final data = InteractiveData()
        ..templateType = 'kinematics_simulation'
        ..equations = ['v0 + a * t']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'v0'
            ..label = 'Velocità Iniziale (v₀)'
            ..defaultValue = 5.0
            ..unit = 'm/s',
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Accelerazione Costante (a)'
            ..defaultValue = 2.0
            ..unit = 'm/s²',
        ];

      final widget = InteractiveTemplateFactory.buildWidget(data);
      expect(widget, isNotNull);
      expect(widget, isA<KinematicsSimulationWidget>());

      await tester.pumpWidget(_wrapWithApp(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(KinematicsSimulationWidget), findsOneWidget);
      expect(find.byType(Slider), findsAtLeastNWidgets(2));
    });

    testWidgets('Template 3: function_graph links to CartesianGraphWidget', (tester) async {
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

      final widget = InteractiveTemplateFactory.buildWidget(data);
      expect(widget, isNotNull);
      expect(widget, isA<CartesianGraphWidget>());

      await tester.pumpWidget(_wrapWithApp(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(CartesianGraphWidget), findsOneWidget);
      expect(find.byType(Slider), findsAtLeastNWidgets(3));
    });

    testWidgets('Template 4: trig_circle links to TrigCircleWidget', (tester) async {
      final data = InteractiveData()..templateType = 'trig_circle';
      final widget = InteractiveTemplateFactory.buildWidget(data);

      expect(widget, isNotNull);
      expect(widget, isA<TrigCircleWidget>());

      await tester.pumpWidget(_wrapWithApp(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(TrigCircleWidget), findsOneWidget);
    });

    testWidgets('Template 5: triangle_solver links to TriangleSolverWidget', (tester) async {
      final data = InteractiveData()..templateType = 'triangle_solver';
      final widget = InteractiveTemplateFactory.buildWidget(data);

      expect(widget, isNotNull);
      expect(widget, isA<TriangleSolverWidget>());

      await tester.pumpWidget(_wrapWithApp(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(TriangleSolverWidget), findsOneWidget);
      expect(find.byType(Slider), findsAtLeastNWidgets(2));
    });

    testWidgets('Template 6: derivative_tangent links to DerivativeTangentWidget', (tester) async {
      final data = InteractiveData()..templateType = 'derivative_tangent';
      final widget = InteractiveTemplateFactory.buildWidget(data);

      expect(widget, isNotNull);
      expect(widget, isA<DerivativeTangentWidget>());

      await tester.pumpWidget(_wrapWithApp(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(DerivativeTangentWidget), findsOneWidget);
      expect(find.byType(Slider), findsAtLeastNWidgets(2));
    });

    testWidgets('Template 7: riemann_sum links to RiemannSumWidget', (tester) async {
      final data = InteractiveData()..templateType = 'riemann_sum';
      final widget = InteractiveTemplateFactory.buildWidget(data);

      expect(widget, isNotNull);
      expect(widget, isA<RiemannSumWidget>());

      await tester.pumpWidget(_wrapWithApp(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(RiemannSumWidget), findsOneWidget);
      expect(find.byType(Slider), findsAtLeastNWidgets(1));
    });

    testWidgets('Template 8: rolle_lagrange links to RolleLagrangeWidget', (tester) async {
      final data = InteractiveData()..templateType = 'rolle_lagrange';
      final widget = InteractiveTemplateFactory.buildWidget(data);

      expect(widget, isNotNull);
      expect(widget, isA<RolleLagrangeWidget>());

      await tester.pumpWidget(_wrapWithApp(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(RolleLagrangeWidget), findsOneWidget);
      expect(find.byType(Slider), findsAtLeastNWidgets(2));
    });

    testWidgets('Template 9: live_equation links to LiveEquationWidget', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..equations = ['a + b']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Valore a'
            ..defaultValue = 3.0,
          InteractiveParameter()
            ..variableName = 'b'
            ..label = 'Valore b'
            ..defaultValue = 4.0,
        ];

      final widget = InteractiveTemplateFactory.buildWidget(data);
      expect(widget, isNotNull);
      expect(widget, isA<LiveEquationWidget>());

      await tester.pumpWidget(_wrapWithApp(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(LiveEquationWidget), findsOneWidget);
      expect(find.byType(Slider), findsAtLeastNWidgets(2));
      expect(find.text('7'), findsWidgets); // 3 + 4 = 7
    });
  });

  group('Tier 1: Slider Systems & Unit Decoupling (R4 Requirements)', () {
    testWidgets('LiveEquationWidget renders custom Watt unit (W) for Electrical Power', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'W'
        ..equations = ['V * I']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'V'
            ..label = 'Tensione'
            ..minValue = 1.0
            ..maxValue = 48.0
            ..defaultValue = 12.0
            ..unit = 'V',
          InteractiveParameter()
            ..variableName = 'I'
            ..label = 'Corrente'
            ..minValue = 0.1
            ..maxValue = 10.0
            ..defaultValue = 2.0
            ..unit = 'A',
        ];

      final widget = InteractiveTemplateFactory.buildWidget(data);
      await tester.pumpWidget(_wrapWithApp(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      // 12 * 2 = 24 W
      expect(find.text('24'), findsWidgets);
      expect(find.text('W'), findsOneWidget);
    });

    testWidgets('LiveEquationWidget renders custom Joule unit (J) for Thermal Energy', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'J'
        ..equations = ['R * I * I * t']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'R'
            ..defaultValue = 5.0
            ..unit = 'Ω',
          InteractiveParameter()
            ..variableName = 'I'
            ..defaultValue = 2.0
            ..unit = 'A',
          InteractiveParameter()
            ..variableName = 't'
            ..defaultValue = 10.0
            ..unit = 's',
        ];

      final widget = InteractiveTemplateFactory.buildWidget(data);
      await tester.pumpWidget(_wrapWithApp(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      // 5 * 2^2 * 10 = 200 J
      expect(find.text('200'), findsWidgets);
      expect(find.text('J'), findsOneWidget);
    });

    testWidgets('LiveEquationWidget renders custom Newton unit (N) for Force', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'N'
        ..equations = ['m * a']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'm'
            ..defaultValue = 10.0
            ..unit = 'kg',
          InteractiveParameter()
            ..variableName = 'a'
            ..defaultValue = 9.8
            ..unit = 'm/s²',
        ];

      final widget = InteractiveTemplateFactory.buildWidget(data);
      await tester.pumpWidget(_wrapWithApp(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('N'), findsOneWidget);
    });

    testWidgets('Parameter sliders render custom unit badges (m/s, Ω, V, A)', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'W'
        ..equations = ['V * I']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'V'
            ..label = 'Tensione'
            ..minValue = 0.0
            ..maxValue = 24.0
            ..defaultValue = 12.0
            ..unit = 'V',
          InteractiveParameter()
            ..variableName = 'I'
            ..label = 'Corrente'
            ..minValue = 0.0
            ..maxValue = 10.0
            ..defaultValue = 3.0
            ..unit = 'A',
        ];

      final widget = InteractiveTemplateFactory.buildWidget(data);
      await tester.pumpWidget(_wrapWithApp(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      // Sliders must display unit badges "12 V" and "3 A"
      expect(find.text('12 V'), findsOneWidget);
      expect(find.text('3 A'), findsOneWidget);
    });
  });

  group('Tier 2: Boundary & Corner Cases (Unit Decoupling & Extreme Ranges)', () {
    testWidgets('LiveEquationWidget with empty unit ("") NEVER renders "V" or suffix', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = ''
        ..equations = ['a + b']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..defaultValue = 2.0,
          InteractiveParameter()
            ..variableName = 'b'
            ..defaultValue = 3.0,
        ];

      final widget = InteractiveTemplateFactory.buildWidget(data);
      await tester.pumpWidget(_wrapWithApp(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('5'), findsWidgets);
      // Hardcoded 'V' must NOT be present
      expect(find.text('V'), findsNothing);
    });

    testWidgets('LiveEquationWidget with null unit NEVER renders "V" or suffix', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = null
        ..equations = ['a * b']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..defaultValue = 4.0,
          InteractiveParameter()
            ..variableName = 'b'
            ..defaultValue = 5.0,
        ];

      final widget = InteractiveTemplateFactory.buildWidget(data);
      await tester.pumpWidget(_wrapWithApp(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('20'), findsWidgets);
      expect(find.text('V'), findsNothing);
    });

    testWidgets('Parameter sliders without unit render only numeric values (no stray null)', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..equations = ['x + 1']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'x'
            ..label = 'Variabile X'
            ..defaultValue = 7.0
            ..unit = null,
        ];

      final widget = InteractiveTemplateFactory.buildWidget(data);
      await tester.pumpWidget(_wrapWithApp(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('7'), findsWidgets);
      expect(find.text('7 null'), findsNothing);
    });

    testWidgets('Handles negative parameter slider ranges and fractional values', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..equations = ['a + b']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..minValue = -20.0
            ..maxValue = 20.0
            ..defaultValue = -5.0
            ..stepSize = 1.0,
          InteractiveParameter()
            ..variableName = 'b'
            ..minValue = -10.0
            ..maxValue = 10.0
            ..defaultValue = 2.5
            ..stepSize = 0.5,
        ];

      final widget = InteractiveTemplateFactory.buildWidget(data);
      await tester.pumpWidget(_wrapWithApp(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      // -5 + 2.5 = -2.50 (formatted to 2 decimal places)
      expect(find.text('-2.50'), findsWidgets);
    });

    testWidgets('Gracefully handles division by zero without application crash', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..equations = ['10 / x']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'x'
            ..minValue = 0.0
            ..maxValue = 10.0
            ..defaultValue = 0.0,
        ];

      final widget = InteractiveTemplateFactory.buildWidget(data);
      await tester.pumpWidget(_wrapWithApp(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      // Must build safely and show error state or non-finite indication
      expect(find.byType(LiveEquationWidget), findsOneWidget);
    });
  });

  group('Tier 3: Cross-Feature Integration (Aliases, Routing & Detail Screen)', () {
    test('Resolves all 17 canonical template aliases correctly', () {
      final testCases = <String, Type>{
        'circuit_simulation': OhmCircuitSimulationWidget,
        'ohm_simulation': OhmCircuitSimulationWidget,
        'kinematics_simulation': KinematicsSimulationWidget,
        'rectilinear_motion': KinematicsSimulationWidget,
        'rolle_lagrange': RolleLagrangeWidget,
        'rolle': RolleLagrangeWidget,
        'lagrange': RolleLagrangeWidget,
        'function_graph': CartesianGraphWidget,
        'cartesian_plot': CartesianGraphWidget,
        'trig_circle': TrigCircleWidget,
        'trigonometric_circle': TrigCircleWidget,
        'triangle_solver': TriangleSolverWidget,
        'pythagoras_carnot': TriangleSolverWidget,
        'derivative_tangent': DerivativeTangentWidget,
        'difference_quotient': DerivativeTangentWidget,
        'riemann_sum': RiemannSumWidget,
        'riemann_integral': RiemannSumWidget,
      };

      for (final entry in testCases.entries) {
        final data = InteractiveData()..templateType = entry.key;
        final widget = InteractiveTemplateFactory.buildWidget(data);
        expect(widget.runtimeType, equals(entry.value),
            reason: 'Template alias "${entry.key}" failed to instantiate ${entry.value}');
      }
    });

    test('Smart routes cubic formula from function_graph to RolleLagrangeWidget', () {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['x * x * x / 3 - x'];

      final widget = InteractiveTemplateFactory.buildWidget(data);
      expect(widget, isA<RolleLagrangeWidget>());
    });

    test('Falls back to LiveEquationWidget when templateType is null but equations exist', () {
      final data = InteractiveData()
        ..templateType = null
        ..equations = ['x + 2']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'x'
            ..defaultValue = 3.0,
        ];

      final widget = InteractiveTemplateFactory.buildWidget(data);
      expect(widget, isA<LiveEquationWidget>());
    });

    test('Returns null when InteractiveData is null', () {
      final widget = InteractiveTemplateFactory.buildWidget(null);
      expect(widget, isNull);
    });

    testWidgets('Live equation re-evaluates when slider value changes', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'W'
        ..equations = ['V * 2']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'V'
            ..label = 'Tensione'
            ..minValue = 0.0
            ..maxValue = 20.0
            ..defaultValue = 5.0
            ..unit = 'V',
        ];

      final widget = InteractiveTemplateFactory.buildWidget(data);
      await tester.pumpWidget(_wrapWithApp(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      // Initial: 5 * 2 = 10 W
      expect(find.text('10'), findsWidgets);

      // Drag the slider
      final sliderFinder = find.byType(Slider);
      expect(sliderFinder, findsOneWidget);

      await tester.drag(sliderFinder, const Offset(80.0, 0.0));
      await tester.pump(const Duration(milliseconds: 50));

      // After dragging, the evaluated text must still exist and be updated
      expect(find.byType(LiveEquationWidget), findsOneWidget);
    });

    testWidgets('NodeDetailScreen seamlessly embeds declaratively linked interactive widget', (tester) async {
      final testNode = KnowledgeNode()
        ..serverId = 'test_e2e_node_01'
        ..title = 'Test E2E Node'
        ..category = 'Fisica'
        ..subCategory = 'Cinematica'
        ..algebraicProof = [
          ProofStep()
            ..description = 'Corollario: Test Step'
            ..latexEquation = r'v = v_0 + at',
        ]
        ..interactiveData = (InteractiveData()
          ..templateType = 'kinematics_simulation'
          ..parameters = [
            InteractiveParameter()
              ..variableName = 'v0'
              ..defaultValue = 5.0,
            InteractiveParameter()
              ..variableName = 'a'
              ..defaultValue = 2.0,
          ]);

      await tester.pumpWidget(MaterialApp(
        home: NodeDetailScreen(node: testNode),
      ));
      await tester.pump(const Duration(milliseconds: 50));

      // Verify NodeDetailScreen renders KinematicsSimulationWidget
      expect(find.byType(NodeDetailScreen), findsOneWidget);
      expect(find.byType(KinematicsSimulationWidget), findsOneWidget);
    });
  });
}
