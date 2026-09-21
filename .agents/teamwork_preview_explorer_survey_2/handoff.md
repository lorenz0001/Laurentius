# Handoff Report: Curriculum Survey & Linear Algebra Foundational Module Specification

**From:** `teamwork_preview_explorer_survey_2`  
**To:** `teamwork_preview_orchestrator_4` / Downstream Implementers (Milestone 3 & Milestone 4)  
**Date:** 2026-09-14T10:02:00Z  
**Type:** Hard Handoff (Investigation & Specification Complete)

---

## 1. Observation

### 1.1 Existing Curriculum Assets and Paths
- Grep and directory listing across `assets/content/` revealed exactly 35 `.md` files in 5 categories:
  - `arithmetic/`: 4 topics (`mat_add_01`, `mat_mul_01`, `mat_frac_01`, `mat_pow_01`)
  - `algebra/`: 8 topics (`mat_binom_01`, `mat_quad_monomia_01`, `mat_quad_pura_01`, `mat_quad_spuria_01`, `mat_quad_eq_01`, `mat_quad_viete_01`, `mat_parabola_01`, `mat_log_01`)
  - `geometry_trig/`: 5 topics (`mat_triang_01`, `mat_pythagoras_01`, `mat_trig_circ_01`, `mat_trig_add_01`, `mat_trig_triang_01`)
  - `calculus/`: 13 topics (`mat_limits_01`, `mat_lim_sinc_01`, `mat_lim_cos_01`, `mat_lim_e_01`, `mat_lim_exp_01`, `mat_lim_log_01`, `mat_deriv_def_01`, `mat_deriv_rules_01`, `mat_deriv_theorems_01`, `mat_riemann_01`, `mat_fund_calc_01`, `mat_integ_parts_01`, `mat_integ_subst_01`)
  - `physics/`: 5 topics (`phys_kin_01`, `ele_ohm_01`, `ele_power_01`, `ele_joule_01`, `chem_ph_01`)
- In `pubspec.yaml` lines 74-86: All 13 asset folders are individually registered under `flutter: assets:`. No directory for linear algebra (`assets/content/linear_algebra/`) currently exists.
- In `lib/data/content/content_loader_service.dart` lines 20-56: `ContentLoaderService.knownAssetPaths` explicitly enumerates all 35 file paths as a fallback for headless test environments.
- In `lib/data/catalog/curriculum_registry.dart` lines 86-135: `_defaultPrerequisiteMap` statically defines the exact dependency graph for all 35 nodes.

### 1.2 DAG Rigidity & Test Invariants
- In `test/challenger_curriculum_stress_test.dart` lines 166-169:
  ```dart
  final rootNodes = nodeIds.where((id) => inDegree[id] == 0).toList();
  expect(rootNodes, equals(['mat_add_01']),
      reason: 'mat_add_01 must be the unique ultimate foundational root of the entire curriculum');
  ```
  `mat_add_01` is strictly asserted to be the *sole* node in the curriculum with `inDegree == 0`.
- In `test/challenger_curriculum_stress_test.dart` lines 121-142: Test 3 asserts strict parity between prerequisites declared in markdown YAML frontmatter and `CurriculumRegistry._defaultPrerequisiteMap`.
- In `test/curriculum_dag_test.dart` lines 149-167:
  ```dart
  final hasCorollary = node.algebraicProof.any(
    (step) =>
        (step.description?.toLowerCase().contains('corollario') ??
            false) ||
        (step.insight?.toLowerCase().contains('corollario') ?? false),
  );
  expect(hasCorollary, true, reason: 'Nodo ... non ha corollari esplicitamente enunciati.');
  ```
- In `test/challenger_curriculum_stress_test.dart` lines 40-64: `validTemplates` maintains an explicit whitelist of template key strings.
- In `test/markdown_content_loader_test.dart` lines 559, 710, 823, 862: Hardcoded assertions expect `allNodes.length == 35`.

---

## 2. Logic Chain

1. **Root Node Integrity**:
   - Observation 1.2 shows that `mat_add_01` must be the unique node with `inDegree == 0`.
   - Therefore, the initial linear algebra node `lin_alg_01_tuples` cannot have empty prerequisites (`prerequisites: []`).
   - By assigning `prerequisites: ['mat_add_01', 'mat_pythagoras_01']`, `lin_alg_01_tuples` receives `inDegree == 2`, rooting it directly in arithmetic structure and Euclidean Cartesian geometry while preserving `mat_add_01` as the unique ultimate root.

