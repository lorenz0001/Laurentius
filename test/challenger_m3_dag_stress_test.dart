import 'dart:io';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/data/catalog/curriculum_registry.dart';
import 'package:laurentius/data/content/content_loader_service.dart';
import 'package:laurentius/data/content/markdown_content_parser.dart';

// ============================================================================
// ADVERSARIAL GRAPH ORACLES FOR CURRICULUM TOPOLOGY
// ============================================================================

/// Result of a Kahn's topological sort run.
class KahnResult {
  final bool isAcyclic;
  final List<String> sortedOrder;
  final Map<String, int> remainingInDegrees;

  KahnResult({
    required this.isAcyclic,
    required this.sortedOrder,
    required this.remainingInDegrees,
  });
}

/// Oracles implementing graph algorithms for independent empirical verification.
class GraphTopologyOracles {
  /// Builds forward adjacency list (prerequisite -> dependents) and initial in-degrees.
  static void buildGraph(
    Set<String> nodes,
    Map<String, List<String>> prereqMap,
    Map<String, List<String>> forwardAdj,
    Map<String, int> inDegree,
  ) {
    for (final node in nodes) {
      forwardAdj[node] = [];
      inDegree[node] = 0;
    }
    for (final entry in prereqMap.entries) {
      final dependent = entry.key;
      for (final prereq in entry.value) {
        if (!nodes.contains(prereq)) continue;
        forwardAdj[prereq]!.add(dependent);
        inDegree[dependent] = (inDegree[dependent] ?? 0) + 1;
      }
    }
  }

  /// Kahn's Algorithm for Topological Sorting & Cycle Detection.
  static KahnResult runKahn(
    Set<String> nodes,
    Map<String, List<String>> prereqMap, {
    List<String> Function(List<String>)? queueOrderModifier,
  }) {
    final forwardAdj = <String, List<String>>{};
    final inDegree = <String, int>{};
    buildGraph(nodes, prereqMap, forwardAdj, inDegree);

    List<String> queue = [
      for (final id in nodes)
        if (inDegree[id] == 0) id
    ];

    if (queueOrderModifier != null) {
      queue = queueOrderModifier(queue);
    }

    final sorted = <String>[];
    while (queue.isNotEmpty) {
      final u = queue.removeAt(0);
      sorted.add(u);

      final nextEligible = <String>[];
      for (final v in forwardAdj[u]!) {
        inDegree[v] = inDegree[v]! - 1;
        if (inDegree[v] == 0) {
          nextEligible.add(v);
        }
      }

      if (queueOrderModifier != null) {
        nextEligible.sort();
      }
      queue.addAll(nextEligible);
    }

    return KahnResult(
      isAcyclic: sorted.length == nodes.length,
      sortedOrder: sorted,
      remainingInDegrees: inDegree,
    );
  }

  /// Tarjan's Strongly Connected Components (SCC) Algorithm.
  static List<List<String>> runTarjanSCC(
    Set<String> nodes,
    Map<String, List<String>> prereqMap,
  ) {
    final forwardAdj = <String, List<String>>{};
    final inDegree = <String, int>{};
    buildGraph(nodes, prereqMap, forwardAdj, inDegree);

    int index = 0;
    final indices = <String, int>{};
    final lowlink = <String, int>{};
    final stack = <String>[];
    final onStack = <String, bool>{};
    final sccs = <List<String>>[];

    void strongConnect(String u) {
      indices[u] = index;
      lowlink[u] = index;
      index++;
      stack.add(u);
      onStack[u] = true;

      for (final v in forwardAdj[u] ?? []) {
        if (!indices.containsKey(v)) {
          strongConnect(v);
          lowlink[u] = math.min(lowlink[u]!, lowlink[v]!);
        } else if (onStack[v] == true) {
          lowlink[u] = math.min(lowlink[u]!, indices[v]!);
        }
      }

      if (lowlink[u] == indices[u]) {
        final scc = <String>[];
        while (true) {
          final w = stack.removeLast();
          onStack[w] = false;
          scc.add(w);
          if (w == u) break;
        }
        sccs.add(scc);
      }
    }

    for (final node in nodes) {
      if (!indices.containsKey(node)) {
        strongConnect(node);
      }
    }

    return sccs;
  }

