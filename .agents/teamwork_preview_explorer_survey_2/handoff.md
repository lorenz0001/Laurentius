# Proof Engine & SDUI Architecture Survey Report

**Architectural Analysis & Design Proposals for Complete Corollary Proofs and Spotlight 1-Tap Deep Linking**

- **Author**: Proof Engine & SDUI Architecture Explorer
- **Date**: 2026-09-08T01:44:00Z
- **Working Directory**: `c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_explorer_survey_2\`
- **Target Milestone**: UI Simplification, Unabridged Corollary Proofs, & Spotlight Search Synchronization (Ref. `ORIGINAL_REQUEST.md` § 2026-09-07T23:39:08Z)

---

## 1. Observation

Direct code observations from inspection of the Laurentius repository (`lib/`, `test/`, and `assets/content/`):

### 1.1 `lib/data/content/markdown_content_parser.dart`
- **Parsing Entry Point** (`parse`, lines 11–45): Extracts YAML frontmatter between `---` boundaries and passes the remaining markdown string to `_parseBody(body, node)`.
- **Pre-Proof vs. Proof Split** (lines 213–222):
  ```dart
  final demoRegex = RegExp(r'^##\s+Dimostrazione.*$', caseSensitive: false, multiLine: true);
  final firstDemoMatch = demoRegex.firstMatch(body);
  final preProof = firstDemoMatch != null ? body.substring(0, firstDemoMatch.start).trim() : body.trim();
  final proofPart = firstDemoMatch != null ? body.substring(firstDemoMatch.start).trim() : '';
  ```
  - Any markdown preceding the first `## Dimostrazione` is chunked by double newlines (`\n\s*\n`) into `node.blocks` (`math_latex`, `info_box`, or `text_markdown`).
  - **Handling of `> Corollario: [Nome]`**: If placed in `preProof`, it is treated as a generic `info_box` `ContentBlock`. The parser has no dedicated pattern or type for corollaries in the pre-proof body.
- **Proof Section Chunking** (lines 264–286):
  ```dart
  final sectionChunks = proofPart.split(
    RegExp(r'(?=^##\s+Dimostrazione)', caseSensitive: false, multiLine: true),
  );
  ```
  - It extracts `groupName` only if the section header contains `:` or ` - `:
    ```dart
    final colonIdx = firstLine.indexOf(':');
    final dashIdx = firstLine.indexOf(' - ');
    if (colonIdx != -1) {
      final name = firstLine.substring(colonIdx + 1).trim();
      if (name.isNotEmpty) groupName = name;
    } else if (dashIdx != -1) {
      final name = firstLine.substring(dashIdx + 3).trim();
      if (name.isNotEmpty) groupName = name;
    }
    ```
    *Limitation*: If a header is `## Dimostrazione Logico-Algebrica` (as in `phys_kin_01.md` line 44), `groupName` remains `null`.
- **Step Extraction** (lines 288–330):
  - Steps are split strictly on `RegExp(r'(?=^###\s+)', multiLine: true)`.
  - The header line is extracted by stripping `^###\s+`.
  - If `groupName != null`, the description is formatted as:
    ```dart
    final finalDesc = groupName != null ? '[$groupName] $headerLine' : headerLine;
    ```
  - Only the *first* `$$...$$` and the *first* `> **Insight:**` / `> **Intuizione:**` are extracted:
    ```dart
    final mathMatch = RegExp(r'\$\$(.*?)\$\$', dotAll: true).firstMatch(remaining);
    final insightMatch = RegExp(r'>\s*(\*\*Insight:\*\*|\*\*Intuizione:\*\*)?\s*(.*?)(?=(\n|$))', dotAll: true).firstMatch(remaining);
    ```
  - **Handling of `#### Dimostrazione del Corollario`**: Currently **unsupported** in `markdown_content_parser.dart`. Any `####` line is not treated as a delimiter; it falls inside the `remaining` block of the preceding `### ` step. Consequently, any subsequent formulas or sub-steps in that corollary block are dropped because only the first `$$` is captured into `latexEquation`.
  - **Capture of Corollary Proofs**: Corollaries are currently written across the 35 curriculum files as `### 4. Corollario: [Nome]` (e.g., `mat_quad_eq_01.md:71`, `phys_kin_01.md:62`). The parser stores them as a standard, flat `ProofStep` inside `node.algebraicProof` with no distinction from regular theorem derivation steps.

