# Architectural Survey Report: Content Decoupling & In-Memory Compaction (R1 & R3)

**Agent Identity:** `teamwork_preview_explorer_survey_2`  
**Working Directory:** `c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_explorer_survey_2`  
**Timestamp:** 2026-09-07T12:05:00Z  
**Target:** Laurentius (Flutter/Dart offline-first STEM knowledge tree)  

---

## 1. Observation

### 1.1 Current Knowledge/Content Storage & Loading Architecture
1. **Model Hierarchy** (`lib/domain/models/knowledge_node.dart`):
   - `@collection class KnowledgeNode` (lines 5–107):
     - `Id id = Isar.autoIncrement` (line 7).
     - `@Index(unique: true, replace: true) late String serverId` (lines 9–10).
     - `late String title`, `late String category`, `String? subCategory` (lines 12–16).
     - `final prerequisites = IsarLinks<KnowledgeNode>()` (line 18).
     - `List<ProofStep> algebraicProof = []` (line 20).
     - `List<ContentBlock> blocks = []` (line 22).
     - `InteractiveData? interactiveData` (line 24).
     - `late DateTime lastUpdated` (line 26).
     - `@ignore List<String> tempPrerequisiteIds = []` (lines 30–31): temporary container used during JSON deserialization prior to Isar relation linking.
     - `@ignore List<ContentBlock> get effectiveBlocks` (lines 37–64): if `blocks.isNotEmpty` returns `blocks`; otherwise transforms each `ProofStep` into three synthetic `ContentBlock` objects (`text_markdown`, `math_latex`, `info_box`).
   - `@embedded class ContentBlock` (lines 109–121): `String? type`, `String? content`. Types used across the app: `'text_markdown'`, `'math_latex'`, `'info_box'`, `'image'`.
   - `@embedded class ProofStep` (lines 123–137): `String? description`, `String? latexEquation`, `String? insight`.
   - `@embedded class InteractiveData` (lines 139–157): `String? templateType`, `List<String>? equations`, `List<InteractiveParameter>? parameters`. **Lacks a `unit` / `resultUnit` field**.
   - `@embedded class InteractiveParameter` (lines 159–179): `String? variableName`, `String? label`, `double? minValue`, `double? maxValue`, `double? defaultValue`, `double? stepSize`. **Lacks a `unit` field**.

2. **Database Bootstrap & Population** (`lib/core/services/mock_data_service.dart` & `lib/main.dart`):
   - In `lib/main.dart` (lines 23–28):
     ```dart
     final dir = await getApplicationDocumentsDirectory();
     isar = await Isar.open([KnowledgeNodeSchema], directory: dir.path);
     await MockDataService.populateDatabase(isar);
     ```
   - In `lib/core/services/mock_data_service.dart` (lines 8–13):
     ```dart
     class MockDataService {
       static Future<void> populateDatabase(Isar isar) async {
         await CurriculumRegistry.syncToIsar(isar);
       }
     }
     ```
     `MockDataService` is an empty 14-line pass-through wrapper delegating exclusively to `CurriculumRegistry.syncToIsar(isar)`.

3. **In-Memory Registry & Sync Routine** (`lib/data/catalog/curriculum_registry.dart`):
   - Concatenates 5 individual Dart catalogs into `getAllNodes()` (lines 15–23):
     ```dart
     static List<KnowledgeNode> getAllNodes() {
       return [
         ...ArithmeticCatalog.getAllNodes(),
         ...AlgebraCatalog.getAllNodes(),
         ...GeometryTrigCatalog.getAllNodes(),
         ...CalculusCatalog.getAllNodes(),
         ...PhysicsCatalog.getAllNodes(),
       ];
     }
     ```
   - Hardcodes `prerequisiteMap` as a static `Map<String, List<String>>` (lines 27–65) with 24 distinct topic keys.
   - Executes a 2-Phase transaction in `syncToIsar(Isar isar)` (lines 68–119):
     - **Phase 1 (Upsert)**: Loops through `allNodes`, checks `isar.knowledgeNodes.where().serverIdEqualTo(node.serverId).findFirst()`, preserves the primary auto-increment `id` if present, and runs `isar.knowledgeNodes.put(node)`.
     - **Phase 2 (Prerequisite Linking)**: Reloads all persisted nodes into an in-memory map `nodeMap`, iterates `prerequisiteMap.entries`, loads `targetNode.prerequisites`, clears them, appends `nodeMap[prereqId]`, and calls `targetNode.prerequisites.save()`.

4. **Persistence Repository** (`lib/data/repositories/node_repository.dart`):
   - `Future<void> saveNode(KnowledgeNode node)`: puts node and calls `node.prerequisites.save()`.
   - `Future<KnowledgeNode?> getNodeByServerId(String serverId)`: queries `isar.knowledgeNodes.getByServerId(serverId)`.
   - `Future<List<KnowledgeNode>> getAllNodes()`: queries all nodes and iterates `await node.prerequisites.load()`.

5. **Remote Sychronization Service** (`lib/core/services/sync_service.dart`):
   - Connects to FastAPI endpoint `GET /api/nodes` (`http://10.229.178.148:8000/api/nodes`, timeout 4s).
   - Deserializes JSON via `KnowledgeNode.fromJson`.
   - Implements the exact same two-phase upsert and prerequisite resolution as `CurriculumRegistry.syncToIsar` (lines 46–86).

