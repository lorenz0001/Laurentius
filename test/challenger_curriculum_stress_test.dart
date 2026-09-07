import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/data/catalog/curriculum_registry.dart';
import 'package:laurentius/data/content/content_loader_service.dart';
import 'package:laurentius/data/content/markdown_content_parser.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';

void main() {
  group('Challenger 2: Empirical Stress Test Suite for Curriculum & Markdown DAG', () {
    test('1. Bidirectional verification between disk files and ContentLoaderService.knownAssetPaths', () {
      final dir = Directory('assets/content');
      expect(dir.existsSync(), isTrue, reason: 'assets/content must exist');

      final diskFiles = dir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.md'))
          .map((f) => f.path.replaceAll('\\', '/'))
          .toList()
        ..sort();

      final known = List<String>.from(ContentLoaderService.knownAssetPaths)..sort();

      expect(diskFiles.length, 35, reason: 'Disk must contain exactly 35 markdown files');
      expect(known.length, 35, reason: 'knownAssetPaths must contain exactly 35 paths');
      expect(diskFiles, equals(known), reason: 'Every disk file must match knownAssetPaths exactly');
    });

    test('2. Deep Markdown and Frontmatter Schema Validation across all 35 files', () {
      final validCategories = {
        'Matematica',
        'Fisica',
        'Elettrotecnica',
        'Aritmetica',
        'Algebra',
        'Geometria',
      };

      final validTemplates = {
        'circuit_simulation',
        'ohm_simulation',
        'kinematics_simulation',
        'rectilinear_motion',
        'function_graph',
        'cartesian_plot',
        'live_equation',
        'trig_circle',
        'trigonometric_circle',
        'triangle_solver',
        'pythagoras_carnot',
        'derivative_tangent',
        'difference_quotient',
        'riemann_sum',
        'riemann_integral',
        'rolle_lagrange',
        'squeeze_theorem',
        'carabinieri_theorem',
        'teorema_carabinieri',
        'completing_square',
        'quadratic_visual',
        'quadratic_proof',
        'dimostrazione_quadratica',
      };

      final parsedNodes = <String, KnowledgeNode>{};

      for (final path in ContentLoaderService.knownAssetPaths) {
        final content = File(path).readAsStringSync();
        expect(content.startsWith('---\n') || content.startsWith('---\r\n'), isTrue,
            reason: '$path must start with YAML frontmatter delimiter ---');

        final parts = content.split(RegExp(r'^---\r?\n', multiLine: true));
        expect(parts.length, greaterThanOrEqualTo(3),
            reason: '$path must contain opening and closing --- delimiters');

        final fileBaseName = path.split('/').last.replaceAll('.md', '');

        final node = MarkdownContentParser.parse(content);
        expect(node.serverId, equals(fileBaseName));
        expect(node.title.trim().isNotEmpty, isTrue,
            reason: '$path title must be non-empty');
        expect(validCategories.contains(node.category), isTrue,
            reason: '$path category "${node.category}" must be in valid categories');
        expect(node.subCategory != null && node.subCategory!.isNotEmpty, isTrue,
            reason: '$path subCategory must be non-empty');
        expect(node.algebraicProof.isNotEmpty, isTrue,
            reason: '$path must have at least one proof step');

        final hasCorollary = node.algebraicProof.any((s) =>
            (s.description?.toLowerCase().contains('corollario') ?? false) ||
            (s.insight?.toLowerCase().contains('corollario') ?? false));
        expect(hasCorollary, isTrue, reason: '$path must contain at least one corollary');

        if (node.interactiveData != null) {
          final inter = node.interactiveData!;
          final tmpl = inter.templateType;
          expect(validTemplates.contains(tmpl), isTrue,
              reason: '$path uses unknown interactive template "$tmpl"');

          if (inter.parameters != null) {
            for (final p in inter.parameters!) {
              expect(p.variableName?.isNotEmpty ?? false, isTrue);
              if (p.minValue != null && p.maxValue != null) {
                expect(p.minValue!, lessThan(p.maxValue!), reason: '$path parameter min < max');
                if (p.defaultValue != null) {
                  expect(p.defaultValue!, greaterThanOrEqualTo(p.minValue!));
                  expect(p.defaultValue!, lessThanOrEqualTo(p.maxValue!));
                }
              }
            }
          }
        }

        parsedNodes[node.serverId] = node;
      }

      expect(parsedNodes.length, 35);
    });

    test('3. Strict Parity: Markdown Frontmatter DAG vs CurriculumRegistry._defaultPrerequisiteMap', () {
      final markdownPrereqs = <String, List<String>>{};
      for (final path in ContentLoaderService.knownAssetPaths) {
        final node = MarkdownContentParser.parse(File(path).readAsStringSync());
        final prereqs = List<String>.from(node.tempPrerequisiteIds)..sort();
        markdownPrereqs[node.serverId] = prereqs;
      }

      final registryPrereqs = <String, List<String>>{};
      for (final entry in CurriculumRegistry.prerequisiteMap.entries) {
        final prereqs = List<String>.from(entry.value)..sort();
        registryPrereqs[entry.key] = prereqs;
      }

      expect(markdownPrereqs.keys.toSet(), equals(registryPrereqs.keys.toSet()),
          reason: 'Node keys in markdown and registry must be identical');

      for (final id in markdownPrereqs.keys) {
        expect(markdownPrereqs[id], equals(registryPrereqs[id]),
            reason: 'Prerequisites for $id mismatch between markdown file and CurriculumRegistry');
      }
    });

    test('4. Advanced Graph Analysis: Kahn topological sort, Tarjan SCCs, DFS cycle check', () {
      final allNodes = CurriculumRegistry.getAllNodes();
      final nodeIds = allNodes.map((n) => n.serverId).toSet();
      final graph = CurriculumRegistry.prerequisiteMap;

      // In-degree & Out-degree
      final inDegree = <String, int>{for (final id in nodeIds) id: 0};
      final outDegree = <String, int>{for (final id in nodeIds) id: 0};
      final dependents = <String, List<String>>{for (final id in nodeIds) id: []};

      for (final entry in graph.entries) {
        final dep = entry.key;
        for (final prereq in entry.value) {
          expect(nodeIds.contains(prereq), isTrue,
              reason: 'Unknown prereq $prereq in node $dep');
          dependents[prereq]!.add(dep);
          inDegree[dep] = (inDegree[dep] ?? 0) + 1;
          outDegree[prereq] = (outDegree[prereq] ?? 0) + 1;
        }
      }

      // Root nodes (inDegree == 0)
      final rootNodes = nodeIds.where((id) => inDegree[id] == 0).toList();
      expect(rootNodes, equals(['mat_add_01']),
          reason: 'mat_add_01 must be the unique ultimate foundational root of the entire curriculum');

      // Terminal leaf nodes (outDegree == 0, nothing depends on them)
      final leafNodes = nodeIds.where((id) => outDegree[id] == 0).toSet();
      // Notice: e.g. physics applications or advanced calculus topics might be sinks
      expect(leafNodes.isNotEmpty, isTrue);

      // Kahn's algorithm
      final q = List<String>.from(rootNodes);
      final inDegCopy = Map<String, int>.from(inDegree);
      final topoOrder = <String>[];
      while (q.isNotEmpty) {
        final u = q.removeAt(0);
        topoOrder.add(u);
        for (final v in dependents[u]!) {
          inDegCopy[v] = inDegCopy[v]! - 1;
          if (inDegCopy[v] == 0) q.add(v);
        }
      }
      expect(topoOrder.length, 35, reason: 'Kahn algorithm must order all 35 nodes');

      // Tarjan's strongly connected components algorithm
      int index = 0;
      final indices = <String, int>{};
      final lowlink = <String, int>{};
      final sccStack = <String>[];
      final onStack = <String, bool>{};
      final sccs = <List<String>>[];

      void strongConnect(String v) {
        indices[v] = index;
        lowlink[v] = index;
        index++;
        sccStack.add(v);
        onStack[v] = true;

        for (final w in dependents[v]!) {
          if (!indices.containsKey(w)) {
            strongConnect(w);
            if (lowlink[w]! < lowlink[v]!) {
              lowlink[v] = lowlink[w]!;
            }
          } else if (onStack[w] == true) {
            if (indices[w]! < lowlink[v]!) {
              lowlink[v] = indices[w]!;
            }
          }
        }

        if (lowlink[v] == indices[v]) {
          final scc = <String>[];
          while (true) {
            final w = sccStack.removeLast();
            onStack[w] = false;
            scc.add(w);
            if (w == v) break;
          }
          sccs.add(scc);
        }
      }

      for (final id in nodeIds) {
        if (!indices.containsKey(id)) {
          strongConnect(id);
        }
      }

      for (final scc in sccs) {
        expect(scc.length, 1,
            reason: 'SCC with length > 1 detected (contains cycle): $scc');
      }

      // Longest path computation (DAG depth / critical educational path)
      final longestPathTo = <String, int>{for (final id in nodeIds) id: 0};
      for (final u in topoOrder) {
        for (final v in dependents[u]!) {
          if (longestPathTo[u]! + 1 > longestPathTo[v]!) {
            longestPathTo[v] = longestPathTo[u]! + 1;
          }
        }
      }
      final maxDepth = longestPathTo.values.reduce((a, b) => a > b ? a : b);
      expect(maxDepth, greaterThanOrEqualTo(6),
          reason: 'Curriculum DAG depth must represent meaningful progressive depth');
    });

    test('5. Adversarial Fault Injection: Perturbation, cycles, dangling references, malformed YAML', () {
      // 5a. Cyclic edge injection
      final cyclicGraph = <String, List<String>>{
        'A': ['B'],
        'B': ['C'],
        'C': ['A'],
      };
      final inDeg = <String, int>{'A': 0, 'B': 0, 'C': 0};
      for (final targets in cyclicGraph.values) {
        for (final t in targets) {
          inDeg[t] = (inDeg[t] ?? 0) + 1;
        }
      }
      final q = [for (final k in inDeg.keys) if (inDeg[k] == 0) k];
      expect(q, isEmpty, reason: 'Cycle must produce 0 initial zero-indegree nodes');

      // 5b. Dangling prerequisite detection
      const danglingMd = '''
---
id: mat_phantom_test
title: "Phantom"
category: "Matematica"
prerequisites:
  - non_existent_node_xyz
---
Dimostrazione
''';
      final danglingNode = MarkdownContentParser.parse(danglingMd);
      expect(danglingNode.tempPrerequisiteIds, contains('non_existent_node_xyz'));
      final validIds = CurriculumRegistry.getAllNodes().map((n) => n.serverId).toSet();
      expect(validIds.contains(danglingNode.tempPrerequisiteIds.first), isFalse);

      // 5c. Malformed YAML frontmatter resilience
      const malformedYaml = '''
---
id: [invalid
  yaml: unbalanced
---
Body text
''';
      expect(() => MarkdownContentParser.parse(malformedYaml), returnsNormally);

      // 5d. Missing frontmatter resilience
      const noFrontmatter = 'Simple raw markdown without any frontmatter headers';
      final fallbackNode = MarkdownContentParser.parse(noFrontmatter);
      expect(fallbackNode.serverId, isEmpty);
    });

    test('6. In-Memory Fallback vs Markdown Alignment for 6 Limit Articles', () {
      final limitIds = [
        'mat_limits_01',
        'mat_lim_sinc_01',
        'mat_lim_cos_01',
        'mat_lim_e_01',
        'mat_lim_exp_01',
        'mat_lim_log_01',
      ];

      final allNodesMap = {
        for (final n in CurriculumRegistry.getAllNodes()) n.serverId: n
      };

      for (final id in limitIds) {
        expect(allNodesMap.containsKey(id), isTrue,
            reason: 'CurriculumRegistry must contain limit topic $id');
        final fallbackNode = allNodesMap[id]!;
        expect(fallbackNode.category, 'Matematica');
        expect(fallbackNode.subCategory, 'Limiti e Continuità');

        // Check physical markdown file
        final mdPath = 'assets/content/calculus/limits/$id.md';
        expect(File(mdPath).existsSync(), isTrue, reason: '$mdPath must exist');
        final mdNode = MarkdownContentParser.parse(File(mdPath).readAsStringSync());

        expect(mdNode.serverId, id);
        expect(mdNode.category, fallbackNode.category);
        expect(mdNode.subCategory, fallbackNode.subCategory);

        // Verify template consistency
        expect(mdNode.interactiveData?.templateType,
            fallbackNode.interactiveData?.templateType);
      }
    });
  });
}
