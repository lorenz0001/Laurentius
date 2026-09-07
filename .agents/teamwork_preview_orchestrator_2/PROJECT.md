# Project: Laurentius (Brilliant-OS) Visual & Curriculum Overhaul

## Architecture
- **Tech Stack**: Flutter 3.x / Dart 3.x, Isar Database (offline-first NoSQL), KaTeX/flutter_math_fork, math_expressions, GraphView.
- **Visual Design**: Brilliant.org style — generous whitespace, rounded geometry (R12-R16), pastel domain accents, step-by-step cognitive unlocking, 60fps vector graphics.
- **Module Boundaries**:
  - `lib/presentation/widgets/interactive/`: Simulation widgets and factory routing.
  - `assets/content/`: Human-editable Markdown articles with YAML frontmatter and LaTeX math.
  - `lib/data/content/`: `ContentLoaderService` (offline asset discovery and Isar ingestion) and `MarkdownContentParser`.
  - `lib/data/catalog/`: In-memory fallback catalogs and `CurriculumRegistry`.
  - `test/`: Comprehensive unit, widget, navigation, animation, and DAG test suites.

## Feature Inventory
| # | Feature | Description | Milestone | Source | Status |
|---|---------|-------------|-----------|--------|--------|
| 1 | Autoplay Suppression (R1) | 7 simulation widgets initialize paused/static with clean default geometry | M1 | ORIGINAL_REQUEST §R1 | DONE |
| 2 | Explicit User Controls (R1) | Play/pause buttons, step buttons, sliders, drag gestures | M1 | ORIGINAL_REQUEST §R1 | DONE |
| 3 | Trig Circle Tangent (R2) | Collinear ray rendering across all 4 quadrants | M1 | ORIGINAL_REQUEST §R2 | DONE |
| 4 | Trig Circle Asymptotes (R2) | Smooth clamping and infinity arrows without flickering near $\pi/2, 3\pi/2$ | M1 | ORIGINAL_REQUEST §R2 | DONE |
| 5 | Rolle/Lagrange Diagrams (R2) | High-readability static-by-default diagrams; Rolle shows both stationary points | M1 | ORIGINAL_REQUEST §R2 | DONE |
| 6 | Squeeze Theorem Widget (R2) | Dedicated `SqueezeTheoremWidget` for Carabinieri theorem with envelope | M1 | ORIGINAL_REQUEST §R2 | DONE |
| 7 | Carnot's Geometric Proof (R2) | Law of Cosines via altitude $h = a\sin\gamma$ and projection $p = a\cos\gamma$ | M1 | ORIGINAL_REQUEST §R2 | DONE |
| 8 | Animation Test Suite Alignment (R1) | Update existing tests expecting autoplay to expect paused-on-mount | M1 | ORIGINAL_REQUEST §Acceptance Criteria | DONE |
| 9 | Sub-folder Structure (R3) | Create `assets/content/calculus/limits/` and register in `pubspec.yaml` | M2 | ORIGINAL_REQUEST §R3 | DONE |
| 10 | Limit Definition Article (R3) | Rigorous $\epsilon$-$\delta$ article `mat_limits_01.md` with proofs & corollaries | M2 | ORIGINAL_REQUEST §R3 | DONE |
| 11 | Sine Remarkable Limit (R3) | `mat_lim_sinc_01.md` ($\lim_{x \to 0} \frac{\sin x}{x} = 1$) with area proof & squeeze link | M2 | ORIGINAL_REQUEST §R3 | DONE |
| 12 | Cosine Remarkable Limit (R3) | `mat_lim_cos_01.md` ($\lim_{x \to 0} \frac{1-\cos x}{x^2} = \frac{1}{2}$) with conjugate proof | M2 | ORIGINAL_REQUEST §R3 | DONE |
| 13 | Euler's Number Limit (R3) | `mat_lim_e_01.md` ($\lim_{x \to \pm\infty} (1+1/x)^x = e$) with binomial proof | M2 | ORIGINAL_REQUEST §R3 | DONE |
| 14 | Exponential Limit (R3) | `mat_lim_exp_01.md` ($\lim_{x \to 0} \frac{e^x-1}{x} = 1$) with variable change proof | M2 | ORIGINAL_REQUEST §R3 | DONE |
| 15 | Logarithmic Limit (R3) | `mat_lim_log_01.md` ($\lim_{x \to 0} \frac{\ln(1+x)}{x} = 1$) with power law proof | M2 | ORIGINAL_REQUEST §R3 | DONE |
| 16 | Migration of mat_limits_01 (R3) | Move to `limits/` subfolder, remove duplicate in parent directory | M2 | ORIGINAL_REQUEST §R3 | DONE |
| 17 | Content Loader Updates (R3) | Update `knownAssetPaths` in `ContentLoaderService` with 6 limit paths | M2 | ORIGINAL_REQUEST §R3 | DONE |
| 18 | In-Memory Catalog Updates (R3) | Add fallbacks for 6 limit topics in `CalculusCatalog` | M2 | ORIGINAL_REQUEST §R3 | DONE |
| 19 | Unbroken Prerequisite DAG (R4) | 29-node acyclic DAG in `CurriculumRegistry._defaultPrerequisiteMap` | M2 | ORIGINAL_REQUEST §R4 | DONE |
| 20 | DAG & Loader Test Alignment (R4) | Update `test/markdown_content_loader_test.dart` assertions to 29 topics | M2 | ORIGINAL_REQUEST §Acceptance Criteria | DONE |
| 21 | Static Analysis Verification | `flutter analyze` passes with 0 errors and 0 warnings | M3 | ORIGINAL_REQUEST §Acceptance Criteria | DONE |
| 22 | Full Test Suite Verification | `flutter test` passes all 146+ tests (184 total) without regressions | M3 | ORIGINAL_REQUEST §Acceptance Criteria | DONE |
| 23 | Forensic Integrity Audit | Independent verification that implementations are genuine and not stubbed | M3 | Audit Enforcement | DONE |

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| M1 | Interactive Widgets & Animation Overhaul | Refactor 7 simulation widgets to paused-by-default (R1); fix Trig Circle tangent/asymptotes, Rolle/Lagrange diagrams, Carnot projection in TriangleSolver, and create SqueezeTheoremWidget (R2); align animation test suite. | none | DONE |
| M2 | Curriculum Modularization, Limits & Prerequisite DAG | Register `limits/` in `pubspec.yaml`; create 6 comprehensive limit articles in `assets/content/calculus/limits/`; update `ContentLoaderService.knownAssetPaths`, `CalculusCatalog`, and `CurriculumRegistry`; update DAG and content loader tests (R3, R4). | none | DONE |
| M3 | Full Integration, Regression Testing & Forensic Audit | End-to-end integration, full `flutter analyze` (0 errors, 0 warnings), full `flutter test` execution, reviewer validation, challenger stress testing, and forensic audit. | M1, M2 | DONE |

