import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// Widget didattico che effettua il parsing e rendering ibrido di Markdown e formule LaTeX
/// sia inline ($formula$) sia a blocco display ($$formula$$), con tipografia ad alta risoluzione.
class MathMarkdownView extends StatelessWidget {
  final String text;
  final TextStyle? baseStyle;

  const MathMarkdownView({
    super.key,
    required this.text,
    this.baseStyle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBaseStyle = baseStyle ??
        const TextStyle(
          fontSize: 15,
          height: 1.65,
          color: Color(0xFF334155),
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
          widgets.addAll(_buildTextAndInlineMathParagraphs(textChunk, effectiveBaseStyle));
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
        widgets.addAll(_buildTextAndInlineMathParagraphs(textChunk, effectiveBaseStyle));
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
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x04000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Math.tex(
            latex,
            textStyle: const TextStyle(
              fontSize: 17,
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w500,
            ),
            mathStyle: MathStyle.display,
            onErrorFallback: (err) => Text(
              latex,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: Color(0xFFDC2626),
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
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
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
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
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
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.4,
                ),
              ),
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
                  padding: EdgeInsets.only(top: 6, right: 8),
                  child: Icon(
                    Icons.circle,
                    size: 6,
                    color: Color(0xFF2563EB),
                  ),
                ),
                Expanded(
                  child: Text.rich(
                    _buildInlineSpans(line.substring(2), baseStyle),
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
              _buildInlineSpans(line, baseStyle),
            ),
          ),
        );
      }
    }

    return paragraphs;
  }

  /// Suddivide una riga di testo identificando le porzioni matematiche inline racchiuse tra $ ... $
  static InlineSpan _buildInlineSpans(String line, TextStyle textStyle) {
    final inlineMathRegex = RegExp(r'\$(.*?)\$');
    final List<InlineSpan> spans = [];
    int cursor = 0;

    for (final match in inlineMathRegex.allMatches(line)) {
      if (match.start > cursor) {
        final textBefore = line.substring(cursor, match.start);
        spans.addAll(_parseMarkdownFormatting(textBefore, textStyle));
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
                  color: const Color(0xFF0F172A),
                ),
                onErrorFallback: (err) => Text(
                  latexFormula,
                  style: textStyle.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2563EB),
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
      spans.addAll(_parseMarkdownFormatting(remaining, textStyle));
    }

    return TextSpan(children: spans);
  }

  /// Converte la formattazione markdown inline di base (**grassetto** e *corsivo*)
  static List<InlineSpan> _parseMarkdownFormatting(String text, TextStyle base) {
    final List<InlineSpan> spans = [];
    final boldItalicRegex = RegExp(r'(\*\*\*.*?\*\*\*|\*\*.*?\*\*|\*.*?\*|`.*?`)');
    int cursor = 0;

    for (final match in boldItalicRegex.allMatches(text)) {
      if (match.start > cursor) {
        spans.add(TextSpan(
          text: text.substring(cursor, match.start),
          style: base,
        ));
      }

      final token = match.group(0) ?? '';
      if (token.startsWith('***') && token.endsWith('***') && token.length >= 6) {
        spans.add(TextSpan(
          text: token.substring(3, token.length - 3),
          style: base.copyWith(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
        ));
      } else if (token.startsWith('**') && token.endsWith('**') && token.length >= 4) {
        spans.add(TextSpan(
          text: token.substring(2, token.length - 2),
          style: base.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
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
            backgroundColor: const Color(0xFFF1F5F9),
            color: const Color(0xFF0F172A),
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