---

### 1.2 `lib/domain/models/knowledge_node.dart`
- **KnowledgeNode Entity** (`@collection`, lines 6–107):
  - Contains `List<ProofStep> algebraicProof = [];`
  - Contains `List<ContentBlock> blocks = [];`
  - Contains `@ignore List<ContentBlock> get effectiveBlocks` (synthesizes blocks from `algebraicProof` when `blocks` is empty).
- **ProofStep Entity** (`@embedded`, lines 124–137):
  ```dart
  @embedded
  class ProofStep {
    String? description;
    String? latexEquation;
    String? insight;

    ProofStep();
    factory ProofStep.fromJson(...) => ...
  }
  ```
  - There are **no fields** for: `groupName`, `isCorollary`, `corollaryTitle`, or nested sub-steps.
  - In Isar, modifying `@embedded` or `@collection` classes to add stored fields requires running `dart run build_runner build` to regenerate `knowledge_node.g.dart`.
  - However, Dart `@ignore` getters or computed properties on `ProofStep` can be added without any Isar schema migration or generator execution.

---

### 1.3 `lib/presentation/widgets/algebraic_proof_widget.dart`
- **Group Discovery & Filtering** (lines 22–48):
  - Groups are extracted dynamically from `step.description` using `RegExp(r'^\[(.*?)\]')`:
    ```dart
    List<String> get _groups {
      final groups = <String>[];
      for (final step in widget.proofSteps) {
        final desc = step.description ?? '';
        final match = RegExp(r'^\[(.*?)\]').firstMatch(desc);
        if (match != null) {
          final g = match.group(1)!.trim();
          if (g.isNotEmpty && !groups.contains(g)) groups.add(g);
        }
      }
      return groups;
    }
    ```
  - When `_groups` is non-empty, it renders horizontal `FilterChip`s (lines 158–203). Selecting a chip sets `_selectedGroup = group`, resets `currentStepIndex = 0`, and resets `_showAllSteps = false`.
- **Step Unlocking & Progressive Disclosure** (lines 79–83, 222–246):
  - Step progression is controlled via `currentStepIndex`.
  - Users must tap "Sblocca Passaggio N" repeatedly or tap "Mostra tutti" to reveal all steps.
- **Corollary Card Rendering & Badge Styling** (lines 280–363):
  - Detects corollaries at runtime by checking description text:
    ```dart
    final isCorollary =
        cleanDesc.trim().toLowerCase().startsWith('corollario') ||
        cleanDesc.toLowerCase().contains('corollario:');
    ```
  - If true, applies:
    - Amber border (`#F59E0B`, 1.5px width) and warm cream background (`#FFFBEB`).
    - Gold badge with star: `Icon(Icons.star_rounded)` + `Text('COROLLARIO DEDOTTO')`.
    - Larger LaTeX formula font size (22 vs 19) and bold font weight (`FontWeight.w700`).
    - Dedicated yellow insight box (`#FEF9C3`) with `#B45309` bulb icon.
- **Deep-Linking & Scrolling Deficiencies**:
  - `AlgebraicProofWidget` does not accept parameters to preselect an `initialGroup`, expand up to an `initialStepIndex`, or highlight a specific corollary.
  - The step list uses `physics: const NeverScrollableScrollPhysics()` and has no `ScrollController` or `GlobalKey` references.

---

### 1.4 `lib/presentation/pages/node_detail_screen.dart`
- **Layout & Structure** (lines 53–339):
  - Renders a single vertical `SingleChildScrollView(physics: BouncingScrollPhysics(), child: Column(...))` displaying:
    1. Category / SubCategory tags
    2. Node title and ID
    3. `PrerequisitesSectionWidget`
    4. Theoretical blocks (`node.effectiveBlocks`)
    5. `AlgebraicProofWidget(proofSteps: node.algebraicProof)`
    6. Interactive simulation widget (if configured)
    7. AI Quiz prompt card
