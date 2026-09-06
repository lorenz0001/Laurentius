import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../domain/models/knowledge_node.dart';
import 'math_markdown_view.dart';

/// Factory e builder per il rendering modulare dei blocchi editoriali e didattici (ContentBlock).
/// Supporta Markdown arricchito, formule matematiche LaTeX vettoriali sia inline sia display,
/// Info Box di approfondimento (insight/corollari) e richiami multimediali.
class ContentBlockFactory {
  /// Costruisce il widget corrispondente al singolo blocco di contenuto
  static Widget buildBlock(ContentBlock block, BuildContext context) {
    switch (block.type) {
      case 'text_markdown':
        return _buildMarkdownBlock(block.content ?? '');
      case 'math_latex':
        return _buildLatexBlock(block.content ?? '');
      case 'info_box':
        return _buildInfoBoxBlock(block.content ?? '');
      case 'image':
        return _buildImageBlock(block.content ?? '');
      default:
        // Fallback per blocchi di testo generici
        return _buildMarkdownBlock(block.content ?? '');
    }
  }

  /// Blocco di testo Markdown formattato con supporto a formule LaTeX inline ($ ... $) e display ($$ ... $$)
  static Widget _buildMarkdownBlock(String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: MathMarkdownView(text: content),
    );
  }

  /// Blocco LaTeX renderizzato vettorialmente con scroll orizzontale di sicurezza
  static Widget _buildLatexBlock(String latex) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      width: double.infinity,
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
              fontSize: 18,
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

  /// Blocco informativo / Insight / Corollario pastello con supporto a LaTeX inline
  static Widget _buildInfoBoxBlock(String insight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB), // Giallo ambra pastello
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: Color(0xFFD97706),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'INSIGHT & INTUIZIONE DIDATTICA',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: Color(0xFFB45309),
                  ),
                ),
                const SizedBox(height: 4),
                MathMarkdownView(
                  text: insight,
                  baseStyle: const TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: Color(0xFF78350F),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Blocco multimediale immagine (se presente)
  static Widget _buildImageBlock(String imageName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        imageName,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          padding: const EdgeInsets.all(24),
          color: const Color(0xFFF1F5F9),
          child: Center(
            child: Text(
              'Immagine non trovata: $imageName',
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}
