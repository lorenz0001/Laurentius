import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/models/knowledge_node.dart';
import '../pages/node_detail_screen.dart';
import 'category_style.dart';

/// Widget per la visualizzazione e navigazione dei prerequisiti e collegamenti interdisciplinari
/// in stile Wikipedia Mobile Dark Mode.
class PrerequisitesSectionWidget extends StatelessWidget {
  final KnowledgeNode currentNode;
  final List<KnowledgeNode>? prerequisites;
  final Isar? isar;

  const PrerequisitesSectionWidget({
    super.key,
    required this.currentNode,
    this.prerequisites,
    this.isar,
  });

  @override
  Widget build(BuildContext context) {
    final prereqs = prerequisites ?? currentNode.prerequisites.toList();

    if (prereqs.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderDark, width: 0.8),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.flag_circle_outlined,
              size: 16,
              color: AppTheme.textSecondary,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Concetto fondamentale di partenza (nessun prerequisito)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.account_tree_outlined,
              size: 16,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              'PREREQUISITI & COLLEGAMENTI (${prereqs.length})',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...prereqs.map((prereq) => _buildPrereqCard(context, prereq)),
      ],
    );
  }

  Widget _buildPrereqCard(BuildContext context, KnowledgeNode prereq) {
    final isCrossSubject =
        prereq.category.trim().toLowerCase() !=
        currentNode.category.trim().toLowerCase();
    final catStyle = CategoryStyle.forCategory(prereq.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCrossSubject ? catStyle.border : AppTheme.borderDark,
          width: isCrossSubject ? 1.2 : 0.9,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NodeDetailScreen(node: prereq, isar: isar),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Icona Materia
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: catStyle.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: catStyle.border, width: 0.8),
                  ),
                  child: Icon(catStyle.icon, size: 16, color: catStyle.primary),
                ),
                const SizedBox(width: 12),

                // Testo e Titolo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isCrossSubject) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: catStyle.background,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'INTERDISCIPLINARE • ${prereq.category.toUpperCase()}',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: catStyle.primary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            prereq.serverId,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppTheme.textMuted,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        prereq.title,
                        style: const TextStyle(
                          fontSize: 14,
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
                  size: 13,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
