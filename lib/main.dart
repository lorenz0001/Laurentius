import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'core/services/mock_data_service.dart';
import 'domain/models/knowledge_node.dart';
import 'presentation/pages/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Caricamento sicuro delle variabili d'ambiente per DeepSeek API
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Nota: file .env non caricato ($e). Uso fallback didattico.');
  }

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [KnowledgeNodeSchema],
    directory: dir.path,
  );

  // Inizializzazione autonoma e offline-first del catalogo locale STEM (nodi, animazioni, corollari)
  await MockDataService.populateDatabase(isar);

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      home: HomeScreen(isar: isar),
    );
  }
}