6. **Web / Headless UI Fallback Paths**:
   - `lib/presentation/pages/home_screen.dart` (lines 130–147): If `widget.isar == null`, calls `CurriculumRegistry.getAllNodes()` and manually stitches `target.prerequisites.add(prereq)` using `CurriculumRegistry.prerequisiteMap`.
   - `lib/presentation/pages/category_explorer_screen.dart` (lines 106–111): If `widget.isar == null`, falls back to `CurriculumRegistry.getAllNodes()`.
   - `lib/presentation/widgets/node_search_delegate.dart` (line 87): Falls back to `CurriculumRegistry.getAllNodes()`.

7. **Interactive Widget Factory & Slider Implementations**:
   - `InteractiveTemplateFactory.buildWidget(data)` (`lib/presentation/widgets/interactive/interactive_template_factory.dart`):
     - Maps `templateType` to: `OhmCircuitSimulationWidget` (`'circuit_simulation'`, `'ohm_simulation'`), `KinematicsSimulationWidget` (`'kinematics_simulation'`, `'rectilinear_motion'`), `RolleLagrangeWidget` (`'rolle_lagrange'`, `'rolle'`, `'lagrange'`), `CartesianGraphWidget` (`'function_graph'`, `'cartesian_plot'`), `TrigCircleWidget` (`'trig_circle'`, `'trigonometric_circle'`), `TriangleSolverWidget` (`'triangle_solver'`, `'pythagoras_carnot'`), `DerivativeTangentWidget` (`'derivative_tangent'`, `'difference_quotient'`), `RiemannSumWidget` (`'riemann_sum'`, `'riemann_integral'`), `LiveEquationWidget` (`'live_equation'`).
   - `LiveEquationWidget` (`lib/presentation/widgets/interactive/live_equation_widget.dart`):
     - Line 257: Hardcodes `'V'` immediately beside `formattedResult`:
       ```dart
       Text(
         formattedResult,
         style: const TextStyle(fontSize: 36, ...),
       ),
       const SizedBox(width: 8),
       const Text(
         'V',
         style: TextStyle(fontSize: 20, ...),
       ),
       ```
     - Evaluates mathematical expressions using `math_expressions` (`GrammarParser`, `RealEvaluator`).
     - Slider readouts display only `formattedValue` without parameter units.
   - `KinematicsSimulationWidget` (`lib/presentation/widgets/interactive/kinematics_simulation_widget.dart`):
     - Lines 285 & 301 hardcode `unit: 'm/s'` and `unit: 'm/s²'`.
   - `OhmCircuitSimulationWidget` (`lib/presentation/widgets/interactive/ohm_circuit_simulation_widget.dart`):
     - Lines 288 & 306 hardcode `unit: 'V'` and `unit: 'Ω'`.

---

### 1.2 Structure of Hardcoded In-Memory Catalogs & Duplication (R1)
There are 5 catalog files in `lib/data/catalog/` totaling **1,391 lines of pure Dart code**:
1. `arithmetic_catalog.dart` (233 lines, 4 nodes: `mat_add_01`, `mat_mul_01`, `mat_frac_01`, `mat_pow_01`)
2. `algebra_catalog.dart` (246 lines, 4 nodes: `mat_binom_01`, `mat_quad_eq_01`, `mat_parabola_01`, `mat_log_01`)
3. `geometry_trig_catalog.dart` (226 lines, 5 nodes: `mat_triang_01`, `mat_pythagoras_01`, `mat_trig_circ_01`, `mat_trig_add_01`, `mat_trig_triang_01`)
4. `calculus_catalog.dart` (345 lines, 6 nodes: `mat_limits_01`, `mat_deriv_def_01`, `mat_deriv_rules_01`, `mat_deriv_theorems_01`, `mat_riemann_01`, `mat_fund_calc_01`)
5. `physics_catalog.dart` (341 lines, 5 nodes: `phys_kin_01`, `ele_ohm_01`, `ele_power_01`, `ele_joule_01`, `chem_ph_01`)

**Observed Duplications and Anomalies:**
- **Dual Content Representation in Dart**:
  - 13 nodes (`mat_add_01`, `mat_binom_01`, `mat_triang_01`, `mat_pythagoras_01`, `mat_trig_circ_01`, `mat_deriv_def_01`, `mat_deriv_rules_01`, `mat_deriv_theorems_01`, `mat_riemann_01`, `mat_fund_calc_01`, `phys_kin_01`, `ele_ohm_01`, `ele_power_01`, `ele_joule_01`, `chem_ph_01`) define BOTH `blocks` and `algebraicProof`, repeating identical explanations, formulas, and insights across two separate embedded lists.
  - 11 nodes (`mat_mul_01`, `mat_frac_01`, `mat_pow_01`, `mat_quad_eq_01`, `mat_parabola_01`, `mat_log_01`, `mat_trig_add_01`, `mat_trig_triang_01`, `mat_limits_01`) define ONLY `algebraicProof`, relying on the runtime getter `effectiveBlocks` to synthesize `blocks`.
- **Double Maintenance of the DAG**:
  - Prerequisite edges are declared in `CurriculumRegistry.prerequisiteMap` independently from node declarations. If a developer alters prerequisites in a node or adds a new topic, they must remember to update both the catalog node factory and `CurriculumRegistry.prerequisiteMap`.
