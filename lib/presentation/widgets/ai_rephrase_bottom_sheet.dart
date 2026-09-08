import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../core/services/ai_tutor_service.dart';
import '../../core/services/app_settings_service.dart';
import '../../data/repositories/node_repository.dart';
import '../../domain/models/knowledge_node.dart';
import '../pages/settings_screen.dart';
import 'content_block_factory.dart';

/// Modal Bottom Sheet per la rielaborazione sperimentale dei contenuti con DeepSeek AI (Tasto Matita).
/// Permette all'utente di richiedere modifiche (semplificazioni, analogie, rigore formale),
/// visualizzare un'anteprima comparativa prima di modificare il nodo,
/// e accettare o rifiutare la modifica, lasciando intatta l'animazione interattiva.
class AIRephraseBottomSheet extends StatefulWidget {
  final KnowledgeNode node;
  final Isar? isar;
  final VoidCallback onApplied;

  const AIRephraseBottomSheet({
    super.key,
    required this.node,
    this.isar,
    required this.onApplied,
  });

  @override
  State<AIRephraseBottomSheet> createState() => _AIRephraseBottomSheetState();
}

class _AIRephraseBottomSheetState extends State<AIRephraseBottomSheet> {
  final AITutorService _aiService = AITutorService();
  final TextEditingController _instructionController = TextEditingController();

  bool _isLoading = false;
  bool _hasApiKey = true;
  String? _errorMessage;
  List<ContentBlock>? _proposedBlocks;

  final List<String> _quickPrompts = [
    'Semplifica la spiegazione con un linguaggio intuitivo per principianti',
    'Aggiungi potenti analogie quotidiane ed esempi pratici',
    'Rendi la formulazione più rigorosa con passaggi algebrici formali',
    'Sintetizza i concetti chiave in un elenco chiaro ed essenziale',
  ];

  @override
  void initState() {
    super.initState();
    _checkApiKey();
  }

  @override
  void dispose() {
    _instructionController.dispose();
    super.dispose();
  }

  Future<void> _checkApiKey() async {
    final hasKey = await AppSettingsService.hasApiKey();
    if (mounted) {
      setState(() {
        _hasApiKey = hasKey;
      });
    }
  }

  Future<void> _generateRephrase(String instruction) async {
    final cleanInstruction = instruction.trim();
    if (cleanInstruction.isEmpty) {
      setState(() {
        _errorMessage =
            'Inserisci un\'istruzione per l\'AI o seleziona un suggerimento.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final newBlocks = await _aiService.rephraseContent(
        widget.node,
        cleanInstruction,
      );
      if (mounted) {
        setState(() {
          _proposedBlocks = newBlocks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _applyChanges() async {
    if (_proposedBlocks == null) return;

    // Aggiorna i blocchi del nodo in memoria
    widget.node.blocks = _proposedBlocks!;

    // Salva nel database Isar se disponibile
    if (widget.isar != null) {
      try {
        final repo = NodeRepository(widget.isar!);
        await repo.saveNode(widget.node);
      } catch (e) {
        debugPrint('Errore durante il salvataggio dei blocchi su Isar: $e');
      }
    }

    widget.onApplied();
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Spiegazione teorica aggiornata con successo!',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFF16A34A),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _discardPreview() {
    setState(() {
      _proposedBlocks = null;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final availableHeight = mediaQuery.size.height - bottomInset;
    final maxHeight = availableHeight * 0.88;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: const BoxDecoration(
          color: Color(0xFF191C20),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Maniglia di trascinamento
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF475569),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Intestazione
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_fix_high_rounded,
                      color: Color(0xFF60A5FA),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rielaborazione AI del Testo',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFEAECF0),
                          ),
                        ),
                        Text(
                          'Argomento: ${widget.node.title}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Chiudi',
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF94A3B8),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const Divider(color: Color(0xFF2D3238), height: 1),

            // Corpo della BottomSheet
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _proposedBlocks != null
                  ? _buildPreviewState()
                  : _buildInputState(),
            ),
          ],
        ),
      ),
    ),
  );
}

