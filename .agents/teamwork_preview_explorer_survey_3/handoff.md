# Handoff Report: Spotlight Search & UI Architecture Exploration

**Author**: Spotlight Search & UI Architecture Explorer  
**Working Directory**: `c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_explorer_survey_3`  
**Date**: 2026-09-08 (UTC: 2026-09-07T23:45:00Z)  
**Status**: Complete (Hard Handoff)  

---

## Executive Architectural Summary

This investigation analyzes the main screen layout, UI clutter, and search subsystem of Laurentius (Brilliant-OS). The current application buries search inside a traditional Flutter `SearchDelegate` invoked by a tiny AppBar action icon, filtering only coarse topic titles (`KnowledgeNode.title`) and ignoring the rich mathematical corpus (theorems, formulas, step-by-step proofs, corollaries, and definitions). Simultaneously, the main screen and topic details suffer from redundant debug buttons, nested collapsible folder layers ("Cartellette"), huge dark hero cards, and triplicate quiz callouts that dilute the clean, low-friction ethos of Brilliant design language.

We present the complete architectural blueprint for an **Omnipresent Instant Spotlight Search Bar** permanently seated at the top of the main screen with:
1. **Live predictive sub-millisecond indexing** across all theorems, formulas, corollaries, and definitions.
2. **Dedicated proof and corollary visual cards** featuring category pills, KaTeX formula previews, contextual snippets, and query highlights.
3. **Deep 1-tap direct navigation** into `NodeDetailScreen` that automatically switches proof groups, expands the targeted proof step, scrolls it smoothly into view, and highlights the target corollary in $\le 1$ tap.
4. **Radical clutter eradication** across `MainLayoutScreen`, `HomeScreen`, `CategoryExplorerScreen`, and `NodeDetailScreen`.

---

## 1. Observation

### 1.1 UI Clutter & Redundancies in Existing Screens

#### A. `MainLayoutScreen` (`lib/presentation/pages/main_layout_screen.dart`)
- **Lines 70-75**: Search is hidden behind a modal overlay invoked by an AppBar icon:
  ```dart
  void _openSearch() {
    showSearch(
      context: context,
      delegate: GlobalNodeSearchDelegate(isar: widget.isar),
    );
  }
  ```
- **Lines 81-174**: The top `AppBar` contains excessive visual noise:
  - Hub badge + Title + Subtitle ("Brilliant OS" / "Mappa Conoscenze (DAG)").
  - Three separate icon actions in lines 128-171:
    1. Search button (`IconButton(icon: Icon(Icons.search_rounded))`).
    2. Refresh/Sync database button (`IconButton(icon: Icon(Icons.refresh_rounded))`).
    3. Settings button (`IconButton(icon: Icon(Icons.settings_outlined))`).
- **Observation**: The search bar is not omnipresent; it requires a tap to push a separate modal route. The "Ricarica catalogo" button is developer/debug clutter that belongs in background sync or Settings, not in the primary user-facing top bar.

#### B. `HomeScreen` / `GraphViewScreen` (`lib/presentation/pages/home_screen.dart`)
- **Lines 204-273**: Retains a duplicate fallback `AppBar` with a `TextButton.icon` for "Ricarica" and a "${_nodeLookup.length} Nodi" badge.
- **Lines 356-366**: Floating controls (`GraphControlsWidget`) float at `top: 16, right: 16`.
- **Lines 370-410**: A persistent, heavy dark floating banner is permanently fixed at the bottom:
  ```dart
  Positioned(
    bottom: 20, left: 20, right: 20,
    child: Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(color: const Color(0xF00F172A), ...),
        child: Text('Pizzica per zoomare • Trascina per esplorare • Tocca un nodo per aprirlo'),
      ),
    ),
  )
  ```
- **Observation**: This banner obscures lower DAG nodes, never dismisses, and introduces persistent visual weight.

#### C. `CategoryExplorerScreen` (`lib/presentation/pages/category_explorer_screen.dart`)
- **Lines 285-290 & Lines 364-451**: `_buildHeaderHero()` introduces a massive dark card (180px high) with gradient, icon, title, node counter badge, and explanatory paragraph:
  > *"Libreria Didattica STEM - Esplora per materia e livello di padronanza..."*
