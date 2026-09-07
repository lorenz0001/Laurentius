## 2026-09-07T13:01:39Z
You are the Implementer Worker for Milestone 4 (M4: R2 Agent-Optimized Project Map).
Your identity: teamwork_preview_worker_m4_1
Your working directory: c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_worker_m4_1
Workspace root: c:\Users\catte\Desktop\Laurentius

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_preview_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

MANDATORY: Read c:\Users\catte\Desktop\Laurentius\.agents\ORIGINAL_REQUEST.md before starting.
Also read:
- c:\Users\catte\Desktop\Laurentius\PROJECT.md
- c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_explorer_survey_3\handoff.md (Section 2.5 contains the detailed 6-section blueprint and line budget)

Your exclusive write ownership:
- `c:\Users\catte\Desktop\Laurentius\PROJECT_MAP.md` (at repository root)

Detailed Tasks:
1. Create `PROJECT_MAP.md` at repository root strictly under 300 lines (target ~220-250 lines).
2. Structure it across the 6 essential sections:
   - Section 1: Overview & Tech Stack (offline-first STEM knowledge graph, Brilliant-style UI/UX, Flutter/Dart, Isar, flutter_math_fork, math_expressions).
   - Section 2: Annotated Directory Structure of every primary directory and file under `lib/` (`core/`, `data/`, `domain/`, `presentation/`).
   - Section 3: Catalog & Content Pathways: decoupled Markdown files in `assets/content/**/*.md`, YAML frontmatter schema, `ContentLoaderService`, `MarkdownContentParser`, Isar sync, and caching.
   - Section 4: Interactive Simulation Widget Catalog: complete table of all 9 simulation widgets in `lib/presentation/widgets/interactive/`, all 17 template key aliases, parameters, equations, and unit support.
   - Section 5: State & Data Flow: application startup -> asset discovery -> parsing -> Isar persistence -> UI graph/detail screens -> `InteractiveTemplateFactory` -> 60fps reactive CustomPainters.
   - Section 6: Step-by-Step Developer Guide for Adding New Topics:
     * Step 1: Create `.md` in `assets/content/<category>/` with YAML frontmatter and LaTeX proof.
     * Step 2: Set `interactive.template` key and parameter bindings (or `null` for pure algebra).
     * Step 3: Run `flutter test` to verify automatic ingestion and DAG validation.
3. Verify:
   - File line count: MUST BE STRICTLY UNDER 300 LINES (count exact lines).
   - Run `flutter analyze` and `flutter test`.

Deliverable:
Write report to `c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_worker_m4_1\handoff.md`.
Send message to parent when complete.