- **Divergence with Server Data Nodes**:
  - The Python server has 7 JSON nodes in `server/data_nodes/` (`ohm.json`, `kinematics.json`, `joule.json`, etc.).
  - In `server/data_nodes/ohm.json`, line 5 sets `"prerequisites": []`, while `CurriculumRegistry.prerequisiteMap` sets `'ele_ohm_01': ['mat_frac_01']`.
  - In `ohm.json`, parameter `R` max is `48.0` and default is `6.0`, whereas in `PhysicsCatalog._createOhmNode()`, max is `50.0` and default is `10.0`.
- **Code Bloat**:
  - Every single pedagogical content change (fixing math typesetting, updating an insight, changing an explanation) requires altering compiled Dart source files rather than declarative content files.

---

### 1.3 Dependencies & Parsing Capabilities in `pubspec.yaml`
Inspection of `pubspec.yaml` (lines 30–60) reveals:
- **Dependencies Present**:
  - `flutter`: SDK
  - `cupertino_icons: ^1.0.8`
  - `isar: ^3.1.0+1` & `isar_flutter_libs: ^3.1.0+1`: Local offline database
  - `path_provider: ^2.1.6`: Storage path resolution
  - `flutter_math_fork: ^0.7.4`: High-performance LaTeX math rendering engine (displays inline `MathStyle.text` and display `MathStyle.display`)
  - `math_expressions: ^3.2.0`: Mathematical expression parsing and real-number evaluation
  - `graphview: ^1.5.1`: Graph visualization for knowledge tree
  - `http: ^1.6.0`: Network client
  - `flutter_dotenv: ^6.0.1`: Environment variables
  - `flutter_markdown: ^0.7.6`: Markdown rendering widget (used in `ai_tutor_qna_bottom_sheet.dart`)
  - `shared_preferences: ^2.5.4`: Key-value storage
- **Dependencies Absent**:
  - `yaml` is **not** listed in `pubspec.yaml` dependencies or dev_dependencies, nor present in `.dart_tool/package_config.json`.
- **Skill Directives** (`.agents/skills/laurentius-dev/SKILL.md`, Section 4):
  - *"Non introdurre nuovi pacchetti senza prima avvisare e giustificare la scelta."*
- **Assets Registration** (`pubspec.yaml`, lines 72–74):
  - Currently only registers `.env`. No asset folders exist under `assets/`.

---

## 2. Inventory of Current In-Memory Content (All 24 Nodes)

The table below catalogs all 24 knowledge nodes to be migrated into `assets/content/**/*.md`, including their current catalog location, interactive template, parameter configuration, and unit decoupling requirements:

| # | Server ID | Title | Category & SubCategory | Prerequisites | Template Key | Parameters & Current Units | Required Equation Unit (R4) |
|---|---|---|---|---|---|---|---|
| 1 | `mat_add_01` | Addizione e Struttura Algebrica | Matematica / Aritmetica e Fondamenti | `[]` | `live_equation` | `a` [-20..20, d:5, s:1], `b` [-20..20, d:7, s:1] | `""` (no unit) |
| 2 | `mat_mul_01` | Moltiplicazione e Proprietà Distributiva | Matematica / Aritmetica e Fondamenti | `mat_add_01` | `live_equation` | `a` [-10..10, d:4, s:1], `b` [-10..10, d:-3, s:1] | `""` (no unit) |
| 3 | `mat_frac_01` | Frazioni, Rapporti e Numeri Razionali | Matematica / Frazioni e Rapporti | `mat_mul_01` | `live_equation` | `a` [-20..20, d:6, s:1], `b` [1..20, d:8, s:1] | `""` (no unit) |
| 4 | `mat_pow_01` | Potenze, Radici ed Esponenti Reali | Matematica / Potenze e Radicali | `mat_mul_01` | `live_equation` | `a` [0.5..5, d:2, s:0.5], `b` [-3..4, d:3, s:1] | `""` (no unit) |
| 5 | `mat_binom_01` | Prodotti Notevoli e Scomposizioni | Matematica / Polinomi e Prodotti Notevoli | `mat_pow_01` | `live_equation` | `a` [-5..5, d:2, s:0.5], `b` [-5..5, d:3, s:0.5] | `""` (no unit) |
| 6 | `mat_quad_eq_01` | Equazioni di Secondo Grado e Discriminante | Matematica / Equazioni di Secondo Grado | `mat_binom_01`, `mat_frac_01` | `function_graph` | `a` [-3..3, d:1, s:0.5], `b` [-6..6, d:-2, s:0.5], `c` [-6..6, d:-3, s:0.5] | `""` (no unit) |
| 7 | `mat_parabola_01` | Funzione Quadratica e Parabola | Matematica / Funzioni e Geometria Analitica | `mat_quad_eq_01` | `function_graph` | `a` [-3..3, d:1, s:0.1], `b` [-4..4, d:0, s:0.2], `c` [-5..5, d:-2, s:0.5] | `""` (no unit) |
| 8 | `mat_log_01` | Logaritmi ed Esponenziali | Matematica / Funzioni Esponenziali e Logaritmiche | `mat_pow_01` | `live_equation` | `x` [0.5..50, d:8, s:0.5], `b` [1.5..10, d:2, s:0.5] | `""` (no unit) |
| 9 | `mat_triang_01` | Geometria del Triangolo e Angoli Interni | Matematica / Geometria Euclidea Piana | `mat_add_01` | `triangle_solver` | *(internal geometry state)* | `""` (geometry) |
| 10 | `mat_pythagoras_01` | Teorema di Pitagora ed Euclide | Matematica / Geometria Euclidea Piana | `mat_triang_01`, `mat_binom_01` | `triangle_solver` | *(internal geometry state)* | `""` (geometry) |
| 11 | `mat_trig_circ_01` | Circonferenza Goniometrica e Relazione Fondamentale | Matematica / Goniometria Fondamentale | `mat_pythagoras_01` | `trig_circle` | *(angle θ internal slider)* | `rad` / `°` |
| 12 | `mat_trig_add_01` | Formule Goniometriche: Addizione, Duplicazione e Bisezione | Matematica / Goniometria Fondamentale | `mat_trig_circ_01` | `trig_circle` | *(angle θ internal slider)* | `rad` / `°` |
| 13 | `mat_trig_triang_01` | Teoremi dei Triangoli: Carnot, Seni e Formula dell'Area | Matematica / Trigonometria dei Triangoli | `mat_trig_add_01`, `mat_pythagoras_01` | `triangle_solver` | *(internal sides/angles state)* | `""` (geometry) |
| 14 | `mat_limits_01` | Limiti di Funzione e Limiti Notevoli | Matematica / Limiti e Continuità | `mat_trig_circ_01`, `mat_frac_01` | `function_graph` | `k` [0.5..3.0, d:1.0, s:0.5] | `""` (no unit) |
| 15 | `mat_deriv_def_01` | Rapporto Incrementale e Definizione di Derivata | Matematica / Calcolo Differenziale | `mat_limits_01` | `derivative_tangent` | *(secant/tangent slider h, x0)* | `""` (analysis) |
| 16 | `mat_deriv_rules_01` | Regole di Derivazione: Prodotto, Quoziente e Catena | Matematica / Calcolo Differenziale | `mat_deriv_def_01`, `mat_binom_01` | `derivative_tangent` | *(secant/tangent slider h, x0)* | `""` (analysis) |
| 17 | `mat_deriv_theorems_01` | Teoremi di Rolle, Lagrange e Criterio di Monotonia | Matematica / Teoremi Differenziali | `mat_deriv_rules_01` | `rolle_lagrange` | `a` [-2.4..-0.2, d:-1.8, s:0.1], `b` [0.2..2.4, d:1.4, s:0.1] | `""` (analysis) |
| 18 | `mat_riemann_01` | Integrale di Riemann e Somme di Rettangoli | Matematica / Calcolo Integrale | `mat_deriv_theorems_01`, `mat_limits_01` | `riemann_sum` | *(subdivision partition sliders)* | `""` (analysis) |
| 19 | `mat_fund_calc_01` | Teorema Fondamentale del Calcolo (Torricelli-Barrow) | Matematica / Calcolo Integrale | `mat_riemann_01`, `mat_deriv_def_01` | `riemann_sum` | *(subdivision partition sliders)* | `""` (analysis) |
| 20 | `phys_kin_01` | Cinematica: Moto Rettilineo e Corollario di Torricelli | Fisica / Cinematica e Dinamica | `mat_parabola_01`, `mat_deriv_rules_01`, `mat_fund_calc_01` | `kinematics_simulation` | `v0` [0..30, d:5, s:1, unit: `"m/s"`], `a` [-5..10, d:2, s:0.5, unit: `"m/s²"`] | `"m/s"` |
| 21 | `ele_ohm_01` | Legge di Ohm e Resistenza Elettrica | Elettrotecnica / Circuiti in Corrente Continua | `mat_frac_01` | `circuit_simulation` | `V` [1..24, d:12, s:1, unit: `"V"`], `R` [1..50, d:10, s:1, unit: `"Ω"`] | `"A"` / `"V"` |
| 22 | `ele_power_01` | Potenza Elettrica nei Circuiti | Elettrotecnica / Circuiti in Corrente Continua | `ele_ohm_01` | `live_equation` | `V` [1..48, d:12, s:1, unit: `"V"`], `I` [0.1..10, d:2, s:0.1, unit: `"A"`] | `"W"` *(Bug: currently shows 'V')* |
| 23 | `ele_joule_01` | Effetto Joule e Dissipazione Termica | Elettrotecnica / Termodinamica & Circuiti | `ele_power_01`, `mat_fund_calc_01` | `live_equation` | `R` [1..20, d:5, s:1, unit: `"Ω"`], `I` [0.5..5, d:2, s:0.5, unit: `"A"`], `t` [1..60, d:10, s:1, unit: `"s"`] | `"J"` *(Bug: currently shows 'V')* |
| 24 | `chem_ph_01` | Chimica Fisica: Soluzioni Acido-Base e Calcolo del pH | Fisica / Chimica Fisica | `mat_log_01` | `live_equation` | `c` [0.0000001..0.1, d:0.001, s:0.001, unit: `"M"`] | `""` / `"pH"` *(Bug: currently shows 'V')* |

---

## 3. Logic Chain

