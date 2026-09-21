import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/catalog/university_glossary_catalog.dart';
import '../../../data/catalog/university_linear_algebra_course.dart';
import '../../../domain/models/university_course_model.dart';
import '../../widgets/math_markdown_view.dart';
import 'university_term_screen.dart';

/// Schermata di visualizzazione della Lezione Universitaria.
/// Dotata di:
/// - AppBar superiore con pulsante "← Torna al Corso".
/// - Riquadro introduttivo con livello di importanza (codice colore del professore).
/// - Barra dei termini chiave cliccabili.
/// - Rendering MathMarkdownView con KaTeX e termini ipertestuali interattivi.
/// - Pulsanti inferiori di navigazione sequenziale tra lezioni.
class UniversityLectureScreen extends StatefulWidget {
  final UniversityLecture lecture;

  const UniversityLectureScreen({
    super.key,
    required this.lecture,
  });

  @override
  State<UniversityLectureScreen> createState() => _UniversityLectureScreenState();
}

class _UniversityLectureScreenState extends State<UniversityLectureScreen> {
  final ScrollController _scrollController = ScrollController();

  void _openTerm(String termId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UniversityTermScreen(
          termId: termId,
          previousContextTitle: 'Lezione ${widget.lecture.number}',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lecture = widget.lecture;
    final colorCode = lecture.defaultColor;

    final allLectures = UniversityLinearAlgebraCourse.course.chapters.first.lectures;
    final currentIndex = allLectures.indexWhere((l) => l.id == lecture.id);
    final prevLecture = currentIndex > 0 ? allLectures[currentIndex - 1] : null;
    final nextLecture = currentIndex >= 0 && currentIndex < allLectures.length - 1
        ? allLectures[currentIndex + 1]
        : null;

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: AppTheme.bgDark,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          tooltip: 'Torna alla lista delle lezioni',
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Geometria e Algebra Lineare (PoliMi)',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Lezione ${lecture.number}: ${lecture.title}',
              style: const TextStyle(
                fontSize: 15,
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
              color: colorCode.color.withAlpha(35),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colorCode.color.withAlpha(120), width: 0.8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 8, color: colorCode.color),
                const SizedBox(width: 6),
                Text(
                  colorCode.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: colorCode.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner informativo sulla lezione
            _buildLectureHeaderCard(lecture),
            const SizedBox(height: 14),

            // Barra dei termini chiave con scorciatoie cliccabili
            _buildKeyTermsSection(lecture),
            const SizedBox(height: 18),

            // Corpo principale della lezione in MathMarkdownView con link cliccabili
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF13171F),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF262D38)),
              ),
              child: MathMarkdownView(
                text: lecture.markdownContent,
                onTermTap: _openTerm,
              ),
            ),
            const SizedBox(height: 24),

            // Barra di navigazione sequenziale inferiore
            _buildBottomNavigationRow(prevLecture, nextLecture),
          ],
        ),
      ),
    );
  }

  Widget _buildLectureHeaderCard(UniversityLecture lecture) {
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withAlpha(40),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF38BDF8).withAlpha(100)),
                ),
                child: Text(
                  'SEZIONE ${lecture.number}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF38BDF8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  lecture.pageRange,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFCBD5E1),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.timer_outlined, size: 14, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 4),
                  Text(
                    '~${lecture.estimatedMinutes} min',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            lecture.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            lecture.subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF94A3B8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyTermsSection(UniversityLecture lecture) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.touch_app_outlined, size: 14, color: Color(0xFF38BDF8)),
              SizedBox(width: 6),
              Text(
                'TERMINI CHIAVE (PREMI PER APPROFONDIRE CON DIAGRAMMI VISIVI)',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: Color(0xFF38BDF8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: lecture.keyTermIds.map((termId) {
              final term = UniversityGlossaryCatalog.getTerm(termId);
              final label = term != null ? term.name : termId;

              return ActionChip(
                backgroundColor: const Color(0xFF1E293B),
                side: const BorderSide(color: Color(0xFF334155), width: 0.8),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                label: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF1F5F9),
                  ),
                ),
                onPressed: () => _openTerm(termId),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationRow(UniversityLecture? prev, UniversityLecture? next) {
    return Row(
      children: [
        if (prev != null)
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                side: const BorderSide(color: Color(0xFF334155)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.arrow_back_rounded, size: 16, color: Colors.white),
              label: Text(
                'Lez. ${prev.number}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UniversityLectureScreen(lecture: prev),
                  ),
                );
              },
            ),
          )
        else
          const Spacer(),
        const SizedBox(width: 12),
        if (next != null)
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              label: Text(
                'Lez. ${next.number} →',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UniversityLectureScreen(lecture: next),
                  ),
                );
              },
            ),
          )
        else
          const Spacer(),
      ],
    );
  }
}
