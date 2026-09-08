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
- [ ] Automated tests verify that sliders with custom units display their respective unit labels.

## 2026-09-07T18:34:50Z

# Complete Visual & Curriculum Overhaul for Laurentius (Brilliant-OS)

Overhaul interactive animations (disable default autoplay, fix trigonometric circle tangent, replace confusing animations with clear Wikipedia-style diagrams for Rolle, Lagrange, Carabinieri, and Carnot) and expand the mathematical curriculum into organized sub-folders with deep, step-by-step proofs and unbroken prerequisite chains.

Working directory: c:\Users\catte\Desktop\Laurentius
Integrity mode: development

## Requirements

### R1. Animation Autoplay & Control Refactor
- Simulation widgets (`KinematicsSimulationWidget`, `RolleLagrangeWidget`, `TrigCircleWidget`, `RiemannSumWidget`, etc.) must NEVER start animating automatically on initial render.
- All simulation widgets must initialize in a paused/static state, displaying clean, clear default geometry and readouts.
- Users must have explicit control over animations via play/pause buttons, step buttons, or parameter sliders/gestures.

### R2. Interactive Simulation & Diagram Fixes
- **Trigonometric Circle (`trig_circle_widget.dart`)**:
  - Fix the tangent line and projection rendering so that it remains mathematically stable and visually coherent across all quadrants.
  - Gracefully handle asymptotes ($\theta \to \pi/2, 3\pi/2$) without flickering, visual glitches, or unexpected disappearances.
- **Theorems & Limit Visualizations (Wikipedia-Style Clarity)**:
  - Replace confusing dynamic animations for Rolle, Lagrange, and the Squeeze Theorem (Teorema dei Carabinieri) with clean, high-readability visual representations (geometric diagrams or interactive static-by-default plots).
  - Explicitly illustrate key geometric intuitions: secants parallel to tangents at interior points ($c$), and bounding upper/lower curves squeezing the central limit.
- **Carnot's Theorem / Triangle Geometry (`triangle_solver_widget.dart`)**:
  - Transform the visualization into an intuitive geometrical explanation of the Law of Cosines (Carnot as generalized Pythagorean theorem with dynamic projections $b \cos \gamma$ and side-length relationships).

### R3. Curriculum Modularization & Encyclopedic Expansion
- Reorganize and expand large topic areas into dedicated sub-folders (e.g. `assets/content/calculus/limits/` for Limits), updating `pubspec.yaml` assets accordingly.
- Create comprehensive, self-contained articles in Wikipedia/Brilliant style for:
  - Definition of limit (intuitive, formal $\epsilon$-$\delta$, and geometric meaning).
  - Individual fundamental/remarkable limits (e.g., $\lim_{x \to 0} \frac{\sin x}{x} = 1$, $\lim_{x \to 0} \frac{1 - \cos x}{x^2} = \frac{1}{2}$, $\lim_{x \to \pm\infty} (1 + \frac{1}{x})^x = e$, $\lim_{x \to 0} \frac{e^x - 1}{x} = 1$, $\lim_{x \to 0} \frac{\ln(1+x)}{x} = 1$).
  - For each topic: complete algebraic derivation step-by-step (`### Dimostrazione`), geometric intuition callouts (`> Intuizione:`), corollaries (`> Corollario:`), and linked visual widgets/diagrams.

### R4. Strict Prerequisite Chain & Knowledge Graph Integrity
- Construct an unbroken, logical prerequisite DAG: foundational concepts -> intermediate topics -> advanced theorems (e.g., Euclidean geometry / unit circle -> trigonometric limits; limit definition -> remarkable limits -> derivatives).
- Every newly created or modified topic must have valid, existing IDs in `prerequisites`.

## Acceptance Criteria

### Simulation & Visual Polish
- [ ] Every simulation widget starts in a stopped/paused state upon initial view rendering; no automated motion occurs without user action.
- [ ] The tangent line in `trig_circle_widget.dart` renders correctly in all 4 quadrants with appropriate clamping/asymptote protection and no flickering.
- [ ] Rolle, Lagrange, Carabinieri, and Carnot theorem widgets provide crisp, self-explanatory geometric diagrams with clear labels and intuitive visual cues.

