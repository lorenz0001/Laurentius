import 'package:flutter/material.dart';

import '../../../domain/models/knowledge_node.dart';
import 'live_equation_widget.dart';

/// Factory Pattern per l'istanziazione dinamica di widget interattivi (Server-Driven UI).
/// A seconda del [templateType] specificato nel database, restituisce il widget corrispondente.
class InteractiveTemplateFactory {
  /// Restituisce il widget interattivo corretto oppure null se il template non è riconosciuto.
  static Widget? buildWidget(InteractiveData? data) {
    if (data == null) {
      return null;
    }

    switch (data.templateType) {
      case 'live_equation':
        return LiveEquationWidget(data: data);
      default:
        // Template non ancora supportato o sconosciuto
        return null;
    }
  }
}
