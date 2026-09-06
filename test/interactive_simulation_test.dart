import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/widgets/category_style.dart';
import 'package:laurentius/presentation/widgets/interactive/interactive_template_factory.dart';
import 'package:laurentius/presentation/widgets/interactive/ohm_circuit_simulation_widget.dart';
import 'package:laurentius/presentation/widgets/prerequisites_section_widget.dart';

void main() {
  group('InteractiveTemplateFactory Tests', () {
    test('Returns OhmCircuitSimulationWidget for circuit_simulation', () {
      final data = InteractiveData()
        ..templateType = 'circuit_simulation'
        ..equations = ['V / R']
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

      expect(mathStyle.primary, isNot(equals(chemStyle.primary)));
      expect(chemStyle.primary, isNot(equals(eleStyle.primary)));
    });
  });

  group('PrerequisitesSectionWidget Tests', () {
    testWidgets('Renders cross-disciplinary badge when subjects differ', (tester) async {
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

  group('OhmCircuitSimulationWidget Tests', () {
    testWidgets('Renders circuit controls, sliders, and telemetry', (tester) async {
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

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: OhmCircuitSimulationWidget(data: data),
            ),
          ),
        ),
      );

      // Verify title and telemetry are rendered
      expect(find.text('Simulazione Dinamica del Circuito'), findsOneWidget);
      expect(find.text('CORRENTE (I)'), findsOneWidget);
      expect(find.text('POTENZA (P)'), findsOneWidget);
      expect(find.text('2.00 A'), findsOneWidget); // 12V / 6Ω = 2.00 A
      expect(find.text('24.0 W'), findsOneWidget); // 12V * 2A = 24.0 W
    });
  });
}
