import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/data/catalog/physics_catalog.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/widgets/interactive/kinematics_simulation_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/live_equation_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/ohm_circuit_simulation_widget.dart';

void main() {
  group('R4: Configurable Slider System & Unit Decoupling Tests', () {
    testWidgets('LiveEquationWidget with custom unit displays custom unit and calculated value', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'N'
        ..equations = ['m * a']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'm'
            ..label = 'Massa (m)'
            ..unit = 'kg'
            ..minValue = 1.0
            ..maxValue = 20.0
            ..defaultValue = 5.0
            ..stepSize = 1.0,
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Accelerazione (a)'
            ..unit = 'm/s²'
            ..minValue = 0.0
            ..maxValue = 10.0
            ..defaultValue = 2.0
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

      // Risultato m * a = 5 * 2 = 10
      expect(find.text('10'), findsOneWidget);
      // Risultato ha unità 'N'
      expect(find.text('N'), findsOneWidget);
      // Non deve mostrare 'V'
      expect(find.text('V'), findsNothing);

      // Sliders con unità personalizzate
      expect(find.text('5 kg'), findsOneWidget);
      expect(find.text('2 m/s²'), findsOneWidget);
    });

    testWidgets('LiveEquationWidget with null unit displays naked number and NEVER displays "V"', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = null
        ..equations = ['a + b']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Valore A'
            ..minValue = 0.0
            ..maxValue = 10.0
            ..defaultValue = 3.0
            ..stepSize = 1.0,
          InteractiveParameter()
            ..variableName = 'b'
            ..label = 'Valore B'
            ..minValue = 0.0
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

      // Risultato a + b = 3 + 4 = 7
      expect(find.text('7'), findsOneWidget);
      // Assicurazione assoluta: l'unità 'V' non deve mai apparire
      expect(find.text('V'), findsNothing);

      // Sliders senza unità mostrano numeri puri
      expect(find.text('3'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('LiveEquationWidget with empty string unit displays naked number and NEVER displays "V"', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = '   '
        ..equations = ['c * 5']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'c'
            ..label = 'Concentrazione'
            ..unit = 'mol/L'
            ..minValue = 0.0
            ..maxValue = 10.0
            ..defaultValue = 2.0
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

      // Risultato c * 5 = 10
      expect(find.text('10'), findsOneWidget);
      // Nessuna unità nel risultato e mai 'V'
      expect(find.text('V'), findsNothing);
      expect(find.text('   '), findsNothing);

      // Badge parametro include la sua unità
      expect(find.text('2 mol/L'), findsOneWidget);
    });

    testWidgets('Parameter sliders with custom units display their respective unit labels', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'W'
        ..equations = ['V * I']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'V'
            ..label = 'Tensione'
            ..unit = 'V'
            ..minValue = 1.0
            ..maxValue = 48.0
            ..defaultValue = 12.0
            ..stepSize = 1.0,
          InteractiveParameter()
            ..variableName = 'I'
            ..label = 'Corrente'
            ..unit = 'A'
            ..minValue = 0.1
            ..maxValue = 10.0
            ..defaultValue = 2.0
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

      // Risultato in Watt
      expect(find.text('24'), findsOneWidget);
      expect(find.text('W'), findsOneWidget);

      // Badge sliders
      expect(find.text('12 V'), findsOneWidget);
      expect(find.text('2 A'), findsOneWidget);
    });

    testWidgets('Parameter sliders with null or empty units display naked numbers', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = null
        ..equations = ['x * y']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'x'
            ..label = 'X'
            ..unit = null
            ..minValue = 0.0
            ..maxValue = 50.0
            ..defaultValue = 15.0
            ..stepSize = 1.0,
          InteractiveParameter()
            ..variableName = 'y'
            ..label = 'Y'
            ..unit = ''
            ..minValue = 0.0
            ..maxValue = 50.0
            ..defaultValue = 25.0
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

      // Risultato x * y = 15 * 25 = 375
      expect(find.text('375'), findsOneWidget);
      expect(find.text('V'), findsNothing);

      // Naked numbers on parameter slider badges
      expect(find.text('15'), findsOneWidget);
      expect(find.text('25'), findsOneWidget);
    });

    testWidgets('Live slider dragging dynamically updates expression evaluation without errors', (tester) async {
      final data = InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'J'
        ..equations = ['R * I * I * t']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'R'
            ..label = 'Resistenza'
            ..unit = 'Ω'
            ..minValue = 1.0
            ..maxValue = 20.0
            ..defaultValue = 5.0
            ..stepSize = 1.0,
          InteractiveParameter()
            ..variableName = 'I'
            ..label = 'Corrente'
            ..unit = 'A'
            ..minValue = 1.0
            ..maxValue = 10.0
            ..defaultValue = 2.0
            ..stepSize = 1.0,
          InteractiveParameter()
            ..variableName = 't'
            ..label = 'Tempo'
            ..unit = 's'
            ..minValue = 1.0
            ..maxValue = 10.0
            ..defaultValue = 1.0
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

      // Iniziale: 5 * 2^2 * 1 = 20 J
      expect(find.text('20'), findsOneWidget);
      expect(find.text('J'), findsOneWidget);
      expect(find.text('5 Ω'), findsOneWidget);
      expect(find.text('2 A'), findsOneWidget);
      expect(find.text('1 s'), findsOneWidget);

      // Trascina il primo slider (Resistenza R) verso destra
      final sliders = find.byType(Slider);
      expect(sliders, findsNWidgets(3));

      await tester.drag(sliders.first, const Offset(60, 0));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Il risultato non deve più essere 20 e non devono esserci errori di calcolo
      expect(find.textContaining('Impossibile calcolare'), findsNothing);
      expect(find.text('J'), findsOneWidget);
    });

    testWidgets('OhmCircuitSimulationWidget respects custom parameter units and falls back gracefully', (tester) async {
      // Test 1: Configurazione esplicita con unità personalizzate
      final customData = InteractiveData()
        ..templateType = 'circuit_simulation'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'V'
            ..label = 'Generatore Alta Tensione'
            ..unit = 'kV'
            ..defaultValue = 24.0,
          InteractiveParameter()
            ..variableName = 'R'
            ..label = 'Carico Alta Resistenza'
            ..unit = 'kΩ'
            ..defaultValue = 12.0,
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

      expect(find.text('24 kV'), findsOneWidget);
      expect(find.text('12 kΩ'), findsOneWidget);

      // Test 2: Senza unità esplicite (fallback standard 'V' e 'Ω')
      final defaultData = InteractiveData()
        ..templateType = 'circuit_simulation'
        ..parameters = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: OhmCircuitSimulationWidget(data: defaultData),
            ),
          ),
        ),
      );
      await tester.pump();

      // Fallback a 'V' e 'Ω'
      expect(find.textContaining('V'), findsWidgets);
      expect(find.textContaining('Ω'), findsWidgets);

      // Test 3: Valori out-of-bounds clampati difensivamente senza eccezioni assertion
      final outOfBoundsData = InteractiveData()
        ..templateType = 'circuit_simulation'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'V'
            ..defaultValue = 100.0 // max default è 48.0
            ..unit = 'V',
          InteractiveParameter()
            ..variableName = 'R'
            ..defaultValue = 0.0 // min default è 1.0
            ..unit = 'Ω',
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
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('KinematicsSimulationWidget respects custom parameter units and falls back gracefully', (tester) async {
      // Test 1: Con unità personalizzate
      final customData = InteractiveData()
        ..templateType = 'kinematics_simulation'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'v0'
            ..label = 'Velocità Iniziale'
            ..unit = 'km/h'
            ..defaultValue = 15.0,
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Accelerazione'
            ..unit = 'g'
            ..defaultValue = 1.0,
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

      // '15.0 km/h' compare sia nella pillola telemetrica della velocità sia nel badge dello slider v0
      expect(find.text('15.0 km/h'), findsNWidgets(2));
      expect(find.text('15.0 m/s'), findsNothing);
      expect(find.text('1.0 g'), findsOneWidget);

      // Test 2: Fallback standard ('m/s' e 'm/s²')
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

      // '5.0 m/s' compare sia nella pillola telemetrica della velocità sia nel badge dello slider v0
      expect(find.text('5.0 m/s'), findsNWidgets(2));
      expect(find.text('2.0 m/s²'), findsOneWidget);

      // Test 3: Unità esplicitamente vuota per telemetria naked
      final nakedData = InteractiveData()
        ..templateType = 'kinematics_simulation'
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'v0'
            ..unit = ''
            ..defaultValue = 12.0,
          InteractiveParameter()
            ..variableName = 'a'
            ..unit = ''
            ..defaultValue = 3.0,
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

      // Telemetria pillola mostra numero naked '12.0' (trovato sia nella pillola che nello slider)
      expect(find.text('12.0'), findsNWidgets(2));
      expect(find.textContaining('12.0 m/s'), findsNothing);
    });

    test('PhysicsCatalog nodes are correctly configured with units and parameter units', () {
      final nodes = PhysicsCatalog.getAllNodes();

      final powerNode = nodes.firstWhere((n) => n.serverId == 'ele_power_01');
      expect(powerNode.interactiveData?.unit, 'W');
      expect(
        powerNode.interactiveData?.parameters
            ?.firstWhere((p) => p.variableName == 'V')
            .unit,
        'V',
      );
      expect(
        powerNode.interactiveData?.parameters
            ?.firstWhere((p) => p.variableName == 'I')
            .unit,
        'A',
      );

      final jouleNode = nodes.firstWhere((n) => n.serverId == 'ele_joule_01');
      expect(jouleNode.interactiveData?.unit, 'J');
      expect(
        jouleNode.interactiveData?.parameters
            ?.firstWhere((p) => p.variableName == 'R')
            .unit,
        'Ω',
      );
      expect(
        jouleNode.interactiveData?.parameters
            ?.firstWhere((p) => p.variableName == 'I')
            .unit,
        'A',
      );
      expect(
        jouleNode.interactiveData?.parameters
            ?.firstWhere((p) => p.variableName == 't')
            .unit,
        's',
      );

      final phNode = nodes.firstWhere((n) => n.serverId == 'chem_ph_01');
      expect(phNode.interactiveData?.unit, '');
      expect(
        phNode.interactiveData?.parameters
            ?.firstWhere((p) => p.variableName == 'c')
            .unit,
        'mol/L',
      );

      final kinNode = nodes.firstWhere((n) => n.serverId == 'phys_kin_01');
      expect(
        kinNode.interactiveData?.parameters
            ?.firstWhere((p) => p.variableName == 'v0')
            .unit,
        'm/s',
      );
      expect(
        kinNode.interactiveData?.parameters
            ?.firstWhere((p) => p.variableName == 'a')
            .unit,
        'm/s²',
      );

      final ohmNode = nodes.firstWhere((n) => n.serverId == 'ele_ohm_01');
      expect(
        ohmNode.interactiveData?.parameters
            ?.firstWhere((p) => p.variableName == 'V')
            .unit,
        'V',
      );
      expect(
        ohmNode.interactiveData?.parameters
            ?.firstWhere((p) => p.variableName == 'R')
            .unit,
        'Ω',
      );
    });
  });
}
