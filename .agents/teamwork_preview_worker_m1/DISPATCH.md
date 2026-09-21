## 2026-09-14T10:04:34Z
You are teamwork_preview_worker_m1.
Your working directory is: c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_worker_m1
The project workspace root is: c:\Users\catte\Desktop\Laurentius
Mandatory input: You MUST read the original user request at c:\Users\catte\Desktop\Laurentius\.agents\ORIGINAL_REQUEST.md before starting work (specifically the latest request dated 2026-09-14T09:56:11Z). Also read c:\Users\catte\Desktop\Laurentius\PROJECT.md, the survey report at c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_explorer_survey_1\survey_interactive_report.md, and handoff at c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_explorer_survey_1\handoff.md.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_preview_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Objective (Milestone 1: Interactive Simulations Audit & Optimization - R1):
1. Fix performance hotspot in `lib/presentation/widgets/interactive/cartesian_graph_widget.dart`:
   - Currently, `_evaluateY` re-parses the equation string with `_parser.parse(_equationString)` inside the pixel sampling loop (240+ times per paint!).
   - Refactor `CartesianGraphWidget` so that `_parsedExpression = _parser.parse(_equationString)` is compiled ONCE when the equation or parameters change (in `initState`, `didUpdateWidget`, or helper), and `_evaluateY` evaluates the cached expression using `RealEvaluator` with `ContextModel`.
   - Ensure error handling gracefully catches any invalid expression and falls back safely without crashing or dropping frames.
2. Fix formula display and vertex marker in `cartesian_graph_widget.dart`:
   - Inspect lines 145-155 and 470-480.
   - If the equation is not a standard quadratic polynomial (or contains cubic/log/exp terms), display the genuine equation rather than the misleading hardcoded `y = ax^2 + bx + c`.
   - Only render the parabola vertex marker $V(-b/(2a), ...)$ when the equation is actually a quadratic curve; hide the vertex marker for non-quadratic curves.
3. Rebind physics topics in `assets/content/physics/`:
   - `ele_power_01.md`: change `template: live_equation` to `template: circuit_simulation` with appropriate voltage $V$ and resistance $R$ parameters (since power $P = V \cdot I$ is directly simulated in the circuit widget with thermal glow).
   - `ele_joule_01.md`: change `template: live_equation` to `template: circuit_simulation` with appropriate parameters.
4. Run verification:
   - Run `flutter analyze` to ensure 0 errors and 0 warnings.
   - Run `flutter test test/interactive_simulation_test.dart` and `flutter test test/simulations_autoplay_and_geometry_stress_test.dart`.
   - Run full `flutter test` to ensure zero regressions across all 251+ tests.

Scope Boundaries:
- You exclusively own: `lib/presentation/widgets/interactive/cartesian_graph_widget.dart`, `assets/content/physics/ele_power_01.md`, and `assets/content/physics/ele_joule_01.md`.
- Deliver your report in `c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_worker_m1\handoff.md` with full command outputs, and notify parent upon completion.
