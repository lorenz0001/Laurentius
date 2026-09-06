import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:isar/isar.dart';

import '../../core/services/sync_service.dart';
import '../../data/repositories/node_repository.dart';
import '../../domain/models/knowledge_node.dart';
import 'node_detail_screen.dart';

/// Schermata principale con visualizzazione ad albero/grafo delle conoscenze (Knowledge Graph).
/// Permette navigazione, zoom, pan e selezione dei singoli nodi per accedere al dettaglio.
class HomeScreen extends StatefulWidget {
  final Isar? isar;

  const HomeScreen({super.key, this.isar});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Graph _graph = Graph()..isTree = true;
  final Map<String, KnowledgeNode> _nodeLookup = {};

  late final BuchheimWalkerConfiguration _config;
  late final BuchheimWalkerAlgorithm _algorithm;

  bool _isLoading = true;
  bool _isSyncing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // Configurazione dell'algoritmo di layout direzionale (Top-Down)
    _config = BuchheimWalkerConfiguration()
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM
      ..siblingSeparation = 36
      ..levelSeparation = 56
      ..subtreeSeparation = 36;

    _algorithm = BuchheimWalkerAlgorithm(_config, TreeEdgeRenderer(_config));

    _loadKnowledgeGraph();
  }

  /// Forza la sincronizzazione HTTP con il server Python e ricarica il grafo
  Future<void> _syncWithServer() async {
    if (widget.isar == null || _isSyncing) return;

    setState(() {
      _isSyncing = true;
    });

    final success = await SyncService().syncWithServer(widget.isar!);
    await _loadKnowledgeGraph();

    if (mounted) {
      setState(() {
        _isSyncing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Sincronizzazione completata! Nodi aggiornati.'
                : 'Modalità offline: server non raggiungibile. Dati locali preservati.',
          ),
          backgroundColor:
              success ? const Color(0xFF16A34A) : const Color(0xFF475569),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Recupera tutti i nodi e relative dipendenze dal database locale Isar
  Future<void> _loadKnowledgeGraph() async {
    if (widget.isar == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Database locale non inizializzato.';
      });
      return;
    }

    try {
      final repository = NodeRepository(widget.isar!);
      final nodes = await repository.getAllNodes();

      _nodeLookup.clear();
      _graph.nodes.clear();
      _graph.edges.clear();
      final Map<String, Node> graphNodes = {};

      // 1. Aggiunge tutti i nodi al grafo
      for (final kNode in nodes) {
        _nodeLookup[kNode.serverId] = kNode;
        final gNode = Node.Id(kNode.serverId);
        graphNodes[kNode.serverId] = gNode;
        _graph.addNode(gNode);
      }

      // 2. Aggiunge gli archi direzionati: Prerequisito -> Nodo Dipendente
      for (final kNode in nodes) {
        final targetGNode = graphNodes[kNode.serverId];
        if (targetGNode == null) continue;

        for (final prereq in kNode.prerequisites) {
          final sourceGNode = graphNodes[prereq.serverId];
          if (sourceGNode != null) {
            _graph.addEdge(sourceGNode, targetGNode);
          }
        }
      }

      setState(() {
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Errore durante il caricamento del grafo: $e';
      });
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
        title: const Row(
          children: [
            Icon(Icons.account_tree_outlined, color: Color(0xFF2563EB), size: 22),
            SizedBox(width: 8),
            Text(
              'Brilliant OS',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        actions: [
          // Pulsante manuale di sincronizzazione
          TextButton.icon(
            onPressed: _isSyncing ? null : _syncWithServer,
            icon: _isSyncing
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF2563EB),
                    ),
                  )
                : const Icon(Icons.sync_rounded, size: 16, color: Color(0xFF2563EB)),
            label: const Text(
              'Sincronizza',
              style: TextStyle(
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          if (!_isLoading && _nodeLookup.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(right: 14, left: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Text(
                '${_nodeLookup.length} Nodi',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D4ED8),
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF2563EB)),
            SizedBox(height: 16),
            Text(
              'Caricamento albero delle conoscenze...',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Color(0xFFDC2626)),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF475569), fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    if (_nodeLookup.isEmpty) {
      return const Center(
        child: Text(
          'Nessun nodo presente nell\'albero.',
          style: TextStyle(color: Color(0xFF64748B)),
        ),
      );
    }

    return Stack(
      children: [
        // Visualizzazione interattiva del Grafo con pan e zoom
        InteractiveViewer(
          constrained: false,
          boundaryMargin: const EdgeInsets.all(120),
          minScale: 0.3,
          maxScale: 2.2,
          child: GraphView(
            graph: _graph,
            algorithm: _algorithm,
            paint: Paint()
              ..color = const Color(0xFFCBD5E1)
              ..strokeWidth = 2.5
              ..style = PaintingStyle.stroke,
            builder: (Node node) {
              final serverId = node.key!.value as String;
              final kNode = _nodeLookup[serverId];
              if (kNode == null) {
                return const SizedBox.shrink();
              }
              return _buildKnowledgeNodeCard(kNode);
            },
          ),
        ),

        // Suggerimento didattico fluttuante in basso
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xF00F172A),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.touch_app_outlined, color: Colors.white70, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Trascina per esplorare • Tocca un nodo per aprirlo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Costruisce la scheda visiva del nodo con estetica in stile "Brilliant"
  Widget _buildKnowledgeNodeCard(KnowledgeNode node) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NodeDetailScreen(node: node),
            ),
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Categoria badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      node.category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Titolo del nodo
              Text(
                node.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),

              // Dettagli sintetici (passaggi dimostrativi / laboratorio)
              Row(
                children: [
                  Icon(
                    node.interactiveData != null
                        ? Icons.tune_rounded
                        : Icons.menu_book_outlined,
                    size: 13,
                    color: const Color(0xFF64748B),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    node.interactiveData != null
                        ? 'Formule + Lab Live'
                        : '${node.algebraicProof.length} passaggi',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
