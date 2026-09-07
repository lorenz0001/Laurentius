import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/widgets/interactive/live_equation_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/kinematics_simulation_widget.dart';

void main() {
  group('Adversarial Challenge M1: Unit Decoupling & Configurable Sliders', () {
    // =========================================================================
    // 1. Dynamic Math Expressions with Custom Units ("N", "W", "J")
    // =========================================================================
    testWidgets('Challenge 1.1: Kinetic Energy formula (unit: "J") with decimals and multi-term math', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'J'
        ..equations = ['0.5 * m * v * v']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'm'
            ..label = 'Massa del corpo'
            ..unit = 'kg'
            ..minValue = 0.5
            ..maxValue = 20.0
            ..defaultValue = 4.0
            ..stepSize = 0.5,
          InteractiveParameter()
            ..variableName = 'v'
            ..label = 'Velocità'
            ..unit = 'm/s'
            ..minValue = 0.0
            ..maxValue = 30.0
            ..defaultValue = 3.0
            ..stepSize = 1.0,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LiveEquationWidget(data: data),
            ),
          ),
        ),
      );
      await tester.pump();

      // Calculation: 0.5 * 4.0 * 3.0 * 3.0 = 18
      expect(find.text('18'), findsOneWidget);
      expect(find.text('J'), findsOneWidget);
      expect(find.text('4 kg'), findsOneWidget);
      expect(find.text('3 m/s'), findsOneWidget);
      expect(find.text('V'), findsNothing);

      // Drag velocity slider to change value
      final sliders = find.byType(Slider);
      expect(sliders, findsNWidgets(2));
      await tester.drag(sliders.last, const Offset(40, 0));
      await tester.pump();

      expect(find.text('J'), findsOneWidget);
      expect(find.text('V'), findsNothing);
      expect(find.textContaining('Impossibile calcolare'), findsNothing);
    });

    testWidgets('Challenge 1.2: Newton Second Law (unit: "N") with force evaluation', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'N'
        ..equations = ['m * a']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'm'
            ..label = 'Massa'
            ..unit = 'kg'
            ..minValue = 1.0
            ..maxValue = 50.0
            ..defaultValue = 9.8
            ..stepSize = 0.1,
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Accelerazione gravitazionale'
            ..unit = 'm/s²'
            ..minValue = 0.0
            ..maxValue = 25.0
            ..defaultValue = 9.8
            ..stepSize = 0.1,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LiveEquationWidget(data: data),
            ),
          ),
        ),
      );
      await tester.pump();

      // Calculation: 9.8 * 9.8 = 96.04
      expect(find.text('96.04'), findsOneWidget);
      expect(find.text('N'), findsOneWidget);
      expect(find.text('9.8 kg'), findsOneWidget);
      expect(find.text('9.8 m/s²'), findsOneWidget);
      expect(find.text('V'), findsNothing);
    });

    testWidgets('Challenge 1.3: Electrical Power (unit: "W") with custom parameters', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'W'
        ..equations = ['volts * amps']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'volts'
            ..label = 'Tensione'
            ..unit = 'V'
            ..minValue = 100.0
            ..maxValue = 250.0
            ..defaultValue = 230.0
            ..stepSize = 5.0,
          InteractiveParameter()
            ..variableName = 'amps'
            ..label = 'Corrente'
            ..unit = 'A'
            ..minValue = 0.1
            ..maxValue = 5.0
            ..defaultValue = 0.5
            ..stepSize = 0.1,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LiveEquationWidget(data: data),
            ),
          ),
        ),
      );
      await tester.pump();

      // Calculation: 230.0 * 0.5 = 115
      expect(find.text('115'), findsOneWidget);
      expect(find.text('W'), findsOneWidget);
      expect(find.text('230 V'), findsOneWidget);
      expect(find.text('0.5 A'), findsOneWidget);
      // 'V' appears ONLY as parameter badge unit for '230 V', NEVER as the output unit
      expect(find.widgetWithText(Row, '115'), findsOneWidget);
    });

    // =========================================================================
    // 2. Unit Decoupling Absolute Invariance: Null, Empty, Whitespace Units
    // =========================================================================
    testWidgets('Challenge 2.1: Null unit in equation and parameters NEVER produces "V"', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = null
        ..equations = ['x * 2 + y']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'x'
            ..label = 'Coefficiente X'
            ..unit = null
            ..minValue = 0.0
            ..maxValue = 20.0
            ..defaultValue = 7.0
            ..stepSize = 1.0,
          InteractiveParameter()
            ..variableName = 'y'
            ..label = 'Termine Notatore Y'
            ..unit = null
            ..minValue = 0.0
            ..maxValue = 20.0
            ..defaultValue = 6.0
            ..stepSize = 1.0,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LiveEquationWidget(data: data),
            ),
          ),
        ),
      );
      await tester.pump();

      // Calculation: 7 * 2 + 6 = 20
      expect(find.text('20'), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
      expect(find.text('6'), findsOneWidget);

      // Verify that 'V' is totally absent in the entire widget tree
      expect(find.text('V'), findsNothing);
    });

    testWidgets('Challenge 2.2: Whitespace-only units in equation and parameters NEVER render whitespace badges or "V"', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = '    '
        ..equations = ['p / q']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'p'
            ..label = 'Numeratore'
            ..unit = '   '
            ..minValue = 1.0
            ..maxValue = 50.0
            ..defaultValue = 24.0
            ..stepSize = 1.0,
          InteractiveParameter()
            ..variableName = 'q'
            ..label = 'Denominatore'
            ..unit = ''
            ..minValue = 1.0
            ..maxValue = 10.0
            ..defaultValue = 4.0
            ..stepSize = 1.0,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LiveEquationWidget(data: data),
            ),
          ),
        ),
      );
      await tester.pump();

      // 24 / 4 = 6
      expect(find.text('6'), findsOneWidget);
      expect(find.text('24'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);

      // Verify no 'V' and no trailing empty whitespace widgets
      expect(find.text('V'), findsNothing);
      expect(find.text('    '), findsNothing);
      expect(find.text('   '), findsNothing);
    });

    // =========================================================================
    // 3. Negative Ranges, Decimals, and Sub-Zero Calculations
    // =========================================================================
    testWidgets('Challenge 3.1: Negative range slider and sub-zero calculation with decimals', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'K'
        ..equations = ['T + 273.15']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'T'
            ..label = 'Temperatura Celsius'
            ..unit = '°C'
            ..minValue = -50.0
            ..maxValue = 50.0
            ..defaultValue = -15.5
            ..stepSize = 0.5,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LiveEquationWidget(data: data),
            ),
          ),
        ),
      );
      await tester.pump();

      // Calculation: -15.5 + 273.15 = 257.65
      expect(find.text('257.65'), findsOneWidget);
      expect(find.text('K'), findsOneWidget);
      expect(find.text('-15.5 °C'), findsOneWidget);
      expect(find.text('V'), findsNothing);

      // Drag slider from negative to positive
      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(120, 0));
      await tester.pump();

      expect(find.text('K'), findsOneWidget);
      expect(find.textContaining('Impossibile calcolare'), findsNothing);
    });

    testWidgets('Challenge 3.2: Entirely negative slider range with negative result and decibel unit', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'dBm'
        ..equations = ['attenuation - 30']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'attenuation'
            ..label = 'Attenuazione'
            ..unit = 'dB'
            ..minValue = -80.0
            ..maxValue = -10.0
            ..defaultValue = -40.0
            ..stepSize = 5.0,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LiveEquationWidget(data: data),
            ),
          ),
        ),
      );
      await tester.pump();

      // -40 - 30 = -70
      expect(find.text('-70'), findsOneWidget);
      expect(find.text('dBm'), findsOneWidget);
      expect(find.text('-40 dB'), findsOneWidget);
      expect(find.text('V'), findsNothing);
    });

    // =========================================================================
    // 4. Edge Cases, Malformed Expressions, and Dynamic Updates
    // =========================================================================
    testWidgets('Challenge 4.1: Empty equation list handles gracefully without crashing', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'm'
        ..equations = []
        ..parameters = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LiveEquationWidget(data: data),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Nessuna equazione specificata.'), findsOneWidget);
      expect(find.text('V'), findsNothing);
    });

    testWidgets('Challenge 4.2: Malformed equation syntax displays error container without unhandled exception', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'm/s'
        ..equations = ['2 * + / 4']
        ..parameters = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LiveEquationWidget(data: data),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.textContaining('Impossibile calcolare l\'espressione'), findsOneWidget);
    });

    testWidgets('Challenge 4.3: didUpdateWidget switches models dynamically and updates unit badge correctly', (tester) async {
      final dataA = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'N'
        ..equations = ['m * 10']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'm'
            ..label = 'Massa'
            ..unit = 'kg'
            ..defaultValue = 3.0,
        ];

      final dataB = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'W'
        ..equations = ['v * 2']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'v'
            ..label = 'Velocità'
            ..unit = 'm/s'
            ..defaultValue = 8.0,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LiveEquationWidget(data: dataA),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('30'), findsOneWidget);
      expect(find.text('N'), findsOneWidget);
      expect(find.text('3 kg'), findsOneWidget);

      // Rebuild with dataB
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LiveEquationWidget(data: dataB),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('16'), findsOneWidget);
      expect(find.text('W'), findsOneWidget);
      expect(find.text('8 m/s'), findsOneWidget);
      expect(find.text('N'), findsNothing);
    });

    // =========================================================================
    // 5. Model Deserialization & Schema Integrity
    // =========================================================================
    test('Challenge 5.1: InteractiveData and InteractiveParameter fromJson parses unit, numbers, and nulls correctly', () {
      final jsonMap = {
        'templateType': 'live_equation',
        'unit': 'rad/s',
        'equations': ['omega * t'],
        'parameters': [
          {
            'variableName': 'omega',
            'label': 'Velocità angolare',
            'unit': 'rad/s',
            'minValue': 0,
            'maxValue': 100,
            'defaultValue': 25,
            'stepSize': 5,
          },
          {
            'variableName': 't',
            'label': 'Tempo',
            'unit': null,
            'minValue': 0.5,
            'maxValue': 10.5,
            'defaultValue': 2.5,
            'stepSize': 0.5,
          }
        ]
      };

      final data = InteractiveData.fromJson(jsonMap);
      expect(data.unit, 'rad/s');
      expect(data.equations?.first, 'omega * t');
      expect(data.parameters?.length, 2);

      final param1 = data.parameters![0];
      expect(param1.variableName, 'omega');
      expect(param1.unit, 'rad/s');
      expect(param1.minValue, 0.0);
      expect(param1.maxValue, 100.0);
      expect(param1.defaultValue, 25.0);
      expect(param1.stepSize, 5.0);

      final param2 = data.parameters![1];
      expect(param2.variableName, 't');
      expect(param2.unit, isNull);
      expect(param2.minValue, 0.5);
      expect(param2.maxValue, 10.5);
      expect(param2.defaultValue, 2.5);
      expect(param2.stepSize, 0.5);
    });

    // =========================================================================
    // 6. Simulation Widgets with Negative Ranges & Edge Units
    // =========================================================================
    testWidgets('Challenge 6.1: KinematicsSimulationWidget with negative deceleration and custom units', (tester) async {
      final customData = InteractiveData()
        ..templateType = 'kinematics_simulation'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'v0'
            ..label = 'Velocità Iniziale'
            ..unit = 'm/s'
            ..minValue = 0.0
            ..maxValue = 50.0
            ..defaultValue = 20.0,
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Decelerazione Frenante'
            ..unit = 'm/s²'
            ..minValue = -10.0
            ..maxValue = 0.0
            ..defaultValue = -4.0
            ..stepSize = 0.5,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: KinematicsSimulationWidget(data: customData),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('20.0 m/s'), findsNWidgets(2)); // telemetry pill + slider badge
      expect(find.text('-4.0 m/s²'), findsOneWidget); // slider badge
    });
  });
}