1. **Premise 1**: Requirements R1 and R3 demand decoupling content into standalone `.md` files under `assets/content/**/*.md` without Dart code, and eliminating redundant boilerplate and duplicate in-memory data declarations.
2. **Premise 2**: Existing test suites (`test/curriculum_dag_test.dart`, `test/step11_navigation_content_test.dart`, `test/step12_reorganization_and_simulations_test.dart`) enforce strict structural invariants:
   - Every node must have non-empty `serverId`, `title`, `category`, and `subCategory`.
   - Every node must have a non-empty `algebraicProof` with at least one step clearly identifying a `"Corollario"` in `description` or `insight`.
   - The prerequisite graph must be strictly acyclic (DAG validated via topological sort).
   - `CurriculumRegistry.getAllNodes()` and `CurriculumRegistry.prerequisiteMap` are invoked across tests and UI fallback paths.
3. **Premise 3**: In `LiveEquationWidget`, line 257 renders `const Text('V')` unconditionally. In equations computing Power ($P = V \cdot I$, watts), Joule Heat ($Q = R \cdot I^2 \cdot t$, joules), pH (dimensionless), or basic arithmetic (sums, products, powers), this hardcoded `'V'` produces incorrect physical and mathematical readouts.
4. **Premise 4**: `pubspec.yaml` currently does not include the `yaml` package. Adding unvetted external dependencies violates skill directives unless strictly justified. However, the YAML frontmatter schema for educational articles is well-defined, compact, and deterministic.
5. **Deduction A (Content Organization)**:
   - Articles should be stored in 5 category subdirectories under `assets/content/`:
     - `assets/content/arithmetic/` (4 files)
     - `assets/content/algebra/` (4 files)
     - `assets/content/geometry_trig/` (5 files)
     - `assets/content/calculus/` (6 files)
     - `assets/content/physics/` (5 files)
   - In `pubspec.yaml`, each directory containing assets must be declared under `flutter: assets:`.
6. **Deduction B (Frontmatter Schema & Article Structure)**:
   - The frontmatter must capture all metadata: `id`, `title`, `category`, `subCategory`, `prerequisites`, and an `interactive` object defining `template`, `unit`, `equations`, and `parameters` (including variable name, label, unit, min, max, default, step).
   - The article body must use pure Markdown and LaTeX math:
     - Introductory pedagogical narrative with inline `$ ... $` and display `$$ ... $$` math.
     - Theory callouts using blockquotes (`> **Insight:** ...`).
     - A structured `## Dimostrazione` section with numbered steps (`### 1. Titolo`), equations, and explicit `### Corollario: [Nome]` blocks.
7. **Deduction C (Offline Parser & Ingestion Engine)**:
   - A zero-dependency pure Dart parser (`MarkdownContentParser`) can extract the YAML frontmatter and parse the Markdown/LaTeX body into `KnowledgeNode`, `ContentBlock`s, `ProofStep`s, and `InteractiveData`.
   - A service (`ContentLoaderService`) utilizes `AssetManifest.loadFromAssetBundle(rootBundle)` to discover all `.md` files, read them offline via `rootBundle.loadString()`, and parse them.
   - Database ingestion into Isar follows the proven 2-phase transaction: Phase 1 upserts nodes preserving primary keys; Phase 2 connects `IsarLinks<KnowledgeNode>`.
   - An in-memory cache is populated on startup so that headless or web test environments without Isar continue functioning seamlessly without duplicating hardcoded catalog Dart files.
8. **Deduction D (R4 Unit Decoupling)**:
   - `InteractiveParameter` and `InteractiveData` in `knowledge_node.dart` must be extended with an optional `String? unit` field.
   - `LiveEquationWidget` is refactored to remove `const Text('V')` and instead render `widget.data.unit ?? ''` (or omit the suffix entirely if null/empty).
   - Parameter sliders across `LiveEquationWidget`, `KinematicsSimulationWidget`, and `OhmCircuitSimulationWidget` dynamically read `param.unit`.

---

## 4. Proposed Technical Architecture & Specifications

### 4.1 Recommended YAML Frontmatter Schema

Each article starts with a YAML frontmatter block between `---` delimiters:

```yaml
---
id: phys_kin_01
title: "Cinematica: Moto Rettilineo e Corollario di Torricelli"
category: "Fisica"
subCategory: "Cinematica e Dinamica"
prerequisites:
  - mat_parabola_01
  - mat_deriv_rules_01
  - mat_fund_calc_01
interactive:
  template: kinematics_simulation
  unit: "m/s"
  equations:
    - "v0 + a * t"
  parameters:
    - variable: v0
      label: "Velocità Iniziale (v₀)"
      unit: "m/s"
      min: 0.0
      max: 30.0
      default: 5.0
      step: 1.0
    - variable: a
      label: "Accelerazione Costante (a)"
      unit: "m/s²"
      min: -5.0
      max: 10.0
      default: 2.0
      step: 0.5
---
```

