# Laurentius — Project Architecture Map

> High-density architectural index and reference map for AI agents and developers.
> Offline-first STEM knowledge graph and Brilliant-style interactive learning system.

---

## 1. Overview & Tech Stack

Laurentius is an offline-first Flutter application presenting STEM knowledge (mathematics, physics, electrical engineering) as an interactive, prerequisite-linked directed acyclic graph (DAG). Concepts emphasize deep visual and algebraic intuition through step-by-step proofs and real-time reactive simulations.

- **Framework**: Flutter 3.x / Dart 3.x (iOS-first responsive mobile & desktop design).
- **Local Database**: Isar NoSQL (`@collection KnowledgeNode`, `@embedded` objects, transactional 2-phase sync).
- **Formula & Proof Rendering**: `flutter_math_fork` (KaTeX-compliant inline `$..$` and display `$$..$$` LaTeX).
- **Numerical & Symbolic Math**: `math_expressions` (runtime algebraic expression parsing and live slider evaluation).
- **Knowledge Graph Topology**: `graphview` (interactive DAG canvas with Sugiyama hierarchical layout).
- **Design Philosophy**: Brilliant.org style — generous whitespace, rounded geometry (R12–R16), pastel domain accents, cognitive step-by-step unlocking, 60fps vector animations.

---

## 2. Annotated Directory Structure (`lib/`)

```
lib/
├── main.dart                          # App entry point, Isar DB initialization, service providers, root widget
├── core/                              # Shared application-level services & utilities
│   └── services/
│       ├── ai_tutor_service.dart      # Socratic AI tutor mock: concept simplification and contextual Q&A
│       ├── app_settings_service.dart  # Settings persistence, offline preferences, and cache maintenance
│       ├── mock_data_service.dart     # Seeding coordinator: ingests markdown content via ContentLoaderService
│       └── sync_service.dart          # Synchronization status and offline state coordination
├── data/                              # Data sources, storage, and catalog definitions
│   ├── catalog/                       # Structured curriculum registries and category definitions
│   │   ├── curriculum_registry.dart   # Central curriculum registry: delegates to cached nodes or fallbacks
│   │   ├── algebra_catalog.dart       # Fallback catalog definitions for foundational algebra
│   │   ├── arithmetic_catalog.dart    # Fallback catalog definitions for elementary arithmetic
│   │   ├── calculus_catalog.dart      # Fallback catalog definitions for limits, derivatives, integrals
│   │   ├── geometry_trig_catalog.dart # Fallback catalog definitions for Euclidean geometry & trigonometry
│   │   ├── physics_catalog.dart       # Fallback catalog definitions for kinematics, Ohm's law, thermodynamics
│   │   ├── university_glossary_catalog.dart # 40+ rigorous terms with KaTeX, definitions & diagrams
│   │   └── university_linear_algebra_course.dart # PoliMi Chapter 1 (81 pp.) 6 decomposed master lectures
│   ├── content/                       # Decoupled content parsing & offline loading engine
│   │   ├── content_loader_service.dart# Discovers assets/content/**/*.md via AssetManifest; 2-phase Isar sync
│   │   └── markdown_content_parser.dart# Pure Dart parser: YAML frontmatter -> models, body -> blocks & proofs
│   └── repositories/
│       └── node_repository.dart       # Isar data access layer: query by ID, category, or search filter
├── domain/                            # Enterprise business models & domain entities
│   └── models/
│       ├── exercise_model.dart        # Practice quizzes & validation models linked to knowledge nodes
│       ├── knowledge_node.dart        # Core entity: KnowledgeNode, ContentBlock, ProofStep, InteractiveData/Param
│       ├── knowledge_node.g.dart      # Generated Isar schema code, type adapters, and index queries
│       └── university_course_model.dart# UniversityCourse, Chapter, Lecture, UniversityTerm, VisualDiagramType
└── presentation/                      # UI layer: screens, custom components, and interactive simulations
    ├── pages/                         # Primary application screens
    │   ├── category_explorer_screen.dart # Filterable topic catalog with domain tabs & difficulty chips
    │   ├── exercise_screen.dart       # Practice runner with instant answer validation & feedback
    │   ├── home_screen.dart           # Interactive 2D knowledge graph view with pan/zoom and node status
    │   ├── main_layout_screen.dart    # Scaffold navigation bar: Grafo, Esplora, and Università
    │   ├── node_detail_screen.dart    # Article view: simulation widget, markdown blocks, step proofs, DAG links
    │   ├── settings_screen.dart       # Preferences screen: AI config, database inspection, cache wipe
    │   └── university/                # Complete university courses & hypertextual glossary screens
    │       ├── university_courses_screen.dart  # Course hub, PoliMi metadata, lecture cards & color legend
    │       ├── university_lecture_screen.dart  # Lecture reader with back button, key terms & KaTeX markdown
    │       ├── university_term_screen.dart     # Term detail with visual diagram, formula & related terms
    │       └── university_glossary_screen.dart # Searchable & filterable alphabetical term glossary
    └── widgets/                       # Reusable UI widgets and simulation canvas components
        ├── algebraic_proof_widget.dart    # Step-by-step collapsible proof accordion with corollary badges
        ├── math_markdown_view.dart    # Hybrid Markdown + KaTeX renderer with [term](term:id) taps
        ├── university/
        │   └── term_visual_example_widget.dart # Static CustomPainter diagrams (arrows, clocks, Cayley, etc.)
        └── interactive/               # 60fps reactive simulation widgets and dynamic factory
            ├── interactive_template_factory.dart   # SDUI router: resolves templateType to simulation widgets
            ├── cartesian_graph_widget.dart        # 2D coordinate plot with dynamic curves & coefficient sliders
            ├── derivative_tangent_widget.dart     # Secant-to-tangent convergence & difference quotient limit
            ├── kinematics_simulation_widget.dart  # Accelerated rectilinear motion, vector v, Torricelli card
            ├── live_equation_widget.dart          # Parametric formula solver with dynamic units & live readout
            ├── ohm_circuit_simulation_widget.dart # Circuit with electron drift, thermal glow, Ohm sliders
            ├── riemann_sum_widget.dart            # Definite integral rectangular partition approximations
            ├── rolle_lagrange_widget.dart         # Mean Value & Rolle theorems secant/tangent visualizer
            ├── triangle_solver_widget.dart        # Triangle solver with Carnot/Pythagoras laws & angle arc
            └── trig_circle_widget.dart            # Unit circle with drag gestures, sin/cos projections, tan line
```

