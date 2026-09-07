# Laurentius Automated Test Infrastructure & Verification Architecture

## 1. Executive Summary & Test Philosophy

The Laurentius application is an offline-first, Brilliant-style STEM knowledge tree built in Flutter. Its pedagogical integrity relies on two core pillars:
1. **Curriculum Topology & Rigor**: A strictly acyclic directed knowledge graph (DAG) spanning arithmetic, algebra, geometry/trigonometry, calculus, and physics/electrotechnics, where every topic features formal step-by-step mathematical proofs and clearly demarcated corollaries.
2. **Interactive Simulation & Dynamic Evaluation**: High-performance interactive widgets (animated vector simulations, dynamic Cartesian graphs, unit circles, and parameter-driven live equation solvers) declaratively linked via human-editable content files with fully decoupled measurement units.

### 1.1 Opaque-Box, Requirement-Driven Philosophy
Testing in Laurentius strictly adheres to an **opaque-box (black-box)** methodology:
- Tests treat the system and components as functional black boxes, verifying observable inputs, outputs, UI state, rendering trees, and mathematical invariants against specifications rather than internal private variables.
- **No Facade Tests**: Every test exercises genuine execution paths, math evaluation engines, topological graph traversals, and widget layout builds. Trivial assertions that pass unconditionally are strictly prohibited.
- **Requirement-Driven**: Every test case maps directly to requirements in `ORIGINAL_REQUEST.md` (R1–R5) and the interface contracts defined in `PROJECT.md`.

### 1.2 The Four Test Tiers

To ensure complete coverage across all abstraction levels, tests are organized into **4 progressive tiers**:

```
┌─────────────────────────────────────────────────────────────┐
│  Tier 4: Real-World & Topological Curriculum Integrity      │
│  - All 24 curriculum topics, DAG acyclicity, topological    │
│    sort, cross-discipline prerequisites, corollary bounds   │
├─────────────────────────────────────────────────────────────┤
│  Tier 3: Cross-Feature & Declarative Linking Integration   │
│  - Template factory alias resolution, smart cubic routing,   │
│    live slider-to-equation reactive binding, fallback engine│
├─────────────────────────────────────────────────────────────┤
│  Tier 2: Boundary, Corner & Adversarial Stress Cases        │
│  - Missing frontmatter fields, unit null/empty handling,    │
│    division-by-zero, Unicode/LaTeX escapes, cycle rejection │
├─────────────────────────────────────────────────────────────┤
│  Tier 1: Feature Coverage (Happy Paths)                     │
│  - YAML frontmatter extraction, LaTeX block parsing,        │
│    ProofStep/Corollary detection, 9 simulation widgets      │
└─────────────────────────────────────────────────────────────┘
```

1. **Tier 1: Feature Coverage (Core Requirements)**
   - Verification of nominal behavior for Markdown frontmatter parsing, LaTeX block extraction, and ProofStep identification.
   - Instantiation of all 9 interactive simulation widgets via `InteractiveTemplateFactory`.
   - Dynamic equation evaluation and custom unit rendering (e.g. `'W'`, `'J'`, `'N'`, `'m/s'`).

2. **Tier 2: Boundary & Corner Cases**
   - Handling of missing optional metadata (null `subCategory`, empty `prerequisites`, absent `interactive` block).
   - Empty/null unit decoupling: ensuring no suffix is displayed and the deprecated hardcoded `'V'` never appears.
   - Adversarial text inputs: multi-line LaTeX formulas, Greek symbols (`\theta`, `\gamma`, `\Delta`, `\Omega`), accents (`à`, `è`, `é`, `ì`, `ò`, `ù`).
   - Extreme slider parameters: single-step division, negative ranges, zero values.

3. **Tier 3: Cross-Feature / Integration**
   - Frontmatter-to-Widget Pipeline: parsing YAML content and passing deserialized `InteractiveData` directly into `InteractiveTemplateFactory` without intermediate code alteration.
   - Template alias resolution across 17 aliases (e.g. `circuit_simulation` & `ohm_simulation`, `function_graph` & `cartesian_plot`).
   - Smart routing: automatic elevation of `function_graph` containing cubic formulas to `RolleLagrangeWidget`.
   - Fallback engine: routing unspecified templates with parameters or equations to `LiveEquationWidget`.
   - Live state synchronization: verifying that slider manipulation in `LiveEquationWidget` recomputes formulas in real time.

