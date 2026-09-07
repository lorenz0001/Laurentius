# Handoff Report: DAG Integrity, Prerequisite Chains & Test Verification Survey

## 1. Observation

### 1.1 Baseline Test Execution & Analysis
Two primary baseline commands were executed on the workspace `c:\Users\catte\Desktop\Laurentius`:
1. **Static Analysis**:
   - Command: `flutter analyze`
   - Exit code: `0`
   - Output snippet:
     ```text
     Analyzing Laurentius...
     No issues found! (ran in 6.8s)
     ```
2. **Full Test Suite**:
   - Command: `flutter test`
   - Exit code: `0`
   - Output summary:
     ```text
     00:05 +146: All tests passed!
     ```
   - Total test count: Exactly **146 tests** across 14 test files (`test/ai_settings_and_features_test.dart`, `test/all_animations_test.dart`, `test/curriculum_dag_test.dart`, `test/e2e_content_and_widgets_test.dart`, `test/graph_algorithm_test.dart`, `test/interactive_simulation_test.dart`, `test/live_equation_and_sliders_test.dart`, `test/m1_adversarial_challenge_test.dart`, `test/m1_challenger2_simulation_stress_test.dart`, `test/markdown_content_loader_test.dart`, `test/math_rendering_and_explorer_test.dart`, `test/step11_navigation_content_test.dart`, `test/step12_reorganization_and_simulations_test.dart`, `test/widget_test.dart`).

---

### 1.2 Current Curriculum DAG Map (24 Topics)
The current curriculum contains 24 topics defined both as physical Markdown files (`assets/content/**/*.md`) and in-memory fallback catalogs (`lib/data/catalog/*.dart`).

