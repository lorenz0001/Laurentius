import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../domain/models/knowledge_node.dart';
import '../widgets/ai_rephrase_bottom_sheet.dart';
import '../widgets/ai_tutor_qna_bottom_sheet.dart';
import '../widgets/algebraic_proof_widget.dart';
import '../widgets/category_style.dart';
import '../widgets/content_block_factory.dart';
import '../widgets/interactive/interactive_template_factory.dart';
import '../widgets/prerequisites_section_widget.dart';
import 'exercise_screen.dart';

/// Schermata di dettaglio del nodo di conoscenza.
/// Presenta: collegamenti interdisciplinari e prerequisiti, passaggi di dimostrazione algebrica,
/// laboratori o simulazioni interattive, rielaborazione con AI (matita) e Q&A tutor (punto interrogativo).
class NodeDetailScreen extends StatefulWidget {
  final KnowledgeNode node;
  final Isar? isar;
  final String? targetProofGroup;
  final int? targetStepIndex;
  final String? targetCorollary;
  final bool autoUnlockProof;

  const NodeDetailScreen({
    super.key,
    required this.node,
    this.isar,
    this.targetProofGroup,
    this.targetStepIndex,
    this.targetCorollary,
    this.autoUnlockProof = false,
  });

  @override
  State<NodeDetailScreen> createState() => _NodeDetailScreenState();
}

class _NodeDetailScreenState extends State<NodeDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _proofSectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.targetProofGroup != null ||
        widget.targetStepIndex != null ||
        widget.targetCorollary != null ||
        widget.autoUnlockProof) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final proofCtx = _proofSectionKey.currentContext;
        if (proofCtx != null && mounted) {
          Scrollable.ensureVisible(
            proofCtx,
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeInOutCubic,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  void _openAIRephraseModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AIRephraseBottomSheet(
        node: widget.node,
        isar: widget.isar,
        onApplied: () {
          setState(() {});
        },
      ),
    );
  }

  void _openAITutorQnAModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AITutorQnABottomSheet(node: widget.node),
    );
  }

  @override
  Widget build(BuildContext context) {
    final node = widget.node;
    final catStyle = CategoryStyle.forCategory(node.category);
    final interactiveWidget = InteractiveTemplateFactory.buildWidget(
      node.interactiveData,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(catStyle.icon, size: 16, color: catStyle.primary),
            const SizedBox(width: 6),
            Text(
              node.category,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: catStyle.primary,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          // Tasto Matita: Rielaborazione / Semplificazione AI del testo e passaggi
          IconButton(
            tooltip: 'Rielabora o semplifica testo con AI',
            icon: const Icon(Icons.edit_note_rounded, color: Color(0xFF0284C7)),
            onPressed: _openAIRephraseModal,
          ),
          // Tasto Punto Interrogativo: Chiedi chiarimenti all'AI Tutor
          IconButton(
            tooltip: 'Chiedi chiarimenti all\'AI Tutor',
            icon: const Icon(
              Icons.help_outline_rounded,
              color: Color(0xFF7C3AED),
            ),
            onPressed: _openAITutorQnAModal,
          ),
          // Tasto Quiz: Mettiti alla prova
          IconButton(
            tooltip: 'Mettiti alla prova',
            icon: const Icon(Icons.quiz_outlined, color: Color(0xFF2563EB)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ExerciseScreen(node: node)),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge Categoria e Sottocategoria stilizzati
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: catStyle.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: catStyle.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(catStyle.icon, size: 12, color: catStyle.primary),
                        const SizedBox(width: 6),
                        Text(
                          node.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: catStyle.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (node.subCategory != null &&
                      node.subCategory!.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Text(
                        node.subCategory!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ],
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

              // Server ID
              Row(
                children: [
                  const Icon(
                    Icons.hub_outlined,
                    size: 15,
                    color: Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'ID Nodo: ${node.serverId}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Sezione Prerequisiti & Collegamenti Interdisciplinari
              PrerequisitesSectionWidget(currentNode: node, isar: widget.isar),
              const SizedBox(height: 20),

              const Divider(color: Color(0xFFE2E8F0), height: 1),
              const SizedBox(height: 24),

              // Sezione Blocchi Contenuto Ricco (Markdown, LaTeX, Info Box)
              if (node.effectiveBlocks.isNotEmpty) ...[
                const Row(
                  children: [
                    Icon(
                      Icons.auto_stories_rounded,
                      size: 18,
                      color: Color(0xFF334155),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'APPROFONDIMENTO TEORICO',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...node.effectiveBlocks.map(
                  (block) => ContentBlockFactory.buildBlock(block, context),
                ),
                const SizedBox(height: 16),
              ],

              // Sezione Dimostrazione Algebrica a passaggi separati (se definita esplicitamente e non vuota)
              if (node.algebraicProof.isNotEmpty) ...[
                const Row(
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 18,
                      color: Color(0xFF334155),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'DIMOSTRAZIONE LOGICO-ALGEBRICA',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AlgebraicProofWidget(
                  key: _proofSectionKey,
                  proofSteps: node.algebraicProof,
                  initialGroup: widget.targetProofGroup,
                  initialStepIndex: widget.targetStepIndex,
                  initialShowAll: widget.autoUnlockProof,
                  targetCorollary: widget.targetCorollary,
                ),
                const SizedBox(height: 28),
              ],

              // Sezione Laboratorio / Simulazione Interattiva (in fondo come culmine pratico)
              if (interactiveWidget != null) ...[
                const SizedBox(height: 12),
                interactiveWidget,
                const SizedBox(height: 28),
              ],

              // Invito Esercizio con AI Tutor
              _buildExercisePromptCard(node),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExercisePromptCard(KnowledgeNode node) {
    return Container(
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
                  'L\'AI genererà un quesito su misura basato su questo concetto e i suoi prerequisiti.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
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
    );
  }
}
