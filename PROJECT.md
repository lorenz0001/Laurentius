# Project: Laurentius Refactoring & Decoupled Content Architecture

## Architecture
Offline-first Flutter application (Brilliant-style interactive STEM knowledge tree) using:
- **Presentation**: `lib/presentation/` (Screens, Widgets, Canvas CustomPainters, Interactive Widgets).
- **Domain**: `lib/domain/models/` (`KnowledgeNode`, `ContentBlock`, `ProofStep`, `InteractiveData`, `InteractiveParameter`).
- **Data & Services**: `lib/data/` & `lib/core/services/` (Isar Database, `ContentLoaderService`, `MarkdownContentParser`, `AITutorService`, `AppSettingsService`).
- **Content Assets**: `assets/content/**/*.md` (Decoupled human-editable Markdown with YAML frontmatter + LaTeX math).
- **Interactive Simulation Engine**: `InteractiveTemplateFactory` linking 17 key aliases to 9 dynamic simulation widgets.

## Feature Inventory
| # | Feature | Description | Milestone | Source |
|---|---------|-------------|-----------|--------|
| 1 | R4 Unit Decoupling in Models | Add `String? unit` to `InteractiveParameter` and `InteractiveData`, regenerate Isar code | M1 | Survey 1 & 2 |
| 2 | R4 LiveEquationWidget Refactoring | Remove hardcoded `'V'`, support dynamic output unit, format slider unit labels | M1 | Survey 1 |
| 3 | R4 Simulation Sliders Unit Wiring | Pass `param.unit` to sliders in Ohm & Kinematics widgets | M1 | Survey 1 & 3 |
| 4 | R4 Automated Unit Tests | Test equations with custom units, no unit, and slider unit badges | M1 | Survey 1 |
| 5 | R3 Markdown Content Files | 24 human-editable `.md` files under `assets/content/{arithmetic,algebra,geometry_trig,calculus,physics}/` | M2 | Survey 2 |
| 6 | R3 Asset Registration | Register content directories under `flutter: assets:` in `pubspec.yaml` | M2 | Survey 2 |
| 7 | R3 Zero-Dep Frontmatter & Markdown Parser | Pure Dart `MarkdownContentParser` extracting YAML frontmatter, theory blocks, LaTeX, and proof steps | M2 | Survey 2 |
| 8 | R3 Offline Content Loader & Sync | `ContentLoaderService` using `AssetManifest` / `rootBundle` to populate Isar and in-memory cache | M2 | Survey 2 |
| 9 | R5 Declarative Widget Linking | Frontmatter `interactive:` specification deserializes into `InteractiveData` without widget code changes | M2 | Survey 3 |
| 10 | R3 & R5 Content Loader Tests | Automated tests for metadata, LaTeX blocks, widget linking, and DAG acyclicity | M2 | Survey 2 & 3 |
| 11 | R1 Codebase Compaction & Catalog Streamlining | Eliminate redundant 1,400 lines of hardcoded catalog files and duplicate DAG in `curriculum_registry.dart` | M3 | Survey 2 |
| 12 | R1 Dead Path Removal & Service Wiring | Refactor `MockDataService` to delegate to `ContentLoaderService`, clean dead imports | M3 | Survey 2 |
| 13 | R2 Agent-Optimized Project Map | `PROJECT_MAP.md` at root strictly <300 lines documenting modules, catalogs, widgets, state flow, and guide | M4 | Survey 3 |
| 14 | E2E & Full Verification | 100% pass on all existing and new tests, zero `flutter analyze` warnings/errors | M5 | Survey 1, 2, 3 |

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| M1 | R4: Configurable Slider System & Unit Decoupling | `InteractiveParameter`, `InteractiveData`, `LiveEquationWidget`, simulation sliders, unit tests | None | DONE |
| M2 | R3 & R5: Decoupled Markdown Content & Declarative Linking | `assets/content/**/*.md`, `pubspec.yaml`, `MarkdownContentParser`, `ContentLoaderService`, tests | M1 | DONE |
| M3 | R1: Codebase Refactoring & Compaction | Streamline `curriculum_registry.dart`, clean catalog duplication, wire `MockDataService` | M2 | DONE |
| M4 | R2: Agent-Optimized Project Map (`PROJECT_MAP.md`) | Single-file architecture index at root (<300 lines) | M1, M2, M3 | DONE |
| M5 | Final Milestone: Full E2E & Regression Pass | Complete verification of all test tiers, `flutter analyze` 0 warnings/errors | M1, M2, M3, M4 | DONE |

## Interface Contracts
### `InteractiveParameter` & `InteractiveData`
- `InteractiveData.unit`: `String?` (output measurement unit, e.g. `'W'`, `'J'`, `'m/s'`, `'V'`, or `null`/`''`).
- `InteractiveParameter.unit`: `String?` (parameter slider measurement unit, e.g. `'V'`, `'Ω'`, `'m/s'`, `'m/s²'`, or `null`/`''`).

### `MarkdownContentParser`
- `static KnowledgeNode parse(String rawMarkdown)`:
  - Parses frontmatter delimited by `--- ... ---`.
  - Maps `id` -> `serverId`, `title`, `category`, `subCategory`, `prerequisites` -> `tempPrerequisiteIds`.
  - Maps `interactive` object -> `InteractiveData` with `templateType`, `unit`, `equations`, and `parameters`.
  - Parses body into `ContentBlock`s (text, latex `$$...$$`, info_box) and `ProofStep`s (title, latex, insight, corollary tags).

### `ContentLoaderService`
- `static Future<List<KnowledgeNode>> loadAllFromBundle({AssetBundle? bundle})`:
  - Discovers all `assets/content/**/*.md` via `AssetManifest`.
  - Loads and parses each article via `MarkdownContentParser`.
- `static Future<void> syncToIsar(Isar isar, List<KnowledgeNode> nodes)`:
  - Phase 1: Upserts nodes into Isar preserving autoIncrement `id`.
  - Phase 2: Resolves prerequisite relationships via `IsarLinks<KnowledgeNode>`.

## Code Layout
- `lib/domain/models/`: Domain entities (`knowledge_node.dart`, `knowledge_node.g.dart`).
- `lib/data/content/`: `markdown_content_parser.dart`, `content_loader_service.dart`.
- `lib/data/catalog/`: Streamlined `curriculum_registry.dart`.
- `lib/presentation/widgets/interactive/`: 9 simulation widgets + `interactive_template_factory.dart`.
- `assets/content/`: Subdirectories `arithmetic/`, `algebra/`, `geometry_trig/`, `calculus/`, `physics/`.
- `PROJECT_MAP.md`: Root architectural guide (<300 lines).
- `test/`: Existing tests + `test/live_equation_and_sliders_test.dart`, `test/markdown_content_loader_test.dart`, `test/e2e_content_and_widgets_test.dart`.