| Server ID | Title | Category | SubCategory | Direct Prerequisites (`prerequisites`) | Interactive Template |
|---|---|---|---|---|---|
| `mat_add_01` | Addizione e Struttura Algebrica | Matematica | Aritmetica e Fondamenti | `[]` *(Root)* | `live_equation` |
| `mat_mul_01` | Moltiplicazione e Proprietà Distributiva | Matematica | Aritmetica e Fondamenti | `['mat_add_01']` | `live_equation` |
| `mat_frac_01` | Frazioni, Rapporti e Numeri Razionali | Matematica | Frazioni e Rapporti | `['mat_mul_01']` | `live_equation` |
| `mat_pow_01` | Potenze, Radici ed Esponenti Reali | Matematica | Potenze e Radicali | `['mat_mul_01']` | `live_equation` |
| `mat_binom_01` | Prodotti Notevoli e Scomposizioni | Matematica | Polinomi e Prodotti Notevoli | `['mat_pow_01']` | `live_equation` |
| `mat_quad_eq_01` | Equazioni di Secondo Grado e Discriminante | Matematica | Equazioni di Secondo Grado | `['mat_binom_01', 'mat_frac_01']` | `function_graph` |
| `mat_parabola_01` | Funzione Quadratica e Parabola | Matematica | Funzioni e Geometria Analitica | `['mat_quad_eq_01']` | `function_graph` |
| `mat_log_01` | Logaritmi ed Esponenziali | Matematica | Funzioni Esponenziali e Logaritmiche | `['mat_pow_01']` | `live_equation` |
| `mat_triang_01` | Geometria del Triangolo e Angoli Interni | Matematica | Geometria Euclidea Piana | `['mat_add_01']` | `triangle_solver` |
| `mat_pythagoras_01` | Teorema di Pitagora ed Euclide | Matematica | Geometria Euclidea Piana | `['mat_triang_01', 'mat_binom_01']` | `triangle_solver` |
| `mat_trig_circ_01` | Circonferenza Goniometrica e Relazione Fondamentale | Matematica | Goniometria Fondamentale | `['mat_pythagoras_01']` | `trig_circle` |
| `mat_trig_add_01` | Formule Goniometriche: Addizione, Duplicazione e Bisezione | Matematica | Goniometria Fondamentale | `['mat_trig_circ_01']` | `trig_circle` |
| `mat_trig_triang_01` | Teoremi dei Triangoli: Carnot, Seni e Formula dell'Area | Matematica | Trigonometria dei Triangoli | `['mat_trig_add_01', 'mat_pythagoras_01']` | `triangle_solver` |
| `mat_limits_01` | Limiti di Funzione e Limiti Notevoli | Matematica | Limiti e Continuità | `['mat_trig_circ_01', 'mat_frac_01']` | `function_graph` |
| `mat_deriv_def_01` | Rapporto Incrementale e Definizione di Derivata | Matematica | Calcolo Differenziale | `['mat_limits_01']` | `derivative_tangent` |
| `mat_deriv_rules_01` | Regole di Derivazione: Prodotto, Quoziente e Catena | Matematica | Calcolo Differenziale | `['mat_deriv_def_01', 'mat_binom_01']` | `derivative_tangent` |
| `mat_deriv_theorems_01` | Teoremi di Rolle, Lagrange e Criterio di Monotonia | Matematica | Teoremi Differenziali | `['mat_deriv_rules_01']` | `rolle_lagrange` |
| `mat_riemann_01` | Integrale di Riemann e Somme di Rettangoli | Matematica | Calcolo Integrale | `['mat_deriv_theorems_01', 'mat_limits_01']` | `riemann_sum` |
| `mat_fund_calc_01` | Teorema Fondamentale del Calcolo (Torricelli-Barrow) | Matematica | Calcolo Integrale | `['mat_riemann_01', 'mat_deriv_def_01']` | `riemann_sum` |
| `phys_kin_01` | Cinematica: Moto Rettilineo e Corollario di Torricelli | Fisica | Cinematica e Dinamica | `['mat_parabola_01', 'mat_deriv_rules_01', 'mat_fund_calc_01']` | `kinematics_simulation` |
| `ele_ohm_01` | Legge di Ohm e Resistenza Elettrica | Elettrotecnica | Circuiti in Corrente Continua | `['mat_frac_01']` | `circuit_simulation` |
| `ele_power_01` | Potenza Elettrica nei Circuiti | Elettrotecnica | Circuiti in Corrente Continua | `['ele_ohm_01']` | `live_equation` |
| `ele_joule_01` | Effetto Joule e Dissipazione Termica | Elettrotecnica | Termodinamica & Circuiti | `['ele_power_01', 'mat_fund_calc_01']` | `live_equation` |
| `chem_ph_01` | Chimica Fisica: Soluzioni Acido-Base e Calcolo del pH | Fisica | Chimica Fisica | `['mat_log_01']` | `live_equation` |

---

### 1.3 Inspection of `test/curriculum_dag_test.dart`
- **What it tests**: Tests `CurriculumRegistry.getAllNodes()` and `CurriculumRegistry.prerequisiteMap`.
- **Physical vs. In-memory**: It does **NOT** read physical markdown files from disk or bundle; it validates the in-memory fallback catalogs (`ArithmeticCatalog`, `AlgebraCatalog`, `GeometryTrigCatalog`, `CalculusCatalog`, `PhysicsCatalog`) and `CurriculumRegistry._defaultPrerequisiteMap` (unless cached by prior tests).
- **Hardcoded node checks**:
  - Lines 42-65 assert presence of 18 specific key IDs:
    ```dart
    expect(ids.contains('mat_add_01'), true);
    ...
    expect(ids.contains('mat_limits_01'), true);
    expect(ids.contains('mat_deriv_def_01'), true);
    expect(ids.contains('mat_deriv_rules_01'), true);
    expect(ids.contains('mat_deriv_theorems_01'), true);
    expect(ids.contains('mat_riemann_01'), true);
    expect(ids.contains('mat_fund_calc_01'), true);
    expect(ids.contains('phys_kin_01'), true);
    ```
  - Line 58 explicitly requires `mat_limits_01` to exist.
