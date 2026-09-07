import 'package:isar/isar.dart';

import '../../domain/models/knowledge_node.dart';
import '../content/content_loader_service.dart';
import 'algebra_catalog.dart';
import 'arithmetic_catalog.dart';
import 'calculus_catalog.dart';
import 'geometry_trig_catalog.dart';
import 'physics_catalog.dart';

/// Registro centrale del Curriculum Matematico e Scientifico di Laurentius.
/// Raccoglie tutti i nodi dai singoli cataloghi specializzati o dalla cache caricata
/// e definisce il Grafo Aciclico Diretto (DAG) rigoroso delle dipendenze didattiche.
class CurriculumRegistry {
  static List<KnowledgeNode>? _cachedNodes;

  /// Popola la cache in memoria con i nodi caricati (es. da Markdown/Bundle)
  static void setCachedNodes(List<KnowledgeNode> nodes) {
    _cachedNodes = List.unmodifiable(nodes);
  }

  /// Svuota la cache in memoria
  static void clearCache() {
    _cachedNodes = null;
  }

  /// Restituisce tutti i nodi di conoscenza del sistema (da cache se presente, altrimenti da catalogo di fallback)
  static List<KnowledgeNode> getAllNodes() {
    if (_cachedNodes != null && _cachedNodes!.isNotEmpty) {
      return _cachedNodes!;
    }
    return [
      ...ArithmeticCatalog.getAllNodes(),
      ...AlgebraCatalog.getAllNodes(),
      ...GeometryTrigCatalog.getAllNodes(),
      ...CalculusCatalog.getAllNodes(),
      ...PhysicsCatalog.getAllNodes(),
    ];
  }

  /// Mappa dei prerequisiti diretti (DAG didattico rigoroso senza collegamenti spuri).
  /// Se la cache dei nodi è attiva, deriva la mappa dinamicamente dai nodi caricati.
  static Map<String, List<String>> get prerequisiteMap {
    if (_cachedNodes != null && _cachedNodes!.isNotEmpty) {
      return {
        for (final node in _cachedNodes!)
          node.serverId: node.tempPrerequisiteIds,
      };
    }
    return _defaultPrerequisiteMap;
  }

  /// Crea un nodo di fallback compatto per ambienti headless/test/web
  static KnowledgeNode createFallbackNode({
    required String serverId,
    required String title,
    required String category,
    required String subCategory,
    List<String>? prerequisites,
    InteractiveData? interactiveData,
    String? corollary,
  }) {
    return KnowledgeNode()
      ..serverId = serverId
      ..title = title
      ..category = category
      ..subCategory = subCategory
      ..tempPrerequisiteIds =
          prerequisites ?? _defaultPrerequisiteMap[serverId] ?? []
      ..lastUpdated = DateTime(2026, 9, 7)
      ..interactiveData = interactiveData
      ..algebraicProof = [
        ProofStep()
          ..description = 'Dimostrazione per $title'
          ..latexEquation = r'\text{Fondamento didattico}'
          ..insight =
              'Corollario: ${corollary ?? "Deduzione e proprietà fondamentale."}',
      ];
  }

  /// Sincronizza l'intero catalogo sul database locale Isar delegando a [ContentLoaderService]
  static Future<void> syncToIsar(Isar isar) async {
    await ContentLoaderService.syncToIsar(isar, getAllNodes());
  }

  static const Map<String, List<String>> _defaultPrerequisiteMap = {
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
}
