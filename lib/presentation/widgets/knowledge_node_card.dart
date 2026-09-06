import 'package:flutter/material.dart';

import '../../domain/models/knowledge_node.dart';
import '../pages/node_detail_screen.dart';
import 'category_style.dart';

/// Card interattiva per la visualizzazione di un singolo nodo nel Knowledge Graph.
/// Presenta codice cromatico per materia, indicatori di prerequisiti e tipo di laboratorio.
class KnowledgeNodeCard extends StatelessWidget {
  final KnowledgeNode node;

  const KnowledgeNodeCard({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    final catStyle = CategoryStyle.forCategory(node.category);
    final prereqs = node.prerequisites.toList();

    // Determina il tipo di laboratorio / interattività
    final templateType = node.interactiveData?.templateType;
    final isSimulation =
        templateType != null && templateType != 'live_equation';
    final isLiveEquation = templateType == 'live_equation';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NodeDetailScreen(node: node)),
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 230,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: catStyle.border, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Badge Categoria e icona materia
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: catStyle.background,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            catStyle.icon,
                            size: 12,
                            color: catStyle.primary,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              node.category.toUpperCase(),
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                                color: catStyle.primary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Titolo del nodo
              Text(
                node.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                  height: 1.25,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Badge per Prerequisiti interdisciplinari se presenti
              if (prereqs.isNotEmpty) ...[
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: prereqs.take(2).map((p) {
                    final pStyle = CategoryStyle.forCategory(p.category);
                    final isCross =
                        p.category.toLowerCase() != node.category.toLowerCase();
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isCross
                            ? pStyle.background
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isCross
                              ? pStyle.border
                              : const Color(0xFFE2E8F0),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        'req: ${p.title}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isCross
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isCross
                              ? pStyle.primary
                              : const Color(0xFF475569),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
              ],

              // Dettaglio footer (Simulazione / Lab / Dimostrazione)
              Row(
                children: [
                  Icon(
                    isSimulation
                        ? Icons.electric_bolt_rounded
                        : isLiveEquation
                        ? Icons.tune_rounded
                        : Icons.menu_book_outlined,
                    size: 13,
                    color: isSimulation
                        ? const Color(0xFF2563EB)
                        : isLiveEquation
                        ? const Color(0xFF059669)
                        : const Color(0xFF64748B),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      isSimulation
                          ? 'Simulatore Interattivo'
                          : isLiveEquation
                          ? 'Lab Interattivo'
                          : '${node.algebraicProof.length} passaggi algebrici',
                      style: TextStyle(
                        fontSize: 11,
                        color: isSimulation
                            ? const Color(0xFF2563EB)
                            : isLiveEquation
                            ? const Color(0xFF059669)
                            : const Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
