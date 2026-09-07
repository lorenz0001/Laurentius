import 'package:flutter/material.dart';

import '../../domain/models/knowledge_node.dart';
import '../widgets/algebraic_proof_widget.dart';
import '../widgets/content_block_factory.dart';
import '../widgets/graph_controls_widget.dart';
import '../widgets/interactive/cartesian_graph_widget.dart';
import '../widgets/interactive/derivative_tangent_widget.dart';
import '../widgets/interactive/kinematics_simulation_widget.dart';
import '../widgets/interactive/live_equation_widget.dart';
import '../widgets/interactive/ohm_circuit_simulation_widget.dart';
import '../widgets/interactive/quadratic_visual_proof_widget.dart';
import '../widgets/interactive/riemann_sum_widget.dart';
import '../widgets/interactive/rolle_lagrange_widget.dart';
import '../widgets/interactive/squeeze_theorem_widget.dart';
import '../widgets/interactive/triangle_solver_widget.dart';
import '../widgets/interactive/trig_circle_widget.dart';
import '../widgets/knowledge_node_card.dart';
import '../widgets/math_markdown_view.dart';
import '../widgets/prerequisites_section_widget.dart';

/// Rappresenta un singolo widget registrato nella Galleria di Debug
class GalleryWidgetItem {
  final String id;
  final String title;
  final String category;
  final String description;
  final bool isAnimated;
  final Widget Function(BuildContext context, Key key) builder;

  const GalleryWidgetItem({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.isAnimated,
    required this.builder,
  });
}

/// Schermata Standalone per visualizzare, testare e debuggare tutti i widget
/// animati e non di Laurentius direttamente, senza dover navigare nel grafo o nel database.
class WidgetGalleryScreen extends StatefulWidget {
  const WidgetGalleryScreen({super.key});

  @override
  State<WidgetGalleryScreen> createState() => _WidgetGalleryScreenState();
}

class _WidgetGalleryScreenState extends State<WidgetGalleryScreen> {
  String _selectedFilter = 'Tutti'; // Tutti, Simulazioni, Componenti UI
  String? _selectedWidgetId; // Se valorizzato, visualizza quel widget a tutto schermo
  String _searchQuery = '';
  final Map<String, int> _widgetReloadKeys = {};

  late final List<GalleryWidgetItem> _allItems;

  @override
  void initState() {
    super.initState();
    _allItems = _buildGalleryItems();
  }

  void _reloadWidget(String id) {
    setState(() {
      _widgetReloadKeys[id] = (_widgetReloadKeys[id] ?? 0) + 1;
    });
  }