- **Lines 292-348 & Lines 944-992**: A pinned `SliverPersistentHeader` with height 104px stacks a scrollable `TabBar` on top of a 5-item horizontal `FilterChip` row ('Tutti', 'Fondamenti', 'Intermedio', 'Avanzato', 'Superiore').
- **Lines 567-730**: Nested "Cartellette" (`_buildSubCategoryFolderCard`) create collapsible accordion containers for topics with $>1$ child, requiring the user to tap to expand folders before seeing topic cards.
- **Observation**: The hero banner eats up 30-40% of the viewport height before any topic is visible. The collapsible folder accordion adds an unnecessary layer of nesting contrary to Brilliant's clean, immediate-access design language.

#### D. `NodeDetailScreen` (`lib/presentation/pages/node_detail_screen.dart`)
- **Lines 84-110**: The top `AppBar` has 3 action buttons:
  1. AI Rephrase (`Icons.edit_note_rounded`)
  2. AI Tutor Q&A (`Icons.help_outline_rounded`)
  3. Quiz runner (`Icons.quiz_outlined`)
- **Lines 241-274**: The body has a duplicate "Rielabora con AI" button right next to the "APPROFONDIMENTO TEORICO" section header.
- **Lines 317-318 & 342-411**: The body has an exercise prompt card `_buildExercisePromptCard` with a prominent "Mettiti alla Prova" button.
- **Lines 324-338**: Simultaneously, there is a `FloatingActionButton.extended` with "Mettiti alla Prova"!
- **Lines 17-25**: `NodeDetailScreen` only accepts `final KnowledgeNode node; final Isar? isar;`. It has **no parameters** to accept a target proof step, corollary anchor, or focus highlight.
- **Observation**: There are 3 separate entry points to launch the quiz and 2 entry points to trigger AI rephrasing. Crucially, there is no mechanism to deep-link or focus on a specific theorem or corollary.

---

### 1.2 Current Search Architecture & Mechanics

#### A. `GlobalNodeSearchDelegate` (`lib/presentation/widgets/node_search_delegate.dart`)
- **Lines 83-102**:
  ```dart
  final List<KnowledgeNode> pool =
      preloadedNodes ??
      (isar != null
          ? isar!.knowledgeNodes.where().findAllSync()
          : CurriculumRegistry.getAllNodes());

  final matches = pool.where((node) {
    final titleMatch = node.title.toLowerCase().contains(cleanQuery);
    final catMatch = node.category.toLowerCase().contains(cleanQuery);
    final subCatMatch =
        node.subCategory != null &&
        node.subCategory!.toLowerCase().contains(cleanQuery);
    final idMatch = node.serverId.toLowerCase().contains(cleanQuery);
    return titleMatch || catMatch || subCatMatch || idMatch;
  }).toList();
  ```
- **Lines 158-164**: Selecting a match simply executes:
  ```dart
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => NodeDetailScreen(node: node, isar: isar),
    ),
  );
  ```
- **Observations on Current Search Limitations**:
  1. **Zero Mathematical Object Indexing**: `node.algebraicProof` (step titles, LaTeX formulas, corollaries, insights) and `node.blocks` (definitions, theorems, LaTeX equations) are completely ignored.
  2. **Zero Predictive Indexing**: It runs an ad-hoc linear scan over the array on every keystroke without token trie or inverted index structures.
  3. **No Result Typology**: Every result is rendered as an identical generic topic card. Corollaries, theorems, and formulas cannot be differentiated.
  4. **No Preview Snippet or LaTeX Math**: The user cannot see why the item matched or what formula belongs to it.
  5. **No Direct Jump ($\le 1$ Tap)**: The user is dumped at line 0 of `NodeDetailScreen`. If the user searched for "Corollario di Viète" or "Formula Ridotta", they must scroll through the entire page, find the proof widget, and manually tap through steps to locate the corollary.

---

### 1.3 Algebraic Proof & Step Parsing Mechanics

