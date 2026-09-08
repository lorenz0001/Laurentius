import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/models/knowledge_node.dart';
import '../widgets/ai_rephrase_bottom_sheet.dart';
import '../widgets/ai_tutor_qna_bottom_sheet.dart';
import '../widgets/algebraic_proof_widget.dart';
import '../widgets/category_style.dart';
import '../widgets/content_block_factory.dart';
import '../widgets/interactive/interactive_template_factory.dart';
import '../widgets/prerequisites_section_widget.dart';
import 'exercise_screen.dart';

/// Schermata di dettaglio del nodo di conoscenza ispirata all'app mobile di Wikipedia in Dark Mode.
/// Presenta:
/// - Sfondo scuro e tipografia nitida ad alto contrasto.
/// - App bar e navigazione minimalisti senza distrazioni visive.
/// - Macro-sezioni organizzate in sezioni pulite, espandibili/collassabili (accordion):
///   1. Approfondimento teorico (Markdown arricchito, formule display KaTeX, box note)
///   2. Dimostrazione logico-algebrica (step-by-step, corollari ed equazioni)
///   3. Laboratorio / Simulazione interattiva (60fps reactive canvas e parametri)
/// - Scheda finale per la verifica attiva con AI Tutor.
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

  // Stati di espansione/collasso per le sezioni accordion in stile Wikipedia
  bool _isTheoryExpanded = true;
  bool _isProofExpanded = true;
  bool _isLabExpanded = true;

  @override
  void initState() {
    super.initState();

    final hasTarget = widget.targetProofGroup != null ||
        widget.targetStepIndex != null ||
        widget.targetCorollary != null ||
        widget.autoUnlockProof;

    if (hasTarget) {
      _isProofExpanded = true;
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
  void didUpdateWidget(covariant NodeDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    final hadTarget = oldWidget.targetProofGroup != null ||
        oldWidget.targetStepIndex != null ||
        oldWidget.targetCorollary != null ||
        oldWidget.autoUnlockProof;
    final hasTarget = widget.targetProofGroup != null ||
        widget.targetStepIndex != null ||
        widget.targetCorollary != null ||
        widget.autoUnlockProof;

    if (hasTarget &&
        (!hadTarget ||
            oldWidget.targetCorollary != widget.targetCorollary ||
            oldWidget.targetProofGroup != widget.targetProofGroup ||
            oldWidget.targetStepIndex != widget.targetStepIndex ||
            oldWidget.autoUnlockProof != widget.autoUnlockProof)) {
      setState(() {
        _isProofExpanded = true;
      });
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
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: AppTheme.bgDark,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
        title: Align(
          alignment: Alignment.centerLeft,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: catStyle.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: catStyle.border, width: 0.8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(catStyle.icon, size: 14, color: catStyle.primary),
                  const SizedBox(width: 6),
                  Text(
                    node.category,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: catStyle.primary,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
        centerTitle: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(color: AppTheme.borderDark, height: 1.0),
        ),
        actions: [
          // Tasto Matita: Rielaborazione / Semplificazione AI del testo
          IconButton(
            tooltip: 'Rielabora o semplifica testo con AI',
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.edit_note_rounded,
              color: AppTheme.accentBlueBright,
              size: 22,
            ),
            onPressed: _openAIRephraseModal,
          ),
          // Tasto Punto Interrogativo: Chiedi chiarimenti all'AI Tutor
          IconButton(
            tooltip: 'Chiedi chiarimenti all\'AI Tutor',
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.help_outline_rounded,
              color: AppTheme.accentPurpleBright,
              size: 22,
            ),
            onPressed: _openAITutorQnAModal,
          ),
          // Tasto Quiz: Mettiti alla prova
          IconButton(
            tooltip: 'Mettiti alla prova',
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.quiz_outlined,
              color: AppTheme.accentGreenBright,
              size: 21,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ExerciseScreen(node: node)),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lead Section: Badge Categoria e Sottocategoria
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: catStyle.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: catStyle.border, width: 0.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(catStyle.icon, size: 12, color: catStyle.primary),
                        const SizedBox(width: 5),
                        Text(
                          node.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            color: catStyle.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (node.subCategory != null &&
                      node.subCategory!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceElevated,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.borderDark, width: 0.8),
                      ),
                      child: Text(
                        node.subCategory!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Titolo dell'articolo in grande (Wikipedia Mobile Dark style)
              Text(
                node.title,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: AppTheme.textPrimary,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),

              // Server ID e metadati
              Row(
                children: [
                  const Icon(
                    Icons.hub_outlined,
                    size: 14,
                    color: AppTheme.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'ID Nodo: ${node.serverId}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Sezione Prerequisiti & Collegamenti Interdisciplinari (Lead)
              PrerequisitesSectionWidget(currentNode: node, isar: widget.isar),
              const SizedBox(height: 20),

              const Divider(color: AppTheme.borderDark, height: 1),
              const SizedBox(height: 20),

              // Macro-Sezione 1: Approfondimento Teorico (Accordion collassabile)
              if (node.effectiveBlocks.isNotEmpty) ...[
                _buildCollapsibleSection(
                  title: 'APPROFONDIMENTO TEORICO',
                  icon: Icons.auto_stories_rounded,
                  badgeText: '${node.effectiveBlocks.length} SEZIONI',
                  badgeColor: catStyle.primary,
                  isExpanded: _isTheoryExpanded,
                  onToggle: () {
                    setState(() {
                      _isTheoryExpanded = !_isTheoryExpanded;
                    });
                  },
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...node.effectiveBlocks.map(
                        (block) => ContentBlockFactory.buildBlock(block, context),
                      ),
                    ],
                  ),
                ),
              ],

              // Macro-Sezione 2: Dimostrazione Logico-Algebrica (Accordion collassabile)
              if (node.algebraicProof.isNotEmpty) ...[
                _buildCollapsibleSection(
                  key: _proofSectionKey,
                  title: 'DIMOSTRAZIONE LOGICO-ALGEBRICA',
                  icon: Icons.menu_book_rounded,
                  badgeText: '${node.algebraicProof.length} PASSAGGI',
                  badgeColor: AppTheme.accentPurpleBright,
                  isExpanded: _isProofExpanded,
                  onToggle: () {
                    setState(() {
                      _isProofExpanded = !_isProofExpanded;
                    });
                  },
                  content: AlgebraicProofWidget(
                    proofSteps: node.algebraicProof,
                    initialGroup: widget.targetProofGroup,
                    initialStepIndex: widget.targetStepIndex,
                    initialShowAll: widget.autoUnlockProof,
                    targetCorollary: widget.targetCorollary,
                  ),
                ),
              ],

              // Macro-Sezione 3: Laboratorio / Simulazione Interattiva (Accordion collassabile)
              if (interactiveWidget != null) ...[
                _buildCollapsibleSection(
                  title: 'LABORATORIO INTERATTIVO',
                  icon: Icons.tune_rounded,
                  badgeText: '60 FPS',
                  badgeColor: AppTheme.accentGreenBright,
                  isExpanded: _isLabExpanded,
                  onToggle: () {
                    setState(() {
                      _isLabExpanded = !_isLabExpanded;
                    });
                  },
                  content: interactiveWidget,
                ),
              ],

              // Invito Esercizio con AI Tutor
              _buildExercisePromptCard(node),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  /// Costruisce una macro-sezione collassabile/espandibile in stile Wikipedia Mobile
  Widget _buildCollapsibleSection({
    Key? key,
    required String title,
    required IconData icon,
    String? badgeText,
    Color? badgeColor,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget content,
  }) {
    final effectiveBadgeColor = badgeColor ?? AppTheme.accentBlueBright;

    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderDark, width: 1.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onToggle,
              splashColor: AppTheme.surfaceHighlight,
              highlightColor: AppTheme.surfaceElevated,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Icon(icon, size: 18, color: effectiveBadgeColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (badgeText != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: effectiveBadgeColor.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: effectiveBadgeColor.withValues(alpha: 0.32),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          badgeText,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                            color: effectiveBadgeColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeInOut,
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppTheme.textSecondary,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Offstage(
            offstage: !isExpanded,
            child: TickerMode(
              enabled: isExpanded,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Divider(color: AppTheme.borderDark, height: 16),
                    const SizedBox(height: 6),
                    content,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExercisePromptCard(KnowledgeNode node) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentBlueDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppTheme.accentBlueBright.withValues(alpha: 0.3),
                width: 0.8,
              ),
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: AppTheme.accentBlueBright,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Verifica la tua comprensione',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'L\'AI genererà un quesito su misura basato su questo concetto e i suoi prerequisiti.',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 12),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExerciseScreen(node: node),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_rounded, size: 15),
                    label: const Text(
                      'Mettiti alla Prova',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
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
