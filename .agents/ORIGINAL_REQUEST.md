# Original User Request

## 2026-09-07T11:53:43Z

Refactor the Laurentius (Flutter/Dart) codebase to streamline architecture, implement a token-saving project map for AI agents, decouple educational content into code-free human-editable files (LaTeX + widget linking), and make slider units fully configurable while removing hardcoded units.

Working directory: c:\Users\catte\Desktop\Laurentius
Integrity mode: development

## Requirements

### R1. Codebase Refactoring & Compaction
Refactor and clean the Laurentius Flutter project to eliminate redundant boilerplate, duplicate in-memory data declarations, and dead paths. Ensure the codebase remains modular, compact, and maintainable.

### R2. Agent-Optimized Project Map (`PROJECT_MAP.md`)
Create a concise, single-file architectural index and map (`PROJECT_MAP.md`, strictly under 300 lines) documenting module boundaries, catalog pathways, interactive simulation widgets, and state flow. The map must allow AI agents to navigate and modify features accurately without reading or grepping through the entire repository.

### R3. Decoupled Content System (Human-Editable Markdown Articles)
Separate educational articles into individual, human-editable Markdown files (`assets/content/**/*.md`) free of Flutter/Dart code. Each article must define its metadata (title, category, prerequisites, linked interactive simulation, and parameter configuration) via YAML frontmatter, and its educational narrative via pure Markdown and LaTeX math blocks. An offline parser/loader must ingest these files into the application's local knowledge store without requiring network connectivity.

### R4. Configurable Slider System & Unit Decoupling
Refactor parameter and result sliders across interactive components (including equation evaluation) to eliminate hardcoded units (specifically the hardcoded `'V'` in live equation evaluation). Every slider and evaluation readout must allow specifying its own measurement unit (e.g., `'V'`, `'Ω'`, `'m/s'`, `'N'`, `'rad'`) or no unit at all, strictly driven by the content/parameter specification.

### R5. Declarative Widget Linking
Allow any Markdown article to link to any supported animated simulation widget (e.g., circuit simulation, kinematics, trigonometric circle, cartesian graph, triangle solver, etc.) using a declarative key and parameter bindings in its frontmatter, so that new topics can be added and hooked up to animations without modifying widget source code.

## Acceptance Criteria

### Code Hygiene & Integrity
- [ ] `flutter analyze` runs and exits with zero errors and zero warnings.
- [ ] All existing tests in `test/` (including animation, navigation, and explorer tests) continue to pass via `flutter test`.
- [ ] Hardcoded in-memory catalogs are streamlined to avoid duplication with the file-based content system.

### Project Map for AI Agents
- [ ] `PROJECT_MAP.md` exists at repository root and is strictly under 300 lines.
- [ ] `PROJECT_MAP.md` documents every primary directory under `lib/`, the list of all available interactive simulation widgets and their template keys, and step-by-step instructions for adding new topics.

### Markdown Content System & Parser
- [ ] Educational topics are organized as separate `.md` files under `assets/content/` (and registered in `pubspec.yaml`) with YAML frontmatter and LaTeX math body.
- [ ] The app parses and loads all Markdown content files into the local database/catalog offline upon startup or synchronization.
- [ ] Automated tests verify that the Markdown content loader successfully parses metadata, LaTeX math blocks, and widget links.

### Slider Units & Parameterization
- [ ] The hardcoded `'V'` unit in `LiveEquationWidget` is removed; it renders the configured unit from parameters or nothing if no unit is set.
- [ ] `InteractiveParameter` and interactive templates support an optional `unit` field (e.g. `unit: "V"`, `unit: "m/s"`, `unit: ""`).
- [ ] Automated tests verify that an equation with a custom unit (e.g. `unit: "N"`) displays `"N"` and an equation with no unit displays no suffix.
- [ ] Automated tests verify that sliders with custom units display their respective unit labels.
