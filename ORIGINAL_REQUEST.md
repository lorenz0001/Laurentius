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

## 2026-09-08T11:17:14Z

This is a single self-contained fix; keep it small and focused. Semplificare l'interfaccia utente eliminando la complessità visiva e trasformando l'applicazione Laurentius in un tema scuro (Dark Mode) ispirato all'app mobile di Wikipedia, con particolare focus sulla schermata articolo strutturata a sezioni espandibili/collassabili.

Working directory: c:\Users\catte\Desktop\Laurentius
Integrity mode: development

## Requirements

### R1. Redesign dell'articolo in stile Wikipedia Mobile (Dark Mode & Sezioni Collassabili)
Riprogettare la schermata dell'articolo (`NodeDetailScreen`) adottando l'estetica e l'usabilità tipica dell'app di Wikipedia in Dark Mode:
- Sfondo scuro/nero a contrasto pulito con tipografia nitida e leggibile.
- App bar ed elementi di navigazione minimalisti senza decorazioni ingombranti.
- Organizzazione delle macro-sezioni (Approfondimento teorico, Dimostrazione algebrica, Laboratorio/Simulazione interattiva) con sezioni pulite ed espandibili/collassabili (accordion) per favorire la consultazione focalizzata.

### R2. Tema Dark coerente su tutta l'applicazione
Estendere la palette scura e lo stile minimalista a tutti gli schermi principali:
- Grafo della conoscenza 2D (`HomeScreen` / `GraphView`), con nodi, etichette e linee di connessione visibili e gradevoli su sfondo scuro.
- Catalogo argomenti (`CategoryExplorerScreen`), con schede e chip sobrie ad alto contrasto.
- Schermata preferenze (`SettingsScreen`) e barre di navigazione (`MainLayoutScreen`).

### R3. Contrasto e leggibilità di formule LaTeX e simulazioni interattive
Assicurare che:
- Le formule matematiche inline e display renderizzate con `flutter_math_fork` abbiano colori chiari ad alta visibilità su sfondo scuro.
- I widget di simulazione interattiva (canvas `CustomPainter`, slider parametrici, controlli) mantengano leggibilità, reattività a 60fps e un design coordinato col tema scuro.

### R4. Integrità funzionale e zero regressioni
Preservare integralmente tutte le funzionalità esistenti dell'applicazione:
- Risoluzione e navigazione dei prerequisiti DAG.
- Interazione con i passaggi delle dimostrazioni e navigazione verso i corollari.
- Dialoghi e bottom sheet con AI tutor e rielaborazione del testo.
- Lancio degli esercizi di verifica.

## Acceptance Criteria

### Interfaccia e Design
- [ ] La schermata dell'articolo presenta una palette scura con struttura a sezioni collassabili/espandibili in stile Wikipedia.
- [ ] Non sono presenti sfondi bianchi residui o elementi di testo illeggibili per mancato contrasto nelle schermate dell'articolo, del grafo, del catalogo o dei componenti principali.
- [ ] Formule LaTeX (inline e a blocco) e widget interattivi risultano perfettamente contrastati e utilizzabili su sfondo scuro.

### Verifica Programmatica
- [ ] `flutter analyze` termina con 0 errori e 0 warning.
- [ ] L'intera suite di test `flutter test` passes con successo senza regressioni.

## 2026-09-14T09:56:11Z

Revisione e ottimizzazione delle animazioni e simulazioni interattive di Laurentius (eliminazione di widget/animazioni prive di utilità didattica, garanzia di reattività fluida a 60fps con controlli diretti) e creazione di un nuovo modulo fondativo di Algebra Lineare a partire dal concetto di n-upla, con standard di scrittura matematica e intuizione visiva di altissimo livello.

Working directory: c:/Users/catte/Desktop/Laurentius
Integrity mode: development

## Requirements