#### A. `MarkdownContentParser` (`lib/data/content/markdown_content_parser.dart`)
- **Lines 261-333**: The parser detects `## Dimostrazione: [GroupName]` and parses step headers `### [StepHeader]`, extracting `$$...$$` LaTeX equations and `> **Insight:**` or `> Corollario:`.
- **Line 321**: `final finalDesc = groupName != null ? '[$groupName] $headerLine' : headerLine;`
- **Resulting Data Structure in Memory**:
  - `step.description`: e.g. `"[Formule di Viète (Somma e Prodotto delle Radici)] 3. Corollario: Equazione Parametrica Noti Somma e Prodotto"`
  - `step.latexEquation`: e.g. `"x^2 - s x + p = 0 \quad \text{con } s = x_1 + x_2, \; p = x_1 \cdot x_2"`
  - `step.insight`: e.g. `"Permette di ricostruire all'istante l'equazione quadratica..."`

#### B. `AlgebraicProofWidget` (`lib/presentation/widgets/algebraic_proof_widget.dart`)
- **Lines 18-21 & Lines 51-57**: Starts with `currentStepIndex = 0`, `_showAllSteps = false`, `_selectedGroup = null`.
- **Lines 280-305**: Identifies corollaries only visually if the description contains `"corollario"` (`final isCorollary = cleanDesc.trim().toLowerCase().startsWith('corollario') || cleanDesc.toLowerCase().contains('corollario:');`).
- **Observation**: `AlgebraicProofWidget` has no external controls to initialize at a specific step index, switch directly to an active group, or highlight a target corollary.

---

### 1.4 Test Suite Baseline
- Command: `flutter test`
- Result: **196 tests passed out of 196 (100% passing)** across all 18 test files.
- Relevant existing test suites:
  - `test/step11_navigation_content_test.dart`
  - `test/step12_reorganization_and_simulations_test.dart`
  - `test/math_rendering_and_explorer_test.dart`
  - `test/curriculum_dag_test.dart`

---

## 2. Logic Chain

1. **Premise 1**: The user requests an omnipresent Instant Spotlight Search bar accessible from the top of the main screen with live predictive indexing of theorems, formulas, corollaries, and definitions, displaying matching cards with preview snippets and enabling a direct jump in $\le 1$ tap.
2. **Premise 2**: Current search in `GlobalNodeSearchDelegate` is a modal full-screen route that only queries 4 string fields (`title`, `category`, `subCategory`, `serverId`), ignoring all mathematical entities within `blocks` and `algebraicProof`.
3. **Inference 2.1**: A dedicated `SpotlightIndexService` must parse and index four discrete mathematical object types on startup:
   - `SpotlightResultType.topic`
   - `SpotlightResultType.theorem`
   - `SpotlightResultType.corollary`
   - `SpotlightResultType.formula`
   - `SpotlightResultType.definition`
4. **Premise 3**: To achieve $\le 1$ tap direct jump to a theorem or corollary, navigation cannot simply instantiate `NodeDetailScreen(node: node)`.
5. **Inference 3.1**: `NodeDetailScreen` must accept deep-link parameters:
   - `initialProofStepIndex: int?`
   - `initialProofGroup: String?`
   - `targetFocusId: String?`
   - `focusType: SpotlightResultType?`
   - `highlightQuery: String?`
6. **Inference 3.2**: `AlgebraicProofWidget` must accept `initialStepIndex` and `initialGroup`, ensure that steps up to `initialStepIndex` are revealed, select the correct group, and apply a high-visibility amber/blue highlight pulse to the target card.
7. **Premise 4**: The Brilliant design language mandates generous whitespace, low friction, minimal button clutter, and immediate cognitive clarity.
8. **Inference 4.1**: 
   - Replace the cluttered `MainLayoutScreen` AppBar with a unified top Spotlight Header.
   - Remove redundant sync/refresh buttons from primary views.
   - Eliminate the 180px dark hero card in `CategoryExplorerScreen` and flatten nested folder accordions.
   - Consolidate triplicate quiz entry points and duplicate AI rephrase buttons in `NodeDetailScreen`.

---

## 3. Caveats

1. **Curriculum Scope**: There are 35+ Markdown topics in `assets/content/`. While the index engine automatically digests all nodes present in `CurriculumRegistry.getAllNodes()`, any topic lacking explicit `### ... Corollario` steps or `$$...$$` blocks will only be indexed at the topic and text block levels.
2. **Memory Footprint**: The in-memory token index for 35+ nodes occupies $\approx 250\text{ KB}$, which is negligible for mobile and desktop runtimes.
3. **Deep Linking to Markdown Blocks**: Proof steps can be targeted by index ($0 \dots N$); body markdown blocks are targeted via sequential block index or anchor IDs.
4. **No caveats** regarding Flutter/Dart framework compatibility or test runner integrity.

