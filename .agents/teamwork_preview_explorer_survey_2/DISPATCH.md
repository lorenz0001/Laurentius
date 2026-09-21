## 2026-09-14T09:58:49Z

Conduct a thorough investigation of the curriculum content system and design the Linear Algebra foundational module (R2 & R4):
1. Inspect existing markdown files in `assets/content/` (`arithmetic/`, `algebra/`, `geometry_trig/`, `calculus/`, `physics/`).
2. Inspect `pubspec.yaml` to see how assets are declared.
3. Analyze the prerequisite DAG in the existing curriculum and inspect how `test/curriculum_dag_test.dart` checks for cycles and prerequisite resolution.
4. Design the 5 sequential linear algebra nodes in `assets/content/linear_algebra/` (or designated path):
   - Node 1: Concetto di n-upla ordinata e spazio R^n (from pairs/triplets to R^n, algebraic & geometric meaning).
   - Node 2: Vettori Geometrici e Coordinate (applied vector, magnitude/norm, direction, orientation, component representation wrt canonical basis).
   - Node 3: Operazioni Vettoriali Fondamentali (vector addition via parallelogram rule & tip-to-tail, scalar multiplication, axiomatic vector space properties).
   - Node 4: Combinazioni Lineari e Spazio Generato (span) (definition, geometric interpretation of line, plane, hyperplane span).
   - Node 5: Dipendenza e Indipendenza Lineare (formal definition, non-trivial zero linear combination, geometric meaning of collinear/coplanar vectors).
5. For each node, detail:
   - Proposed ID (e.g. `lin_alg_01_tuples`, `lin_alg_02_vectors`, etc.)
   - Category and subCategory
   - Prerequisite chain connecting to foundational algebra/geometry nodes without cycles
   - Structure of mathematical content, LaTeX equations (`$...$`, `$$...$$`), step-by-step derivations without logical leaps, `> **Insight:**` intuition boxes, theorems, and corollaries with full proofs
   - Proposed `interactive` configuration binding to the 2D vector widget or other relevant templates
6. Produce a concrete specification and step-by-step authoring plan for Milestone 3.

Scope Boundaries:
- You are a read-only exploration agent. Do NOT modify source code or tests.
- Deliver your detailed report and handoff in: `c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_explorer_survey_2\survey_curriculum_report.md` and `handoff.md`.
- Send a completion message back to parent when done.
