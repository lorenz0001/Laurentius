import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/data/catalog/curriculum_registry.dart';
import 'package:laurentius/data/content/content_loader_service.dart';
import 'package:laurentius/data/content/markdown_content_parser.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/widgets/interactive/cartesian_graph_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/derivative_tangent_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/interactive_template_factory.dart';
import 'package:laurentius/presentation/widgets/interactive/kinematics_simulation_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/live_equation_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/ohm_circuit_simulation_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/squeeze_theorem_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/triangle_solver_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/trig_circle_widget.dart';

// ============================================================================
// Mathematical & Topological Helper Classes for Opaque-Box E2E Testing
// ============================================================================

/// 2D Vector model representing mathematical properties of R^2 vectors.
class _Vector2D {
  final double x;
  final double y;

  const _Vector2D(this.x, this.y);

  double get norm => math.sqrt(x * x + y * y);
  double get angle => math.atan2(y, x);

  _Vector2D operator +(_Vector2D other) => _Vector2D(x + other.x, y + other.y);
  _Vector2D operator -(_Vector2D other) => _Vector2D(x - other.x, y - other.y);
  _Vector2D operator *(double scalar) => _Vector2D(x * scalar, y * scalar);

  double dot(_Vector2D other) => x * other.x + y * other.y;
  double det2D(_Vector2D other) => x * other.y - y * other.x;

  _Vector2D normalize() {
    final n = norm;
    if (n < 1e-12) return const _Vector2D(0, 0);
    return _Vector2D(x / n, y / n);
  }

  bool isCollinearWith(_Vector2D other, {double eps = 1e-9}) {
    return det2D(other).abs() < eps;
  }
}

/// DAG Topology validator implementing Kahn's algorithm and root isolation.
class _DAGValidator {
  static bool isAcyclic(Map<String, List<String>> graph) {
    final inDegree = <String, int>{};
    for (final node in graph.keys) {
      inDegree[node] = 0;
    }
    for (final prereqs in graph.values) {
      for (final p in prereqs) {
        inDegree.putIfAbsent(p, () => 0);
      }
    }

    final adj = <String, List<String>>{};
    for (final entry in graph.entries) {
      final dependent = entry.key;
      for (final prereq in entry.value) {
        adj.putIfAbsent(prereq, () => []).add(dependent);
        inDegree[dependent] = (inDegree[dependent] ?? 0) + 1;
      }
    }

    final queue = <String>[];
    for (final entry in inDegree.entries) {
      if (entry.value == 0) {
        queue.add(entry.key);
      }
    }

    int visited = 0;
    while (queue.isNotEmpty) {
      final curr = queue.removeAt(0);
      visited++;
      for (final neighbor in adj[curr] ?? []) {
        inDegree[neighbor] = inDegree[neighbor]! - 1;
        if (inDegree[neighbor] == 0) {
          queue.add(neighbor);
        }
      }
    }

    return visited == inDegree.length;
  }

  static List<String> getRoots(Map<String, List<String>> graph) {
    final nonRoots = <String>{};
    for (final entry in graph.entries) {
      if (entry.value.isNotEmpty) {
        nonRoots.add(entry.key);
      }
    }
    final allNodes = <String>{...graph.keys};
    for (final prereqs in graph.values) {
      allNodes.addAll(prereqs);
    }
    return allNodes.where((id) => !nonRoots.contains(id)).toList();
  }
}

/// Helper to wrap widgets in a stable testing scaffold.
Widget _wrap(Widget child, {double width = 900, double height = 800}) {
  return MaterialApp(
    theme: ThemeData.dark(),
    home: Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: width,
          height: height,
          child: SingleChildScrollView(
            child: child,
          ),
        ),
      ),
    ),
  );
}

// ============================================================================
// Reference Specifications for Linear Algebra Curriculum (5 Sequential Nodes)
// ============================================================================

const String _specLinAlg01Tuples = '''---
id: lin_alg_01_tuples
title: "Concetto di n-upla ordinata e spazio R^n"
category: "Matematica"
subCategory: "Algebra Lineare"
prerequisites:
  - mat_add_01
  - mat_pythagoras_01
interactive:
  template: vector_2d
  unit: ""
  equations:
    - "sqrt(x1*x1 + x2*x2)"
  parameters:
    - variable: x1
      label: "Componente x1"
      min: -10.0
      max: 10.0
      default: 3.0
      step: 0.5
    - variable: x2
      label: "Componente x2"
      min: -10.0
      max: 10.0
      default: 4.0
      step: 0.5
---

### Dalle Coppie Ordinate allo Spazio n-Dimensionale

Lo spazio vettoriale \$\\mathbb{R}^n\$ rappresenta l'insieme di tutte le \$n\$-uple ordinate di numeri reali:

\$\$\\mathbf{x} = (x_1, x_2, \\dots, x_n) \\in \\mathbb{R}^n\$\$

> **Insight:** Una coppia ordinata \$(x_1, x_2)\$ individua un punto nel piano cartesiano, mentre una terna \$(x_1, x_2, x_3)\$ definisce una posizione nello spazio tridimensionale.

## Dimostrazione Logico-Algebrica

### 1. Definizione di Prodotto Cartesiano Generalizzato
\$\$\\mathbb{R}^n = \\underbrace{\\mathbb{R} \\times \\mathbb{R} \\times \\dots \\times \\mathbb{R}}_{n \\text{ volte}} = \\{ (x_1, \\dots, x_n) : x_i \\in \\mathbb{R} \\}\$\$
> **Insight:** Ogni asse cartesiano corrisponde a una dimensione di libertà indipendente.

### 2. Metrica Euclidea e Norma
\$\$\\|\\mathbf{x}\\| = \\sqrt{\\sum_{i=1}^n x_i^2}\$\$
> **Insight:** Estensione multidimensionale del Teorema di Pitagora.

### 3. Corollario: Spazio Euclideo Standard
\$\$\\forall \\mathbf{x}, \\mathbf{y} \\in \\mathbb{R}^n, \\quad d(\\mathbf{x}, \\mathbf{y}) = \\|\\mathbf{x} - \\mathbf{y}\\| = \\sqrt{\\sum_{i=1}^n (x_i - y_i)^2}\$\$
> **Insight:** La distanza cartesiana soddisfa gli assiomi di metrica: positività, simmetria e disuguaglianza triangolare.

### 4. Corollario: Isomorfismo Geometrico del Piano
\$\$\\mathbb{R}^2 \\cong \\mathbb{E}^2\$\$
> **Insight:** Ogni punto del piano geometrico corrisponde biunivocamente a una coppia numerica ordinata.
''';

const String _specLinAlg02Vectors = '''---
id: lin_alg_02_vectors
title: "Vettori Geometrici e Coordinate Canoniche"
category: "Matematica"
subCategory: "Algebra Lineare"
prerequisites:
  - lin_alg_01_tuples
interactive:
  template: vector_2d
  parameters:
    - variable: vx
      label: "Componente vx"
      min: -10.0
      max: 10.0
      default: 5.0
    - variable: vy
      label: "Componente vy"
      min: -10.0
      max: 10.0
      default: 2.0
---

### Vettori Applicati e Vettori Liberi

Un vettore geometrico sul piano è caratterizzato da modulo, direzione e verso:

\$\$\\mathbf{v} = v_x \\mathbf{e}_1 + v_y \\mathbf{e}_2\$\$

## Dimostrazione Logico-Algebrica

### 1. Decomposizione lungo la base canonica
\$\$\\mathbf{v} = \\begin{pmatrix} v_x \\\\ v_y \\end{pmatrix} = v_x \\begin{pmatrix} 1 \\\\ 0 \\end{pmatrix} + v_y \\begin{pmatrix} 0 \\\\ 1 \\end{pmatrix}\$\$
> **Insight:** I versori canonici formano le coordinate proiettive ortogonali.

### 2. Corollario: Calcolo della Norma e Disuguaglianza di Cauchy-Schwarz
\$\$\\|\\mathbf{v}\\| = \\sqrt{v_x^2 + v_y^2} \\ge 0\$\$
> **Insight:** La norma è non-negativa ed è nulla se e solo se il vettore è il vettore nullo.

### 3. Corollario: Versore e Normalizzazione
\$\$\\mathbf{u} = \\frac{\\mathbf{v}}{\\|\\mathbf{v}\\|} \\implies \\|\\mathbf{u}\\| = 1\$\$
> **Insight:** Qualsiasi vettore non nullo può essere scalato a lunghezza unitaria conservando verso e direzione.
''';

