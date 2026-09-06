import 'package:flutter/material.dart';

import '../../domain/models/knowledge_node.dart';
import '../widgets/algebraic_proof_widget.dart';
import '../widgets/interactive/interactive_template_factory.dart';
import 'exercise_screen.dart';

class NodeDetailScreen extends StatefulWidget {
  final KnowledgeNode node;

  const NodeDetailScreen({
    super.key,
    required this.node,
  });

  @override
  State<NodeDetailScreen> createState() => _NodeDetailScreenState();
}

class _NodeDetailScreenState extends State<NodeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final node = widget.node;
    final interactiveWidget = InteractiveTemplateFactory.buildWidget(node.interactiveData);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
        title: Text(
          node.category,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Mettiti alla prova',
            icon: const Icon(Icons.quiz_outlined, color: Color(0xFF2563EB)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExerciseScreen(node: node),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Categoria badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  node.category.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Titolo del nodo in grande
              Text(
                node.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),

              // Server ID o info secondaria
              Row(
                children: [
                  const Icon(Icons.hub_outlined, size: 16, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 6),
                  Text(
                    'Nodo: ${node.serverId}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Divider sottile
              const Divider(color: Color(0xFFE2E8F0), height: 1),
              const SizedBox(height: 24),

              // Sezione Dimostrazione Algebrica
              if (node.algebraicProof.isNotEmpty) ...[
                AlgebraicProofWidget(proofSteps: node.algebraicProof),
                const SizedBox(height: 28),
              ] else
                const Text(
                  'Nessun passaggio dimostrativo presente.',
                  style: TextStyle(color: Color(0xFF64748B)),
                ),

              // Sezione Interattiva (Server-Driven UI tramite Factory)
              if (interactiveWidget != null) ...[
                interactiveWidget,
                const SizedBox(height: 32),
              ],

              // Card Invito Esercizio
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.psychology_rounded,
                        color: Color(0xFF2563EB),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Verifica la tua comprensione',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'L\'AI genererà un quesito su misura basato su questo concetto.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ExerciseScreen(node: node),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                            label: const Text(
                              'Mettiti alla Prova',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExerciseScreen(node: node),
            ),
          );
        },
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.psychology_outlined),
        label: const Text(
          'Mettiti alla Prova',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
