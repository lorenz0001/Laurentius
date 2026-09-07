import 'package:isar/isar.dart';

import '../../data/catalog/curriculum_registry.dart';
import '../../data/content/content_loader_service.dart';

/// Servizio per la popolazione del database locale Isar con il catalogo delle conoscenze.
/// Carica tutti i nodi didattici disaccoppiati tramite [ContentLoaderService] e li sincronizza su Isar.
class MockDataService {
  /// Popola o sincronizza l'intero catalogo sul database locale Isar
  static Future<void> populateDatabase(Isar isar) async {
    var nodes = await ContentLoaderService.loadAllFromBundle();
    if (nodes.isEmpty) {
      nodes = CurriculumRegistry.getAllNodes();
    }
    await ContentLoaderService.syncToIsar(isar, nodes);
  }
}