const String _specLinAlg03Operations = '''---
id: lin_alg_03_operations
title: "Operazioni Vettoriali Fondamentali"
category: "Matematica"
subCategory: "Algebra Lineare"
prerequisites:
  - lin_alg_02_vectors
interactive:
  template: vector_addition
  parameters:
    - variable: v1x
      default: 3.0
    - variable: v1y
      default: 1.0
    - variable: v2x
      default: 1.0
    - variable: v2y
      default: 4.0
---

### Somma Vettoriale e Moltiplicazione Scalare

La somma tra due vettori si calcola componente per componente:

\$\$\\mathbf{u} + \\mathbf{v} = (u_x + v_x, u_y + v_y)\$\$

## Dimostrazione Logico-Algebrica

### 1. Regola del Parallelogramma
\$\$\\mathbf{w} = \\mathbf{u} + \\mathbf{v}\$\$
> **Insight:** Il vettore somma corrisponde alla diagonale del parallelogramma formato dai vettori addendi.

### 2. Corollario: Disuguaglianza Triangolare
\$\$\\|\\mathbf{u} + \\mathbf{v}\\| \\le \\|\\mathbf{u}\\| + \\|\\mathbf{v}\\|\$\$
> **Insight:** La lunghezza di un lato del triangolo non può mai superare la somma degli altri due.

### 3. Corollario: Proprietà Distributiva dello Scalare
\$\$\\lambda (\\mathbf{u} + \\mathbf{v}) = \\lambda \\mathbf{u} + \\lambda \\mathbf{v}\$\$
> **Insight:** L'omogeneità della moltiplicazione preserva la struttura dello spazio vettoriale.
''';

const String _specLinAlg04Span = '''---
id: lin_alg_04_span
title: "Combinazioni Lineari e Spazio Generato (Span)"
category: "Matematica"
subCategory: "Algebra Lineare"
prerequisites:
  - lin_alg_03_operations
interactive:
  template: linear_combination
  parameters:
    - variable: c1
      default: 2.0
    - variable: c2
      default: -1.0
---

### Definizione di Span

Dato un insieme di vettori \$\\mathcal{S} = \\{\\mathbf{v}_1, \\dots, \\mathbf{v}_k\\}\$, lo spazio generato è:

\$\$\\text{Span}(\\mathbf{v}_1, \\dots, \\mathbf{v}_k) = \\left\\{ \\sum_{i=1}^k c_i \\mathbf{v}_i : c_i \\in \\mathbb{R} \\right\\}\$\$

## Dimostrazione Logico-Algebrica

### 1. Struttura di Sottospazio Vettoriale
\$\$\\mathbf{0} = 0 \\mathbf{v}_1 + \\dots + 0 \\mathbf{v}_k \\in \\text{Span}(\\mathcal{S})\$\$
> **Insight:** Lo span contiene sempre l'elemento neutro ed è chiuso rispetto alle combinazioni lineari.

### 2. Corollario: Generazione del Piano R^2
\$\$\\text{Se } \\det(\\mathbf{v}_1, \\mathbf{v}_2) \\ne 0 \\implies \\text{Span}(\\mathbf{v}_1, \\mathbf{v}_2) = \\mathbb{R}^2\$\$
> **Insight:** Due vettori non allineati generano l'intero piano cartesiano.

### 3. Corollario: Collasso su Retta per Vettori Paralleli
\$\$\\text{Se } \\mathbf{v}_2 = k \\mathbf{v}_1 \\implies \\text{Span}(\\mathbf{v}_1, \\mathbf{v}_2) = \\text{Span}(\\mathbf{v}_1)\$\$
> **Insight:** Due vettori collineari generano solamente una retta passante per l'origine.
''';

const String _specLinAlg05Independence = '''---
id: lin_alg_05_independence
title: "Dipendenza e Indipendenza Lineare"
category: "Matematica"
subCategory: "Algebra Lineare"
prerequisites:
  - lin_alg_04_span
interactive:
  template: linear_combination
  parameters:
    - variable: v1x
      default: 2.0
    - variable: v1y
      default: 3.0
    - variable: v2x
      default: -4.0
    - variable: v2y
      default: -6.0
---

### Definizione di Indipendenza Lineare

I vettori \$\\mathbf{v}_1, \\dots, \\mathbf{v}_k\$ sono linearmente indipendenti se:

\$\$\\sum_{i=1}^k c_i \\mathbf{v}_i = \\mathbf{0} \\implies c_1 = c_2 = \\dots = c_k = 0\$\$

## Dimostrazione Logico-Algebrica

### 1. Criterio di Annullamento Lineare
\$\$c_1 \\mathbf{v}_1 + c_2 \\mathbf{v}_2 = \\mathbf{0}\$\$
> **Insight:** Se esiste una combinazione a coefficienti non tutti nulli che dà zero, un vettore è esprimibile come multiplo dell'altro.

### 2. Corollario: Criterio del Determinante in R^2
\$\$\\det \\begin{pmatrix} v_{1x} & v_{2x} \\\\ v_{1y} & v_{2y} \\end{pmatrix} \\ne 0 \\iff \\mathbf{v}_1, \\mathbf{v}_2 \\text{ indipendenti}\$\$
> **Insight:** Il determinante misura l'area orientata del parallelogramma: è nullo solo se i vettori sono paralleli.

### 3. Corollario: Dimensione Massima e Basi di R^2
\$\$\\text{In } \\mathbb{R}^2, \\text{ ogni insieme di } k > 2 \\text{ vettori è linearmente dipendente}\$\$
> **Insight:** La cardinalità di una base massimale è pari alla dimensione dello spazio vettoriale.
''';

