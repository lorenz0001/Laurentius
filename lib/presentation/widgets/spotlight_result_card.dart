import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../domain/models/spotlight_result.dart';

/// Card in stile Brilliant per i risultati di ricerca istantanea Spotlight.
/// Presenta: badge colorato per tipo (Corollario, Teorema, Formula, Definizione, Argomento),
/// breadcrumb di categoria, anteprima KaTeX LaTeX, snippet su 2 righe e indicatore di salto diretto <= 1 tap.
class SpotlightResultCard extends StatelessWidget {
  final SpotlightSearchResult result;
  final String query;
  final VoidCallback onTap;
  final bool isSelected;

  const SpotlightResultCard({
    super.key,
    required this.result,
    required this.query,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final typeBadge = _buildTypeBadge(result.type);
    final actionLabel = _getActionLabel(result.type);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF0F7FF) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
          width: isSelected ? 1.8 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? const Color(0x182563EB)
                : const Color(0x08000000),
            blurRadius: isSelected ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Riga superiore: Badge Tipo + Breadcrumb + Indicatore 1 Tap
                Row(
                  children: [
                    typeBadge,
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _buildBreadcrumb(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          actionLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? const Color(0xFF1D4ED8)
                                : const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 13,
                          color: isSelected
                              ? const Color(0xFF1D4ED8)
                              : const Color(0xFF2563EB),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Titolo del risultato con evidenziazione del match
                _buildHighlightedTitle(context),

                // Anteprima equazione LaTeX se presente
                if (result.latexFormula != null &&
                    result.latexFormula!.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFEDF2F7)),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Math.tex(
                        result.latexFormula!,
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF0F172A),
                        ),
                        onErrorFallback: (err) => Text(
                          result.latexFormula!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                // Snippet contestuale di 2 righe
                if (result.snippet.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    result.snippet.trim(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: Color(0xFF475569),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _buildBreadcrumb() {
    final sub = result.subCategory;
    if (sub != null && sub.isNotEmpty && sub != result.category) {
      return '${result.category} • $sub';
    }
    return result.category;
  }

  String _getActionLabel(SpotlightResultType type) {
    switch (type) {
      case SpotlightResultType.corollary:
      case SpotlightResultType.theorem:
        return 'Apri dimostrazione';
      case SpotlightResultType.formula:
        return 'Vedi formula';
      case SpotlightResultType.definition:
        return 'Vedi definizione';
      case SpotlightResultType.topic:
        return 'Apri argomento';
    }
  }

  Widget _buildTypeBadge(SpotlightResultType type) {
    Color bg;
    Color fg;
    Color border;
    IconData icon;
    String label;

    switch (type) {
      case SpotlightResultType.corollary:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFB45309);
        border = const Color(0xFFFDE68A);
        icon = Icons.star_rounded;
        label = 'COROLLARIO';
        break;
      case SpotlightResultType.theorem:
        bg = const Color(0xFFEFF6FF);
        fg = const Color(0xFF1D4ED8);
        border = const Color(0xFFBFDBFE);
        icon = Icons.bookmark_added_rounded;
        label = 'TEOREMA';
        break;
      case SpotlightResultType.formula:
        bg = const Color(0xFFDCFCE7);
        fg = const Color(0xFF15803D);
        border = const Color(0xFFBBF7D0);
        icon = Icons.functions_rounded;
        label = 'FORMULA';
        break;
      case SpotlightResultType.definition:
        bg = const Color(0xFFF3E8FF);
        fg = const Color(0xFF7C3AED);
        border = const Color(0xFFE9D5FF);
        icon = Icons.lightbulb_outline_rounded;
        label = 'DEFINIZIONE';
        break;
      case SpotlightResultType.topic:
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF334155);
        border = const Color(0xFFE2E8F0);
        icon = Icons.auto_stories_rounded;
        label = 'ARGOMENTO';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedTitle(BuildContext context) {
    final title = result.title;
    final cleanQuery = query.trim().toLowerCase();

    if (cleanQuery.isEmpty || !title.toLowerCase().contains(cleanQuery)) {
      return Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F172A),
          letterSpacing: -0.2,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    final spans = <TextSpan>[];
    final lowerTitle = title.toLowerCase();
    int start = 0;

    while (start < title.length) {
      final matchIndex = lowerTitle.indexOf(cleanQuery, start);
      if (matchIndex == -1) {
        spans.add(TextSpan(text: title.substring(start)));
        break;
      }
      if (matchIndex > start) {
        spans.add(TextSpan(text: title.substring(start, matchIndex)));
      }
      spans.add(
        TextSpan(
          text: title.substring(matchIndex, matchIndex + cleanQuery.length),
          style: const TextStyle(
            backgroundColor: Color(0xFFFEF08A),
            color: Color(0xFF854D0E),
            fontWeight: FontWeight.w800,
          ),
        ),
      );
      start = matchIndex + cleanQuery.length;
    }

    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F172A),
          letterSpacing: -0.2,
        ),
        children: spans,
      ),
    );
  }
}
