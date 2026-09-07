import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/data/catalog/curriculum_registry.dart';

void main() {
  group('Curriculum & DAG Rigorous Validation Tests', () {
    test('All nodes in CurriculumRegistry have unique serverIds and non-empty titles', () {
      final nodes = CurriculumRegistry.getAllNodes();
      expect(nodes.isNotEmpty, true);

      final ids = <String>{};
      for (final n in nodes) {
        expect(
          n.serverId.isNotEmpty,
          true,
          reason: 'Node must have non-empty serverId',
        );
        expect(
          ids.contains(n.serverId),
          false,
          reason: 'Duplicate serverId found: ${n.serverId}',
        );
        ids.add(n.serverId);

        expect(
          n.title.isNotEmpty,
          true,
          reason: 'Node ${n.serverId} has empty title',
        );
        expect(
          n.category.isNotEmpty,
          true,
          reason: 'Node ${n.serverId} has empty category',
        );
        expect(
          n.algebraicProof.isNotEmpty,
          true,
          reason: 'Node ${n.serverId} must have algebraic proof',
        );
      }
    });

    test('Curriculum spans from addition (mat_add_01) all the way to calculus (mat_fund_calc_01)', () {
      final nodes = CurriculumRegistry.getAllNodes();
      final ids = nodes.map((n) => n.serverId).toSet();

      // Verifica nodi chiave da addizione a integrazione
      expect(ids.contains('mat_add_01'), true);
      expect(ids.contains('mat_mul_01'), true);
      expect(ids.contains('mat_frac_01'), true);
      expect(ids.contains('mat_pow_01'), true);
      expect(ids.contains('mat_binom_01'), true);
      expect(ids.contains('mat_quad_eq_01'), true);
      expect(ids.contains('mat_triang_01'), true);
      expect(ids.contains('mat_pythagoras_01'), true);
      expect(ids.contains('mat_trig_circ_01'), true);
      expect(ids.contains('mat_trig_add_01'), true);
      expect(ids.contains('mat_trig_triang_01'), true);
      expect(ids.contains('mat_limits_01'), true);
      expect(ids.contains('mat_lim_sinc_01'), true);
      expect(ids.contains('mat_lim_cos_01'), true);
      expect(ids.contains('mat_lim_e_01'), true);
      expect(ids.contains('mat_lim_exp_01'), true);
      expect(ids.contains('mat_lim_log_01'), true);
      expect(ids.contains('mat_deriv_def_01'), true);
      expect(ids.contains('mat_deriv_rules_01'), true);
      expect(ids.contains('mat_deriv_theorems_01'), true);
      expect(ids.contains('mat_riemann_01'), true);
      expect(ids.contains('mat_fund_calc_01'), true);
      expect(ids.contains('phys_kin_01'), true);
    });

    test('Every prerequisite in prerequisiteMap points to a valid serverId', () {
      final validIds = CurriculumRegistry.getAllNodes()
          .map((n) => n.serverId)
          .toSet();

      for (final entry in CurriculumRegistry.prerequisiteMap.entries) {
        final targetId = entry.key;
        expect(
          validIds.contains(targetId),
          true,
          reason: 'prerequisiteMap key $targetId does not exist',
        );

        for (final prereqId in entry.value) {
          expect(
            validIds.contains(prereqId),
            true,
            reason:
                'Node $targetId references non-existent prerequisite $prereqId',
          );
        }
      }
    });

    test('Prerequisite graph is strictly acyclic (DAG check with topological sort)', () {
      final graph = CurriculumRegistry.prerequisiteMap;
      final inDegree = <String, int>{};

      for (final key in graph.keys) {
        inDegree[key] = 0;
      }

      // Calcola in-degree degli archi diretti (prerequisito -> dipendente)
      for (final prereqs in graph.values) {
        for (final p in prereqs) {
          inDegree[p] = (inDegree[p] ?? 0);
        }
      }

      // Adiacenza: da prerequisito a nodi che dipendono da esso
      final adj = <String, List<String>>{};
      for (final entry in graph.entries) {
        final dependent = entry.key;
        for (final prereq in entry.value) {
          adj.putIfAbsent(prereq, () => []).add(dependent);
          inDegree[dependent] = (inDegree[dependent] ?? 0) + 1;
        }
      }

      // Coda di nodi con inDegree == 0 (senza prerequisiti non ancora processati)
      final queue = <String>[];
      for (final entry in inDegree.entries) {
        if (entry.value == 0) {
          queue.add(entry.key);
        }
      }

      int visitedCount = 0;
      while (queue.isNotEmpty) {
        final current = queue.removeAt(0);
        visitedCount++;

        for (final neighbor in adj[current] ?? []) {
          inDegree[neighbor] = inDegree[neighbor]! - 1;
          if (inDegree[neighbor] == 0) {
            queue.add(neighbor);
          }
        }
      }

      expect(
        visitedCount,
        graph.length,
        reason: 'Ciclo rilevato nel grafo dei prerequisiti! Non è un DAG aciclico valido.',
      );
    });

    test('Every knowledge node contains clearly identified corollaries', () {
      final nodes = CurriculumRegistry.getAllNodes();

      for (final node in nodes) {
        final hasCorollary = node.algebraicProof.any(
          (step) =>
              (step.description?.toLowerCase().contains('corollario') ??
                  false) ||
              (step.insight?.toLowerCase().contains('corollario') ?? false),
        );

        expect(
          hasCorollary,
          true,
          reason:
              'Nodo ${node.serverId} ("${node.title}") non ha corollari esplicitamente enunciati.',
        );
      }
    });
  });
}
