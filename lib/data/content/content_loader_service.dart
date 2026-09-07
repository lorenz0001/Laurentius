import 'package:flutter/services.dart';
import 'package:isar/isar.dart';

import '../../domain/models/knowledge_node.dart';
import '../catalog/curriculum_registry.dart';
import 'markdown_content_parser.dart';

/// Offline content loader and synchronizer for decoupled Markdown articles.
///
/// Discovers Markdown files in `assets/content/`, parses them via
/// [MarkdownContentParser], and persists them into the local [Isar] database
/// using a 2-phase transactional upsert.
class ContentLoaderService {
  static List<KnowledgeNode>? _cachedNodes;

  /// Returns currently loaded/cached nodes, if any.
  static List<KnowledgeNode>? get cachedNodes => _cachedNodes;

  /// All standard bundled Markdown topic asset paths.
  static const List<String> knownAssetPaths = [
    'assets/content/arithmetic/mat_add_01.md',
    'assets/content/arithmetic/mat_mul_01.md',
    'assets/content/arithmetic/mat_frac_01.md',
    'assets/content/arithmetic/mat_pow_01.md',
    'assets/content/algebra/mat_binom_01.md',
    'assets/content/algebra/mat_quad_eq_01.md',
    'assets/content/algebra/mat_parabola_01.md',
    'assets/content/algebra/mat_log_01.md',
    'assets/content/geometry_trig/mat_triang_01.md',
    'assets/content/geometry_trig/mat_pythagoras_01.md',
    'assets/content/geometry_trig/mat_trig_circ_01.md',
    'assets/content/geometry_trig/mat_trig_add_01.md',
    'assets/content/geometry_trig/mat_trig_triang_01.md',
    'assets/content/calculus/mat_limits_01.md',
    'assets/content/calculus/mat_deriv_def_01.md',
    'assets/content/calculus/mat_deriv_rules_01.md',
    'assets/content/calculus/mat_deriv_theorems_01.md',
    'assets/content/calculus/mat_riemann_01.md',
    'assets/content/calculus/mat_fund_calc_01.md',
    'assets/content/physics/phys_kin_01.md',
    'assets/content/physics/ele_ohm_01.md',
    'assets/content/physics/ele_power_01.md',
    'assets/content/physics/ele_joule_01.md',
    'assets/content/physics/chem_ph_01.md',
  ];

  /// Populates the in-memory cache and propagates it to [CurriculumRegistry].
  static void setCachedNodes(List<KnowledgeNode> nodes) {
    _cachedNodes = List.unmodifiable(nodes);
    CurriculumRegistry.setCachedNodes(nodes);
  }

  /// Clears the in-memory cache in both this service and [CurriculumRegistry].
  static void clearCache() {
    _cachedNodes = null;
    CurriculumRegistry.clearCache();
  }

  /// Discovers and loads all Markdown content articles from the given [bundle]
  /// (defaulting to [rootBundle]), parses them into [KnowledgeNode]s,
  /// updates the in-memory cache, and returns the parsed list.
  static Future<List<KnowledgeNode>> loadAllFromBundle({
    AssetBundle? bundle,
  }) async {
    final effectiveBundle = bundle ?? rootBundle;
    List<String> mdAssets = [];

    try {
      final manifest = await AssetManifest.loadFromAssetBundle(effectiveBundle);
      mdAssets = manifest
          .listAssets()
          .where((p) => p.startsWith('assets/content/') && p.endsWith('.md'))
          .toList();
    } catch (_) {
      mdAssets = [];
    }

    // Fallback to known asset paths if manifest listing returned none
    if (mdAssets.isEmpty) {
      mdAssets = List.from(knownAssetPaths);
    }

    final nodes = <KnowledgeNode>[];
    for (final path in mdAssets) {
      try {
        final content = await effectiveBundle.loadString(path);
        final node = MarkdownContentParser.parse(content);
        if (node.serverId.isNotEmpty) {
          nodes.add(node);
        }
      } catch (_) {
        // Continue loading remaining assets if a single path fails
      }
    }

    setCachedNodes(nodes);
    return nodes;
  }

  /// Sincronizza i nodi passati sul database locale Isar mediante transazione a 2 fasi:
  /// - Fase 1: Upsert dei nodi preservando la chiave primaria univoca Isar auto-increment.
  /// - Fase 2: Risoluzione e persistenza dei link dei prerequisiti (DAG didattico).
  static Future<void> syncToIsar(Isar isar, List<KnowledgeNode> nodes) async {
    // Fase 1: Upsert dei nodi
    await isar.writeTxn(() async {
      for (final node in nodes) {
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

    // Fase 2: Risoluzione dei collegamenti IsarLinks per i prerequisiti
    await isar.writeTxn(() async {
      final persisted = await isar.knowledgeNodes.where().findAll();
      final nodeMap = {for (final n in persisted) n.serverId: n};

      for (final node in nodes) {
        final target = nodeMap[node.serverId];
        if (target == null) continue;

        await target.prerequisites.load();
        target.prerequisites.clear();

        for (final prereqId in node.tempPrerequisiteIds) {
          final prereqNode = nodeMap[prereqId];
          if (prereqNode != null) {
            target.prerequisites.add(prereqNode);
          }
        }

        await target.prerequisites.save();
      }
    });
  }
}
