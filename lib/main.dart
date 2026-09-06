import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'domain/models/knowledge_node.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [KnowledgeNodeSchema],
    directory: dir.path,
  );

  runApp(LaurentiusApp(isar: isar));
}

class LaurentiusApp extends StatelessWidget {
  final Isar? isar;

  const LaurentiusApp({super.key, this.isar});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brilliant OS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brilliant OS'),
      ),
      body: const Center(
        child: Text('Brilliant OS'),
      ),
    );
  }
}
