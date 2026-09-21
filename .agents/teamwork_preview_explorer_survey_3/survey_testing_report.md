# Comprehensive Survey Report: Build Health, Test Infrastructure & Offline Content Pipeline (R4)

**Date**: 2026-09-14  
**Investigator**: Teamwork Explorer (Survey 3)  
**Target Repository**: Laurentius (Brilliant-OS)  
**Workspace**: `c:\Users\catte\Desktop\Laurentius`  

---

## 1. Executive Summary

A comprehensive, empirical investigation of the Laurentius Flutter/Dart codebase was conducted, focusing on build health, static analysis integrity, test suite coverage, and the offline content loading pipeline.

### Key Metrics & Findings
- **Static Analysis**: `flutter analyze` executed with **0 errors and 0 warnings** (analysis time: 84.4s).
- **Test Suite Status**: Full test suite execution (`flutter test`) ran **251 automated tests across 23 test files**, achieving a **100% pass rate** (251 passed, 0 failed, 0 skipped, run time: ~21s).
- **Offline Content Ingestion**: 35 decoupled Markdown curriculum articles reside on disk under `assets/content/`. In headless test environments where Flutter's `AssetManifest` is unpopulated, `ContentLoaderService.knownAssetPaths` provides a guaranteed fallback that allows 100% offline testing without network or asset bundle dependencies.
- **Isar Database Decoupling**: Isar persistence uses a transactional 2-phase upsert (`syncToIsar`), while UI and test layers cleanly decouple via nullable `Isar? isar` references, falling back dynamically to `CurriculumRegistry.cachedNodes` or static catalog fallbacks.
- **Upcoming Milestone (Linear Algebra & 2D Vector Simulation)**:
  - Adding the 5 new Linear Algebra topics (`mat_nupla_01`, `mat_vec_geom_01`, `mat_vec_ops_01`, `mat_vec_span_01`, `mat_vec_indep_01`) will expand the curriculum from 35 to 40 nodes.
  - **Critical Architectural Invariant**: In `challenger_curriculum_stress_test.dart`, Kahn's topological sort asserts that `mat_add_01` is the **unique foundational root** (`inDegree == 0`) of the entire curriculum. Therefore, the first Linear Algebra node (`mat_nupla_01`) must NOT have empty prerequisites, but must link back to foundational arithmetic/algebra nodes (e.g. `mat_add_01`, `mat_mul_01`).
  - Several tests currently assert hardcoded counts of `35` (e.g. `markdown_content_loader_test.dart` and `challenger_curriculum_stress_test.dart`). These must be updated to `40` (or `>= 40`) when new nodes are introduced.
  - The new 2D vector simulation widget requires registration in `InteractiveTemplateFactory` and `validTemplates`, as well as autoplay suppression verification (initializing paused).

---

## 2. Complete Inventory & Catalog of Existing Test Infrastructure (`test/`)

The repository contains **23 test files** in `test/`, comprising **251 individual test cases**. The following table catalogs every test file, its line count, size, test count, and primary architectural focus:

