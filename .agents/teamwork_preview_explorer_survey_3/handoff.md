# Survey Report: Interactive Simulation Widgets, Declarative Linking (R5) & Project Map (R2)

**Explorer Identity:** `teamwork_preview_explorer_survey_3`  
**Working Directory:** `c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_explorer_survey_3`  
**Workspace Root:** `c:\Users\catte\Desktop\Laurentius`  
**Date:** 2026-09-07  

---

## 1. Observation

### 1.1 Codebase Verification & Environment
- Command `flutter test` executed across the entire repository: **62 tests passed** (exit code 0).
- Command `flutter analyze` executed across the entire repository: **0 errors, 0 warnings** ("No issues found!", ran in 3.9s).
- Flutter SDK: `^3.13.2` as defined in `pubspec.yaml` line 22.

### 1.2 Interactive Simulation Widgets Directory
Located in `lib/presentation/widgets/interactive/`. There are exactly **9 simulation widgets** and **1 factory**:
1. `ohm_circuit_simulation_widget.dart` (852 lines): Interactive DC circuit simulation.
2. `kinematics_simulation_widget.dart` (688 lines): 1D kinematic motion with car on metric road track.
3. `cartesian_graph_widget.dart` (540 lines): Dynamic 2D Cartesian graph with customizable function deformer.
4. `live_equation_widget.dart` (360 lines): General-purpose live math equation evaluator using `math_expressions`.
5. `rolle_lagrange_widget.dart` (724 lines): Calculus differential theorems (Lagrange Mean Value & Rolle).
6. `triangle_solver_widget.dart` (533 lines): Triangle geometry showing Carnot (Law of Cosines) collapsing into Pythagoras.
7. `trig_circle_widget.dart` (719 lines): Interactive unit circle with $\sin$, $\cos$, $\tan$, touch-drag and notable angles.
8. `derivative_tangent_widget.dart` (479 lines): Differential calculus demonstrating secant collapsing to tangent as $h \to 0$.
9. `riemann_sum_widget.dart` (445 lines): Integral calculus demonstrating convergence of Riemann sum rectangles ($N \to \infty$) to definite integral via Barrow's formula.
10. `interactive_template_factory.dart` (66 lines): Static factory instantiating the widgets based on `InteractiveData`.

### 1.3 `InteractiveTemplateFactory` Implementation
Located in `lib/presentation/widgets/interactive/interactive_template_factory.dart`:
```dart
23:     switch (data.templateType) {
24:       case 'circuit_simulation':
25:       case 'ohm_simulation':
26:         return OhmCircuitSimulationWidget(data: data);
27:       case 'kinematics_simulation':
28:       case 'rectilinear_motion':
29:         return KinematicsSimulationWidget(data: data);
30:       case 'rolle_lagrange':
31:       case 'rolle':
32:       case 'lagrange':
33:         return RolleLagrangeWidget(data: data);
34:       case 'function_graph':
35:       case 'cartesian_plot':
36:         // Se la formula è la cubica dei teoremi di Rolle/Lagrange, usa il simulatore specifico
37:         if (data.equations != null &&
38:             data.equations!.any((eq) => eq.contains('x * x * x / 3') || eq.contains('rolle'))) {
39:           return RolleLagrangeWidget(data: data);
40:         }
41:         return CartesianGraphWidget(data: data);
42:       case 'trig_circle':
43:       case 'trigonometric_circle':
44:         return TrigCircleWidget(data: data);
45:       case 'triangle_solver':
46:       case 'pythagoras_carnot':
47:         return TriangleSolverWidget(data: data);
48:       case 'derivative_tangent':
49:       case 'difference_quotient':
50:         return DerivativeTangentWidget(data: data);
51:       case 'riemann_sum':
52:       case 'riemann_integral':
53:         return RiemannSumWidget(data: data);
54:       case 'live_equation':
55:         return LiveEquationWidget(data: data);
56:       default:
57:         // Se non specificato ma ha equazioni e parametri, fallback su live_equation
58:         if ((data.equations != null && data.equations!.isNotEmpty) ||
59:             (data.parameters != null && data.parameters!.isNotEmpty)) {
60:           return LiveEquationWidget(data: data);
61:         }
62:         return null;
63:     }
```