4. **Tier 4: Real-World & Topological Integrity**
   - Comprehensive inventory verification of all 24 curriculum knowledge nodes (`mat_add_01` through `chem_ph_01`).
   - Graph-theoretic validation: constructing adjacency matrices, verifying strict acyclicity (Kahn's algorithm), checking zero self-referential edges, and verifying prerequisite closure.
   - Corollary presence: ensuring 100% of curriculum topics feature at least one identifiable corollary step.

---

## 2. Feature Inventory Test Mapping

The following matrix maps each system requirement to its automated test implementation:

| Req ID | Requirement Description | Tier | Target Suite | Test Function / Group |
|---|---|---|---|---|
| **R3** | YAML Frontmatter Extraction | Tier 1 | `test/markdown_content_loader_test.dart` | `group('YAML Frontmatter Parsing')` -> `parses complete frontmatter metadata` |
| **R3** | LaTeX Math Blocks Parsing | Tier 1 | `test/markdown_content_loader_test.dart` | `group('LaTeX Math Blocks Parsing')` -> `parses display math blocks ($$...$$) into math_latex ContentBlock` |
| **R3** | Theory & Info Box Extraction | Tier 1 | `test/markdown_content_loader_test.dart` | `group('LaTeX Math Blocks Parsing')` -> `parses blockquotes into info_box ContentBlock` |
| **R3** | ProofSteps & Corollary Detection | Tier 1 | `test/markdown_content_loader_test.dart` | `group('ProofSteps & Corollary Detection')` -> `extracts sequential proof steps with titles and insights` |
| **R3** | Optional Frontmatter Fallbacks | Tier 2 | `test/markdown_content_loader_test.dart` | `group('Boundary & Corner Cases')` -> `handles missing subCategory and empty prerequisites` |
| **R3** | Adversarial Unicode & LaTeX Symbols | Tier 2 | `test/markdown_content_loader_test.dart` | `group('Boundary & Corner Cases')` -> `preserves complex LaTeX expressions and Greek symbols` |
| **R3** | Malformed YAML / Markdown Handling | Tier 2 | `test/markdown_content_loader_test.dart` | `group('Boundary & Corner Cases')` -> `gracefully parses without crashing on malformed frontmatter` |
| **R5** | 9 Simulation Widgets Instantiation | Tier 1 | `test/e2e_content_and_widgets_test.dart` | `group('Declarative Widget Linking - Core Templates')` (tests 1–9 for all 9 widgets) |
| **R5** | Template Key Aliases (17 keys) | Tier 3 | `test/e2e_content_and_widgets_test.dart` | `group('Template Factory Aliases & Smart Routing')` -> `resolves all canonical template aliases` |
| **R5** | Smart Cubic Function Routing | Tier 3 | `test/e2e_content_and_widgets_test.dart` | `group('Template Factory Aliases & Smart Routing')` -> `smart routes cubic function_graph to RolleLagrangeWidget` |
| **R5** | Fallback to LiveEquationWidget | Tier 3 | `test/e2e_content_and_widgets_test.dart` | `group('Template Factory Aliases & Smart Routing')` -> `falls back to LiveEquationWidget when templateType is null/generic` |
| **R4** | Configurable Equation Output Unit | Tier 1 | `test/e2e_content_and_widgets_test.dart` | `group('Slider Systems & Unit Decoupling (R4)')` -> `LiveEquationWidget renders custom unit suffix ('W', 'J', 'N')` |
| **R4** | Removal of Hardcoded 'V' | Tier 2 | `test/e2e_content_and_widgets_test.dart` | `group('Slider Systems & Unit Decoupling (R4)')` -> `LiveEquationWidget renders NO unit when unit is empty or null (never hardcoded 'V')` |
| **R4** | Parameter Slider Unit Badges | Tier 1 | `test/e2e_content_and_widgets_test.dart` | `group('Slider Systems & Unit Decoupling (R4)')` -> `parameter sliders display custom unit badge ('m/s', 'Ω')` |
| **R4** | Sliders Without Unit | Tier 2 | `test/e2e_content_and_widgets_test.dart` | `group('Slider Systems & Unit Decoupling (R4)')` -> `parameter sliders without unit display only numeric value` |
| **R4** | Dynamic Math Evaluation & Reactive Sliders | Tier 3 | `test/e2e_content_and_widgets_test.dart` | `group('Cross-Feature Live Equation Reactive Binding')` -> `slider drag updates live evaluation readout in real time` |
| **R1/R3** | 24 Topics Inventory Completeness | Tier 4 | `test/markdown_content_loader_test.dart` | `group('Topological Integrity & Curriculum DAG (All 24 Topics)')` -> `contains exactly 24 unique topic nodes` |
| **R1/R3** | Proofs & Corollaries across All 24 Nodes | Tier 4 | `test/markdown_content_loader_test.dart` | `group('Topological Integrity & Curriculum DAG (All 24 Topics)')` -> `every node defines at least one corollary` |
| **R1/R3** | Strict DAG Acyclicity (Topological Sort) | Tier 4 | `test/markdown_content_loader_test.dart` | `group('Topological Integrity & Curriculum DAG (All 24 Topics)')` -> `prerequisite graph is strictly acyclic (DAG)` |
| **R1/R3** | Prerequisite Closure & Root Node Health | Tier 4 | `test/markdown_content_loader_test.dart` | `group('Topological Integrity & Curriculum DAG (All 24 Topics)')` -> `all referenced prerequisites exist with valid root foundations` |
| **R1/R3** | Cycle Detection Adversarial Assertion | Tier 4 | `test/markdown_content_loader_test.dart` | `group('Topological Integrity & Curriculum DAG (All 24 Topics)')` -> `cycle detection catches and rejects circular dependencies` |

---

## 3. Test Architecture & Directory Layout

Automated tests reside in `test/` under the standard Flutter test structure:

```
test/
├── markdown_content_loader_test.dart      # [NEW - Tier 1, 2, 4] Markdown parsing, YAML, LaTeX, proofs, DAG
├── e2e_content_and_widgets_test.dart       # [NEW - Tier 1, 2, 3] 9 widgets, declarative linking, R4 units
├── live_equation_and_sliders_test.dart     # [M1 Unit Tests] Live equation & slider unit tests
├── curriculum_dag_test.dart                # Existing catalog DAG structural integrity
├── all_animations_test.dart                # 60fps canvas animations (Trig, Kinematics, Ohm, Graph)
├── interactive_simulation_test.dart        # Simulation widget mounting and control interactions
├── step11_navigation_content_test.dart     # Navigation, search, and content block factory
├── step12_reorganization_and_simulations_test.dart # Depth sorting & layout
├── math_rendering_and_explorer_test.dart   # LaTeX rendering & difficulty filters
├── ai_settings_and_features_test.dart      # AI tutor and settings UI
├── graph_algorithm_test.dart               # GraphView layout logic
└── widget_test.dart                        # Flutter smoke test
```

---

## 4. Test Runner Instructions

### 4.1 Running All Tests
To execute the entire automated test suite (including all 4 tiers and regression tests):
```bash
flutter test
```

### 4.2 Running Specific Test Suites
To run the Markdown content loading and DAG acyclicity suite:
```bash
flutter test test/markdown_content_loader_test.dart
```

To run the Declarative Widget Linking and Slider Unit Decoupling E2E suite:
```bash
flutter test test/e2e_content_and_widgets_test.dart
```

To run both new E2E and content suites together:
```bash
flutter test test/markdown_content_loader_test.dart test/e2e_content_and_widgets_test.dart
```

### 4.3 Running with Verbose Output & Filtering
To run only tests matching a specific tag or keyword (e.g. `Declarative`):
```bash
flutter test --plain-name "Declarative"
```

To run with coverage collection:
```bash
flutter test --coverage
```

### 4.4 Static Analysis
Static verification with zero allowed warnings or errors:
```bash
flutter analyze
```

---

## 5. Test Reliability & Independence Guarantees

1. **Self-Contained State**: Every test case constructs its own model fixtures, mock asset bundles, or test widgets. No test relies on global mutable state or execution sequence from other tests.
2. **Deterministic Output Matching**: Numerical calculations in `LiveEquationWidget` and physics simulations are verified using mathematical bounds and explicit formatted strings.
3. **Asynchronous Execution Safety**: All Flutter widget tests utilize `tester.pumpWidget()` and `tester.pumpAndSettle()` to guarantee microtasks, animation frames, and timer loops settle before assertions execute.
4. **Clean Resource Teardown**: Widgets mounted during test runs are cleanly disposed between test cases.