| # | Test File | Lines | Size | Test Count | Test Scope & Purpose |
|---|---|---|---|---|---|
| 1 | `widget_test.dart` | 12 | 287 B | 1 | Smoke test verifying `LaurentiusApp` root mount and "Brilliant OS" header. |
| 2 | `graph_algorithm_test.dart` | 32 | 1.0 KB | 1 | Sugiyama hierarchical layout algorithm run over cross-subject DAG nodes. |
| 3 | `step11_navigation_content_test.dart` | 131 | 4.7 KB | 4 | `KnowledgeNode.subCategory` verification, `ContentBlockFactory` widget dispatch, bottom nav bar. |
| 4 | `step12_reorganization_and_simulations_test.dart` | 217 | 8.3 KB | 6 | Domain grouping under 'Matematica', separation of 'Fisica'/'Elettrotecnica', monotonic difficulty, category tabs. |
| 5 | `curriculum_dag_test.dart` | 170 | 5.6 KB | 5 | Unique `serverId`s, valid prerequisite resolution, Kahn topological DAG check, presence of corollaries. |
| 6 | `challenger_curriculum_stress_test.dart` | 339 | 12.7 KB | 6 | Bidirectional disk vs `knownAssetPaths` parity (35 files), schema validation, unique root `mat_add_01`, Kahn & Tarjan SCC acyclicity, fault injection, limits fallback alignment. |
| 7 | `markdown_content_parser_test.dart` | 298 | 10.8 KB | 8 | `ProofStepExt` computed getters (`isCorollary`, `groupName`, `corollaryTitle`), sub-step `####` parsing, `AlgebraicProofWidget` deep-linking and badging. |
| 8 | `markdown_content_loader_test.dart` | 911 | 28.2 KB | 26 | 4-Tier verification: Tier 1 frontmatter parsing, Tier 2 boundary cases, Tier 3 SDUI factory linking, Tier 4 all 35 topics DAG & corollary integrity, disk files parsing, bundle loader. |
| 9 | `interactive_simulation_test.dart` | 402 | 14.3 KB | 17 | `InteractiveTemplateFactory` routing for all 9 simulation widgets, `CategoryStyle`, `PrerequisitesSectionWidget` badge, widget tests for Kinematics, Cartesian, TrigCircle (4 quadrants & asymptotes), TriangleSolver, RolleLagrange, SqueezeTheorem, DerivativeTangent, RiemannSum. |
| 10 | `all_animations_test.dart` | 492 | 18.8 KB | 12 | Initial paused state on mount, play/pause controls, 60fps animation progression, touch drag for TrigCircle, Kinematics, Circuits, Tangent, Riemann, Triangle, Squeeze, Cartesian. |
| 11 | `simulations_autoplay_and_geometry_stress_test.dart` | 624 | 23.2 KB | 15 | Adversarial autoplay suppression across all 9 widgets, boundary angle stress for TrigCircle ($0, \pi/2, \pi, 3\pi/2, 2\pi$), Squeeze narrow envelope ($\delta=0.05$), Triangle Carnot exactness (acute, 90° Pythagoras collapse, obtuse 120°). |
| 12 | `live_equation_and_sliders_test.dart` | 524 | 16.4 KB | 15 | R4 Configurable slider units ('N', 'kg', 'm/s²', 'J', 'W'), null unit naked numbers (never 'V'), defensive slider clamping, drag re-evaluation. |
| 13 | `live_equation_unbound_variable_test.dart` | 113 | 4.1 KB | 4 | Variable auto-discovery when parameters are omitted/partial, verified clean mount across all fallback nodes in `ArithmeticCatalog` and `AlgebraCatalog`. |
| 14 | `m1_adversarial_challenge_test.dart` | 520 | 17.0 KB | 15 | Multi-term math formulas with custom units ('J', 'W', 'N'), negative slider ranges, scientific notation, division by zero resilience. |
| 15 | `m1_challenger2_simulation_stress_test.dart` | 607 | 20.0 KB | 18 | `InteractiveTemplateFactory` resilience with null/unknown templates, Ohm circuit units (MV, MΩ, naked), defaultValue out-of-bounds defensive clamping, Kinematics units. |
| 16 | `quadratic_visual_proof_test.dart` | 185 | 6.7 KB | 7 | `QuadraticVisualProofWidget` paused by default, 5 geometric dissection steps, mode switching (geometric dissection vs parabola & symmetry), parameter sliders. |
| 17 | `spotlight_search_test.dart` | 133 | 5.3 KB | 14 | `SpotlightIndexService` unit tests: >100 indexed items, topic/theorem/corollary/formula indexing, Italian diacritic folding ('viète'/'viete'), keyword queries, empty query resilience. |
| 18 | `spotlight_widget_navigation_test.dart` | 190 | 7.4 KB | 5 | Persistent `SpotlightSearchBarWidget` at top of `MainLayoutScreen`, live typing overlay, KaTeX rendering, direct $\le$ 1-tap navigation to `NodeDetailScreen`, keyboard arrows/Enter navigation. |
| 19 | `wikipedia_dark_mode_test.dart` | 270 | 9.8 KB | 10 | `AppTheme` dark tokens (`bgDark` 0xFF101214), `NodeDetailScreen` collapsible accordion sections (expand, collapse, re-expand), KaTeX contrast in dark mode, `ExerciseScreen` styling. |
| 20 | `ai_settings_and_features_test.dart` | 184 | 6.7 KB | 8 | `AppSettingsService` defaults, model selection (`deepseek-v4-flash`), SharedPreferences persistence, connection testing, `AITutorService` offline exercise generation. |
| 21 | `math_rendering_and_explorer_test.dart` | 249 | 8.7 KB | 8 | `MathMarkdownView` inline KaTeX math (`$...$`) and display math (`$$...$$`) in scrollable cards, malformed/unclosed math error handling, explorer filtering. |
| 22 | `adversarial_reviewer_test.dart` | 554 | 20.1 KB | 12 | State preservation of unlocked proof steps across accordion collapse/expand cycles, `didUpdateWidget` auto-expansion on `targetCorollary`, rapid concurrent toggling of accordion with KaTeX, full-screen dark contrast. |
| 23 | `e2e_content_and_widgets_test.dart` | 569 | 20.8 KB | 18 | 4-Tier E2E tests: Tier 1 declarative linking of 9 templates, Tier 2 units on live widgets, Tier 3 full hierarchy rendering on `NodeDetailScreen`, Tier 4 edge cases and resilience. |