- **Cycle & Missing Prerequisite Validation**:
  - Lines 67-89: Iterates through `CurriculumRegistry.prerequisiteMap.entries`, asserting that both key and all values exist in `validIds = CurriculumRegistry.getAllNodes().map((n) => n.serverId).toSet()`.
  - Lines 91-142: Implements Kahn's algorithm (topological sorting using in-degree calculation) and asserts:
    ```dart
    expect(visitedCount, graph.length, reason: 'Ciclo rilevato nel grafo dei prerequisiti! Non è un DAG aciclico valido.');
    ```
    This check is dynamic against `graph.length` (not hardcoded to 24).
- **Corollary verification**: Lines 144-162 verify that every node has at least one step whose description or insight contains `"corollario"`.

---

### 1.4 Inspection of `test/markdown_content_loader_test.dart` & `ContentLoaderService`
- **Fallback List in Production Code**:
  - `lib/data/content/content_loader_service.dart` (lines 20-45) defines:
    ```dart
    static const List<String> knownAssetPaths = [
      'assets/content/arithmetic/mat_add_01.md',
      ...
      'assets/content/calculus/mat_limits_01.md', // line 34
      ...
      'assets/content/physics/chem_ph_01.md',
    ];
    ```
  - In `loadAllFromBundle()`, lines 79-81:
    ```dart
    if (mdAssets.isEmpty) {
      mdAssets = List.from(knownAssetPaths);
    }
    ```
    In headless test environments where `AssetManifest` is empty, `ContentLoaderService` falls back to `knownAssetPaths`.
- **Hardcoded 24 Expectations in `test/markdown_content_loader_test.dart`**:
  Multiple tests hardcode the exact integer `24`:
  - Line 519: `group('Tier 4: Real-World & Topological Curriculum Integrity (All 24 Topics)', () {`
  - Line 524: `expect(allNodes.length, 24, reason: 'Curriculum must contain exactly 24 knowledge topics');`
  - Line 573: `test('Every single one of the 24 topics defines at least one identifiable Corollary step', () {`
  - Line 598: `test('Prerequisite graph over all 24 topics is strictly acyclic (Topological Sort / DAG)', () {`
  - Line 674: `expect(topologicalOrder.length, 24);`
  - Line 733: `test('All 24 physical Markdown files exist on disk and parse successfully', () {`
  - Line 787: `expect(loadedNodes.length, 24);`
  - Line 791: `expect(idSet.length, 24);`
  - Line 826: `expect(visited.length, 24, reason: 'All 24 loaded Markdown articles must form an acyclic DAG');`
  - Line 843: `expect(CurriculumRegistry.getAllNodes().length, 24);`
  - Line 855: `expect(CurriculumRegistry.getAllNodes().length, 24);`
  - Line 867: `expect(nodes.length, 24);`
  - Line 869: `expect(ContentLoaderService.cachedNodes!.length, 24);`
  - Line 870: `expect(CurriculumRegistry.getAllNodes().length, 24);`
- **Physical Disk File Iteration**:
  - Line 735 & 835 iterate over `ContentLoaderService.knownAssetPaths` using `File(assetPath)`. If a file is moved to a subfolder without updating `knownAssetPaths`, `file.existsSync()` fails.
- **Flutter Asset Registration Requirement**:
  - In `pubspec.yaml` (lines 72-78):
    ```yaml
    assets:
      - .env
      - assets/content/arithmetic/
      - assets/content/algebra/
      - assets/content/geometry_trig/
      - assets/content/calculus/
      - assets/content/physics/
    ```
    Flutter does **not** recursively bundle subdirectories. Adding a subfolder `assets/content/calculus/limits/` requires adding `- assets/content/calculus/limits/` to `pubspec.yaml`.

---