---

## 3. Catalog & Content Pathways

Educational topics are decoupled into human-editable Markdown files in `assets/content/<category>/<topic_id>.md`, registered under `flutter: assets:` in `pubspec.yaml`.

### YAML Frontmatter Schema
```yaml
---
id: phys_kin_01                        # String: unique topic ID (persisted as serverId in Isar)
title: "Cinematica: Moto Rettilineo"   # String: topic display title
category: "Fisica"                     # String: Aritmetica, Algebra, Geometria e Trigonometria, Analisi Matematica, Fisica
subCategory: "Cinematica e Dinamica"   # String?: optional grouping within category
prerequisites: [mat_parabola_01]       # List<String>: IDs of prerequisite topics (forming DAG links)
interactive:                           # Optional map: links topic to simulation widget
  template: kinematics_simulation      # String: template key or alias (see Section 4)
  unit: "m/s"                          # String?: optional result readout unit badge
  equations: ["v0 + a * t"]            # List<String>?: mathematical expressions
  parameters:                          # List<Map>?: interactive slider definitions
    - name: v0                         # String: variable identifier
      label: "Velocità Iniziale (v₀)"  # String: slider label
      min: 0.0                         # double: minimum bound
      max: 30.0                        # double: maximum bound
      default: 5.0                     # double: initial value
      step: 1.0                        # double: slider step size
      unit: "m/s"                      # String?: measurement unit for slider badge
---
```