**Total Suite Statistics**:
- Total Files: 23
- Total Source Size: ~245 KB
- Total Test Cases: 251
- Pass Rate: 100% (251 passed in 21 seconds)

---

## 3. Deep Examination of Offline Content Loading Pipeline (R4)

The application uses an offline-first, decoupled content pipeline where educational articles are written in pure Markdown + LaTeX with YAML frontmatter and loaded into memory and the local Isar database.

```
[Markdown File on Disk] (assets/content/<domain>/<id>.md)
         │
         ▼
[ContentLoaderService.loadAllFromBundle()]
         │── 1. AssetManifest listing (production) or knownAssetPaths (headless test fallback)
         │── 2. MarkdownContentParser.parse(rawMarkdown)
         │── 3. Memory cache updated: ContentLoaderService.setCachedNodes()
         │── 4. Cache propagated to CurriculumRegistry.setCachedNodes()
         ▼
[ContentLoaderService.syncToIsar()]
         │── Phase 1: WriteTxn -> serverIdEqualTo(node.serverId).findFirst()
         │           Preserve auto-increment PK (node.id = existing.id) -> isar.knowledgeNodes.put(node)
         │── Phase 2: WriteTxn -> Resolve tempPrerequisiteIds against persisted nodeMap
         │           target.prerequisites.clear() -> add(prereqNode) -> prerequisites.save()
         ▼
[Isar NoSQL Local Database & Knowledge Graph]
```

### 3.1 `ContentLoaderService` (`lib/data/content/content_loader_service.dart`)

1. **Asset Discovery**:
   - In production runtime, `AssetManifest.loadFromAssetBundle(effectiveBundle)` discovers all assets matching `assets/content/**/*.md`.
   - In headless testing environments (`flutter test`), `AssetManifest` is empty or throws. `ContentLoaderService` gracefully detects `mdAssets.isEmpty` and falls back to `knownAssetPaths`.
2. **The `knownAssetPaths` Fallback Array**:
   - Lines 20–56 define 35 hardcoded asset paths spanning arithmetic (4), algebra (8), geometry/trigonometry (5), calculus (13), and physics/circuits (5).
   - **Crucial Requirement**: When adding Linear Algebra articles, their paths MUST be appended to `knownAssetPaths`. Otherwise, headless unit tests (`loadAllFromBundle`) will not load them.
3. **In-Memory Cache & CurriculumRegistry Sync**:
   - Once parsed, nodes are cached in `_cachedNodes` and propagated via `CurriculumRegistry.setCachedNodes(nodes)`.
   - Subsequent calls to `CurriculumRegistry.getAllNodes()` or `CurriculumRegistry.prerequisiteMap` use the dynamically parsed nodes rather than static fallbacks.
4. **2-Phase Transactional Isar Upsert**:
   - **Phase 1 (Node Upsert)**: Queries `isar.knowledgeNodes.where().serverIdEqualTo(node.serverId).findFirst()`. If found, preserves `node.id = existing.id` before executing `isar.knowledgeNodes.put(node)`. This guarantees referential integrity and prevents duplicate rows across re-syncs.
   - **Phase 2 (Prerequisite Link Resolution)**: Once all nodes exist with auto-increment IDs in Isar, Phase 2 queries `nodeMap = {for (final n in persisted) n.serverId: n}`. For each node, it clears `target.prerequisites`, resolves each string in `node.tempPrerequisiteIds` to its target entity, adds it to `target.prerequisites`, and calls `prerequisites.save()`.

### 3.2 `MarkdownContentParser` (`lib/data/content/markdown_content_parser.dart`)

`MarkdownContentParser` is a zero-dependency, pure-Dart parser designed for robustness:
1. **Frontmatter Parsing**:
   - Strips `---` delimiters.
   - Parses `id`, `title`, `category`, `subCategory`.
   - Parses `prerequisites` in both bracketed format (`[a, b, c]`) and bullet list format (`- a\n- b`).
   - Parses `interactive:` section:
     - `template` / `templateType`: Maps to SDUI template identifier.
     - `unit`: Measurement unit for calculation readout.
     - `equations`: Array of formula strings.
     - `parameters`: Array of slider specifications (`variable`/`name`, `label`, `unit`, `min`, `max`, `default`, `step`).