### 1.5 Inspection of Animation Autoplay Expectations across Tests
Requirement R1 specifies that simulation widgets must **never** autoplay on initial render (must initialize paused/static). The current test suite explicitly asserts the opposite (that widgets start playing):
1. `test/all_animations_test.dart`:
   - Line 14: `testWidgets('Starts auto-rotating immediately and progresses angle'...)` -> expects `find.byTooltip('Ferma rotazione')`.
   - Line 110: Kinematics test expects moving car and `find.byTooltip('Pausa')`.
   - Line 186: Circuit test expects active charge flow and `find.byTooltip('Pausa flusso')`.
   - Line 221: Derivative tangent test expects oscillating h and `find.byTooltip('Pausa animazione limite')`.
   - Line 263: Riemann sum test expects auto-partitioning and `find.byTooltip('Pausa convergenza')`.
   - Line 300: Triangle solver test expects auto-transforming and `find.byTooltip('Pausa deformazione')`.
   - Line 352: Cartesian graph test expects auto-morphing and `find.byTooltip('Pausa deformazione')`.
2. `test/math_rendering_and_explorer_test.dart`:
   - Line 228: `RolleLagrangeWidget` test asserts:
     ```dart
     final pauseBtn = find.byTooltip('Pausa simulazione');
     expect(pauseBtn, findsOneWidget);
     ```
3. `test/step12_reorganization_and_simulations_test.dart`:
   - Line 156: `TrigCircleWidget` test asserts:
     ```dart
     final stopBtn = find.byTooltip('Ferma rotazione');
     expect(stopBtn, findsOneWidget);
     ```

---

## 2. Logic Chain

### 2.1 Backward Compatibility of `mat_limits_01`
1. Observation 1.3 shows that `test/curriculum_dag_test.dart` (line 58) asserts `expect(ids.contains('mat_limits_01'), true)`.
2. Observation 1.2 shows that `mat_deriv_def_01` and `mat_riemann_01` directly list `mat_limits_01` in their prerequisites.
3. Observation 1.2 and `test/step12_reorganization_and_simulations_test.dart` (line 81) show that monotonic difficulty calculation tests `computeDepth('mat_deriv_def_01', prereqs)`.
4. Therefore, preserving `mat_limits_01` as the primary topic ID for "Definizione di Limite di Funzione e Teorema del Confronto" preserves full backward compatibility, avoiding breaking changes across dependent topics and key node assertions.

### 2.2 Mathematical & Architectural Structure for Limits Modularization
Requirement R3 requests:
- Sub-folder `assets/content/calculus/limits/`
- Limit definition (intuitive, $\epsilon$-$\delta$, geometric meaning)
- Individual fundamental/remarkable limits:
  1. $\lim_{x \to 0} \frac{\sin x}{x} = 1$
  2. $\lim_{x \to 0} \frac{1 - \cos x}{x^2} = \frac{1}{2}$
  3. $\lim_{x \to \pm\infty} (1 + \frac{1}{x})^x = e$
  4. $\lim_{x \to 0} \frac{e^x - 1}{x} = 1$
  5. $\lim_{x \to 0} \frac{\ln(1+x)}{x} = 1$

Requirement R4 requests an unbroken DAG:
- Foundational concepts (Euclidean geometry/unit circle, algebra) $\to$ limit definition and squeeze theorem $\to$ remarkable limits $\to$ derivatives and advanced calculus.

The logical dependency chain is derived as follows:
1. **Limit Definition & Squeeze Theorem** (`mat_limits_01`):
   - Mathematically requires fractions and functions (`mat_frac_01`, `mat_parabola_01`).
   - Introduces neighborhood topology $(\epsilon, \delta)$ and the universal Squeeze Theorem ($g(x) \le f(x) \le h(x)$).
2. **Sine Remarkable Limit** (`mat_limits_sin_01`):
   - Mathematically requires the unit circle geometry (`mat_trig_circ_01`) for the geometric area inequality $\sin x < x < \tan x \implies \cos x < \frac{\sin x}{x} < 1$, and the Squeeze Theorem from `mat_limits_01`.
   - Prerequisites: `['mat_limits_01', 'mat_trig_circ_01']`.