### 1.4 Hardcoded Unit in `LiveEquationWidget` (Requirement R4)
Located in `lib/presentation/widgets/interactive/live_equation_widget.dart` lines 256-263:
```dart
256:               const SizedBox(width: 8),
257:               const Text(
258:                 'V',
259:                 style: TextStyle(
260:                   fontSize: 20,
261:                   fontWeight: FontWeight.w700,
262:                   color: Color(0xFF2563EB),
263:                 ),
264:               ),
```
In `LiveEquationWidget`, the result unit `'V'` (Volt) is hardcoded into the text widget regardless of whether the equation evaluates a force ($N$), power ($W$), acceleration ($m/s^2$), or a unitless mathematical expression.
Furthermore, parameter slider value chips (line 321-329) currently only display the numeric value:
```dart
321:               child: Text(
322:                 formattedValue,
323:                 style: const TextStyle(
324:                   fontSize: 13,
325:                   fontWeight: FontWeight.w700,
326:                   color: Color(0xFF0F172A),
327:                 ),
328:               ),
```

### 1.5 Domain Models: `InteractiveData` & `InteractiveParameter`
Located in `lib/domain/models/knowledge_node.dart` lines 139-179:
```dart
140: class InteractiveData {
141:   String? templateType;
142:   List<String>? equations;
143:   List<InteractiveParameter>? parameters;
...
160: class InteractiveParameter {
161:   String? variableName;
162:   String? label;
163:   double? minValue;
164:   double? maxValue;
165:   double? defaultValue;
166:   double? stepSize;
```
Neither `InteractiveData` nor `InteractiveParameter` currently has a `unit` field.

### 1.6 UI Instantiation Site
Located in `lib/presentation/pages/node_detail_screen.dart` lines 56-58 and 310-314:
```dart
56:     final interactiveWidget = InteractiveTemplateFactory.buildWidget(
57:       node.interactiveData,
58:     );
...
310:     if (interactiveWidget != null) ...[
311:       const SizedBox(height: 12),
312:       interactiveWidget,
313:       const SizedBox(height: 28),
314:     ],
```

---

## 2. Logic Chain

### 2.1 Complete Inventory of Simulation Widgets & Parameter Contract
From inspecting each widget's `initState()`, `build()`, and parameter reading logic:

| Widget Class | Factory Keys (Canonical & Aliases) | Expected Parameters (`variableName`) | Equations Usage | Behavior & Interactive Features |
|---|---|---|---|---|
| `OhmCircuitSimulationWidget` | `'circuit_simulation'`, `'ohm_simulation'` | `V` (voltage, default 12.0), `R` (resistance, default 6.0) | None for computation; calculates $I = V/R$ and $P = V \cdot I$ in Dart | Animated closed circuit with drifting electrons (cyan particles), real electron vs conventional current toggle, resistor heat thermal glow shader, telemetry ($I, P$), sliders for $V, R$. |
| `KinematicsSimulationWidget` | `'kinematics_simulation'`, `'rectilinear_motion'` | `v0` (initial velocity, default 5.0), `a` (acceleration, default 2.0) | Optional description equation (e.g. `v0 + a * t`) | Metric road canvas (0-100m) with finish line, animated car with rotating wheels and velocity vector $\vec{v}$, play/pause/reset, real-time telemetry ($x(t), v(t), t$), Torricelli formula card ($v^2 = v_0^2 + 2a\Delta x$). |
| `CartesianGraphWidget` | `'function_graph'`, `'cartesian_plot'` | Dynamic coefficients, e.g. `a`, `b`, `c` | `equations.first`: parsed via `math_expressions` GrammarParser (e.g. `a * x * x + b * x + c`) | 2D cartesian grid with orthogonal axes, continuous function curve rendering at 60fps, dynamic vertex calculation & label ($V$), auto-morphing toggle, sliders for each coefficient. |
| `LiveEquationWidget` | `'live_equation'` (and default fallback) | Any user-defined variables matching equation identifiers | `equations.first`: parsed via `math_expressions` GrammarParser | Generic mathematical formula evaluator with real-time slider binding, LIVE evaluation display box, error diagnostics. |
| `RolleLagrangeWidget` | `'rolle_lagrange'`, `'rolle'`, `'lagrange'` (and auto-routed from `function_graph` if equation contains `x * x * x / 3` or `rolle`) | `a` (left boundary), `b` (right boundary) | Hardcoded cubic polynomial $f(x) = x^3/3 - x$ and $f'(x) = x^2 - 1$ | Visual demonstration of Lagrange & Rolle theorems, secant line between $(a, f(a))$ and $(b, f(b))$, parallel tangent at interior point $c \in (a, b)$, mode switch, telemetry, auto-oscillation. |
| `TriangleSolverWidget` | `'triangle_solver'`, `'pythagoras_carnot'` | `sideA`, `sideB`, `angleGammaDeg` (in internal state; defaults: 3.0, 4.0, 90.0°) | Law of Cosines $c^2 = a^2 + b^2 - 2ab\cos\gamma$ and Pythagoras collapse when $\gamma = 90^\circ$ | Interactive triangle rendering with colored sides, angle arc, right-triangle detector, telemetry for sides and area, formula check card, sliders, 90° quick preset. |
| `TrigCircleWidget` | `'trig_circle'`, `'trigonometric_circle'` | Angle $\theta$ (default $\pi/4$) | $\sin\theta, \cos\theta, \tan\theta$, fundamental identity $\sin^2\theta + \cos^2\theta = 1$ | Unit circle with radius vector, orthogonal projections of $\sin$ (green) and $\cos$ (blue), vertical tangent line $x=1$ with asymptotes at $\pi/2$ and $3\pi/2$, touch/drag directly on canvas, auto-rotation at 60fps, notable angle chips. |
| `DerivativeTangentWidget` | `'derivative_tangent'`, `'difference_quotient'` | `x0` (base point), `h` (increment) | Parabola $f(x) = \frac{1}{2}x^2$, derivative $f'(x) = x$, difference quotient $\frac{f(x_0+h) - f(x_0)}{h}$ | Secant line through $P$ and $Q$ collapsing to tangent line as $h \to 0$, telemetry of quotient vs exact derivative, error readout, auto-animation of limit, sliders for $h$ and $x_0$. |
| `RiemannSumWidget` | `'riemann_sum'`, `'riemann_integral'` | `nRectangles` ($N$, default 6), interval $[a, b] = [0, 2]$ | Test function $f(x) = 0.75x^2 + 0.5$, antiderivative $F(x) = 0.25x^3 + 0.5x$, Barrow's formula | Rectangular partitions under curve, exact integral computation, convergence telemetry error $|\Sigma - \int|$, auto-partition animation $N = 2 \to 40$, slider for $N$. |

### 2.2 Mechanism of `InteractiveTemplateFactory`
1. **Input:** Receives `InteractiveData? data`. If `data == null`, immediately returns `null`.
2. **Switch Matching:** Evaluates `data.templateType` using string matching against canonical keys and aliases.
3. **Smart Specialization:** For `'function_graph'` / `'cartesian_plot'`, inspects `data.equations` to see if it contains `'x * x * x / 3'` or `'rolle'`. If so, automatically delegates to `RolleLagrangeWidget`; otherwise returns `CartesianGraphWidget`.
4. **Fallback:** If `templateType` is unknown or omitted, but `equations` or `parameters` are present, falls back to `LiveEquationWidget(data: data)`. If none exist, returns `null`.

### 2.3 Requirements for R5 (Declarative Widget Linking via Markdown Frontmatter)
The goal of R5 is to allow any Markdown article to link to any simulation widget using declarative YAML frontmatter without modifying Dart widget code.

#### Proposed Frontmatter Specification
```yaml
---
id: phys_kin_01
title: "Cinematica: Moto Rettilineo e Corollario di Torricelli"
category: "Fisica"
subCategory: "Cinematica e Dinamica"
prerequisites:
  - mat_parabola_01
interactive:
  template: kinematics_simulation   # or circuit_simulation, function_graph, etc.
  unit: "m/s"                       # optional result readout unit (for R4)
  equations:
    - "v0 + a * t"
  parameters:
    - name: v0
      label: "Velocità Iniziale (v₀)"
      min: 0.0
      max: 30.0
      default: 5.0
      step: 1.0
      unit: "m/s"
    - name: a
      label: "Accelerazione (a)"
      min: -5.0
      max: 10.0
      default: 2.0
      step: 0.5
      unit: "m/s²"
---
# Educational narrative in Markdown and LaTeX blocks follow...
```