## Code Layout & Write Ownership
- **Milestone 1 (Interactive Widgets)**:
  - `lib/presentation/widgets/interactive/kinematics_simulation_widget.dart`
  - `lib/presentation/widgets/interactive/ohm_circuit_simulation_widget.dart`
  - `lib/presentation/widgets/interactive/trig_circle_widget.dart`
  - `lib/presentation/widgets/interactive/cartesian_graph_widget.dart`
  - `lib/presentation/widgets/interactive/derivative_tangent_widget.dart`
  - `lib/presentation/widgets/interactive/riemann_sum_widget.dart`
  - `lib/presentation/widgets/interactive/triangle_solver_widget.dart`
  - `lib/presentation/widgets/interactive/rolle_lagrange_widget.dart`
  - `lib/presentation/widgets/interactive/squeeze_theorem_widget.dart` (new)
  - `lib/presentation/widgets/interactive/interactive_template_factory.dart`
  - `test/all_animations_test.dart`
  - `test/interactive_simulation_test.dart`
  - `test/step12_reorganization_and_simulations_test.dart`
  - `test/math_rendering_and_explorer_test.dart`
  - `test/m1_challenger2_simulation_stress_test.dart`
- **Milestone 2 (Curriculum & DAG)**:
  - `pubspec.yaml`
  - `assets/content/calculus/limits/mat_limits_01.md`
  - `assets/content/calculus/limits/mat_lim_sinc_01.md`
  - `assets/content/calculus/limits/mat_lim_cos_01.md`
  - `assets/content/calculus/limits/mat_lim_e_01.md`
  - `assets/content/calculus/limits/mat_lim_exp_01.md`
  - `assets/content/calculus/limits/mat_lim_log_01.md`
  - `lib/data/content/content_loader_service.dart`
  - `lib/data/catalog/calculus_catalog.dart`
  - `lib/data/catalog/curriculum_registry.dart`
  - `test/markdown_content_loader_test.dart`
  - `test/curriculum_dag_test.dart`

## Interface Contracts
### SqueezeTheoremWidget ↔ InteractiveTemplateFactory
- Template key: `squeeze_theorem`
- Template aliases: `carabinieri_theorem`, `teorema_carabinieri`
- Parameters: `delta` (bound slider, min: 0.05, max: 1.5, default: 0.8), `k` (frequency factor, default: 1.0)
- Rendering: $g(x) = \cos(x)$, $f(x) = \sin(x)/x$, $h(x) = 1$, shaded corridor between $g(x)$ and $h(x)$, probe point at $x \to 0$.

### mat_limits_* ↔ InteractiveTemplateFactory
- `mat_limits_01`: `template: function_graph` or `rolle_lagrange`
- `mat_lim_sinc_01`: `template: squeeze_theorem` (or `function_graph`), equations `["sin(k * x) / x"]`
- `mat_lim_cos_01`: `template: function_graph`, equations `["(1 - cos(x)) / (x * x)"]`
- `mat_lim_e_01`: `template: function_graph`, equations `["(1 + 1 / x)^x"]`
- `mat_lim_exp_01`: `template: function_graph`, equations `["(2.71828^x - 1) / x"]`
- `mat_lim_log_01`: `template: function_graph`, equations `["ln(1 + x) / x"]`
