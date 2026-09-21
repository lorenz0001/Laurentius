# Project: Laurentius (Brilliant-OS) — Interactive Simulations & Linear Algebra Overhaul

## Architecture
- **Framework**: Flutter / Dart (iOS/Desktop responsive UI, CustomPainter 60fps animations).
- **Storage**: Offline Isar NoSQL database (`KnowledgeNode`, `@embedded` objects, 2-phase transactional sync).
- **Content Engine**: Decoupled Markdown (`assets/content/**/*.md`) with YAML frontmatter, pure KaTeX LaTeX math (`flutter_math_fork`), and declarative interactive widget linking.
- **Simulation Layer**: Factory pattern (`InteractiveTemplateFactory`) routing declarative template keys to 60fps gesture-driven `CustomPainter` widgets.
- **Topology**: Strictly acyclic directed graph (DAG) with unique root node `mat_add_01`.

## Feature Inventory
| # | Feature | Description | Milestone | Source |
|---|---------|-------------|-----------|--------|
| 1 | F1: Cartesian Graph AST Cache | Pre-parse expression once on parameter change instead of per-pixel in paint loop | M1 | survey_interactive_report |
| 2 | F1: Non-Quadratic Equation Display | Correct formula string and hide quadratic vertex for non-parabolic equations | M1 | survey_interactive_report |
| 3 | F1: Rich Physics Pedagogical Rebinding | Rebind `ele_power_01` and `ele_joule_01` from numeric `live_equation` to `circuit_simulation` | M1 | survey_interactive_report |
| 4 | F2: 2D Vector Simulation Widget | Dedicated `Vector2DSimulationWidget` with 3 modes (Components, Addition, Linear Combinations & Span) | M2 | survey_interactive_report / R3 |
| 5 | F2: Vector Direct Touch Dragging | Pan gestures on canvas to drag vector arrowheads $\mathbf{v}_1, \mathbf{v}_2$ at 60fps | M2 | survey_interactive_report / R3 |
| 6 | F2: Vector Template Factory Registration | Register `vector_2d`, `linear_combination`, `vector_addition`, `span_2d` in factory & test whitelist | M2 | survey_interactive_report / R3 |
| 7 | F3: Linear Algebra 5 Sequential Topics | Author 5 rigorous articles from $n$-tuples to linear independence with complete LaTeX proofs | M3 | survey_curriculum_report / R2 |
| 8 | F3: Pubspec & Asset Registration | Register `assets/content/linear_algebra/` in `pubspec.yaml` | M3 | survey_curriculum_report / R2 |
| 9 | F3: Offline Loader & Fallback Sync | Update `ContentLoaderService.knownAssetPaths` and `CurriculumRegistry._defaultPrerequisiteMap` | M3 | survey_curriculum_report / R4 |
| 10 | F4: Unique Root & DAG Topological Invariant | Ensure `lin_alg_01_tuples` connects to `mat_add_01` & `mat_pythagoras_01`, keeping `mat_add_01` as sole root | M4 | survey_testing_report / R4 |
| 11 | F4: Test Count Alignment (35 -> 40) | Align node count assertions in `markdown_content_loader_test` and `challenger_curriculum_stress_test` | M4 | survey_testing_report / R4 |
| 12 | F4: Zero Analyze Issues & 100% Test Pass | `flutter analyze` with 0 issues, 100% tests passing across all test files | M4 | survey_testing_report / R4 |
| 13 | F5: 4-Tier E2E Test Suite | Comprehensive opaque-box test suite (Tiers 1-4) published with `TEST_READY.md` | E2E Track | survey_testing_report / R4 |

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| M1 | Interactive Simulations Audit & Optimization (R1) | AST pre-parse caching & formula display fix in `CartesianGraphWidget`, rebind power/joule topics | none | DONE |
| M2 | 2D Vector Interactive Visualization Widget (R3) | `Vector2DSimulationWidget` (3 modes, canvas touch drag, sliders), template routing & tests | M1 | DONE |
| M3 | Linear Algebra Curriculum & Registration (R2) | 5 sequential nodes in `assets/content/linear_algebra/`, `pubspec.yaml`, loader & registry fallbacks | M2 | DONE |
| M4 | Architectural Integrity, DAG Verification & E2E Validation (R4) | Test count alignment, DAG acyclicity, 0 analyze errors, 100% test pass | M1, M2, M3, E2E | DONE |
| E2E | E2E Testing Track | Independent requirement-driven 4-tier test suite, publishes `TEST_READY.md` | none (parallel) | DONE |

## Interface Contracts

### M1 ↔ M2 (Interactive Widget Layer)
- Files: `lib/presentation/widgets/interactive/`
- Factory entry: `InteractiveTemplateFactory.buildWidget({required InteractiveData data, ...})`
- Contract: M1 optimizes existing widgets and preserves factory routing. M2 adds `Vector2DSimulationWidget` and registers new template keys without breaking existing routes.

### M2 ↔ M3 (Interactive Template Binding)
- Template keys: `vector_2d`, `linear_combination`, `vector_addition`, `span_2d`
- Parameter schema:
  - `lin_alg_01_tuples`: `vx`, `vy` (point coordinates / components)
  - `lin_alg_02_vectors`: `vx`, `vy` (vector components, norm, direction)
  - `lin_alg_03_operations`: `v1x`, `v1y`, `v2x`, `v2y` (vector addition & scalar multiplication)
  - `lin_alg_04_span`: `v1x`, `v1y`, `v2x`, `v2y`, `c1`, `c2` (linear combination & span)
  - `lin_alg_05_independence`: `v1x`, `v1y`, `v2x`, `v2y` (determinant / collinearity test)

### M3 ↔ M4 (Curriculum & Topological Integrity)
- Node IDs: `lin_alg_01_tuples`, `lin_alg_02_vectors`, `lin_alg_03_operations`, `lin_alg_04_span`, `lin_alg_05_independence`
- Prerequisite Chain:
  - `lin_alg_01_tuples` $\to$ `['mat_add_01', 'mat_pythagoras_01']` (inDegree 2)
  - `lin_alg_02_vectors` $\to$ `['lin_alg_01_tuples']`
  - `lin_alg_03_operations` $\to$ `['lin_alg_02_vectors']`
  - `lin_alg_04_span` $\to$ `['lin_alg_03_operations']`
  - `lin_alg_05_independence` $\to$ `['lin_alg_04_span']`
- Contract: Topological order depth 4–8, `mat_add_01` strictly retained as sole root with `inDegree == 0`. Every node has $\ge 2$ corollaries with full algebraic derivations.

## Code Layout
- `lib/presentation/widgets/interactive/cartesian_graph_widget.dart` — AST compiler optimization & formula fix
- `lib/presentation/widgets/interactive/vector_2d_simulation_widget.dart` — New 2D vector interactive widget
- `lib/presentation/widgets/interactive/interactive_template_factory.dart` — Template alias routing
- `assets/content/linear_algebra/` — 5 new Markdown curriculum articles
- `pubspec.yaml` — Asset folder declarations
- `lib/data/content/content_loader_service.dart` — Fallback asset paths
- `lib/data/catalog/curriculum_registry.dart` — Prerequisite map and fallback nodes
- `lib/data/catalog/linear_algebra_catalog.dart` — In-memory catalog definitions
- `test/vector_2d_simulation_test.dart` — Dedicated widget & interaction test suite
- `test/curriculum_dag_test.dart` & `test/challenger_curriculum_stress_test.dart` — Topological verification
