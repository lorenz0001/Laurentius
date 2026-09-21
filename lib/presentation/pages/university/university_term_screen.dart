import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/catalog/university_glossary_catalog.dart';
import '../../../domain/models/university_course_model.dart';
import '../../widgets/university/term_visual_example_widget.dart';

/// Schermata di dettaglio per un termine matematico ipertestuale.
/// Fornisce:
/// - AppBar superiore con pulsante di ritorno ("← Torna indietro") e breadcrumb.
/// - Definizione sintetica e formula formale KaTeX.
/// - Esempio visuale statico dedicato (CustomPainter a diagrammi).
/// - Spiegazione didattica profonda del docente.
/// - Esempio concreto / controesempio.
/// - Termini correlati navigabili ipertestualmente.
class UniversityTermScreen extends StatelessWidget {
  final String termId;
  final String? previousContextTitle;

  const UniversityTermScreen({
    super.key,
    required this.termId,
    this.previousContextTitle,
  });

  @override
  Widget build(BuildContext context) {
    final term = UniversityGlossaryCatalog.getTerm(termId);

    if (term == null) {
      return Scaffold(
        backgroundColor: AppTheme.bgDark,
        appBar: AppBar(
          backgroundColor: AppTheme.bgDark,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Termine non trovato'),
        ),
        body: Center(
          child: Text(
            'Termine "$termId" non trovato nel glossario.',
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: AppTheme.bgDark,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          tooltip: 'Torna alla pagina precedente',
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (previousContextTitle != null)
              Text(
                '← $previousContextTitle',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            Text(
              term.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFFF1F5F9),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF334155), width: 0.8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bookmark_outline_rounded, size: 14, color: Color(0xFF38BDF8)),
                const SizedBox(width: 4),
                Text(
                  term.category,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF38BDF8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Intestazione Termine & Simbolo
            _buildHeaderCard(term),
            const SizedBox(height: 14),

            // Card Formula Formale KaTeX
            _buildFormalLatexCard(term),
            const SizedBox(height: 14),

            // Visualizzazione Grafica Statica Dedicata
            TermVisualExampleWidget(
              diagramType: term.visualType,
              title: 'Rappresentazione Visiva: ${term.name}',
            ),
            const SizedBox(height: 14),

            // Spiegazione Didattica e Pedagogica del Docente
            _buildExplanationSection(term),
            const SizedBox(height: 16),

            // Esempio / Controesempio Matematico
            _buildExampleCard(term),
            const SizedBox(height: 20),

            // Termini Correlati
            if (term.relatedTermIds.isNotEmpty)
              _buildRelatedTermsSection(context, term),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(UniversityTerm term) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withAlpha(40),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Color(0xFF38BDF8),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      term.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Simbolo / Notazione: ${term.symbol}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            term.shortDefinition,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFFE2E8F0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormalLatexCard(UniversityTerm term) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2563EB).withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.functions_rounded, size: 14, color: Color(0xFF60A5FA)),
              SizedBox(width: 6),
              Text(
                'DEFINIZIONE FORMALE (KATEX)',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: Color(0xFF60A5FA),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Math.tex(
                term.formalLatex,
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFFF8FAFC),
                  fontWeight: FontWeight.w600,
                ),
                mathStyle: MathStyle.display,
                onErrorFallback: (err) => Text(
                  term.formalLatex,
                  style: const TextStyle(fontFamily: 'monospace', color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationSection(UniversityTerm term) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, size: 16, color: Color(0xFFFBBF24)),
              SizedBox(width: 8),
              Text(
                'Spiegazione del Docente',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFBBF24),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            term.pedagogicalExplanation,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFFCBD5E1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(UniversityTerm term) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF10B981).withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle_outline_rounded, size: 16, color: Color(0xFF34D399)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  term.exampleTitle,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF34D399),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            term.exampleText,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFFE2E8F0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedTermsSection(BuildContext context, UniversityTerm term) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TERMINI CORRELATI',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: term.relatedTermIds.map((relId) {
            final relTerm = UniversityGlossaryCatalog.getTerm(relId);
            final label = relTerm != null ? relTerm.name : relId;

            return ActionChip(
              backgroundColor: const Color(0xFF1E293B),
              side: const BorderSide(color: Color(0xFF334155)),
              avatar: const Icon(Icons.link_rounded, size: 14, color: Color(0xFF38BDF8)),
              label: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF38BDF8),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UniversityTermScreen(
                      termId: relId,
                      previousContextTitle: term.name,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