2. **Body & Proof Parsing**:
   - Divides body at first match of `^##\s+(?:Dimostrazione|Corollario)`.
   - Pre-proof content is partitioned into `ContentBlock` entities:
     - `$$...$$` $\to$ `math_latex`
     - `> ...` $\to$ `info_box` (with `**Insight:**` / `**Intuizione:**` stripped)
     - Standard paragraphs $\to$ `text_markdown`
   - Proof section is parsed into sequential `ProofStep` entities:
     - Supports multiple sections (`## Dimostrazione: [Name]`, `## Corollario: [Name]`).
     - Extracts step descriptions (`### 1. ...`), KaTeX equations (`$$...$$`), and `> **Insight:**` callouts.
     - Supports nested sub-steps (`#### 1. ...`) for comprehensive corollary proofs without dropping equations.
3. **Effective Blocks Fallback**:
   - If a topic has an empty `blocks` array, `KnowledgeNode.effectiveBlocks` synthesizes equivalent blocks from `algebraicProof`, ensuring backward compatibility and rendering stability.

### 3.3 Static Fallback Catalog Layer (`lib/data/catalog/`)

When Isar is uninitialized and no bundle has been loaded, `CurriculumRegistry.getAllNodes()` falls back to static catalog definitions:
- `ArithmeticCatalog` (4 nodes)
- `AlgebraCatalog` (8 nodes)
- `GeometryTrigCatalog` (5 nodes)
- `CalculusCatalog` (13 nodes)
- `PhysicsCatalog` (5 nodes)
- `CurriculumRegistry._defaultPrerequisiteMap` (hardcoded 35-entry prerequisite map).

---

## 4. Static Analysis & Build Hygiene

### 4.1 Configuration (`analysis_options.yaml`)
```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - build/**
    - android/**
    - ios/**
    - "**/*.g.dart"
    - web/**
  errors:
    experimental_member_use: ignore
```

### 4.2 Static Analysis Results
- Executing `flutter analyze` across the entire repository:
  ```
  Analyzing Laurentius...
  No issues found! (ran in 84.4s)
  ```
- Result: **0 errors, 0 warnings, 0 lints**.
- Build Runner / Isar Generator: All Isar schemas (`knowledge_node.g.dart`) are up to date.

---

## 5. Requirements for the Linear Algebra Expansion (R2, R3, R4)

The latest user request specifies:
1. **Curriculum Module**: At least 5 sequential articles in `assets/content/linear_algebra/` (or `assets/content/algebra/linear_algebra/`).
2. **Interactive Simulation**: A 2D vector simulation widget for vector sums (parallelogram / tip-to-tail) and linear combinations ($c_1 \mathbf{v}_1 + c_2 \mathbf{v}_2$).
3. **Architectural Integrity**: Zero cycles in the DAG, offline ingestion into Isar, zero errors in `flutter analyze`, and 100% test pass rate.

### 5.1 The 5 Linear Algebra Topics & Prerequisite DAG

To maintain pedagogical coherence and topological integrity, the 5 topics should be structured as follows:

| Order | Topic ID | Title | Prerequisites | Linked Interactive Template | Corollario Enunciato |
|---|---|---|---|---|---|
| 1 | `mat_nupla_01` | Concetto di $n$-upla ordinata e Spazio $\mathbb{R}^n$ | `['mat_mul_01', 'mat_quad_eq_01']` | `live_equation` | Dimensione dello spazio e principio di uguaglianza per componenti |
| 2 | `mat_vec_geom_01` | Vettori Geometrici e Coordinate Cartesiane | `['mat_nupla_01', 'mat_pythagoras_01']` | `vector_2d_simulation` | Modulo euclideo come corollario del Teorema di Pitagora |
| 3 | `mat_vec_ops_01` | Operazioni Vettoriali: Somma e Prodotto Scalare | `['mat_vec_geom_01']` | `vector_2d_simulation` | Regola del Parallelogramma e Disuguaglianza Triangolare |
| 4 | `mat_vec_span_01` | Combinazioni Lineari e Spazio Generato ($\text{span}$) | `['mat_vec_ops_01']` | `vector_2d_simulation` | Chiusura lineare e caratterizzazione geometrica dello span (Retta/Piano) |
| 5 | `mat_vec_indep_01` | Dipendenza e Indipendenza Lineare | `['mat_vec_span_01']` | `vector_2d_simulation` | Criterio di annullamento a coefficienti non nulli e complanarità |

