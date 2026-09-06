import 'package:flutter/material.dart';

import '../../domain/models/knowledge_node.dart';
import '../widgets/algebraic_proof_widget.dart';

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
              if (node.algebraicProof.isNotEmpty)
                AlgebraicProofWidget(proofSteps: node.algebraicProof)
              else
                const Text(
                  'Nessun passaggio dimostrativo presente.',
                  style: TextStyle(color: Color(0xFF64748B)),
                ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
