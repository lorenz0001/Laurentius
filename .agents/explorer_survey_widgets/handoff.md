# Handoff Report — Explorer Survey: Interactive Simulation Widgets & Animation Controls

## 1. Observation

### 1.1 Scope & Inventory of Interactive Widgets
Under `lib/presentation/widgets/interactive/`, the system defines 10 Dart files:
1. `interactive_template_factory.dart` (66 lines)
2. `kinematics_simulation_widget.dart` (723 lines)
3. `ohm_circuit_simulation_widget.dart` (885 lines)
4. `trig_circle_widget.dart` (719 lines)
5. `cartesian_graph_widget.dart` (540 lines)
6. `derivative_tangent_widget.dart` (479 lines)
7. `riemann_sum_widget.dart` (445 lines)
8. `triangle_solver_widget.dart` (533 lines)
9. `rolle_lagrange_widget.dart` (724 lines)
10. `live_equation_widget.dart` (367 lines)

All 146 existing tests pass under `flutter test` and `flutter analyze` reports 0 issues.

---

### 1.2 Exact Autoplay Call Sites & Initial States (R1)
Through code inspection and pattern search (`repeat(`), 7 of the 9 simulation widgets contain automated animation calls in `initState()` and default flags set to `true`:

1. **`kinematics_simulation_widget.dart`**:
   - Line 27: `bool _isPlaying = true;`
   - Line 42: `_animController.repeat();` inside `initState()` (lines 32-43).
   - Lines 78-94: `_onTick()` increments `_elapsedTime += dt` continuously.
   - Initial behavior: Car begins translating immediately across the track; wheels rotate.

2. **`ohm_circuit_simulation_widget.dart`**:
   - Line 26: `bool _isPlaying = true;`
   - Line 44: `_animController.repeat();` inside `initState()` (lines 33-45).
   - Lines 90-101: `_onTick()` advances phase `_phase = (_phase + speed * dt) % 1.0;`.
   - Initial behavior: Electron dots immediately drift through the wire paths at 60 FPS.

3. **`trig_circle_widget.dart`**:
   - Line 24: `bool _isAutoRotating = true;`
   - Lines 42-43:
     ```dart
     _autoRotateController.forward(from: (_angleRad / (2 * math.pi)));
     _autoRotateController.repeat();
     ```
   - Lines 46-52: `_onAutoRotateTick()` continuously alters `_angleRad`.
   - Initial behavior: Radius vector spins around the circle continuously at 12s per revolution.

4. **`cartesian_graph_widget.dart`**:
   - Line 24: `bool _isAutoMorphing = true;`
   - Line 36: `_graphAnimController.repeat(reverse: true);` inside `initState()`.
   - Lines 39-52: `_onGraphAnimTick()` wobbles parameter `a` between `-2.0` and `+2.0`.
   - Initial behavior: Quadratic/polynomial curve oscillates constantly.

5. **`derivative_tangent_widget.dart`**:
   - Line 22: `bool _isAutoAnimating = true;`
   - Line 40: `_limitAnimController.repeat(reverse: true);` inside `initState()`.
   - Lines 43-51: `_onLimitAnimTick()` oscillates increment $h$ between `2.0` and `0.05`.
   - Initial behavior: Secant line continuously sweeps towards the tangent line and back.

6. **`riemann_sum_widget.dart`**:
   - Line 23: `bool _isAutoPartitioning = true;`
   - Line 35: `_partitionAnimController.repeat(reverse: true);` inside `initState()`.
   - Lines 38-46: `_onPartitionTick()` dynamically alters rectangle count $N$ from `2` to `40`.
   - Initial behavior: Partitions expand and contract automatically.

7. **`triangle_solver_widget.dart`**:
   - Line 25: `bool _isAutoTransforming = true;`
   - Line 37: `_triangleAnimController.repeat(reverse: true);` inside `initState()`.
   - Lines 40-48: `_onTriangleAnimTick()` sweeps $\gamma$ between $40^\circ$ and $135^\circ$.
   - Initial behavior: Triangle vertices and hypotenuse flex continuously.

