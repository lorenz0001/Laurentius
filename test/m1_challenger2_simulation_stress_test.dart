import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/widgets/interactive/interactive_template_factory.dart';
import 'package:laurentius/presentation/widgets/interactive/kinematics_simulation_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/live_equation_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/ohm_circuit_simulation_widget.dart';

void main() {
  group('Empirical Challenge 2: InteractiveTemplateFactory Resilience', () {
    test('Returns null when data is null', () {
      final widget = InteractiveTemplateFactory.buildWidget(null);
      expect(widget, isNull);
    });

    test('Returns null when templateType is unknown and parameters/equations are empty', () {
      final data = InteractiveData()
        ..templateType = 'unknown_future_template'
        ..equations = []
        ..parameters = [];
      final widget = InteractiveTemplateFactory.buildWidget(data);
      expect(widget, isNull);
    });

    test('Falls back to LiveEquationWidget when templateType is unknown but equations exist', () {
      final data = InteractiveData()
        ..templateType = 'custom_unregistered_equation'
        ..unit = 'kg'
        ..equations = ['2 * x']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'x'
            ..defaultValue = 5.0,
        ];
      final widget = InteractiveTemplateFactory.buildWidget(data);
      expect(widget, isA<LiveEquationWidget>());
    });

    test('Resolves circuit simulation aliases to OhmCircuitSimulationWidget', () {
      for (final alias in ['circuit_simulation', 'ohm_simulation']) {
        final data = InteractiveData()
          ..templateType = alias
          ..parameters = [
            InteractiveParameter()
              ..variableName = 'V'
              ..unit = 'kV'
              ..defaultValue = 24.0,
          ];
        final widget = InteractiveTemplateFactory.buildWidget(data);
        expect(widget, isA<OhmCircuitSimulationWidget>());
        final ohmWidget = widget as OhmCircuitSimulationWidget;
        expect(ohmWidget.data?.parameters?.first.unit, 'kV');
      }
    });

    test('Resolves kinematics simulation aliases to KinematicsSimulationWidget', () {
      for (final alias in ['kinematics_simulation', 'rectilinear_motion']) {
        final data = InteractiveData()
          ..templateType = alias
          ..parameters = [
            InteractiveParameter()
              ..variableName = 'v0'
              ..unit = 'mph'
              ..defaultValue = 60.0,
          ];
        final widget = InteractiveTemplateFactory.buildWidget(data);
        expect(widget, isA<KinematicsSimulationWidget>());
        final kinWidget = widget as KinematicsSimulationWidget;
        expect(kinWidget.data?.parameters?.first.unit, 'mph');
      }
    });
  });

  group('Empirical Challenge 2: OhmCircuitSimulationWidget Stress & Units', () {
    testWidgets('Custom units badge formatting and graceful fallback', (tester) async {
      tester.view.physicalSize = const Size(1000, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final customData = InteractiveData()
        ..templateType = 'circuit_simulation'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'V'
            ..label = 'Tensione Elettrica'
            ..unit = 'MV'
            ..minValue = 10.0
            ..maxValue = 100.0
            ..defaultValue = 50.0
            ..stepSize = 10.0,
          InteractiveParameter()
            ..variableName = 'R'
            ..label = 'Resistenza Elettrica'
            ..unit = 'MΩ'
            ..minValue = 5.0
            ..maxValue = 50.0
            ..defaultValue = 25.0
            ..stepSize = 5.0,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: OhmCircuitSimulationWidget(data: customData),
            ),
          ),
        ),
      );
      await tester.pump();

      // Badges with custom units
      expect(find.text('50 MV'), findsOneWidget);
      expect(find.text('25 MΩ'), findsOneWidget);
      // Telemetry: 50 / 25 = 2.00 A, Power = 50 * 2 = 100.0 W
      expect(find.text('2.00 A'), findsOneWidget);
      expect(find.text('100.0 W'), findsOneWidget);
    });

    testWidgets('Naked number formatting when unit is empty string or whitespace', (tester) async {
      final nakedData = InteractiveData()
        ..templateType = 'circuit_simulation'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'V'
            ..label = 'Voltaggio Adimensionale'
            ..unit = '   '
            ..defaultValue = 30.0,
          InteractiveParameter()
            ..variableName = 'R'
            ..label = 'Resistenza Adimensionale'
            ..unit = ''
            ..defaultValue = 10.0,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: OhmCircuitSimulationWidget(data: nakedData),
            ),
          ),
        ),
      );
      await tester.pump();

      // Sliders should display naked numbers without trailing unit text
      expect(find.text('30'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('Interactive slider dragging re-evaluates telemetry accurately without crashing', (tester) async {
      tester.view.physicalSize = const Size(1000, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final data = InteractiveData()
        ..templateType = 'circuit_simulation'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'V'
            ..unit = 'V'
            ..minValue = 1.0
            ..maxValue = 48.0
            ..defaultValue = 12.0
            ..stepSize = 1.0,
          InteractiveParameter()
            ..variableName = 'R'
            ..unit = 'Ω'
            ..minValue = 1.0
            ..maxValue = 48.0
            ..defaultValue = 6.0
            ..stepSize = 1.0,
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
      await tester.pump();

      expect(find.text('12 V'), findsOneWidget);
      expect(find.text('6 Ω'), findsOneWidget);
      expect(find.text('2.00 A'), findsOneWidget);
      expect(find.text('24.0 W'), findsOneWidget);

      final sliders = find.byType(Slider);
      expect(sliders, findsNWidgets(2));

      // Drag voltage slider
      await tester.drag(sliders.first, const Offset(100, 0));
      await tester.pump();

      expect(find.text('12 V'), findsNothing);
      expect(find.text('2.00 A'), findsNothing);

      // Drag resistance slider
      await tester.drag(sliders.last, const Offset(80, 0));
      await tester.pump();

      expect(find.text('6 Ω'), findsNothing);
    });

    testWidgets('VULNERABILITY RESOLVED: OhmCircuitSimulationWidget safely clamps slider value when defaultValue is out of bounds', (tester) async {
      // In OhmCircuitSimulationWidget line 504, Slider value is now defensively clamped (`value: value.clamp(min, max)`),
      // matching LiveEquationWidget (line 350) and KinematicsSimulationWidget (line 486).
      // If a parameter defaultValue is outside min..max (e.g. 0.0 with min=1.0),
      // Flutter's Slider no longer throws an unhandled assertion error.
      final outOfBoundsData = InteractiveData()
        ..templateType = 'circuit_simulation'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'V'
            ..defaultValue = 12.0,
          InteractiveParameter()
            ..variableName = 'R'
            ..defaultValue = 0.0, // 0.0 is less than default min 1.0
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: OhmCircuitSimulationWidget(data: outOfBoundsData),
            ),
          ),
        ),
      );

      // Verify that Flutter no longer throws an assertion error due to defensive .clamp(min, max)
      final exception = tester.takeException();
      expect(exception, isNull);
    });

    testWidgets('Toggles play/pause and electron flow modes without errors', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: OhmCircuitSimulationWidget(),
            ),
          ),
        ),
      );
      await tester.pump();

      // Initial state is playing; find pause icon button
      final pauseButton = find.byIcon(Icons.pause_circle_filled_rounded);
      expect(pauseButton, findsOneWidget);

      await tester.tap(pauseButton);
      await tester.pump();

      // After tap, icon changes to play_circle_fill_rounded
      expect(find.byIcon(Icons.play_circle_fill_rounded), findsOneWidget);

      // Toggle electron flow mode button
      expect(find.text('e⁻ Reale'), findsOneWidget);
      await tester.tap(find.text('e⁻ Reale'));
      await tester.pump();
      expect(find.text('I Conv.'), findsOneWidget);
    });

    testWidgets('didUpdateWidget reloads parameters cleanly when data changes', (tester) async {
      tester.view.physicalSize = const Size(1000, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final initialData = InteractiveData()
        ..templateType = 'circuit_simulation'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'V'
            ..defaultValue = 10.0
            ..unit = 'V',
          InteractiveParameter()
            ..variableName = 'R'
            ..defaultValue = 5.0
            ..unit = 'Ω',
        ];

      final updatedData = InteractiveData()
        ..templateType = 'circuit_simulation'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'V'
            ..defaultValue = 36.0
            ..unit = 'kV',
          InteractiveParameter()
            ..variableName = 'R'
            ..defaultValue = 18.0
            ..unit = 'kΩ',
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: OhmCircuitSimulationWidget(data: initialData),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('10 V'), findsOneWidget);
      expect(find.text('5 Ω'), findsOneWidget);

      // Re-pump with updated data
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: OhmCircuitSimulationWidget(data: updatedData),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('36 kV'), findsOneWidget);
      expect(find.text('18 kΩ'), findsOneWidget);
    });
  });

  group('Empirical Challenge 2: KinematicsSimulationWidget Stress & Units', () {
    testWidgets('Custom units badge formatting and telemetry inspection', (tester) async {
      final customData = InteractiveData()
        ..templateType = 'kinematics_simulation'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'v0'
            ..label = 'Velocità Iniziale'
            ..unit = 'mph'
            ..minValue = 0.0
            ..maxValue = 120.0
            ..defaultValue = 45.0
            ..stepSize = 5.0,
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Accelerazione'
            ..unit = 'ft/s²'
            ..minValue = -10.0
            ..maxValue = 20.0
            ..defaultValue = 5.0
            ..stepSize = 1.0,
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

      // Sliders and telemetry correctly format custom units
      expect(find.text('45.0 mph'), findsNWidgets(2)); // telemetry pill + slider badge
      expect(find.text('5.0 ft/s²'), findsOneWidget);
      expect(find.text('45.0 m/s'), findsNothing);
    });

    testWidgets('Naked number formatting when kinematics unit is explicitly empty', (tester) async {
      final nakedData = InteractiveData()
        ..templateType = 'kinematics_simulation'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'v0'
            ..unit = '   '
            ..defaultValue = 10.0,
          InteractiveParameter()
            ..variableName = 'a'
            ..unit = ''
            ..defaultValue = 2.0,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: KinematicsSimulationWidget(data: nakedData),
            ),
          ),
        ),
      );
      await tester.pump();

      // Slider badges and telemetry show naked numbers without trailing whitespace
      expect(find.text('10.0'), findsNWidgets(2)); // telemetry pill + slider badge
      expect(find.text('2.0'), findsOneWidget);
    });

    testWidgets('Fallback units when parameters have null units', (tester) async {
      final fallbackData = InteractiveData()
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
              child: KinematicsSimulationWidget(data: fallbackData),
            ),
          ),
        ),
      );
      await tester.pump();

      // Falls back to m/s and m/s²
      expect(find.text('5.0 m/s'), findsWidgets);
      expect(find.text('2.0 m/s²'), findsOneWidget);
    });

    testWidgets('Interactive slider drag updates kinematics parameter values', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: KinematicsSimulationWidget(),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('2.0 m/s²'), findsOneWidget);

      final sliders = find.byType(Slider);
      expect(sliders, findsNWidgets(2));

      await tester.drag(sliders.last, const Offset(60, 0));
      await tester.pump();

      expect(find.text('2.0 m/s²'), findsNothing);
    });

    testWidgets('Reset and play/pause controls respond cleanly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: KinematicsSimulationWidget(),
            ),
          ),
        ),
      );
      await tester.pump();

      // Find pause button
      final pauseButton = find.byIcon(Icons.pause_circle_filled_rounded);
      expect(pauseButton, findsOneWidget);

      await tester.tap(pauseButton);
      await tester.pump();
      expect(find.byIcon(Icons.play_circle_fill_rounded), findsOneWidget);

      // Find reset button
      final resetButton = find.byIcon(Icons.replay_rounded);
      expect(resetButton, findsOneWidget);
      await tester.tap(resetButton);
      await tester.pump();

      // Time telemetry reset to 0.0 s
      expect(find.text('0.0 s'), findsOneWidget);
    });
  });

  group('Empirical Challenge 2: LiveEquationWidget Deep Stress', () {
    testWidgets('Division by zero in mathematical expression handled gracefully without crashing UI', (tester) async {
      final divZeroData = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'A'
        ..equations = ['num / den']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'num'
            ..label = 'Numeratore'
            ..defaultValue = 10.0,
          InteractiveParameter()
            ..variableName = 'den'
            ..label = 'Denominatore'
            ..minValue = 0.0
            ..maxValue = 10.0
            ..defaultValue = 0.0,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LiveEquationWidget(data: divZeroData),
            ),
          ),
        ),
      );
      await tester.pump();

      // LiveEquationWidget stays mounted and does not throw unhandled exception
      expect(find.byType(LiveEquationWidget), findsOneWidget);
      // Evaluates to Infinity or error message, unit 'A' rendered, NEVER hardcoded 'V'
      expect(find.text('V'), findsNothing);
    });

    testWidgets('Unicode and exotic units format cleanly', (tester) async {
      final exoticData = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'μmol/m²·s'
        ..equations = ['flux * 1.5']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'flux'
            ..label = 'Flusso Fotonico'
            ..unit = 'μmol/s'
            ..defaultValue = 4.0,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LiveEquationWidget(data: exoticData),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('6'), findsOneWidget);
      expect(find.text('μmol/m²·s'), findsOneWidget);
      expect(find.text('4 μmol/s'), findsOneWidget);
      expect(find.text('V'), findsNothing);
    });

    testWidgets('Rapid multiple slider drags maintain calculation consistency', (tester) async {
      final multiParamData = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'W'
        ..equations = ['a + b + c']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..defaultValue = 1.0
            ..minValue = 0.0
            ..maxValue = 10.0
            ..unit = 'W',
          InteractiveParameter()
            ..variableName = 'b'
            ..defaultValue = 2.0
            ..minValue = 0.0
            ..maxValue = 10.0
            ..unit = 'W',
          InteractiveParameter()
            ..variableName = 'c'
            ..defaultValue = 3.0
            ..minValue = 0.0
            ..maxValue = 10.0
            ..unit = 'W',
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LiveEquationWidget(data: multiParamData),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('6'), findsOneWidget);
      expect(find.text('W'), findsOneWidget);

      final sliders = find.byType(Slider);
      expect(sliders, findsNWidgets(3));

      // Rapid drags on all 3 sliders
      for (final slider in sliders.evaluate()) {
        await tester.drag(find.byWidget(slider.widget), const Offset(20, 0));
        await tester.pump();
      }

      // Result calculated without error
      expect(find.textContaining('Impossibile calcolare'), findsNothing);
      expect(find.text('W'), findsOneWidget);
    });
  });
}