### Ingestion & Sync Pipeline
1. **Discovery**: `ContentLoaderService.loadAllFromBundle()` reads `AssetManifest` for `assets/content/**/*.md` (with fallback to 24 bundled paths in headless tests).
2. **Parsing**: `MarkdownContentParser.parse()` strips YAML frontmatter, maps `interactive` block to `InteractiveData` and `InteractiveParameter` entities, and breaks body into:
   - `ContentBlock`s: `text` paragraphs, `latex` equation cards (`$$...$$`), and `info_box` callouts (`> [!NOTE]`).
   - `ProofStep`s: extracted from `### Dimostrazione`, parsing step titles, LaTeX derivations, `> Intuizione:` insights, and `> Corollario: [Nome]` badges.
3. **In-Memory Cache**: Parsed nodes are held in `ContentLoaderService.cachedNodes` and propagated to `CurriculumRegistry`.
4. **Isar Persistence**: `ContentLoaderService.syncToIsar(isar, nodes)` executes a 2-phase transaction:
   - *Phase 1*: Upserts nodes, matching `serverId` to preserve auto-increment primary keys (`id`).
   - *Phase 2*: Resolves `tempPrerequisiteIds` and binds relationships via `IsarLinks<KnowledgeNode>`.

---

## 4. Interactive Simulation Widget Catalog

All 10 interactive simulation widgets reside in `lib/presentation/widgets/interactive/`. The `InteractiveTemplateFactory` routes 22+ template key aliases to widgets:

| Widget Class | Template Key Aliases | Parameters (`variableName`) | Equations & Math Engine | Unit Support | Visuals & Interactive Features |
|---|---|---|---|---|---|
| `OhmCircuitSimulationWidget` | `circuit_simulation`, `ohm_simulation` | `V` (voltage, def: 12), `R` (resistance, def: 6) | Internal Dart math: $I = V/R$, $P = V \cdot I$ | Sliders: `param.unit` (`V`, `Ω`); Telemetry: `A`, `W` | Closed loop with drifting electrons, conventional/real current toggle, thermal glow shader |
| `KinematicsSimulationWidget` | `kinematics_simulation`, `rectilinear_motion` | `v0` (init vel, def: 5), `a` (accel, def: 2) | Optional `v0 + a * t`; $x(t) = v_0 t + \frac{1}{2}at^2$, $v(t) = v_0 + at$ | Sliders: `param.unit` (`m/s`, `m/s²`); Telemetry: `m`, `m/s` | Metric road (0–100m), vehicle with rotating wheels, velocity vector $\vec{v}$, Torricelli formula card |
| `CartesianGraphWidget` | `function_graph`, `cartesian_plot` | Dynamic coefficients (`a`, `b`, `c`) | Evaluated via `math_expressions` GrammarParser | Sliders: `param.unit` | 2D cartesian axes with metric grid, 60fps continuous curve plotting, dynamic vertex marker, auto-morphing |
| `LiveEquationWidget` | `live_equation` (and fallback) | User variables matching equation tokens | Evaluated via `math_expressions` ContextModel | Result box: `data.unit`; Sliders: `param.unit` | Generic formula evaluator, real-time recalculation, numeric display, error diagnostics |
| `RolleLagrangeWidget` | `rolle_lagrange`, `rolle`, `lagrange` | `a` (left bound, def: -1.8), `b` (right bound, def: 1.8) | Cubic $f(x) = x^3/3 - x$, $f'(x) = x^2 - 1$ | Sliders: `param.unit` | Secant line through $(a, f(a))$ and $(b, f(b))$, parallel tangent at interior $c$, mode switch, auto-oscillation |
| `TriangleSolverWidget` | `triangle_solver`, `pythagoras_carnot` | `sideA` (def: 3), `sideB` (def: 4), `angleGammaDeg` (def: 90) | Carnot Law: $c^2 = a^2 + b^2 - 2ab\cos\gamma$ | Sliders: `param.unit` (`cm`, `m`, `°`) | Real-time triangle geometry, dynamic angle arc, right-angle detector, sides/area telemetry, 90° preset |
| `TrigCircleWidget` | `trig_circle`, `trigonometric_circle` | `angle` ($\theta$, default: $\pi/4$) | $\sin\theta, \cos\theta, \tan\theta$, identity $\sin^2\theta + \cos^2\theta = 1$ | Radian and degree display; unitless trig ratios | Interactive canvas drag, orthogonal projections ($\sin$ green, $\cos$ blue), tangent line $x=1$, 60fps auto-rotation |
| `DerivativeTangentWidget` | `derivative_tangent`, `difference_quotient` | `x0` (base point, def: 1.0), `h` (increment, def: 1.5) | Parabola $f(x) = \frac{1}{2}x^2$, quotient $\frac{f(x_0+h)-f(x_0)}{h}$ | Sliders: `param.unit` | Secant line collapsing to tangent line as $h \to 0$, convergence error telemetry, limit animation |
| `RiemannSumWidget` | `riemann_sum`, `riemann_integral` | `nRectangles` ($N$, default: 6) on $[a,b] = [0,2]$ | $f(x) = 0.75x^2 + 0.5$, $F(x) = 0.25x^3 + 0.5x$ | Slider: rectangle count badge | Rectangular partitions under curve, exact definite integral, convergence error $|\Sigma - \int|$, partition step animation |
| `Vector2DSimulationWidget` | `vector_2d`, `linear_combination`, `vector_addition`, `span_2d`, `vector_simulation` | `vx`, `vy`, `v1x`, `v1y`, `v2x`, `v2y`, `c1`, `c2` | $\mathbf{v} = v_x \mathbf{e}_1 + v_y \mathbf{e}_2$, $\mathbf{s} = \mathbf{v}_1 + \mathbf{v}_2$, $\mathbf{w} = c_1 \mathbf{v}_1 + c_2 \mathbf{v}_2$, $\det = v_{1x}v_{2y} - v_{1y}v_{2x}$ | Sliders: `param.unit` | 2D cartesian canvas, 3 modes (Components, Addition with Parallelogram/Punta-Coda, Span & Combinations), touch drag vector heads, determinant & collinearity check |