#### Field Specifications:
- `id` (String, required): Unique identifier corresponding to `serverId`.
- `title` (String, required): Human-readable title displayed in AppBar and cards.
- `category` (String, required): Broad discipline (`Matematica`, `Fisica`, `Elettrotecnica`).
- `subCategory` (String, required): Specific branch (e.g. `Cinematica e Dinamica`, `Calcolo Integrale`).
- `prerequisites` (List of Strings, required): Server IDs of direct prerequisite topics in the DAG.
- `interactive` (Object, optional):
  - `template` (String, required if interactive): Key matching `InteractiveTemplateFactory` (e.g. `live_equation`, `circuit_simulation`, `kinematics_simulation`, `function_graph`, `trig_circle`, `triangle_solver`, `derivative_tangent`, `rolle_lagrange`, `riemann_sum`).
  - `unit` (String, optional): Measurement unit for the live equation output readout (e.g. `"W"`, `"J"`, `"m/s"`, `"V"`, or `""`).
  - `equations` (List of Strings, optional): Mathematical formulas evaluated at runtime.
  - `parameters` (List of Objects, optional): Configuration for sliders:
    - `variable` (String): Variable name bound into `ContextModel` (e.g. `v0`, `a`, `V`, `R`).
    - `label` (String): Display label for the slider.
    - `unit` (String, optional): Unit displayed beside the slider value (e.g. `"m/s"`, `"Ω"`, `"V"`).
    - `min` (Double): Minimum slider bound.
    - `max` (Double): Maximum slider bound.
    - `default` (Double): Default starting value.
    - `step` (Double, optional): Slider increment step.

---

### 4.2 Recommended Markdown / LaTeX Article Format

Below is the standardized structure for an educational article body:

```markdown
### Il Moto Rettilineo Uniformemente Accelerato

Nel moto rettilineo con accelerazione costante $a$, la variazione temporale della velocità è costante:
- La velocità cresce linearmente nel tempo: $v(t) = v_0 + at$
- La posizione $x(t)$ è una parabola nel tempo, ottenuta per **integrazione definita** della velocità:

$$x(t) = x_0 + v_0 t + \frac{1}{2} a t^2$$

> **Insight:** La celebre **Formula di Torricelli** elimina il tempo $t$ dal sistema, collegando direttamente velocità e spostamento: $v^2 = v_0^2 + 2a\Delta x$.

## Dimostrazione Logico-Algebrica

### 1. Definizione di accelerazione costante
$$a = \frac{dv}{dt} = \text{costante} \implies v(t) = v_0 + a t$$
> **Insight:** La velocità cresce in modo direttamente proporzionale al tempo trascorso.

### 2. Legge oraria per integrazione temporale
$$x(t) = x_0 + \int_0^t v(t) dt = x_0 + v_0 t + \frac{1}{2} a t^2$$
> **Insight:** L'area sotto la retta delle velocità nel piano (t, v) genera il termine parabolico quadratico.

### 3. Isolamento della variabile temporale t
$$t = \frac{v - v_0}{a}$$
> **Insight:** Elimina il parametro temporale unificando cinematica e geometria cartesiana.

### 4. Sostituzione nella legge dello spostamento
$$\Delta x = v_0 \left(\frac{v - v_0}{a}\right) + \frac{1}{2} a \left(\frac{v - v_0}{a}\right)^2$$
> **Insight:** Espansione del quadrato di binomio e somma a denominatore comune 2a.

### 5. Corollario: Formula Senza Tempo di Torricelli
$$v^2 = v_0^2 + 2 a \Delta x$$
> **Insight:** Collega direttamente la velocità finale allo spazio percorso senza necessità di misurare il tempo.
```

#### Dual-Section Mapping:
1. **Pre-`## Dimostrazione` Content** is parsed into `node.blocks`:
   - Text paragraphs -> `ContentBlock(type: 'text_markdown', content: ...)`
   - Standalone `$$...$$` blocks -> `ContentBlock(type: 'math_latex', content: ...)`
   - Blockquotes `> ...` -> `ContentBlock(type: 'info_box', content: ...)`
2. **`## Dimostrazione` Content** is parsed into `node.algebraicProof`:
   - Each `### [Step Title]` -> `ProofStep.description`
   - `$$ [Latex] $$` -> `ProofStep.latexEquation`
   - `> **Insight:** [Text]` -> `ProofStep.insight`
3. This guarantees full fidelity with both `NodeDetailScreen` views (the theoretical content block flow and the step-by-step collapsible proof widget), while fully satisfying existing test assertions (`node.algebraicProof.isNotEmpty` and corollary keywords).

---

### 4.3 Offline Content Loader & Parser Architecture

```
[Assets: assets/content/**/*.md]
             │
             ▼
    [AssetManifest.loadFromAssetBundle(rootBundle)]
             │
             ▼
    [ContentLoaderService.loadAllArticles()]
             │
             ▼
    [MarkdownContentParser.parse(String mdContent)]
      ├── 1. Frontmatter Extractor (--- ... ---)
      ├── 2. YAML Key/Value & List Parser (Zero-dep Dart)
      ├── 3. Body Block & Step Splitter
      └── 4. KnowledgeNode Model Hydrator
             │
             ▼
    [KnowledgeContentSynchronizer]
      ├── Phase 1: Isar Upsert (preserving AutoIncrement IDs)
      ├── Phase 2: DAG IsarLinks<KnowledgeNode> Connection
      └── In-Memory Cache for Web/Headless Fallback (CurriculumRegistry)
```