8. **`rolle_lagrange_widget.dart`**:
   - Line 26: `bool _isAutoAnimating = true;`
   - Line 44: `_animController.repeat(reverse: true);` inside `initState()`.
   - Lines 47-63: `_onAnimTick()` wobbles bounds $a$ and $b$ at 60 FPS.
   - Initial behavior: Secant line endpoints and parallel tangent point fluctuate constantly.

9. **`live_equation_widget.dart`**:
   - Does NOT declare any `AnimationController` or automated ticker. It initializes statically and recalculates on slider changes. It already satisfies R1.

---

### 1.3 Trigonometric Circle (`trig_circle_widget.dart`) Tangent & Projection Rendering (R2)
Inspecting `_TrigCirclePainter` (lines 460-713):
1. **Hard Asymptote Discontinuity**:
   - Lines 545-568:
     ```dart
     final isAsymptote = cosVal.abs() < 0.02;
     if (isAsymptote) {
       // Se siamo nei pressi di π/2 o 3π/2: linea asintotica rossa tratteggiata
       final asympPaint = Paint()..color = const Color(0xFFF43F5E)..strokeWidth = 2.0;
       canvas.drawLine(Offset(tanLineX - 1, 10), Offset(tanLineX - 1, size.height - 10), asympPaint);
       ...
     ```
   - When $|\cos\theta| < 0.02$ ($\theta \in [88.85^\circ, 91.15^\circ]$ and $[268.85^\circ, 271.15^\circ]$), the painter completely suppresses the tangent line, the tangent point $T$, and the arrowheads. Across a continuous drag or rotation, this hard conditional switch causes severe visual flashing and flickering.
2. **Distorted Slope on Clamping**:
   - Lines 580-592:
     ```dart
     final double clampedTanY = rawTanY.clamp(topMargin, bottomMargin);
     canvas.drawLine(center, Offset(tanLineX, clampedTanY), secantPaint);
     ```
     When `rawTanY` is clamped, `tanLineX` remains fixed at $center.dx + radius$. The line drawn from `center` to $(tanLineX, clampedTanY)$ no longer has slope $-\tan\theta$. The secant ray visibly bends away from point $P(\cos\theta, \sin\theta)$, violating geometric collinearity.
3. **Quadrants II and III Disconnection**:
   - In Q2 ($\frac{\pi}{2} < \theta < \pi$) and Q3 ($\pi < \theta < \frac{3\pi}{2}$), $\cos\theta < 0$, so $P$ is on the left side of the circle ($x < center.dx$).
   - Line 588 draws `canvas.drawLine(center, Offset(tanLineX, clampedTanY), secantPaint);`, drawing exclusively towards $x = 1$ in the right half of the canvas. No line connects $P$ to the center, nor is there a dashed collinear extension through the origin.
4. **Numerical Blowup**:
   - At $\theta = \frac{\pi}{2}$ (selectable via chip at line 386), `math.tan(math.pi / 2)` yields $1.63312 \times 10^{16}$, generating pixel values of order $10^{18}$.

---

### 1.4 Theorems & Limit Visualizations (Rolle, Lagrange, Carabinieri)
1. **`InteractiveTemplateFactory`**:
   - Lines 30-33 map aliases `'rolle_lagrange'`, `'rolle'`, `'lagrange'` to `RolleLagrangeWidget`.
   - Lines 37-40 auto-route expressions containing `'x * x * x / 3'` or `'rolle'` from `function_graph` to `RolleLagrangeWidget`.
   - There is NO template, alias, or widget for the Squeeze Theorem / Teorema dei Carabinieri. In `assets/content/calculus/mat_limits_01.md`, the article currently links to `function_graph` with equation `"sin(k * x) / x"`.
2. **`rolle_lagrange_widget.dart`**:
   - Uses `enum TheoremMode { lagrange, rolle }` to toggle between the two theorems.
   - For Rolle mode, only a single point $c$ is marked, whereas $f(x) = \frac{x^3}{3} - x$ has two distinct stationary points ($c_1 = -1$, $c_2 = +1$) on $[-\sqrt{3}, \sqrt{3}]$.

---