  /// 3-Color DFS Cycle Detector (0=White/unvisited, 1=Gray/visiting, 2=Black/visited).
  static bool hasCycleDFS(
    Set<String> nodes,
    Map<String, List<String>> prereqMap,
  ) {
    final forwardAdj = <String, List<String>>{};
    final inDegree = <String, int>{};
    buildGraph(nodes, prereqMap, forwardAdj, inDegree);

    final color = <String, int>{for (final id in nodes) id: 0};

    bool dfs(String u) {
      color[u] = 1; // Gray
      for (final v in forwardAdj[u] ?? []) {
        if (color[v] == 1) return true; // Cycle detected: back edge to gray node
        if (color[v] == 0) {
          if (dfs(v)) return true;
        }
      }
      color[u] = 2; // Black
      return false;
    }

    for (final node in nodes) {
      if (color[node] == 0) {
        if (dfs(node)) return true;
      }
    }
    return false;
  }

  /// Forward Reachability from a root node using BFS.
  static Set<String> computeForwardReachable(
    String root,
    Set<String> nodes,
    Map<String, List<String>> prereqMap,
  ) {
    final forwardAdj = <String, List<String>>{};
    final inDegree = <String, int>{};
    buildGraph(nodes, prereqMap, forwardAdj, inDegree);

    if (!nodes.contains(root)) return {};

    final visited = <String>{root};
    final queue = <String>[root];

    while (queue.isNotEmpty) {
      final curr = queue.removeAt(0);
      for (final neighbor in forwardAdj[curr] ?? []) {
        if (visited.add(neighbor)) {
          queue.add(neighbor);
        }
      }
    }
    return visited;
  }

  /// Finds all paths from source to destination.
  static List<List<String>> findAllPaths(
    String source,
    String destination,
    Set<String> nodes,
    Map<String, List<String>> prereqMap,
  ) {
    final forwardAdj = <String, List<String>>{};
    final inDegree = <String, int>{};
    buildGraph(nodes, prereqMap, forwardAdj, inDegree);

    final allPaths = <List<String>>[];

    void dfs(String current, List<String> currentPath, Set<String> visited) {
      if (current == destination) {
        allPaths.add(List.from(currentPath));
        return;
      }
      for (final next in forwardAdj[current] ?? []) {
        if (!visited.contains(next)) {
          visited.add(next);
          currentPath.add(next);
          dfs(next, currentPath, visited);
          currentPath.removeLast();
          visited.remove(next);
        }
      }
    }

    if (nodes.contains(source) && nodes.contains(destination)) {
      dfs(source, [source], {source});
    }

    return allPaths;
  }

  /// Computes the number of weakly connected components in the undirected projection.
  static List<Set<String>> computeWeaklyConnectedComponents(
    Set<String> nodes,
    Map<String, List<String>> prereqMap,
  ) {
    final undirectedAdj = <String, Set<String>>{for (final id in nodes) id: <String>{}};

    for (final entry in prereqMap.entries) {
      final dependent = entry.key;
      if (!nodes.contains(dependent)) continue;
      for (final prereq in entry.value) {
        if (!nodes.contains(prereq)) continue;
        undirectedAdj[prereq]!.add(dependent);
        undirectedAdj[dependent]!.add(prereq);
      }
    }

    final visited = <String>{};
    final components = <Set<String>>[];

    for (final node in nodes) {
      if (visited.contains(node)) continue;

      final component = <String>{node};
      final queue = <String>[node];
      visited.add(node);

      while (queue.isNotEmpty) {
        final curr = queue.removeAt(0);
        for (final neighbor in undirectedAdj[curr] ?? <String>{}) {
          if (visited.add(neighbor)) {
            component.add(neighbor);
            queue.add(neighbor);
          }
        }
      }
      components.add(component);
    }

    return components;
  }
}

