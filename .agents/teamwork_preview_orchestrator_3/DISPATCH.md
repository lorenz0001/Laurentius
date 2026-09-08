## 2026-09-07T23:39:46Z

You are the Project Orchestrator for Laurentius (Brilliant-OS).

Your working directory is:
`c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_orchestrator_3`

Read the original user request from:
`c:\Users\catte\Desktop\Laurentius\.agents\ORIGINAL_REQUEST.md` (latest section ## 2026-09-07T23:39:08Z).

Read and adhere to the project skills:
- `c:\Users\catte\Desktop\Laurentius\.agents\skills\laurentius-dev\SKILL.md`
- `c:\Users\catte\Desktop\Laurentius\.agents\skills\server-content-agent\SKILL.md`
Also review `PROJECT_MAP.md` at project root for repository architecture.

Your mission:
1. R1: Radically Simplified UI & Instant Spotlight Search:
   - Provide an omnipresent, top-level Instant Spotlight Search bar on the main screen with live predictive indexing of theorems, formulas, corollaries, and definitions.
   - Searching any keyword immediately displays matching proof/corollary cards.
   - Selecting a search result jumps directly to that topic focused on that exact theorem or corollary in <= 1 tap.
   - Eliminate redundant buttons and cluttered nested layers.
2. R2: Complete, Unabridged Proofs for All Corollaries:
   - Audit all 35+ curriculum topics across `arithmetic`, `algebra`, `calculus`, `geometry_trig`, and `physics`.
   - Ensure every single corollary contains a comprehensive, step-by-step mathematical proof (`#### Dimostrazione del Corollario` / `### Dimostrazione`), fully written out with all intermediate algebraic derivations and substitutions, never just stating the final result.
3. R3: Interactive Proof Switcher & Quick Navigation Synchronization:
   - Update `AlgebraicProofWidget`, `MarkdownContentParser`, and SDUI parser so all corollaries with proofs are properly indexed, selectable in proof switches, and linkable from the search index offline-first.
4. Quality and Verification:
   - Ensure `flutter analyze` passes with 0 errors and 0 warnings.
   - Add/update dedicated widget and unit tests for Spotlight search, 1-tap navigation, and corollary proof presence.
   - Ensure all tests pass (`flutter test`).

Decompose the work into milestones, dispatch tasks to specialist subagents (e.g. explorer, worker, reviewer, challenger), continuously update `progress.md`, and when all acceptance criteria are met, send your completion report and claim victory to the Sentinel.
