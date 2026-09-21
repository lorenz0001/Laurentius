import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/data/catalog/curriculum_registry.dart';
import 'package:laurentius/data/content/content_loader_service.dart';
import 'package:laurentius/data/content/markdown_content_parser.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/widgets/interactive/interactive_template_factory.dart';
import 'package:laurentius/presentation/widgets/interactive/kinematics_simulation_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/live_equation_widget.dart';
import 'package:laurentius/presentation/widgets/interactive/ohm_circuit_simulation_widget.dart';

/// Specification Parser Harness pointing directly to production [MarkdownContentParser]
typedef MarkdownContentParserContract = MarkdownContentParser;

void main() {
  group('Tier 1: Feature Coverage - Markdown & Frontmatter Parsing', () {
    test('Parses complete frontmatter metadata and kinematics interactive simulation', () {
      const markdown = '''
---
id: phys_kin_01
title: "Cinematica: Moto Rettilineo e Corollario di Torricelli"
category: "Fisica"
subCategory: "Cinematica e Dinamica"
prerequisites:
  - mat_parabola_01
  - mat_deriv_rules_01
  - mat_fund_calc_01
interactive:
  template: kinematics_simulation
  unit: "m/s"
  equations:
    - "v0 + a * t"
  parameters:
    - variable: v0
      label: "Velocità Iniziale (v₀)"
      unit: "m/s"
      min: 0.0
      max: 30.0
      default: 5.0
      step: 1.0
    - variable: a
      label: "Accelerazione Costante (a)"
      unit: "m/s²"
      min: -5.0
      max: 10.0
      default: 2.0
      step: 0.5
---

### Il Moto Rettilineo Uniformemente Accelerato

Nel moto con accelerazione costante \$a\$, la velocità varia linearmente nel tempo:

\$\$x(t) = x_0 + v_0 t + \\frac{1}{2} a t^2\$\$

> **Insight:** La celebre formula di Torricelli elimina la dipendenza temporale.

## Dimostrazione Logico-Algebrica

### 1. Definizione di accelerazione costante
\$\$a = \\frac{dv}{dt} = \\text{costante} \\implies v(t) = v_0 + a t\$\$
> **Insight:** La velocità cresce in modo direttamente proporzionale al tempo trascorso.

### 2. Legge oraria per integrazione temporale
\$\$x(t) = x_0 + \\int_0^t v(t) dt = x_0 + v_0 t + \\frac{1}{2} a t^2\$\$
> **Insight:** L'area sotto la retta delle velocità genera il termine quadratico parabolico.

### 3. Corollario: Formula Senza Tempo di Torricelli
\$\$v^2 = v_0^2 + 2 a \\Delta x\$\$
> **Insight:** Collega direttamente la velocità finale allo spazio percorso.
''';

      final node = MarkdownContentParserContract.parse(markdown);

      // Metadata assertions
      expect(node.serverId, 'phys_kin_01');
      expect(
        node.title,
        'Cinematica: Moto Rettilineo e Corollario di Torricelli',
      );
      expect(node.category, 'Fisica');
      expect(node.subCategory, 'Cinematica e Dinamica');
      expect(node.tempPrerequisiteIds, [
        'mat_parabola_01',
        'mat_deriv_rules_01',
        'mat_fund_calc_01',
      ]);

      // Interactive simulation assertions
      expect(node.interactiveData, isNotNull);
      final data = node.interactiveData!;
      expect(data.templateType, 'kinematics_simulation');
      expect(data.unit, 'm/s');
      expect(data.equations, ['v0 + a * t']);
      expect(data.parameters, isNotNull);
      expect(data.parameters!.length, 2);

      final p1 = data.parameters![0];
      expect(p1.variableName, 'v0');
      expect(p1.label, 'Velocità Iniziale (v₀)');
      expect(p1.unit, 'm/s');
      expect(p1.minValue, 0.0);
      expect(p1.maxValue, 30.0);
      expect(p1.defaultValue, 5.0);
      expect(p1.stepSize, 1.0);

      final p2 = data.parameters![1];
      expect(p2.variableName, 'a');
      expect(p2.label, 'Accelerazione Costante (a)');
      expect(p2.unit, 'm/s²');
      expect(p2.minValue, -5.0);
      expect(p2.maxValue, 10.0);
      expect(p2.defaultValue, 2.0);
      expect(p2.stepSize, 0.5);

      // Content blocks assertions
      expect(node.blocks.length, 4);
      expect(node.blocks[0].type, 'text_markdown');
      expect(node.blocks[1].type, 'text_markdown');
      expect(node.blocks[2].type, 'math_latex');
      expect(node.blocks[2].content, r'x(t) = x_0 + v_0 t + \frac{1}{2} a t^2');
      expect(node.blocks[3].type, 'info_box');

      // Algebraic proof assertions
      expect(node.algebraicProof.length, 3);
      expect(
        node.algebraicProof[0].description,
        '1. Definizione di accelerazione costante',
      );
      expect(
        node.algebraicProof[0].latexEquation,
        r'a = \frac{dv}{dt} = \text{costante} \implies v(t) = v_0 + a t',
      );
      expect(
        node.algebraicProof[0].insight,
        contains('direttamente proporzionale'),
      );

      expect(
        node.algebraicProof[2].description,
        '3. Corollario: Formula Senza Tempo di Torricelli',
      );
      expect(
        node.algebraicProof[2].latexEquation,
        r'v^2 = v_0^2 + 2 a \Delta x',
      );
      expect(
        node.algebraicProof[2].description!.contains('Corollario'),
        isTrue,
      );
    });

    test(
      'Parses electrical circuit article with circuit_simulation template',
      () {
        const md = '''
---
id: ele_ohm_01
title: "Legge di Ohm e Resistenza Elettrica"
category: "Elettrotecnica"
subCategory: "Circuiti in Corrente Continua"
prerequisites:
  - mat_frac_01
interactive:
  template: circuit_simulation
  unit: "A"
  equations:
    - "V / R"
  parameters:
    - variable: V
      label: "Tensione (V)"
      unit: "V"
      min: 1.0
      max: 48.0
      default: 12.0
      step: 1.0
    - variable: R
      label: "Resistenza (R)"
      unit: "Ω"
      min: 1.0
      max: 50.0
      default: 10.0
      step: 1.0
---

## Dimostrazione Logico-Algebrica

### 1. Definizione Microscopica della Conduzione
\$\$J = \\sigma E\$\$
> **Insight:** Densità di corrente proporzionale al campo elettrico.

### 2. Corollario: Legge Macroscopica di Ohm
\$\$V = R \\cdot I\$\$
> **Insight:** Relazione lineare fondamentale tra potenziale e corrente.
''';

        final node = MarkdownContentParserContract.parse(md);
        expect(node.serverId, 'ele_ohm_01');
        expect(node.category, 'Elettrotecnica');
        expect(node.tempPrerequisiteIds, ['mat_frac_01']);
        expect(node.interactiveData?.templateType, 'circuit_simulation');
        expect(node.interactiveData?.unit, 'A');
        expect(node.interactiveData?.parameters?.length, 2);
        expect(node.interactiveData?.parameters?[0].unit, 'V');
        expect(node.interactiveData?.parameters?[1].unit, 'Ω');
        expect(
          node.algebraicProof.any((s) => s.description!.contains('Corollario')),
          isTrue,
        );
      },
    );

    test('Parses live equation article with custom Power unit (W)', () {
      const md = '''
---
id: ele_power_01
title: "Potenza Elettrica nei Circuiti"
category: "Elettrotecnica"
subCategory: "Circuiti in Corrente Continua"
prerequisites:
  - ele_ohm_01
interactive:
  template: live_equation
  unit: "W"
  equations:
    - "V * I"
  parameters:
    - variable: V
      label: "Tensione"
      unit: "V"
      min: 1.0
      max: 48.0
      default: 12.0
    - variable: I
      label: "Corrente"
      unit: "A"
      min: 0.1
      max: 10.0
      default: 2.0
---

## Dimostrazione Logico-Algebrica

### 1. Lavoro per unità di carica
\$\$L = q V\$\$

### 2. Corollario: Espressione della Potenza Istantanea
\$\$P = V \\cdot I\$\$
> **Insight:** La potenza misura il tasso temporale di conversione dell'energia elettrica in Watt (W).
''';

      final node = MarkdownContentParserContract.parse(md);
      expect(node.serverId, 'ele_power_01');
      expect(node.interactiveData?.templateType, 'live_equation');
      expect(node.interactiveData?.unit, 'W');
      expect(node.interactiveData?.equations, ['V * I']);
      expect(node.interactiveData?.parameters?[0].unit, 'V');
      expect(node.interactiveData?.parameters?[1].unit, 'A');
    });

    test('Parses pure math article without interactive simulation block', () {
      const md = '''
---
id: mat_deriv_rules_01
title: "Regole di Derivazione: Prodotto, Quoziente e Catena"
category: "Matematica"
subCategory: "Calcolo Differenziale"
prerequisites:
  - mat_deriv_def_01
  - mat_binom_01
---

La derivata del prodotto si sviluppa aggiungendo e sottraendo un termine misto:

\$\$(f \\cdot g)' = f'g + fg'\$\$

## Dimostrazione Logico-Algebrica

### 1. Definizione tramite limite del rapporto incrementale
\$\$\\lim_{h \\to 0} \\frac{f(x+h)g(x+h) - f(x)g(x)}{h}\$\$

### 2. Corollario: Regola di Leibniz per il Prodotto
\$\$(fg)' = f'g + fg'\$\$
> **Insight:** Non è il semplice prodotto delle derivate, ma una somma ponderata.
''';

      final node = MarkdownContentParserContract.parse(md);
      expect(node.serverId, 'mat_deriv_rules_01');
      expect(node.interactiveData, isNull);
      expect(node.blocks.length, 2);
      expect(node.algebraicProof.length, 2);
    });
  });

  group('Tier 2: Boundary & Corner Cases in Markdown Parsing', () {
    test('Handles missing subCategory and empty prerequisites gracefully', () {
      const md = '''
---
id: mat_add_01
title: "Addizione e Struttura Algebrica"
category: "Matematica"
prerequisites: []
---

## Dimostrazione Logico-Algebrica

### 1. Definizione assiomatica di Peano
\$\$a + 0 = a\$\$

### 2. Corollario: Esistenza dell'Elemento Neutro
\$\$a + (-a) = 0\$\$
''';

      final node = MarkdownContentParserContract.parse(md);
      expect(node.serverId, 'mat_add_01');
      expect(node.subCategory, isNull);
      expect(node.tempPrerequisiteIds, isEmpty);
      expect(node.algebraicProof.length, 2);
    });

    test('Handles empty and whitespace-only markdown without crashing', () {
      final node = MarkdownContentParserContract.parse('   \n\t   ');
      expect(node.serverId, isEmpty);
      expect(node.title, isEmpty);
      expect(node.blocks, isEmpty);
      expect(node.algebraicProof, isEmpty);
    });

    test('Correctly parses multi-demonstration sections with named groups and corollaries', () {
      const md = r'''
---
id: test_multi_demo_01
title: "Multi-Demo Test"
category: "Matematica"
subCategory: "Test"
---

Corpo teorico introduttivo.

## Dimostrazione: Formule di Addizione
### 1. Primo passaggio addizione
$$x + y = z$$
> **Insight:** Spiegazione addizione.

### 2. Corollario: Proprietà Additiva
$$z - y = x$$

## Dimostrazione: Formule di Bisezione
### 1. Primo passaggio bisezione
$$\sin(\alpha / 2) = \sqrt{(1-\cos\alpha)/2}$$
> **Intuizione:** Spiegazione bisezione.

### 2. Corollario: Segno della Bisezione
$$\text{Segno da } \alpha/2$$
''';

      final node = MarkdownContentParserContract.parse(md);
      expect(node.algebraicProof.length, 4);
      expect(node.algebraicProof[0].description, '[Formule di Addizione] 1. Primo passaggio addizione');
      expect(node.algebraicProof[1].description, '[Formule di Addizione] 2. Corollario: Proprietà Additiva');
      expect(node.algebraicProof[2].description, '[Formule di Bisezione] 1. Primo passaggio bisezione');
      expect(node.algebraicProof[3].description, '[Formule di Bisezione] 2. Corollario: Segno della Bisezione');
    });

    test('Preserves complex LaTeX formatting and Greek symbols accurately', () {
      const md = r'''
---
id: mat_trig_circ_01
title: "Circonferenza Goniometrica"
category: "Matematica"
---

$$\sin^2(\theta) + \cos^2(\theta) = 1 \quad \forall \theta \in [0, 2\pi)$$

## Dimostrazione Logico-Algebrica

### 1. Applicazione del Teorema di Pitagora nel triangolo rettangolo
$$x^2 + y^2 = r^2 \implies \cos^2\theta + \sin^2\theta = 1$$
> **Insight:** Valido in ogni quadrante per la definizione di coordinate cartesiane del raggio unitario.

### 2. Corollario: Relazione Fondamentale della Goniometria
$$\tan\theta = \frac{\sin\theta}{\cos\theta} \quad (\theta \neq \frac{\pi}{2} + k\pi)$$
''';

      final node = MarkdownContentParserContract.parse(md);
      expect(
        node.blocks.first.content,
        contains(r'\sin^2(\theta) + \cos^2(\theta) = 1'),
      );
      expect(
        node.blocks.first.content,
        contains(r'\forall \theta \in [0, 2\pi)'),
      );
      expect(
        node.algebraicProof[1].latexEquation,
        contains(r'\tan\theta = \frac{\sin\theta}{\cos\theta}'),
      );
    });

    test('Handles frontmatter with missing closing delimiter gracefully', () {
      const md = '''
---
id: mat_broken_01
title: "Unclosed Delimiter Node"
category: "Matematica"

Questo contenuto non ha il delimitatore di chiusura ---
''';

      final node = MarkdownContentParserContract.parse(md);
      // Parser does not throw unhandled exception
      expect(node, isA<KnowledgeNode>());
    });

    test('Correctly parses slider parameters with missing optional fields', () {
      const md = '''
---
id: test_param_01
title: "Param Test"
category: "Test"
interactive:
  template: live_equation
  parameters:
    - variable: x
      min: 0.0
      max: 10.0
      default: 5.0
---
''';

      final node = MarkdownContentParserContract.parse(md);
      final param = node.interactiveData?.parameters?.first;
      expect(param, isNotNull);
      expect(param!.variableName, 'x');
      expect(param.minValue, 0.0);
      expect(param.maxValue, 10.0);
      expect(param.defaultValue, 5.0);
      expect(param.stepSize, isNull);
      expect(param.unit, isNull);
    });
  });

  group(
    'Tier 3: Cross-Feature Integration - Parser to TemplateFactory Linking',
    () {
      test('Parsed frontmatter kinematics specification directly builds KinematicsSimulationWidget', () {
        const md = '''
---
id: phys_kin_01
title: "Cinematica"
category: "Fisica"
interactive:
  template: kinematics_simulation
  equations:
    - "v0 + a * t"
  parameters:
    - variable: v0
      defaultValue: 5.0
    - variable: a
      defaultValue: 2.0
---
''';

        final node = MarkdownContentParserContract.parse(md);
        final widget = InteractiveTemplateFactory.buildWidget(
          node.interactiveData,
        );
        expect(widget, isNotNull);
        expect(widget, isA<KinematicsSimulationWidget>());
      });

      test('Parsed frontmatter circuit specification directly builds OhmCircuitSimulationWidget', () {
        const md = '''
---
id: ele_ohm_01
title: "Circuito Ohm"
category: "Elettrotecnica"
interactive:
  template: circuit_simulation
  parameters:
    - variable: V
      defaultValue: 12.0
    - variable: R
      defaultValue: 10.0
---
''';

        final node = MarkdownContentParserContract.parse(md);
        final widget = InteractiveTemplateFactory.buildWidget(
          node.interactiveData,
        );
        expect(widget, isNotNull);
        expect(widget, isA<OhmCircuitSimulationWidget>());
      });

      test('Parsed frontmatter live equation specification builds LiveEquationWidget', () {
        const md = '''
---
id: ele_power_01
title: "Potenza"
category: "Elettrotecnica"
interactive:
  template: live_equation
  unit: "W"
  equations:
    - "V * I"
  parameters:
    - variable: V
      defaultValue: 12.0
    - variable: I
      defaultValue: 2.0
---
''';

        final node = MarkdownContentParserContract.parse(md);
        final widget = InteractiveTemplateFactory.buildWidget(
          node.interactiveData,
        );
        expect(widget, isNotNull);
        expect(widget, isA<LiveEquationWidget>());
      });

      test('KnowledgeNode synthesized effectiveBlocks mirrors proof steps when blocks are empty', () {
        const md = '''
---
id: mat_fallback_01
title: "Proof Only Node"
category: "Matematica"
---

## Dimostrazione Logico-Algebrica

### 1. Proprietà riflessiva
\$\$a = a\$\$
> **Insight:** Ogni elemento coincide con se stesso.

### 2. Corollario: Simmetria
\$\$a = b \\implies b = a\$\$
''';

        final node = MarkdownContentParserContract.parse(md);
        expect(node.blocks, isEmpty);
        expect(node.algebraicProof.length, 2);

        final effective = node.effectiveBlocks;
        expect(effective.isNotEmpty, isTrue);
        expect(effective.any((b) => b.type == 'text_markdown'), isTrue);
        expect(effective.any((b) => b.type == 'math_latex'), isTrue);
        expect(effective.any((b) => b.type == 'info_box'), isTrue);
      });
    },
  );

  group('Tier 4: Real-World & Topological Curriculum Integrity (All 40 Topics)', () {
    test('Curriculum contains exactly 40 topics with valid unique serverIds and categories', () {
      final allNodes = CurriculumRegistry.getAllNodes();
      expect(
        allNodes.length,
        40,
        reason: 'Curriculum must contain exactly 40 knowledge topics',
      );

      final ids = <String>{};
      final categories = <String>{};
      final subCategories = <String>{};

      for (final node in allNodes) {
        expect(
          node.serverId.trim().isNotEmpty,
          isTrue,
          reason: 'Node must have valid non-empty serverId',
        );
        expect(
          ids.contains(node.serverId),
          isFalse,
          reason: 'Duplicate serverId found: ${node.serverId}',
        );
        ids.add(node.serverId);

        expect(
          node.title.trim().isNotEmpty,
          isTrue,
          reason: 'Node ${node.serverId} must have non-empty title',
        );
        expect(
          node.category.trim().isNotEmpty,
          isTrue,
          reason: 'Node ${node.serverId} must have non-empty category',
        );
        expect(
          node.subCategory != null && node.subCategory!.trim().isNotEmpty,
          isTrue,
          reason: 'Node ${node.serverId} must have non-empty subCategory',
        );

        categories.add(node.category);
        subCategories.add(node.subCategory!);
      }

      // Ensure full multidisciplinary STEM coverage
      expect(categories.contains('Matematica'), isTrue);
      expect(categories.contains('Fisica'), isTrue);
      expect(categories.contains('Elettrotecnica'), isTrue);

      expect(subCategories.length, greaterThanOrEqualTo(6));
    });

    test('Every single one of the 35 topics defines at least one identifiable Corollary step', () {
      final allNodes = CurriculumRegistry.getAllNodes();

      for (final node in allNodes) {
        expect(
          node.algebraicProof.isNotEmpty,
          isTrue,
          reason: 'Node ${node.serverId} must have a non-empty algebraic proof',
        );

        final hasCorollary = node.algebraicProof.any((step) {
          final desc = step.description?.toLowerCase() ?? '';
          final insight = step.insight?.toLowerCase() ?? '';
          return desc.contains('corollario') || insight.contains('corollario');
        });

        expect(
          hasCorollary,
          isTrue,
          reason:
              'Node ${node.serverId} ("${node.title}") must contain at least one corollary step',
        );
      }
    });

    test('Prerequisite graph over all 35 topics is strictly acyclic (Topological Sort / DAG)', () {
      final allNodes = CurriculumRegistry.getAllNodes();
      final nodeIds = allNodes.map((n) => n.serverId).toSet();
      final graph = CurriculumRegistry.prerequisiteMap;

      // In-degree computation: inDegree[v] = number of direct prerequisites of v
      final inDegree = <String, int>{for (final id in nodeIds) id: 0};
      // Adjacency list: prereq -> list of dependent topics that require it
      final dependents = <String, List<String>>{
        for (final id in nodeIds) id: [],
      };

      for (final entry in graph.entries) {
        final dependent = entry.key;
        final prereqs = entry.value;

        expect(
          nodeIds.contains(dependent),
          isTrue,
          reason: 'Prerequisite map contains unknown node key: $dependent',
        );

        for (final prereq in prereqs) {
          expect(
            nodeIds.contains(prereq),
            isTrue,
            reason:
                'Node $dependent references non-existent prerequisite: $prereq',
          );
          expect(
            prereq,
            isNot(equals(dependent)),
            reason: 'Self-referential dependency detected in node $dependent',
          );

          dependents[prereq]!.add(dependent);
          inDegree[dependent] = (inDegree[dependent] ?? 0) + 1;
        }
      }

      // Kahn's Algorithm for Topological Sorting & Cycle Detection
      final queue = <String>[];
      for (final entry in inDegree.entries) {
        if (entry.value == 0) {
          queue.add(entry.key);
        }
      }

      // Foundation verification: root nodes must exist
      expect(
        queue.isNotEmpty,
        isTrue,
        reason: 'Curriculum DAG must have at least one root foundational node',
      );
      expect(
        queue.contains('mat_add_01'),
        isTrue,
        reason: 'Addition (mat_add_01) must be a root foundational topic with 0 prerequisites',
      );

      final topologicalOrder = <String>[];
      while (queue.isNotEmpty) {
        final current = queue.removeAt(0);
        topologicalOrder.add(current);

        for (final dep in dependents[current]!) {
          inDegree[dep] = inDegree[dep]! - 1;
          if (inDegree[dep] == 0) {
            queue.add(dep);
          }
        }
      }

      // Acyclicity Assertion: all 40 nodes must be topologically ordered
      expect(
        topologicalOrder.length,
        40,
        reason:
            'Prerequisite graph contains a cycle! Topologically ordered only ${topologicalOrder.length} of 40 nodes',
      );

      // Verify that advanced topics appear after their foundational dependencies
      final indexMap = {
        for (int i = 0; i < topologicalOrder.length; i++)
          topologicalOrder[i]: i,
      };
      expect(indexMap['mat_add_01']!, lessThan(indexMap['mat_mul_01']!));
      expect(indexMap['mat_mul_01']!, lessThan(indexMap['mat_frac_01']!));
      expect(indexMap['mat_frac_01']!, lessThan(indexMap['ele_ohm_01']!));
      expect(indexMap['mat_pow_01']!, lessThan(indexMap['chem_ph_01']!));
      expect(indexMap['mat_fund_calc_01']!, lessThan(indexMap['phys_kin_01']!));
    });

    test('Adversarial cycle detection catches and rejects circular prerequisite loops', () {
      // Create a test synthetic graph with an intentional cycle: A -> B -> C -> A
      final testNodes = {'A', 'B', 'C'};
      final cyclicPrereqs = {
        'A': ['C'],
        'B': ['A'],
        'C': ['B'],
      };

      final inDegree = <String, int>{for (final id in testNodes) id: 0};
      final dependents = <String, List<String>>{
        for (final id in testNodes) id: [],
      };

      for (final entry in cyclicPrereqs.entries) {
        final dep = entry.key;
        for (final p in entry.value) {
          dependents[p]!.add(dep);
          inDegree[dep] = inDegree[dep]! + 1;
        }
      }

      final queue = [
        for (final id in testNodes)
          if (inDegree[id] == 0) id,
      ];
      final visited = <String>[];
      while (queue.isNotEmpty) {
        final cur = queue.removeAt(0);
        visited.add(cur);
        for (final nxt in dependents[cur]!) {
          inDegree[nxt] = inDegree[nxt]! - 1;
          if (inDegree[nxt] == 0) queue.add(nxt);
        }
      }

      // Cycle detected: queue was empty from start, 0 nodes sorted
      expect(visited.length, lessThan(testNodes.length));
    });
  });

  group('ContentLoaderService & Physical Markdown Files Ingestion', () {
    test('All 35 physical Markdown files exist on disk and parse successfully', () {
      final loadedNodes = <KnowledgeNode>[];
      for (final assetPath in ContentLoaderService.knownAssetPaths) {
        final file = File(assetPath);
        expect(
          file.existsSync(),
          isTrue,
          reason: 'File must exist at $assetPath',
        );
        final content = file.readAsStringSync();
        expect(
          content.trim().isNotEmpty,
          isTrue,
          reason: '$assetPath must not be empty',
        );
        final node = MarkdownContentParser.parse(content);
        expect(
          node.serverId.isNotEmpty,
          isTrue,
          reason: 'Parsed node from $assetPath must have serverId',
        );
        expect(
          node.title.isNotEmpty,
          isTrue,
          reason: 'Parsed node from $assetPath must have title',
        );
        expect(
          node.category.isNotEmpty,
          isTrue,
          reason: 'Parsed node from $assetPath must have category',
        );
        expect(
          node.subCategory != null && node.subCategory!.isNotEmpty,
          isTrue,
          reason: 'Parsed node from $assetPath must have subCategory',
        );
        expect(
          node.algebraicProof.isNotEmpty,
          isTrue,
          reason: 'Parsed node from $assetPath must have algebraicProof',
        );
        final hasCorollary = node.algebraicProof.any(
          (s) =>
              (s.description?.toLowerCase().contains('corollario') ?? false) ||
              (s.insight?.toLowerCase().contains('corollario') ?? false),
        );
        expect(
          hasCorollary,
          isTrue,
          reason: 'Parsed node from $assetPath must contain a corollary step',
        );
        loadedNodes.add(node);
      }

      expect(loadedNodes.length, 40);

      // Verify serverId uniqueness
      final idSet = loadedNodes.map((n) => n.serverId).toSet();
      expect(idSet.length, 40);

      // Verify DAG acyclicity over the loaded Markdown files
      final inDegree = <String, int>{for (final id in idSet) id: 0};
      final dependents = <String, List<String>>{for (final id in idSet) id: []};

      for (final node in loadedNodes) {
        for (final prereq in node.tempPrerequisiteIds) {
          expect(
            idSet.contains(prereq),
            isTrue,
            reason:
                'Prerequisite $prereq of node ${node.serverId} must be in idSet',
          );
          dependents[prereq]!.add(node.serverId);
          inDegree[node.serverId] = (inDegree[node.serverId] ?? 0) + 1;
        }
      }

      final queue = [
        for (final id in idSet)
          if (inDegree[id] == 0) id,
      ];
      final visited = <String>[];
      while (queue.isNotEmpty) {
        final cur = queue.removeAt(0);
        visited.add(cur);
        for (final nxt in dependents[cur]!) {
          inDegree[nxt] = inDegree[nxt]! - 1;
          if (inDegree[nxt] == 0) queue.add(nxt);
        }
      }

      expect(
        visited.length,
        40,
        reason: 'All 40 loaded Markdown articles must form an acyclic DAG',
      );
    });

    test(
      'ContentLoaderService cache hook integrates with CurriculumRegistry',
      () {
        final loadedNodes = <KnowledgeNode>[];
        for (final assetPath in ContentLoaderService.knownAssetPaths) {
          final file = File(assetPath);
          final content = file.readAsStringSync();
          loadedNodes.add(MarkdownContentParser.parse(content));
        }

        // Populate cache
        ContentLoaderService.setCachedNodes(loadedNodes);
        expect(CurriculumRegistry.getAllNodes().length, 40);
        expect(
          CurriculumRegistry.prerequisiteMap.containsKey('phys_kin_01'),
          isTrue,
        );
        expect(
          CurriculumRegistry.prerequisiteMap['phys_kin_01']!,
          contains('mat_parabola_01'),
        );

        // Clear cache and verify fallback behavior
        ContentLoaderService.clearCache();
        expect(CurriculumRegistry.getAllNodes().length, 40);
        expect(
          CurriculumRegistry.prerequisiteMap.containsKey('phys_kin_01'),
          isTrue,
        );
      },
    );

    testWidgets(
      'ContentLoaderService.loadAllFromBundle loads and parses articles from bundle',
      (tester) async {
        final nodes = await ContentLoaderService.loadAllFromBundle();
        expect(nodes.length, 40);
        expect(ContentLoaderService.cachedNodes, isNotNull);
        expect(ContentLoaderService.cachedNodes!.length, 40);
        expect(CurriculumRegistry.getAllNodes().length, 40);
      },
    );
  });
}
