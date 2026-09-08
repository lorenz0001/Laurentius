# Project: Laurentius (Brilliant-OS) — Radical UI Simplification & Complete Corollary Proofs Overhaul

## Architecture
- **Framework**: Flutter 3.x / Dart 3.x (iOS-first responsive, BouncingScrollPhysics, 60fps animations).
- **Local Storage**: Isar Database (NoSQL `@collection KnowledgeNode`, `@embedded ProofStep`, `@embedded ContentBlock`).
- **Formula & Math**: `flutter_math_fork` (KaTeX LaTeX rendering), `math_expressions` (runtime evaluation).
- **Design Language**: Brilliant.org style — generous whitespace, rounded geometry (R12-R16), pastel domain accents, zero unnecessary modal layers or debug clutter.
- **Search & Deep-Linking Pipeline**:
  - `SpotlightIndexService`: In-memory predictive trie/inverted index digesting topics, theorems, corollaries, formulas, and definitions with Italian diacritic folding.
  - `SpotlightSearchBarWidget`: Omnipresent top-level search bar with `⌘K` keyboard shortcut badge.
  - `NodeDetailScreen` + `AlgebraicProofWidget`: Deep navigation parameters (`initialProofGroup`, `initialProofStepIndex`, `targetCorollary`, `autoUnlockProof`) with `Scrollable.ensureVisible` for direct $\le 1$-tap jump.

## Feature Inventory
| # | Feature | Description | Milestone | Source |
|---|---------|-------------|-----------|--------|
| 1 | Omnipresent Spotlight Search Bar | Persistent top search bar on main screen with live predictive filtering | M3 | R1 |
| 2 | Predictive Multi-Object Indexing | Sub-millisecond indexing of theorems, formulas, corollaries, definitions, topics | M3 | R1 |
| 3 | Deep $\le 1$-Tap Navigation | Selecting result directly opens topic focused and expanded on theorem/corollary | M3 | R1 |
| 4 | UI Clutter Eradication | Remove debug sync button, eliminate bottom floating banner, flatten nested folders | M3 | R1 |
| 5 | Complete Corollary Proofs (Arithmetic) | Full step-by-step mathematical proofs with algebraic derivations for all 4 arithmetic topics | M1 | R2 |
| 6 | Complete Corollary Proofs (Algebra) | Full step-by-step mathematical proofs with derivations for all 8 algebra topics | M1 | R2 |
| 7 | Complete Corollary Proofs (Calculus) | Full step-by-step mathematical proofs with derivations for all 13 calculus topics | M1 | R2 |
| 8 | Complete Corollary Proofs (Geometry & Trig) | Full step-by-step mathematical proofs with derivations for all 5 geometry/trig topics | M1 | R2 |
| 9 | Complete Corollary Proofs (Physics) | Full step-by-step mathematical proofs with derivations for all 5 physics/circuits topics | M1 | R2 |
| 10 | Enhanced MarkdownContentParser | Support named proof groups and corollary demonstrations without dropping formulas | M2 | R3 |
| 11 | Non-Breaking ProofStep Ext | Computed getters (`isCorollary`, `groupName`, `cleanDescription`, `corollaryTitle`) | M2 | R3 |
| 12 | AlgebraicProofWidget Group Switcher | Tab/chip selector with star badges (`COROLLARIO DEDOTTO`) and initial group selection | M2 | R3 |
| 13 | NodeDetailScreen Deep-Linking | `ScrollController` + `Scrollable.ensureVisible` and targeting parameters | M2 | R3 |
| 14 | Spotlight Search Unit Tests | 12+ tests for indexing, predictive queries, ranking, diacritics in `spotlight_search_test.dart` | M4 | Quality |
| 15 | Widget & Navigation Tests | Tests for omnipresent search bar, live typing, and direct 1-tap navigation | M4 | Quality |
| 16 | Curriculum Proof Rigor Tests | Tests asserting all 35 topics contain full multi-step corollary demonstrations | M4 | Quality |
| 17 | Static Analysis & Full Regression | `flutter analyze` (0 errors, 0 warnings) and 100% passing `flutter test` | M4 | Quality |

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| M1 | Complete Unabridged Proofs for All Corollaries | Audit & expand all 35 Markdown topics in `assets/content/` with step-by-step algebraic demonstrations | none | PLANNED |
| M2 | Proof Engine & SDUI Parser Synchronization | `MarkdownContentParser`, `ProofStep` getters, `AlgebraicProofWidget` switcher & `NodeDetailScreen` deep-link | M1 | PLANNED |
| M3 | Radically Simplified UI & Instant Spotlight Search | `SpotlightIndexService`, `SpotlightSearchBarWidget`, `MainLayoutScreen`, `HomeScreen`, `CategoryExplorerScreen` | M2 | PLANNED |
| M4 | E2E Testing, Quality Verification & Hardening | Dedicated unit & widget tests (`spotlight_search_test.dart`, `spotlight_widget_navigation_test.dart`), `flutter analyze`, `flutter test` | M1, M2, M3 | PLANNED |

## Interface Contracts
### Search Engine ↔ Detail Screen
- `SpotlightSearchResult`:
  - `node`: `KnowledgeNode`
  - `type`: `SpotlightResultType` (`topic`, `theorem`, `corollary`, `formula`, `definition`)
  - `proofGroup`: `String?`
  - `proofStepIndex`: `int?`
  - `targetFocusId`: `String?`
  - `snippet`: `String`
- `NodeDetailScreen` constructor:
  ```dart
  NodeDetailScreen({
    Key? key,
    required KnowledgeNode node,
    Isar? isar,
    String? targetProofGroup,
    int? targetStepIndex,
    String? targetCorollary,
    bool autoUnlockProof = false,
  })
  ```

### AlgebraicProofWidget Contract
- `AlgebraicProofWidget` constructor:
  ```dart
  AlgebraicProofWidget({
    Key? key,
    required List<ProofStep> proofSteps,
    String? initialGroup,
    int? initialStepIndex,
    bool initialShowAll = false,
    String? targetCorollary,
  })
  ```

## Code Layout
- `assets/content/`:
  - `arithmetic/`, `algebra/`, `calculus/`, `geometry_trig/`, `physics/`
- `lib/core/services/`:
  - `spotlight_index_service.dart`
- `lib/domain/models/`:
  - `spotlight_result.dart`
  - `knowledge_node.dart`
- `lib/data/content/`:
  - `markdown_content_parser.dart`
- `lib/presentation/widgets/`:
  - `spotlight_search_bar_widget.dart`
  - `spotlight_result_card.dart`
  - `spotlight_dropdown_overlay.dart`
  - `algebraic_proof_widget.dart`
- `lib/presentation/pages/`:
  - `main_layout_screen.dart`
  - `home_screen.dart`
  - `category_explorer_screen.dart`
  - `node_detail_screen.dart`
- `test/`:
  - `spotlight_search_test.dart`
  - `spotlight_widget_navigation_test.dart`