### 1.5 Carnot's Theorem / Triangle Geometry (`triangle_solver_widget.dart`)
1. **`_TrianglePainter` (lines 440-532)**:
   - Draws only the closed path $\triangle ABC$, edges $a, b, c$, and angle arc $\gamma$.
   - Does not render altitude $h$, perpendicular foot $H$, or orthogonal projection $a \cos\gamma$.
   - Law of Cosines is presented solely as numerical text in a card (`c² = a² + b² - 2ab·cos(γ)`), lacking any geometric proof illustration.

---

### 1.6 Existing Widget Tests in `test/`
1. `test/all_animations_test.dart` explicitly asserts autoplay on initial mount:
   - Line 14: `testWidgets('Starts auto-rotating immediately and progresses angle', ...)`
   - Line 34: `expect(nextString, isNot(equals(initialString)));`
   - Lines 37, 110, 186, 221, 263, 300, 352: expects pause tooltips (`Ferma rotazione`, `Pausa`, `Pausa flusso`, etc.) on initial mount.
2. `test/step12_reorganization_and_simulations_test.dart`:
   - Line 156: expects `find.byTooltip('Ferma rotazione')` immediately on mount of `TrigCircleWidget`.
3. `test/math_rendering_and_explorer_test.dart`:
   - Line 229: expects `find.byTooltip('Pausa simulazione')` on mount of `RolleLagrangeWidget`.
4. `test/m1_challenger2_simulation_stress_test.dart`:
   - Lines 255 & 468: expects `find.byIcon(Icons.pause_circle_filled_rounded)` on initial mount.

---

## 2. Logic Chain

### 2.1 Refactoring Animation Autoplay to Static Defaults (R1)
1. *Premise*: Educational clarity requires students to read and absorb definitions and diagrams without distraction. 60 FPS motion on initial mount distracts attention and forces immediate user defense (clicking pause).
2. *Remedy*:
   - In each of the 7 animated widgets, set the initial playing flag to `false`:
     * `_isPlaying = false;` (Kinematics, Ohm)
     * `_isAutoRotating = false;` (Trig Circle)
     * `_isAutoMorphing = false;` (Cartesian Graph)
     * `_isAutoAnimating = false;` (Derivative Tangent, Rolle-Lagrange)
     * `_isAutoPartitioning = false;` (Riemann Sum)
     * `_isAutoTransforming = false;` (Triangle Solver)
   - Remove unconditional `.repeat()` and `.forward()` calls from `initState()`.
   - Ensure header control buttons display the "Play" icon (`Icons.play_circle_fill_rounded`) and appropriate "Avvia / Anima" tooltip initially.
   - Clicking Play triggers `.repeat()`, and clicking Pause triggers `.stop()`.
   - Sliders, touch drag on canvas, and preset chips immediately trigger `setState()` and update geometries in a paused state.

---

### 2.2 Fixing `TrigCircleWidget` Tangent, Projections & Asymptotes (R2)
1. *Premise*: Tangent is geometrically defined as the intersection of the line passing through origin $O$ and $P(\cos\theta, \sin\theta)$ with the vertical line $x = 1$.
2. *Step 1: Continuous Secant Ray*:
   - Instead of drawing `center` to clamped $(x_{tan}, y_{clamped})$:
   - For all $\theta$, draw the ray collinear with $P$. In Q2 and Q3 ($\cos\theta < 0$), draw the solid radius $OP$, and draw a dashed line through origin $O$ extending into Q4/Q1 towards $x=1$.
3. *Step 2: Smooth Viewport Clamping (No Flickering)*:
   - Replace the threshold `cosVal.abs() < 0.02` with an exact clipping against viewport height:
     $y_T = center.dy - \tan\theta \cdot radius$.
   - If $|y_T - center.dy| \le H_{max}$:
     Draw solid tangent segment from $(tanLineX, center.dy)$ to $(tanLineX, y_T)$ and draw point $T(1, \tan\theta)$.
   - If $|y_T - center.dy| > H_{max}$:
     Clamp the drawn segment on $x = 1$ to viewport edge, and draw an infinity arrow pointing along $x = 1$ towards $+\infty$ (up) or $-\infty$ (down).
   - If $|\cos\theta| < 10^{-4}$ (exact asymptote $\theta = \pi/2, 3\pi/2$):
     Draw the vertical ray $OP$ parallel to $x = 1$, with a clean non-intrusive badge: *"Rette parallele: nessuna intersezione (tan θ non definita)"*.
