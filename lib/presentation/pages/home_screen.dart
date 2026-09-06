import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:isar/isar.dart';

import '../../data/catalog/curriculum_registry.dart';
import '../../core/services/mock_data_service.dart';
import '../../data/repositories/node_repository.dart';
import '../../domain/models/knowledge_node.dart';
import '../widgets/graph_controls_widget.dart';
import '../widgets/knowledge_node_card.dart';

/// Schermata con visualizzazione ad albero/grafo delle conoscenze (Knowledge Graph).
/// Supporta collegamenti interdisciplinari (DAG), navigazione, zoom calibrato, pan e controlli di visualizzazione.
class GraphViewScreen extends StatefulWidget {
  final Isar? isar;
  final bool showAppBar;
  final VoidCallback? onRefresh;

  const GraphViewScreen({
    super.key,
    this.isar,
    this.showAppBar = true,
    this.onRefresh,
  });

  @override
  State<GraphViewScreen> createState() => _GraphViewScreenState();
}

/// Alias per compatibilità con codice pregresso
typedef HomeScreen = GraphViewScreen;

class _GraphViewScreenState extends State<GraphViewScreen> {
  // Supporta grafi orientati aciclici (DAG) con nodi a padri multipli / interdisciplinari
  final Graph _graph = Graph()..isTree = false;
  final Map<String, KnowledgeNode> _nodeLookup = {};

  late final SugiyamaConfiguration _config;
  late final SugiyamaAlgorithm _algorithm;

  final TransformationController _transformationController =
      TransformationController();
  double _currentScale = 1.0;

  static const double _minScale = 0.45;
  static const double _maxScale = 1.60;

  bool _isLoading = true;
  bool _isSyncing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // Configurazione Sugiyama per grafi diretti stratificati (DAG)
    _config = SugiyamaConfiguration()
      ..orientation = SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM
      ..nodeSeparation = 32
      ..levelSeparation = 64;

    _algorithm = SugiyamaAlgorithm(_config);

    _transformationController.addListener(_onTransformationChanged);

    _loadKnowledgeGraph();
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformationChanged);
    _transformationController.dispose();
    super.dispose();
  }

  void _onTransformationChanged() {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    if ((scale - _currentScale).abs() > 0.01) {
      setState(() {
        _currentScale = scale;
      });
    }
  }

  void _resetView() {
    setState(() {
      _transformationController.value = Matrix4.identity();
      _currentScale = 1.0;
    });
  }

  /// Ricarica e sincronizza il catalogo delle conoscenze dal servizio locale
  Future<void> _refreshCatalog() async {
    if (_isSyncing) return;

    setState(() {
      _isSyncing = true;
    });

    if (widget.isar != null) {
      await MockDataService.populateDatabase(widget.isar!);
    }
    await _loadKnowledgeGraph();

    if (mounted) {
      setState(() {
        _isSyncing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Catalogo delle conoscenze aggiornato con successo!',
          ),
          backgroundColor: const Color(0xFF16A34A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Recupera tutti i nodi e relative dipendenze (da Isar o in memoria per browser web)
  Future<void> _loadKnowledgeGraph() async {
    try {
      final List<KnowledgeNode> nodes;
      if (widget.isar != null) {
        final repository = NodeRepository(widget.isar!);
        nodes = await repository.getAllNodes();
      } else {
        // Modalità Browser Web o anteprima rapida in memoria da CurriculumRegistry
        nodes = CurriculumRegistry.getAllNodes();
        final Map<String, KnowledgeNode> inMemoryMap = {
          for (final n in nodes) n.serverId: n,
        };
        for (final entry in CurriculumRegistry.prerequisiteMap.entries) {
          final target = inMemoryMap[entry.key];
          if (target != null) {
            target.tempPrerequisiteIds = List.from(entry.value);
            for (final prereqId in entry.value) {
              final prereq = inMemoryMap[prereqId];
              if (prereq != null) {
                try {
                  target.prerequisites.add(prereq);
                } catch (_) {}
              }
            }
          }
        }
      }

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

      // 2. Aggiunge gli archi direzionati: Prerequisito -> Nodo Dipendente (anche cross-subject)
      for (final kNode in nodes) {
        final targetGNode = graphNodes[kNode.serverId];
        if (targetGNode == null) continue;

        final prereqIds = kNode.prerequisites.isNotEmpty
            ? kNode.prerequisites.map((p) => p.serverId).toList()
            : kNode.tempPrerequisiteIds;

        for (final prereqId in prereqIds) {
          final sourceGNode = graphNodes[prereqId];
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

  /// Metodo pubblico per ricaricare il grafo dall'esterno (es. MainLayoutScreen)
  Future<void> reloadGraph() => _refreshCatalog();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: widget.showAppBar
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 1,
              title: const Row(
                children: [
                  Icon(Icons.hub_outlined, color: Color(0xFF2563EB), size: 22),
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
                // Pulsante di ricarica catalogo locale
                TextButton.icon(
                  onPressed: _isSyncing ? null : _refreshCatalog,
                  icon: _isSyncing
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF2563EB),
                          ),
                        )
                      : const Icon(
                          Icons.refresh_rounded,
                          size: 16,
                          color: Color(0xFF2563EB),
                        ),
                  label: const Text(
                    'Ricarica',
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
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
            )
          : null,
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
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Color(0xFFDC2626),
              ),
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
        // Visualizzazione interattiva del Grafo con limiti calibrati di zoom e pan
        InteractiveViewer(
          transformationController: _transformationController,
          constrained: false,
          boundaryMargin: const EdgeInsets.all(280),
          minScale: _minScale,
          maxScale: _maxScale,
          child: GraphView(
            graph: _graph,
            algorithm: _algorithm,
            paint: Paint()
              ..color = const Color(0xFF94A3B8)
              ..strokeWidth = 2.0
              ..style = PaintingStyle.stroke,
            builder: (Node node) {
              final serverId = node.key!.value as String;
              final kNode = _nodeLookup[serverId];
              if (kNode == null) {
                return const SizedBox.shrink();
              }
              return KnowledgeNodeCard(node: kNode, isar: widget.isar);
            },
          ),
        ),

        // Barra di controllo fluttuante per Zoom e Ripristino Vista (in alto a destra)
        Positioned(
          top: 16,
          right: 16,
          child: GraphControlsWidget(
            transformationController: _transformationController,
            currentScale: _currentScale,
            minScale: _minScale,
            maxScale: _maxScale,
            onReset: _resetView,
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
                  Icon(
                    Icons.touch_app_outlined,
                    color: Colors.white70,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Pizzica per zoomare • Trascina per esplorare • Tocca un nodo per aprirlo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
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
}