### Curriculum Structure & Content Quality
- [ ] Sub-topic folders (such as `assets/content/calculus/limits/`) are created and registered in `pubspec.yaml`.
- [ ] Detailed Markdown articles are created for limit definition and each major remarkable limit with full algebraic steps and intuitive explanations.
- [ ] The full curriculum DAG is strictly acyclic and all referenced prerequisite IDs resolve cleanly.

### Build & Test Verification
- [ ] `flutter analyze` passes with 0 errors and 0 warnings.
- [ ] `flutter test test/markdown_content_loader_test.dart` passes.
- [ ] `flutter test test/curriculum_dag_test.dart` passes.
- [ ] The full test suite (`flutter test`) passes without regressions.

## 2026-09-07T23:39:08Z

# Complete UI Simplification & Comprehensive Corollary Proofs Overhaul

Redesign the Laurentius UI to be radically simple, clean, and low-friction, featuring an omnipresent instant Spotlight search bar that allows users to find and jump to any theorem, proof, or corollary in a single tap with minimum buttons. Simultaneously, expand every corollary across all 35+ curriculum topics to include a complete, fully expanded step-by-step mathematical demonstration with all algebraic derivations visible in the text rather than just stating the final result.

Working directory: c:\Users\catte\Desktop\Laurentius
Integrity mode: development

## Requirements

### R1. Radically Simplified UI & Instant Spotlight Search
- Centralize and simplify the main user interface: eliminate redundant buttons, deeply nested menus, and clutter.
- Provide a persistent, top-level **Instant Spotlight Search bar** (with live predictive indexing of theorems, formulas, corollaries, and definitions):
  - Typing any keyword (e.g., "bisezione", "pura", "viète", "carabinieri", "ridotta", "corollario") instantly displays matching proof and corollary cards.
  - Tapping a result immediately opens the topic directly focused on that exact theorem or corollary in a single tap.
- Streamline the topic view: present content cleanly and effortlessly with minimal button clutter.

### R2. Complete, Unabridged Proofs for All Corollaries
- Audit every topic across the entire curriculum (`arithmetic`, `algebra`, `calculus`, `geometry_trig`, `physics`).
- For every corollary, provide a comprehensive, fully written-out step-by-step mathematical proof directly in the text:
  - Explain the initial hypothesis derived from the main theorem.
  - Detail every single intermediate algebraic manipulation, substitution, and simplification.
  - Never merely state the final result formula without the mathematical derivation.
- Proofs for corollaries must be clearly visible and formatted for immediate reading and study without requiring extra button presses to uncover the steps.

### R3. Interactive Proof Switcher & Quick Navigation Synchronization
- Update the interactive proof engine (`AlgebraicProofWidget`, `MarkdownContentParser`) and SDUI parser so that all corollaries with proofs are properly recognized, indexed in the proof selector bar, and linkable from the search index.
- Maintain full offline-first capability and compatibility with existing simulation widgets.

## Acceptance Criteria

### UI Usability & Simplicity
- [ ] Omnipresent Spotlight Search bar is accessible from the top of the main screen, returning instant matching results for any theorem, rule, or corollary as the user types.
- [ ] Selecting a search result navigates directly to that topic in <= 1 tap.
- [ ] The overall UI layout has fewer buttons, clear visual hierarchy, and zero confusing nested layers.

### Mathematical Rigor & Content Quality
- [ ] Every corollary in the curriculum contains its complete mathematical demonstration step-by-step (`#### Dimostrazione del Corollario` / `### Dimostrazione`), detailing all intermediate algebraic steps.
- [ ] No corollary simply states the final equation without derivation.
- [ ] Markdown parser and search index cleanly ingest all theorem and corollary proofs.

### Code Quality & Automated Tests
- [ ] `flutter analyze` passes with 0 errors and 0 warnings.
- [ ] Dedicated widget and unit tests verify:
  - Instant Spotlight search functionality and direct 1-tap navigation.
  - Presence of full step-by-step proofs for corollaries across curriculum nodes.
- [ ] Entire test suite (`flutter test`) passes 100% without regressions.