### R1. Audit, Semplificazione e Fix delle Simulazioni Interattive
- Ispezionare tutti i widget in `lib/presentation/widgets/interactive/` e i relativi template collegati nei nodi Markdown.
- Eliminare o sostituire comportamenti non funzionali, autoplay disorientanti e widget puramente numerici privi di intuizione geometrica o fisica (es. formule statiche senza reale interazione visuale).
- Garantire che ogni simulazione offra un controllo manuale reattivo (slider/gesture touch), rendering a 60fps su canvas e un chiaro modello concettuale (stile Brilliant.org).
- Mantenere il codice snello ed elegante: evitare file ipertrofici o duplicazione di logica matematica, preferendo astrazioni pulite e librerie sicure ove consentano di risparmiare codice ("meno codice, maggiore espressività").

### R2. Modulo Didattico Fondativo di Algebra Lineare
- Introdurre il nuovo settore didattico di Algebra Lineare in `assets/content/linear_algebra/` (o sotto `algebra/`), registrando il percorso in `pubspec.yaml`.
- Articolare il percorso didattico in almeno 5 nodi sequenziali ad altissima cura espositiva e rigore formale:
  1. **Concetto di $n$-upla ordinata e spazio $\mathbb{R}^n$**: dalle coppie e terne ordinate alla generalizzazione a $n$ dimensioni, significato algebrico e geometrico.
  2. **Vettori Geometrici e Coordinate**: vettore applicato, modulo, direzione, verso e rappresentazione per componenti rispetto alla base canonica.
  3. **Operazioni Vettoriali Fondamentali**: somma di vettori (regola del parallelogramma e punta-coda) e moltiplicazione per uno scalare con relative proprietà assiomatiche.
  4. **Combinazioni Lineari e Spazio Generato ($\text{span}$)**: definizione, interpretazione geometrica di retta, piano e iperpiano generati.
  5. **Dipendenza e Indipendenza Lineare**: definizione formale, condizione di annullamento a coefficienti non nulli, significato geometrico (vettori collineari/complanari).
- Ogni articolo deve includere: frontmatter YAML valido con prerequisiti, passaggi algebrici senza salti logici, riquadri `> **Insight:**` per l'intuizione profonda, e teoremi/corollari ben identificati.

### R3. Visualizzazione Interattiva per l'Algebra Lineare
- Fornire un widget interattivo 2D dedicato (o integrazione in canvas cartesiano) per manipolare vettori sul piano:
  - Spostamento interattivo dei vettori o variazione dei coefficienti scalari tramite slider/gesture.
  - Visualizzazione in tempo reale della regola del parallelogramma / somma vettoriale e della combinazione lineare $c_1 \mathbf{v}_1 + c_2 \mathbf{v}_2$.

### R4. Integrità Architetturale e Test Automatizzati
- La struttura dei prerequisiti tra i nuovi nodi e i nodi esistenti deve formare un Grafo Aciclico Diretto (DAG) privo di cicli.
- I nuovi file `.md` devono essere caricati correttamente dal `ContentLoaderService` offline in Isar Database.
- Il codice deve superare `flutter analyze` senza errori né warning e tutti i test di `flutter test` devono avere esito positivo (inclusi test per i nuovi contenuti e per le simulazioni).

## Acceptance Criteria

### Interactive Simulations
- [ ] Nessun widget interattivo presenta crash, loop di render a vuoto o autoplay caotico incontrollabile.
- [ ] I widget interattivi collegati agli articoli rispondono a gesti/slider aggiornando visualmente la rappresentazione geometrica a 60fps.
- [ ] Le visualizzazioni prive di senso pedagogico sono state sostituite da rappresentazioni grafiche concrete o rimosse dai template attivi.

### Linear Algebra Curriculum
- [ ] Sono presenti i 5 articoli didattici completi che coprono la progressione da $n$-upla a indipendenza lineare.
- [ ] Tutti i passaggi algebrici e le definizioni nei file `.md` utilizzano LaTeX corretto (`$...$` e `$$...$$`) e non contengono salti logici non dimostrati.
- [ ] È attivo e funzionante il widget visuale per esplorare vettori, somma vettoriale e combinazioni lineari.

### Code Quality & Verification
- [ ] `flutter analyze` restituisce 0 errori e 0 warning.
- [ ] `flutter test test/curriculum_dag_test.dart` conferma che il DAG è rigorosamente aciclico.
- [ ] `flutter test test/markdown_content_loader_test.dart` e l'intera suite `flutter test` superano tutti i test con codice di uscita 0.


