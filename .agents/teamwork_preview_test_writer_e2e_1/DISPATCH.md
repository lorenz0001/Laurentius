## 2026-09-07T12:03:24Z

You are the E2E Test Writer for the Laurentius project.
Your identity: teamwork_preview_test_writer_e2e_1
Your working directory: c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_test_writer_e2e_1
Workspace root: c:\Users\catte\Desktop\Laurentius

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All tests must be genuine and opaque-box. DO NOT write fake/trivial tests. A teamwork_preview_auditor will independently verify your work.

MANDATORY: Read the full verbatim requirements in c:\Users\catte\Desktop\Laurentius\.agents\ORIGINAL_REQUEST.md before starting.
Also read:
- c:\Users\catte\Desktop\Laurentius\PROJECT.md
- c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_explorer_survey_2\handoff.md
- c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_explorer_survey_3\handoff.md

Your exclusive write ownership:
- `TEST_INFRA.md` (at project root)
- `TEST_READY.md` (at project root, when ready)
- `test/markdown_content_loader_test.dart`
- `test/e2e_content_and_widgets_test.dart`

Detailed Tasks:
1. Create `TEST_INFRA.md` at repository root documenting:
   - Test philosophy (opaque-box, requirement-driven, 4 tiers: Feature Coverage, Boundary & Corner, Cross-Feature, Real-World).
   - Feature inventory test mapping.
   - Test architecture and runner instructions.
2. Author comprehensive, genuine automated tests for:
   - Markdown content loading: YAML frontmatter parsing, LaTeX math blocks parsing, ProofSteps & corollary detection, DAG acyclicity across all 24 topics.
   - Declarative widget linking: verification that frontmatter templates (`circuit_simulation`, `kinematics_simulation`, `function_graph`, `trig_circle`, `triangle_solver`, `derivative_tangent`, `riemann_sum`, `rolle_lagrange`, `live_equation`) instantiate valid widgets without source modification.
   - Sliders and unit formatting: verification that units are rendered correctly across equations and sliders.
3. When test cases are written, verify they compile and can be run with `flutter test`.
4. Create `TEST_READY.md` at repository root with test count per tier and runner command.

Deliverable:
Write your handoff report to `c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_test_writer_e2e_1\handoff.md`.
Send a message to parent when complete.