3. **Cosine Remarkable Limit** (`mat_limits_cos_01`):
   - Mathematically derived algebraically by multiplying $\frac{1 - \cos x}{x^2}$ by $\frac{1 + \cos x}{1 + \cos x} = \frac{\sin^2 x}{x^2(1 + \cos x)}$ and applying the sine limit.
   - Prerequisites: `['mat_limits_sin_01']`.
4. **Euler's Number Limit** (`mat_limits_e_01`):
   - Mathematically requires Newton's binomial expansion from algebra (`mat_binom_01`) to prove $(1 + 1/n)^n \le \sum \frac{1}{k!}$ and monotone bounded convergence, combined with limit definition (`mat_limits_01`).
   - Prerequisites: `['mat_limits_01', 'mat_binom_01']`.
5. **Exponential Remarkable Limit** (`mat_limits_exp_01`):
   - Mathematically derived by variable substitution $y = e^x - 1 \iff x = \ln(1+y)$, transforming into $\lim \frac{y}{\ln(1+y)} = \frac{1}{\ln e} = 1$.
   - Prerequisites: `['mat_limits_e_01']`.
6. **Logarithmic Remarkable Limit** (`mat_limits_log_01`):
   - Mathematically uses logarithm power property $\frac{1}{x}\ln(1+x) = \ln((1+x)^{1/x})$, logarithm continuity (`mat_log_01`), and Euler limit (`mat_limits_e_01`).
   - Prerequisites: `['mat_limits_e_01', 'mat_log_01']`.

### 2.3 Proof of DAG Acyclicity & Topological Order
Let $G = (V, E)$ where edges represent $(prerequisite, dependent)$.
1. All prerequisites of `mat_limits_01` are in $\{ \text{mat\_frac\_01}, \text{mat\_parabola\_01} \}$. Neither depends on limits.
2. `mat_limits_sin_01` depends on `mat_limits_01` and `mat_trig_circ_01`. Neither depends on `mat_limits_sin_01`.
3. `mat_limits_cos_01` depends on `mat_limits_sin_01`.
4. `mat_limits_e_01` depends on `mat_limits_01` and `mat_binom_01`. Neither depends on `mat_limits_e_01`.
5. `mat_limits_exp_01` and `mat_limits_log_01` depend on `mat_limits_e_01` (and `mat_log_01`).
6. Downstream topics `mat_deriv_def_01` depends on `mat_limits_01`.
7. `mat_deriv_rules_01` depends on `mat_deriv_def_01` and `mat_binom_01` (and can optionally link `mat_limits_sin_01` and `mat_limits_exp_01`).
8. `mat_riemann_01` depends on `mat_deriv_theorems_01` and `mat_limits_01`.
9. `mat_fund_calc_01` depends on `mat_riemann_01` and `mat_deriv_def_01`.
10. At every stage, edges strictly flow forward in topological order. No backwards edge exists. Hence $G$ is strictly acyclic.

### 2.4 Monotonic Depth Verification (`computeDepth`)
In `test/step12_reorganization_and_simulations_test.dart`:
- `dAdd` = 0
- `dMul` = 1
- `dPow` = 2
- `dBinom` = 3
- `dDeriv` (`mat_deriv_def_01`):
  - `mat_limits_01` depth = max(depth(`mat_parabola_01`)=5, depth(`mat_frac_01`)=2) + 1 = 6.
  - `mat_deriv_def_01` depth = 6 + 1 = 7.
- `dFund` (`mat_fund_calc_01`):
  - `mat_deriv_theorems_01` depth = 9.
  - `mat_riemann_01` depth = 10.
  - `mat_fund_calc_01` depth = 11.
- `0 < 1 < 2 < 3 < 7 < 11` strictly holds ($dAdd < dMul < dPow < dBinom < dDeriv < dFund$).

---