4. *Step 3: Projections*:
   - Cosine vector (blue): from $(center.dx, center.dy)$ to $(center.dx + \cos\theta \cdot radius, center.dy)$.
   - Sine vector (green): from $(center.dx + \cos\theta \cdot radius, center.dy)$ to $P$.
   - Both vectors remain crisp in all 4 quadrants.

---

### 2.3 Theorems & Limit Visualizations (Rolle, Lagrange, Carabinieri)
1. *Rolle vs. Lagrange in `rolle_lagrange_widget.dart`*:
   - Keep `TheoremMode` in `RolleLagrangeWidget` for Lagrange and Rolle because both represent mean value theorems on $[a, b]$ for a single function.
   - For Rolle ($f(a) = f(b)$): Detect both roots of $f'(c) = 0$ ($c_1 = -1$ and $c_2 = +1$) on $[-\sqrt{3}, \sqrt{3}]$. Render both horizontal tangents ($y = 2/3$ and $y = -2/3$) simultaneously when both fall within $(a, b)$, reflecting the standard Wikipedia illustration.
2. *Teorema dei Carabinieri (Squeeze Theorem) Architectural Placement*:
   - **Determination**: Carabinieri must be a **dedicated widget** (`SqueezeTheoremWidget`), NOT a mode inside `RolleLagrangeWidget`.
   - **Rationale**:
     * Mathematical domain: Limit of three bounding functions ($g(x) \le f(x) \le h(x)$ as $x \to x_0$) vs. derivative/mean value of a single function.
     * Rendering model: Shaded squeeze envelope pinching down to $(x_0, L)$ vs. chord parallel to tangent line.
     * Architectural integrity: Adding Carabinieri to `RolleLagrangeWidget` would violate SRP and inflate the file well over 1000 lines.
   - Register template key `squeeze_theorem` (with aliases `carabinieri_theorem`, `teorema_carabinieri`) in `InteractiveTemplateFactory`.
   - `SqueezeTheoremWidget` renders:
     * Upper bound $h(x) = 1$ (or $1 + 0.1x^2$)
     * Lower bound $g(x) = \cos x$
     * Central trapped function $f(x) = \frac{\sin x}{x}$
     * Squeezed envelope region shaded between $g(x)$ and $h(x)$
     * Interactive probe $x \in [-1.5, 1.5]$ or delta slider $\delta \to 0$ showing $|h(x) - g(x)| \to 0 \implies \lim_{x\to 0} f(x) = 1$.

---

### 2.4 Carnot's Theorem / Geometric Law of Cosines (`triangle_solver_widget.dart`)
1. *Geometric Intuition*:
   - Law of Cosines is the generalized Pythagorean theorem:
     In $\triangle ABC$ with horizontal base $b = AC$:
     Drop altitude $h = BH \perp AC$. Foot $H$ has distance $d = a\cos\gamma$ from $C$.
     In right triangle $\triangle BHA$:
     $c^2 = h^2 + (b - a\cos\gamma)^2 = (a\sin\gamma)^2 + b^2 - 2ab\cos\gamma + a^2\cos^2\gamma = a^2 + b^2 - 2ab\cos\gamma$.
2. *Canvas Rendering Enhancements*:
   - Draw dashed altitude $BH$ with right-angle corner mark at $H$.
   - Highlight base projection segment $CH$ with label $p = a\cos\gamma$.
   - Highlight remaining base $HA = |b - a\cos\gamma|$.
   - For $\gamma = 90^\circ$, $H = C$, projection $p = 0$, directly revealing Pythagoras $c^2 = a^2 + b^2$.
   - For $\gamma > 90^\circ$, extend base line dashed to the left to meet foot $H$.

---