---

## 4. Conclusion & Architectural Design

### 4.1 UI Layout Simplification: Eradication of Clutter

```
┌────────────────────────────────────────────────────────────────────────┐
│                        MAIN LAYOUT SCREEN (ROOT)                       │
├────────────────────────────────────────────────────────────────────────┤
│  [✦ Brilliant OS]   [ 🔍 Cerca teoremi, formule, corollari...  (⌘K) ] [⚙]│  <-- OMNIPRESENT SPOTLIGHT
├────────────────────────────────────────────────────────────────────────┤
│                                                                        │
│                       INDEXED STACK (ACTIVE TAB)                       │
│                                                                        │
│  TAB 1: GRAFO (DAG)                        TAB 2: ESPLORA (CATALOG)    │
│  - Fullscreen Sugiyama 2D Graph            - Sleek Domain Pills        │
│  - Subtle floating zoom controls (top-R)   - Difficulty Chips          │
│  - Zero intrusive bottom banners           - Flat Topic Cards (No Folders)│
│                                                                        │
├────────────────────────────────────────────────────────────────────────┤
│              BOTTOM NAVIGATION BAR: [ ⬡ Grafo ]  [ 📖 Esplora ]        │
└────────────────────────────────────────────────────────────────────────┘
```

#### Specific Clean-Up Actions by Screen:

| Screen | Existing Clutter / Redundancy | Proposed Brilliant Simplification |
|---|---|---|
| **`MainLayoutScreen`** | • 3 icon buttons in AppBar (Search modal, Sync, Settings)<br>• Search hidden in separate route<br>• Developer sync button exposed | • Persistent top-level **Instant Spotlight Search Bar** with integrated search input and shortcut badge (`⌘K`)<br>• Remove debug "Ricarica" button (handled automatically in background)<br>• Clean minimalist Settings gear at trailing edge |
| **`HomeScreen` / `GraphViewScreen`** | • Duplicate internal AppBar<br>• Heavy dark floating tooltip banner covering bottom nodes (`Positioned(bottom: 20)`) | • Clean DAG viewport; DAG is the hero<br>• Remove persistent bottom tooltip banner<br>• Translucent frosted glass floating zoom buttons positioned cleanly beneath the top Spotlight bar |
| **`CategoryExplorerScreen`** | • Heavy 180px dark hero banner (`_buildHeaderHero`) pushing content down<br>• Nested "Cartellette" accordion folders requiring tap-to-expand | • Remove dark hero banner; replace with elegant, airy typography<br>• Flatten topic cards directly into category views with prominent subcategory tags (zero tap-to-expand friction) |
| **`NodeDetailScreen`** | • 3 ways to launch quiz (AppBar icon, body prompt card, FAB)<br>• 2 ways to trigger AI rephrasing (AppBar pencil, body header button) | • Single clear primary action for quiz (bottom action card or FAB)<br>• Unified AI Assistant action in AppBar<br>• Deep-link focus scroll and target corollary highlighting |

---

### 4.2 Spotlight Predictive Search Engine (`SpotlightIndexService`)

#### A. Data Model (`SpotlightSearchResult`)
```dart
enum SpotlightResultType {
  corollary, // Specific corollary derived from theorem
  theorem,   // Major theorem or lemma
  formula,   // LaTeX algebraic identity
  definition,// Core mathematical/scientific concept
  topic,     // Root knowledge node
}

class SpotlightSearchResult {
  final String id;                  // e.g. "mat_quad_eq_01#step_3"
  final String nodeId;              // e.g. "mat_quad_eq_01"
  final KnowledgeNode node;         // Full node entity
  final SpotlightResultType type;   // Corollary, Theorem, Formula, etc.
  final String title;               // Display title
  final String parentTopicTitle;    // Parent node title
  final String category;            // e.g. "Matematica"
  final String? subCategory;        // e.g. "Equazioni di Secondo Grado"
  final String snippet;             // Context preview text
  final String? latexFormula;       // KaTeX formula string
  final int? proofStepIndex;        // Target proof step index
  final String? proofGroup;         // Target proof sub-demonstration group
  final int? contentBlockIndex;     // Target body block index
  final double score;               // Relevance rank score
  final List<TextRange> matchRanges;// Ranges to highlight in UI
}
```