  List<GalleryWidgetItem> _buildGalleryItems() {
    return [
      // 1. Circonferenza Goniometrica
      GalleryWidgetItem(
        id: 'trig_circle',
        title: 'Circonferenza Goniometrica (TrigCircleWidget)',
        category: 'Trigonometria',
        description:
            'Cerchio unitario con drag diretto, raggio vettore, proiezioni seno/coseno, tangente continua senza salti ed asintoti esatti a 90°/270°.',
        isAnimated: true,
        builder: (ctx, key) => TrigCircleWidget(key: key),
      ),

      // 2. Teoremi di Rolle e Lagrange
      GalleryWidgetItem(
        id: 'rolle_lagrange',
        title: 'Teoremi del Valor Medio (RolleLagrangeWidget)',
        category: 'Analisi Matematica',
        description:
            'Diagramma geometrico stile Wikipedia: secante cordale e tangenti parallele nei punti interni c. Switch tra Teorema di Rolle e Lagrange.',
        isAnimated: true,
        builder: (ctx, key) => RolleLagrangeWidget(
          key: key,
          data: InteractiveData()
            ..templateType = 'rolle_lagrange'
            ..equations = ['x * x * x / 3 - x'],
        ),
      ),

      // 3. Teorema dei Carabinieri
      GalleryWidgetItem(
        id: 'squeeze_theorem',
        title: 'Teorema dei Carabinieri (SqueezeTheoremWidget)',
        category: 'Limiti e Continuità',
        description:
            'Visualizzazione geometrica delle due curve di contenimento g(x) <= f(x) <= h(x) che strizzano la funzione centrale nel punto limite.',
        isAnimated: true,
        builder: (ctx, key) => SqueezeTheoremWidget(
          key: key,
          data: InteractiveData()
            ..templateType = 'squeeze_theorem'
            ..equations = ['sin(k * x) / x'],
        ),
      ),

      // 4. Teorema di Carnot e Triangoli
      GalleryWidgetItem(
        id: 'triangle_solver',
        title: 'Teorema di Carnot & Triangoli (TriangleSolverWidget)',
        category: 'Geometria Euclidea',
        description:
            'Dimostrazione geometrica intuitiva del Teorema del Coseno come Pitagora generalizzato: altezza, proiezione p = a*cos(gamma) e termine correttivo.',
        isAnimated: true,
        builder: (ctx, key) => TriangleSolverWidget(
          key: key,
          data: InteractiveData()..templateType = 'triangle_solver',
        ),
      ),

      // 5. Grafico Cartesiano 2D
      GalleryWidgetItem(
        id: 'cartesian_graph',
        title: 'Grafico Cartesiano Dinamico (CartesianGraphWidget)',
        category: 'Analisi Matematica',
        description:
            'Piano cartesiano interattivo a 60fps con deformazione parametrica di curve polinomiali, vertici notevoli e griglia metrica.',
        isAnimated: true,
        builder: (ctx, key) => CartesianGraphWidget(
          key: key,
          data: InteractiveData()
            ..templateType = 'function_graph'
            ..equations = ['a * x * x + b * x + c'],
        ),
      ),

      // 6. Rapporto Incrementale e Derivata
      GalleryWidgetItem(
        id: 'derivative_tangent',
        title: 'Rapporto Incrementale (DerivativeTangentWidget)',
        category: 'Calcolo Differenziale',
        description:
            'Secante che collassa alla retta tangente al tendere dell\'incremento h a zero. Telemetria convergenza in tempo reale.',
        isAnimated: true,
        builder: (ctx, key) => DerivativeTangentWidget(
          key: key,
          data: InteractiveData()..templateType = 'derivative_tangent',
        ),
      ),

      // 7. Somme di Riemann
      GalleryWidgetItem(
        id: 'riemann_sum',
        title: 'Somme di Riemann & Integrali (RiemannSumWidget)',
        category: 'Calcolo Integrale',
        description:
            'Partizione rettangolare dell\'area sottesa da f(x) con N rettangoli variabile ed errore di convergenza rispetto all\'integrale esatto.',
        isAnimated: true,
        builder: (ctx, key) => RiemannSumWidget(
          key: key,
          data: InteractiveData()..templateType = 'riemann_sum',
        ),
      ),

      // 8. Cinematica Rettilinea
      GalleryWidgetItem(
        id: 'kinematics_simulation',
        title: 'Moto Rettilineo & Torricelli (KinematicsSimulationWidget)',
        category: 'Fisica',
        description:
            'Asse stradale metrica (0-100m), vettura con ruote rotanti, vettore velocità istantanea e verifica formula di Torricelli.',
        isAnimated: true,
        builder: (ctx, key) => KinematicsSimulationWidget(
          key: key,
          data: InteractiveData()
            ..templateType = 'kinematics_simulation'
            ..unit = 'm/s'
            ..equations = ['v0 + a * t'],
        ),
      ),

      // 9. Circuito di Ohm
      GalleryWidgetItem(
        id: 'ohm_circuit',
        title: 'Circuito Elettrico di Ohm (OhmCircuitSimulationWidget)',
        category: 'Elettrotecnica',
        description:
            'Circuito chiuso con generatore, conduttore resistivo, deriva di elettroni proporzionale alla corrente e bagliore termico.',
        isAnimated: true,
        builder: (ctx, key) => OhmCircuitSimulationWidget(
          key: key,
          data: InteractiveData()
            ..templateType = 'circuit_simulation'
            ..unit = 'A'
            ..equations = ['V / R'],
        ),
      ),

      // 10. Valutatore Formule Dinamico
      GalleryWidgetItem(
        id: 'live_equation',
        title: 'Laboratorio Equazioni Dinamico (LiveEquationWidget)',
        category: 'Aritmetica & Algebra',
        description:
            'Valutatore algebrico sicuro con auto-discovery delle variabili, slider dedicati, auto-recovery da variabili non vincolate e risultato live.',
        isAnimated: true,
        builder: (ctx, key) => LiveEquationWidget(
          key: key,
          data: InteractiveData()
            ..templateType = 'live_equation'
            ..equations = ['a * a + 2 * a * b + b * b'],
        ),
      ),

      // 11. Dimostrazione Visiva Formula Quadratica
      GalleryWidgetItem(
        id: 'quadratic_visual_proof',
        title: 'Dimostrazione Visiva: Formula Quadratica (QuadraticVisualProofWidget)',
        category: 'Equazioni di Secondo Grado',
        description:
            'Completamento geometrico 2D del quadrato (al-Khwarizmi) con tassello mancante animato b²/(4a²), slider parametrici, e vista cartesiana della simmetria delle radici.',
        isAnimated: true,
        builder: (ctx, key) => QuadraticVisualProofWidget(
          key: key,
          data: InteractiveData()
            ..templateType = 'completing_square'
            ..parameters = [
              InteractiveParameter()
                ..variableName = 'a'
                ..defaultValue = 1.0,
              InteractiveParameter()
                ..variableName = 'b'
                ..defaultValue = 4.0,
              InteractiveParameter()
                ..variableName = 'c'
                ..defaultValue = -5.0,
            ],
        ),
      ),

      // 12. Dimostrazione Algebrica Step-by-Step
      GalleryWidgetItem(
        id: 'algebraic_proof',
        title: 'Dimostrazione Step-by-Step (AlgebraicProofWidget)',
        category: 'Componenti Didattici',
        description:
            'Fisarmonica interattiva per sbloccare i passaggi algebrici uno ad uno, con formule KaTeX, box intuizione e corollari evidenziati.',
        isAnimated: false,
        builder: (ctx, key) => Container(
          key: key,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          padding: const EdgeInsets.all(16),
          child: AlgebraicProofWidget(
            proofSteps: [
              ProofStep()
                ..description = '1. Enunciato del Teorema del Coseno'
                ..latexEquation = r'c^2 = a^2 + b^2 - 2ab\cos\gamma'
                ..insight =
                    'Generalizzazione del Teorema di Pitagora a triangoli con angolo gamma qualsiasi.',
              ProofStep()
                ..description = '2. Tracciamento dell\'altezza relativa al lato b'
                ..latexEquation = r'h = a\sin\gamma, \quad p = a\cos\gamma'
                ..insight =
                    'L\'altezza divide il triangolo in due triangoli rettangoli adiacenti.',
              ProofStep()
                ..description = '3. Corollario: Caso Rettangolo (gamma = 90°)'
                ..latexEquation =
                    r'\cos(90^\circ) = 0 \implies c^2 = a^2 + b^2'
                ..insight =
                    'Il termine correttivo si annulla e si ricade esattamente in Pitagora.',
            ],
          ),
        ),
      ),

      // 12. Rendering Ibrido Markdown + LaTeX
      GalleryWidgetItem(
        id: 'math_markdown',
        title: 'Rendering KaTeX & Markdown (MathMarkdownView)',
        category: 'Componenti Didattici',
        description:
            'Visualizzazione ibrida Markdown con KaTeX inline ed equazioni centralizzate.',
        isAnimated: false,
        builder: (ctx, key) => Container(
          key: key,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          padding: const EdgeInsets.all(20),
          child: const MathMarkdownView(
            text:
                r'''### Teorema Fondamentale del Calcolo

Sia $f: [a, b] \to \mathbb{R}$ continua. La funzione integrale $F(x)$ soddisfa:

$$F'(x) = \frac{d}{dx} \int_a^x f(t)\,dt = f(x)$$

> **Intuizione:** La derivazione e l'integrazione sono operazioni algebriche esattamente inverse.''',
          ),
        ),
      ),

      // 13. Card Nodo di Conoscenza
      GalleryWidgetItem(
        id: 'knowledge_card',
        title: 'Card Nodo Curriculum (KnowledgeNodeCard)',
        category: 'Componenti UI',
        description:
            'Card compatta visualizzata nell\'Esplora con materia, titolo, corollario di sintesi e livello di profondità.',
        isAnimated: false,
        builder: (ctx, key) {
          final sampleNode = KnowledgeNode()
            ..serverId = 'mat_lim_sinc_01'
            ..title = 'Limite Notevole del Seno: sin(x)/x'
            ..category = 'Matematica'
            ..subCategory = 'Limiti e Continuità';
          return Container(
            key: key,
            alignment: Alignment.centerLeft,
            child: KnowledgeNodeCard(
              node: sampleNode,
            ),
          );
        },
      ),

      // 14. Sezione Prerequisiti & Dipendenze
      GalleryWidgetItem(
        id: 'prerequisites_section',
        title: 'Sezione Prerequisiti (PrerequisitesSectionWidget)',
        category: 'Componenti UI',
        description:
            'Chip e collegamenti visivi interdisciplinari per esplorare a monte e a valle nel DAG.',
        isAnimated: false,
        builder: (ctx, key) {
          final curr = KnowledgeNode()
            ..serverId = 'mat_lim_not_01'
            ..title = 'Limiti Notevoli'
            ..category = 'Matematica';
          final p1 = KnowledgeNode()
            ..serverId = 'mat_trig_circ_01'
            ..title = 'Circonferenza Goniometrica'
            ..category = 'Matematica';
          final p2 = KnowledgeNode()
            ..serverId = 'mat_limits_01'
            ..title = 'Definizione Rigorosa di Limite'
            ..category = 'Matematica';
          return Container(
            key: key,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            padding: const EdgeInsets.all(16),
            child: PrerequisitesSectionWidget(
              currentNode: curr,
              prerequisites: [p1, p2],
            ),
          );
        },
      ),

      // 15. Blocchi di Contenuto (ContentBlockFactory)
      GalleryWidgetItem(
        id: 'content_blocks',
        title: 'Blocchi Didattici (ContentBlockFactory)',
        category: 'Componenti Didattici',
        description:
            'Tipologie di blocchi renderizzati dagli articoli: testo markdown, equazione LaTeX isolata e callout informativo.',
        isAnimated: false,
        builder: (ctx, key) => Container(
          key: key,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ContentBlockFactory.buildBlock(
                ContentBlock()
                  ..type = 'text_markdown'
                  ..content =
                      'Questo è un blocco di testo standard con formattazione.',
                ctx,
              ),
              const SizedBox(height: 12),
              ContentBlockFactory.buildBlock(
                ContentBlock()
                  ..type = 'math_latex'
                  ..content =
                      r'\lim_{x \to 0} \frac{1 - \cos x}{x^2} = \frac{1}{2}',
                ctx,
              ),
              const SizedBox(height: 12),
              ContentBlockFactory.buildBlock(
                ContentBlock()
                  ..type = 'info_box'
                  ..content =
                      'Callout di intuizione geometrica: evidenzia il concetto cardine.',
                ctx,
              ),
            ],
          ),
        ),
      ),