#### Parsing & Mapping Pipeline to `InteractiveTemplateFactory`
1. **Offline Ingestion:** An offline Markdown loader (e.g. `MarkdownContentLoader`) parses the frontmatter map:
   - `yaml['interactive']['template']` $\to$ `InteractiveData.templateType`
   - `yaml['interactive']['unit']` $\to$ `InteractiveData.unit`
   - `yaml['interactive']['equations']` $\to$ `InteractiveData.equations`
   - `yaml['interactive']['parameters']` $\to$ `List<InteractiveParameter>`
     - `p['name']` / `p['variableName']` $\to$ `InteractiveParameter.variableName`
     - `p['label']` $\to$ `InteractiveParameter.label`
     - `p['min']` / `p['minValue']` $\to$ `InteractiveParameter.minValue`
     - `p['max']` / `p['maxValue']` $\to$ `InteractiveParameter.maxValue`
     - `p['default']` / `p['defaultValue']` $\to$ `InteractiveParameter.defaultValue`
     - `p['step']` / `p['stepSize']` $\to$ `InteractiveParameter.stepSize`
     - `p['unit']` $\to$ `InteractiveParameter.unit`
2. **Database Persistence:** The constructed `InteractiveData` is stored in the `KnowledgeNode.interactiveData` field in Isar.
3. **UI Rendering:** In `NodeDetailScreen.build()`, `InteractiveTemplateFactory.buildWidget(node.interactiveData)` is called:
   - It matches `templateType` (`'kinematics_simulation'`).
   - It instantiates `KinematicsSimulationWidget(data: data)`.
   - The widget reads parameter values from `data.parameters` and updates its reactive state.
   - **Zero widget source code modifications required to add new topics or reconfigure existing ones.**

### 2.4 Necessary Model & Widget Changes for R4 & R5
1. **Domain Model (`lib/domain/models/knowledge_node.dart`):**
   - Add `@embedded class InteractiveData` field: `String? unit;` (with `fromJson` serialization).
   - Add `@embedded class InteractiveParameter` field: `String? unit;` (with `fromJson` serialization).
2. **`LiveEquationWidget`:**
   - Remove hardcoded `'V'`.
   - Read `widget.data.unit`. If non-null and not empty, render `Text(unit, style: ...)`. If empty or null, render nothing.
   - In parameter slider values, render `'$formattedValue ${param.unit ?? ""}'.trim()`.
3. **Existing Simulation Widgets (`ohm_circuit_simulation_widget.dart`, `kinematics_simulation_widget.dart`, etc.):**
   - Allow parameter sliders to use `p.unit ?? defaultUnit` so authors can customize or localize unit labels.

### 2.5 Requirements for R2 (`PROJECT_MAP.md` strictly < 300 lines)
`PROJECT_MAP.md` must be a high-density, agent-optimized architectural guide located at the repository root. To guarantee it remains **strictly under 300 lines**, we allocate a strict line budget across 6 sections:

| Section | Content | Estimated Line Budget |
|---|---|---|
| **1. Overview & Architecture** | Offline-first STEM knowledge graph, Brilliant-style UI/UX, tech stack (Isar, flutter_math_fork, math_expressions, graphview). | ~25 lines |
| **2. Directory Structure (`lib/`)** | Complete annotated tree of every primary directory and file under `lib/`. | ~60 lines |
| **3. Catalog & Content Pathways** | In-memory catalogs vs decoupled Markdown files (`assets/content/`), sync mechanisms. | ~35 lines |
| **4. Simulation Widget Catalog** | Table of 9 widgets, template keys, required parameters, equations, unit support. | ~50 lines |
| **5. State & Data Flow** | Boot sequence $\to$ Markdown/Catalog loading $\to$ Isar $\to$ UI/Navigation $\to$ Factory $\to$ CustomPainter 60fps. | ~35 lines |
| **6. Step-by-Step Guide: Adding Topics** | Step 1: Create `.md` in `assets/content/` with frontmatter; Step 2: Link widget declarative key; Step 3: Run `flutter test`. | ~35 lines |
| **Total Estimated Lines** | | **~240 lines** (well below the 300-line ceiling) |

