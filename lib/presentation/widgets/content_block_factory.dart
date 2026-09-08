import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/models/knowledge_node.dart';
import 'math_markdown_view.dart';

/// Factory e builder per il rendering modulare dei blocchi editoriali e didattici (ContentBlock).
/// Supporta Markdown arricchito, formule matematiche LaTeX vettoriali sia inline sia display,
/// Info Box di approfondimento (insight/corollari) e richiami multimediali in stile Wikipedia Dark Mode.
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
              fontSize: 18,
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

  /// Blocco informativo / Insight / Corollario pastello con supporto a LaTeX inline
  static Widget _buildInfoBoxBlock(String insight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF261D10), // Ambra profonda dark
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF78350F)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF451A03),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF92400E), width: 0.8),
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: Color(0xFFFBBF24),
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
                    color: Color(0xFFFBBF24),
                  ),
                ),
                const SizedBox(height: 4),
                MathMarkdownView(
                  text: insight,
                  baseStyle: const TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: Color(0xFFFDE68A),
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
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderDark),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        imageName,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          padding: const EdgeInsets.all(24),
          color: AppTheme.surfaceElevated,
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.broken_image_rounded, color: AppTheme.textMuted, size: 20),
                SizedBox(width: 8),
                Text(
                  'Immagine illustrativa non disponibile offline',
                  style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