  /// Stato di Caricamento
  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Color(0xFF60A5FA),
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            const Text(
              'DeepSeek sta rielaborando i blocchi teorici...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFFEAECF0),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Adattamento del linguaggio, cura delle formule e mantenimento del rigore scientifico.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF94A3B8),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF14171A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 16,
                    color: Color(0xFF94A3B8),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Le animazioni interattive rimangono inalterate',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Stato di Input e Scelta Prompt
  Widget _buildInputState() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner di avviso se API Key assente
          if (!_hasApiKey) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF3B2805),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFD97706)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.bolt_rounded,
                    color: Color(0xFFFBBF24),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Chiave DeepSeek non configurata',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFCD34D),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Inserisci la tua API Key nelle Impostazioni per utilizzare la rielaborazione AI.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFDE68A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD97706),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                      _checkApiKey();
                    },
                    child: const Text(
                      'Configura',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
          ],

          // Avviso salvaguardia animazioni
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF3B82F6)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFF60A5FA),
                  size: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'La rielaborazione modifica esclusivamente la parte esplicativa teorica (testo, formule e note). Eventuali simulazioni e grafici interattivi non vengono intaccati.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF93C5FD),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'SUGGERIMENTI RAPIDI',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickPrompts.map((prompt) {
              return ActionChip(
                backgroundColor: const Color(0xFF14171A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Color(0xFF2D3238)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                label: Text(
                  prompt,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFCBD5E1),
                  ),
                ),
                onPressed: () {
                  _instructionController.text = prompt;
                  _generateRephrase(prompt);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          const Text(
            'OPPURE ISTRUZIONE PERSONALIZZATA',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _instructionController,
            maxLines: 3,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFF8FAFC),
            ),
            decoration: InputDecoration(
              hintText: 'es. Spiega questo concetto evidenziando il legame con la geometria euclidea ed esponi le formule con una notazione molto chiara...',
              hintStyle: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
              ),
              filled: true,
              fillColor: const Color(0xFF14171A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF2D3238)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF2D3238)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFF3B82F6),
                  width: 1.5,
                ),
              ),
            ),
          ),

          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF3B1219),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFB91C1C)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Color(0xFFEF4444),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFFB7185),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => _generateRephrase(_instructionController.text),
              icon: const Icon(Icons.auto_awesome_rounded, size: 18),
              label: const Text(
                'Genera Anteprima Rielaborata',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Stato di Anteprima Comparativa (Diff / Preview) con Accetta / Rifiuta
  Widget _buildPreviewState() {
    final blocks = _proposedBlocks!;

    return Column(
      children: [
        // Banner di stato Anteprima
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
            color: Color(0xFF3B2805),
            border: Border(bottom: BorderSide(color: Color(0xFFB45309))),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.visibility_rounded,
                color: Color(0xFFFBBF24),
                size: 20,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'ANTEPRIMA NON APPLICATA: Esamina il testo generato. Clicca "Accetta ed Applica" per sostituire la teoria.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFDE68A),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Lista dei blocchi generati
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'NUOVA FORMULAZIONE PROPOSTA',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF143820),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'AI GENERATED',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF4ADE80),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Blocchi renderizzati
                ...blocks.map(
                  (block) => ContentBlockFactory.buildBlock(block, context),
                ),

                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF14171A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.lock_clock_outlined,
                        size: 16,
                        color: Color(0xFF94A3B8),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Simulazioni e animazioni interattive rimangono intatte.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Barra Inferiore: Rifiuta vs Accetta
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: const BoxDecoration(
            color: Color(0xFF101214),
            border: Border(top: BorderSide(color: Color(0xFF2D3238))),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _discardPreview,
                  icon: const Icon(Icons.close_rounded, size: 18),
                  label: const Text(
                    'Rifiuta Modifica',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFCBD5E1),
                    side: const BorderSide(color: Color(0xFF475569)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _applyChanges,
                  icon: const Icon(Icons.check_circle_rounded, size: 18),
                  label: const Text(
                    'Accetta ed Applica',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
