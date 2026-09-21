import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../core/theme/app_theme.dart';

/// Widget didattico che effettua il parsing e rendering ibrido di Markdown e formule LaTeX
/// sia inline ($formula$) sia a blocco display ($$formula$$), con tipografia ad alta risoluzione
/// ottimizzata per Wikipedia Mobile Dark Mode. Supporta termini ipertestuali interattivi [Termine](term:id).
class MathMarkdownView extends StatelessWidget {
  final String text;
  final TextStyle? baseStyle;
  final void Function(String termId)? onTermTap;

  const MathMarkdownView({
    super.key,
    required this.text,
    this.baseStyle,
    this.onTermTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBaseStyle = baseStyle ??
        const TextStyle(
          fontSize: 15,
          height: 1.65,
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w400,
        );

    // 1. Suddivisione preliminare tra blocchi display ($$ ... $$) e paragrafi testuali
    final displayMathRegex = RegExp(r'\$\$(.*?)\$\$', dotAll: true);
    final List<Widget> widgets = [];
    int lastEnd = 0;

    for (final match in displayMathRegex.allMatches(text)) {
      if (match.start > lastEnd) {
        final textChunk = text.substring(lastEnd, match.start).trim();
        if (textChunk.isNotEmpty) {
          widgets.addAll(_buildTextAndInlineMathParagraphs(textChunk, effectiveBaseStyle, onTermTap));
        }
      }

      final displayLatex = match.group(1)?.trim() ?? '';
      if (displayLatex.isNotEmpty) {
        widgets.add(_buildDisplayLatexCard(displayLatex));
      }

      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      final textChunk = text.substring(lastEnd).trim();
      if (textChunk.isNotEmpty) {
        widgets.addAll(_buildTextAndInlineMathParagraphs(textChunk, effectiveBaseStyle, onTermTap));
      }
    }

    if (widgets.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

  /// Card con scroll orizzontale per formule matematiche isolate a display ($$ ... $$)
  static Widget _buildDisplayLatexCard(String latex) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Math.tex(
            latex,
            textStyle: const TextStyle(
              fontSize: 17,
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            mathStyle: MathStyle.display,
            onErrorFallback: (err) => Text(
              latex,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: AppTheme.accentRedBright,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Converte blocchi di testo contenenti titoli markdown, elenchi puntati e formule inline ($ ... $)
  static List<Widget> _buildTextAndInlineMathParagraphs(
    String text,
    TextStyle baseStyle,
    void Function(String termId)? onTermTap,
  ) {
    final List<Widget> paragraphs = [];
    final lines = text.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) {
        paragraphs.add(const SizedBox(height: 8));
        continue;
      }

      // Intestazioni Markdown (#, ##, ###)
      if (line.startsWith('### ')) {
        paragraphs.add(
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 6),
            child: Text.rich(
              _buildInlineSpans(
                line.substring(4),
                const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.2,
                ),
                onTermTap,
              ),
            ),
          ),
        );
      } else if (line.startsWith('## ')) {
        paragraphs.add(
          Padding(
            padding: const EdgeInsets.only(top: 18, bottom: 8),
            child: Text.rich(
              _buildInlineSpans(
                line.substring(3),
                const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.3,
                ),
                onTermTap,
              ),
            ),
          ),
        );
      } else if (line.startsWith('# ')) {
        paragraphs.add(
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text.rich(
              _buildInlineSpans(
                line.substring(2),
                const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.4,
                ),
                onTermTap,
              ),
            ),
          ),
        );
      } else if (line == '---' || line == '***' || line == '___') {
        // Separatore orizzontale
        paragraphs.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF334155).withAlpha(0),
                    const Color(0xFF334155),
                    const Color(0xFF334155).withAlpha(0),
                  ],
                ),
              ),
            ),
          ),
        );
      } else if (line.startsWith('> ')) {
        // Blockquote: raccolta di righe consecutive che iniziano con >
        final List<String> quoteLines = [line.substring(2)];
        while (i + 1 < lines.length) {
          final nextLine = lines[i + 1].trim();
          if (nextLine.startsWith('> ')) {
            quoteLines.add(nextLine.substring(2));
            i++;
          } else if (nextLine == '>') {
            quoteLines.add('');
            i++;
          } else {
            break;
          }
        }
        paragraphs.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  left: BorderSide(
                    color: const Color(0xFF38BDF8).withAlpha(180),
                    width: 3,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: quoteLines.map((ql) {
                  if (ql.isEmpty) return const SizedBox(height: 6);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text.rich(
                      _buildInlineSpans(
                        ql,
                        baseStyle.copyWith(
                          fontSize: 13.5,
                          color: const Color(0xFFCBD5E1),
                          fontStyle: FontStyle.italic,
                        ),
                        onTermTap,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      } else if (RegExp(r'^\d+\.\s').hasMatch(line)) {
        // Lista numerata (1. testo, 2. testo, ...)
        final dotIndex = line.indexOf('. ');
        final number = line.substring(0, dotIndex);
        final content = line.substring(dotIndex + 2);
        paragraphs.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 26,
                  child: Text(
                    '$number.',
                    style: baseStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.accentBlueBright,
                    ),
                  ),
                ),
                Expanded(
                  child: Text.rich(
                    _buildInlineSpans(content, baseStyle, onTermTap),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (line.startsWith('- ') || line.startsWith('* ')) {
        // Elemento di elenco puntato
        paragraphs.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 7, right: 8),
                  child: Icon(
                    Icons.circle,
                    size: 6,
                    color: AppTheme.accentBlueBright,
                  ),
                ),
                Expanded(
                  child: Text.rich(
                    _buildInlineSpans(line.substring(2), baseStyle, onTermTap),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        // Paragrafo normale con supporto a formule matematiche inline
        paragraphs.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text.rich(
              _buildInlineSpans(line, baseStyle, onTermTap),
            ),
          ),
        );
      }
    }

    return paragraphs;
  }

  /// Suddivide una riga di testo identificando le porzioni matematiche inline racchiuse tra $ ... $
  static InlineSpan _buildInlineSpans(
    String line,
    TextStyle textStyle,
    void Function(String termId)? onTermTap,
  ) {
    final inlineMathRegex = RegExp(r'\$(.*?)\$');
    final List<InlineSpan> spans = [];
    int cursor = 0;

    for (final match in inlineMathRegex.allMatches(line)) {
      if (match.start > cursor) {
        final textBefore = line.substring(cursor, match.start);
        spans.addAll(_parseMarkdownFormatting(textBefore, textStyle, onTermTap));
      }

      final latexFormula = match.group(1)?.trim() ?? '';
      if (latexFormula.isNotEmpty) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
              child: Math.tex(
                latexFormula,
                mathStyle: MathStyle.text,
                textStyle: textStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
                onErrorFallback: (err) => Text(
                  latexFormula,
                  style: textStyle.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                    color: AppTheme.accentBlueBright,
                  ),
                ),
              ),
            ),
          ),
        );
      }

      cursor = match.end;
    }

    if (cursor < line.length) {
      final remaining = line.substring(cursor);
      spans.addAll(_parseMarkdownFormatting(remaining, textStyle, onTermTap));
    }

    return TextSpan(children: spans);
  }

  /// Converte la formattazione markdown inline di base (**grassetto**, *corsivo*, link [testo](term:id))
  static List<InlineSpan> _parseMarkdownFormatting(
    String text,
    TextStyle base,
    void Function(String termId)? onTermTap,
  ) {
    final List<InlineSpan> spans = [];
    final tokenRegex = RegExp(r'(\[.*?\]\(.*?\)|\*\*\*.*?\*\*\*|\*\*.*?\*\*|\*.*?\*|`.*?`)');
    int cursor = 0;

    for (final match in tokenRegex.allMatches(text)) {
      if (match.start > cursor) {
        spans.add(TextSpan(
          text: text.substring(cursor, match.start),
          style: base,
        ));
      }

      final token = match.group(0) ?? '';
      if (token.startsWith('[') && token.endsWith(')') && token.contains('](')) {
        final closingBracket = token.indexOf('](');
        final label = token.substring(1, closingBracket);
        final url = token.substring(closingBracket + 2, token.length - 1);
        if (url.startsWith('term:')) {
          final termId = url.substring(5);
          spans.add(
            TextSpan(
              text: label,
              style: base.copyWith(
                color: const Color(0xFF38BDF8),
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFF38BDF8).withAlpha(160),
                decorationStyle: TextDecorationStyle.solid,
              ),
              recognizer: onTermTap != null
                  ? (TapGestureRecognizer()..onTap = () => onTermTap(termId))
                  : null,
            ),
          );
        } else {
          spans.add(TextSpan(
            text: label,
            style: base.copyWith(
              color: const Color(0xFF60A5FA),
              decoration: TextDecoration.underline,
            ),
          ));
        }
      } else if (token.startsWith('***') && token.endsWith('***') && token.length >= 6) {
        spans.add(TextSpan(
          text: token.substring(3, token.length - 3),
          style: base.copyWith(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ));
      } else if (token.startsWith('**') && token.endsWith('**') && token.length >= 4) {
        spans.add(TextSpan(
          text: token.substring(2, token.length - 2),
          style: base.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ));
      } else if (token.startsWith('*') && token.endsWith('*') && token.length >= 2) {
        spans.add(TextSpan(
          text: token.substring(1, token.length - 1),
          style: base.copyWith(fontStyle: FontStyle.italic),
        ));
      } else if (token.startsWith('`') && token.endsWith('`') && token.length >= 2) {
        spans.add(TextSpan(
          text: token.substring(1, token.length - 1),
          style: base.copyWith(
            fontFamily: 'monospace',
            backgroundColor: AppTheme.surfaceElevated,
            color: AppTheme.accentBlueBright,
            fontSize: base.fontSize != null ? base.fontSize! * 0.9 : 13,
          ),
        ));
      } else {
        spans.add(TextSpan(text: token, style: base));
      }

      cursor = match.end;
    }

    if (cursor < text.length) {
      spans.add(TextSpan(
        text: text.substring(cursor),
        style: base,
      ));
    }

    return spans;
  }
}
