import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'core/services/mock_data_service.dart';
import 'core/theme/app_theme.dart';
import 'domain/models/knowledge_node.dart';
import 'presentation/pages/main_layout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Caricamento sicuro delle variabili d'ambiente per DeepSeek API
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Nota: file .env non caricato ($e). Uso fallback didattico.');
  }

  Isar? isar;
  if (!kIsWeb) {
    try {
      final dir = await getApplicationDocumentsDirectory();
      isar = await Isar.open([KnowledgeNodeSchema], directory: dir.path);

      // Inizializzazione autonoma e offline-first del catalogo locale STEM (nodi, animazioni, corollari)
      await MockDataService.populateDatabase(isar);
    } catch (e) {
      debugPrint('Nota Isar: $e. Uso fallback didattico in memoria.');
    }
  }

  runApp(LaurentiusApp(isar: isar));
}

class LaurentiusApp extends StatelessWidget {
  final Isar? isar;

  const LaurentiusApp({super.key, this.isar});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brilliant OS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: MainLayoutScreen(isar: isar),
    );
  }
}
