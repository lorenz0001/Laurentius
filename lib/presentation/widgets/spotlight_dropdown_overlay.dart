import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/models/spotlight_result.dart';
import 'spotlight_result_card.dart';

/// Overlay a discesa per i risultati predittivi di Spotlight Search.
/// Fornisce navigazione con tastiera (Frecce Su/Giù, Invio, Escape),
/// contatore risultati, stato vuoto informativo e visualizzazione delle card in stile Brilliant.
class SpotlightDropdownOverlay extends StatefulWidget {
  final List<SpotlightSearchResult> results;
  final String query;
  final ValueChanged<SpotlightSearchResult> onResultSelected;
  final VoidCallback onClose;
  final int selectedIndex;
  final ValueChanged<int>? onSelectedIndexChanged;

  const SpotlightDropdownOverlay({
    super.key,
    required this.results,
    required this.query,
    required this.onResultSelected,
    required this.onClose,
    this.selectedIndex = 0,
    this.onSelectedIndexChanged,
  });

  @override
  State<SpotlightDropdownOverlay> createState() =>
      _SpotlightDropdownOverlayState();
}

class _SpotlightDropdownOverlayState extends State<SpotlightDropdownOverlay> {
  late int _selectedIndex;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant SpotlightDropdownOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _selectedIndex = widget.selectedIndex;
    }
    if (widget.results.isNotEmpty && _selectedIndex >= widget.results.length) {
      _selectedIndex = 0;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyDown(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (widget.results.isNotEmpty) {
        setState(() {
          _selectedIndex = (_selectedIndex + 1).clamp(0, widget.results.length - 1);
        });
        widget.onSelectedIndexChanged?.call(_selectedIndex);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (widget.results.isNotEmpty) {
        setState(() {
          _selectedIndex = (_selectedIndex - 1).clamp(0, widget.results.length - 1);
        });
        widget.onSelectedIndexChanged?.call(_selectedIndex);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (widget.results.isNotEmpty &&
          _selectedIndex >= 0 &&
          _selectedIndex < widget.results.length) {
        widget.onResultSelected(widget.results[_selectedIndex]);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.escape) {
      widget.onClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.62;

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: false,
      onKeyEvent: _handleKeyDown,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A0F172A),
              blurRadius: 24,
              spreadRadius: -4,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header contatore risultati
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.manage_search_rounded,
                      size: 16,
                      color: Color(0xFF2563EB),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.results.isEmpty
                          ? 'NESSUN RISULTATO'
                          : '${widget.results.length} RISULTAT${widget.results.length == 1 ? 'O' : 'I'} TROVAT${widget.results.length == 1 ? 'O' : 'I'}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Tocca o premi Invio',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),

              // Lista risultati o Messaggio Vuoto
              Flexible(
                child: widget.results.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        physics: const BouncingScrollPhysics(),
                        itemCount: widget.results.length,
                        itemBuilder: (context, index) {
                          final item = widget.results[index];
                          return SpotlightResultCard(
                            key: ValueKey(item.id),
                            result: item,
                            query: widget.query,
                            isSelected: index == _selectedIndex,
                            onTap: () => widget.onResultSelected(item),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              color: Color(0xFFEF4444),
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Nessun risultato per "${widget.query}"',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          const Text(
            'Suggerimenti di ricerca rapida:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              _buildSuggestionChip('bisezione'),
              _buildSuggestionChip('pura'),
              _buildSuggestionChip('viète'),
              _buildSuggestionChip('carabinieri'),
              _buildSuggestionChip('ridotta'),
              _buildSuggestionChip('torricelli'),
              _buildSuggestionChip('corollario'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1D4ED8),
        ),
      ),
    );
  }
}