### 5.2 Critical Invariant: Unique Root Node (`mat_add_01`)

In `test/challenger_curriculum_stress_test.dart` (lines 166–169):
```dart
final rootNodes = nodeIds.where((id) => inDegree[id] == 0).toList();
expect(rootNodes, equals(['mat_add_01']),
    reason: 'mat_add_01 must be the unique ultimate foundational root of the entire curriculum');
```
**Mandatory Guideline**: `mat_nupla_01` must NOT declare `prerequisites: []`. It must declare prerequisites that link back to the foundational tree (e.g. `mat_mul_01` from arithmetic and/or `mat_quad_eq_01` from algebra). This guarantees that `mat_add_01` remains the sole root of the curriculum DAG.

### 5.3 Hardcoded Test Count Assertions to Update

When expanding from 35 to 40 nodes, the following test assertions will fail unless updated:

1. **`test/markdown_content_loader_test.dart`**:
   - Line 560: `expect(allNodes.length, 35)` $\to$ change to `40` (or `>= 35`)
   - Line 710: `expect(topologicalOrder.length, 35)` $\to$ change to `40`
   - Line 823: `expect(loadedNodes.length, 35)` $\to$ change to `40`
   - Line 827: `expect(idSet.length, 35)` $\to$ change to `40`
   - Line 862: `expect(visited.length, 35)` $\to$ change to `40`
   - Line 879, 891, 903, 905, 906: `expect(..., 35)` $\to$ change to `40`
2. **`test/challenger_curriculum_stress_test.dart`**:
   - Line 25: `expect(diskFiles.length, 35)` $\to$ change to `40`
   - Line 26: `expect(known.length, 35)` $\to$ change to `40`
   - Line 40–64: `validTemplates` set must include `'vector_2d_simulation'`, `'linear_combination'`, `'vector_simulation'`
   - Line 118: `expect(parsedNodes.length, 35)` $\to$ change to `40`
   - Line 187: `expect(topoOrder.length, 35)` $\to$ change to `40`
3. **`ContentLoaderService.knownAssetPaths`**:
   - Must append the 5 new `.md` paths.
4. **`CurriculumRegistry._defaultPrerequisiteMap`**:
   - Must append the 5 new prerequisite relationships.
5. **`pubspec.yaml`**:
   - Under `flutter: assets:`, add `- assets/content/linear_algebra/`.

---

## 6. Interactive 2D Vector Simulation Widget Specification & Test Harness

### 6.1 Widget Architecture (`Vector2dSimulationWidget`)
- **Location**: `lib/presentation/widgets/interactive/vector_2d_simulation_widget.dart`
- **Template Aliases**: `vector_2d_simulation`, `linear_combination`, `vector_simulation`, `vector_ops`
- **State & Parameters**:
  - Vector 1: $\mathbf{v}_1 = (x_1, y_1)$ (default: $(3, 1)$)
  - Vector 2: $\mathbf{v}_2 = (x_2, y_2)$ (default: $(1, 2)$)
  - Scalar multipliers: $c_1$ (default: $1.0$, min: $-3.0$, max: $3.0$, step: $0.5$) and $c_2$ (default: $1.0$, min: $-3.0$, max: $3.0$, step: $0.5$)
  - Resultant vector: $\mathbf{w} = c_1 \mathbf{v}_1 + c_2 \mathbf{v}_2 = (c_1 x_1 + c_2 x_2, c_1 y_1 + c_2 y_2)$
- **Interactive Controls**:
  - Sliders for $c_1, c_2, x_1, y_1, x_2, y_2$.
  - Touch gesture drag on Cartesian canvas for vector tips $\mathbf{v}_1$ and $\mathbf{v}_2$.
  - Mode toggles:
    - *Somma Semplice (Parallelogramma)*: Shows parallelogram ghost lines and resultant diagonal.
    - *Combinazione Lineare*: Highlights scaled vectors $c_1 \mathbf{v}_1, c_2 \mathbf{v}_2$ and resultant $\mathbf{w}$.
    - *Indipendenza Lineare / Span*: Computes $\det(\mathbf{v}_1, \mathbf{v}_2) = x_1 y_2 - x_2 y_1$. Displays badge: "LINEARMENTE INDIPENDENTI (Span = ℝ²)" when $\det \neq 0$ vs "COLLEARI / DIPENDENTI (Span = Retta)" when $\det = 0$.
- **Autoplay Suppression**:
  - Must mount in a static/paused state with 0 automated motion on initial render, complying with Requirement R1.

---

## 7. Four-Tier E2E Testing Strategy

