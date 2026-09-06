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
      case 'matematica':
        return const CategoryStyle(
          primary: Color(0xFF6366F1), // Indaco brillante
          background: Color(0xFFEEF2FF),
          border: Color(0xFFC7D2FE),
          icon: Icons.functions_rounded,
        );
      case 'chimica':
        return const CategoryStyle(
          primary: Color(0xFF059669), // Smeraldo vivace
          background: Color(0xFFECFDF5),
          border: Color(0xFFA7F3D0),
          icon: Icons.science_rounded,
        );
      case 'elettrotecnica':
        return const CategoryStyle(
          primary: Color(0xFF2563EB), // Blu elettrico
          background: Color(0xFFEFF6FF),
          border: Color(0xFFBFDBFE),
          icon: Icons.electric_bolt_rounded,
        );
      case 'fisica':
        return const CategoryStyle(
          primary: Color(0xFFD97706), // Ambra profonda
          background: Color(0xFFFFFBEB),
          border: Color(0xFFFDE68A),
          icon: Icons.blur_on_rounded,
        );
      case 'ingegneria':
        return const CategoryStyle(
          primary: Color(0xFF0D9488), // Teal
          background: Color(0xFFF0FDFA),
          border: Color(0xFF99F6E4),
          icon: Icons.precision_manufacturing_rounded,
        );
      default:
        return const CategoryStyle(
          primary: Color(0xFF475569), // Slate
          background: Color(0xFFF8FAFC),
          border: Color(0xFFE2E8F0),
          icon: Icons.school_rounded,
        );
    }
  }
}