## 3. Caveats
1. **Scope Boundary**: This investigation is strictly read-only. No files outside `.agents/explorer_survey_tests/` were modified.
2. **Hardcoded Test Assertions**: If downstream agents create the new markdown files without simultaneously updating `test/markdown_content_loader_test.dart` (which contains 10 assertions expecting `24`), `flutter test test/markdown_content_loader_test.dart` will fail on the node count checks.
3. **Autoplay Tests**: When downstream agents modify simulation widgets so they initialize paused by default (R1), existing animation tests in `test/all_animations_test.dart`, `test/step12_reorganization_and_simulations_test.dart`, and `test/math_rendering_and_explorer_test.dart` will fail unless their initial tooltip expectations are updated from 'Pausa'/'Ferma' to the corresponding play action.

---

## 4. Conclusion & Actionable Implementation Plan

### 4.1 Summary of Findings
- The codebase currently passes `flutter analyze` with 0 issues and passes all 146 tests in `flutter test`.
- The curriculum has 24 topics. Modularizing Limits into 1 Definition + 5 Remarkable Limits expands the curriculum to **29 topics** (or 24 - 1 + 6 = 29).
- The prerequisite graph can be modularized cleanly and remain strictly acyclic, with monotonic depth progression and valid existing IDs.

### 4.2 Exact Implementation Specifications for Downstream Agents

#### A. Files to Create in `assets/content/calculus/limits/`:
1. `mat_limits_01.md`:
   - `id`: `mat_limits_01`
   - `title`: `"Definizione di Limite e Teorema del Confronto"`
   - `category`: `"Matematica"`
   - `subCategory`: `"Limiti e Continuità"`
   - `prerequisites`: `['mat_frac_01', 'mat_parabola_01']`
   - `interactive`: template `function_graph` (or `rolle_lagrange`)
2. `mat_limits_sin_01.md`:
   - `id`: `mat_limits_sin_01`
   - `title`: `"Limite Notevole del Seno: \\lim_{x \\to 0} \\frac{\\sin x}{x} = 1"`
   - `category`: `"Matematica"`
   - `subCategory`: `"Limiti e Continuità"`
   - `prerequisites`: `['mat_limits_01', 'mat_trig_circ_01']`
   - `interactive`: template `function_graph`, equations `["sin(k * x) / x"]`
3. `mat_limits_cos_01.md`:
   - `id`: `mat_limits_cos_01`
   - `title`: `"Limite Notevole del Coseno: \\lim_{x \\to 0} \\frac{1 - \\cos x}{x^2} = \\frac{1}{2}"`
   - `category`: `"Matematica"`
   - `subCategory`: `"Limiti e Continuità"`
   - `prerequisites`: `['mat_limits_sin_01']`
   - `interactive`: template `function_graph`, equations `["(1 - cos(k * x)) / (x * x)"]`
4. `mat_limits_e_01.md`:
   - `id`: `mat_limits_e_01`
   - `title`: `"Numero di Nepero e Limite Notevole: \\lim_{x \\to \\pm\\infty} (1 + \\frac{1}{x})^x = e"`
   - `category`: `"Matematica"`
   - `subCategory`: `"Limiti e Continuità"`
   - `prerequisites`: `['mat_limits_01', 'mat_binom_01']`
   - `interactive`: template `function_graph` (or `live_equation`), equations `["pow(1 + 1 / x, x)"]`
5. `mat_limits_exp_01.md`:
   - `id`: `mat_limits_exp_01`
   - `title`: `"Limite Notevole Esponenziale: \\lim_{x \\to 0} \\frac{e^x - 1}{x} = 1"`
   - `category`: `"Matematica"`
   - `subCategory`: `"Limiti e Continuità"`
   - `prerequisites`: `['mat_limits_e_01']`
   - `interactive`: template `function_graph`, equations `["(exp(k * x) - 1) / x"]`
