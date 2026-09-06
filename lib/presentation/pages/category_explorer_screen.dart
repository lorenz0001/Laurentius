import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../data/catalog/curriculum_registry.dart';
import '../../data/repositories/node_repository.dart';
import '../../domain/models/knowledge_node.dart';
import '../widgets/category_style.dart';
import 'node_detail_screen.dart';

/// Schermata di esplorazione gerarchica delle conoscenze didattiche STEM.
/// Organizza il curriculum in macro-sezioni (Matematica, Fisica, Elettrotecnica)
/// con navigazione a tab, appiattimento delle sottocategorie con singolo elemento
/// (nessuna cartella superflua) e ordinamento rigorosamente crescente per difficoltà (profondità DAG).
class CategoryExplorerScreen extends StatefulWidget {
  final Isar? isar;
  final VoidCallback? onRefreshRequested;

  const CategoryExplorerScreen({super.key, this.isar, this.onRefreshRequested});

  @override
  State<CategoryExplorerScreen> createState() => _CategoryExplorerScreenState();
}

class _CategoryExplorerScreenState extends State<CategoryExplorerScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  String? _errorMessage;
  List<KnowledgeNode> _allNodes = [];

  // Mappa delle profondità topologiche dei nodi nel DAG (difficoltà crescente)
  Map<String, int> _nodeDepths = {};

  // Mappa gerarchica: Categoria -> Sottocategoria -> Lista di Nodi
  Map<String, Map<String, List<KnowledgeNode>>> _groupedData = {};
  List<String> _categories = [];

  TabController? _tabController;

  static const List<String> _preferredOrder = [
    'Matematica',
    'Fisica',
    'Elettrotecnica',
  ];

  @override
  void initState() {
    super.initState();
    _loadNodes();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  /// Calcola ricorsivamente la profondità topologica nel DAG a partire dai prerequisiti
  int _calculateDepth(
    String serverId,
    Map<String, List<String>> prereqMap, [
    Set<String>? visited,
  ]) {
    visited ??= {};
    if (visited.contains(serverId)) return 0; // Protezione contro cicli
    visited.add(serverId);

    final prereqs = prereqMap[serverId] ?? [];
    if (prereqs.isEmpty) return 0; // Nodo radice / fondamento di base

    int maxParentDepth = 0;
    for (final parent in prereqs) {
      final d = _calculateDepth(parent, prereqMap, visited);
      if (d + 1 > maxParentDepth) {
        maxParentDepth = d + 1;
      }
    }
    return maxParentDepth;
  }

  Future<void> _loadNodes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final List<KnowledgeNode> nodes;
      if (widget.isar != null) {
        final repository = NodeRepository(widget.isar!);
        nodes = await repository.getAllNodes();
      } else {
        nodes = CurriculumRegistry.getAllNodes();
      }

      // 1. Calcola la profondità nel DAG per ciascun nodo
      final Map<String, int> depths = {};
      final prereqMap = CurriculumRegistry.prerequisiteMap;
      for (final node in nodes) {
        depths[node.serverId] = _calculateDepth(node.serverId, prereqMap);
      }

      // 2. Raggruppa per Categoria (Macro-sezione) -> Sottocategoria
      final Map<String, Map<String, List<KnowledgeNode>>> tree = {};

      for (final node in nodes) {
        final category = node.category.trim().isEmpty
            ? 'Matematica'
            : node.category.trim();
        final subCategory =
            (node.subCategory == null || node.subCategory!.trim().isEmpty)
                ? 'Concetti Fondamentali'
                : node.subCategory!.trim();

        tree.putIfAbsent(category, () => {});
        tree[category]!.putIfAbsent(subCategory, () => []);
        tree[category]![subCategory]!.add(node);
      }

      // 3. Ordina i nodi all'interno di ogni sottocategoria per difficoltà crescente (profondità DAG)
      for (final cat in tree.keys) {
        for (final subCat in tree[cat]!.keys) {
          tree[cat]![subCat]!.sort((a, b) {
            final depthA = depths[a.serverId] ?? 0;
            final depthB = depths[b.serverId] ?? 0;
            if (depthA != depthB) return depthA.compareTo(depthB);
            return a.serverId.compareTo(b.serverId);
          });
        }
      }

      // 4. Ordina le categorie secondo l'ordine didattico preferito
      final categories = tree.keys.toList();
      categories.sort((a, b) {
        final idxA = _preferredOrder.indexOf(a);
        final idxB = _preferredOrder.indexOf(b);
        if (idxA != -1 && idxB != -1) return idxA.compareTo(idxB);
        if (idxA != -1) return -1;
        if (idxB != -1) return 1;
        return a.compareTo(b);
      });

      _tabController?.dispose();
      _tabController = TabController(
        length: categories.isEmpty ? 1 : categories.length,
        vsync: this,
      );

      setState(() {
        _allNodes = nodes;
        _nodeDepths = depths;
        _groupedData = tree;
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Errore durante il recupero dei dati: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF2563EB)),
            SizedBox(height: 16),
            Text(
              'Organizzazione catalogo didattico...',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 44,
                color: Color(0xFFDC2626),
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF475569), fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadNodes,
                icon: const Icon(Icons.refresh),
                label: const Text('Riprova'),
              ),
            ],
          ),
        ),
      );
    }

    if (_groupedData.isEmpty || _categories.isEmpty) {
      return const Center(
        child: Text(
          'Nessun contenuto disponibile nel catalogo.',
          style: TextStyle(color: Color(0xFF64748B)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: _buildHeaderHero(),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: const Color(0xFF2563EB),
                  unselectedLabelColor: const Color(0xFF64748B),
                  indicatorColor: const Color(0xFF2563EB),
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: _categories.map((category) {
                    final catStyle = CategoryStyle.forCategory(category);
                    final subCats = _groupedData[category] ?? {};
                    final count = subCats.values.fold<int>(
                      0,
                      (acc, list) => acc + list.length,
                    );
                    return Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(catStyle.icon, size: 16),
                          const SizedBox(width: 6),
                          Text(category),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$count',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: catStyle.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: _categories.map((category) {
            final subCategories = _groupedData[category] ?? {};
            return _buildCategoryTabView(category, subCategories);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildHeaderHero() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Libreria Didattica STEM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      'Difficoltà crescente e struttura ad albero logico',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_allNodes.length} Nodi',
                  style: const TextStyle(
                    color: Color(0xFF93C5FD),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Gli argomenti alla sommità sono i fondamenti diretti del grafo. Scorrendo verso il basso, la difficoltà e le dipendenze teoriche crescono rigorosamente.',
            style: TextStyle(
              color: Color(0xFFCBD5E1),
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// Vista della singola Tab (Matematica, Fisica, Elettrotecnica)
  Widget _buildCategoryTabView(
    String categoryName,
    Map<String, List<KnowledgeNode>> subCategories,
  ) {
    final catStyle = CategoryStyle.forCategory(categoryName);

    // Ordina le sottocategorie in base alla minima profondità dei loro nodi
    final sortedSubCatEntries = subCategories.entries.toList()
      ..sort((a, b) {
        final minDepthA = a.value.isEmpty
            ? 0
            : a.value
                .map((n) => _nodeDepths[n.serverId] ?? 0)
                .reduce(math.min);
        final minDepthB = b.value.isEmpty
            ? 0
            : b.value
                .map((n) => _nodeDepths[n.serverId] ?? 0)
                .reduce(math.min);
        return minDepthA.compareTo(minDepthB);
      });

    return RefreshIndicator(
      onRefresh: _loadNodes,
      color: const Color(0xFF2563EB),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        itemCount: sortedSubCatEntries.length,
        itemBuilder: (context, index) {
          final entry = sortedSubCatEntries[index];
          final subCategoryName = entry.key;
          final nodes = entry.value;

          // REGOLA RICHIESTA: Se la sottocategoria ha UN SOLO elemento,
          // non ha senso avere la cartella (ExpansionTile) -> appiattisci e renderizza direttamente la card!
          if (nodes.length == 1) {
            return _buildSingleNodeCard(nodes.first, subCategoryName, catStyle);
          }

          // Altrimenti, se ha più elementi, mostra il contenitore a cartella
          return _buildSubCategoryFolder(subCategoryName, nodes, catStyle);
        },
      ),
    );
  }

  /// Renderizza direttamente un nodo singolo quando la sottocategoria contiene 1 solo elemento
  Widget _buildSingleNodeCard(
    KnowledgeNode node,
    String subCategoryName,
    CategoryStyle catStyle,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: _buildNodeItem(
        node,
        catStyle,
        subCategoryBadge: subCategoryName,
      ),
    );
  }

  /// Renderizza la cartella espandibile per le sottocategorie con 2 o più elementi
  Widget _buildSubCategoryFolder(
    String subCategoryName,
    List<KnowledgeNode> nodes,
    CategoryStyle catStyle,
  ) {
    final minDepth = nodes.isEmpty
        ? 0
        : nodes.map((n) => _nodeDepths[n.serverId] ?? 0).reduce(math.min);
    final maxDepth = nodes.isEmpty
        ? 0
        : nodes.map((n) => _nodeDepths[n.serverId] ?? 0).reduce(math.max);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x04000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: false,
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: catStyle.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: catStyle.border),
              ),
              child: Icon(Icons.folder_rounded, size: 18, color: catStyle.primary),
            ),
            title: Text(
              subCategoryName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            subtitle: Text(
              minDepth == maxDepth
                  ? '${nodes.length} concetti • Livello DAG $minDepth'
                  : '${nodes.length} concetti • Livello DAG $minDepth - $maxDepth',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${nodes.length}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF475569),
                ),
              ),
            ),
            children: nodes
                .map((node) => _buildNodeItem(node, catStyle))
                .toList(),
          ),
        ),
      ),
    );
  }

  /// Card di visualizzazione del singolo nodo concettuale
  Widget _buildNodeItem(
    KnowledgeNode node,
    CategoryStyle catStyle, {
    String? subCategoryBadge,
  }) {
    final hasProof = node.algebraicProof.isNotEmpty || node.blocks.isNotEmpty;
    final hasInteractive = node.interactiveData != null;
    final depth = _nodeDepths[node.serverId] ?? 0;

    // Etichetta di difficoltà didattica basata sulla profondità DAG
    final String difficultyLabel;
    final Color difficultyColor;
    final Color difficultyBg;

    if (depth <= 1) {
      difficultyLabel = 'Fondamento (L$depth)';
      difficultyColor = const Color(0xFF16A34A); // Verde smeraldo
      difficultyBg = const Color(0xFFDCFCE7);
    } else if (depth <= 4) {
      difficultyLabel = 'Intermedio (L$depth)';
      difficultyColor = const Color(0xFF0284C7); // Blu cielo
      difficultyBg = const Color(0xFFE0F2FE);
    } else if (depth <= 7) {
      difficultyLabel = 'Avanzato (L$depth)';
      difficultyColor = const Color(0xFFD97706); // Ambra
      difficultyBg = const Color(0xFFFEF3C7);
    } else {
      difficultyLabel = 'Superiore (L$depth)';
      difficultyColor = const Color(0xFF7C3AED); // Viola profondo
      difficultyBg = const Color(0xFFF3E8FF);
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NodeDetailScreen(node: node, isar: widget.isar),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x04000000),
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              // Indicatore colorato della categoria
              Container(
                width: 6,
                height: 38,
                decoration: BoxDecoration(
                  color: catStyle.primary,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge sottocategoria (se appiattito) e badge difficoltà crescente
                    Row(
                      children: [
                        if (subCategoryBadge != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              subCategoryBadge,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: difficultyBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            difficultyLabel,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: difficultyColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      node.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          node.serverId,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF94A3B8),
                            fontFamily: 'monospace',
                          ),
                        ),
                        if (hasProof) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.menu_book_rounded,
                                  size: 10,
                                  color: Color(0xFF64748B),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  'Teoria',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (hasInteractive) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFFBFDBFE)),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.tune_rounded,
                                  size: 10,
                                  color: Color(0xFF2563EB),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  'Laboratorio',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Color(0xFF2563EB),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Delegate per mantenere il TabBar pinned durante lo scroll
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height + 8;

  @override
  double get maxExtent => tabBar.preferredSize.height + 8;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