---

## 3. Caveats

1. **YAML Parser Dependency:** Dart's SDK does not include a YAML parser in `dart:convert`. A lightweight YAML reader or the standard `yaml: ^3.1.2` package will be needed for parsing Markdown frontmatter. If package additions are restricted, a lightweight line-by-line frontmatter parser can easily extract key-value pairs without new dependencies.
2. **Offline Asset Ingestion Timing:** `rootBundle.loadString()` requires the Flutter binding and asset registration in `pubspec.yaml`. Content files must be declared in `pubspec.yaml` under `assets:` (e.g. `- assets/content/`).
3. **Hardcoded Initial Parameters in Some Widgets:** Some simulation widgets (e.g. `TriangleSolverWidget`, `RolleLagrangeWidget`, `TrigCircleWidget`) currently initialize state variables with internal constants (`_sideA = 3.0`, `_a = -1.8`, `_angleRad = pi/4`) rather than reading from `widget.data?.parameters`. To achieve 100% parameter customizability via frontmatter for all 9 widgets, minor optional parameter bindings can be wired into those widgets.

---

## 4. Conclusion

1. **Inventory:** Exactly 9 interactive simulation widgets exist under `lib/presentation/widgets/interactive/`. They cover Physics (Ohm circuit, Kinematics), Geometry/Trigonometry (Triangle solver, Trig circle), Calculus (Cartesian plot, Rolle/Lagrange, Derivative tangent, Riemann sum), and general STEM (Live equation).
2. **Template Keys:** `InteractiveTemplateFactory` currently recognizes 17 template key aliases mapping to these 9 widgets, plus a live-equation fallback.
3. **Unit Decoupling (R4):** The hardcoded `'V'` in `LiveEquationWidget` (line 257) must be replaced by a configurable `unit` field in `InteractiveData` and `InteractiveParameter`.
4. **Declarative Widget Linking (R5):** Achieved cleanly by standardizing YAML frontmatter keys (`template`, `equations`, `parameters`) that deserialize into `InteractiveData` and pass directly to `InteractiveTemplateFactory.buildWidget()` without touching widget code.
5. **Project Map (R2):** A structured, 6-section blueprint for `PROJECT_MAP.md` at root has been designed to fit comfortably within **~240 lines**, guaranteeing compliance with the `< 300 lines` strict limit.

---

## 5. Verification Method

### 5.1 Independent Test Execution
Run the full test suite and static analysis:
```bash
flutter test
flutter analyze
```
Both commands must pass with zero failures and zero issues.

### 5.2 Verification of Simulation Widget Mounting
Run the animation and simulation widget test suites:
```bash
flutter test test/interactive_simulation_test.dart
flutter test test/all_animations_test.dart
flutter test test/step12_reorganization_and_simulations_test.dart
```

### 5.3 Files to Inspect
- Factory & routing: `lib/presentation/widgets/interactive/interactive_template_factory.dart`
- Hardcoded unit location: `lib/presentation/widgets/interactive/live_equation_widget.dart` (lines 256-263)
- Models to update: `lib/domain/models/knowledge_node.dart` (lines 140-179)
- Detail screen builder: `lib/presentation/pages/node_detail_screen.dart` (lines 56-59, 310-314)

### 5.4 Invalidation Conditions
- Any change to `InteractiveTemplateFactory` that breaks existing key aliases (`circuit_simulation`, `ohm_simulation`, `kinematics_simulation`, `function_graph`, `trig_circle`, `triangle_solver`, `derivative_tangent`, `riemann_sum`, `rolle_lagrange`).
- Any failure in `test/interactive_simulation_test.dart` or `test/all_animations_test.dart`.
- `PROJECT_MAP.md` exceeding 299 lines.
