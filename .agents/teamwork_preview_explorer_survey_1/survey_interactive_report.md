# Technical Survey & Audit Report: Interactive Simulations & R3 2D Vector Widget

**Agent**: `teamwork_preview_explorer_survey_1`  
**Working Directory**: `c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_explorer_survey_1`  
**Target Repository**: `c:\Users\catte\Desktop\Laurentius`  
**Date**: 2026-09-14  
**Scope**: Requirements R1 (Audit, Semplificazione e Fix delle Simulazioni Interattive) and R3 (Visualizzazione Interattiva per l'Algebra Lineare)

---

## 1. Executive Summary

A comprehensive investigation and static/dynamic audit was conducted on all interactive simulations in Laurentius (`lib/presentation/widgets/interactive/`), their routing mechanism in `interactive_template_factory.dart`, and their content bindings across all 35 Markdown curriculum articles in `assets/content/`.

### Key Takeaways
1. **Catalog Inventory**: Exactly **11 simulation widgets** exist in `lib/presentation/widgets/interactive/`, routed through **20 template aliases** in `InteractiveTemplateFactory`. Every single one of the 35 curriculum articles under `assets/content/` binds to an interactive simulation template.
2. **Autoplay Compliance**: All 11 widgets currently initialize in a paused/static state (`_isPlaying = false`, `_isAutoAnimating = false`, etc.), respecting the strict anti-autoplay requirement from the 2026-09-07 overhaul.
3. **Critical Performance Bottleneck in `CartesianGraphWidget`**: `_CartesianPainter.paint()` invokes `_evaluateY(x)` approximately 200–300 times per frame. Inside `_evaluateY(x)`, `_parser.parse(_equationString)` is called on **every single pixel sample**, repeatedly parsing the AST from scratch at 60fps. This constitutes a severe CPU hotspot.
4. **Pedagogical Flaw in `CartesianGraphWidget`**: `CartesianGraphWidget` hardcodes a quadratic formula string (`y = ax² + bx + c`) on line 150 and calculates a parabola vertex $V(-b/(2a), ...)$ on line 473. When referenced by non-quadratic topics (e.g., remarkable limits like `mat_lim_e_01.md` $(1 + 1/x)^x$, `mat_lim_log_01.md` $\frac{\ln(1+x)}{x}$, or integrals like `mat_integ_parts_01.md` $x e^x$), the widget erroneously displays `y = 1.0x² + 0.0x - 2.0` and renders an irrelevant parabola vertex.
5. **Purely Numerical Widget (`LiveEquationWidget`)**: Used across 10 curriculum nodes (arithmetic operations, powers, fractions, binomial square, Viète, logarithms, pH, electrical power, Joule's law), `LiveEquationWidget` is 100% numerical with zero geometric or physical visual model. Topics such as `ele_power_01.md` and `ele_joule_01.md` would gain immense pedagogical value if upgraded to the existing circuit simulation canvas.
6. **Touch Interaction Gap**: Only `TrigCircleWidget` implements direct canvas drag gestures (`GestureDetector` tracking angular position). The other 10 widgets rely exclusively on below-canvas sliders.
7. **R3 2D Vector Simulation Architecture**: Designed a unified `Vector2DSimulationWidget` supporting 3 dedicated pedagogical views:
   - *View 1: Single Vector & Coordinate Projections* (components $v_x, v_y$, basis $\mathbf{e}_1, \mathbf{e}_2$, magnitude, polar angle $\theta$).
   - *View 2: Vector Addition* (parallelogram rule and tip-to-tail / punta-coda mode, triangle inequality verification).
   - *View 3: Linear Combinations & Span* ($c_1 \mathbf{v}_1 + c_2 \mathbf{v}_2$, sliders for $c_1, c_2 \in [-3, 3]$, 2D determinant calculation $\det = v_{1x}v_{2y} - v_{1y}v_{2x}$, collinearity detection, and shaded span area).
   Includes direct canvas drag of vector heads at 60fps with hit testing.

---

## 2. Complete Inventory & Markdown Binding Audit

The table below catalogs all 11 interactive simulation widgets, their file sizes, registered template aliases, referenced Markdown nodes, parameters, and visual features.

| # | Widget Class | Source File | Line Count | Template Key Aliases | Bound Markdown Topics (`assets/content/`) | Sliders & Parameters | Visual Intuition & Canvas Features |
|---|---|---|---|---|---|---|---|
| 1 | `CartesianGraphWidget` | `cartesian_graph_widget.dart` | 531 | `function_graph`, `cartesian_plot` | **11 nodes**:<br>• `algebra/quadratics/mat_quad_spuria_01.md`<br>• `algebra/mat_parabola_01.md`<br>• `algebra/quadratics/mat_quad_pura_01.md`<br>• `algebra/quadratics/mat_quad_monomia_01.md`<br>• `calculus/limits/mat_lim_cos_01.md`<br>• `calculus/limits/mat_lim_log_01.md`<br>• `calculus/limits/mat_limits_01.md`<br>• `calculus/limits/mat_lim_e_01.md`<br>• `calculus/limits/mat_lim_exp_01.md`<br>• `calculus/integrals/mat_integ_parts_01.md`<br>• `calculus/integrals/mat_integ_subst_01.md` | Dynamic coefficients (`a`, `b`, `c`) with `minValue`, `maxValue`, `stepSize` | Cartesian grid, continuous curve plotting, dynamic vertex marker (hardcoded quadratic), auto-morphing toggle. |
| 2 | `DerivativeTangentWidget` | `derivative_tangent_widget.dart` | 497 | `derivative_tangent`, `difference_quotient` | **2 nodes**:<br>• `calculus/derivatives/mat_deriv_def_01.md`<br>• `calculus/derivatives/mat_deriv_rules_01.md` | Base point $x_0 \in [-2, 2]$, increment $h \in [0.05, 2.5]$ | Parabola $f(x) = \frac{1}{2}x^2$, secant line through $P$ and $Q$, collapsing tangent line as $h \to 0$, differential triangle $(\Delta x, \Delta y)$, convergence error telemetry. |
| 3 | `KinematicsSimulationWidget` | `kinematics_simulation_widget.dart` | 715 | `kinematics_simulation`, `rectilinear_motion` | **1 node**:<br>• `physics/phys_kin_01.md` | Initial velocity $v_0$ (def: 5 m/s), acceleration $a$ (def: 2 m/s²) | Metric road (0–100m), aerodynamically styled car with rotating wheels, motion trail, velocity vector $\vec{v}$, real-time telemetry ($x, v, t$), Torricelli formula card. |
| 4 | `LiveEquationWidget` | `live_equation_widget.dart` | 462 | `live_equation` (and fallback for unassigned templates with parameters) | **10 nodes**:<br>• `arithmetic/operations/mat_mul_01.md`<br>• `algebra/quadratics/mat_quad_viete_01.md`<br>• `arithmetic/mat_pow_01.md`<br>• `arithmetic/operations/mat_add_01.md`<br>• `arithmetic/mat_frac_01.md`<br>• `algebra/mat_binom_01.md`<br>• `physics/circuits/ele_power_01.md`<br>• `algebra/mat_log_01.md`<br>• `physics/chem_ph_01.md`<br>• `physics/circuits/ele_joule_01.md` | Dynamic variable tokens extracted from math formula with auto-discovery | **Purely numerical** display with large result font, live badge, and parameter sliders. Zero geometric canvas. |
| 5 | `OhmCircuitSimulationWidget` | `ohm_circuit_simulation_widget.dart` | 878 | `circuit_simulation`, `ohm_simulation` | **1 node**:<br>• `physics/circuits/ele_ohm_01.md` | Voltage $V \in [1, 48]\text{V}$, Resistance $R \in [1, 48]\Omega$ | Closed rectangular wire loop, DC battery (+/- plates), thermal glow resistor (Joule effect shader), ammeter, animated drifting electrons / conventional current switch. |
| 6 | `QuadraticVisualProofWidget` | `quadratic_visual_proof_widget.dart` | 1207 | `completing_square`, `quadratic_visual`, `quadratic_proof`, `dimostrazione_quadratica` | **1 node**:<br>• `algebra/quadratics/mat_quad_eq_01.md` | Coefficients $a, b, c$ and geometric base side $x$ | Dual mode: (1) Al-Khwarizmi 2D geometric dissection in 5 steps ($x^2$, two wings $\frac{b}{2a}x$, missing corner $\frac{b^2}{4a^2}$); (2) Cartesian parabola with symmetry axis $x = -b/(2a)$ and root span $\pm \sqrt{\Delta}/(2a)$. |
| 7 | `RiemannSumWidget` | `riemann_sum_widget.dart` | 463 | `riemann_sum`, `riemann_integral` | **2 nodes**:<br>• `calculus/integrals/mat_fund_calc_01.md`<br>• `calculus/integrals/mat_riemann_01.md` | Partitions count $N \in [2, 40]$ on $[0, 2]$ | Rectangular midpoint partitions, exact curve $f(x) = 0.75x^2 + 0.5$, exact Barrow definite integral comparison, convergence error telemetry $|\Sigma - \int|$. |
| 8 | `RolleLagrangeWidget` | `rolle_lagrange_widget.dart` | 776 | `rolle_lagrange`, `rolle`, `lagrange` | **1 node**:<br>• `calculus/derivatives/mat_deriv_theorems_01.md` | Interval endpoints $a \in [-2.4, -0.2]$, $b \in [0.2, 2.4]$ | Cubic curve $f(x) = x^3/3 - x$, secant line through $(a, f(a))$ and $(b, f(b))$, parallel tangent at interior $c$, dual mode (Lagrange vs. Rolle with dual horizontal tangents at $c_1=-1, c_2=+1$). |
| 9 | `SqueezeTheoremWidget` | `squeeze_theorem_widget.dart` | 713 | `squeeze_theorem`, `carabinieri_theorem`, `teorema_carabinieri` | **1 node**:<br>• `calculus/limits/mat_lim_sinc_01.md` | Interval semiamplitude $\delta \in [0.05, 1.5]$, probe point $x \in [-\delta, \delta]$ | Three sandwich curves: $g(x) = \cos(x) \le f(x) = \frac{\sin x}{x} \le 1 = h(x)$, translucent corridor envelope shading, vertical probe connector, common limit $(0, 1)$ glow. |
| 10 | `TriangleSolverWidget` | `triangle_solver_widget.dart` | 736 | `triangle_solver`, `pythagoras_carnot` | **3 nodes**:<br>• `geometry_trig/geometry/mat_triang_01.md`<br>• `geometry_trig/geometry/mat_pythagoras_01.md`<br>• `geometry_trig/trigonometry/mat_trig_triang_01.md` | Sides $a, b \in [1.5, 6.0]$, angle $\gamma \in [15^\circ, 160^\circ]$ | Geometric proof of Carnot's Law via right triangle $\triangle BHA$, dynamic altitude $h = a\sin\gamma$, projection $p = a\cos\gamma$, angle arc, collapse to Pythagoras when $\gamma = 90^\circ$. |
| 11 | `TrigCircleWidget` | `trig_circle_widget.dart` | 768 | `trig_circle`, `trigonometric_circle` | **2 nodes**:<br>• `geometry_trig/trigonometry/mat_trig_circ_01.md`<br>• `geometry_trig/trigonometry/mat_trig_add_01.md` | Angle $\theta \in [0, 2\pi]$ (preset chips for $0, \pi/6, \pi/4, \pi/3, \pi/2, \dots$) | Direct touch drag on canvas, unit circle, orthogonal projections ($\cos\theta$ blue, $\sin\theta$ green), tangent line $x = 1$ across all 4 quadrants with graceful asymptote protection, fundamental identity readout. |

---

## 3. Deep Audit Against User Requirements (R1 Criteria)

### 3.1 Autoplay & Animation Control Analysis
- **Initial State**: All 11 widgets strictly initialize with autoplay **disabled** (`_isPlaying = false`, `_isAutoAnimating = false`, `_isAutoRotating = false`, `_isAutoMorphing = false`, `_isAutoPartitioning = false`, `_isAutoTransforming = false`). Verified by automated tests in `test/simulations_autoplay_and_geometry_stress_test.dart`.
- **Manual Play Controls**: Each widget features an explicit play/pause button (`Icons.play_circle_fill_rounded` / `Icons.pause_circle_rounded`) in its header card with informative tooltips.
- **Animation Loops**:
  - `KinematicsSimulationWidget`: Smooth `AnimationController` delta accumulation. Resets gracefully after reaching 100m or upon deceleration stop.
  - `TrigCircleWidget`: Uniform $2\pi$ angular sweep with smooth pause/resume without resetting user angle.
  - `RolleLagrangeWidget`, `SqueezeTheoremWidget`, `RiemannSumWidget`, `TriangleSolverWidget`: Use `repeat(reverse: true)` for periodic oscillation of parameters, which stops immediately upon slider interaction.

### 3.2 Pedagogical Value & Geometric Intuition Audit
1. **The `LiveEquationWidget` Gap**:
   - `LiveEquationWidget` is referenced by **10 out of 35 curriculum articles** (28.6% of the entire curriculum).
   - In topics like `mat_frac_01.md` (fractions), `mat_mul_01.md` (multiplication), and `mat_binom_01.md` (binomial theorem $(a+b)^2$), the widget renders only numeric sliders and a raw number (e.g. `4.00`). There is no visual area decomposition, no fraction strip, no geometric square.
   - In physics circuits (`ele_power_01.md` $P = VI$ and `ele_joule_01.md` $Q = R I^2 t$), `LiveEquationWidget` is used instead of leveraging `OhmCircuitSimulationWidget`, which already renders electron flow, ammeters, and Joule thermal dissipation shaders.
2. **The `CartesianGraphWidget` Discrepancy**:
   - `CartesianGraphWidget` lines 146–151:
     ```dart
     final a = _paramValues['a'] ?? 1.0;
     final b = _paramValues['b'] ?? 0.0;
     final c = _paramValues['c'] ?? 0.0;
     final formulaText = 'y = ${a.toStringAsFixed(1)}x² ${b >= 0 ? '+ ' : '- '}${b.abs().toStringAsFixed(1)}x ${c >= 0 ? '+ ' : '- '}${c.abs().toStringAsFixed(1)}';
     ```
   - Lines 473–490:
     ```dart
     if (a.abs() > 0.001) {
       final vx = -b / (2 * a);
       final vy = a * vx * vx + b * vx + c;
       // Draws parabola vertex V(vx, vy)
     }
     ```
   - In `mat_lim_e_01.md`, the equation is `(1 + 1/x)^x`. In `mat_lim_log_01.md`, it is `log(1 + x) / x`. In `mat_integ_parts_01.md`, it is `x * e^x`. In all these topics, the formula card erroneously states `y = 1.0x² + 0.0x - 2.0` and plots a fake vertex $V(0, -2)$ on top of an exponential or logarithmic curve.
3. **High-Intuition Exemplars**:
   - `QuadraticVisualProofWidget`: Demonstrates how Al-Khwarizmi's geometric square dissection forms the basis of algebraic completion of the square.
   - `TriangleSolverWidget`: Clearly illustrates Carnot's theorem through orthogonal projection $p = a\cos\gamma$ and altitude $h = a\sin\gamma$, showing the geometric collapse into Pythagoras when $\cos(90^\circ) = 0$.
   - `SqueezeTheoremWidget`: Provides visual intuition of the Squeeze Theorem with shaded bounding envelope.
   - `TrigCircleWidget`: Renders sine, cosine, and tangent projections seamlessly across all 4 quadrants with asymptotic stability.

### 3.3 60fps Gesture, Slider Responsiveness & State Management
- **Performance Hazard in `CartesianGraphWidget`**:
  Lines 435–452 in `_CartesianPainter.paint()`:
  ```dart
  const stepPx = 1.5;
  for (double px = 0; px <= w; px += stepPx) {
    final mathX = (px - origin.dx) / scale;
    final mathY = evaluateY(mathX); // Calls _parser.parse(_equationString) on EVERY step!
    ...
  }
  ```
  On a 400px wide screen, this executes `_parser.parse(_equationString)` **267 times per frame**. String parsing and grammar AST construction inside the inner render loop causes severe CPU frame drops.
- **Touch Gesture vs. Slider Handling**:
  - `TrigCircleWidget` is the **only** widget that allows touching and dragging the canvas directly. Its `_updateAngleFromOffset` converts `Offset(dx, dy)` to polar angle $\theta$ via `math.atan2(dy, dx)`.
  - All other 10 widgets require manipulating `Slider` controls below the canvas.
  - Adding direct canvas interaction to 2D vector visualization (dragging the vector arrows directly) will bridge this gap for the new Linear Algebra module.
- **State Management**:
  - Clean lifecycle: Widgets properly override `initState`, `didUpdateWidget`, and `dispose` (unregistering ticker listeners and disposing animation controllers).
  - Memory leak checks: Verified zero controller leaks in automated test runs.

### 3.4 Code Elegance & Size Metrics
- Widgets range from 462 lines (`LiveEquationWidget`) to 1,207 lines (`QuadraticVisualProofWidget`).
- While self-contained and modular, there is repeated code across widgets for:
  - Metric telemetry tiles (`_buildMetricCard` / `_buildTelemetryBox`).
  - Parameter slider styling (`SliderTheme` overrides).
  - Dashed line rendering (`_drawDashedLine`).
- A shared utility or component module could eliminate boilerplate without sacrificing widget independence.

---

## 4. Design & Architecture for R3: 2D Vector Simulation Widget

### 4.1 Module Context & Linear Algebra Curriculum (R2)
The Linear Algebra curriculum (R2) introduces:
1. **$n$-tuple and $\mathbb{R}^n$**: Points and vectors in $\mathbb{R}^2$ as pairs $(x, y)$.
2. **Geometric Vectors & Canonical Basis**: Applied vectors, magnitude $|\mathbf{v}| = \sqrt{v_x^2 + v_y^2}$, direction angle $\theta$, basis decomposition $\mathbf{v} = v_x \mathbf{e}_1 + v_y \mathbf{e}_2$.
3. **Fundamental Vector Operations**: Vector addition $\mathbf{v}_1 + \mathbf{v}_2$ (parallelogram rule and tip-to-tail method) and scalar multiplication $c \mathbf{v}$.
4. **Linear Combinations & Span**: $\mathbf{w} = c_1 \mathbf{v}_1 + c_2 \mathbf{v}_2$, geometric visualization of span (plane vs line).
5. **Linear Dependence & Independence**: $c_1 \mathbf{v}_1 + c_2 \mathbf{v}_2 = \mathbf{0} \iff c_1 = c_2 = 0$. Collinearity condition via 2D determinant $\det[\mathbf{v}_1, \mathbf{v}_2] = v_{1x}v_{2y} - v_{1y}v_{2x} = 0$.

### 4.2 Widget Specification: `Vector2DSimulationWidget`
- **File Location**: `lib/presentation/widgets/interactive/vector_2d_simulation_widget.dart`
- **Template Key Aliases**:
  `vector_2d`, `linear_combination`, `vector_addition`, `vector_span`, `vector_space`, `vettori_2d`, `somma_vettoriale`, `combinazione_lineare`.

### 4.3 Pedagogical Views & Modes
The widget should feature a top `SegmentedButton` with 3 views:

```
┌─────────────────────────────────────────────────────────────┐
│ [ Vettore & Coordinate ]  [ Somma Vettoriale ]  [ Span & Base ]│
└─────────────────────────────────────────────────────────────┘
```

#### View 1: Vettore & Coordinate (`components`)
- **Visuals**:
  - Vector $\mathbf{v} = (v_x, v_y)$ starting at $(0, 0)$ with arrow tip at $P(v_x, v_y)$.
  - Orthogonal projections: horizontal component $v_x \mathbf{e}_1$ on X axis (cyan) and vertical component $v_y \mathbf{e}_2$ on Y axis (amber).
  - Right triangle connecting origin, $(v_x, 0)$, and $(v_x, v_y)$.
  - Angle arc for direction $\theta = \operatorname{atan2}(v_y, v_x)$.
- **Direct Touch Interaction**:
  - Dragging the vector head directly updates $(v_x, v_y)$ at 60fps.
  - Snap-to-grid assistance when within 0.15 of integer coordinates.
- **Telemetry Readouts**:
  - Components: $\mathbf{v} = (v_x, v_y)$
  - Magnitude: $|\mathbf{v}| = \sqrt{v_x^2 + v_y^2}$
  - Direction: $\theta$ in degrees and radians
  - Canonical Basis Form: $\mathbf{v} = v_x \mathbf{e}_1 + v_y \mathbf{e}_2$

#### View 2: Somma Vettoriale (`addition`)
- **Visuals**:
  - Two independent vectors $\mathbf{v}_1 = (x_1, y_1)$ (cyan) and $\mathbf{v}_2 = (x_2, y_2)$ (amber).
  - Sum vector $\mathbf{s} = \mathbf{v}_1 + \mathbf{v}_2 = (x_1 + x_2, y_1 + y_2)$ (fuchsia / rose).
  - **Sub-mode Toggle**:
    1. *Regola del Parallelogramma*: Dashed lines from $\mathbf{v}_1$ to $\mathbf{s}$ (parallel to $\mathbf{v}_2$) and from $\mathbf{v}_2$ to $\mathbf{s}$ (parallel to $\mathbf{v}_1$).
    2. *Metodo Punta-Coda (Tip-to-Tail)*: Vector $\mathbf{v}_2$ rendered translated starting at the head of $\mathbf{v}_1$.
- **Direct Touch Interaction**:
  - Touch hit testing: user can touch and drag head of $\mathbf{v}_1$ OR head of $\mathbf{v}_2$ independently.
- **Telemetry Readouts**:
  - $\mathbf{v}_1 = (x_1, y_1)$, $\mathbf{v}_2 = (x_2, y_2)$, $\mathbf{s} = \mathbf{v}_1 + \mathbf{v}_2$
  - Magnitudes: $|\mathbf{v}_1|$, $|\mathbf{v}_2|$, $|\mathbf{s}|$
  - Triangle Inequality Check: $|\mathbf{v}_1 + \mathbf{v}_2| \le |\mathbf{v}_1| + |\mathbf{v}_2|$ (with equality when collinear with same direction).

#### View 3: Combinazione Lineare & Span (`linear_combination`)
- **Visuals**:
  - Two basis vectors $\mathbf{v}_1$ and $\mathbf{v}_2$.
  - Scaled vectors $c_1 \mathbf{v}_1$ and $c_2 \mathbf{v}_2$.
  - Linear combination $\mathbf{w} = c_1 \mathbf{v}_1 + c_2 \mathbf{v}_2$.
  - Parallelogram area formed by $\mathbf{v}_1$ and $\mathbf{v}_2$, shaded with translucent indigo.
  - Collinearity line: when vectors are collinear ($\det \approx 0$), the line $\operatorname{Span}(\mathbf{v}_1)$ is drawn extending across the canvas.
- **Controls**:
  - Direct canvas dragging of $\mathbf{v}_1$ and $\mathbf{v}_2$.
  - Sliders for scalar coefficients $c_1 \in [-3.0, 3.0]$ and $c_2 \in [-3.0, 3.0]$ with default $1.0$.
  - Preset chips: $(1, 1)$, $(2, -1)$, $(-1, 2)$, $(0.5, 0.5)$, $(0, 0)$.
- **Telemetry & Determinant Badge**:
  - 2D Determinant: $\det[\mathbf{v}_1, \mathbf{v}_2] = x_1 y_2 - y_1 x_2$.
  - Area of parallelogram: $|\det|$.
  - Status Badge:
    - If $|\det| \ge 0.05$: **Linearmente Indipendenti: $\operatorname{Span}(\mathbf{v}_1, \mathbf{v}_2) = \mathbb{R}^2$ (Base di $\mathbb{R}^2$)** (Green badge).
    - If $|\det| < 0.05$: **Collineari (Linearmente Dipendenti): $\operatorname{Span} = \text{Retta}$** (Amber/Red badge).

### 4.4 Canvas Math & Projection Engine
```dart
class Vector2D {
  final double x;
  final double y;
  const Vector2D(this.x, this.y);

  double get length => math.sqrt(x * x + y * y);
  double get angle => math.atan2(y, x);

  Vector2D operator +(Vector2D other) => Vector2D(x + other.x, y + other.y);
  Vector2D operator *(double scalar) => Vector2D(x * scalar, y * scalar);

  double cross(Vector2D other) => x * other.y - y * other.x; // 2D Determinant
}
```

- **Canvas Scale & Origin**:
  - Origin $(0, 0)$ placed at the center of the canvas: `Offset(size.width / 2, size.height / 2)`.
  - Scale: $24.0$ pixels per mathematical unit (allowing visible range from $-6$ to $+6$).
  - Coordinate conversion:
    ```dart
    Offset toPixel(Vector2D v, Offset center, double scale) {
      return Offset(center.dx + v.x * scale, center.dy - v.y * scale);
    }
    Vector2D toMath(Offset p, Offset center, double scale) {
      return Vector2D((p.dx - center.dx) / scale, -(p.dy - center.dy) / scale);
    }
    ```

### 4.5 Hit-Testing & Direct Touch Dragging
```dart
int? _draggedVectorIndex; // null, 1 (v1), or 2 (v2)

void _onPanStart(Offset localPos, Size size) {
  final center = Offset(size.width / 2, size.height / 2);
  const scale = 24.0;
  final p1 = toPixel(_v1, center, scale);
  final p2 = toPixel(_v2, center, scale);

  const hitRadius = 28.0;
  if ((localPos - p1).distance <= hitRadius) {
    _draggedVectorIndex = 1;
  } else if (_mode != 0 && (localPos - p2).distance <= hitRadius) {
    _draggedVectorIndex = 2;
  } else {
    _draggedVectorIndex = null;
  }
}

void _onPanUpdate(Offset localPos, Size size) {
  if (_draggedVectorIndex == null) return;
  final center = Offset(size.width / 2, size.height / 2);
  const scale = 24.0;
  var mathPos = toMath(localPos, center, scale);

  // Optional subtle snap to integer coordinates if within 0.15
  final rx = mathPos.x.roundToDouble();
  final ry = mathPos.y.roundToDouble();
  if ((mathPos.x - rx).abs() < 0.15) mathPos = Vector2D(rx, mathPos.y);
  if ((mathPos.y - ry).abs() < 0.15) mathPos = Vector2D(mathPos.x, ry);

  setState(() {
    if (_draggedVectorIndex == 1) _v1 = mathPos;
    if (_draggedVectorIndex == 2) _v2 = mathPos;
  });
}
```

### 4.6 Integration in `InteractiveTemplateFactory`
Add cases to `lib/presentation/widgets/interactive/interactive_template_factory.dart`:
```dart
case 'vector_2d':
case 'linear_combination':
case 'vector_addition':
case 'vector_span':
case 'vector_space':
case 'vettori_2d':
case 'somma_vettoriale':
case 'combinazione_lineare':
  return Vector2DSimulationWidget(data: data);
```

---

## 5. Concrete Recommendations & Step-by-Step Implementation Strategy

### 5.1 Milestone 1: Interactive Simulation Cleanups & Fixes (R1)

#### Step 1.1: Fix `CartesianGraphWidget` Performance Bottleneck
- **Problem**: `_parser.parse(_equationString)` is executed ~250 times per frame inside `_evaluateY` in `_CartesianPainter.paint()`.
- **Solution**:
  - Parse the mathematical expression **once** when `_equationString` changes (in `_initializeParams()`). Store the parsed `Expression _parsedExpression`.
  - Pass the compiled expression or precomputed sampling array / evaluator closure into `_CartesianPainter`.
  - Inside the 60fps sampling loop, only bind variables to `ContextModel` and evaluate. This eliminates repeated grammar parsing, reducing frame time from >16ms to <1ms.

#### Step 1.2: Fix `CartesianGraphWidget` Formula Text & Vertex Marker Discrepancy
- **Problem**: Line 150 hardcodes `y = ax² + bx + c` and line 473 draws parabola vertex $V$, even for limits and integrals.
- **Solution**:
  - Check whether the equation is quadratic (or whether parameters are `a, b, c`).
  - If the equation is non-quadratic (e.g., `(1 + 1/x)^x`, `log(1+x)/x`, `x * e^x`):
    - Render the actual equation string in the formula badge (e.g. `f(x) = (1 + 1/x)^x`).
    - Suppress the parabola vertex marker $V(-b/2a, ...)$.
    - Only display the vertex marker if the formula is quadratic and $a \ne 0$.

#### Step 1.3: Elevate Circuit Topics to `circuit_simulation`
- **Problem**: `physics/circuits/ele_power_01.md` and `ele_joule_01.md` currently declare `template: live_equation`, which only shows a numeric number.
- **Solution**:
  - Update `ele_power_01.md` to declare `template: circuit_simulation`. `OhmCircuitSimulationWidget` already features power calculation $P = VI$ and thermal glow.
  - Update `ele_joule_01.md` to declare `template: circuit_simulation`, visually highlighting heat dissipation.

#### Step 1.4: Refactor / Augment `LiveEquationWidget` with Visual Scale
- **Problem**: `LiveEquationWidget` is purely numeric across 10 curriculum nodes.
- **Solution**:
  - Add a dynamic proportional visual gauge/bar below the result (e.g., dynamic relative scale or balance bar) to provide immediate geometric/magnitude feedback for inputs and outputs.

---

### 5.2 Milestone 2: R3 2D Vector Simulation Widget Implementation

#### Step 2.1: Implement `Vector2DSimulationWidget`
- Create `lib/presentation/widgets/interactive/vector_2d_simulation_widget.dart` (~600 lines).
- Incorporate the 3 pedagogical views:
  1. *Vettore & Coordinate*
  2. *Somma Vettoriale (Parallelogramma / Punta-Coda)*
  3. *Combinazione Lineare & Span ($c_1 \mathbf{v}_1 + c_2 \mathbf{v}_2$)*
- Implement `GestureDetector` with 60fps touch-dragging of vector arrowheads.
- Implement sliders for $c_1, c_2 \in [-3, 3]$ and preset combination buttons.
- Calculate 2D determinant $\det[\mathbf{v}_1, \mathbf{v}_2]$ and display live collinearity / independence status.
- Ensure paused initial state with autoplay disabled.

#### Step 2.2: Register in `InteractiveTemplateFactory`
- Update `lib/presentation/widgets/interactive/interactive_template_factory.dart` with all aliases (`vector_2d`, `linear_combination`, `vector_addition`, `vector_span`, `vector_space`, `vettori_2d`, `somma_vettoriale`, `combinazione_lineare`).
- Default view mapping based on incoming template key:
  - `vector_addition`, `somma_vettoriale` $\to$ View 2.
  - `linear_combination`, `combinazione_lineare`, `vector_span` $\to$ View 3.
  - `vector_2d`, `vettori_2d` $\to$ View 1 (or 3 if coefficients provided).

#### Step 2.3: Connect with 5 Linear Algebra Content Articles (R2)
- In the new linear algebra curriculum nodes (`assets/content/linear_algebra/`):
  - `lin_tuples_01.md` $\to$ `template: vector_2d` (mode: components).
  - `lin_vectors_geom_01.md` $\to$ `template: vector_2d` (mode: components & basis).
  - `lin_vec_ops_01.md` $\to$ `template: vector_addition` (parallelogram & tip-to-tail).
  - `lin_linear_comb_01.md` $\to$ `template: linear_combination` (sliders $c_1, c_2$).
  - `lin_linear_indep_01.md` $\to$ `template: linear_combination` (collinearity & determinant check).

#### Step 2.4: Comprehensive Automated Test Suite
- Create `test/vector_2d_simulation_test.dart` verifying:
  1. Starts in paused state without automated motion.
  2. Renders on canvas with initial vectors $\mathbf{v}_1 = (2, 3)$, $\mathbf{v}_2 = (3, -1)$.
  3. Mode switching between Components, Addition, and Linear Combination.
  4. Parallelogram vs Tip-to-Tail submode toggle in addition mode.
  5. Vector arithmetic and determinant calculations:
     - Independent vectors $\mathbf{v}_1 = (2, 1), \mathbf{v}_2 = (1, 3) \implies \det = 5 \implies \text{Independent}$.
     - Collinear vectors $\mathbf{v}_1 = (2, 1), \mathbf{v}_2 = (4, 2) \implies \det = 0 \implies \text{Collinear / Dependent}$.
  6. Direct drag interaction updating vector coordinates.
  7. Factory routing verification for all 8 template aliases.

#### Step 2.5: Update `PROJECT_MAP.md`
- Register `Vector2DSimulationWidget` in the interactive widget table in Section 4 of `PROJECT_MAP.md`.
- Document its template keys, parameters, and features while strictly respecting the 300-line budget.

---

## 6. Verification and Regression Checklist

| Target / Check | Verification Command / Method | Expected Outcome |
|---|---|---|
| Static Analysis | `flutter analyze` | 0 errors, 0 warnings |
| Existing Test Suite | `flutter test` | All 251+ tests pass |
| Interactive Simulation Suite | `flutter test test/interactive_simulation_test.dart` | 100% pass |
| Simulation Stress & Autoplay Suite | `flutter test test/simulations_autoplay_and_geometry_stress_test.dart` | 100% pass |
| Vector 2D Widget Tests | `flutter test test/vector_2d_simulation_test.dart` | 100% pass |
| Content Loader & DAG Integrity | `flutter test test/markdown_content_loader_test.dart`<br>`flutter test test/curriculum_dag_test.dart` | Ingestion pass, DAG strictly acyclic |
| `PROJECT_MAP.md` Budget | Line count check | Strictly $\le 300$ lines |