To ensure zero regressions, mathematical precision, and robustness across the entire application, testing for the new Linear Algebra module and interactive vector simulation must follow the established 4-Tier methodology:

```
┌────────────────────────────────────────────────────────────────────────┐
│  Tier 4: Real-World Scenarios & Curriculum Graph Continuity            │
│  - Topological sort across 40 nodes; full learning pathway simulation │
│  - Multi-tab navigation; mobile memory & gesture 60fps responsiveness  │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
┌───────────────────────────────────▼────────────────────────────────────┐
│  Tier 3: Cross-Feature Integration                                     │
│  - Spotlight Search ➔ 1-Tap Navigation to Linear Algebra topic         │
│  - NodeDetailScreen accordion (Theory, Proof, Vector Simulation)       │
│  - Offline Isar database synchronization & cache propagation           │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
┌───────────────────────────────────▼────────────────────────────────────┐
│  Tier 2: Boundary & Corner Cases                                       │
│  - Collinear vectors (det = 0, collinearity singularity)               │
│  - Zero vector (0, 0), negative scalars, canvas boundary clamping      │
│  - Missing parameters in YAML frontmatter, malformed equations         │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
┌───────────────────────────────────▼────────────────────────────────────┐
│  Tier 1: Feature Coverage                                              │
│  - Pure Dart parsing of all 5 Linear Algebra Markdown files            │
│  - Template routing: vector_2d_simulation ➔ Vector2dSimulationWidget   │
│  - Step-by-step proofs, KaTeX math blocks, and corollary extraction   │
│  - Slider unit binding and telemetry evaluations                       │
└────────────────────────────────────────────────────────────────────────┘
```

### Detailed Tier Breakdown

#### Tier 1: Feature Coverage (Unit & Parser Integrity)
1. **Frontmatter Ingestion**: Verify `MarkdownContentParser` correctly parses all 5 Linear Algebra articles (`mat_nupla_01` to `mat_vec_indep_01`), extracting metadata, prerequisites, and interactive parameter bindings.
2. **Template Factory Dispatch**: Verify `InteractiveTemplateFactory.buildWidget()` maps `vector_2d_simulation`, `linear_combination`, and `vector_simulation` to `Vector2dSimulationWidget`.
3. **Proof & Corollary Verification**: Verify every Linear Algebra article contains non-empty `algebraicProof` with at least one explicitly identified corollary step (`isCorollary == true`).
4. **LaTeX Block Compliance**: Verify all formula strings parse into `math_latex` blocks without raw unescaped tokens.

#### Tier 2: Boundary & Corner Cases
1. **Collinear Vectors (Linear Dependence Singularity)**:
   - When $\mathbf{v}_1 = (2, 1)$ and $\mathbf{v}_2 = (4, 2)$, $\det = 0$.
   - Verify that the simulation does not crash or divide by zero.
   - Verify that the telemetry displays "Collineari / Linearmente Dipendenti" and the span area indicator collapses to 0.
2. **Zero Vector Input**:
   - Set $\mathbf{v}_1 = (0, 0)$ or scalars $c_1 = 0, c_2 = 0$.
   - Verify that vector rendering collapses gracefully to the origin without rendering NaN or infinite arrow coordinates.
3. **Negative Scalar Multipliers**:
   - Set $c_1 = -2.0$.
   - Verify that the vector reverses direction visually (pointing into the opposite quadrant) and coordinates reflect negative values.
4. **Extreme Slider Boundaries**:
   - Sliders dragged to $\min = -3.0$ and $\max = 3.0$; verify defensive clamping via `.clamp(min, max)`.
5. **Frontmatter Resilience**:
   - Missing `parameters` or missing `equations` in frontmatter does not crash the parser or widget.

#### Tier 3: Cross-Feature Integration
1. **Spotlight Search Integration**:
   - Typing keywords: "n-upla", "vettori", "combinazione lineare", "span", "indipendenza lineare".
   - Verify that `SpotlightIndexService` matches the new topics and corollaries with high score (>50.0).
   - Selecting a result directly opens `NodeDetailScreen` in $\le 1$ tap.
2. **Wikipedia-Style Accordion Integration**:
   - `NodeDetailScreen` mounts with the 3 collapsible sections:
     - `APPROFONDIMENTO TEORICO`
     - `DIMOSTRAZIONE LOGICO-ALGEBRICA`
     - `LABORATORIO INTERATTIVO` (housing `Vector2dSimulationWidget`).
   - Collapsing and re-expanding sections preserves the vector coordinates and proof unlock state.