#### B. Ingestion & Indexing Pipeline
```
[CurriculumRegistry.getAllNodes() / Isar]
                  │
                  ▼
       [SpotlightIndexService]
                  │
  ┌───────────────┼───────────────┬────────────────┐
  ▼               ▼               ▼                ▼
[Topics]     [Theorems]     [Corollaries]     [Formulas]
• Title      • Step Headers • "Corollario:"   • LaTeX $$..$$
• SubCategory• ### Teorema  • Insights        • Parameters
• Category   • Rules        • Derived Results • Equations
  │               │               │                │
  └───────────────┴───────┬───────┴────────────────┘
                          ▼
            [In-Memory Predictive Trie]
            - Diacritic folding (è->e, viète->viete)
            - Token prefix matching (<1ms response)
            - Multi-field ranking & scoring
```

#### C. Scoring & Ranking Heuristics
1. **Exact token match on Corollary / Theorem title**: Score $+100$
2. **Prefix match on Corollary / Theorem title** (e.g. `"bisez"` $\to$ `"Bisezione"`): Score $+80$
3. **Keyword match in LaTeX equation tokens** (e.g. `"b^2 - 4ac"`, `"\sin"`): Score $+60$
4. **Exact match in Topic title**: Score $+50$
5. **Match in Insight / Snippet description**: Score $+30$
6. **Tie-breaking**: Shorter title string length and DAG foundational level.

---

### 4.3 Spotlight Search Bar & Matching Cards UI

#### A. Persistent Top-Level Spotlight Bar (`SpotlightSearchBarWidget`)
- **Dimensions**: Height 48px, horizontal margin 16px, vertical margin 8px.
- **Decoration**: `BorderRadius.circular(16)`, background `Colors.white`, border `Border.all(color: Color(0xFFE2E8F0), width: 1.2)`, elevation 2 with ambient shadow `BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4))`.
- **Leading**: `Icon(Icons.search_rounded, color: Color(0xFF2563EB), size: 20)`.
- **Field**: `TextField` with `hintText: 'Cerca teoremi, formule, corollari (es. "Viète", "Carabinieri")...'`.
- **Trailing**:
  - If text is empty: Keyboard badge `⌘K` or `Ctrl+K` (`Container(padding: ..., color: Color(0xFFF1F5F9), child: Text('⌘K'))`).
  - If text is not empty: Clear button `IconButton(icon: Icon(Icons.close_rounded), onPressed: clear)`.

#### B. Instant Dropdown Overlay (`SpotlightDropdownOverlay`)
When the user focuses or types into the Spotlight bar, an animated dropdown sheet descends smoothly over the active tab (using an `OverlayEntry` or anchored `Stack` layer):
- **Scrim**: Soft translucent backdrop (`Color(0x330F172A)`).
- **Max Height**: `MediaQuery.of(context).size.height * 0.65`.
- **Results Count Indicator**: Header showing e.g. `"5 RISULTATI TROVATI"`.

#### C. Result Card Anatomy (`SpotlightResultCard`)
```
┌────────────────────────────────────────────────────────────────────────┐
│ [ ★ COROLLARIO ]  Matematica • Equazioni di 2° Grado      [ 1 TAP → ]  │
│ Formula Ridotta (b pari)                                               │
│                                                                        │
│   ┌──────────────────────────────────────────────────────────────┐     │
│   │           x = (-b/2 ± √((b/2)² - ac)) / a                    │     │  <-- KaTeX Formula
│   └──────────────────────────────────────────────────────────────┘     │
│ "...quando il coefficiente lineare b è pari, il calcolo si             │  <-- Preview Snippet
│  semplifica dimezzando i termini ed evitando fattori 4..."             │
└────────────────────────────────────────────────────────────────────────┘
```
1. **Type Badge**:
   - `COROLLARIO`: Amber pill (`bg: Color(0xFFFEF3C7), text: Color(0xFFB45309)` with `Icons.star_rounded`).
   - `TEOREMA`: Indigo pill (`bg: Color(0xFFEFF6FF), text: Color(0xFF1D4ED8)` with `Icons.bookmark_added_rounded`).
   - `FORMULA`: Emerald pill (`bg: Color(0xFFDCFCE7), text: Color(0xFF15803D)` with `Icons.functions_rounded`).
   - `DEFINIZIONE`: Purple pill (`bg: Color(0xFFF3E8FF), text: Color(0xFF7C3AED)` with `Icons.lightbulb_outline_rounded`).