6. `mat_limits_log_01.md`:
   - `id`: `mat_limits_log_01`
   - `title`: `"Limite Notevole Logaritmico: \\lim_{x \\to 0} \\frac{\\ln(1+x)}{x} = 1"`
   - `category`: `"Matematica"`
   - `subCategory`: `"Limiti e Continuità"`
   - `prerequisites`: `['mat_limits_e_01', 'mat_log_01']`
   - `interactive`: template `function_graph`, equations `["log(1 + k * x) / x"]`

*Old file deletion*: Remove `assets/content/calculus/mat_limits_01.md` after migrating to `assets/content/calculus/limits/mat_limits_01.md`.

#### B. Code Updates Required in `lib/`:
1. `pubspec.yaml`:
   - Add `- assets/content/calculus/limits/` under `flutter: assets:`.
2. `lib/data/content/content_loader_service.dart`:
   - In `knownAssetPaths`, replace `'assets/content/calculus/mat_limits_01.md'` with:
     ```dart
     'assets/content/calculus/limits/mat_limits_01.md',
     'assets/content/calculus/limits/mat_limits_sin_01.md',
     'assets/content/calculus/limits/mat_limits_cos_01.md',
     'assets/content/calculus/limits/mat_limits_e_01.md',
     'assets/content/calculus/limits/mat_limits_exp_01.md',
     'assets/content/calculus/limits/mat_limits_log_01.md',
     ```
3. `lib/data/catalog/calculus_catalog.dart`:
   - Add fallback node definitions for the 5 new limits in `CalculusCatalog.getAllNodes()`.
4. `lib/data/catalog/curriculum_registry.dart`:
   - Update `_defaultPrerequisiteMap` with:
     ```dart
     'mat_limits_01': ['mat_frac_01', 'mat_parabola_01'],
     'mat_limits_sin_01': ['mat_limits_01', 'mat_trig_circ_01'],
     'mat_limits_cos_01': ['mat_limits_sin_01'],
     'mat_limits_e_01': ['mat_limits_01', 'mat_binom_01'],
     'mat_limits_exp_01': ['mat_limits_e_01'],
     'mat_limits_log_01': ['mat_limits_e_01', 'mat_log_01'],
     ```

#### C. Test Updates Required in `test/`:
1. `test/markdown_content_loader_test.dart`:
   - Update group name and test names mentioning 24 to 29 (or dynamic count).
   - Update all 10 occurrences of `expect(..., 24)` to `29` (or `ContentLoaderService.knownAssetPaths.length`).
2. `test/curriculum_dag_test.dart`:
   - Optionally add assertions verifying the 5 new limit IDs exist in `CurriculumRegistry.getAllNodes()`.
3. Animation Autoplay Tests (`test/all_animations_test.dart`, `test/math_rendering_and_explorer_test.dart`, `test/step12_reorganization_and_simulations_test.dart`):
   - When R1 (paused by default) is implemented, update test steps: verify that widgets render in paused state, tap play/step, and assert active animation.

---

## 5. Verification Method

To independently verify the baseline and future changes:

1. **Verify Static Analysis**:
   ```powershell
   flutter analyze
   ```
   *Expected outcome*: 0 errors, 0 warnings.

2. **Verify DAG Test**:
   ```powershell
   flutter test test/curriculum_dag_test.dart
   ```
   *Expected outcome*: All tests pass (validates uniqueness, corollaries, valid prerequisite IDs, and topological DAG acyclicity via Kahn's algorithm).

3. **Verify Markdown Content Loader**:
   ```powershell
   flutter test test/markdown_content_loader_test.dart
   ```
   *Expected outcome*: All tests pass (validates physical asset files on disk, YAML frontmatter, LaTeX math blocks, corollary steps, and DAG topological sort over parsed files).

4. **Verify Monotonic Depth & Topological Ordering**:
   ```powershell
   flutter test test/step12_reorganization_and_simulations_test.dart
   ```
   *Expected outcome*: Passes `Difficulty increases monotonically along mathematical learning pathways` and category unification.

5. **Verify Full Test Suite**:
   ```powershell
   flutter test
   ```
   *Expected outcome*: All 146+ tests pass with zero regressions.