#### Zero-Dependency Frontmatter Parser vs. `package:yaml`:
- **Recommendation**: Implement a dedicated, zero-dependency pure Dart parser (`FrontmatterParser`) in ~100 lines.
  - Reason 1: Adheres strictly to skill guidelines prohibiting unapproved dependencies.
  - Reason 2: Completely eliminates versioning conflicts or pub upgrade frictions.
  - Reason 3: The schema is strictly bounded (strings, lists of strings, nested parameter maps with double/string fields). A simple recursive or stateful line-reader parses this deterministically in microseconds.
- **Alternative**: If approved by the Lead Engineer, `yaml: ^3.1.2` (the official Dart SDK package from `dart.dev`) can be added to `dependencies`. The parser architecture should isolate YAML parsing behind an interface so the implementation can switch without affecting the loader.

#### Algorithm for Ingestion (`ContentLoaderService` & `MockDataService`):
1. **Discovery**:
   ```dart
   final manifest = await AssetManifest.loadFromAssetBundle(bundle ?? rootBundle);
   final mdAssets = manifest.listAssets().where((p) => p.startsWith('assets/content/') && p.endsWith('.md')).toList();
   ```
2. **Parsing**:
   ```dart
   final nodes = <KnowledgeNode>[];
   for (final path in mdAssets) {
     final content = await (bundle ?? rootBundle).loadString(path);
     final node = MarkdownContentParser.parse(content);
     nodes.add(node);
   }
   ```
3. **Database Ingestion (Two-Phase Transaction)**:
   - **Phase 1**:
     ```dart
     await isar.writeTxn(() async {
       for (final node in nodes) {
         final existing = await isar.knowledgeNodes.where().serverIdEqualTo(node.serverId).findFirst();
         if (existing != null) node.id = existing.id;
         await isar.knowledgeNodes.put(node);
       }
     });
     ```
   - **Phase 2**:
     ```dart
     await isar.writeTxn(() async {
       final persisted = await isar.knowledgeNodes.where().findAll();
       final map = {for (final n in persisted) n.serverId: n};
       for (final node in nodes) {
         final target = map[node.serverId];
         if (target == null) continue;
         await target.prerequisites.load();
         target.prerequisites.clear();
         for (final pId in node.tempPrerequisiteIds) {
           final prereq = map[pId];
           if (prereq != null) target.prerequisites.add(prereq);
         }
         await target.prerequisites.save();
       }
     });
     ```
4. **In-Memory Cache Population**:
   - Update `CurriculumRegistry.setLoadedNodes(nodes)` so that `CurriculumRegistry.getAllNodes()` and `CurriculumRegistry.prerequisiteMap` are dynamically backed by the loaded Markdown nodes.
   - This eliminates the need for hardcoding 1,391 lines of catalog Dart code while maintaining 100% backward compatibility with all web modes and existing test suites.

---

### 4.4 Configurable Slider System & Unit Decoupling (R4)

1. **Model Updates** (`lib/domain/models/knowledge_node.dart`):
   - Add `String? unit;` to `@embedded class InteractiveParameter`.
   - Add `String? unit;` to `@embedded class InteractiveData`.
   - Update `fromJson` factories in `knowledge_node.dart`:
     - `InteractiveParameter.fromJson`: `..unit = json['unit'] as String?`
     - `InteractiveData.fromJson`: `..unit = json['unit'] as String?`
   - Run `dart run build_runner build --delete-conflicting-outputs` to regenerate `knowledge_node.g.dart`.

2. **LiveEquationWidget Refactoring** (`lib/presentation/widgets/interactive/live_equation_widget.dart`):
   - In `_buildResultDisplay(String equation)`:
     ```dart
     // BEFORE (hardcoded 'V'):
     const SizedBox(width: 8),
     const Text(
       'V',
       style: TextStyle(
         fontSize: 20,
         fontWeight: FontWeight.w700,
         color: Color(0xFF2563EB),
       ),
     ),

     // AFTER (strictly driven by interactiveData.unit):
     if (widget.data.unit != null && widget.data.unit!.trim().isNotEmpty) ...[
       const SizedBox(width: 8),
       Text(
         widget.data.unit!.trim(),
         style: const TextStyle(
           fontSize: 20,
           fontWeight: FontWeight.w700,
           color: Color(0xFF2563EB),
         ),
       ),
     ],
     ```
   - In `_buildParameterSlider(InteractiveParameter param)`:
     - Update formatted value display:
       ```dart
       final unitSuffix = (param.unit != null && param.unit!.trim().isNotEmpty)
           ? ' ${param.unit!.trim()}'
           : '';
       final displayVal = '$formattedValue$unitSuffix';
       ```
     - Renders `displayVal` inside the badge so users see `"12 V"`, `"10 Ω"`, `"5 m/s"`, or `"2"` cleanly.

3. **Kinematics & Circuit Simulation Refactoring**:
   - In `KinematicsSimulationWidget` (`lib/presentation/widgets/interactive/kinematics_simulation_widget.dart`):
     - Pass `param.unit` from `widget.data.parameters` rather than hardcoding `'m/s'` and `'m/s²'`.
   - In `OhmCircuitSimulationWidget` (`lib/presentation/widgets/interactive/ohm_circuit_simulation_widget.dart`):
     - Pass `param.unit` from `widget.data.parameters` rather than hardcoding `'V'` and `'Ω'`.

---