- **Deep-Linking Deficiencies**:
  - Constructor only accepts `required KnowledgeNode node` and `Isar? isar`.
  - No `ScrollController` is attached to `SingleChildScrollView`.
  - When opened from search or external link, the screen always opens scrolled to position 0 (the top). If the user searches for a specific corollary (e.g. "Torricelli" or "Formula Ridotta"), they land at the top of the node and must scroll manually through prerequisite chips and theoretical blocks, switch tabs if multiple proof groups exist, and tap to unlock steps.

---

### 1.5 `lib/presentation/widgets/node_search_delegate.dart`
- **Current Search Scope** (lines 94–102):
  - Searches only `node.title`, `node.category`, `node.subCategory`, and `node.serverId`.
  - Does **not** search inside `node.algebraicProof` (theorems, steps, corollaries, formulas) or `node.blocks`.
  - On tap (lines 157–164), it unconditionally launches `NodeDetailScreen(node: node, isar: isar)` with no target proof focus.

---

### 1.6 Existing Test Suite Verification
- Executed `flutter test`:
  - **Result**: `All tests passed! (196 tests)`.
  - Exit code: 0.
- Executed `flutter analyze`:
  - **Result**: `No issues found! (ran in 2.7s)`.
  - Exit code: 0.
- Key tests verifying parser and proofs:
  - `test/markdown_content_loader_test.dart`:
    - Line 18: Frontmatter and proof step extraction.
    - Line 330: Multi-demonstration parsing with named groups (`[Formule di Addizione] 2. Corollario: Proprietà Additiva`).
    - Line 609: Verifies every single one of the 35 topics contains an identifiable corollary step.
    - Line 769: Verifies all 35 markdown files parse successfully.
  - `test/interactive_simulation_test.dart`:
    - Line 147: Verifies `AlgebraicProofWidget` corollary badge (`COROLLARIO DEDOTTO`).
  - `test/curriculum_dag_test.dart`:
    - Line 149: Verifies presence of corollaries in all nodes.
  - `test/challenger_curriculum_stress_test.dart`:
    - Line 90: Asserts `hasCorollary == true` for each node.

---

## 2. Logic Chain

1. **Premise 1 (Content Structure)**: The curriculum contains 35+ topics. Some topics (like `mat_quad_eq_01.md`, `mat_trig_add_01.md`, `mat_fund_calc_01.md`) have multiple distinct proofs formatted with `## Dimostrazione: [Titolo]`, while others have a single `## Dimostrazione Logico-Algebrica` containing `### [N]. Corollario: [Nome]` as the final step.
2. **Premise 2 (Requirement R2)**: Requirement R2 mandates that *every* corollary have a complete, fully expanded step-by-step mathematical demonstration detailing all intermediate algebraic manipulations, hypotheses, and substitutions, without merely stating the final equation.
3. **Premise 3 (Parser Architecture)**:
   - There are two clean ways to write full corollary proofs in Markdown:
     - **Format A (Top-Level Corollary Sections)**:
       ```markdown
       ## Dimostrazione: Teorema di Pitagora
       ### 1. Costruzione geometrica ...
       ### 2. Equivalenza delle aree ...

       ## Dimostrazione: Corollario - Metrica Euclidea e Diagonale del Quadrato
       ### 1. Ipotesi e riduzione geometrica ...
       ### 2. Sostituzione algebrica l_1 = l_2 = l ...
       ### 3. Deduzione della diagonale d = l * sqrt(2) ...
       ```
       *Advantage*: Automatically integrates with the existing `_groups` switcher in `AlgebraicProofWidget`! The selector chip bar immediately displays `[Teorema di Pitagora]` and `[Corollario - Metrica Euclidea]`.
     - **Format B (Sub-Demonstrations within a Section)**:
       ```markdown
       ### 4. Corollario: Formula Senza Tempo di Torricelli
       $$v^2 = v_0^2 + 2 a \Delta x$$
       > **Insight:** ...
       #### Dimostrazione del Corollario
       ##### 1. Isolamento del parametro temporale t
       $$t = \frac{v - v_0}{a}$$
       ##### 2. Sostituzione nella legge oraria
       $$\Delta x = v_0 \left(\frac{v - v_0}{a}\right) + \frac{1}{2} a \left(\frac{v - v_0}{a}\right)^2$$
       ```
       *Requirement*: `MarkdownContentParser` must be enhanced to parse `#### Dimostrazione del Corollario` and sub-steps without dropping formulas.
