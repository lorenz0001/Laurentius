import 'package:flutter/material.dart';

import '../../domain/models/knowledge_node.dart';
import '../pages/node_detail_screen.dart';
import 'category_style.dart';

/// Widget per la visualizzazione e navigazione dei prerequisiti e collegamenti interdisciplinari.
class PrerequisitesSectionWidget extends StatelessWidget {
  final KnowledgeNode currentNode;
  final List<KnowledgeNode>? prerequisites;

  const PrerequisitesSectionWidget({
    super.key,
    required this.currentNode,
    this.prerequisites,
  });

  @override
  Widget build(BuildContext context) {
    final prereqs = prerequisites ?? currentNode.prerequisites.toList();

    if (prereqs.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.flag_circle_outlined, size: 16, color: Color(0xFF64748B)),
            SizedBox(width: 8),
            Text(
              'Concetto fondamentale di partenza (nessun prerequisito)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF475569),
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
            const Icon(Icons.account_tree_outlined, size: 16, color: Color(0xFF64748B)),
            const SizedBox(width: 8),
            Text(
              'PREREQUISITI & COLLEGAMENTI (${prereqs.length})',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: Color(0xFF475569),
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
    final isCrossSubject = prereq.category.trim().toLowerCase() !=
        currentNode.category.trim().toLowerCase();
    final catStyle = CategoryStyle.forCategory(prereq.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NodeDetailScreen(node: prereq),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isCrossSubject ? catStyle.border : const Color(0xFFE2E8F0),
                width: isCrossSubject ? 1.5 : 1.0,
              ),
              color: isCrossSubject ? catStyle.background.withValues(alpha: 0.35) : Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: catStyle.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(catStyle.icon, size: 16, color: catStyle.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isCrossSubject)
                        Container(
                          margin: const EdgeInsets.only(bottom: 3),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: catStyle.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'INTERDISCIPLINARE • ${prereq.category.toUpperCase()}',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4,
                              color: catStyle.primary,
                            ),
                          ),
                        ),
                      Text(
                        prereq.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
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