## 5. Recommended Test Strategy

### 5.1 New Automated Tests
1. **`test/content/markdown_content_parser_test.dart`**:
   - `test('Parses complete frontmatter metadata correctly')`: Verifies `id`, `title`, `category`, `subCategory`, `prerequisites`, and `interactive` fields.
   - `test('Handles missing optional frontmatter fields gracefully')`: Tests nodes with null/empty `interactive` or `subCategory`.
   - `test('Parses equation unit and parameter units (R4)')`: Verifies that `unit: "N"`, `unit: "W"`, `unit: ""` are deserialized onto `InteractiveData` and `InteractiveParameter`.
   - `test('Parses Markdown theory blocks and LaTeX math blocks')`: Verifies conversion into `ContentBlock`s.
   - `test('Parses proof steps and identifies corollaries')`: Verifies that `### Corollario:` headers produce `ProofStep`s satisfying corollary detection assertions.

2. **`test/content/content_loader_service_test.dart`**:
   - `test('Loads all 24 Markdown articles from assets/content/')`: Verifies that exactly 24 files are discovered and ingested.
   - `test('All parsed articles have unique serverIds matching curriculum specification')`: Verifies IDs from `mat_add_01` to `chem_ph_01`.
   - `test('Prerequisite graph derived from Markdown frontmatter is strictly acyclic')`: Runs topological sort over all 24 articles.

3. **`test/interactive/configurable_slider_units_test.dart`**:
   - `testWidgets('LiveEquationWidget renders custom unit suffix when unit is specified')`: Tests `unit: "N"` -> displays `"N"`.
   - `testWidgets('LiveEquationWidget renders no unit suffix when unit is null or empty')`: Tests `unit: ""` -> verifies `"V"` is NOT displayed.
   - `testWidgets('Parameter sliders render configured unit badges')`: Tests slider with `unit: "m/s"` displays `"m/s"`.

### 5.2 Regression Verification for Existing Tests
All existing tests must continue passing without modification:
- `test/curriculum_dag_test.dart` (validates all nodes, unique IDs, non-empty titles/categories, corollaries, and acyclic DAG).
- `test/step11_navigation_content_test.dart` (validates navigation, subCategories, and ContentBlockFactory).
- `test/step12_reorganization_and_simulations_test.dart` (validates depth ordering and simulation widgets).
- `test/all_animations_test.dart`, `test/interactive_simulation_test.dart`, `test/ai_settings_and_features_test.dart`.

---

## 6. Caveats

1. **Flutter Asset Registration**: Flutter's asset packager does not automatically recurse into subdirectories. When registering `assets/content/` in `pubspec.yaml`, each subfolder (`assets/content/arithmetic/`, `assets/content/algebra/`, `assets/content/geometry_trig/`, `assets/content/calculus/`, `assets/content/physics/`) must be explicitly declared in `pubspec.yaml`.
2. **Isar Code Generation**: Adding `String? unit` to `InteractiveParameter` and `InteractiveData` modifies `@embedded` entities. `build_runner` must be executed to refresh `knowledge_node.g.dart`.
3. **No Network Dependency**: All 24 articles must be bundled in the app package so that cold startup in airplane mode achieves immediate, 100% offline knowledge base population.

---

## 7. Conclusion

1. **Current State**: The content layer currently couples ~1,400 lines of hardcoded Dart catalog declarations with dual content models (`blocks` and `algebraicProof`), duplicate manual DAG graphs, and hardcoded units (`'V'` in live equation evaluation and hardcoded units in physics simulators).
2. **Feasibility**: Decoupling into 24 clean Markdown files under `assets/content/**/*.md` is 100% feasible without adding third-party dependencies, utilizing a lightweight pure Dart frontmatter parser and Flutter's built-in `AssetManifest` / `rootBundle`.
3. **Actionable Plan**:
   - Create 24 human-editable Markdown files under `assets/content/{arithmetic,algebra,geometry_trig,calculus,physics}/`.
   - Register asset paths in `pubspec.yaml`.
   - Implement `MarkdownContentParser` and `ContentLoaderService`.
   - Extend `InteractiveData` and `InteractiveParameter` with `unit` and remove hardcoded `'V'` from `LiveEquationWidget`.
   - Compact `CurriculumRegistry` and `MockDataService` to be backed by the loaded articles.

---

## 8. Verification Method

To independently verify the facts and code locations reported:
1. **Analyze Codebase**:
   ```bash
   flutter analyze
   ```
   *Expected result*: Exits with code 0 and "No issues found!".
2. **Run Test Suite**:
   ```bash
   flutter test
   ```
   *Expected result*: All 62 test cases pass in ~3 seconds.
3. **Inspect Hardcoded 'V' in LiveEquationWidget**:
   Inspect line 257 in `lib/presentation/widgets/interactive/live_equation_widget.dart` using `view_file` to confirm `const Text('V')`.
4. **Inspect Catalog Structure**:
   Inspect `lib/data/catalog/curriculum_registry.dart` lines 15–65 to confirm the 24 hardcoded nodes and duplicate `prerequisiteMap`.
5. **Inspect Pubspec Dependencies**:
   Inspect `pubspec.yaml` lines 30–60 to confirm presence of `flutter_math_fork`, `math_expressions`, `flutter_markdown` and absence of `yaml`.