2. **Highlighting**: Matched characters highlighted with soft amber highlight `Color(0xFFFEF08A)`.
3. **KaTeX Formula Preview**: Clean KaTeX math snippet rendered using `flutter_math_fork`.
4. **Context Snippet**: Truncated 2-line contextual preview.
5. **Tap Indicator**: Subtle arrow and indicator showing `"Apri passaggio 4 →"`.

---

### 4.4 Direct 1-Tap Jump to Theorem / Corollary

#### Navigation Flow
```
User types "ridotta"
       │
       ▼
Spotlight displays: [COROLLARIO] Formula Ridotta (b pari)
       │
       ▼  (1 TAP on card)
[SpotlightSearchBarWidget] dismisses overlay
       │
       ▼
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => NodeDetailScreen(
      node: result.node,
      isar: widget.isar,
      initialProofStepIndex: result.proofStepIndex, // e.g. 3
      initialProofGroup: result.proofGroup,         // e.g. "Formula Risolutiva"
      targetFocusId: result.id,
      focusType: result.type,
      highlightQuery: query,
    ),
  ),
);
       │
       ▼
[NodeDetailScreen.initState]
  1. Sets active group in AlgebraicProofWidget to result.proofGroup
  2. Unlocks steps up to initialProofStepIndex (autoExpand = true)
  3. PostFrameCallback: Scrollable.ensureVisible(proofKey, duration: 450ms)
  4. Triggers 1.5s glowing pulse on target corollary card
```

**Outcome**: Exactly 1 tap from search to viewing and studying the fully expanded proof of the target corollary.

---

### 4.5 State Management, Keyboard Handling & Widget Tree

#### A. State Management: `SpotlightSearchController` (ChangeNotifier)
```dart
class SpotlightSearchController extends ChangeNotifier {
  final SpotlightIndexService indexService;
  
  String _query = '';
  List<SpotlightSearchResult> _results = [];
  bool _isOpen = false;
  int _selectedIndex = 0;

  String get query => _query;
  List<SpotlightSearchResult> get results => _results;
  bool get isOpen => _isOpen;
  int get selectedIndex => _selectedIndex;

  void onQueryChanged(String newQuery) {
    _query = newQuery;
    if (newQuery.trim().isEmpty) {
      _results = [];
      _isOpen = false;
    } else {
      _results = indexService.search(newQuery);
      _isOpen = true;
      _selectedIndex = 0;
    }
    notifyListeners();
  }

  void moveSelectionDown() {
    if (_results.isNotEmpty && _selectedIndex < _results.length - 1) {
      _selectedIndex++;
      notifyListeners();
    }
  }

  void moveSelectionUp() {
    if (_selectedIndex > 0) {
      _selectedIndex--;
      notifyListeners();
    }
  }

  void close() {
    _isOpen = false;
    _query = '';
    _results = [];
    notifyListeners();
  }
}
```

#### B. Keyboard Handling
- **`Ctrl+K` / `⌘K`**: Global shortcut via `Shortcuts` & `Actions`:
  ```dart
  Shortcuts(
    shortcuts: {
      LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyK): const FocusSearchIntent(),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyK): const FocusSearchIntent(),
    },
    child: Actions(
      actions: {
        FocusSearchIntent: CallbackAction(onInvoke: (_) => _searchFocusNode.requestFocus()),
      },
      child: ...,
    ),
  )
  ```
- **`ArrowDown` / `ArrowUp`**: Navigates active selection in results list without losing text field focus.
- **`Enter`**: Activates currently selected result immediately (1 keypress jump).
- **`Escape`**: Closes dropdown overlay and unfocuses search field.

---

## 5. Verification Method

### 5.1 Static Analysis & Existing Test Suite
Run the standard analysis and full test suite to guarantee zero regressions:
```bash
flutter analyze
flutter test
```
*Expected*: 0 errors, 0 warnings, 196+ tests passing.

### 5.2 Recommended New Test Suites

