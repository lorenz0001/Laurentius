# Forensic Integrity Audit Plan

## Target Scope
All modified and newly created files in Laurentius (Brilliant-OS) for UI simplification, Spotlight search, proof engine enhancements, and corollary proof expansions.

## Execution Steps

### 1. Static Analysis & Diagnostics
- Execute `flutter analyze` from project root (`c:\Users\catte\Desktop\Laurentius`).
- Verify exit code 0, 0 errors, 0 warnings, 0 infos/lint bypasses.

### 2. Full Test Suite Verification
- Execute `flutter test` across entire project.
- Verify test counts, ensure 100% pass rate.
- Check for any skipped tests, suppressed failures, or empty assertion blocks.

### 3. Git Diff & Scope Identification
- Inspect `git status` and `git diff` to identify all changed files in this iteration.

### 4. Implementation Authenticity Audit
- **SpotlightIndexService**:
  - Verify genuine inverted indexing / tokenization algorithm.
  - Check diacritic folding (e.g., Italian accents à, è, é, ì, ò, ù).
  - Verify relevance scoring / type weighting (theorems, corollaries, formulas, definitions, topics).
  - Confirm NO hardcoded search query dispatch tables or mock return values.
- **SpotlightSearchBarWidget & NodeDetailScreen**:
  - Verify genuine direct 1-tap navigation implementation.
  - Verify deep-link parameters (`targetProofGroup`, `targetStepIndex`, `targetCorollary`, `autoUnlockProof`).
  - Verify genuine `ScrollController` / `Scrollable.ensureVisible` implementation.
- **UI Clutter Eradication**:
  - Audit `MainLayoutScreen`, `HomeScreen`, `CategoryExplorerScreen`.
  - Confirm removal of redundant sync buttons, bottom floating banners, hero card distractions, and folder accordions.
- **AlgebraicProofWidget & MarkdownContentParser**:
  - Verify proof group switching, corollary deduction badges (`COROLLARIO DEDOTTO`).
  - Verify parser extracts proof steps, groups, and corollaries without dropping LaTeX formulas.

### 5. Curriculum Mathematical Rigor Forensics
- Audit all 35 Markdown curriculum files in `assets/content/`:
  - `arithmetic/` (4 files)
  - `algebra/` (8 files)
  - `calculus/` (13 files)
  - `geometry_trig/` (5 files)
  - `physics/` (5 files)
- For every file:
  - Verify presence of `### Corollario:` or corollary sections.
  - Verify presence of comprehensive `#### Dimostrazione del Corollario` / step-by-step mathematical proof.
  - Verify genuine intermediate algebraic manipulations, substitutions, and LaTeX expressions (not cosmetic placeholders or raw formula dumps).

### 6. Test Integrity & Facade Detection
- Inspect test files (`test/spotlight_search_test.dart`, `test/spotlight_widget_navigation_test.dart`, etc.) to confirm tests genuinely test the production classes and do not test trivial mocks or self-certifying assertions.

### 7. Final Assessment & Verdict
- Determine verdict: CLEAN or INTEGRITY VIOLATION.
- Produce `handoff.md` with complete evidence.