3. **Dark Mode Rendering**:
   - Verify vector canvas uses bright high-contrast vectors on dark background (`AppTheme.bgDark` 0xFF101214).
   - KaTeX formulas render in crisp light off-white text (`AppTheme.textPrimary` 0xFFEAECF0).
4. **Offline Isar Sync**:
   - `ContentLoaderService.syncToIsar` persists the 5 nodes into Isar and binds the prerequisite links via `IsarLinks<KnowledgeNode>`.

#### Tier 4: Real-World Application Scenarios
1. **End-to-End Curriculum Traversal**:
   - A simulated student navigates from `mat_add_01` $\to$ `mat_pythagoras_01` $\to$ `mat_nupla_01` $\to$ `mat_vec_geom_01` $\to$ `mat_vec_ops_01` $\to$ `mat_vec_span_01` $\to$ `mat_vec_indep_01`.
   - Kahn's algorithm confirms the entire 40-node graph is strictly acyclic.
2. **60 FPS Vector Manipulation**:
   - Interactive touch drag on vector endpoints executes smooth CustomPainter repaints without jank or memory leakage.
3. **Offline Cold Boot**:
   - Cold boot with empty SharedPreferences and offline bundle loads all 40 topics instantly.

---

## 8. Proposed Test Code Specifications

The following concrete test files should be implemented when adding the Linear Algebra module:

### Specification 1: `test/linear_algebra_content_and_dag_test.dart`
```dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/data/catalog/curriculum_registry.dart';
import 'package:laurentius/data/content/content_loader_service.dart';
import 'package:laurentius/data/content/markdown_content_parser.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/widgets/interactive/interactive_template_factory.dart';

void main() {
  group('Linear Algebra Curriculum & DAG Integrity Tests (40 Nodes)', () {
    const laIds = [
      'mat_nupla_01',
      'mat_vec_geom_01',
      'mat_vec_ops_01',
      'mat_vec_span_01',
      'mat_vec_indep_01',
    ];

    test('1. All 5 Linear Algebra markdown files exist on disk and parse cleanly', () {
      for (final id in laIds) {
        final path = 'assets/content/linear_algebra/$id.md';
        final file = File(path);
        expect(file.existsSync(), isTrue, reason: 'File $path must exist');

        final content = file.readAsStringSync();
        final node = MarkdownContentParser.parse(content);

        expect(node.serverId, id);
        expect(node.category, 'Matematica');
        expect(node.subCategory, 'Algebra Lineare');
        expect(node.title.trim().isNotEmpty, isTrue);
        expect(node.algebraicProof.isNotEmpty, isTrue);

        final hasCorollary = node.algebraicProof.any((s) => s.isCorollary);
        expect(hasCorollary, isTrue, reason: '$id must contain at least one corollary');
      }
    });

    test('2. Root node invariant: mat_add_01 remains the unique foundational root', () {
      final allNodes = CurriculumRegistry.getAllNodes();
      final nodeIds = allNodes.map((n) => n.serverId).toSet();
      final graph = CurriculumRegistry.prerequisiteMap;

      final inDegree = <String, int>{for (final id in nodeIds) id: 0};
      for (final prereqs in graph.values) {
        for (final p in prereqs) {
          inDegree[p] = (inDegree[p] ?? 0);
        }
      }
      for (final entry in graph.entries) {
        final dep = entry.key;
        for (final prereq in entry.value) {
          inDegree[dep] = (inDegree[dep] ?? 0) + 1;
        }
      }

      final rootNodes = nodeIds.where((id) => inDegree[id] == 0).toList();
      expect(rootNodes, equals(['mat_add_01']),
          reason: 'mat_add_01 must remain the unique foundational root after adding linear algebra');
    });

    test('3. Topological Kahn sort successfully orders all 40 curriculum nodes without cycles', () {
      final allNodes = CurriculumRegistry.getAllNodes();
      expect(allNodes.length, 40);

      final nodeIds = allNodes.map((n) => n.serverId).toSet();
      final graph = CurriculumRegistry.prerequisiteMap;

      final inDegree = <String, int>{for (final id in nodeIds) id: 0};
      final dependents = <String, List<String>>{for (final id in nodeIds) id: []};

      for (final entry in graph.entries) {
        final dep = entry.key;
        for (final prereq in entry.value) {
          expect(nodeIds.contains(prereq), isTrue, reason: 'Unknown prereq $prereq in node $dep');
          dependents[prereq]!.add(dep);
          inDegree[dep] = (inDegree[dep] ?? 0) + 1;
        }
      }

      final queue = [for (final id in nodeIds) if (inDegree[id] == 0) id];
      final topoOrder = <String>[];

      while (queue.isNotEmpty) {
        final u = queue.removeAt(0);
        topoOrder.add(u);
        for (final v in dependents[u]!) {
          inDegree[v] = inDegree[v]! - 1;
          if (inDegree[v] == 0) queue.add(v);
        }
      }

      expect(topoOrder.length, 40, reason: 'Curriculum DAG must be strictly acyclic over all 40 nodes');
      
      // Ensure linear algebra sequence is topologically ordered
      final indexMap = {for (int i = 0; i < topoOrder.length; i++) topoOrder[i]: i};
      expect(indexMap['mat_add_01']!, lessThan(indexMap['mat_nupla_01']!));
      expect(indexMap['mat_nupla_01']!, lessThan(indexMap['mat_vec_geom_01']!));
      expect(indexMap['mat_vec_geom_01']!, lessThan(indexMap['mat_vec_ops_01']!));
      expect(indexMap['mat_vec_ops_01']!, lessThan(indexMap['mat_vec_span_01']!));
      expect(indexMap['mat_vec_span_01']!, lessThan(indexMap['mat_vec_indep_01']!));
    });
  });
}
```

