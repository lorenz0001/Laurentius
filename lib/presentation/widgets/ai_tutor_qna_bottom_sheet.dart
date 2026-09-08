import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../core/services/ai_tutor_service.dart';
import '../../core/services/app_settings_service.dart';
import '../../domain/models/knowledge_node.dart';
import '../pages/settings_screen.dart';

/// Messaggio di dialogo nella sessione di Q&A con il tutor
class _ChatMessage {
  final bool isUser;
  final String text;
  final DateTime timestamp;

  _ChatMessage({required this.isUser, required this.text, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();
}

/// Modal Bottom Sheet per porre domande e chiarire dubbi all'AI Tutor (Tasto Punto Interrogativo ❓).
/// Offre un'interfaccia di conversazione focalizzata sul nodo corrente,
/// con supporto a Markdown ricco, formule LaTeX e suggerimenti rapidi.
class AITutorQnABottomSheet extends StatefulWidget {
  final KnowledgeNode node;

  const AITutorQnABottomSheet({super.key, required this.node});

  @override
  State<AITutorQnABottomSheet> createState() => _AITutorQnABottomSheetState();
}

class _AITutorQnABottomSheetState extends State<AITutorQnABottomSheet> {
  final AITutorService _aiService = AITutorService();
  final TextEditingController _questionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _hasApiKey = true;
  String? _errorMessage;

  final List<String> _suggestedQuestions = [
    'Qual è l\'intuizione visiva o fisica fondamentale?',
    'Qual è l\'errore concettuale più frequente tra gli studenti?',
    'Quali sono le applicazioni pratiche nel mondo reale?',
    'Come si collega ai concetti prerequisiti?',
  ];

  @override
  void initState() {
    super.initState();
    _checkApiKey();
    _messages.add(
      _ChatMessage(
        isUser: false,
        text:
            'Ciao! Sono il tuo Laurentius AI Tutor per **${widget.node.title}**.\n\nCosa non ti è del tutto chiaro o quale aspetto vorresti approfondire? Puoi digitare un dubbio oppure toccare uno dei suggerimenti rapidi in basso.',
      ),
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    _scrollController.dispose();
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

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendQuestion(String rawQuestion) async {
    final cleanQuestion = rawQuestion.trim();
    if (cleanQuestion.isEmpty || _isLoading) return;

    _questionController.clear();
    setState(() {
      _messages.add(_ChatMessage(isUser: true, text: cleanQuestion));
      _isLoading = true;
      _errorMessage = null;
    });
    _scrollToBottom();

    try {
      final answer = await _aiService.askQuestionAboutNode(
        widget.node,
        cleanQuestion,
      );
      if (mounted) {
        setState(() {
          _messages.add(_ChatMessage(isUser: false, text: answer));
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
        _scrollToBottom();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final availableHeight = mediaQuery.size.height - bottomInset;
    final maxHeight = availableHeight * 0.90;

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
                      color: const Color(0xFF281845),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.psychology_rounded,
                      color: Color(0xFFA78BFA),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Chiedi all\'AI Tutor',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFEAECF0),
                          ),
                        ),
                        Text(
                          'Chiarimenti su: ${widget.node.title}',
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

            // Avviso API Key se assente
            if (!_hasApiKey) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B2805),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD97706)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.bolt_rounded,
                      color: Color(0xFFFBBF24),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Configura la chiave API DeepSeek per ricevere risposte interattive su misura.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFDE68A),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                        _checkApiKey();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text(
                        'Configura',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFBBF24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Lista messaggi di conversazione
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    return _buildLoadingBubble();
                  }
                  final msg = _messages[index];
                  return _buildMessageBubble(msg);
                },
              ),
            ),

            // Banner errore se presente
            if (_errorMessage != null) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(10),
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
                      size: 16,
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

            // Suggerimenti rapidi (orizzontali)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: const Color(0xFF14171A),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _suggestedQuestions.map((q) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        backgroundColor: const Color(0xFF1E2228),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Color(0xFF2D3238)),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        label: Text(
                          q,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFCBD5E1),
                          ),
                        ),
                        onPressed: _isLoading ? null : () => _sendQuestion(q),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // Input bar inferiore
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              decoration: const BoxDecoration(
                color: Color(0xFF191C20),
                border: Border(top: BorderSide(color: Color(0xFF2D3238))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _questionController,
                      minLines: 1,
                      maxLines: 3,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendQuestion,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFEAECF0),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Fai una domanda su ${widget.node.title}...',
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                        isDense: true,
                        filled: true,
                        fillColor: const Color(0xFF101214),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color(0xFF2D3238),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color(0xFF2D3238),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color(0xFF7C3AED),
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF7C3AED),
                    ),
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.arrow_upward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: _isLoading
                          ? null
                          : () => _sendQuestion(_questionController.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildMessageBubble(_ChatMessage msg) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12, left: 48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB),
            borderRadius: BorderRadius.circular(16)
                .copyWith(bottomRight: const Radius.circular(4)),
          ),
          child: Text(
            msg.text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, right: 32),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF191C20),
          borderRadius: BorderRadius.circular(16)
              .copyWith(bottomLeft: const Radius.circular(4)),
          border: Border.all(color: const Color(0xFF2D3238)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A1B4E),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    size: 14,
                    color: Color(0xFFA78BFA),
                  ),
                ),
                const SizedBox(width: 8),
                const Flexible(
                  child: Text(
                    'Laurentius AI Tutor',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFA78BFA),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            MarkdownBody(
              data: msg.text,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: Color(0xFFEAECF0),
                ),
                strong: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                code: const TextStyle(
                  backgroundColor: Color(0xFF101214),
                  fontFamily: 'monospace',
                  fontSize: 13,
                  color: Color(0xFFE2E8F0),
                ),
                listBullet: const TextStyle(
                  color: Color(0xFFA78BFA),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, right: 48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF191C20),
          borderRadius: BorderRadius.circular(16)
              .copyWith(bottomLeft: const Radius.circular(4)),
          border: Border.all(color: const Color(0xFF2D3238)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFFA78BFA),
              ),
            ),
            SizedBox(width: 12),
            Text(
              'L\'AI Tutor sta formulando la risposta dai primi principi...',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
