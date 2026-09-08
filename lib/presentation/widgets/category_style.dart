import 'package:flutter/material.dart';

/// Configurazione visiva e palette colori per ciascuna materia/categoria STEM.
class CategoryStyle {
  final Color primary;
  final Color background;
  final Color border;
  final IconData icon;

  const CategoryStyle({
    required this.primary,
    required this.background,
    required this.border,
    required this.icon,
  });

  /// Restituisce lo stile associato alla categoria specificata
  static CategoryStyle forCategory(String category) {
    switch (category.trim().toLowerCase()) {
      case 'aritmetica':
        return const CategoryStyle(
          primary: Color(0xFF38BDF8), // Sky blue brillante
          background: Color(0xFF082F49),
          border: Color(0xFF0369A1),
          icon: Icons.calculate_rounded,
        );
      case 'algebra':
        return const CategoryStyle(
          primary: Color(0xFFA78BFA), // Violetta brillante
          background: Color(0xFF2E1065),
          border: Color(0xFF6D28D9),
          icon: Icons.superscript_rounded,
        );
      case 'geometria':
        return const CategoryStyle(
          primary: Color(0xFFFB7185), // Rosa corallo brillante
          background: Color(0xFF4C0519),
          border: Color(0xFFBE123C),
          icon: Icons.change_history_rounded,
        );
      case 'goniometria':
        return const CategoryStyle(
          primary: Color(0xFFE879F9), // Fucsia brillante
          background: Color(0xFF4A044E),
          border: Color(0xFFA21CAF),
          icon: Icons.radar_rounded,
        );
      case 'analisi':
      case 'analisi matematica':
        return const CategoryStyle(
          primary: Color(0xFF818CF8), // Indaco brillante
          background: Color(0xFF1E1B4B),
          border: Color(0xFF4338CA),
          icon: Icons.functions_rounded,
        );
      case 'matematica':
        return const CategoryStyle(
          primary: Color(0xFF818CF8), // Indaco brillante
          background: Color(0xFF1E1B4B),
          border: Color(0xFF4338CA),
          icon: Icons.functions_rounded,
        );
      case 'chimica':
        return const CategoryStyle(
          primary: Color(0xFF34D399), // Smeraldo brillante
          background: Color(0xFF064E3B),
          border: Color(0xFF047857),
          icon: Icons.science_rounded,
        );
      case 'elettrotecnica':
        return const CategoryStyle(
          primary: Color(0xFF60A5FA), // Blu elettrico brillante
          background: Color(0xFF172554),
          border: Color(0xFF1D4ED8),
          icon: Icons.electric_bolt_rounded,
        );
      case 'fisica':
        return const CategoryStyle(
          primary: Color(0xFFFBBF24), // Ambra calda brillante
          background: Color(0xFF451A03),
          border: Color(0xFFB45309),
          icon: Icons.blur_on_rounded,
        );
      case 'ingegneria':
        return const CategoryStyle(
          primary: Color(0xFF2DD4BF), // Teal brillante
          background: Color(0xFF042F2E),
          border: Color(0xFF0F766E),
          icon: Icons.precision_manufacturing_rounded,
        );
      default:
        return const CategoryStyle(
          primary: Color(0xFF94A3B8), // Slate neutro
          background: Color(0xFF1E293B),
          border: Color(0xFF334155),
          icon: Icons.school_rounded,
        );
    }
  }
}
