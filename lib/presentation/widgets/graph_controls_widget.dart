import 'package:flutter/material.dart';

/// Barra di controllo fluttuante per il Knowledge Graph:
/// permette Zoom In, Zoom Out, Ripristino/Centratura vista e visualizzazione percentuale della scala.
class GraphControlsWidget extends StatelessWidget {
  final TransformationController transformationController;
  final double currentScale;
  final double minScale;
  final double maxScale;
  final VoidCallback onReset;

  const GraphControlsWidget({
    super.key,
    required this.transformationController,
    required this.currentScale,
    required this.minScale,
    required this.maxScale,
    required this.onReset,
  });

  void _zoom(double factor) {
    final matrix = transformationController.value.clone();
    final newScale = (currentScale * factor).clamp(minScale, maxScale);
    final scaleDelta = newScale / currentScale;

    // Zoom o scala diretta della matrice
    matrix.scaleByDouble(scaleDelta, scaleDelta, 1.0, 1.0);
    transformationController.value = matrix;
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (currentScale * 100).round();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF191C20),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2D3238)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Zoom Out
          IconButton(
            icon: const Icon(
              Icons.remove_rounded,
              size: 18,
              color: Color(0xFFCBD5E1),
            ),
            onPressed: currentScale <= minScale ? null : () => _zoom(0.85),
            tooltip: 'Rimpicciolisci (Zoom -)',
            splashRadius: 18,
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
          ),

          // Percentuale di zoom
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              '$percentage%',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFFF8FAFC),
              ),
            ),
          ),

          // Zoom In
          IconButton(
            icon: const Icon(
              Icons.add_rounded,
              size: 18,
              color: Color(0xFFCBD5E1),
            ),
            onPressed: currentScale >= maxScale ? null : () => _zoom(1.18),
            tooltip: 'Ingrandisci (Zoom +)',
            splashRadius: 18,
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
          ),

          const SizedBox(width: 2),
          Container(height: 16, width: 1, color: const Color(0xFF2D3238)),
          const SizedBox(width: 2),

          // Reset / Centra Vista
          IconButton(
            icon: const Icon(
              Icons.center_focus_strong_rounded,
              size: 18,
              color: Color(0xFF60A5FA),
            ),
            onPressed: onReset,
            tooltip: 'Ripristina e centra vista',
            splashRadius: 18,
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
