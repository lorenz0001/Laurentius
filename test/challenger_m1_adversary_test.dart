import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/data/content/markdown_content_parser.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/widgets/interactive/cartesian_graph_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/interactive_template_factory.dart';
import 'package:laurentius/presentation/widgets/interactive/ohm_circuit_simulation_widget.dart';

void main() {
  group('Adversary M1.1: Quadratic Formula Display and Vertex Marker Calculation', () {
    testWidgets('Quadratic x^2 - 4 displays quadratic formula and calculates vertex V(0.0, -4.0)', (tester) async {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['a * x * x + c']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Curvatura (a)'
            ..defaultValue = 1.0
            ..minValue = -3.0
            ..maxValue = 3.0,
          InteractiveParameter()
            ..variableName = 'b'
            ..label = 'Lineare (b)'
            ..defaultValue = 0.0
            ..minValue = -4.0
            ..maxValue = 4.0,
          InteractiveParameter()
            ..variableName = 'c'
            ..label = 'Termine noto (c)'
            ..defaultValue = -4.0
            ..minValue = -9.0
            ..maxValue = 9.0,
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

      // Formula display must show quadratic representation
      expect(find.text('y = 1.0x² - 4.0'), findsOneWidget);

      // Vertex dot on canvas for y = 1*x^2 - 4 is drawn as Color(0xFFF59E0B) circle
      final customPaintFinder = find.descendant(
        of: find.byType(ClipRRect),
        matching: find.byType(CustomPaint),
      );
      expect(customPaintFinder, paints..circle(color: const Color(0xFFF59E0B)));
    });

    testWidgets('Quadratic 2x^2 + 3x - 1 displays quadratic formula and calculates vertex', (tester) async {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['a * x * x + b * x + c']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..defaultValue = 2.0
            ..minValue = -5.0
            ..maxValue = 5.0,
          InteractiveParameter()
            ..variableName = 'b'
            ..defaultValue = 3.0
            ..minValue = -5.0
            ..maxValue = 5.0,
          InteractiveParameter()
            ..variableName = 'c'
            ..defaultValue = -1.0
            ..minValue = -5.0
            ..maxValue = 5.0,
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

      // Formula display must show quadratic representation
      expect(find.text('y = 2.0x² + 3.0x - 1.0'), findsOneWidget);

      // Vertex dot on canvas is drawn with Color(0xFFF59E0B)
      final customPaintFinder = find.descendant(
        of: find.byType(ClipRRect),
        matching: find.byType(CustomPaint),
      );
      expect(customPaintFinder, paints..circle(color: const Color(0xFFF59E0B)));
    });
  });

  group('Adversary M1.2: Non-Quadratic Function Genuine Equation Display & Vertex Suppression', () {
    testWidgets('Euler limit (1 + 1/x)^x displays genuine equation and suppresses vertex marker', (tester) async {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['(1 + 1/x)^x']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'n'
            ..defaultValue = 10.0
            ..minValue = 1.0
            ..maxValue = 50.0,
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

      // Genuine equation display
      expect(find.text('y = (1 + 1/x)^x'), findsOneWidget);
      // Vertex marker must be suppressed on canvas
      final customPaintFinder = find.descendant(
        of: find.byType(ClipRRect),
        matching: find.byType(CustomPaint),
      );
      expect(customPaintFinder, isNot(paints..circle(color: const Color(0xFFF59E0B))));
    });

    testWidgets('Logarithm limit ln(1+x)/x displays genuine equation and suppresses vertex marker', (tester) async {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['ln(1 + x) / x']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'k'
            ..defaultValue = 1.0
            ..minValue = 0.5
            ..maxValue = 3.0,
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

      // Genuine equation display
      expect(find.text('y = ln(1 + x) / x'), findsOneWidget);
      // Vertex marker must be suppressed on canvas
      final customPaintFinder = find.descendant(
        of: find.byType(ClipRRect),
        matching: find.byType(CustomPaint),
      );
      expect(customPaintFinder, isNot(paints..circle(color: const Color(0xFFF59E0B))));
    });

    testWidgets('Trigonometric sin(x) displays genuine equation and suppresses vertex marker', (tester) async {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['sin(x)'];

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

      // Genuine equation display
      expect(find.text('y = sin(x)'), findsOneWidget);
      // Vertex marker must be suppressed on canvas
      final customPaintFinder = find.descendant(
        of: find.byType(ClipRRect),
        matching: find.byType(CustomPaint),
      );
      expect(customPaintFinder, isNot(paints..circle(color: const Color(0xFFF59E0B))));
    });

    testWidgets('Cubic polynomial x * x * x / 3 - x displays genuine equation and suppresses vertex marker', (tester) async {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['x * x * x / 3 - x'];

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

      // Non-quadratic function must display genuine equation
      expect(find.text('y = x * x * x / 3 - x'), findsOneWidget);
      // Vertex marker must be suppressed on canvas
      final customPaintFinder = find.descendant(
        of: find.byType(ClipRRect),
        matching: find.byType(CustomPaint),
      );
      expect(customPaintFinder, isNot(paints..circle(color: const Color(0xFFF59E0B))));
    });
  });

  group('Adversary M1.3: Edge Case a = 0 (bx + c, a line) Vertex Suppression', () {
    testWidgets('Quadratic parameterization with a = 0 suppresses vertex marker', (tester) async {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['a * x * x + b * x + c']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..defaultValue = 0.0
            ..minValue = -3.0
            ..maxValue = 3.0,
          InteractiveParameter()
            ..variableName = 'b'
            ..defaultValue = 2.0
            ..minValue = -4.0
            ..maxValue = 4.0,
          InteractiveParameter()
            ..variableName = 'c'
            ..defaultValue = 1.0
            ..minValue = -5.0
            ..maxValue = 5.0,
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

      // A straight line has no parabola vertex: marker must be suppressed on canvas!
      final customPaintFinder = find.descendant(
        of: find.byType(ClipRRect),
        matching: find.byType(CustomPaint),
      );
      expect(customPaintFinder, isNot(paints..circle(color: const Color(0xFFF59E0B))));
    });

    testWidgets('Pure linear equation b * x + c suppresses vertex marker and shows genuine equation', (tester) async {
      final data = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['2 * x + 1'];

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

      expect(find.text('y = 2 * x + 1'), findsOneWidget);
      final customPaintFinder = find.descendant(
        of: find.byType(ClipRRect),
        matching: find.byType(CustomPaint),
      );
      expect(customPaintFinder, isNot(paints..circle(color: const Color(0xFFF59E0B))));
    });
  });

  group('Adversary M1.4: Physics Articles Rebinding and Electrical Calculations', () {
    testWidgets('ele_power_01.md loads as circuit_simulation and computes I = V/R and P = V*I', (tester) async {
      final file = File('assets/content/physics/circuits/ele_power_01.md');
      expect(file.existsSync(), isTrue, reason: 'ele_power_01.md must exist on disk');

      final content = file.readAsStringSync();
      final node = MarkdownContentParser.parse(content);

      // Verify template type
      expect(node.interactiveData?.templateType, 'circuit_simulation',
          reason: 'ele_power_01.md must declare template: circuit_simulation');

      // Verify parameters
      final vParam = node.interactiveData?.parameters?.firstWhere((p) => p.variableName == 'V');
      final rParam = node.interactiveData?.parameters?.firstWhere((p) => p.variableName == 'R');
      expect(vParam, isNotNull);
      expect(rParam, isNotNull);
      expect(vParam!.defaultValue, 12.0);
      expect(rParam!.defaultValue, 6.0);

      // Build widget via factory
      final widget = InteractiveTemplateFactory.buildWidget(node.interactiveData);
      expect(widget, isA<OhmCircuitSimulationWidget>());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: widget,
            ),
          ),
        ),
      );
      await tester.pump();

      // Current I = 12.0 V / 6.0 Ω = 2.00 A
      expect(find.text('2.00 A'), findsOneWidget);
      // Power P = 12.0 V * 2.00 A = 24.0 W
      expect(find.text('24.0 W'), findsOneWidget);
    });

    testWidgets('ele_joule_01.md loads as circuit_simulation and computes I = V/R and P = V*I', (tester) async {
      final file = File('assets/content/physics/circuits/ele_joule_01.md');
      expect(file.existsSync(), isTrue, reason: 'ele_joule_01.md must exist on disk');

      final content = file.readAsStringSync();
      final node = MarkdownContentParser.parse(content);

      // Verify template type
      expect(node.interactiveData?.templateType, 'circuit_simulation',
          reason: 'ele_joule_01.md must declare template: circuit_simulation');

      // Verify parameters
      final vParam = node.interactiveData?.parameters?.firstWhere((p) => p.variableName == 'V');
      final rParam = node.interactiveData?.parameters?.firstWhere((p) => p.variableName == 'R');
      expect(vParam, isNotNull);
      expect(rParam, isNotNull);
      expect(vParam!.defaultValue, 12.0);
      expect(rParam!.defaultValue, 4.0);

      // Build widget via factory
      final widget = InteractiveTemplateFactory.buildWidget(node.interactiveData);
      expect(widget, isA<OhmCircuitSimulationWidget>());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: widget,
            ),
          ),
        ),
      );
      await tester.pump();

      // Current I = 12.0 V / 4.0 Ω = 3.00 A
      expect(find.text('3.00 A'), findsOneWidget);
      // Power P = 12.0 V * 3.00 A = 36.0 W
      expect(find.text('36.0 W'), findsOneWidget);
    });
  });
}