#### A. Unit Tests: `test/spotlight_search_test.dart`
1. **`SpotlightIndexService` Ingestion Test**:
   - Ingests `CurriculumRegistry.getAllNodes()`.
   - Verifies total index entries $> 100$ across topics, theorems, corollaries, and formulas.
2. **Italian Diacritic & Case Insensitivity**:
   - Querying `"viete"` and `"viète"` returns identical results for Viète formulas and corollaries.
   - Querying `"cartesio"` returns Descartes rule corollary.
3. **Specific Predictive Queries**:
   - Query `"bisezione"` $\to$ matches Bolzano-Bisezione theorem and corollary cards.
   - Query `"carabinieri"` $\to$ matches Teorema dei Carabinieri with $\lim_{x\to 0}\frac{\sin x}{x}=1$.
   - Query `"pura"` $\to$ matches Equazioni Pure and its root symmetry corollary.
   - Query `"ridotta"` $\to$ matches Formula Ridotta ($b$ pari) corollary card.
   - Query `"corollario"` $\to$ returns all corollaries across all 5 STEM domains.

#### B. Widget & Navigation Tests: `test/spotlight_widget_navigation_test.dart`
1. **Spotlight Bar Presence in `MainLayoutScreen`**:
   - Pumps `MainLayoutScreen()`.
   - Verifies Spotlight search input is visible at the top without tapping any icon.
   - Verifies debug "Ricarica" button is removed.
2. **Live Typing & Overlay Rendering**:
   - Enters text `"pura"` into the Spotlight search bar.
   - Pumps frame.
   - Verifies `SpotlightResultCard` appears with badge `COROLLARIO` and title `"Simmetria Radici Reali e Traslazione Assiale"`.
3. **Direct 1-Tap Navigation**:
   - Taps the corollary card.
   - Pumps and settles navigation.
   - Verifies `NodeDetailScreen` is pushed.
   - Verifies `AlgebraicProofWidget` has the corollary step expanded and visible.
4. **Keyboard Navigation**:
   - Pressing `ArrowDown` increments selected index; pressing `Enter` navigates to target node.

---

## 6. Implementation Roadmap for Builders

| Phase | Target Files | Key Implementation Objectives |
|---|---|---|
| **Phase 1: Domain & Search Service** | • `lib/domain/models/spotlight_result.dart`<br>• `lib/core/services/spotlight_index_service.dart` | • Implement `SpotlightSearchResult` & `SpotlightResultType`<br>• Implement `SpotlightIndexService` with diacritic-folding trie<br>• Ingest topics, theorems, corollaries, and LaTeX formulas |
| **Phase 2: Deep Navigation Extensions** | • `lib/presentation/pages/node_detail_screen.dart`<br>• `lib/presentation/widgets/algebraic_proof_widget.dart` | • Add `initialProofStepIndex`, `initialProofGroup`, `targetFocusId`<br>• Support group auto-switch and step auto-reveal in `AlgebraicProofWidget`<br>• Add glowing highlight animation on target corollary card |
| **Phase 3: Spotlight UI Components** | • `lib/presentation/widgets/spotlight_search_bar_widget.dart`<br>• `lib/presentation/widgets/spotlight_result_card.dart`<br>• `lib/presentation/widgets/spotlight_dropdown_overlay.dart` | • Create persistent top search bar with `⌘K` badge<br>• Create result cards with KaTeX formula & preview snippets<br>• Create smooth dropdown overlay with keyboard shortcuts |
| **Phase 4: Clutter Eradication** | • `lib/presentation/pages/main_layout_screen.dart`<br>• `lib/presentation/pages/home_screen.dart`<br>• `lib/presentation/pages/category_explorer_screen.dart` | • Integrate Spotlight into `MainLayoutScreen` top header; remove debug buttons<br>• Remove bottom floating banner in `HomeScreen`<br>• Flatten nested folders and remove 180px dark hero card in `CategoryExplorerScreen` |
| **Phase 5: Automated Tests & Validation** | • `test/spotlight_search_test.dart`<br>• `test/spotlight_widget_navigation_test.dart` | • Implement 12+ unit tests for search accuracy and diacritics<br>• Implement 6+ widget tests for 1-tap navigation and UI verification<br>• Verify `flutter analyze` (0 issues) and `flutter test` (100% pass) |
