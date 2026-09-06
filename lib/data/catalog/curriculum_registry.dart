import 'package:isar/isar.dart';

import '../../domain/models/knowledge_node.dart';
import 'algebra_catalog.dart';
import 'arithmetic_catalog.dart';
import 'calculus_catalog.dart';
import 'geometry_trig_catalog.dart';
import 'physics_catalog.dart';

/// Registro centrale del Curriculum Matematico e Scientifico di Laurentius.
/// Raccoglie tutti i nodi dai singoli cataloghi specializzati e definisce
/// il Grafo Aciclico Diretto (DAG) rigoroso delle dipendenze didattiche.
class CurriculumRegistry {
  /// Restituisce tutti i nodi di conoscenza del sistema
  static List<KnowledgeNode> getAllNodes() {
    return [
      ...ArithmeticCatalog.getAllNodes(),
      ...AlgebraCatalog.getAllNodes(),
      ...GeometryTrigCatalog.getAllNodes(),
      ...CalculusCatalog.getAllNodes(),
      ...PhysicsCatalog.getAllNodes(),
    ];
  }

  /// Mappa dei prerequisiti diretti (DAG didattico rigoroso senza collegamenti spuri).
  /// Ogni argomento dipende esclusivamente da ciò che usa direttamente.
  static const Map<String, List<String>> prerequisiteMap = {
    // Aritmetica
    'mat_add_01': [],
    'mat_mul_01': ['mat_add_01'],
    'mat_frac_01': ['mat_mul_01'],
    'mat_pow_01': ['mat_mul_01'],

    // Algebra
    'mat_binom_01': ['mat_pow_01'],
    'mat_quad_eq_01': ['mat_binom_01', 'mat_frac_01'],
    'mat_parabola_01': ['mat_quad_eq_01'],
    'mat_log_01': ['mat_pow_01'],

    // Geometria & Trigonometria
    'mat_triang_01': ['mat_add_01'],
    'mat_pythagoras_01': ['mat_triang_01', 'mat_binom_01'],
    'mat_trig_circ_01': ['mat_pythagoras_01'],
    'mat_trig_add_01': ['mat_trig_circ_01'],
    'mat_trig_triang_01': ['mat_trig_add_01', 'mat_pythagoras_01'],

    // Analisi Matematica (Limiti -> Derivate -> Teoremi -> Riemann -> Teorema Fondamentale)
    'mat_limits_01': ['mat_trig_circ_01', 'mat_frac_01'],
    'mat_deriv_def_01': ['mat_limits_01'],
    'mat_deriv_rules_01': ['mat_deriv_def_01', 'mat_binom_01'],
    'mat_deriv_theorems_01': ['mat_deriv_rules_01'],
    'mat_riemann_01': ['mat_deriv_theorems_01', 'mat_limits_01'],
    'mat_fund_calc_01': ['mat_riemann_01', 'mat_deriv_def_01'],

    // Scienze Applicate Interconnesse
    'phys_kin_01': [
      'mat_parabola_01',
      'mat_deriv_rules_01',
      'mat_fund_calc_01',
    ],
    'ele_ohm_01': ['mat_frac_01'],
    'ele_power_01': ['ele_ohm_01'],
    'ele_joule_01': ['ele_power_01', 'mat_fund_calc_01'],
    'chem_ph_01': ['mat_log_01'],
  };

  /// Sincronizza l'intero catalogo sul database locale Isar
  static Future<void> syncToIsar(Isar isar) async {
    final allNodes = getAllNodes();

    // Fase 1: Upsert dei nodi preservando gli ID univoci
    await isar.writeTxn(() async {
      for (final node in allNodes) {
        final existing = await isar.knowledgeNodes
            .where()
            .serverIdEqualTo(node.serverId)
            .findFirst();
        if (existing != null) {
          node.id = existing.id;
        }
        await isar.knowledgeNodes.put(node);
      }
    });

    // Fase 2: Connessione bidirezionale e salvataggio dei link di prerequisito
    await isar.writeTxn(() async {
      // Indicizzazione in memoria per lookup veloce
      final Map<String, KnowledgeNode> nodeMap = {};
      for (final n in allNodes) {
        final persisted = await isar.knowledgeNodes
            .where()
            .serverIdEqualTo(n.serverId)
            .findFirst();
        if (persisted != null) {
          nodeMap[persisted.serverId] = persisted;
        }
      }

      for (final entry in prerequisiteMap.entries) {
        final targetServerId = entry.key;
        final prereqServerIds = entry.value;

        final targetNode = nodeMap[targetServerId];
        if (targetNode == null) continue;

        await targetNode.prerequisites.load();
        targetNode.prerequisites.clear();

        for (final prereqId in prereqServerIds) {
          final prereqNode = nodeMap[prereqId];
          if (prereqNode != null) {
            targetNode.prerequisites.add(prereqNode);
          }
        }

        await targetNode.prerequisites.save();
      }
    });
  }
}