4. **Premise 4 (Model Backward Compatibility)**:
   - The test suite strictly validates that `step.description` starts with `[groupName]` when multiple demonstrations exist (see `test/markdown_content_loader_test.dart:361`).
   - Adding computed getters to `ProofStep` (`isCorollary`, `groupName`, `cleanDescription`, `corollaryName`) allows the UI and search engine to access structured corollary data cleanly without touching Isar schema code (`knowledge_node.g.dart`) or requiring `build_runner`.
5. **Premise 5 (UI Deep Linking & 1-Tap Navigation)**:
   - For Spotlight search to satisfy Requirement R1 (1-tap jump to the exact theorem or corollary):
     - `NodeDetailScreen` must accept optional deep-link parameters: `targetProofGroup`, `targetStepIndex`, `targetCorollary`, and `autoUnlockProof`.
     - `NodeDetailScreen` must use a `ScrollController` and trigger `Scrollable.ensureVisible` on the proof widget when deep-linked.
     - `AlgebraicProofWidget` must accept `initialGroup`, `initialStepIndex`, and `initialShowAll` to switch to the right tab and display the corollary immediately without requiring button taps to unlock.
     - The Spotlight search delegate must index theorems, proof groups, and corollaries, passing the target parameters upon selection.

---

## 3. Caveats

1. **Isar Schema Stability**: We intentionally recommend using `@ignore` getters on `ProofStep` (or non-persisted helpers) rather than modifying `@embedded` stored fields. Modifying stored fields in `lib/domain/models/knowledge_node.dart` would require running `build_runner build` and could cause database migration mismatches if existing local Isar stores contain old schemas.
2. **Backward Compatibility of Existing Tests**: Multiple tests in `test/markdown_content_loader_test.dart` assert exact string matches on `step.description` (e.g. `[Formule di Addizione] 2. Corollario: Proprietà Additiva`). Any refactoring of `MarkdownContentParser` must retain `finalDesc = groupName != null ? '[$groupName] $headerLine' : headerLine` to preserve 100% test pass rate.
3. **Format Uniformity across 35 Topics**: The 35 markdown files currently use `### <N>. Corollario: <Titolo>` inside `## Dimostrazione`. Adopting **Format A** (`## Dimostrazione: Corollario - <Titolo>` or `## Dimostrazione: <Teorema>` + `## Dimostrazione: <Corollario>`) is the most robust and least invasive approach, as it directly leverages Flutter's existing horizontal chip group switcher in `AlgebraicProofWidget`.

---

## 4. Conclusion & Concrete Design Proposals

### Proposal 1: Enhanced `MarkdownContentParser`
Enhance `MarkdownContentParser._parseBody` to:
1. Support both `:` and `-` in section headers, and if a section header is simply `## Dimostrazione Logico-Algebrica`, assign `groupName = 'Dimostrazione Principale'` if other named sections exist.
2. Support `## Corollario: [Nome]` as a proof section delimiter on par with `## Dimostrazione: [Nome]`.
3. Support `#### Dimostrazione del Corollario` by capturing sub-steps into distinct `ProofStep` entries tagged with `[Corollario: <Nome>] Passo <N>`.

