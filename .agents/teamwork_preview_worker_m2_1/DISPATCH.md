## 2026-09-07T12:37:00Z

You are the Implementer Worker for Milestone 2 (M2: R3 & R5 Decoupled Markdown Content & Declarative Linking).
Your identity: teamwork_preview_worker_m2_1
Your working directory: c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_worker_m2_1
Workspace root: c:\Users\catte\Desktop\Laurentius

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_preview_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

MANDATORY: Read c:\Users\catte\Desktop\Laurentius\.agents\ORIGINAL_REQUEST.md before starting.
Also read:
- c:\Users\catte\Desktop\Laurentius\PROJECT.md
- c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_explorer_survey_2\handoff.md (contains the complete 24 topics inventory, schema, and parser algorithms)
- c:\Users\catte\Desktop\Laurentius\.agents\skills\server-content-agent\SKILL.md (specifications for topics, steps, corollaries, and simulations)
- c:\Users\catte\Desktop\Laurentius\TEST_READY.md

Your exclusive write ownership:
- `assets/content/` (all subdirectories and `.md` files)
- `pubspec.yaml` (registering asset paths under `flutter: assets:`)
- `lib/data/content/markdown_content_parser.dart`
- `lib/data/content/content_loader_service.dart`
- `lib/data/catalog/curriculum_registry.dart` (cache hook)
- `test/markdown_content_loader_test.dart` (if needed)

Detailed Tasks:
1. Create human-editable `.md` files under `assets/content/` for all 24 topics:
   - `assets/content/arithmetic/` (4 files: `mat_add_01.md`, `mat_mul_01.md`, `mat_frac_01.md`, `mat_pow_01.md`)
   - `assets/content/algebra/` (4 files: `mat_binom_01.md`, `mat_quad_eq_01.md`, `mat_parabola_01.md`, `mat_log_01.md`)
   - `assets/content/geometry_trig/` (5 files: `mat_triang_01.md`, `mat_pythagoras_01.md`, `mat_trig_circ_01.md`, `mat_trig_add_01.md`, `mat_trig_triang_01.md`)
   - `assets/content/calculus/` (6 files: `mat_limits_01.md`, `mat_deriv_def_01.md`, `mat_deriv_rules_01.md`, `mat_deriv_theorems_01.md`, `mat_riemann_01.md`, `mat_fund_calc_01.md`)
   - `assets/content/physics/` (5 files: `phys_kin_01.md`, `ele_ohm_01.md`, `ele_power_01.md`, `ele_joule_01.md`, `chem_ph_01.md`)
   Each file MUST have:
   - Complete YAML frontmatter delimited by `---`: `id`, `title`, `category`, `subCategory`, `prerequisites`, and optional `interactive:` (`template`, `unit`, `equations`, `parameters`).
   - Pure Markdown educational narrative with LaTeX math ($...$ and $$...$$) and `> **Insight:** ...` callouts.
   - Structured `## Dimostrazione` section with step headers (`### 1. ...`, `### 2. ...`) and explicit `### Corollario: [Nome]` headers so corollary detection tests pass.
2. Register the asset directories in `pubspec.yaml` under `flutter: assets:`:
   - `assets/content/arithmetic/`
   - `assets/content/algebra/`
   - `assets/content/geometry_trig/`
   - `assets/content/calculus/`
   - `assets/content/physics/`
3. Implement `MarkdownContentParser` in `lib/data/content/markdown_content_parser.dart`:
   - Pure Dart, zero external dependencies.
   - Correctly parses frontmatter into `KnowledgeNode`, `InteractiveData` (including `unit`), `InteractiveParameter` (including `unit`).
   - Correctly parses body blocks (`text_markdown`, `math_latex`, `info_box`) and proof steps (`ProofStep` with description, equation, insight, corollary).
4. Implement `ContentLoaderService` in `lib/data/content/content_loader_service.dart`:
   - `loadAllFromBundle({AssetBundle? bundle})`: discovers and loads all `.md` articles via `AssetManifest` / `rootBundle`.
   - `syncToIsar(Isar isar, List<KnowledgeNode> nodes)`: 2-phase upsert into Isar.
   - Provide an in-memory cache mechanism accessible to `CurriculumRegistry`.
5. Ensure declarative widget linking: frontmatter `interactive:` specification works seamlessly with `InteractiveTemplateFactory.buildWidget(node.interactiveData)` without modifying widget source code.
6. Verify:
   - `flutter analyze` must exit with 0 errors and 0 warnings.
   - `flutter test` must pass 100% across all test suites.
7. Write your handoff report to `c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_worker_m2_1\handoff.md`.
Send message to parent when completed.
