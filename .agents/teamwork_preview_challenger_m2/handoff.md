# Milestone 2: Adversarial Challenge & Stress-Test Handoff Report

## 1. Observation

### 1.1 Scope & Direct Observations
Inspected the following files and components:
1. `lib/presentation/widgets/interactive/vector_2d_simulation_widget.dart` (1529 lines):
   - Internal model `_Vec2` (lines 20–44) implements 2D Euclidean vector operations: length `math.sqrt(x * x + y * y)`, angle `math.atan2(y, x)`, angleDeg, dot product `x * o.x + y * o.y`, 2D cross product / determinant `x * o.y - y * o.x`, and `clamp(minVal, maxVal)`.
   - Direct touch dragging & hit testing:
     ```dart
     // Line 172-194:
     const hitRadius = 32.0;
     final d1 = (localPos - p1).distance;
     // Dispatches drag to v1 or v2 with priority to nearest arrowhead
     ```
   - Coordinate transformation & integer snap assist:
     ```dart
     // Lines 204-209:
     final rx = mathPos.x.roundToDouble();
     final ry = mathPos.y.roundToDouble();
     if ((mathPos.x - rx).abs() < 0.15) mathPos = _Vec2(rx, mathPos.y);
     if ((mathPos.y - ry).abs() < 0.15) mathPos = _Vec2(mathPos.x, ry);
     ```
   - Defensive boundary clamping:
     ```dart
     // Line 202:
     mathPos = mathPos.clamp(-5.0, 5.0);
     ```
   - Autoplay suppression:
     ```dart
     // Line 67:
     bool _isAutoAnimating = false; // Strictly paused on mount!
     ```
     Starts auto-rotation ONLY upon explicit tap on `IconButton` (`Icons.play_circle_fill_rounded`), and immediately halts auto-rotation if a pan gesture starts on canvas (`_onPanStart` lines 166–168).
   - Division by zero / null-vector protection:
     ```dart
     // Lines 1409-1412:
     if (dist < 3.0) {
       // Punto nullo
       canvas.drawCircle(from, 3.0, linePaint);
       return;
     }
     ```
     And for degenerate 1D subspace line rendering when $\det = 0$:
     ```dart
     // Lines 1293-1296:
     final refVec = v1.length >= v2.length ? v1 : v2;
     if (refVec.length > 0.05) {
       final dir = _Vec2(refVec.x / refVec.length, refVec.y / refVec.length);
     ...
     ```
   - Collinearity alert and collapsed shaded area:
     When $|\det| < 0.05$, `_paintSpanMode` (lines 1277–1325) suppresses polygon fill and renders a dashed line indicating the 1D subspace. Telemetry displays:
     ```dart
     // Lines 691-693:
     'Attenzione: Vettori Collineari (det = 0). Lo Span degenera in una retta (sottospazio 1D)!'
     ```
   - Responsive layout defenses:
     Slider controls (lines 953–1000) stack label and slider vertically. Telemetry metric cards (lines 711–750) and mode selectors (lines 357–404) utilize `FittedBox(fit: BoxFit.scaleDown)`. Rule chips and presets use `Wrap(runSpacing: 6)`.

2. `lib/presentation/widgets/interactive/interactive_template_factory.dart` (lines 26–37):
   Routes 10 aliases (`vector_2d`, `linear_combination`, `vector_addition`, `span_2d`, `vector_simulation`, `vector_span`, `vector_space`, `vettori_2d`, `somma_vettoriale`, `combinazione_lineare`) directly to `Vector2DSimulationWidget`.

3. `PROJECT_MAP.md` Section 4 (lines 123–140):
   Fully documents `Vector2DSimulationWidget`, parameters, equations, unit support, and features. File length is 205 lines (strictly $\le 300$).

4. `test/challenger_curriculum_stress_test.dart` (lines 64–69):
   Whitelists all vector template aliases in `validTemplates`.

5. `test/vector_2d_simulation_test.dart` (328 lines, 15 tests):
   Covers initial mount, static autoplay suppression, mode switching, basic drag, presets, factory routing, and zero vector.

6. Dedicated Adversarial Test Suite:
   Created `test/vector_2d_simulation_adversarial_test.dart` (440 lines, 14 tests) covering all stress scenarios and edge cases.

---

## 2. Logic Chain

1. **Gestures and Interactive Touch Controls**:
   - *Observation*: `_onPanStart` computes Euclidean pixel distances `(localPos - p1).distance` and compares with `hitRadius = 32.0`.
   - *Reasoning*: A 32.0px hit target provides ample touch tolerance for mobile fingers. `_toMath` reverses the screen Cartesian projection and `mathPos.clamp(-5.0, 5.0)` confines values to $[-5.0, 5.0]$.
   - *Verification in Test Suite*: Test 1.1 simulates dragging $v_1$ through all 4 quadrants ($Q_1 \to Q_2 \to Q_3 \to Q_4 \to Q_1$) and verifies coordinate readouts update accurately without exceptions. Test 1.4 confirms dragging $v_2$ dynamically recalculates resultant $s = v_1 + v_2$. Test 1.2 confirms snap-to-integer assist snaps when $|\Delta| < 0.15$ while preserving decimal fidelity when $|\Delta| \ge 0.15$. Test 1.3 confirms boundary clamping under extreme offset coordinates.

