import 'package:isar/isar.dart';

import '../../data/catalog/curriculum_registry.dart';

/// Servizio per la popolazione del database locale Isar con il catalogo delle conoscenze.
/// Delega a [CurriculumRegistry] la sincronizzazione dell'albero didattico completo
/// (dall'addizione all'integrazione, corollari e scienze applicate connesse).
class MockDataService {
  /// Popola o sincronizza l'intero catalogo sul database locale Isar
  static Future<void> populateDatabase(Isar isar) async {
    await CurriculumRegistry.syncToIsar(isar);
  }
}