*Routing Rule*: For `function_graph` / `cartesian_plot`, if the equation contains `x * x * x / 3` or `rolle`, `InteractiveTemplateFactory` automatically delegates to `RolleLagrangeWidget`. If `templateType` is omitted but equations or parameters exist, it falls back to `LiveEquationWidget`. Pure theory topics use `template: null`.

---

## 5. State & Data Flow

```
[Application Startup]
        │
        ▼
[Asset Discovery via AssetManifest] ──► Reads assets/content/**/*.md
        │
        ▼
[MarkdownContentParser] ─────────────► Pure Dart frontmatter & body parsing
        │
        ▼
[ContentLoaderService.syncToIsar] ───► Phase 1: Upsert nodes (preserve IDs)
        │                             Phase 2: Populate IsarLinks prerequisites
        ├────────────────────────────► In-memory cache update (CurriculumRegistry)
        ▼
[KnowledgeNodeNotifier Provider] ───► Notifies UI listeners of dataset readiness
        │
        ├────────────────────────────► HomeScreen: Renders GraphView 2D DAG
        ├────────────────────────────► CategoryExplorerScreen: Subject & difficulty filters
        ▼
[User Node Selection] ───────────────► Navigates to NodeDetailScreen
        │
        ▼
[InteractiveTemplateFactory] ────────► Matches templateType & aliases
        │
        ▼
[Simulation Widget & CustomPainter] ─► 60fps gesture-driven canvas repaints
```

---

## 6. Step-by-Step Developer Guide: Adding New Topics

To add an educational topic without writing Flutter/Dart code:

### Step 1: Create the Markdown File
Create a new `.md` file in the appropriate domain directory:
- `assets/content/arithmetic/`
- `assets/content/algebra/`
- `assets/content/geometry_trig/`
- `assets/content/calculus/`
- `assets/content/physics/`

Define YAML frontmatter with `id`, `title`, `category`, `subCategory`, and `prerequisites`. Write the narrative body using Markdown and LaTeX blocks (`$$...$$`). Structure proofs with `### Dimostrazione`, numbered steps (`1. Passaggio...`), intuition callouts (`> Intuizione: ...`), and corollaries (`> Corollario: ...`).