### Specification 2: `test/vector_2d_simulation_widget_test.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurentius/domain/models/knowledge_node.dart';
import 'package:laurentius/presentation/widgets/interactive/interactive_template_factory.dart';
import 'package:laurentius/presentation/widgets/interactive/vector_2d_simulation_widget.dart';

void main() {
  group('Vector2dSimulationWidget Interactive & Geometric Tests', () {
    testWidgets('1. Mounts in static/paused state with zero autoplay (R1 requirement)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Vector2dSimulationWidget(),
            ),
          ),
        ),
      );
      await tester.pump();

      // Verify title and controls
      expect(find.text('Laboratorio Vettori 2D & Combinazioni Lineari'), findsOneWidget);
      expect(find.textContaining('v₁ ='), findsOneWidget);
      expect(find.textContaining('v₂ ='), findsOneWidget);

      // Verify no automated motion occurred
      await tester.pump(const Duration(seconds: 2));
      expect(tester.takeException(), isNull);
    });

    testWidgets('2. Interactive sliders update vector components and resultant accurately', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Vector2dSimulationWidget(),
            ),
          ),
        ),
      );
      await tester.pump();

      final sliders = find.byType(Slider);
      expect(sliders, findsAtLeastNWidgets(2));

      // Drag scalar c1 slider
      await tester.drag(sliders.first, const Offset(50, 0));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('3. Detects and flags collinearity / linear dependence when det = 0', (tester) async {
      final collinearData = InteractiveData()
        ..templateType = 'vector_2d_simulation'
        ..parameters = [
          InteractiveParameter()..variableName = 'x1'..defaultValue = 2.0,
          InteractiveParameter()..variableName = 'y1'..defaultValue = 1.0,
          InteractiveParameter()..variableName = 'x2'..defaultValue = 4.0,
          InteractiveParameter()..variableName = 'y2'..defaultValue = 2.0,
        ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Vector2dSimulationWidget(data: collinearData),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.textContaining('DIPENDENTI'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
```

---

## 9. Conclusion & Pre-Implementation Action Items

The test suite and build infrastructure of Laurentius are currently in pristine health (100% test pass rate, 0 analyzer issues). To implement the Linear Algebra module and the 2D vector simulation widget without regressions:

1. **Pubspec**: Register `assets/content/linear_algebra/` in `pubspec.yaml`.
2. **Content Loader Service**: Append the 5 new `.md` paths to `ContentLoaderService.knownAssetPaths`.
3. **Curriculum Registry**: Add the 5 new node prerequisite pairs into `CurriculumRegistry._defaultPrerequisiteMap` and ensure `mat_nupla_01` has prerequisites from arithmetic/algebra to preserve `mat_add_01` as the sole foundational root.
4. **Catalog Fallbacks**: Add fallback node definitions into `AlgebraCatalog` or create `LinearAlgebraCatalog`.
5. **SDUI Factory**: Register `vector_2d_simulation`, `linear_combination`, and `vector_simulation` in `InteractiveTemplateFactory.buildWidget()` and `validTemplates` in `challenger_curriculum_stress_test.dart`.
6. **Existing Test Count Updates**: Update hardcoded `35` assertions to `40` across `markdown_content_loader_test.dart` and `challenger_curriculum_stress_test.dart`.
7. **New Test Suites**: Add unit and widget tests adhering to the 4-tier E2E testing strategy outlined above.
