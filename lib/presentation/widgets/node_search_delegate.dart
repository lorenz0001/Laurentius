import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../core/theme/app_theme.dart';
import '../../data/catalog/curriculum_registry.dart';
import '../../domain/models/knowledge_node.dart';
import '../pages/node_detail_screen.dart';
import 'category_style.dart';

/// Delegato di ricerca globale per i nodi di conoscenza di Brilliant-OS.
/// Cerca per titolo, categoria o sottocategoria sia su Isar sia in memoria.
class GlobalNodeSearchDelegate extends SearchDelegate<KnowledgeNode?> {
  final Isar? isar;
  final List<KnowledgeNode>? preloadedNodes;

  GlobalNodeSearchDelegate({this.isar, this.preloadedNodes});

  @override
  String? get searchFieldLabel => 'Cerca per titolo, categoria o formula...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return AppTheme.darkTheme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppTheme.bgDark,
        elevation: 0,
        scrolledUnderElevation: 1,
        iconTheme: IconThemeData(color: AppTheme.textPrimary),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          tooltip: 'Cancella',
          icon: const Icon(Icons.clear_rounded, color: AppTheme.textSecondary),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Indietro',
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 20,
        color: AppTheme.textPrimary,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final cleanQuery = query.trim().toLowerCase();

    // Recupero della lista di nodi di base
    final List<KnowledgeNode> pool =
        preloadedNodes ??
        (isar != null
            ? isar!.knowledgeNodes.where().findAllSync()
            : CurriculumRegistry.getAllNodes());

    if (cleanQuery.isEmpty) {
      return _buildEmptyPrompt();
    }

    // Filtraggio per titolo, categoria e sottocategoria
    final matches = pool.where((node) {
      final titleMatch = node.title.toLowerCase().contains(cleanQuery);
      final catMatch = node.category.toLowerCase().contains(cleanQuery);
      final subCatMatch =
          node.subCategory != null &&
          node.subCategory!.toLowerCase().contains(cleanQuery);
      final idMatch = node.serverId.toLowerCase().contains(cleanQuery);
      return titleMatch || catMatch || subCatMatch || idMatch;
    }).toList();

    if (matches.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  size: 40,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Nessun risultato per "$query"',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Prova a cercare termini come "Derivata", "Pitagora", "Ohm", "Matematica" o "Fisica".',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: matches.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final node = matches[index];
        final catStyle = CategoryStyle.forCategory(node.category);

        return Material(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NodeDetailScreen(node: node, isar: isar),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.borderDark),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: catStyle.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: catStyle.border),
                    ),
                    child: Icon(
                      catStyle.icon,
                      color: catStyle.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: catStyle.background,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                node.category.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  color: catStyle.primary,
                                ),
                              ),
                            ),
                            if (node.subCategory != null &&
                                node.subCategory!.isNotEmpty) ...[
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  '• ${node.subCategory}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          node.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppTheme.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyPrompt() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SUGGERIMENTI DI RICERCA',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQueryChip('Matematica'),
              _buildQueryChip('Fisica'),
              _buildQueryChip('Elettrotecnica'),
              _buildQueryChip('Teorema di Pitagora'),
              _buildQueryChip('Legge di Ohm'),
              _buildQueryChip('Derivate'),
              _buildQueryChip('Integrali'),
              _buildQueryChip('Cinematica'),
              _buildQueryChip('Logaritmi'),
              _buildQueryChip('Trigonometria'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQueryChip(String label) {
    return ActionChip(
      label: Text(label),
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
      ),
      backgroundColor: AppTheme.surfaceElevated,
      side: const BorderSide(color: AppTheme.borderDark),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () {
        query = label;
      },
    );
  }
}