#### Code Sketch for `MarkdownContentParser`:
```dart
// In _parseBody:
final demoRegex = RegExp(r'^##\s+(Dimostrazione|Corollario).*$', caseSensitive: false, multiLine: true);
...
final sectionChunks = proofPart.split(
  RegExp(r'(?=^##\s+(Dimostrazione|Corollario))', caseSensitive: false, multiLine: true),
);

for (final section in sectionChunks) {
  final trimmedSection = section.trim();
  if (trimmedSection.isEmpty) continue;
  final lines = trimmedSection.split('\n');
  final firstLine = lines.first.trim();
  String? groupName;

  final colonIdx = firstLine.indexOf(':');
  final dashIdx = firstLine.indexOf(' - ');
  if (colonIdx != -1) {
    groupName = firstLine.substring(colonIdx + 1).trim();
  } else if (dashIdx != -1) {
    groupName = firstLine.substring(dashIdx + 3).trim();
  } else if (firstLine.toLowerCase().contains('corollario')) {
    groupName = firstLine.replaceFirst(RegExp(r'^##\s+', caseSensitive: false), '').trim();
  }
  ...
}
```

---

### Proposal 2: Non-Breaking Getters on `ProofStep` & `KnowledgeNode`
Add the following computed properties to `ProofStep` in `lib/domain/models/knowledge_node.dart`:
```dart
extension ProofStepExt on ProofStep {
  /// Determina se il passaggio è un corollario o parte di una dimostrazione di corollario.
  bool get isCorollary {
    final desc = description?.toLowerCase() ?? '';
    final ins = insight?.toLowerCase() ?? '';
    return desc.contains('corollario') || ins.contains('corollario');
  }

  /// Estrae il nome del gruppo di dimostrazione dal prefisso [Gruppo], se presente.
  String? get groupName {
    if (description == null) return null;
    final match = RegExp(r'^\[(.*?)\]').firstMatch(description!);
    return match?.group(1)?.trim();
  }

  /// Restituisce la descrizione senza il prefisso [Gruppo].
  String get cleanDescription {
    if (description == null) return '';
    return description!.replaceFirst(RegExp(r'^\[.*?\]\s*'), '').trim();
  }

  /// Estrae il titolo del corollario se il passaggio ne definisce uno.
  String? get corollaryTitle {
    final clean = cleanDescription;
    final match = RegExp(r'corollario:\s*(.*)', caseSensitive: false).firstMatch(clean);
    return match?.group(1)?.trim();
  }
}
```

---

### Proposal 3: Enhanced `AlgebraicProofWidget` with Deep-Linking
Update `AlgebraicProofWidget` to support preselection and auto-unlocking:
```dart
class AlgebraicProofWidget extends StatefulWidget {
  final List<ProofStep> proofSteps;
  final String? initialGroup;
  final int? initialStepIndex;
  final bool initialShowAll;
  final String? targetCorollary;

  const AlgebraicProofWidget({
    super.key,
    required this.proofSteps,
    this.initialGroup,
    this.initialStepIndex,
    this.initialShowAll = false,
    this.targetCorollary,
  });
...
}

class _AlgebraicProofWidgetState extends State<AlgebraicProofWidget> {
  late int currentStepIndex;
  late bool _showAllSteps;
  String? _selectedGroup;

  @override
  void initState() {
    super.initState();
    _showAllSteps = widget.initialShowAll;
    currentStepIndex = widget.initialStepIndex ?? 0;
    _selectedGroup = widget.initialGroup;

    // Se è specificato un corollario target, seleziona il gruppo corrispondente
    if (widget.targetCorollary != null) {
      for (final step in widget.proofSteps) {
        if (step.description?.toLowerCase().contains(widget.targetCorollary!.toLowerCase()) ?? false) {
          final g = step.groupName;
          if (g != null) _selectedGroup = g;
          _showAllSteps = true; // Mostra subito tutti i passaggi del corollario
          break;
        }
      }
    }
  }
  ...
  // Nel selettore FilterChip, evidenzia i chip che contengono corollari con icona a stella
  Widget _buildGroupChip(String group, bool isSelected) {
    final isCorollaryGroup = group.toLowerCase().contains('corollario');
    return FilterChip(
      avatar: isCorollaryGroup
          ? const Icon(Icons.star_rounded, size: 14, color: Color(0xFFD97706))
          : null,
      label: Text(group),
      selected: isSelected,
      ...
    );
  }
}
```

