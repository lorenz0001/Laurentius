## 2026-09-14T10:44:30Z

You are teamwork_preview_worker_m3.
Your working directory is: c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_worker_m3
The project workspace root is: c:\Users\catte\Desktop\Laurentius
Mandatory input: You MUST read the original user request at c:\Users\catte\Desktop\Laurentius\.agents\ORIGINAL_REQUEST.md before starting work (specifically the latest request dated 2026-09-14T09:56:11Z). Also read c:\Users\catte\Desktop\Laurentius\PROJECT.md, c:\Users\catte\Desktop\Laurentius\.agents\skills\server-content-agent\SKILL.md, and the detailed curriculum specifications at c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_explorer_survey_2\survey_curriculum_report.md.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_preview_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Objective (Milestone 3: Linear Algebra Curriculum & Registration - R2, R4):
1. Create directory `assets/content/linear_algebra/` and author the 5 sequential educational nodes with highest mathematical rigor and Brilliant-style pedagogical insights:
   - `assets/content/linear_algebra/lin_alg_01_tuples.md`:
     id: `lin_alg_01_tuples`, title: "Spazio Vettoriale Rn e Concetto di n-upla Ordinata"
     prerequisites: `['mat_add_01', 'mat_pythagoras_01']` (CRITICAL: preserves `mat_add_01` as the sole foundational root with inDegree == 0!)
     template: `vector_2d`
     Includes: rigorous definition of Cartesian product, ordered n-tuples, Euclidean metric, component-wise addition and scalar multiplication, `> **Insight:**` callouts, and 2 corollaries with full step-by-step proofs:
     - `### Corollario: Norma Euclidea e Disuguaglianza di Cauchy-Schwarz`
     - `### Corollario: Unicità dell'Elemento Neutro e Inverso Additivo`
   - `assets/content/linear_algebra/lin_alg_02_vectors.md`:
     id: `lin_alg_02_vectors`, title: "Vettori Geometrici, Norma e Coordinate Canoniche"
     prerequisites: `['lin_alg_01_tuples']`
     template: `vector_2d`
     Includes: directed line segments, free vectors as equivalence classes, norm/magnitude, canonical basis e1=(1,0), e2=(0,1), component decomposition, `> **Insight:**` callouts, and 2 corollaries with full proofs:
     - `### Corollario: Normalizzazione e Versore di un Vettore`
     - `### Corollario: Invarianza della Norma per Traslazione Euclidea`
   - `assets/content/linear_algebra/lin_alg_03_operations.md`:
     id: `lin_alg_03_operations`, title: "Operazioni Vettoriali Fondamentali e Assiomi di Spazio Vettoriale"
     prerequisites: `['lin_alg_02_vectors']`
     template: `vector_addition`
     Includes: vector addition via parallelogram and tip-to-tail rules, scalar multiplication, 8 vector space axioms over R, `> **Insight:**` callouts, and 2 corollaries with full proofs:
     - `### Corollario: Annullamento del Prodotto Scalare-Vettore (0 v = 0)`
     - `### Corollario: Opposto Vettoriale e Moltiplicazione per -1`
   - `assets/content/linear_algebra/lin_alg_04_span.md`:
     id: `lin_alg_04_span`, title: "Combinazioni Lineari e Spazio Vettoriale Generato (Span)"
     prerequisites: `['lin_alg_03_operations']`
     template: `linear_combination`
     Includes: linear combinations, definition of Span, proof that Span is a vector subspace, geometric interpretation (line, plane, hyperplane), `> **Insight:**` callouts, and 2 corollaries with full proofs:
     - `### Corollario: Minimalità del Sottospazio Generato (Intersezione di Sottospazi)`
     - `### Corollario: Collasso Dimensionale per Vettori Paralleli`
   - `assets/content/linear_algebra/lin_alg_05_independence.md`:
     id: `lin_alg_05_independence`, title: "Dipendenza e Indipendenza Lineare dei Vettori"
     prerequisites: `['lin_alg_04_span']`
     template: `span_2d`
     Includes: formal definition of linear independence, linear dependence criterion, geometric meaning (collinearity in R^2, coplanarity in R^3), 2D determinant condition det(u, v) != 0 and connection to signed parallelogram area, `> **Insight:**` callouts, and 2 corollaries with full proofs:
     - `### Corollario: Criterio di Dipendenza Lineare del Vettore Nullo`
     - `### Corollario: Determinante 2D e Indipendenza di Due Vettori nel Piano`

2. Asset and Offline Pipeline Registration:
   - In `pubspec.yaml`: add `- assets/content/linear_algebra/` under `flutter: assets:`.
   - In `lib/data/content/content_loader_service.dart`: add the 5 paths to `knownAssetPaths` (lines 20-56).
   - In `lib/data/catalog/curriculum_registry.dart`: add the 5 prerequisite mappings to `_defaultPrerequisiteMap` (exact parity!).
   - In `lib/data/catalog/linear_algebra_catalog.dart` (or `algebra_catalog.dart`): create fallback catalog definitions for the 5 nodes so `CurriculumRegistry` has complete fallback nodes if needed.

3. Verification:
   - Run `flutter analyze lib/` -> 0 errors, 0 warnings.
   - Run `flutter test test/markdown_content_loader_test.dart`.
   - Run `flutter test test/curriculum_dag_test.dart`.
   - Run `flutter test test/e2e_linear_algebra_and_simulations_test.dart`.
   - Deliver your handoff report in `c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_worker_m3\handoff.md` and notify parent.