      // 16. Controlli HUD Grafo DAG
      GalleryWidgetItem(
        id: 'graph_controls',
        title: 'Controlli Grafo HUD (GraphControlsWidget)',
        category: 'Componenti UI',
        description:
            'Pannello mobile galleggiante con pulsanti di zoom in, zoom out, reset vista e riallineamento topologico del DAG.',
        isAnimated: false,
        builder: (ctx, key) => Container(
          key: key,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: GraphControlsWidget(
              transformationController: TransformationController(),
              currentScale: 1.0,
              minScale: 0.5,
              maxScale: 2.5,
              onReset: () {},
            ),
          ),
        ),
      ),
    ];
  }

  List<GalleryWidgetItem> get _filteredItems {
    return _allItems.where((item) {
      if (_selectedFilter == 'Simulazioni' && !item.isAnimated) return false;
      if (_selectedFilter == 'Componenti UI' && item.isAnimated) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchTitle = item.title.toLowerCase().contains(q);
        final matchDesc = item.description.toLowerCase().contains(q);
        final matchCat = item.category.toLowerCase().contains(q);
        if (!matchTitle && !matchDesc && !matchCat) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;

    // Se è selezionato un singolo widget per focus mode
    if (_selectedWidgetId != null) {
      final item = _allItems.firstWhere((it) => it.id == _selectedWidgetId);
      final key = ValueKey('${item.id}_${_widgetReloadKeys[item.id] ?? 0}');

      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            tooltip: 'Torna alla galleria completa',
            onPressed: () => setState(() => _selectedWidgetId = null),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                item.category,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Ricarica widget con stato iniziale',
              onPressed: () => _reloadWidget(item.id),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Text(
                      item.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1E40AF),
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  item.builder(context, key),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: const Row(
          children: [
            Icon(Icons.dashboard_customize_rounded, color: Color(0xFF2563EB)),
            SizedBox(width: 10),
            Text(
              'Laurentius - Widget Debug & Preview Gallery',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                // Ricerca testuale
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cerca widget per nome, materia o formula...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                    ),
                    onChanged: (val) => setState(() => _searchQuery = val),
                  ),
                ),
                const SizedBox(width: 12),

                // Filtro categoria
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'Tutti', label: Text('Tutti (16)')),
                    ButtonSegment(
                      value: 'Simulazioni',
                      label: Text('Simulazioni (10)'),
                    ),
                    ButtonSegment(
                      value: 'Componenti UI',
                      label: Text('Componenti UI (6)'),
                    ),
                  ],
                  selected: {_selectedFilter},
                  onSelectionChanged: (val) {
                    setState(() => _selectedFilter = val.first);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: filtered.isEmpty
          ? const Center(
              child: Text(
                'Nessun widget trovato corrispondente alla ricerca.',
                style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final item = filtered[index];
                final key = ValueKey(
                  '${item.id}_${_widgetReloadKeys[item.id] ?? 0}',
                );

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 16,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header della Card del Widget
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              border: Border(
                                bottom: BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: item.isAnimated
                                        ? const Color(0xFFECFDF5)
                                        : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item.isAnimated ? 'ANIMATO' : 'STATICO',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                      color: item.isAnimated
                                          ? const Color(0xFF047857)
                                          : const Color(0xFF475569),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF6FF),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item.category.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2563EB),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0F172A),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Ricarica stato
                                IconButton(
                                  icon: const Icon(
                                    Icons.refresh_rounded,
                                    size: 18,
                                  ),
                                  tooltip: 'Ricarica widget',
                                  onPressed: () => _reloadWidget(item.id),
                                ),
                                // Focus a tutto schermo
                                IconButton(
                                  icon: const Icon(
                                    Icons.fullscreen_rounded,
                                    size: 20,
                                  ),
                                  tooltip: 'Isola a tutto schermo',
                                  onPressed: () => setState(
                                    () => _selectedWidgetId = item.id,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Descrizione didattica
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                            child: Text(
                              item.description,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                                height: 1.4,
                              ),
                            ),
                          ),

                          // Il Widget vivo da testare
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: item.builder(context, key),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