---

### Proposal 4: `NodeDetailScreen` Deep-Linking and Scroll-to-Proof
Update `NodeDetailScreen` to support direct jumping:
```dart
class NodeDetailScreen extends StatefulWidget {
  final KnowledgeNode node;
  final Isar? isar;
  final String? targetProofGroup;
  final int? targetStepIndex;
  final String? targetCorollary;
  final bool autoUnlockProof;

  const NodeDetailScreen({
    super.key,
    required this.node,
    this.isar,
    this.targetProofGroup,
    this.targetStepIndex,
    this.targetCorollary,
    this.autoUnlockProof = false,
  });

  @override
  State<NodeDetailScreen> createState() => _NodeDetailScreenState();
}

class _NodeDetailScreenState extends State<NodeDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _proofSectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.targetProofGroup != null ||
        widget.targetCorollary != null ||
        widget.targetStepIndex != null ||
        widget.autoUnlockProof) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = _proofSectionKey.currentContext;
        if (context != null) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  ...
  // Nel build():
  SingleChildScrollView(
    controller: _scrollController,
    physics: const BouncingScrollPhysics(),
    ...
    AlgebraicProofWidget(
      key: _proofSectionKey,
      proofSteps: node.algebraicProof,
      initialGroup: widget.targetProofGroup,
      initialStepIndex: widget.targetStepIndex,
      initialShowAll: widget.autoUnlockProof,
      targetCorollary: widget.targetCorollary,
    ),
  )
```

---

### Proposal 5: Instant Spotlight Search Bar & Live Indexing
Replace the nested `IconButton -> showSearch` in `MainLayoutScreen` with a persistent top-level search bar or an instant predictive search delegate that indexes:
1. **Node Topics** (title, category, subcategory)
2. **Main Theorems** (`## Dimostrazione: [Titolo]`)
3. **Corollaries** (`### Corollario: [Nome]` and `## Corollario: [Nome]`)
4. **Formulas** (`step.latexEquation`)

When a user taps a matching result:
- If match is a **Node**: navigates to `NodeDetailScreen(node: node)`.
- If match is a **Theorem Proof**: navigates to `NodeDetailScreen(node: node, targetProofGroup: groupName, autoUnlockProof: true)`.
- If match is a **Corollary**: navigates to `NodeDetailScreen(node: node, targetProofGroup: groupName, targetCorollary: corollaryTitle, autoUnlockProof: true)`.
*Result*: 100% compliant with Requirement R1: **Direct 1-tap navigation focused on the exact corollary, fully expanded without extra button taps.**

---

## 5. Verification Method

To independently verify the implementation during the upcoming development phase:

1. **Unit Tests for Markdown Content Parser**:
   - Run `flutter test test/markdown_content_loader_test.dart`.
   - Add new test cases:
     - Multi-demonstration with top-level corollary sections (`## Dimostrazione: Corollario - ...`).
     - Deep-link extraction of corollary names and formulas.
2. **Widget Tests for Proof Switcher and Deep-Linking**:
   - In `test/interactive_simulation_test.dart`:
     - Test that rendering `NodeDetailScreen(node: node, targetCorollary: 'Torricelli', autoUnlockProof: true)` automatically expands the corollary card and renders `'COROLLARIO DEDOTTO'`.
     - Test that selecting proof group chips switches the visible steps cleanly.
3. **Curriculum Integrity & Coverage**:
   - Run `flutter test test/curriculum_dag_test.dart` and `flutter test test/challenger_curriculum_stress_test.dart`.
   - Verify that all 35 topics continue to have valid, identifiable corollaries with full step-by-step derivations.
4. **Full Test Suite & Static Analysis**:
   - `flutter analyze` must exit with 0 errors and 0 warnings.
   - `flutter test` must pass 100% across all 196+ tests.