2. **Topological Order & Acyclicity**:
   - The 5 linear algebra nodes form a strictly sequential progression:
     `lin_alg_01_tuples` $\to$ `lin_alg_02_vectors` $\to$ `lin_alg_03_operations` $\to$ `lin_alg_04_span` $\to$ `lin_alg_05_independence`.
   - Each node depends solely on the immediately preceding node (or foundational nodes).
   - Because all edges advance strictly from lower to higher topological depth (depths 4 through 8), no back-edges or self-loops exist. Kahn's topological sort and Tarjan's SCC tests will succeed with 100% acyclicity.

3. **Content Loader & Headless Tests Alignment**:
   - Observation 1.1 reveals that `ContentLoaderService` relies on `knownAssetPaths` in test environments.
   - When the 5 Markdown files are created in `assets/content/linear_algebra/`, they must also be declared in `knownAssetPaths` and `pubspec.yaml`.
   - Concurrently, `CurriculumRegistry._defaultPrerequisiteMap` must be updated with the exact matching prerequisite IDs to satisfy the strict parity test.

4. **Corollary & Proof Step Rigor**:
   - Observation 1.2 confirms that every knowledge node must contain at least one corollary step.
   - The specification designs 2 complete corollaries with full algebraic derivations (no logical leaps) and `> **Insight:**` callouts for each of the 5 nodes, satisfying `curriculum_dag_test.dart` and `challenger_curriculum_stress_test.dart`.

5. **Template Factory Linking**:
   - The 5 linear algebra nodes declare `template: vector_2d` with parameters tailored to their conceptual domain (point coordinates, vector components, vector addition and scaling, linear combination coefficients, and determinant evaluation).
   - Milestone 2's implementation of `Vector2DSimulationWidget` and registration of `vector_2d` (and related aliases) in `validTemplates` and `InteractiveTemplateFactory` will complete the declarative SDUI binding.

---

## 3. Caveats

1. **Test Assertion Updates in Milestone 4**:
   - Existing tests (`markdown_content_loader_test.dart` and `challenger_curriculum_stress_test.dart`) check for exactly 35 nodes.
   - When the 5 new linear algebra topics are added, these assertions will naturally need to be updated from 35 to 40. This is an expected consequence of curriculum expansion, not a regression.
2. **Interactive Simulation Timing**:
   - Milestone 2 (2D Vector Simulation Widget) must precede or run concurrently with Milestone 3 (Content Authoring) so that the `vector_2d` template key is registered in `InteractiveTemplateFactory` and `validTemplates` when tests are executed.
3. **No Code Written**:
   - As an explorer agent, no production code, tests, or curriculum markdown files were modified. All specifications are delivered via structured reports in `.agents/teamwork_preview_explorer_survey_2/`.

---

## 4. Conclusion

The curriculum content architecture is well-structured, modular, and protected by rigorous topological tests. The 5-node Linear Algebra foundational module:
1. `lin_alg_01_tuples`
2. `lin_alg_02_vectors`
3. `lin_alg_03_operations`
4. `lin_alg_04_span`
5. `lin_alg_05_independence`

is fully designed and specified down to exact equations, proofs, corollaries, and parameters. It integrates seamlessly into the existing DAG without cycles and maintains `mat_add_01` as the unique root node.

The complete architectural report is persisted in:  
`c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_explorer_survey_2\survey_curriculum_report.md`

---

## 5. Verification Method

To verify the findings and specifications independently:

1. **Verify Asset Registration**:
   Inspect `pubspec.yaml` lines 74-86 to verify current asset declarations:
   ```powershell
   Select-String -Path pubspec.yaml -Pattern "assets/content"
   ```

2. **Verify DAG Test Logic & Root Invariant**:
   Inspect `test/challenger_curriculum_stress_test.dart` around line 167 to confirm the root node condition:
   ```powershell
   Select-String -Path test/challenger_curriculum_stress_test.dart -Pattern "unique ultimate foundational root" -Context 3
   ```

3. **Verify Prerequisite Map**:
   Inspect `lib/data/catalog/curriculum_registry.dart` lines 86-135 to verify `_defaultPrerequisiteMap`:
   ```powershell
   Select-String -Path lib/data/catalog/curriculum_registry.dart -Pattern "_defaultPrerequisiteMap" -Context 10
   ```

4. **Verify Current Build & Test Health**:
   ```powershell
   flutter test test/curriculum_dag_test.dart
   flutter test test/challenger_curriculum_stress_test.dart
   ```