// ============================================================================
// MAIN TEST SUITE: ADVERSARIAL CHALLENGER M3 CURRICULUM DAG STRESS TESTS
// ============================================================================

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Helper to load disk markdown DAG
  Map<String, List<String>> loadDiskMarkdownDAG() {
    final map = <String, List<String>>{};
    for (final path in ContentLoaderService.knownAssetPaths) {
      final file = File(path);
      expect(file.existsSync(), isTrue, reason: 'File $path must exist on disk');
      final node = MarkdownContentParser.parse(file.readAsStringSync());
      map[node.serverId] = List<String>.from(node.tempPrerequisiteIds);
    }
    return map;
  }

  group('Adversarial DAG Topology & E2E Requirements Stress Test', () {
    // ------------------------------------------------------------------------
    // SUB-OBJECTIVE 1A: Kahn's Algorithm Processes All 40 Nodes Without Cycles
    // ------------------------------------------------------------------------
    test('1A. Kahn algorithm processes all 40 nodes with zero cycles (Fallback & Disk)', () {
      // 1. Test Fallback Registry
      final fallbackNodes = CurriculumRegistry.getAllNodes().map((n) => n.serverId).toSet();
      expect(fallbackNodes.length, 40, reason: 'Fallback catalog must contain 40 nodes');

      final fallbackDAG = CurriculumRegistry.prerequisiteMap;
      final kahnFallback = GraphTopologyOracles.runKahn(fallbackNodes, fallbackDAG);

      expect(kahnFallback.isAcyclic, isTrue, reason: 'Fallback graph must be acyclic');
      expect(kahnFallback.sortedOrder.length, 40, reason: 'Kahn must sort all 40 fallback nodes');

      // Verify Kahn ordering invariant: for every edge u -> v, index(u) < index(v)
      final fallbackIndexMap = {
        for (int i = 0; i < kahnFallback.sortedOrder.length; i++)
          kahnFallback.sortedOrder[i]: i
      };
      for (final entry in fallbackDAG.entries) {
        final dependent = entry.key;
        final depIdx = fallbackIndexMap[dependent]!;
        for (final prereq in entry.value) {
          final prereqIdx = fallbackIndexMap[prereq]!;
          expect(
            prereqIdx,
            lessThan(depIdx),
            reason: 'Prerequisite $prereq (idx $prereqIdx) must precede dependent $dependent (idx $depIdx)',
          );
        }
      }

      // 2. Test Disk Markdown Files
      final diskDAG = loadDiskMarkdownDAG();
      final diskNodes = diskDAG.keys.toSet();
      expect(diskNodes.length, 40, reason: 'Disk files must define exactly 40 nodes');

      final kahnDisk = GraphTopologyOracles.runKahn(diskNodes, diskDAG);
      expect(kahnDisk.isAcyclic, isTrue, reason: 'Disk markdown graph must be acyclic');
      expect(kahnDisk.sortedOrder.length, 40, reason: 'Kahn must sort all 40 disk nodes');

      final diskIndexMap = {
        for (int i = 0; i < kahnDisk.sortedOrder.length; i++)
          kahnDisk.sortedOrder[i]: i
      };
      for (final entry in diskDAG.entries) {
        final dependent = entry.key;
        final depIdx = diskIndexMap[dependent]!;
        for (final prereq in entry.value) {
          final prereqIdx = diskIndexMap[prereq]!;
          expect(
            prereqIdx,
            lessThan(depIdx),
            reason: 'Disk Prerequisite $prereq (idx $prereqIdx) must precede dependent $dependent (idx $depIdx)',
          );
        }
      }

      // 3. Stress: Kahn permutation stability
      // Reverse queue insertion to ensure any valid tie-breaking resolves all 40 nodes
      final kahnReversed = GraphTopologyOracles.runKahn(
        diskNodes,
        diskDAG,
        queueOrderModifier: (q) => q.reversed.toList(),
      );
      expect(kahnReversed.isAcyclic, isTrue);
      expect(kahnReversed.sortedOrder.length, 40);
    });

    // ------------------------------------------------------------------------
    // SUB-OBJECTIVE 1B: Tarjan SCC Discovers 0 Cycles / Non-Trivial SCCs
    // ------------------------------------------------------------------------
    test("1B. Tarjan's SCC algorithm discovers 0 cycles and 0 non-trivial SCCs", () {
      // 1. Tarjan on Fallback Catalog
      final fallbackNodes = CurriculumRegistry.getAllNodes().map((n) => n.serverId).toSet();
      final fallbackDAG = CurriculumRegistry.prerequisiteMap;
      final fallbackSCCs = GraphTopologyOracles.runTarjanSCC(fallbackNodes, fallbackDAG);

      expect(fallbackSCCs.length, 40, reason: 'Every node in a DAG forms its own trivial SCC of size 1');
      for (final scc in fallbackSCCs) {
        expect(scc.length, 1, reason: 'SCC with size > 1 found: $scc (cycle detected)');
      }

      // 2. Tarjan on Disk Markdown Catalog
      final diskDAG = loadDiskMarkdownDAG();
      final diskNodes = diskDAG.keys.toSet();
      final diskSCCs = GraphTopologyOracles.runTarjanSCC(diskNodes, diskDAG);

      expect(diskSCCs.length, 40, reason: 'Disk DAG must have exactly 40 trivial SCCs');
      for (final scc in diskSCCs) {
        expect(scc.length, 1, reason: 'Disk SCC with size > 1 found: $scc (cycle detected)');
      }

      // 3. 3-Color DFS Cycle Confirmation
      expect(
        GraphTopologyOracles.hasCycleDFS(fallbackNodes, fallbackDAG),
        isFalse,
        reason: '3-color DFS confirmed cycle-free on fallback graph',
      );
      expect(
        GraphTopologyOracles.hasCycleDFS(diskNodes, diskDAG),
        isFalse,
        reason: '3-color DFS confirmed cycle-free on disk graph',
      );
    });

    // ------------------------------------------------------------------------
    // SUB-OBJECTIVE 1C: Root Reachability (mat_add_01 -> Arithmetic & Geometry -> 5 Lin Alg Nodes)
    // ------------------------------------------------------------------------
    test('1C. Root reachability connects mat_add_01 through arithmetic and geometry into all 5 linear algebra nodes', () {
      final diskDAG = loadDiskMarkdownDAG();
      final diskNodes = diskDAG.keys.toSet();

      // 1. Verify mat_add_01 is the unique root
      final inDegrees = <String, int>{for (final id in diskNodes) id: 0};
      for (final prereqs in diskDAG.values) {
        for (final p in prereqs) {
          inDegrees[p] = (inDegrees[p] ?? 0);
        }
      }
      for (final entry in diskDAG.entries) {
        final dependent = entry.key;
        for (final _ in entry.value) {
          inDegrees[dependent] = (inDegrees[dependent] ?? 0) + 1;
        }
      }

      final zeroInDegreeRoots = diskNodes.where((id) => inDegrees[id] == 0).toList();
      expect(zeroInDegreeRoots, equals(['mat_add_01']),
          reason: 'mat_add_01 must be the unique foundational root of the entire curriculum');

      // 2. Verify forward reachability from mat_add_01 reaches ALL 40 nodes
      final reachableFromRoot = GraphTopologyOracles.computeForwardReachable('mat_add_01', diskNodes, diskDAG);
      expect(reachableFromRoot.length, 40,
          reason: 'Every one of the 40 nodes must be reachable from mat_add_01');
      expect(reachableFromRoot, equals(diskNodes));

      // 3. Verify specific paths into all 5 linear algebra nodes
      final linAlgNodes = [
        'lin_alg_01_tuples',
        'lin_alg_02_vectors',
        'lin_alg_03_operations',
        'lin_alg_04_span',
        'lin_alg_05_independence',
      ];

      for (final laNode in linAlgNodes) {
        expect(reachableFromRoot.contains(laNode), isTrue,
            reason: '$laNode must be reachable from mat_add_01');
        final paths = GraphTopologyOracles.findAllPaths('mat_add_01', laNode, diskNodes, diskDAG);
        expect(paths.isNotEmpty, isTrue, reason: 'Must have at least one directed path from mat_add_01 to $laNode');
      }

      // 4. Trace the dual Arithmetic AND Geometry convergence into lin_alg_01_tuples
      final pathsToTuples = GraphTopologyOracles.findAllPaths('mat_add_01', 'lin_alg_01_tuples', diskNodes, diskDAG);
      expect(pathsToTuples.length, greaterThanOrEqualTo(2),
          reason: 'lin_alg_01_tuples must have multiple convergence paths (direct and via Pythagoras)');

      // Geometry branch path: mat_add_01 -> mat_triang_01 -> mat_pythagoras_01 -> lin_alg_01_tuples
      final hasGeometryPath = pathsToTuples.any((path) =>
          path.contains('mat_triang_01') && path.contains('mat_pythagoras_01'));
      expect(hasGeometryPath, isTrue,
          reason: 'Must have a path passing through Geometry (mat_triang_01, mat_pythagoras_01)');

      // Arithmetic branch path: mat_add_01 -> mat_mul_01 -> mat_pow_01 -> mat_binom_01 -> mat_pythagoras_01 -> lin_alg_01_tuples
      final hasArithmeticPath = pathsToTuples.any((path) =>
          path.contains('mat_mul_01') && path.contains('mat_pow_01'));
      expect(hasArithmeticPath, isTrue,
          reason: 'Must have a path passing through Arithmetic (mat_mul_01, mat_pow_01)');

      // 5. Verify the strict linear sequential progression across the 5 linear algebra nodes
      final pathsToTerminal = GraphTopologyOracles.findAllPaths('mat_add_01', 'lin_alg_05_independence', diskNodes, diskDAG);
      expect(pathsToTerminal.isNotEmpty, isTrue);
      for (final path in pathsToTerminal) {
        // Every path to lin_alg_05_independence must pass sequentially through 01 -> 02 -> 03 -> 04 -> 05
        final idx01 = path.indexOf('lin_alg_01_tuples');
        final idx02 = path.indexOf('lin_alg_02_vectors');
        final idx03 = path.indexOf('lin_alg_03_operations');
        final idx04 = path.indexOf('lin_alg_04_span');
        final idx05 = path.indexOf('lin_alg_05_independence');

        expect(idx01, greaterThanOrEqualTo(0));
        expect(idx02, greaterThan(idx01));
        expect(idx03, greaterThan(idx02));
        expect(idx04, greaterThan(idx03));
        expect(idx05, greaterThan(idx04));
      }
    });

    // ------------------------------------------------------------------------
    // SUB-OBJECTIVE 1D: No Isolated Components Exist
    // ------------------------------------------------------------------------
    test('1D. Weakly connected components verify zero isolated components or orphan islands', () {
      final diskDAG = loadDiskMarkdownDAG();
      final diskNodes = diskDAG.keys.toSet();

      final components = GraphTopologyOracles.computeWeaklyConnectedComponents(diskNodes, diskDAG);
      expect(components.length, 1,
          reason: 'The entire curriculum graph must form exactly 1 connected component (no isolated subgraphs or floating nodes)');
      expect(components.first.length, 40,
          reason: 'The single component must contain all 40 nodes');

      // Check for orphan nodes: every node except mat_add_01 must have at least one prerequisite
      for (final entry in diskDAG.entries) {
        if (entry.key == 'mat_add_01') {
          expect(entry.value, isEmpty);
        } else {
          expect(entry.value.isNotEmpty, isTrue,
              reason: 'Node ${entry.key} has 0 prerequisites but is not mat_add_01 (orphan node)');
        }
      }
    });

    // ------------------------------------------------------------------------
    // ADVERSARIAL ORACLE VALIDATION (FAULT INJECTION STRESS HARNESS)
    // ------------------------------------------------------------------------
    test('1E. Adversarial Fault Injection verifies oracles detect cycles, islands, and breaks', () {
      final diskDAG = loadDiskMarkdownDAG();
      final diskNodes = Set<String>.from(diskDAG.keys);

      // Fault 1: Inject cycle back from lin_alg_05_independence to mat_add_01
      final cyclicDAG = Map<String, List<String>>.from(diskDAG);
      cyclicDAG['mat_add_01'] = ['lin_alg_05_independence'];

      final kahnCyclic = GraphTopologyOracles.runKahn(diskNodes, cyclicDAG);
      expect(kahnCyclic.isAcyclic, isFalse, reason: 'Kahn must fail on injected cycle');
      expect(kahnCyclic.sortedOrder.length, lessThan(40));

      final tarjanCyclic = GraphTopologyOracles.runTarjanSCC(diskNodes, cyclicDAG);
      final nonTrivialSCCs = tarjanCyclic.where((scc) => scc.length > 1).toList();
      expect(nonTrivialSCCs.isNotEmpty, isTrue, reason: 'Tarjan must detect cycle SCC');
      expect(GraphTopologyOracles.hasCycleDFS(diskNodes, cyclicDAG), isTrue);

      // Fault 2: Inject isolated island node
      final islandNodes = Set<String>.from(diskNodes)..add('floating_island_node');
      final islandDAG = Map<String, List<String>>.from(diskDAG);
      islandDAG['floating_island_node'] = [];

      final islandComponents = GraphTopologyOracles.computeWeaklyConnectedComponents(islandNodes, islandDAG);
      expect(islandComponents.length, 2, reason: 'Must detect 2 components when island is injected');

      final reachableWithIsland = GraphTopologyOracles.computeForwardReachable('mat_add_01', islandNodes, islandDAG);
      expect(reachableWithIsland.contains('floating_island_node'), isFalse,
          reason: 'Floating island must NOT be reachable from mat_add_01');

      // Fault 3: Disconnected circular component (island with internal cycle)
      final cycleIslandNodes = Set<String>.from(diskNodes)..addAll(['cycle_x', 'cycle_y']);
      final cycleIslandDAG = Map<String, List<String>>.from(diskDAG);
      cycleIslandDAG['cycle_x'] = ['cycle_y'];
      cycleIslandDAG['cycle_y'] = ['cycle_x'];

      final cycleIslandKahn = GraphTopologyOracles.runKahn(cycleIslandNodes, cycleIslandDAG);
      expect(cycleIslandKahn.isAcyclic, isFalse);
      expect(cycleIslandKahn.sortedOrder.length, 40,
          reason: 'Kahn processes 40 legitimate nodes but halts on the disconnected cycle');

      final cycleIslandTarjan = GraphTopologyOracles.runTarjanSCC(cycleIslandNodes, cycleIslandDAG);
      final islandSCC = cycleIslandTarjan.where((scc) => scc.contains('cycle_x')).first;
      expect(islandSCC.length, 2, reason: 'Tarjan isolates the disconnected cycle into its own SCC');
    });
  });
}