2. **Mathematical Invariants & Edge Cases**:
   - *Observation*: Collinear vectors produce $\det(v_1, v_2) = v_{1x}v_{2y} - v_{1y}v_{2x} = 0$.
   - *Reasoning*: When $|\det| < 0.05$, the 2D span collapses to a 1D subspace. The implementation detects this condition, suppresses drawing the 2D polygon path, displays the red warning banner, and draws the dashed line representing the 1D subspace along `refVec`.
   - *Verification in Test Suite*: Test 2.1 tests parallel vectors ($v_1 = (2, 1), v_2 = (4, 2)$), confirming banner text and area = 0.00. Test 2.2 tests antiparallel vectors ($v_1 = (1, -2), v_2 = (-2, 4)$).
   - *Observation*: For zero vector $(0, 0)$, norm is 0, angle is 0, and unit vector calculation $v / \|v\|$ could divide by zero.
   - *Reasoning*: `_drawArrow` guards with `dist < 3.0`, drawing a static circle dot and returning immediately before calculating unit directions or arrowhead angles. In addition, when both vectors are $(0, 0)$ in Span mode, `refVec.length > 0.05` guards against zero division when computing 1D line directions.
   - *Verification in Test Suite*: Test 2.3 and Test 2.4 verify $(0, 0)$ handling without NaN, Infinity, or unhandled exceptions.
   - *Observation*: Orthogonal vectors have $\mathbf{v}_1 \cdot \mathbf{v}_2 = 0$ and $\det(\mathbf{v}_1, \mathbf{v}_2) \neq 0$.
   - *Reasoning*: For $v_1 = (3, 0)$ and $v_2 = (0, 4)$, $\det = 12.00$, area = $12.00$, and in Addition mode $\|\mathbf{s}\| = \sqrt{3^2 + 4^2} = 5.00$.
   - *Verification in Test Suite*: Test 2.5 confirms both Pythagorean norm in Addition mode and full span area in Span mode.
   - *Observation*: Negative scalar multipliers $c_1, c_2 \in [-3.0, 3.0]$.
   - *Reasoning*: Multiplying by negative scalars inverts the vector direction ($pw_i = \text{center} + c_i \mathbf{v}_i \cdot \text{scale}$).
   - *Verification in Test Suite*: Test 2.6 verifies direction inversion of components, telemetry of resultant $w$, and preset chip toggles.

3. **Layout Resilience on Compact Viewports**:
   - *Observation*: Compact mobile screens (360x640, 400x800) often suffer from horizontal `RenderFlex` overflow when row items or telemetry strings exceed available width.
   - *Reasoning*: The implementation encapsulates telemetry values and tab labels in `FittedBox(fit: BoxFit.scaleDown)`, sets slider rows as vertical `Column`s with full-width sliders, wraps chip selectors with `Wrap(runSpacing: 6)`, and sizes canvas height to 280 with responsive width via `LayoutBuilder`.
   - *Verification in Test Suite*: Test 3.1 and Test 3.2 run the full widget tree on 360x640 and 400x800 across all 3 modes, confirming zero `RenderFlex` overflows and null `tester.takeException()`.

4. **Stress & Robustness Fuzzing**:
   - *Verification in Test Suite*: Test 4.1 verifies extreme numeric inputs ($10^6, -10^6, 99999$) are bounded defensively. Test 4.2 tests rapid mode toggling across animation frames. Test 4.3 verifies gesture start cleanly halts auto-rotation.

---

## 3. Caveats

No caveats. All requirements, gestures, mathematical invariants, edge cases, responsive viewports, and code layout guidelines have been thoroughly verified and tested.

---

## 4. Conclusion

Verdict: **APPROVE**

`Vector2DSimulationWidget` fulfills all Milestone 2 requirements with high mathematical rigor, defensive edge case protections, fluid gesture interactivity, strict autoplay suppression, and zero layout overflow on compact viewports.

---

## 5. Verification Method

To independently verify the implementation and test suites:

1. **Vector 2D Adversarial Test Suite**:
   ```bash
   flutter test test/vector_2d_simulation_adversarial_test.dart
   ```
   *Expected result*: All 14 adversarial/stress tests pass with exit code 0.

2. **Vector 2D Unit & Interaction Test Suite**:
   ```bash
   flutter test test/vector_2d_simulation_test.dart
   ```
   *Expected result*: All 15 tests pass.

3. **E2E Test Suite**:
   ```bash
   flutter test test/e2e_linear_algebra_and_simulations_test.dart
   ```
   *Expected result*: All 91 tests pass.

4. **Static Analysis**:
   ```bash
   flutter analyze lib/
   ```
   *Expected result*: No issues found!
