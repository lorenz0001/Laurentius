import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';

import '../../core/services/spotlight_index_service.dart';
import '../../domain/models/spotlight_result.dart';
import '../pages/node_detail_screen.dart';
import 'spotlight_dropdown_overlay.dart';

/// Barra di ricerca istantanea Spotlight persistente in stile Brilliant.
/// Fornisce: ricerca predittiva su teoremi, formule, corollari e definizioni,
/// visualizzazione overlay ancorato, navigazione con tastiera e salto diretto <= 1 tap.
class SpotlightSearchBarWidget extends StatefulWidget {
  final Isar? isar;
  final SpotlightIndexService? indexService;
  final ValueChanged<SpotlightSearchResult>? onResultSelected;
  final VoidCallback? onClear;
  final String hintText;

  const SpotlightSearchBarWidget({
    super.key,
    this.isar,
    this.indexService,
    this.onResultSelected,
    this.onClear,
    this.hintText = 'Cerca teoremi, formule, corollari (es. "Viète", "Carabinieri")...',
  });

  @override
  State<SpotlightSearchBarWidget> createState() =>
      _SpotlightSearchBarWidgetState();
}

class _SpotlightSearchBarWidgetState extends State<SpotlightSearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  late final SpotlightIndexService _indexService;
  OverlayEntry? _overlayEntry;
  List<SpotlightSearchResult> _currentResults = [];
  int _selectedIndex = 0;
  Timer? _blurTimer;

  @override
  void initState() {
    super.initState();
    _indexService = widget.indexService ??
        SpotlightIndexService(isar: widget.isar);
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _blurTimer?.cancel();
    _removeOverlay();
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final query = _controller.text;
    if (query.trim().isEmpty) {
      _currentResults = [];
      _removeOverlay();
      setState(() {});
      widget.onClear?.call();
      return;
    }

    _currentResults = _indexService.search(query);
    _selectedIndex = 0;
    _showOrUpdateOverlay();
    setState(() {});
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      if (_controller.text.trim().isNotEmpty) {
        _showOrUpdateOverlay();
      }
    } else {
      // Delay lieve per permettere il click sul risultato prima della chiusura
      _blurTimer?.cancel();
      _blurTimer = Timer(const Duration(milliseconds: 200), () {
        if (mounted && !_focusNode.hasFocus) {
          _removeOverlay();
        }
      });
    }
  }

  void _showOrUpdateOverlay() {
    if (!mounted) return;

    if (_overlayEntry == null) {
      final overlay = Overlay.of(context);
      _overlayEntry = _createOverlayEntry();
      overlay.insert(_overlayEntry!);
    } else {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? const Size(360, 48);

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + 8),
            child: Material(
              color: Colors.transparent,
              child: SpotlightDropdownOverlay(
                results: _currentResults,
                query: _controller.text,
                selectedIndex: _selectedIndex,
                onSelectedIndexChanged: (idx) {
                  setState(() {
                    _selectedIndex = idx;
                  });
                  _overlayEntry?.markNeedsBuild();
                },
                onResultSelected: _handleResultSelection,
                onClose: () {
                  _focusNode.unfocus();
                  _removeOverlay();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleResultSelection(SpotlightSearchResult result) {
    _removeOverlay();
    _focusNode.unfocus();

    if (widget.onResultSelected != null) {
      widget.onResultSelected!(result);
      return;
    }

    // Navigazione diretta <= 1 tap alla dimostrazione o al corollario
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NodeDetailScreen(
          node: result.node,
          isar: widget.isar,
          targetProofGroup: result.proofGroup,
          targetStepIndex: result.proofStepIndex,
          targetCorollary: result.title,
          autoUnlockProof: true,
        ),
      ),
    );
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (_currentResults.isNotEmpty) {
        setState(() {
          _selectedIndex = (_selectedIndex + 1).clamp(0, _currentResults.length - 1);
        });
        _overlayEntry?.markNeedsBuild();
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (_currentResults.isNotEmpty) {
        setState(() {
          _selectedIndex = (_selectedIndex - 1).clamp(0, _currentResults.length - 1);
        });
        _overlayEntry?.markNeedsBuild();
      }
    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (_currentResults.isNotEmpty &&
          _selectedIndex >= 0 &&
          _selectedIndex < _currentResults.length) {
        _handleResultSelection(_currentResults[_selectedIndex]);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.escape) {
      _focusNode.unfocus();
      _removeOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _controller.text.isNotEmpty;

    return CompositedTransformTarget(
      link: _layerLink,
      child: KeyboardListener(
        focusNode: FocusNode(skipTraversal: true),
        onKeyEvent: _handleKeyEvent,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF191C20),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _focusNode.hasFocus
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFF2D3238),
              width: _focusNode.hasFocus ? 1.5 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: _focusNode.hasFocus
                    ? const Color(0x333B82F6)
                    : const Color(0x20000000),
                blurRadius: _focusNode.hasFocus ? 12 : 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              // Icona di ricerca
              const Icon(
                Icons.search_rounded,
                color: Color(0xFF60A5FA),
                size: 20,
              ),
              const SizedBox(width: 10),

              // Campo di testo di ricerca
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFF8FAFC),
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              // Tasto Pulisci oppure Badge scorciatoia tastiera
              if (hasText)
                IconButton(
                  tooltip: 'Cancella ricerca',
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF94A3B8),
                    size: 18,
                  ),
                  onPressed: () {
                    _controller.clear();
                    _removeOverlay();
                  },
                )
              else
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22262B),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF2D3238)),
                    ),
                    child: const Text(
                      '⌘K',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