### Step 2: Bind an Interactive Simulation
In the frontmatter `interactive:` block, declare:
- `template`: Choose an alias from Section 4 (e.g. `kinematics_simulation`, `circuit_simulation`, `function_graph`, `live_equation`). Set to `null` or omit for pure theory.
- `unit`: Optional result unit string (e.g. `"V"`, `"m/s"`, `"N"`, `"J"`).
- `equations`: Mathematical formula string(s).
- `parameters`: Array of slider controls with `name`, `label`, `min`, `max`, `default`, `step`, and `unit`.

### Step 3: Verify Ingestion and DAG Acyclicity
Run the test suite and static analyzer to confirm automated loading, parsing, and DAG integrity:
```bash
flutter analyze
flutter test test/markdown_content_loader_test.dart
flutter test test/curriculum_dag_test.dart
```
The tests automatically verify that the new file is discovered, YAML syntax is valid, parameters map cleanly to `InteractiveData`, and no circular prerequisites exist in the curriculum DAG.

---

## 7. University Courses & Hypertextual Term System

Laurentius includes a dedicated module for complete university curriculums ("Materie Universitarie Complete"), accessible via the `"Università"` tab in `MainLayoutScreen`.

### 7.1 Architecture & Domain Models
- **`UniversityCourse`**: Top-level entity (`id`, `title`, `university`, `professor`, `semester`, `chapters`).
- **`UniversityChapter`**: Thematic syllabus section (`id`, `title`, `pageRange`, `lectures`).
- **`UniversityLecture`**: Decomposed lecture unit (`id`, `title`, `sectionNumber`, `professorPages`, `defaultColor`, `keyTermIds`, `markdownContent`).
- **`UniversityTerm`**: Formal mathematical definition (`id`, `name`, `symbol`, `category`, `shortDefinition`, `formalLatex`, `pedagogicalExplanation`, `visualType`, `exampleTitle`, `exampleText`, `relatedTermIds`).
- **`LectureColorCode`**: Professor Constantinescu's 4-color rating convention:
  - **Verde**: Fondamentale, teoria obbligatoria (es. Definizioni base, $M/\sim$).
  - **Giallo**: Rilevante per gli esercizi e la pratica applicata (es. Bézout, Euclide).
  - **Arancione**: Utile ma di importanza secondaria/complementare.
  - **Rosso**: Teoria avanzata o fuori programma d'esame diretto.

### 7.2 Decomposed Linear Algebra Curriculum (PoliMi - Prof. Alexandru Constantinescu)
Chapter 1: "Fondamenti" (81 pages) is decomposed into 6 connected master lectures in `UniversityLinearAlgebraCourse`:
1. **Lezione 1.1**: *Enunciati Matematici e Logica Proposizionale* (pp. 8–16)
2. **Lezione 1.2**: *Insiemi, Paradossi e Prodotto Cartesiano* (pp. 17–24)
3. **Lezione 1.3**: *Applicazioni, Composizione e Invertibilità* (pp. 25–36)
4. **Lezione 1.4**: *Famiglie, Cardinalità e Assioma della Scelta* (pp. 37–45)
5. **Lezione 1.5**: *Relazioni, Insiemi Quoziente e Aritmetica Intera* (pp. 46–57)
6. **Lezione 1.6**: *Strutture Algebriche: Gruppi, Anelli e Campi* (pp. 58–81)

### 7.3 Hypertextual Term System & Visual Diagrams
- In-lecture terms use markdown syntax `[Term Name](term:term_id)`.
- `MathMarkdownView` recognizes `term:` URLs and routes via `onTermTap` to `UniversityTermScreen`.
- `TermVisualExampleWidget` renders static `CustomPainter` diagrams without animation (arrow mappings, equivalence partitions, modulo clock rings, truth matrices, Cayley tables, permutation cycle graphs, subset lattices, and Euclidean division timelines).
- **Navigation**: Top back buttons on `UniversityLectureScreen` and `UniversityTermScreen` allow seamless hierarchical and back-stack traversal.
- **Glossary Hub**: `UniversityGlossaryScreen` provides instant search and category filtering over all 40+ catalogued terms.

