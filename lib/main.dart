import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'core/services/mock_data_service.dart';
import 'data/repositories/node_repository.dart';
import 'domain/models/knowledge_node.dart';
import 'presentation/pages/node_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [KnowledgeNodeSchema],
    directory: dir.path,
  );

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

class HomeScreen extends StatefulWidget {
  final Isar? isar;

  const HomeScreen({super.key, this.isar});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<KnowledgeNode?>? _nodeFuture;

  @override
  void initState() {
    super.initState();
    if (widget.isar != null) {
      _nodeFuture = NodeRepository(widget.isar!).getNodeByServerId('ele_ohm_01');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: const Text(
          'Brilliant OS',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: widget.isar == null
          ? const Center(
              child: Text(
                'Brilliant OS - Database non inizializzato',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            )
          : FutureBuilder<KnowledgeNode?>(
              future: _nodeFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Errore: ${snapshot.error}'),
                  );
                }
                final node = snapshot.data;
                if (node == null) {
                  return const Center(
                    child: Text('Nodo "ele_ohm_01" non trovato nel database.'),
                  );
                }

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0A000000),
                                blurRadius: 16,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  node.category.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                node.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Esplora la dimostrazione algebrica interattiva step-by-step con formule LaTeX.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF64748B),
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => NodeDetailScreen(node: node),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.play_arrow_rounded),
                                  label: const Text(
                                    'Apri Legge di Ohm',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2563EB),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