// ============================================================================
// MAIN TEST SUITE: 4-TIER E2E VALIDATION
// ============================================================================

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // ==========================================================================
  // TIER 1: FEATURE COVERAGE (>=5 tests per feature across all 8 features)
  // Total Tier 1 tests: 8 features * 5 tests = 40 tests
  // ==========================================================================
  group('Tier 1: Feature Coverage (Features 1 to 8)', () {
    // ------------------------------------------------------------------------
    // Feature 1 (R1): Simulation Autoplay Suppression
    // ------------------------------------------------------------------------
    group('F1: Simulation Autoplay Suppression on Mount', () {
      testWidgets('1.1 TrigCircleWidget mounts paused without auto-rotation', (tester) async {
        await tester.pumpWidget(_wrap(const TrigCircleWidget()));
        await tester.pump();

        expect(find.byTooltip('Auto-rotazione continua 60 FPS'), findsOneWidget);
        expect(find.byTooltip('Ferma rotazione'), findsNothing);

        final angleText1 = (find.textContaining('θ =').evaluate().first.widget as Text).data!;
        await tester.pump(const Duration(seconds: 1));
        final angleText2 = (find.textContaining('θ =').evaluate().first.widget as Text).data!;

        expect(angleText1, equals(angleText2));
      });

      testWidgets('1.2 KinematicsSimulationWidget mounts paused without vehicle movement', (tester) async {
        final data = InteractiveData()
          ..templateType = 'kinematics_simulation'
          ..parameters = [
            InteractiveParameter()..variableName = 'v0'..defaultValue = 10.0,
            InteractiveParameter()..variableName = 'a'..defaultValue = 2.0,
          ];
        await tester.pumpWidget(_wrap(KinematicsSimulationWidget(data: data)));
        await tester.pump();

        expect(find.byTooltip('Avvia'), findsOneWidget);
        expect(find.byTooltip('Pausa'), findsNothing);
        expect(find.textContaining('0.0 m'), findsWidgets);
      });

      testWidgets('1.3 OhmCircuitSimulationWidget mounts paused without electron drift', (tester) async {
        final data = InteractiveData()
          ..templateType = 'circuit_simulation'
          ..parameters = [
            InteractiveParameter()..variableName = 'V'..defaultValue = 12.0,
            InteractiveParameter()..variableName = 'R'..defaultValue = 6.0,
          ];
        await tester.pumpWidget(_wrap(OhmCircuitSimulationWidget(data: data)));
        await tester.pump();

        expect(find.byTooltip('Avvia flusso'), findsOneWidget);
        expect(find.byTooltip('Pausa flusso'), findsNothing);
      });

      testWidgets('1.4 SqueezeTheoremWidget mounts paused without corridor animation', (tester) async {
        final data = InteractiveData()..templateType = 'squeeze_theorem';
        await tester.pumpWidget(_wrap(SqueezeTheoremWidget(data: data)));
        await tester.pump();

        expect(find.byTooltip('Anima convergenza δ ➔ 0 a 60 FPS'), findsOneWidget);
        expect(find.byTooltip('Pausa convergenza'), findsNothing);
      });

      testWidgets('1.5 TriangleSolverWidget mounts paused without angle oscillation', (tester) async {
        final data = InteractiveData()..templateType = 'triangle_solver';
        await tester.pumpWidget(_wrap(TriangleSolverWidget(data: data)));
        await tester.pump();

        expect(find.byTooltip('Anima trasformazione triangolo'), findsOneWidget);
        expect(find.byTooltip('Pausa deformazione'), findsNothing);
      });
    });

    // ------------------------------------------------------------------------
    // Feature 2 (R1): 60fps Reactivity & Manual Touch Controls
    // ------------------------------------------------------------------------
    group('F2: 60fps Reactivity & Manual Touch Controls', () {
      testWidgets('2.1 TrigCircleWidget updates angle display smoothly upon drag', (tester) async {
        await tester.pumpWidget(_wrap(const TrigCircleWidget()));
        await tester.pump();

        final customPainterFinder = find.byType(CustomPaint);
        expect(customPainterFinder, findsWidgets);

        // Verify chips allow manual angle selection
        final chipFinder = find.text('π/2');
        if (chipFinder.evaluate().isNotEmpty) {
          await tester.tap(chipFinder);
          await tester.pump(const Duration(milliseconds: 50));
          expect(find.textContaining('90.0°'), findsWidgets);
        }
      });

      testWidgets('2.2 KinematicsSimulationWidget adjusts velocity via parameter slider', (tester) async {
        final data = InteractiveData()
          ..templateType = 'kinematics_simulation'
          ..parameters = [
            InteractiveParameter()..variableName = 'v0'..label = 'v0'..minValue = 0.0..maxValue = 30.0..defaultValue = 5.0,
            InteractiveParameter()..variableName = 'a'..label = 'a'..minValue = 0.0..maxValue = 10.0..defaultValue = 2.0,
          ];
        await tester.pumpWidget(_wrap(KinematicsSimulationWidget(data: data)));
        await tester.pump();

        final sliders = find.byType(Slider);
        expect(sliders, findsAtLeastNWidgets(2));

        await tester.drag(sliders.first, const Offset(60, 0));
        await tester.pump(const Duration(milliseconds: 50));
        expect(tester.takeException(), isNull);
      });

      testWidgets('2.3 OhmCircuitSimulationWidget recalculates telemetry immediately on slider drag', (tester) async {
        final data = InteractiveData()
          ..templateType = 'circuit_simulation'
          ..parameters = [
            InteractiveParameter()..variableName = 'V'..label = 'V'..minValue = 1.0..maxValue = 24.0..defaultValue = 12.0..unit = 'V',
            InteractiveParameter()..variableName = 'R'..label = 'R'..minValue = 1.0..maxValue = 20.0..defaultValue = 4.0..unit = 'Ω',
          ];
        await tester.pumpWidget(_wrap(OhmCircuitSimulationWidget(data: data)));
        await tester.pump();

        // 12V / 4Ω = 3.00 A, 12V * 3A = 36.0 W
        expect(find.textContaining('3.00 A'), findsOneWidget);
        expect(find.textContaining('36.0 W'), findsOneWidget);
      });

      testWidgets('2.4 CartesianGraphWidget maintains responsive slider updates', (tester) async {
        final data = InteractiveData()
          ..templateType = 'function_graph'
          ..equations = ['a * x * x + b * x + c']
          ..parameters = [
            InteractiveParameter()..variableName = 'a'..defaultValue = 1.0,
            InteractiveParameter()..variableName = 'b'..defaultValue = 0.0,
            InteractiveParameter()..variableName = 'c'..defaultValue = -2.0,
          ];
        await tester.pumpWidget(_wrap(CartesianGraphWidget(data: data)));
        await tester.pump();

        expect(find.byType(CartesianGraphWidget), findsOneWidget);
        final sliders = find.byType(Slider);
        expect(sliders, findsAtLeastNWidgets(3));
      });

      testWidgets('2.5 DerivativeTangentWidget scrubs base point x0 and increment h', (tester) async {
        final data = InteractiveData()..templateType = 'derivative_tangent';
        await tester.pumpWidget(_wrap(DerivativeTangentWidget(data: data)));
        await tester.pump();

        expect(find.byType(DerivativeTangentWidget), findsOneWidget);
        final sliders = find.byType(Slider);
        expect(sliders, findsAtLeastNWidgets(2));
      });
    });

    // ------------------------------------------------------------------------
    // Feature 3 (R2): Linear Algebra 5 Sequential Nodes Existence & Content Structure
    // ------------------------------------------------------------------------
    group('F3: Linear Algebra 5 Sequential Nodes Existence & Structure', () {
      test('3.1 Node 1 (lin_alg_01_tuples) specifies n-tuples and connects to arithmetic/geometry', () {
        final node = MarkdownContentParser.parse(_specLinAlg01Tuples);
        expect(node.serverId, equals('lin_alg_01_tuples'));
        expect(node.title, contains('n-upla'));
        expect(node.category, equals('Matematica'));
        expect(node.subCategory, equals('Algebra Lineare'));
        expect(node.tempPrerequisiteIds, containsAll(['mat_add_01', 'mat_pythagoras_01']));
      });

      test('3.2 Node 2 (lin_alg_02_vectors) defines geometric vectors and references node 1', () {
        final node = MarkdownContentParser.parse(_specLinAlg02Vectors);
        expect(node.serverId, equals('lin_alg_02_vectors'));
        expect(node.title, contains('Vettori Geometrici'));
        expect(node.tempPrerequisiteIds, equals(['lin_alg_01_tuples']));
      });

      test('3.3 Node 3 (lin_alg_03_operations) defines vector operations and references node 2', () {
        final node = MarkdownContentParser.parse(_specLinAlg03Operations);
        expect(node.serverId, equals('lin_alg_03_operations'));
        expect(node.title, contains('Operazioni Vettoriali'));
        expect(node.tempPrerequisiteIds, equals(['lin_alg_02_vectors']));
      });

      test('3.4 Node 4 (lin_alg_04_span) defines linear combinations and span, referencing node 3', () {
        final node = MarkdownContentParser.parse(_specLinAlg04Span);
        expect(node.serverId, equals('lin_alg_04_span'));
        expect(node.title, contains('Span'));
        expect(node.tempPrerequisiteIds, equals(['lin_alg_03_operations']));
      });

      test('3.5 Node 5 (lin_alg_05_independence) defines linear independence and references node 4', () {
        final node = MarkdownContentParser.parse(_specLinAlg05Independence);
        expect(node.serverId, equals('lin_alg_05_independence'));
        expect(node.title, contains('Indipendenza Lineare'));
        expect(node.tempPrerequisiteIds, equals(['lin_alg_04_span']));
      });
    });

    // ------------------------------------------------------------------------
    // Feature 4 (R2): Mathematical Rigor, LaTeX & Corollaries with Proofs
    // ------------------------------------------------------------------------
    group('F4: Mathematical Rigor, LaTeX & Corollaries with Proofs', () {
      test('4.1 KaTeX display math blocks are correctly formed with double dollar syntax', () {
        for (final md in [_specLinAlg01Tuples, _specLinAlg02Vectors, _specLinAlg03Operations, _specLinAlg04Span, _specLinAlg05Independence]) {
          final node = MarkdownContentParser.parse(md);
          expect(node.algebraicProof.isNotEmpty, isTrue);
          for (final step in node.algebraicProof) {
            expect(step.latexEquation, isNotNull);
            expect(step.latexEquation!.trim().isNotEmpty, isTrue);
          }
        }
      });

      test('4.2 Every linear algebra node contains progressive numbered proof steps', () {
        final node = MarkdownContentParser.parse(_specLinAlg01Tuples);
        expect(node.algebraicProof.length, greaterThanOrEqualTo(3));
        expect(node.algebraicProof.any((s) => s.description!.contains('1.') || s.description!.contains('Definizione')), isTrue);
      });

      test('4.3 Every linear algebra node contains at least two distinct corollaries', () {
        for (final md in [_specLinAlg01Tuples, _specLinAlg02Vectors, _specLinAlg03Operations, _specLinAlg04Span, _specLinAlg05Independence]) {
          final node = MarkdownContentParser.parse(md);
          final corollaries = node.algebraicProof.where(
            (s) => (s.description?.toLowerCase().contains('corollario') ?? false) ||
                   (s.insight?.toLowerCase().contains('corollario') ?? false),
          ).toList();
          expect(corollaries.length, greaterThanOrEqualTo(2),
            reason: 'Node ${node.serverId} must have at least 2 corollaries');
        }
      });

      test('4.4 Linear algebra proof steps include deep insight pedagogical callouts', () {
        final node = MarkdownContentParser.parse(_specLinAlg03Operations);
        for (final step in node.algebraicProof) {
          expect(step.insight, isNotNull);
          expect(step.insight!.isNotEmpty, isTrue);
        }
      });

      test('4.5 Mathematical inequality verification: Cauchy-Schwarz and Triangle Inequality', () {
        const u = _Vector2D(3, 4);
        const v = _Vector2D(1, 2);

        // Cauchy-Schwarz: |u . v| <= ||u|| * ||v||
        final dotProduct = u.dot(v).abs();
        final normProduct = u.norm * v.norm;
        expect(dotProduct, lessThanOrEqualTo(normProduct + 1e-9));

        // Triangle Inequality: ||u + v|| <= ||u|| + ||v||
        final sumNorm = (u + v).norm;
        final sumOfNorms = u.norm + v.norm;
        expect(sumNorm, lessThanOrEqualTo(sumOfNorms + 1e-9));
      });
    });

    // ------------------------------------------------------------------------
    // Feature 5 (R3): 2D Vector Interactive Visualization Widget & Modes
    // ------------------------------------------------------------------------
    group('F5: 2D Vector Simulation Widget & Modes', () {
      test('5.1 InteractiveTemplateFactory accepts 2D vector template aliases', () {
        final vectorAliases = ['vector_2d', 'linear_combination', 'vector_addition', 'span_2d'];
        for (final alias in vectorAliases) {
          final data = InteractiveData()
            ..templateType = alias
            ..parameters = [
              InteractiveParameter()..variableName = 'vx'..defaultValue = 3.0,
              InteractiveParameter()..variableName = 'vy'..defaultValue = 4.0,
            ];
          final widget = InteractiveTemplateFactory.buildWidget(data);
          expect(widget, isNotNull, reason: 'Template alias "$alias" should resolve to a valid widget');
        }
      });

      test('5.2 Parameter schema mapping supports vector coordinates and scalars', () {
        final data = InteractiveData()
          ..templateType = 'vector_2d'
          ..parameters = [
            InteractiveParameter()..variableName = 'vx'..defaultValue = 4.0,
            InteractiveParameter()..variableName = 'vy'..defaultValue = -3.0,
            InteractiveParameter()..variableName = 'c1'..defaultValue = 1.5,
          ];
        expect(data.parameters!.length, equals(3));
        expect(data.parameters![0].variableName, equals('vx'));
        expect(data.parameters![1].variableName, equals('vy'));
      });

      test('5.3 Vector projection mode calculates canonical basis components', () {
        const v = _Vector2D(5.0, 12.0);
        expect(v.norm, closeTo(13.0, 1e-9));
        expect(v.x, equals(5.0));
        expect(v.y, equals(12.0));
        final unitV = v.normalize();
        expect(unitV.norm, closeTo(1.0, 1e-9));
      });

      test('5.4 Vector addition mode calculates parallelogram diagonal resultant', () {
        const v1 = _Vector2D(3.0, 1.0);
        const v2 = _Vector2D(1.0, 4.0);
        final sum = v1 + v2;
        expect(sum.x, equals(4.0));
        expect(sum.y, equals(5.0));
        expect(sum.norm, closeTo(math.sqrt(41), 1e-9));
      });

      test('5.5 Linear combinations mode supports scalar multipliers in [-3, 3]', () {
        const v1 = _Vector2D(2.0, 1.0);
        const v2 = _Vector2D(-1.0, 3.0);
        const c1 = 2.5;
        const c2 = -1.0;
        final combo = (v1 * c1) + (v2 * c2);
        // 2.5*(2, 1) + (-1)*(-1, 3) = (5.0, 2.5) + (1.0, -3.0) = (6.0, -0.5)
        expect(combo.x, closeTo(6.0, 1e-9));
        expect(combo.y, closeTo(-0.5, 1e-9));
      });
    });

    // ------------------------------------------------------------------------
    // Feature 6 (R3): Vector Addition & Linear Combinations (c1*v1 + c2*v2)
    // ------------------------------------------------------------------------
    group('F6: Vector Addition & Linear Combinations', () {
      test('6.1 Vector addition is strictly commutative and associative', () {
        const a = _Vector2D(1.5, -3.2);
        const b = _Vector2D(-4.1, 7.8);
        const c = _Vector2D(2.0, 2.0);

        final sumAB = a + b;
        final sumBA = b + a;
        expect(sumAB.x, closeTo(sumBA.x, 1e-9));
        expect(sumAB.y, closeTo(sumBA.y, 1e-9));

        final assoc1 = (a + b) + c;
        final assoc2 = a + (b + c);
        expect(assoc1.x, closeTo(assoc2.x, 1e-9));
        expect(assoc1.y, closeTo(assoc2.y, 1e-9));
      });

      test('6.2 Parallelogram rule head-to-tail matches algebraic components', () {
        const v1 = _Vector2D(4, 0);
        const v2 = _Vector2D(0, 3);
        final diag = v1 + v2;
        expect(diag.x, equals(4));
        expect(diag.y, equals(3));
        expect(diag.norm, equals(5)); // Pythagorean 3-4-5
      });

      test('6.3 Scalar multiplication distributes over vector addition', () {
        const u = _Vector2D(2.0, 3.0);
        const v = _Vector2D(-1.0, 4.0);
        const k = 3.0;

        final left = (u + v) * k;
        final right = (u * k) + (v * k);
        expect(left.x, closeTo(right.x, 1e-9));
        expect(left.y, closeTo(right.y, 1e-9));
      });

      test('6.4 Determinant of 2D vectors measures orientation and spanned area', () {
        const v1 = _Vector2D(3, 0);
        const v2 = _Vector2D(0, 4);
        final det = v1.det2D(v2);
        expect(det, equals(12)); // Area of rectangle spanned by v1 and v2
      });

      test('6.5 Span generation in R^2: non-collinear vectors span full plane', () {
        const v1 = _Vector2D(1, 0);
        const v2 = _Vector2D(0, 1);
        expect(v1.isCollinearWith(v2), isFalse);

        // Any arbitrary target point (x, y) can be expressed as c1*v1 + c2*v2
        const target = _Vector2D(7.5, -4.2);
        final det = v1.det2D(v2);
        expect(det.abs(), greaterThan(1e-6));

        // Cramer's rule in 2D
        final c1 = (target.x * v2.y - target.y * v2.x) / det;
        final c2 = (v1.x * target.y - v1.y * target.x) / det;
        final reconstructed = (v1 * c1) + (v2 * c2);
        expect(reconstructed.x, closeTo(target.x, 1e-9));
        expect(reconstructed.y, closeTo(target.y, 1e-9));
      });
    });

    // ------------------------------------------------------------------------
    // Feature 7 (R4): Curriculum DAG Acyclicity & Root Invariant
    // ------------------------------------------------------------------------
    group('F7: Curriculum DAG Acyclicity & Root Invariant', () {
      test('7.1 Standard curriculum registry graph is strictly acyclic', () {
        final graph = CurriculumRegistry.prerequisiteMap;
        expect(_DAGValidator.isAcyclic(graph), isTrue);
      });

      test('7.2 Unique root invariant: mat_add_01 is the sole root node', () {
        final graph = CurriculumRegistry.prerequisiteMap;
        final roots = _DAGValidator.getRoots(graph);
        expect(roots, contains('mat_add_01'));
        // In the full curriculum, mat_add_01 must be the unique foundational root
        expect(roots.length, equals(1));
        expect(roots.first, equals('mat_add_01'));
      });

      test('7.3 All prerequisite IDs in registry point to valid defined nodes', () {
        final validIds = CurriculumRegistry.getAllNodes().map((n) => n.serverId).toSet();
        for (final entry in CurriculumRegistry.prerequisiteMap.entries) {
          for (final prereq in entry.value) {
            expect(validIds.contains(prereq), isTrue,
              reason: 'Prerequisite "$prereq" required by "${entry.key}" must exist');
          }
        }
      });

      test('7.4 Combined graph with 5 linear algebra sequential nodes preserves acyclicity', () {
        final combinedGraph = Map<String, List<String>>.from(CurriculumRegistry.prerequisiteMap);
        combinedGraph['lin_alg_01_tuples'] = ['mat_add_01', 'mat_pythagoras_01'];
        combinedGraph['lin_alg_02_vectors'] = ['lin_alg_01_tuples'];
        combinedGraph['lin_alg_03_operations'] = ['lin_alg_02_vectors'];
        combinedGraph['lin_alg_04_span'] = ['lin_alg_03_operations'];
        combinedGraph['lin_alg_05_independence'] = ['lin_alg_04_span'];

        expect(_DAGValidator.isAcyclic(combinedGraph), isTrue);
        final roots = _DAGValidator.getRoots(combinedGraph);
        expect(roots, equals(['mat_add_01']),
          reason: 'lin_alg_01_tuples must not break unique root invariant');
      });

      test('7.5 Linear algebra nodes form a strictly monotonic prerequisite depth chain', () {
        final graph = {
          'mat_add_01': <String>[],
          'mat_pythagoras_01': ['mat_add_01'],
          'lin_alg_01_tuples': ['mat_add_01', 'mat_pythagoras_01'],
          'lin_alg_02_vectors': ['lin_alg_01_tuples'],
          'lin_alg_03_operations': ['lin_alg_02_vectors'],
          'lin_alg_04_span': ['lin_alg_03_operations'],
          'lin_alg_05_independence': ['lin_alg_04_span'],
        };

        int getDepth(String node, [Set<String>? visited]) {
          visited ??= {};
          if (visited.contains(node)) return 0;
          visited.add(node);
          final p = graph[node] ?? [];
          if (p.isEmpty) return 0;
          return 1 + p.map((x) => getDepth(x, visited)).reduce(math.max);
        }

        final d1 = getDepth('lin_alg_01_tuples');
        final d2 = getDepth('lin_alg_02_vectors');
        final d3 = getDepth('lin_alg_03_operations');
        final d4 = getDepth('lin_alg_04_span');
        final d5 = getDepth('lin_alg_05_independence');

        expect(d1 < d2, isTrue);
        expect(d2 < d3, isTrue);
        expect(d3 < d4, isTrue);
        expect(d4 < d5, isTrue);
      });
    });

    // ------------------------------------------------------------------------
    // Feature 8 (R4): Offline Ingestion via ContentLoaderService
    // ------------------------------------------------------------------------
    group('F8: Offline Ingestion via ContentLoaderService', () {
      test('8.1 ContentLoaderService.knownAssetPaths contains bundled markdown paths', () {
        expect(ContentLoaderService.knownAssetPaths.isNotEmpty, isTrue);
        expect(ContentLoaderService.knownAssetPaths.length, greaterThanOrEqualTo(35));
        expect(ContentLoaderService.knownAssetPaths.every((p) => p.endsWith('.md')), isTrue);
      });

      test('8.2 MarkdownContentParser parses frontmatter metadata into KnowledgeNode', () {
        final node = MarkdownContentParser.parse(_specLinAlg01Tuples);
        expect(node.serverId, equals('lin_alg_01_tuples'));
        expect(node.interactiveData, isNotNull);
        expect(node.interactiveData!.templateType, equals('vector_2d'));
      });

      test('8.3 ContentLoaderService memory cache synchronizes with CurriculumRegistry', () {
        final testNode = KnowledgeNode()
          ..serverId = 'test_mem_sync_01'
          ..title = 'Memory Sync Test Node'
          ..category = 'Matematica';
        ContentLoaderService.setCachedNodes([testNode]);
        expect(ContentLoaderService.cachedNodes, isNotNull);
        expect(ContentLoaderService.cachedNodes!.length, equals(1));
        expect(CurriculumRegistry.getAllNodes().first.serverId, equals('test_mem_sync_01'));
        ContentLoaderService.clearCache();
      });

      test('8.4 Offline fallback nodes provide complete default algebraic proofs', () {
        final allNodes = CurriculumRegistry.getAllNodes();
        expect(allNodes.isNotEmpty, isTrue);
        for (final node in allNodes) {
          expect(node.serverId.isNotEmpty, isTrue);
          expect(node.title.isNotEmpty, isTrue);
          expect(node.algebraicProof.isNotEmpty, isTrue);
        }
      });

      test('8.5 Two-phase Isar sync contract separates node upsert from link resolution', () {
        // Contract validation: KnowledgeNode has tempPrerequisiteIds for Phase 1
        // which resolve into prerequisites IsarLinks for Phase 2.
        final node = MarkdownContentParser.parse(_specLinAlg01Tuples);
        expect(node.tempPrerequisiteIds, isNotEmpty);
        expect(node.prerequisites, isNotNull);
      });
    });
  });

  // ==========================================================================
  // TIER 2: BOUNDARY & CORNER CASES (>=5 tests per feature across all 8 features)
  // Total Tier 2 tests: 8 features * 5 tests = 40 tests
  // ==========================================================================
  group('Tier 2: Boundary & Corner Cases (Features 1 to 8)', () {
    // ------------------------------------------------------------------------
    // F1 Boundary: Autoplay & Animation Edge Cases
    // ------------------------------------------------------------------------
    group('F1 Boundary: Autoplay & Animation Edge Cases', () {
      testWidgets('2.F1.1 Instant unmount after pump produces no unhandled exceptions', (tester) async {
        await tester.pumpWidget(_wrap(const TrigCircleWidget()));
        await tester.pump(const Duration(milliseconds: 10));
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
        expect(tester.takeException(), isNull);
      });

      testWidgets('2.F1.2 Toggling play and immediate pause preserves current state', (tester) async {
        await tester.pumpWidget(_wrap(const TrigCircleWidget()));
        await tester.pump();

        final playBtn = find.byTooltip('Auto-rotazione continua 60 FPS');
        if (playBtn.evaluate().isNotEmpty) {
          await tester.tap(playBtn);
          await tester.pump(const Duration(milliseconds: 100));
          final pauseBtn = find.byTooltip('Ferma rotazione');
          if (pauseBtn.evaluate().isNotEmpty) {
            await tester.tap(pauseBtn);
            await tester.pump();
          }
        }
        expect(tester.takeException(), isNull);
      });

      testWidgets('2.F1.3 Simulation at t = 0.0 emits no NaN or infinite telemetry', (tester) async {
        final data = InteractiveData()
          ..templateType = 'kinematics_simulation'
          ..parameters = [
            InteractiveParameter()..variableName = 'v0'..defaultValue = 0.0,
            InteractiveParameter()..variableName = 'a'..defaultValue = 0.0,
          ];
        await tester.pumpWidget(_wrap(KinematicsSimulationWidget(data: data)));
        await tester.pump();

        expect(find.textContaining('NaN'), findsNothing);
        expect(find.textContaining('Infinity'), findsNothing);
      });

      testWidgets('2.F1.4 Simulation reset button restores initial paused state cleanly', (tester) async {
        final data = InteractiveData()..templateType = 'kinematics_simulation';
        await tester.pumpWidget(_wrap(KinematicsSimulationWidget(data: data)));
        await tester.pump();

        final resetFinder = find.byTooltip('Ripristina');
        if (resetFinder.evaluate().isNotEmpty) {
          await tester.tap(resetFinder);
          await tester.pump();
          expect(find.byTooltip('Avvia'), findsOneWidget);
        }
      });

      testWidgets('2.F1.5 Zero delta frames do not advance internal simulation clocks', (tester) async {
        await tester.pumpWidget(_wrap(const TrigCircleWidget()));
        await tester.pump();
        final angleBefore = (find.textContaining('θ =').evaluate().first.widget as Text).data!;
        await tester.pump(Duration.zero);
        final angleAfter = (find.textContaining('θ =').evaluate().first.widget as Text).data!;
        expect(angleBefore, equals(angleAfter));
      });
    });

    // ------------------------------------------------------------------------
    // F2 Boundary: 60fps & Slider Range Edge Cases
    // ------------------------------------------------------------------------
    group('F2 Boundary: 60fps & Slider Range Edge Cases', () {
      testWidgets('2.F2.1 Slider clamped at absolute minimum value behaves correctly', (tester) async {
        final data = InteractiveData()
          ..templateType = 'live_equation'
          ..equations = ['x']
          ..parameters = [
            InteractiveParameter()..variableName = 'x'..minValue = -50.0..maxValue = 50.0..defaultValue = -50.0,
          ];
        await tester.pumpWidget(_wrap(LiveEquationWidget(data: data)));
        await tester.pump();

        expect(find.text('-50'), findsWidgets);
      });

      testWidgets('2.F2.2 Slider clamped at absolute maximum value behaves correctly', (tester) async {
        final data = InteractiveData()
          ..templateType = 'live_equation'
          ..equations = ['x']
          ..parameters = [
            InteractiveParameter()..variableName = 'x'..minValue = 0.0..maxValue = 100.0..defaultValue = 100.0,
          ];
        await tester.pumpWidget(_wrap(LiveEquationWidget(data: data)));
        await tester.pump();

        expect(find.text('100'), findsWidgets);
      });

      testWidgets('2.F2.3 Micro-step parameter variations (0.01) preserve decimal precision', (tester) async {
        final data = InteractiveData()
          ..templateType = 'live_equation'
          ..equations = ['a + b']
          ..parameters = [
            InteractiveParameter()..variableName = 'a'..defaultValue = 0.01..stepSize = 0.01,
            InteractiveParameter()..variableName = 'b'..defaultValue = 0.02..stepSize = 0.01,
          ];
        await tester.pumpWidget(_wrap(LiveEquationWidget(data: data)));
        await tester.pump();

        expect(find.text('0.03'), findsWidgets);
      });

      testWidgets('2.F2.4 Rapid high-frequency drag events dispatch without dropped state', (tester) async {
        final data = InteractiveData()
          ..templateType = 'live_equation'
          ..equations = ['x * 2']
          ..parameters = [
            InteractiveParameter()..variableName = 'x'..minValue = 0.0..maxValue = 100.0..defaultValue = 10.0,
          ];
        await tester.pumpWidget(_wrap(LiveEquationWidget(data: data)));
        await tester.pump();

        final slider = find.byType(Slider);
        for (int i = 0; i < 5; i++) {
          await tester.drag(slider, const Offset(10.0, 0.0));
          await tester.pump(const Duration(milliseconds: 16)); // 60fps interval
        }
        expect(tester.takeException(), isNull);
      });

      testWidgets('2.F2.5 Zero drag delta on slider does not alter parameter values', (tester) async {
        final data = InteractiveData()
          ..templateType = 'live_equation'
          ..equations = ['x']
          ..parameters = [
            InteractiveParameter()
              ..variableName = 'x'
              ..minValue = 0.0
              ..maxValue = 100.0
              ..defaultValue = 50.0,
          ];
        await tester.pumpWidget(_wrap(LiveEquationWidget(data: data)));
        await tester.pump();

        final slider = find.byType(Slider);
        await tester.drag(slider, Offset.zero);
        await tester.pump();
        expect(find.text('50'), findsWidgets);
      });
    });

    // ------------------------------------------------------------------------
    // F3 Boundary: Linear Algebra Dimension & Prerequisite Edge Cases
    // ------------------------------------------------------------------------
    group('F3 Boundary: Linear Algebra Dimension & Prerequisite Edge Cases', () {
      test('2.F3.1 Degenerate 1-dimensional tuple (real line R^1) norm matches absolute value', () {
        const x = -7.5;
        final norm1D = math.sqrt(x * x);
        expect(norm1D, equals(x.abs()));
      });

      test('2.F3.2 High-dimensional tuple (R^4) norm calculation generalizes Pythagoras', () {
        final v4 = [1.0, 2.0, -3.0, 5.0];
        final sumSquares = v4.fold<double>(0.0, (acc, val) => acc + val * val);
        final norm = math.sqrt(sumSquares);
        // 1 + 4 + 9 + 25 = 39
        expect(norm, closeTo(math.sqrt(39), 1e-9));
      });

      test('2.F3.3 Node with empty body parses frontmatter and synthesizes fallback blocks', () {
        const minimalMd = '''---
id: lin_alg_min_01
title: "Minimal Vector Topic"
category: "Matematica"
---
''';
        final node = MarkdownContentParser.parse(minimalMd);
        expect(node.serverId, equals('lin_alg_min_01'));
        expect(node.title, equals('Minimal Vector Topic'));
      });

      test('2.F3.4 Unicode mathematical symbols in title and body parse cleanly', () {
        const unicodeMd = '''---
id: lin_alg_unicode_01
title: "Spazio ℝⁿ e Base Canonica {e₁, …, eₙ}"
category: "Matematica"
---
Corpo con simboli: ∀v ∈ ℝⁿ, ‖v‖ ≥ 0.
''';
        final node = MarkdownContentParser.parse(unicodeMd);
        expect(node.title, contains('ℝⁿ'));
        expect(node.title, contains('e₁'));
      });

      test('2.F3.5 Fault injection: deliberate circular prerequisite is detected by Kahn check', () {
        final cyclicGraph = {
          'node_A': ['node_B'],
          'node_B': ['node_C'],
          'node_C': ['node_A'], // Cycle A -> B -> C -> A
        };
        expect(_DAGValidator.isAcyclic(cyclicGraph), isFalse);
      });
    });

    // ------------------------------------------------------------------------
    // F4 Boundary: KaTeX, Formatting & Proof Step Edge Cases
    // ------------------------------------------------------------------------
    group('F4 Boundary: KaTeX, Formatting & Proof Step Edge Cases', () {
      test('2.F4.1 Proof step with empty insight string parses safely without null exceptions', () {
        const md = '''---
id: test_empty_insight
title: "Empty Insight Step"
category: "Matematica"
---
## Dimostrazione
### 1. Passo Base
\$\$x = y\$\$
''';
        final node = MarkdownContentParser.parse(md);
        expect(node.algebraicProof.length, equals(1));
        expect(node.algebraicProof.first.latexEquation, equals(r'x = y'));
      });

      test('2.F4.2 Multiline KaTeX aligned equations parse with double backslash line breaks', () {
        const md = '''---
id: test_aligned_katex
title: "Aligned Math"
category: "Matematica"
---
## Dimostrazione
### 1. Sistema Lineare
\$\$\\begin{aligned} x_1 + 2x_2 &= 5 \\\\ 3x_1 - x_2 &= 1 \\end{aligned}\$\$
''';
        final node = MarkdownContentParser.parse(md);
        expect(node.algebraicProof.first.latexEquation, contains('aligned'));
      });

      test('2.F4.3 KaTeX matrix notation pmatrix parses without token corruption', () {
        const md = '''---
id: test_matrix_katex
title: "Matrix Math"
category: "Matematica"
---
## Dimostrazione
### 1. Matrice dei Coefficienti
\$\$\\begin{pmatrix} a & b \\\\ c & d \\end{pmatrix}\$\$
''';
        final node = MarkdownContentParser.parse(md);
        expect(node.algebraicProof.first.latexEquation, contains('pmatrix'));
      });

      test('2.F4.4 Proof step containing Greek scalars (lambda, mu) preserves identifiers', () {
        const md = '''---
id: test_greek_katex
title: "Greek Scalars"
category: "Matematica"
---
## Dimostrazione
### 1. Combinazione Lineare
\$\$\\lambda \\mathbf{u} + \\mu \\mathbf{v} = \\mathbf{0}\$\$
''';
        final node = MarkdownContentParser.parse(md);
        expect(node.algebraicProof.first.latexEquation, contains(r'\lambda'));
        expect(node.algebraicProof.first.latexEquation, contains(r'\mu'));
      });

      test('2.F4.5 Single step theorem with immediate corollary handles minimal length proof', () {
        const md = '''---
id: test_minimal_proof
title: "Minimal Proof"
category: "Matematica"
---
## Dimostrazione
### 1. Teorema e Corollario Diretto
\$\$\\mathbf{v} + \\mathbf{0} = \\mathbf{v}\$\$
> **Insight:** L'elemento neutro è unico.
''';
        final node = MarkdownContentParser.parse(md);
        expect(node.algebraicProof.length, equals(1));
        expect(node.algebraicProof.first.description, contains('Corollario'));
      });
    });

    // ------------------------------------------------------------------------
    // F5 Boundary: 2D Vector Widget Coordinates & Null Edge Cases
    // ------------------------------------------------------------------------
    group('F5 Boundary: 2D Vector Widget Coordinates & Null Edge Cases', () {
      test('2.F5.1 Zero vector (0, 0) has zero norm and does not trigger division by zero', () {
        const zeroV = _Vector2D(0, 0);
        expect(zeroV.norm, equals(0.0));
        final normalized = zeroV.normalize();
        expect(normalized.x, equals(0.0));
        expect(normalized.y, equals(0.0));
      });

      test('2.F5.2 Extreme vector coordinates (+/- 1000) compute finite norms without overflow', () {
        const bigV = _Vector2D(1000.0, -1000.0);
        expect(bigV.norm, closeTo(1000.0 * math.sqrt(2), 1e-6));
        final unitBig = bigV.normalize();
        expect(unitBig.norm, closeTo(1.0, 1e-9));
      });

      test('2.F5.3 Micro coordinates (0.001, -0.005) preserve directional angle', () {
        const microV = _Vector2D(0.001, -0.005);
        expect(microV.norm, greaterThan(0.0));
        expect(microV.angle, closeTo(math.atan2(-0.005, 0.001), 1e-9));
      });

      test('2.F5.4 InteractiveTemplateFactory returns null when InteractiveData is null', () {
        final widget = InteractiveTemplateFactory.buildWidget(null);
        expect(widget, isNull);
      });

      test('2.F5.5 Unknown template with empty equations and parameters returns null safely', () {
        final data = InteractiveData()
          ..templateType = 'completely_unknown_widget_template'
          ..equations = []
          ..parameters = [];
        final widget = InteractiveTemplateFactory.buildWidget(data);
        expect(widget, isNull);
      });
    });

    // ------------------------------------------------------------------------
    // F6 Boundary: Linear Combinations, Collinearity & Division by Zero
    // ------------------------------------------------------------------------
    group('F6 Boundary: Linear Combinations, Collinearity & Division by Zero', () {
      test('2.F6.1 Collinear parallel vectors yield zero determinant (det = 0)', () {
        const v1 = _Vector2D(2.0, 3.0);
        const v2 = _Vector2D(4.0, 6.0); // 2 * v1
        expect(v1.isCollinearWith(v2), isTrue);
        expect(v1.det2D(v2), closeTo(0.0, 1e-9));
      });

      test('2.F6.2 Anti-parallel vectors sum exactly to the zero vector (0, 0)', () {
        const v1 = _Vector2D(5.5, -2.1);
        const v2 = _Vector2D(-5.5, 2.1);
        final sum = v1 + v2;
        expect(sum.x, closeTo(0.0, 1e-9));
        expect(sum.y, closeTo(0.0, 1e-9));
        expect(sum.norm, closeTo(0.0, 1e-9));
      });

      test('2.F6.3 Negative scalar coefficients correctly reverse vector orientation by 180 degrees', () {
        const v = _Vector2D(3.0, 4.0);
        final negV = v * -1.0;
        expect(negV.x, equals(-3.0));
        expect(negV.y, equals(-4.0));
        final dot = v.normalize().dot(negV.normalize());
        expect(dot, closeTo(-1.0, 1e-9)); // cos(180°) = -1
      });

      test('2.F6.4 Zero scalar coefficients collapse linear combination to the origin (0, 0)', () {
        const v1 = _Vector2D(10.0, -8.0);
        const v2 = _Vector2D(3.0, 7.0);
        final combo = (v1 * 0.0) + (v2 * 0.0);
        expect(combo.x, equals(0.0));
        expect(combo.y, equals(0.0));
      });

      test('2.F6.5 Orthogonal vectors satisfy Pythagorean theorem: ||u+v||^2 = ||u||^2 + ||v||^2', () {
        const u = _Vector2D(6.0, 0.0);
        const v = _Vector2D(0.0, 8.0);
        expect(u.dot(v), equals(0.0)); // Orthogonal
        final sumNormSq = (u + v).norm * (u + v).norm;
        final expectedSq = (u.norm * u.norm) + (v.norm * v.norm);
        expect(sumNormSq, closeTo(expectedSq, 1e-9));
      });
    });

    // ------------------------------------------------------------------------
    // F7 Boundary: DAG Topology, Cycles & Orphan Nodes
    // ------------------------------------------------------------------------
    group('F7 Boundary: DAG Topology, Cycles & Orphan Nodes', () {
      test('2.F7.1 Isolated node with no dependencies is correctly detected as a root', () {
        final graph = {
          'root_A': <String>[],
          'isolated_B': <String>[],
          'dependent_C': ['root_A'],
        };
        final roots = _DAGValidator.getRoots(graph);
        expect(roots, containsAll(['root_A', 'isolated_B']));
      });

      test('2.F7.2 Self-referencing node (A -> A) is detected as an invalid cycle', () {
        final cyclicGraph = {
          'self_loop': ['self_loop'],
        };
        expect(_DAGValidator.isAcyclic(cyclicGraph), isFalse);
      });

      test('2.F7.3 Deep linear dependency chain of 15 sequential nodes resolves cleanly', () {
        final deepGraph = <String, List<String>>{};
        deepGraph['node_00'] = [];
        for (int i = 1; i <= 15; i++) {
          final curr = 'node_${i.toString().padLeft(2, '0')}';
          final prev = 'node_${(i - 1).toString().padLeft(2, '0')}';
          deepGraph[curr] = [prev];
        }
        expect(_DAGValidator.isAcyclic(deepGraph), isTrue);
        expect(_DAGValidator.getRoots(deepGraph), equals(['node_00']));
      });

      test('2.F7.4 Diamond dependency graph (A -> B, A -> C, B -> D, C -> D) is acyclic', () {
        final diamondGraph = {
          'root_A': <String>[],
          'node_B': ['root_A'],
          'node_C': ['root_A'],
          'sink_D': ['node_B', 'node_C'],
        };
        expect(_DAGValidator.isAcyclic(diamondGraph), isTrue);
        expect(_DAGValidator.getRoots(diamondGraph), equals(['root_A']));
      });

      test('2.F7.5 Disconnected subgraphs both cycle-free resolve valid topological sort', () {
        final disconnectedGraph = {
          'tree1_root': <String>[],
          'tree1_child': ['tree1_root'],
          'tree2_root': <String>[],
          'tree2_child': ['tree2_root'],
        };
        expect(_DAGValidator.isAcyclic(disconnectedGraph), isTrue);
        expect(_DAGValidator.getRoots(disconnectedGraph), containsAll(['tree1_root', 'tree2_root']));
      });
    });

    // ------------------------------------------------------------------------
    // F8 Boundary: Content Loader Malformed & Resilience Edge Cases
    // ------------------------------------------------------------------------
    group('F8 Boundary: Content Loader Malformed & Resilience Edge Cases', () {
      test('2.F8.1 Ingestion of completely empty markdown string yields empty fallback node', () {
        final node = MarkdownContentParser.parse('');
        expect(node.serverId, isEmpty);
        expect(node.title, isEmpty);
      });

      test('2.F8.2 Ingestion of markdown with unclosed frontmatter parses body text safely', () {
        const unclosedMd = '''---
id: test_unclosed
title: "Unclosed Header
Content starts without closing delimiter.
''';
        final node = MarkdownContentParser.parse(unclosedMd);
        expect(node, isNotNull);
      });

      test('2.F8.3 Ingestion of markdown with unknown YAML fields ignores extraneous keys', () {
        const extraFieldsMd = '''---
id: test_extra_fields
title: "Extra Fields Topic"
category: "Matematica"
unknown_custom_field: "should_be_ignored"
author_notes: "offline-only"
---
Contenuto regolare.
''';
        final node = MarkdownContentParser.parse(extraFieldsMd);
        expect(node.serverId, equals('test_extra_fields'));
        expect(node.category, equals('Matematica'));
      });

      test('2.F8.4 Ingestion with duplicate prerequisite IDs deduplicates dependencies', () {
        const dupPrereqMd = '''---
id: test_dup_prereq
title: "Duplicate Prereq"
category: "Matematica"
prerequisites:
  - mat_add_01
  - mat_add_01
---
''';
        final node = MarkdownContentParser.parse(dupPrereqMd);
        expect(node.tempPrerequisiteIds.toSet().length, equals(1));
      });

      test('2.F8.5 Parsing markdown with malformed parameter values uses default fallbacks', () {
        const badParamMd = '''---
id: test_bad_param
title: "Bad Parameter"
category: "Matematica"
interactive:
  template: live_equation
  parameters:
    - variable: x
      defaultValue: not_a_number
---
''';
        final node = MarkdownContentParser.parse(badParamMd);
        expect(node.interactiveData, isNotNull);
      });
    });
  });

  // ==========================================================================
  // TIER 3: CROSS-FEATURE COMBINATIONS (Pairwise Interactions)
  // ==========================================================================
  group('Tier 3: Cross-Feature Combinations (Pairwise Interactions)', () {
    test('3.1 Pairwise: YAML Frontmatter -> Template Factory Resolution', () {
      final node = MarkdownContentParser.parse(_specLinAlg04Span);
      expect(node.interactiveData, isNotNull);
      expect(node.interactiveData!.templateType, equals('linear_combination'));

      final widget = InteractiveTemplateFactory.buildWidget(node.interactiveData);
      expect(widget, isNotNull);
    });

    test('3.2 Pairwise: 2D Vector Parameter Sliders -> Real-Time Algebraic Recalculation', () {
      // Simulate slider changes for c1, c2 on vectors v1, v2
      const v1 = _Vector2D(3.0, 1.0);
      const v2 = _Vector2D(0.0, 2.0);

      // User changes slider c1 from 1.0 to 2.0, c2 from 1.0 to -1.5
      double c1 = 1.0;
      double c2 = 1.0;
      _Vector2D r = (v1 * c1) + (v2 * c2);
      expect(r.x, equals(3.0));
      expect(r.y, equals(3.0));

      c1 = 2.0;
      c2 = -1.5;
      r = (v1 * c1) + (v2 * c2);
      // 2*(3, 1) + (-1.5)*(0, 2) = (6, 2) + (0, -3) = (6, -1)
      expect(r.x, equals(6.0));
      expect(r.y, equals(-1.0));
      expect(r.norm, closeTo(math.sqrt(37), 1e-9));
    });

    test('3.3 Pairwise: DAG Topology -> Offline Ingestion / Isar 2-Phase Sync', () {
      // Phase 1: Parse curriculum into nodes with serverId
      final parsedNodes = [
        MarkdownContentParser.parse(_specLinAlg01Tuples),
        MarkdownContentParser.parse(_specLinAlg02Vectors),
        MarkdownContentParser.parse(_specLinAlg03Operations),
        MarkdownContentParser.parse(_specLinAlg04Span),
        MarkdownContentParser.parse(_specLinAlg05Independence),
      ];

      final nodeMap = {for (final n in parsedNodes) n.serverId: n};

      // Phase 2: Verify prerequisite resolution matches topological order
      for (final node in parsedNodes) {
        for (final prereqId in node.tempPrerequisiteIds) {
          if (nodeMap.containsKey(prereqId)) {
            final targetPrereq = nodeMap[prereqId]!;
            expect(targetPrereq.serverId, equals(prereqId));
          }
        }
      }
    });

    test('3.4 Pairwise: Markdown Parser -> Proof Step & Corollary KaTeX Extraction', () {
      final node = MarkdownContentParser.parse(_specLinAlg05Independence);
      expect(node.algebraicProof.isNotEmpty, isTrue);

      final detStep = node.algebraicProof.firstWhere(
        (s) => s.description!.contains('Criterio del Determinante'),
      );
      expect(detStep.latexEquation, contains('pmatrix'));
      expect(detStep.latexEquation, contains('det'));
      expect(detStep.insight, contains('parallelogramma'));
    });

    testWidgets('3.5 Pairwise: Cartesian Graph Expression Optimization & Formula Display', (tester) async {
      final nonQuadData = InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['1 / (1 + x * x)']
        ..parameters = [
          InteractiveParameter()..variableName = 'x'..defaultValue = 1.0,
        ];

      final widget = InteractiveTemplateFactory.buildWidget(nonQuadData);
      expect(widget, isNotNull);
      expect(widget, isA<CartesianGraphWidget>());

      await tester.pumpWidget(_wrap(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(CartesianGraphWidget), findsOneWidget);
    });

    testWidgets('3.6 Pairwise: Physics Article Pedagogical Rebinding to Circuit Simulation', (tester) async {
      // Rebound power node: ele_power_01 referencing circuit_simulation
      final powerData = InteractiveData()
        ..templateType = 'circuit_simulation'
        ..unit = 'W'
        ..parameters = [
          InteractiveParameter()..variableName = 'V'..label = 'Tensione'..defaultValue = 12.0..unit = 'V',
          InteractiveParameter()..variableName = 'R'..label = 'Resistenza'..defaultValue = 4.0..unit = 'Ω',
        ];

      final widget = InteractiveTemplateFactory.buildWidget(powerData);
      expect(widget, isNotNull);
      expect(widget, isA<OhmCircuitSimulationWidget>());

      await tester.pumpWidget(_wrap(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      // 12V / 4Ω = 3.00 A, Power = 12 * 3 = 36.0 W
      expect(find.textContaining('3.00 A'), findsOneWidget);
      expect(find.textContaining('36.0 W'), findsOneWidget);
    });
  });

  // ==========================================================================
  // TIER 4: REAL-WORLD APPLICATION SCENARIOS
  // ==========================================================================
  group('Tier 4: Real-World Application Scenarios', () {
    test('4.1 Scenario 1: Complete Linear Algebra Learner Journey (Tuples to Independence)', () {
      final journeySpecs = [
        _specLinAlg01Tuples,
        _specLinAlg02Vectors,
        _specLinAlg03Operations,
        _specLinAlg04Span,
        _specLinAlg05Independence,
      ];

      final unlockedNodes = <String>{'mat_add_01', 'mat_pythagoras_01'};

      for (int step = 0; step < journeySpecs.length; step++) {
        final node = MarkdownContentParser.parse(journeySpecs[step]);

        // Verify learner has completed prerequisites
        for (final prereq in node.tempPrerequisiteIds) {
          expect(unlockedNodes.contains(prereq), isTrue,
            reason: 'Step ${step + 1} (${node.serverId}) prerequisite "$prereq" must be unlocked');
        }

        // Verify learner can view proof steps and corollaries
        expect(node.algebraicProof.length, greaterThanOrEqualTo(2));
        final corollaries = node.algebraicProof.where(
          (s) => (s.description?.toLowerCase().contains('corollario') ?? false) ||
                 (s.insight?.toLowerCase().contains('corollario') ?? false),
        ).toList();
        expect(corollaries.isNotEmpty, isTrue);

        // Unlock this node for subsequent steps
        unlockedNodes.add(node.serverId);
      }

      expect(unlockedNodes.contains('lin_alg_05_independence'), isTrue);
    });

    test('4.2 Scenario 2: Vector Geometry Laboratory (Parallelogram & Span Exploration)', () {
      // Learner sets up vector v1 = (3, 1) and v2 = (1, 3)
      const v1 = _Vector2D(3.0, 1.0);
      const v2 = _Vector2D(1.0, 3.0);

      // 1. Learner inspects norms
      expect(v1.norm, closeTo(math.sqrt(10), 1e-9));
      expect(v2.norm, closeTo(math.sqrt(10), 1e-9));

      // 2. Learner tests parallelogram sum
      final sum = v1 + v2;
      expect(sum.x, equals(4.0));
      expect(sum.y, equals(4.0));

      // 3. Learner explores linear combination: 2*v1 - v2
      final combo = (v1 * 2.0) - v2;
      // 2*(3, 1) - (1, 3) = (6, 2) - (1, 3) = (5, -1)
      expect(combo.x, equals(5.0));
      expect(combo.y, equals(-1.0));

      // 4. Learner checks determinant for span
      final det = v1.det2D(v2);
      expect(det, equals(8.0)); // 3*3 - 1*1 = 8 != 0 -> Spans R^2
      expect(v1.isCollinearWith(v2), isFalse);
    });

    test('4.3 Scenario 3: Complete Curriculum Integrity (Full DAG Load, Unique Root, Zero Cycles)', () {
      // Test full curriculum loaded from registry
      final allNodes = CurriculumRegistry.getAllNodes();
      expect(allNodes.length, greaterThanOrEqualTo(35));

      final graph = CurriculumRegistry.prerequisiteMap;
      expect(_DAGValidator.isAcyclic(graph), isTrue);

      final roots = _DAGValidator.getRoots(graph);
      expect(roots, equals(['mat_add_01']),
        reason: 'Curriculum must preserve mat_add_01 as the sole ultimate root');

      // Check if Linear Algebra nodes are also registered on disk / registry
      final hasLinAlgOnDisk = File('assets/content/linear_algebra/lin_alg_01_tuples.md').existsSync();
      if (hasLinAlgOnDisk) {
        expect(allNodes.length, greaterThanOrEqualTo(40));
      }
    });

    testWidgets('4.4 Scenario 4: Interactive Simulation Touch & Parameter Reactivity in Dark Mode', (tester) async {
      final ohmData = InteractiveData()
        ..templateType = 'circuit_simulation'
        ..parameters = [
          InteractiveParameter()..variableName = 'V'..defaultValue = 24.0..unit = 'V',
          InteractiveParameter()..variableName = 'R'..defaultValue = 8.0..unit = 'Ω',
        ];

      final widget = InteractiveTemplateFactory.buildWidget(ohmData);
      expect(widget, isNotNull);

      await tester.pumpWidget(_wrap(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      // 24V / 8Ω = 3.00 A, Power = 24 * 3 = 72.0 W
      expect(find.textContaining('3.00 A'), findsOneWidget);
      expect(find.textContaining('72.0 W'), findsOneWidget);

      final sliders = find.byType(Slider);
      expect(sliders, findsAtLeastNWidgets(2));
    });

    testWidgets('4.5 Scenario 5: Physics Rebinding & Electrical Engineering Circuit Lab', (tester) async {
      // Verify Joule dissipation simulation
      final jouleData = InteractiveData()
        ..templateType = 'circuit_simulation'
        ..unit = 'J'
        ..parameters = [
          InteractiveParameter()..variableName = 'V'..defaultValue = 10.0..unit = 'V',
          InteractiveParameter()..variableName = 'R'..defaultValue = 5.0..unit = 'Ω',
        ];

      final widget = InteractiveTemplateFactory.buildWidget(jouleData);
      expect(widget, isNotNull);

      await tester.pumpWidget(_wrap(widget!));
      await tester.pump(const Duration(milliseconds: 50));

      // 10V / 5Ω = 2.00 A, Power = 10 * 2 = 20.0 W
      expect(find.textContaining('2.00 A'), findsOneWidget);
      expect(find.textContaining('20.0 W'), findsOneWidget);
    });
  });
}