### 2.5 Test Suite Impact & Update Strategy
1. Because existing tests in `test/all_animations_test.dart`, `test/step12_reorganization_and_simulations_test.dart`, `test/math_rendering_and_explorer_test.dart`, and `test/m1_challenger2_simulation_stress_test.dart` expect widgets to start in an active animating state, implementing R1 will break those test assertions.
2. The tests must be updated to expect:
   - Initial state is PAUSED (e.g. `expect(find.byIcon(Icons.play_circle_fill_rounded), findsOneWidget)`).
   - Advance time via `tester.pump(Duration(seconds: 1))` -> value does NOT advance.
   - Tap play button -> state becomes PLAYING, icon switches to PAUSE, time advance progresses values.
   - Tap pause button -> state reverts to PAUSED.

---

## 3. Caveats
- No changes have been made to production source code during this read-only investigation.
- `flutter test` currently passes 146/146 tests on the existing codebase; updating animation autoplay requires synchronizing test assertions in `test/all_animations_test.dart` and sibling test files in the same pull request/commit to maintain 100% green test status.

---

## 4. Conclusion & Actionable Implementation Plan

### 4.1 Implementation Steps for R1 (Autoplay Refactor)
1. For each of the 7 animated widgets:
   - Set initial boolean flag to `false`.
   - Remove `.repeat()` from `initState()`.
   - Ensure header control button reflects paused state (`Icons.play_circle_fill_rounded`, tooltip `'Avvia ...'`).

### 4.2 Implementation Steps for R2 (Diagrams & Fixes)
1. **`trig_circle_widget.dart`**:
   - Refactor `_TrigCirclePainter` to draw true collinear rays for all 4 quadrants (solid $OP$, dashed backward extension through origin for Q2/Q3).
   - Replace `cosVal.abs() < 0.02` with viewport boundary clamping and smooth infinity arrow rendering.
   - Render clean parallel indicator when $|\cos\theta| < 10^{-4}$.
2. **`rolle_lagrange_widget.dart`**:
   - Remove interval wobble from `initState()`.
   - Enhance Rolle mode to render both horizontal tangent lines ($c_1 = -1, c_2 = +1$) when contained in $[a, b]$.
3. **`squeeze_theorem_widget.dart` (New Widget)**:
   - Create `lib/presentation/widgets/interactive/squeeze_theorem_widget.dart`.
   - Implement curves $g(x) = \cos x$, $f(x) = \frac{\sin x}{x}$, $h(x) = 1$, shaded squeeze corridor, and $\delta$-slider.
   - Register `'squeeze_theorem'`, `'carabinieri_theorem'`, `'teorema_carabinieri'` in `InteractiveTemplateFactory`.
4. **`triangle_solver_widget.dart`**:
   - Add altitude $h = a\sin\gamma$, projection segment $p = a\cos\gamma$, right-angle square marker at $H$, and decomposed Pythagorean formulation.

### 4.3 Implementation Steps for Test Suite Alignment
1. Update `test/all_animations_test.dart` to assert paused-by-default behavior across all simulation widgets.
2. Update `test/step12_reorganization_and_simulations_test.dart`, `test/math_rendering_and_explorer_test.dart`, and `test/m1_challenger2_simulation_stress_test.dart` to match initial paused icons and tooltips.
3. Add unit tests for `SqueezeTheoremWidget` and asymptote handling in `TrigCircleWidget`.

---

## 5. Verification Method

To independently verify after implementation:
1. **Static Analysis**:
   ```powershell
   flutter analyze
   ```
   Must pass with 0 errors and 0 warnings.
2. **Interactive Simulation Tests**:
   ```powershell
   flutter test test/all_animations_test.dart
   flutter test test/interactive_simulation_test.dart
   flutter test test/math_rendering_and_explorer_test.dart
   flutter test test/m1_challenger2_simulation_stress_test.dart
   ```
3. **Full Suite Regression**:
   ```powershell
   flutter test
   ```
   All tests must pass.
4. **Visual Inspection Criteria**:
   - On opening any simulation, canvas is crisp and completely stationary until the user interacts.
   - In `TrigCircleWidget`, selecting `90° (π/2)` or `270° (3π/2)` renders vertical parallel lines with infinity badges without flickering or runtime exceptions.
   - In `TriangleSolverWidget`, the altitude line and projection $a\cos\gamma$ clearly explain the subtraction term in $c^2 = a^2 + b^2 - 2ab\cos\gamma$.
