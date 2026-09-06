import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../data/catalog/curriculum_registry.dart';
import '../../data/repositories/node_repository.dart';
import '../../domain/models/knowledge_node.dart';
import '../widgets/category_style.dart';
import 'node_detail_screen.dart';

/// Schermata di esplorazione gerarchica delle conoscenze didattiche.
/// Organizza l'albero delle competenze secondo la struttura:
/// Categoria (Materia) -> Sottocategoria (Argomento/Capitolo) -> Nodi Concettuali (Lezioni/Teoremi).
class CategoryExplorerScreen extends StatefulWidget {
  final Isar? isar;
  final VoidCallback? onRefreshRequested;

  const CategoryExplorerScreen({super.key, this.isar, this.onRefreshRequested});

  @override
  State<CategoryExplorerScreen> createState() => _CategoryExplorerScreenState();
}

class _CategoryExplorerScreenState extends State<CategoryExplorerScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<KnowledgeNode> _allNodes = [];

  // Mappa gerarchica: Categoria -> Sottocategoria -> Lista di Nodi
  Map<String, Map<String, List<KnowledgeNode>>> _groupedData = {};

  @override
  void initState() {
    super.initState();
    _loadNodes();
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

      final Map<String, Map<String, List<KnowledgeNode>>> tree = {};

      for (final node in nodes) {
        final category = node.category.trim().isEmpty
            ? 'Generale'
            : node.category.trim();
        final subCategory =
            (node.subCategory == null || node.subCategory!.trim().isEmpty)
            ? 'Concetti Fondamentali'
            : node.subCategory!.trim();

        tree.putIfAbsent(category, () => {});
        tree[category]!.putIfAbsent(subCategory, () => []);
        tree[category]![subCategory]!.add(node);
      }

      // Ordina i nodi all'interno delle sottocategorie per serverId o titolo
      for (final cat in tree.keys) {
        for (final subCat in tree[cat]!.keys) {
          tree[cat]![subCat]!.sort((a, b) => a.serverId.compareTo(b.serverId));
        }
      }

      setState(() {
        _allNodes = nodes;
        _groupedData = tree;
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
              'Organizzazione catalogo per categorie...',
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

    if (_groupedData.isEmpty) {
      return const Center(
        child: Text(
          'Nessun contenuto disponibile nel catalogo.',
          style: TextStyle(color: Color(0xFF64748B)),
        ),
      );
    }

    final categories = _groupedData.keys.toList();

    return RefreshIndicator(
      onRefresh: _loadNodes,
      color: const Color(0xFF2563EB),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildHeaderHero();
          }

          final categoryName = categories[index - 1];
          final subCategories = _groupedData[categoryName]!;
          return _buildCategoryCard(categoryName, subCategories);
        },
      ),
    );
  }

  Widget _buildHeaderHero() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
                      'Curriculum strutturato ad albero logico',
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
          const SizedBox(height: 14),
          const Text(
            'Esplora i teoremi, le dimostrazioni algebriche e i laboratori interattivi organizzati per materia e sottocategoria.',
            style: TextStyle(
              color: Color(0xFFCBD5E1),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    String categoryName,
    Map<String, List<KnowledgeNode>> subCategories,
  ) {
    final catStyle = CategoryStyle.forCategory(categoryName);
    final totalNodes = subCategories.values.fold<int>(
      0,
      (sum, list) => sum + list.length,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: false,
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: catStyle.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: catStyle.border),
              ),
              child: Icon(catStyle.icon, color: catStyle.primary, size: 22),
            ),
            title: Text(
              categoryName,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                letterSpacing: -0.2,
              ),
            ),
            subtitle: Text(
              '${subCategories.length} sezioni • $totalNodes concetti',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
            children: subCategories.entries.map((entry) {
              final subCategoryName = entry.key;
              final nodes = entry.value;
              return _buildSubCategoryTile(subCategoryName, nodes, catStyle);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSubCategoryTile(
    String subCategoryName,
    List<KnowledgeNode> nodes,
    CategoryStyle catStyle,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Material(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: false,
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 4,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            leading: const Icon(
              Icons.folder_outlined,
              size: 20,
              color: Color(0xFF64748B),
            ),
            title: Text(
              subCategoryName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
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

  Widget _buildNodeItem(KnowledgeNode node, CategoryStyle catStyle) {
    final hasProof = node.algebraicProof.isNotEmpty || node.blocks.isNotEmpty;
    final hasInteractive = node.interactiveData != null;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NodeDetailScreen(node: node)),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: catStyle.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      node.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4),
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
