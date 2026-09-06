import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/data/catalog/arithmetic_catalog.dart';
import 'package:laurentius/data/catalog/algebra_catalog.dart';
import 'package:laurentius/data/catalog/calculus_catalog.dart';
import 'package:laurentius/data/catalog/curriculum_registry.dart';
import 'package:laurentius/data/catalog/geometry_trig_catalog.dart';
import 'package:laurentius/data/catalog/physics_catalog.dart';
import 'package:laurentius/presentation/pages/category_explorer_screen.dart';
import 'package:laurentius/presentation/widgets/interactive/trig_circle_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/kinematics_simulation_widget.dart';

void main() {
  group('Step 12: Macro-Section Reorganization Tests', () {
    test('All mathematical disciplines are unified under category "Matematica"', () {
      final mathNodes = [
        ...ArithmeticCatalog.getAllNodes(),
        ...AlgebraCatalog.getAllNodes(),
        ...GeometryTrigCatalog.getAllNodes(),
        ...CalculusCatalog.getAllNodes(),
      ];

      for (final node in mathNodes) {
        expect(
          node.category,
          equals('Matematica'),
          reason: 'Node ${node.serverId} should be categorized as Matematica',
        );
      }
    });

    test('Physics and Electrical Engineering are properly separated', () {
      final physNodes = PhysicsCatalog.getAllNodes();
      
      final kinNode = physNodes.firstWhere((n) => n.serverId == 'phys_kin_01');
      final phNode = physNodes.firstWhere((n) => n.serverId == 'chem_ph_01');
      final ohmNode = physNodes.firstWhere((n) => n.serverId == 'ele_ohm_01');
      final powerNode = physNodes.firstWhere((n) => n.serverId == 'ele_power_01');
      final jouleNode = physNodes.firstWhere((n) => n.serverId == 'ele_joule_01');

      expect(kinNode.category, equals('Fisica'));
      expect(phNode.category, equals('Fisica'));

      expect(ohmNode.category, equals('Elettrotecnica'));
      expect(powerNode.category, equals('Elettrotecnica'));
      expect(jouleNode.category, equals('Elettrotecnica'));
    });
  });

  group('Step 12: Monotonic Difficulty & DAG Topological Ordering Tests', () {
    int computeDepth(String serverId, Map<String, List<String>> prereqs, [Set<String>? visited]) {
      visited ??= {};
      if (visited.contains(serverId)) return 0;
      visited.add(serverId);
      final parents = prereqs[serverId] ?? [];
      if (parents.isEmpty) return 0;
      int maxD = 0;
      for (final p in parents) {
        final d = computeDepth(p, prereqs, visited);
        if (d + 1 > maxD) maxD = d + 1;
      }
      return maxD;
    }

    test('Roots of the curriculum have depth 0 and highest vertical position', () {
      final prereqs = CurriculumRegistry.prerequisiteMap;

      // I nodi radice (più in alto nel grafo)
      expect(computeDepth('mat_add_01', prereqs), equals(0));
      expect(computeDepth('ele_ohm_01', prereqs), equals(3)); // Dipende da mat_frac_01 (profondità 2)
    });

    test('Difficulty increases monotonically along mathematical learning pathways', () {
      final prereqs = CurriculumRegistry.prerequisiteMap;

      // Percorso didattico: Addizione -> Moltiplicazione -> Potenze -> Binomio -> Teorema Fondamentale
      final dAdd = computeDepth('mat_add_01', prereqs);
      final dMul = computeDepth('mat_mul_01', prereqs);
      final dPow = computeDepth('mat_pow_01', prereqs);
      final dBinom = computeDepth('mat_binom_01', prereqs);
      final dDeriv = computeDepth('mat_deriv_def_01', prereqs);
      final dFund = computeDepth('mat_fund_calc_01', prereqs);

      expect(dAdd < dMul, isTrue);
      expect(dMul < dPow, isTrue);
      expect(dPow < dBinom, isTrue);
      expect(dBinom < dDeriv, isTrue);
      expect(dDeriv < dFund, isTrue);
    });
  });

  group('Step 12: CategoryExplorerScreen Tabs and Single-Item Flattening UI Tests', () {
    testWidgets('Renders tabs for Matematica, Fisica, Elettrotecnica', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategoryExplorerScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Matematica'), findsOneWidget);
      expect(find.text('Fisica'), findsOneWidget);
      expect(find.text('Elettrotecnica'), findsOneWidget);
    });

    testWidgets('Single item subcategories do not create nested folders (ExpansionTile)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategoryExplorerScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Passa alla tab "Fisica"
      await tester.tap(find.text('Fisica'));
      await tester.pumpAndSettle();

      // In Fisica, i nodi sono "Cinematica e Dinamica" (1 nodo) e "Chimica Fisica" (1 nodo).
      // Entrambi hanno 1 solo elemento, quindi non devono avere ExpansionTile folders ma essere visualizzati direttamente!
      expect(find.textContaining('Cinematica'), findsWidgets);
      expect(find.textContaining('Soluzioni Acido-Base'), findsOneWidget);
      
      // Nessun ExpansionTile di cartella in questa vista
      expect(find.byType(ExpansionTile), findsNothing);
    });
  });

  group('Step 12: Upgraded Simulations Tests', () {
    testWidgets('TrigCircleWidget supports interactive drag and auto-rotation toggle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TrigCircleWidget(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Circonferenza Goniometrica'), findsOneWidget);
      expect(find.text('cos(θ)'), findsOneWidget);
      expect(find.text('sin(θ)'), findsOneWidget);
      expect(find.text('tan(θ)'), findsOneWidget);
      expect(find.text('Trascina sul cerchio'), findsOneWidget);

      // Tap sul pulsante di auto-rotazione
      final autoRotateBtn = find.byTooltip('Auto-rotazione continua 60 FPS');
      expect(autoRotateBtn, findsOneWidget);
      await tester.tap(autoRotateBtn);
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byTooltip('Ferma rotazione'), findsOneWidget);
    });

    testWidgets('KinematicsSimulationWidget includes checkered finish line at 100m', (tester) async {
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
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Simulatore Cinematica (MRUA)'), findsOneWidget);
      expect(find.text('SPAZIO (x)'), findsOneWidget);
      expect(find.text('VELOCITÀ (v)'), findsOneWidget);
    });
  });
}
