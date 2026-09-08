import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../data/catalog/curriculum_registry.dart';
import '../../data/repositories/node_repository.dart';
import '../../domain/models/knowledge_node.dart';
import '../widgets/category_style.dart';
import 'node_detail_screen.dart';

/// Schermata di esplorazione catalogo didattico organizzata per macro-materie
/// (Matematica, Fisica, Elettrotecnica) e filtrabile per livelli di difficoltà:
/// Fondamenti, Intermedio, Avanzato, Superiore.
class CategoryExplorerScreen extends StatefulWidget {
  final Isar? isar;
  final VoidCallback? onRefreshRequested;

  const CategoryExplorerScreen({
    super.key,
    this.isar,
    this.onRefreshRequested,
  });

  @override
  State<CategoryExplorerScreen> createState() => _CategoryExplorerScreenState();
}

class _CategoryExplorerScreenState extends State<CategoryExplorerScreen>
    with TickerProviderStateMixin {
  Map<String, int> _nodeDepths = {};
  Map<String, List<KnowledgeNode>> _categoryNodes = {};
  List<String> _categories = [];

  TabController? _tabController;
  String _selectedDifficulty = 'Tutti'; // Tutti, Fondamenti, Intermedio, Avanzato, Superiore

  bool _isLoading = true;
  String? _errorMessage;

  // Traccia le cartellette di sotto-argomenti compresse/chiuse dall'utente.
  // Di default sono tutte espanse per visualizzazione immediata.
  final Set<String> _collapsedFolders = {};

  // Ordine preferito delle macro-materie
  static const List<String> _preferredOrder = [
    'Matematica',
    'Fisica',
    'Elettrotecnica',
    'Chimica',
  ];

  static const List<String> _difficultyFilters = [
    'Tutti',
    'Fondamenti',
    'Intermedio',
    'Avanzato',
    'Superiore',
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

  /// Calcola ricorsivamente la profondità topologica nel DAG all'interno della stessa materia
  int _calculateDepth(
    String serverId,
    Map<String, List<String>> prereqMap,
    Map<String, String> nodeCategoryMap, [
    Set<String>? visited,
  ]) {
    visited ??= {};
    if (visited.contains(serverId)) return 0; // Protezione contro cicli
    visited.add(serverId);

    final currentCategory = nodeCategoryMap[serverId] ?? '';
    final allPrereqs = prereqMap[serverId] ?? [];
    // Considera le dipendenze intra-materia per determinare la progressione didattica
    final categoryPrereqs = allPrereqs
        .where((p) => (nodeCategoryMap[p] ?? '') == currentCategory)
        .toList();

    if (categoryPrereqs.isEmpty) return 0; // Nodo fondamento di base della materia

    int maxParentDepth = 0;
    for (final parent in categoryPrereqs) {
      final d = _calculateDepth(parent, prereqMap, nodeCategoryMap, visited);
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

      final Map<String, String> nodeCategoryMap = {
        for (final n in nodes)
          n.serverId: n.category.trim().isEmpty ? 'Matematica' : n.category.trim(),
      };

      // 1. Calcola la profondità nel DAG per ciascun nodo
      final Map<String, int> depths = {};
      final prereqMap = CurriculumRegistry.prerequisiteMap;
      for (final node in nodes) {
        depths[node.serverId] = _calculateDepth(
          node.serverId,
          prereqMap,
          nodeCategoryMap,
        );
      }

      // 2. Raggruppa per Categoria (Macro-sezione)
      final Map<String, List<KnowledgeNode>> categoryMap = {};

      for (final node in nodes) {
        final category = node.category.trim().isEmpty
            ? 'Matematica'
            : node.category.trim();

        categoryMap.putIfAbsent(category, () => []);
        categoryMap[category]!.add(node);
      }

      // 3. Ordina i nodi per difficoltà strettamente crescente (profondità DAG)
      for (final cat in categoryMap.keys) {
        categoryMap[cat]!.sort((a, b) {
          final depthA = depths[a.serverId] ?? 0;
          final depthB = depths[b.serverId] ?? 0;
          if (depthA != depthB) return depthA.compareTo(depthB);
          return a.title.compareTo(b.title);
        });
      }

      // 4. Ordina le categorie secondo l'ordine didattico preferito
      final categories = categoryMap.keys.toList();
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
        _nodeDepths = depths;
        _categoryNodes = categoryMap;
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

  /// Determina il livello di difficoltà del nodo in base alla sua posizione didattica
  String _getDifficulty(KnowledgeNode node) {
    final depth = _nodeDepths[node.serverId] ?? 0;
    final cat = node.category.trim();
    if (cat == 'Matematica') {
      if (depth <= 1) return 'Fondamenti';
      if (depth <= 4) return 'Intermedio';
      if (depth <= 7) return 'Avanzato';
      return 'Superiore';
    } else {
      if (depth == 0) return 'Fondamenti';
      if (depth == 1) return 'Intermedio';
      if (depth == 2) return 'Avanzato';
      return 'Superiore';
    }
  }

  (Color, Color) _getDifficultyColors(String difficulty) {
    switch (difficulty) {
      case 'Fondamenti':
        return (const Color(0xFF4ADE80), const Color(0xFF143820));
      case 'Intermedio':
        return (const Color(0xFF38BDF8), const Color(0xFF0C2A40));
      case 'Avanzato':
        return (const Color(0xFFFBBF24), const Color(0xFF3B2805));
      case 'Superiore':
      default:
        return (const Color(0xFFA78BFA), const Color(0xFF281845));
    }
  }

  bool _matchesDifficulty(KnowledgeNode node) {
    if (_selectedDifficulty == 'Tutti') return true;
    return _getDifficulty(node) == _selectedDifficulty;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF60A5FA)),
            SizedBox(height: 16),
            Text(
              'Organizzazione catalogo didattico...',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
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
                color: Color(0xFFEF4444),
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
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

    if (_categoryNodes.isEmpty || _categories.isEmpty) {
      return const Center(
        child: Text(
          'Nessun contenuto disponibile nel catalogo.',
          style: TextStyle(color: Color(0xFF94A3B8)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF101214),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // Header persistente con Tab delle Materie e Barra Filtri Difficoltà
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverHeaderWithFiltersDelegate(
                tabBar: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: const Color(0xFF60A5FA),
                  unselectedLabelColor: const Color(0xFF94A3B8),
                  indicatorColor: const Color(0xFF60A5FA),
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
                    final nodes = _categoryNodes[category] ?? [];
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
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${nodes.length}',
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
                difficultyFilterBar: _buildDifficultyFilterRow(),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: _categories.map((category) {
            final allCategoryNodes = _categoryNodes[category] ?? [];
            final filteredNodes = allCategoryNodes.where(_matchesDifficulty).toList();
            return _buildCategoryNodeListView(category, filteredNodes);
          }).toList(),
        ),
      ),
    );
  }

  /// Barra orizzontale dei filtri di difficoltà richiesta dall'utente
  Widget _buildDifficultyFilterRow() {
    return ListView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      children: _difficultyFilters.map((diff) {
        final isSelected = _selectedDifficulty == diff;
        Color activeBg = const Color(0xFF2563EB);
        Color activeTextColor = Colors.white;

        if (diff == 'Fondamenti') {
          activeBg = const Color(0xFF16A34A);
        } else if (diff == 'Intermedio') {
          activeBg = const Color(0xFF0284C7);
        } else if (diff == 'Avanzato') {
          activeBg = const Color(0xFFD97706);
        } else if (diff == 'Superiore') {
          activeBg = const Color(0xFF7C3AED);
        }

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Text(diff),
            selected: isSelected,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onSelected: (selected) {
              setState(() {
                _selectedDifficulty = diff;
              });
            },
            backgroundColor: const Color(0xFF191C20),
            selectedColor: activeBg,
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? activeTextColor : const Color(0xFF94A3B8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: isSelected ? activeBg : const Color(0xFF2D3238),
                width: isSelected ? 1.5 : 1.0,
              ),
            ),
            elevation: isSelected ? 1 : 0,
          ),
        );
      }).toList(),
    );
  }

  /// Vista a lista pulita e chiara dei nodi della categoria corrente
  Widget _buildCategoryNodeListView(
    String categoryName,
    List<KnowledgeNode> nodes,
  ) {
    final catStyle = CategoryStyle.forCategory(categoryName);

    if (nodes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.filter_list_off_rounded, size: 40, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              'Nessun argomento per il livello "$_selectedDifficulty".',
              style: const TextStyle(fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedDifficulty = 'Tutti';
                });
              },
              child: const Text('Mostra tutti i livelli'),
            ),
          ],
        ),
      );
    }

    // 1. Raggruppa i nodi per sotto-argomento (subCategory) preservando l'ordine
    final Map<String, List<KnowledgeNode>> subGroups = {};
    for (final node in nodes) {
      final sub = (node.subCategory != null && node.subCategory!.trim().isNotEmpty)
          ? node.subCategory!.trim()
          : node.category;
      subGroups.putIfAbsent(sub, () => []).add(node);
    }

    return RefreshIndicator(
      onRefresh: _loadNodes,
      color: const Color(0xFF2563EB),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        children: [
          for (final entry in subGroups.entries)
            if (entry.value.length > 1)
              _buildSubCategoryFolderCard(entry.key, entry.value, catStyle)
            else
              _buildCleanNodeCard(entry.value.first, catStyle),
        ],
      ),
    );
  }

  /// Widget Cartelletta per sotto-argomenti con più di 1 argomento.
  Widget _buildSubCategoryFolderCard(
    String subCategoryTitle,
    List<KnowledgeNode> subNodes,
    CategoryStyle catStyle,
  ) {
    final isCollapsed = _collapsedFolders.contains(subCategoryTitle);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Sottocategoria / Cartelletta compatto e pulito
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                setState(() {
                  if (isCollapsed) {
                    _collapsedFolders.remove(subCategoryTitle);
                  } else {
                    _collapsedFolders.add(subCategoryTitle);
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: Row(
                  children: [
                    // Icona Cartella coordinata
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: catStyle.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isCollapsed
                            ? Icons.folder_rounded
                            : Icons.folder_open_rounded,
                        color: catStyle.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Titolo sotto-argomento
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              subCategoryTitle,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFF8FAFC),
                                letterSpacing: -0.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: catStyle.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'CARTELLETTA',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                                color: catStyle.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(${subNodes.length})',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Icona freccia
                    Icon(
                      isCollapsed
                          ? Icons.keyboard_arrow_down_rounded
                          : Icons.keyboard_arrow_up_rounded,
                      color: const Color(0xFF94A3B8),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Se espansa: lista diretta delle card dei singoli argomenti senza indentazione pesante
          if (!isCollapsed)
            ...subNodes
                .map((node) => _buildCleanNodeCard(node, catStyle)),
        ],
      ),
    );
  }

  /// Card pulita in stile Brilliant: titolo grande e leggibile, badge sottocategoria,
  /// indicatore livello di padronanza e badge visibile per laboratori interattivi.
  Widget _buildCleanNodeCard(
    KnowledgeNode node,
    CategoryStyle catStyle,
  ) {
    final hasInteractive = node.interactiveData != null;
    final hasProof = node.algebraicProof.isNotEmpty;
    final subCategory = (node.subCategory != null && node.subCategory!.isNotEmpty)
        ? node.subCategory!
        : node.category;

    // Colori e denominazione del livello didattico
    final difficultyName = _getDifficulty(node);
    final (difficultyColor, difficultyBg) = _getDifficultyColors(difficultyName);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF191C20),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2D3238)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NodeDetailScreen(node: node, isar: widget.isar),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Indicatore colorato della materia
                Container(
                  width: 5,
                  height: 52,
                  decoration: BoxDecoration(
                    color: catStyle.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 14),

                // Contenuto principale del nodo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Riga Superiore: Badge Sottocategoria e Livello
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22262B),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              subCategory,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: difficultyBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: difficultyColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    difficultyName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: difficultyColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Titolo dell'argomento in grande e nitido
                      Text(
                        node.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF8FAFC),
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Riga Inferiore: Badge per Laboratorio Interattivo e Teoria
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (hasInteractive) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFF3B82F6)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.tune_rounded,
                                    size: 13,
                                    color: Color(0xFF60A5FA),
                                  ),
                                  SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      'Laboratorio Interattivo',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF60A5FA),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (hasProof) ...[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.menu_book_outlined,
                                  size: 12,
                                  color: Color(0xFF94A3B8),
                                ),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    '${node.algebraicProof.length} passaggi',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF94A3B8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Delegate per mantenere il TabBar e la barra di filtri pinned durante lo scroll
class _SliverHeaderWithFiltersDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Widget difficultyFilterBar;

  _SliverHeaderWithFiltersDelegate({
    required this.tabBar,
    required this.difficultyFilterBar,
  });

  static const double _headerHeight = 104.0;

  @override
  double get minExtent => _headerHeight;

  @override
  double get maxExtent => _headerHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: _headerHeight,
      decoration: const BoxDecoration(
        color: Color(0xFF101214),
        border: Border(
          bottom: BorderSide(color: Color(0xFF2D3238)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          tabBar,
          Expanded(
            child: difficultyFilterBar,
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverHeaderWithFiltersDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar ||
        difficultyFilterBar != oldDelegate.difficultyFilterBar;
  }
}
