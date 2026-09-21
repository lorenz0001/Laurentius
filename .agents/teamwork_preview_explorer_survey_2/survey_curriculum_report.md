# Report: Indagine Architetturale del Curriculum e Progettazione del Modulo di Algebra Lineare (R2 & R4)

**Autore:** `teamwork_preview_explorer_survey_2`  
**Data:** 14 Settembre 2026  
**Ambito di Lavoro:** `c:\Users\catte\Desktop\Laurentius`  
**Destinatario:** Orchestrator (`teamwork_preview_orchestrator_4`) / Team Laurentius

---

## 1. Executive Summary

La presente indagine fornisce l'analisi tecnica e pedagogica approfondita per l'introduzione del nuovo settore didattico di **Algebra Lineare** in Laurentius (Brilliant-OS), in conformità con i requisiti **R2** (Modulo Didattico Fondativo di Algebra Lineare) e **R4** (Integrità Architetturale e Test Automatizzati del DAG) del mandato utente.

L'analisi dell'attuale base di codice ha evidenziato:
1. **Curriculum Attuale**: 35 file Markdown distribuiti su 5 cartelle di dominio (`arithmetic/`, `algebra/`, `geometry_trig/`, `calculus/`, `physics/`), caricati sia via `AssetManifest` che tramite fallback hardcoded in `ContentLoaderService.knownAssetPaths`.
2. **Vincoli Rigorosi del DAG**: La suite di test (`curriculum_dag_test.dart`, `challenger_curriculum_stress_test.dart`) applica regole di validazione matematico-topologica stringenti:
   - **Nodo Radice Unico**: `mat_add_01` deve rimanere l'unico nodo con grado di ingresso $0$ (`inDegree == 0`). Il primo nodo di Algebra Lineare deve necessariamente avere prerequisiti per non infrangere questa invariante.
   - **Parità Assoluta**: I prerequisiti dichiarati nel frontmatter YAML devono coincidere esattamente con la mappa `CurriculumRegistry._defaultPrerequisiteMap`.
   - **Assenza di Cicli (DAG Aciclico)**: L'algoritmo di Kahn e l'analisi SCC di Tarjan richiedono una progressione strettamente orientata e priva di cicli.
   - **Dimostrazioni Complete dei Corollari**: Ogni singolo nodo deve contenere dimostrazioni passo-passo complete, senza salti logici, contrassegnate esplicitamente da diciture `Corollario:` o `### Corollario:` sia nel titolo del passaggio che negli insight.
3. **Progettazione Sequenziale dei 5 Nodi**: È stato definito il percorso concettuale e dimostrativo di 5 nodi sequenziali ad altissimo rigore formale:
   - `lin_alg_01_tuples` (Concetto di $n$-upla ordinata e spazio $\mathbb{R}^n$)
   - `lin_alg_02_vectors` (Vettori Geometrici, Norma e Coordinate Canoniche)
   - `lin_alg_03_operations` (Operazioni Vettoriali Fondamentali e Assiomi di Spazio Vettoriale)
   - `lin_alg_04_span` (Combinazioni Lineari e Spazio Vettoriale Generato)
   - `lin_alg_05_independence` (Dipendenza e Indipendenza Lineare dei Vettori)
4. **Piano Operativo Milestone 3**: Viene fornita la specifica dettagliata dei file Markdown e le istruzioni puntuali per l'integrazione con `pubspec.yaml`, `ContentLoaderService` e il catalogo di fallback.

---

## 2. Indagine del Sistema di Contenuto Esistente

### 2.1 Distribuzione dei Contenuti
Il repository ospita attualmente 35 articoli didattici in formato Markdown (`.md`) con frontmatter YAML e corpo in puro LaTeX KaTeX-compliant, organizzati come segue:

| Cartella Dominio | Sotto-cartelle | Conteggio File | Esempi Nodi Chiave |
|---|---|:---:|---|
| `assets/content/arithmetic/` | `operations/`, root | 4 | `mat_add_01`, `mat_mul_01`, `mat_frac_01`, `mat_pow_01` |
| `assets/content/algebra/` | `quadratics/`, root | 8 | `mat_binom_01`, `mat_quad_eq_01`, `mat_parabola_01`, `mat_log_01` |
| `assets/content/geometry_trig/` | `geometry/`, `trigonometry/` | 5 | `mat_triang_01`, `mat_pythagoras_01`, `mat_trig_circ_01`, `mat_trig_add_01` |
| `assets/content/calculus/` | `limits/`, `derivatives/`, `integrals/` | 13 | `mat_limits_01`, `mat_lim_sinc_01`, `mat_deriv_def_01`, `mat_fund_calc_01` |
| `assets/content/physics/` | `circuits/`, root | 5 | `phys_kin_01`, `ele_ohm_01`, `ele_power_01`, `ele_joule_01`, `chem_ph_01` |
| **Totale Attuale** | | **35** | |

### 2.2 Dichiarazione Asset in `pubspec.yaml`
In Flutter, i file di asset non sono inclusi automaticamente in modo ricorsivo. Ogni directory contenente file `.md` deve essere registrata esplicitamente sotto `flutter: assets:`.
Attualmente `pubspec.yaml` dichiara:
```yaml
flutter:
  assets:
    - .env
    - assets/content/arithmetic/
    - assets/content/arithmetic/operations/
    - assets/content/algebra/
    - assets/content/algebra/quadratics/
    - assets/content/geometry_trig/
    - assets/content/geometry_trig/geometry/
    - assets/content/geometry_trig/trigonometry/
    - assets/content/calculus/
    - assets/content/calculus/limits/
    - assets/content/calculus/derivatives/
    - assets/content/calculus/integrals/
    - assets/content/physics/
    - assets/content/physics/circuits/
```
**Direttiva Milestone 3:** L'introduzione della directory `assets/content/linear_algebra/` richiede l'aggiunta obbligatoria della riga `- assets/content/linear_algebra/` in `pubspec.yaml`.

### 2.3 Meccanismo di Ingestione e Caching (`ContentLoaderService`)
In `lib/data/content/content_loader_service.dart`:
1. `ContentLoaderService.loadAllFromBundle()` interroga `AssetManifest.loadFromAssetBundle(rootBundle)` cercando tutti i file con percorso `assets/content/**/*.md`.
2. **Meccanismo di Fallback per Ambienti di Test Headless**: Se `AssetManifest` fallisce o è vuoto (tipico nei test unitari da terminale), il servizio fa ricorso a una lista statica costante: `knownAssetPaths` (righe 20-56).
3. **Implicazione Diretta per i Nuovi Nodi**: Se i 5 nuovi file non vengono registrati in `ContentLoaderService.knownAssetPaths`, i test headless (`test/markdown_content_loader_test.dart` e `test/challenger_curriculum_stress_test.dart`) falliranno. È tassativo aggiornare `knownAssetPaths` con i percorsi dei 5 nodi di Algebra Lineare.

### 2.4 Parsing e Struttura dei Modelli SDUI
`MarkdownContentParser.parse()` (in `lib/data/content/markdown_content_parser.dart`):
- Isola il frontmatter YAML racchiuso tra delimitatori `---`.
- Mappa i metadati su `KnowledgeNode`:
  - `id` $\to$ `serverId` (e chiave primaria Isar)
  - `title` $\to$ `title`
  - `category` $\to$ `category` (es. `"Matematica"`)
  - `subCategory` $\to$ `subCategory` (es. `"Algebra Lineare"`)
  - `prerequisites` $\to$ `tempPrerequisiteIds` (risolti poi in `IsarLinks<KnowledgeNode>`)
  - `interactive` $\to$ `InteractiveData` (con `templateType`, `unit`, `equations`, `parameters`)
- Separa il corpo del testo in:
  - `ContentBlock`: blocchi `text_markdown`, `math_latex` (`$$...$$`), e `info_box` (`> **Insight:**` / `> [!NOTE]`).
  - `ProofStep`: estratti da sezioni con heading di livello 2 (`## Dimostrazione: ...`) e livello 3 (`### 1. ...`, `### Corollario: ...`), catturando la descrizione del passaggio, l'equazione LaTeX principale e la nota di insight associata.

---

## 3. Analisi del DAG dei Prerequisiti e Test di Integrità

### 3.1 Algoritmo di Validazione DAG (`curriculum_dag_test.dart` & `challenger_curriculum_stress_test.dart`)
I test automatici implementano due algoritmi formali di teoria dei grafi:
1. **Algoritmo di Kahn (Ordinamento Topologico)**:
   - Calcola l'in-degree di ciascun nodo (numero di archi entranti, ovvero prerequisiti diretti).
   - Inizializza una coda con i nodi aventi `inDegree == 0`.
   - Estrae ciclicamente i nodi dalla coda, decrementando l'in-degree dei nodi dipendenti.
   - Condizione di successo: il numero di nodi estratti deve corrispondere esattamente alla cardinalità del grafo ($|V|$). Se rimangono nodi con `inDegree > 0`, è presente un ciclo.
2. **Algoritmo di Tarjan per le Componenti Fortemente Connesse (SCC)**:
   - Verifica tramite DFS che non esistano componenti con più di 1 nodo (nessun ciclo orientato interno).

### 3.2 Invariante Fondamentale: Il Nodo Radice Unico (`mat_add_01`)
In `test/challenger_curriculum_stress_test.dart`, riga 167:
```dart
final rootNodes = nodeIds.where((id) => inDegree[id] == 0).toList();
expect(rootNodes, equals(['mat_add_01']),
    reason: 'mat_add_01 must be the unique ultimate foundational root of the entire curriculum');
```
**Attenzione Critica**: `mat_add_01` è testato formalmente come l'**unico** nodo radice dell'intero albero della conoscenza (`inDegree == 0`).  
Di conseguenza:
- Il primo nodo del modulo di Algebra Lineare (`lin_alg_01_tuples`) **NON PUÒ** avere prerequisiti vuoti `prerequisites: []`.
- Se avesse `prerequisites: []`, l'in-degree risulterebbe $0$, portando `rootNodes` a contenere `['mat_add_01', 'lin_alg_01_tuples']` e causando il fallimento immediato del test.
- `lin_alg_01_tuples` deve quindi dichiarare come prerequisiti nodi fondativi già presenti: `mat_add_01` (proprietà algebriche, elemento neutro) e `mat_pythagoras_01` (metrica cartesiana euclidea). In questo modo, il grado di ingresso è $\ge 1$ e la radice del grafo rimane unica.

### 3.3 Parità Assoluta tra Frontmatter e `CurriculumRegistry`
In `test/challenger_curriculum_stress_test.dart`, test 3:
I prerequisiti dichiarati in ciascun file `.md` devono corrispondere **esattamente** a quelli definiti in `CurriculumRegistry._defaultPrerequisiteMap`. Qualsiasi discrepanza di un singolo ID causa il fallimento della suite.

### 3.4 Requisito di Presenza dei Corollari
In `curriculum_dag_test.dart` (riga 153) e `challenger_curriculum_stress_test.dart` (riga 90):
Ogni nodo didattico deve possedere almeno un passaggio dimostrativo in cui `step.description` o `step.insight` contenga la stringa `"corollario"` (case-insensitive), accompagnato da una rigorosa derivazione algebrica.

---

## 4. Progettazione Dettagliata dei 5 Nodi di Algebra Lineare (R2)

Di seguito viene presentata la specifica completa di ciascun nodo: identificativo, metadati, catena dei prerequisiti, trattazione teorica, enunciati di teoremi e corollari con dimostrazioni passo-passo, riquadri di insight e configurazione interattiva.

---

### 4.1 Nodo 1: `lin_alg_01_tuples`
- **File**: `assets/content/linear_algebra/lin_alg_01_tuples.md`
- **ID**: `lin_alg_01_tuples`
- **Titolo**: `"Spazio Vettoriale Rn e Concetto di n-upla Ordinata"`
- **Categoria**: `Matematica`
- **Sotto-categoria**: `Algebra Lineare`
- **Prerequisiti**: `['mat_add_01', 'mat_pythagoras_01']`
- **Motivazione Didattica**:
  Transizione intuitiva dal punto sul piano cartesiano $\mathbb{R}^2$ e nello spazio tridimensionale $\mathbb{R}^3$ alla generalizzazione astratta di $n$-upla ordinata nello spazio euclideo $n$-dimensionale $\mathbb{R}^n$. Dualità tra coordinate di un punto geometrico $P(x_1, \dots, x_n)$ e vettore posizione $\mathbf{x} = \vec{OP}$.
- **Contenuto Matematico & Definizioni**:
  Prodotto cartesiano generalizzato:
  $$\mathbb{R}^n \equiv \underbrace{\mathbb{R} \times \mathbb{R} \times \dots \times \mathbb{R}}_{n \text{ volte}} = \left\{ (x_1, x_2, \dots, x_n) \mid x_i \in \mathbb{R}, \; \forall i \in \{1, 2, \dots, n\} \right\}$$
  Relazione di uguaglianza componente per componente:
  $$(x_1, \dots, x_n) = (y_1, \dots, y_n) \iff x_i = y_i \quad \forall i \in \{1, \dots, n\}$$
- **Teorema: Metrica Euclidea e Distanza nello Spazio $\mathbb{R}^n$**:
  Estensione induttiva della metrica pitagorica dal piano cartesiano bidimensionale allo spazio $n$-dimensionale.
  - **Passaggio 1 (Ipotesi metrica in $\mathbb{R}^2$)**: Dati due punti $P_1(x_1, x_2)$ e $P_2(y_1, y_2)$, per il Teorema di Pitagora applicato al triangolo rettangolo con cateti paralleli agli assi:
    $$d_2(P_1, P_2) = \sqrt{(x_1 - y_1)^2 + (x_2 - y_2)^2}$$
  - **Passaggio 2 (Induzione a $\mathbb{R}^3$)**: Introducendo una terza coordinata ortogonale $x_3, y_3$, la distanza al quadrato è la somma della distanza piana al quadrato più il quadrato della quota:
    $$d_3^2 = d_2^2 + (x_3 - y_3)^2 = (x_1 - y_1)^2 + (x_2 - y_2)^2 + (x_3 - y_3)^2$$
  - **Passaggio 3 (Generalizzazione a $\mathbb{R}^n$)**: Per un numero arbitrario $n$ di dimensioni mutuamente ortogonali:
    $$d(\mathbf{x}, \mathbf{y}) = \sqrt{\sum_{i=1}^n (x_i - y_i)^2}$$
- **Corollario: Proprietà Assiomatiche della Metrica Euclidea**:
  - **Passaggio 1 (Non negatività e Coincidenza)**:
    Poiché $(x_i - y_i)^2 \ge 0$ per ogni termine, la sommatoria è una somma di quantità non negative, dunque $d(\mathbf{x}, \mathbf{y}) \ge 0$. Inoltre, $\sum (x_i - y_i)^2 = 0 \iff x_i - y_i = 0 \; \forall i \iff \mathbf{x} = \mathbf{y}$.
  - **Passaggio 2 (Simmetria)**:
    $$(x_i - y_i)^2 = [-(y_i - x_i)]^2 = (y_i - x_i)^2 \implies d(\mathbf{x}, \mathbf{y}) = d(\mathbf{y}, \mathbf{x})$$
  - **Passaggio 3 (Disuguaglianza Triangolare)**:
    $$d(\mathbf{x}, \mathbf{z}) \le d(\mathbf{x}, \mathbf{y}) + d(\mathbf{y}, \mathbf{z})$$
  - **Passaggio 4 (Corollario)**: La metrica euclidea trasforma $\mathbb{R}^n$ in uno spazio metrico completo.
- **Corollario: L'Elemento Neutro e l'Origine dello Spazio $\mathbb{R}^n$**:
  Esistenza e unicità dell'$n$-upla nulla $\mathbf{0} = (0, 0, \dots, 0)$, la quale funge da origine delle coordinate $O$ e da elemento neutro additivo.
- **Configurazione Interattiva**:
  ```yaml
  interactive:
    template: vector_2d
    unit: ""
    equations:
      - "sqrt(x1 * x1 + x2 * x2)"
    parameters:
      - variable: x1
        label: "Coordinata x₁"
        unit: ""
        min: -5.0
        max: 5.0
        default: 3.0
        step: 0.5
      - variable: x2
        label: "Coordinata x₂"
        unit: ""
        min: -5.0
        max: 5.0
        default: 2.0
        step: 0.5
  ```

---

### 4.2 Nodo 2: `lin_alg_02_vectors`
- **File**: `assets/content/linear_algebra/lin_alg_02_vectors.md`
- **ID**: `lin_alg_02_vectors`
- **Titolo**: `"Vettori Geometrici, Norma e Coordinate Canoniche"`
- **Categoria**: `Matematica`
- **Sotto-categoria**: `Algebra Lineare`
- **Prerequisiti**: `['lin_alg_01_tuples']`
- **Motivazione Didattica**:
  Definizione formale di segmento orientato $\vec{AB}$, vettore applicato e vettore libero (classe di equivalenza per equipollenza). I tre attributi geometrici invarianti: modulo (norma euclidea), direzione (giacitura della retta di supporto) e verso (orientamento della freccia). Scomposizione univoca lungo la base canonica ortonormale $\mathcal{E} = \{\mathbf{e}_1, \dots, \mathbf{e}_n\}$.
- **Contenuto Matematico & Definizioni**:
  Coordinate del vettore congiungente due punti $A(x_1, \dots, x_n)$ e $B(y_1, \dots, y_n)$:
  $$\vec{AB} = B - A = (y_1 - x_1, y_2 - x_2, \dots, y_n - x_n)$$
  Rappresentazione per colonna componente per componente:
  $$\mathbf{v} = \begin{pmatrix} v_1 \\ v_2 \\ \vdots \\ v_n \end{pmatrix} = \sum_{i=1}^n v_i \mathbf{e}_i$$
- **Teorema: Norma Euclidea e Scomposizione sulla Base Canonica**:
  - **Passaggio 1 (Base Canonica)**: Siano $\mathbf{e}_i = (0, \dots, 1, \dots, 0)$ con $1$ all'$i$-esima coordinata.
  - **Passaggio 2 (Scomposizione Lineare Univoca)**:
    $$\mathbf{v} = v_1 (1, 0, \dots) + v_2 (0, 1, \dots) + \dots + v_n (0, \dots, 1) = \sum_{i=1}^n v_i \mathbf{e}_i$$
  - **Passaggio 3 (Norma del Vettore)**: La lunghezza intrinseca del vettore è determinata dal Teorema di Pitagora applicato alle componenti:
    $$\|\mathbf{v}\| = \sqrt{v_1^2 + v_2^2 + \dots + v_n^2}$$
- **Corollario: Normalizzazione e Costruzione del Versore Unitario**:
  - **Passaggio 1 (Ipotesi)**: Sia dato un generico vettore non nullo $\mathbf{v} \in \mathbb{R}^n \setminus \{\mathbf{0}\}$, tale che $\|\mathbf{v}\| > 0$.
  - **Passaggio 2 (Definizione del versore)**: Moltiplichiamo il vettore per il reciproco della sua norma: $\hat{\mathbf{u}} \equiv \frac{1}{\|\mathbf{v}\|} \mathbf{v}$.
  - **Passaggio 3 (Calcolo della norma)**:
    $$\|\hat{\mathbf{u}}\| = \left\| \frac{1}{\|\mathbf{v}\|} \mathbf{v} \right\| = \left| \frac{1}{\|\mathbf{v}\|} \right| \cdot \|\mathbf{v}\| = \frac{1}{\|\mathbf{v}\|} \cdot \|\mathbf{v}\| = 1$$
  - **Passaggio 4 (Corollario: Proprietà del Versore)**: Il vettore $\hat{\mathbf{u}}$ ha norma rigorosamente unitaria, conservando inalterate la direzione e il verso di $\mathbf{v}$.
- **Corollario: Invarianza del Vettore Libero per Traslazione**:
  Dimostrazione algebrica che traslando rigidamente gli estremi $A$ e $B$ mediante un vettore di traslazione $\mathbf{t}$, il vettore libero $\vec{A'B'} = (B+\mathbf{t}) - (A+\mathbf{t}) = B - A = \vec{AB}$ rimane identico.
- **Configurazione Interattiva**:
  ```yaml
  interactive:
    template: vector_2d
    unit: ""
    equations:
      - "sqrt(vx * vx + vy * vy)"
    parameters:
      - variable: vx
        label: "Componente v_x"
        unit: ""
        min: -5.0
        max: 5.0
        default: 4.0
        step: 0.5
      - variable: vy
        label: "Componente v_y"
        unit: ""
        min: -5.0
        max: 5.0
        default: 3.0
        step: 0.5
  ```

---

### 4.3 Nodo 3: `lin_alg_03_operations`
- **File**: `assets/content/linear_algebra/lin_alg_03_operations.md`
- **ID**: `lin_alg_03_operations`
- **Titolo**: `"Operazioni Vettoriali Fondamentali e Assiomi di Spazio Vettoriale"`
- **Categoria**: `Matematica`
- **Sotto-categoria**: `Algebra Lineare`
- **Prerequisiti**: `['lin_alg_02_vectors']`
- **Motivazione Didattica**:
  Le due operazioni fondanti l'algebra lineare: somma vettoriale $+ : V \times V \to V$ e moltiplicazione per uno scalare $\cdot : \mathbb{R} \times V \to V$. Equipollenza tra la regola del parallelogramma e il metodo punta-coda. Definizione assiomatica formale degli 8 assiomi che conferiscono a $(V, +, \cdot)$ la struttura di spazio vettoriale su un campo.
- **Contenuto Matematico & Gli 8 Assiomi**:
  1. *Associatività della somma*: $(\mathbf{u} + \mathbf{v}) + \mathbf{w} = \mathbf{u} + (\mathbf{v} + \mathbf{w})$
  2. *Commutatività della somma*: $\mathbf{u} + \mathbf{v} = \mathbf{v} + \mathbf{u}$
  3. *Elemento neutro additivo*: $\exists \mathbf{0} \in V : \mathbf{v} + \mathbf{0} = \mathbf{v}$
  4. *Elemento opposto additivo*: $\forall \mathbf{v} \in V, \exists (-\mathbf{v}) \in V : \mathbf{v} + (-\mathbf{v}) = \mathbf{0}$
  5. *Distributività rispetto alla somma vettoriale*: $\lambda (\mathbf{u} + \mathbf{v}) = \lambda \mathbf{u} + \lambda \mathbf{v}$
  6. *Distributività rispetto alla somma scalare*: $(\lambda + \mu)\mathbf{v} = \lambda \mathbf{v} + \mu \mathbf{v}$
  7. *Compatibilità tra prodotti*: $(\lambda \mu)\mathbf{v} = \lambda (\mu \mathbf{v})$
  8. *Elemento neutro moltiplicativo*: $1 \cdot \mathbf{v} = \mathbf{v}$
- **Teorema: Struttura di Spazio Vettoriale di $\mathbb{R}^n$ ed Equivalenza Geometrica-Algebrica**:
  Dimostrazione passo-passo che la regola del parallelogramma sul piano proietta esattamente le somme delle singole coordinate cartesiane:
  $$\mathbf{u} + \mathbf{v} = \begin{pmatrix} u_1 \\ \vdots \\ u_n \end{pmatrix} + \begin{pmatrix} v_1 \\ \vdots \\ v_n \end{pmatrix} = \begin{pmatrix} u_1 + v_1 \\ \vdots \\ u_n + v_n \end{pmatrix}$$
- **Corollario: Annullamento del Prodotto per lo Scalare Zero ($0 \cdot \mathbf{v} = \mathbf{0}$)**:
  - **Passaggio 1 (Proprietà dello zero reale)**: Nei numeri reali vale $0 + 0 = 0$.
  - **Passaggio 2 (Moltiplicazione per il vettore)**: $(0 + 0)\mathbf{v} = 0\mathbf{v}$.
  - **Passaggio 3 (Applicazione assioma distributività scalare)**: $0\mathbf{v} + 0\mathbf{v} = 0\mathbf{v}$.
  - **Passaggio 4 (Somma dell'opposto)**: Aggiungiamo ad ambo i membri l'opposto algebrico $-(0\mathbf{v})$:
    $$(0\mathbf{v} + 0\mathbf{v}) + (-(0\mathbf{v})) = 0\mathbf{v} + (-(0\mathbf{v}))$$
  - **Passaggio 5 (Semplificazione tramite associatività e neutro)**:
    $$0\mathbf{v} + (0\mathbf{v} + (-(0\mathbf{v}))) = \mathbf{0} \implies 0\mathbf{v} + \mathbf{0} = \mathbf{0} \implies 0\mathbf{v} = \mathbf{0}$$
  - **Passaggio 6 (Corollario)**: Il prodotto tra il numero zero e qualunque vettore produce invariabilmente il vettore nullo.
- **Corollario: Identificazione dell'Opposto Vettoriale con il Fattore $-1$ ($(-1)\mathbf{v} = -\mathbf{v}$)**:
  - **Passaggio 1**: Consideriamo la somma $\mathbf{v} + (-1)\mathbf{v} = 1\mathbf{v} + (-1)\mathbf{v}$.
  - **Passaggio 2**: Raccogliendo per distributività scalare: $(1 + (-1))\mathbf{v} = 0\mathbf{v}$.
  - **Passaggio 3**: Poiché $0\mathbf{v} = \mathbf{0}$, si deduce $\mathbf{v} + (-1)\mathbf{v} = \mathbf{0}$.
  - **Passaggio 4 (Corollario)**: Per l'unicità dell'inverso additivo nel gruppo abeliano $(V, +)$, $(-1)\mathbf{v}$ coincide esattamente con l'opposto $-\mathbf{v}$.
- **Configurazione Interattiva**:
  ```yaml
  interactive:
    template: vector_2d
    unit: ""
    equations:
      - "ux + vx"
      - "uy + vy"
    parameters:
      - variable: ux
        label: "Vettore u (x)"
        min: -4.0
        max: 4.0
        default: 3.0
        step: 0.5
      - variable: uy
        label: "Vettore u (y)"
        min: -4.0
        max: 4.0
        default: 1.0
        step: 0.5
      - variable: vx
        label: "Vettore v (x)"
        min: -4.0
        max: 4.0
        default: 1.0
        step: 0.5
      - variable: vy
        label: "Vettore v (y)"
        min: -4.0
        max: 4.0
        default: 3.0
        step: 0.5
      - variable: k
        label: "Scalare k (per k·u)"
        min: -2.0
        max: 2.0
        default: 1.0
        step: 0.5
  ```

---

### 4.4 Nodo 4: `lin_alg_04_span`
- **File**: `assets/content/linear_algebra/lin_alg_04_span.md`
- **ID**: `lin_alg_04_span`
- **Titolo**: `"Combinazioni Lineari e Spazio Vettoriale Generato (Span)"`
- **Categoria**: `Matematica`
- **Sotto-categoria**: `Algebra Lineare`
- **Prerequisiti**: `['lin_alg_03_operations']`
- **Motivazione Didattica**:
  Concetto fondamentale di combinazione lineare: come vettori elementari possono combinarsi mediante pesi scalari per raggiungere qualsiasi punto nello spazio. Definizione formale di $\text{Span}(S)$ o $\mathcal{L}(S)$. Gerarchia geometrica: un vettore genera una retta passante per l'origine ($\mathbb{R}^1$), due vettori non allineati generano un piano passante per l'origine ($\mathbb{R}^2$), $k$ vettori generano un sottospazio o iperpiano $k$-dimensionale in $\mathbb{R}^n$.
- **Contenuto Matematico & Definizioni**:
  Combinazione lineare di $k$ vettori con coefficienti $c_1, \dots, c_k \in \mathbb{R}$:
  $$\mathbf{w} = c_1 \mathbf{v}_1 + c_2 \mathbf{v}_2 + \dots + c_k \mathbf{v}_k = \sum_{i=1}^k c_i \mathbf{v}_i$$
  Insieme di tutte le possibili combinazioni lineari (Spazio Generato):
  $$\text{Span}(\mathbf{v}_1, \dots, \mathbf{v}_k) \equiv \left\{ \sum_{i=1}^k c_i \mathbf{v}_i \;\middle|\; c_1, \dots, c_k \in \mathbb{R} \right\}$$
- **Teorema: Lo Spazio Generato è un Sottospazio Vettoriale**:
  Dimostrazione che $W = \text{Span}(\mathbf{v}_1, \dots, \mathbf{v}_k)$ soddisfa la definizione di sottospazio vettoriale di $V$ (chiuso rispetto alla somma e al prodotto per scalare):
  - **Passaggio 1 (Appartenenza del vettore nullo)**: Ponendo tutti i coefficienti scalari $c_i = 0$:
    $$\sum_{i=1}^k 0 \cdot \mathbf{v}_i = \mathbf{0} \implies \mathbf{0} \in W$$
  - **Passaggio 2 (Chiusura rispetto alla somma)**: Siano $\mathbf{w}_A, \mathbf{w}_B \in W$, con $\mathbf{w}_A = \sum a_i \mathbf{v}_i$ e $\mathbf{w}_B = \sum b_i \mathbf{v}_i$. Sommando:
    $$\mathbf{w}_A + \mathbf{w}_B = \sum_{i=1}^k a_i \mathbf{v}_i + \sum_{i=1}^k b_i \mathbf{v}_i = \sum_{i=1}^k (a_i + b_i) \mathbf{v}_i$$
    Poiché $(a_i + b_i) \in \mathbb{R}$, il vettore somma appartiene a $W$.
  - **Passaggio 3 (Chiusura rispetto al prodotto per scalare)**: Sia $\lambda \in \mathbb{R}$:
    $$\lambda \mathbf{w}_A = \lambda \sum_{i=1}^k a_i \mathbf{v}_i = \sum_{i=1}^k (\lambda a_i) \mathbf{v}_i \in W \quad (\lambda a_i \in \mathbb{R})$$
- **Corollario: Minimalità dello Spazio Generato**:
  Dimostrazione che $\text{Span}(S)$ è il più piccolo sottospazio vettoriale di $V$ contenente l'insieme di vettori $S$: qualunque altro sottospazio $U$ tale che $S \subseteq U$ deve necessariamente soddisfare $\text{Span}(S) \subseteq U$.
- **Corollario: Collasso Geometrico dello Span di Vettori Paralleli**:
  Se $\mathbf{v}_2 = k \mathbf{v}_1$, allora $\text{Span}(\mathbf{v}_1, \mathbf{v}_2) = \text{Span}(\mathbf{v}_1)$.
  Dimostrazione: per ogni $\mathbf{w} = c_1 \mathbf{v}_1 + c_2 \mathbf{v}_2 = c_1 \mathbf{v}_1 + c_2 (k \mathbf{v}_1) = (c_1 + k c_2)\mathbf{v}_1 = \gamma \mathbf{v}_1 \in \text{Span}(\mathbf{v}_1)$.
  Lo span collassa da un piano 2D a una retta 1D.
- **Configurazione Interattiva**:
  ```yaml
  interactive:
    template: vector_2d
    unit: ""
    equations:
      - "c1 * v1x + c2 * v2x"
      - "c1 * v1y + c2 * v2y"
    parameters:
      - variable: c1
        label: "Coefficiente c₁"
        min: -3.0
        max: 3.0
        default: 1.5
        step: 0.1
      - variable: c2
        label: "Coefficiente c₂"
        min: -3.0
        max: 3.0
        default: -1.0
        step: 0.1
  ```

---

### 4.5 Nodo 5: `lin_alg_05_independence`
- **File**: `assets/content/linear_algebra/lin_alg_05_independence.md`
- **ID**: `lin_alg_05_independence`
- **Titolo**: `"Dipendenza e Indipendenza Lineare dei Vettori"`
- **Categoria**: `Matematica`
- **Sotto-categoria**: `Algebra Lineare`
- **Prerequisiti**: `['lin_alg_04_span']`
- **Motivazione Didattica**:
  Il cardine dell'algebra lineare: stabilire quando un vettore introduce una dimensione inedita oppure rappresenta un'informazione geometrica ridondante già presente nello span dei precedenti. Definizione rigorosa di indipendenza lineare tramite combinazione lineare nulla a soli coefficienti banali. Significato geometrico nel piano (collinearità) e nello spazio (complanarità).
- **Contenuto Matematico & Definizioni**:
  Un insieme di vettori $\{\mathbf{v}_1, \dots, \mathbf{v}_k\}$ è **linearmente indipendente** se e solo se:
  $$c_1 \mathbf{v}_1 + c_2 \mathbf{v}_2 + \dots + c_k \mathbf{v}_k = \mathbf{0} \implies c_1 = c_2 = \dots = c_k = 0$$
  È **linearmente dipendente** se esiste almeno una combinazione lineare nulla con coefficienti non tutti nulli:
  $$\exists (c_1, \dots, c_k) \neq (0, \dots, 0) : \sum_{i=1}^k c_i \mathbf{v}_i = \mathbf{0}$$
- **Teorema Fondamentale della Dipendenza Lineare (Criterio della Combinazione Lineare)**:
  Un insieme di due o più vettori è linearmente dipendente se e solo se almeno uno di essi può essere espresso come combinazione lineare dei rimanenti.
  - **Dimostrazione Necessità ($\implies$)**:
    1. Per ipotesi di dipendenza: $\sum_{i=1}^k c_i \mathbf{v}_i = \mathbf{0}$ con almeno un coefficiente non nullo $c_j \neq 0$.
    2. Isolando il termine $j$-esimo: $c_j \mathbf{v}_j = -\sum_{i \neq j} c_i \mathbf{v}_i$.
    3. Poiché $c_j \neq 0$, possiamo dividere per lo scalare $c_j$:
       $$\mathbf{v}_j = \sum_{i \neq j} \left( -\frac{c_i}{c_j} \right) \mathbf{v}_i$$
       Dunque $\mathbf{v}_j$ è combinazione lineare degli altri vettori.
  - **Dimostrazione Sufficienza ($\impliedby$)**:
    1. Supponiamo che $\mathbf{v}_j = \sum_{i \neq j} a_i \mathbf{v}_i$.
    2. Riportando tutto a primo membro:
       $$\sum_{i \neq j} a_i \mathbf{v}_i + (-1)\mathbf{v}_j = \mathbf{0}$$
    3. Il coefficiente di $\mathbf{v}_j$ è $-1 \neq 0$. Esiste quindi una combinazione lineare nulla con coefficienti non tutti nulli, dimostrando la dipendenza lineare.
- **Corollario: Presenza del Vettore Nullo e Dipendenza Lineare**:
  Qualsiasi insieme di vettori che contenga il vettore nullo $\mathbf{0}$ è necessariamente linearmente dipendente.
  Dimostrazione: sia $S = \{\mathbf{0}, \mathbf{v}_2, \dots, \mathbf{v}_k\}$. Poniamo $c_1 = 1 \neq 0$ e $c_2 = \dots = c_k = 0$.
  Allora $1 \cdot \mathbf{0} + 0 \cdot \mathbf{v}_2 + \dots + 0 \cdot \mathbf{v}_k = \mathbf{0}$. Poiché $c_1 \neq 0$, il sistema è dipendente.
- **Corollario: Criterio del Determinante e Significato Geometrico in $\mathbb{R}^2$**:
  Due vettori $\mathbf{u} = (u_1, u_2)$ e $\mathbf{v} = (v_1, v_2)$ in $\mathbb{R}^2$ sono linearmente indipendenti se e solo se:
  $$\det \begin{pmatrix} u_1 & v_1 \\ u_2 & v_2 \end{pmatrix} = u_1 v_2 - u_2 v_1 \neq 0$$
  - **Passaggio 1 (Sistema omogeneo)**: $c_1 \mathbf{u} + c_2 \mathbf{v} = \mathbf{0} \iff \begin{cases} c_1 u_1 + c_2 v_1 = 0 \\ c_1 u_2 + c_2 v_2 = 0 \end{cases}$.
  - **Passaggio 2 (Eliminazione algebrica)**: Moltiplicando la prima equazione per $u_2$ e la seconda per $u_1$:
    $$c_1 u_1 u_2 + c_2 v_1 u_2 = 0 \quad \land \quad c_1 u_1 u_2 + c_2 u_1 v_2 = 0$$
  - **Passaggio 3 (Sottrazione membro a membro)**:
    $$c_2 (u_1 v_2 - u_2 v_1) = 0$$
  - **Passaggio 4 (Corollario)**: Se $u_1 v_2 - u_2 v_1 \neq 0$, necessariamente $c_2 = 0$ e di conseguenza $c_1 = 0$ (indipendenza). Geometricamente, $|u_1 v_2 - u_2 v_1|$ corrisponde all'area orientata del parallelogramma formato da $\mathbf{u}$ e $\mathbf{v}$. I vettori sono dipendenti se e solo se sono collineari (area collassata a zero).
- **Configurazione Interattiva**:
  ```yaml
  interactive:
    template: vector_2d
    unit: ""
    equations:
      - "ux * vy - uy * vx"
    parameters:
      - variable: ux
        label: "Vettore u (x)"
        min: -4.0
        max: 4.0
        default: 2.0
        step: 0.5
      - variable: uy
        label: "Vettore u (y)"
        min: -4.0
        max: 4.0
        default: 1.0
        step: 0.5
      - variable: vx
        label: "Vettore v (x)"
        min: -4.0
        max: 4.0
        default: -1.0
        step: 0.5
      - variable: vy
        label: "Vettore v (y)"
        min: -4.0
        max: 4.0
        default: 2.0
        step: 0.5
  ```

---

## 5. Specifica di Binding con il Widget Interattivo 2D

Il widget di simulazione vettoriale 2D (in fase di specifica in Milestone 1 & 2 sotto `Vector2DSimulationWidget`) si collegherà in modo puramente dichiarativo ai nodi Markdown tramite `InteractiveTemplateFactory`.

### 5.1 Alias di Template Riconosciuti
Nella factory (`interactive_template_factory.dart`), i seguenti alias saranno associati a `Vector2DSimulationWidget`:
- `vector_2d`
- `vector_simulation`
- `vector_operations`
- `vector_addition`
- `linear_combination`
- `vector_span`
- `vector_independence`

### 5.2 Modalità Operative Rilevate Automaticamente dai Parametri
Il widget interpreterà dinamicamente la modalità concettuale in base ai parametri dichiarati nel frontmatter YAML:

| Nodo | Parametri Chiave | Modalità Grafica del Canvas | Telemetria / Feedback Visivo |
|---|---|---|---|
| `lin_alg_01_tuples` | `x1`, `x2` | Punto cartesiano $P(x_1, x_2)$ con coordinate cartesiane e linee di proiezione tratteggiate agli assi | Distanza euclidea $d = \sqrt{x_1^2 + x_2^2}$ |
| `lin_alg_02_vectors` | `vx`, `vy` | Freccia orientata $\vec{v}$ dall'origine, componenti rettangolari $v_x \mathbf{e}_1$ e $v_y \mathbf{e}_2$, versore $\hat{\mathbf{v}}$ | Modulo $\|\mathbf{v}\| = \sqrt{v_x^2 + v_y^2}$ e angolo polare $\theta$ |
| `lin_alg_03_operations` | `ux`, `uy`, `vx`, `vy`, `k` | Due vettori $\mathbf{u}$ e $\mathbf{v}$, parallelogramma di completamento con lati tratteggiati, vettore somma diagonale $\mathbf{u}+\mathbf{v}$, scalato $k\mathbf{u}$ | Coordinate risultanti $(u_x+v_x, u_y+v_y)$ |
| `lin_alg_04_span` | `c1`, `c2` | Due vettori generatori $\mathbf{v}_1, \mathbf{v}_2$, vettori scalati $c_1\mathbf{v}_1$ e $c_2\mathbf{v}_2$, punto bersaglio della combinazione $\mathbf{w}$ con reticolato dinamico | Equazione vettoriale $\mathbf{w} = c_1\mathbf{v}_1 + c_2\mathbf{v}_2$ |
| `lin_alg_05_independence` | `ux`, `uy`, `vx`, `vy` | Due vettori manipolabili, area colorata del parallelogramma generato | Determinante $\Delta = u_x v_y - u_y v_x$; stato ("Indipendenti" vs "Dipendenti/Collineari") |

---

## 6. Piano di Redazione ed Esecuzione per Milestone 3

L'implementazione in Milestone 3 dovrà seguire rigidamente la seguente procedura sequenziale per garantire zero regressioni e conformità totale con i test:

### Fase 1: Configurazione Directory e `pubspec.yaml`
1. Creare la cartella `assets/content/linear_algebra/`.
2. Modificare `pubspec.yaml`, registrando sotto `flutter: assets:` la riga:
   ```yaml
       - assets/content/linear_algebra/
   ```

### Fase 2: Redazione dei 5 File Markdown Didattici
Creare i 5 file in `assets/content/linear_algebra/` con il frontmatter e la struttura descritta al punto 4:
- `lin_alg_01_tuples.md`
- `lin_alg_02_vectors.md`
- `lin_alg_03_operations.md`
- `lin_alg_04_span.md`
- `lin_alg_05_independence.md`

Tutti i file devono includere:
- Frontmatter YAML valido con campi `id`, `title`, `category: "Matematica"`, `subCategory: "Algebra Lineare"`, `prerequisites`, e blocco `interactive:`.
- Dimostrazioni algebriche complete con intestazioni `## Dimostrazione: [Titolo]` e passaggi `### [Numero]. [Descrizione]`.
- Almeno un passaggio identificato esplicitamente con `"Corollario:"` contenente una dimostrazione passo-passo priva di salti logici.
- Riquadri di intuizione profonda `> **Insight:**` a ogni passaggio.

### Fase 3: Aggiornamento dei Registri di Caching e Fallback del Codice Dart
1. In `lib/data/content/content_loader_service.dart`:
   - Aggiungere i 5 percorsi alla costante `knownAssetPaths`:
     ```dart
     'assets/content/linear_algebra/lin_alg_01_tuples.md',
     'assets/content/linear_algebra/lin_alg_02_vectors.md',
     'assets/content/linear_algebra/lin_alg_03_operations.md',
     'assets/content/linear_algebra/lin_alg_04_span.md',
     'assets/content/linear_algebra/lin_alg_05_independence.md',
     ```
2. In `lib/data/catalog/curriculum_registry.dart`:
   - Aggiungere i 5 nodi a `_defaultPrerequisiteMap`:
     ```dart
     // Algebra Lineare
     'lin_alg_01_tuples': ['mat_add_01', 'mat_pythagoras_01'],
     'lin_alg_02_vectors': ['lin_alg_01_tuples'],
     'lin_alg_03_operations': ['lin_alg_02_vectors'],
     'lin_alg_04_span': ['lin_alg_03_operations'],
     'lin_alg_05_independence': ['lin_alg_04_span'],
     ```
   - Creare o estendere il catalogo fallback in memoria (es. `LinearAlgebraCatalog.getAllNodes()` o in `AlgebraCatalog`) e collegarlo a `CurriculumRegistry.getAllNodes()`.

### Fase 4: Allineamento dei Test di Integrità e Validazione Topologica
1. In `test/markdown_content_loader_test.dart`:
   - Aggiornare i conteggi attesi dei nodi caricati da 35 a 40 (righe 560, 710, 823, 827, 862, 879, 891, 903, 905, 906).
2. In `test/challenger_curriculum_stress_test.dart`:
   - Aggiornare i conteggi attesi dei file su disco e nodi noti da 35 a 40 (righe 25, 26, 118, 187).
   - Aggiungere i nuovi template consentiti (`'vector_2d'`, ecc.) all'insieme `validTemplates` (righe 40-64).

### Fase 5: Comandi di Verifica
Eseguire la suite di verifica per confermare la piena integrità e l'assenza di cicli:
```bash
flutter analyze
flutter test test/curriculum_dag_test.dart
flutter test test/markdown_content_loader_test.dart
flutter test test/challenger_curriculum_stress_test.dart
flutter test
```

---

## 7. Tabella di Riepilogo dell'Architettura del Modulo

| ID Nodo | Titolo | Prerequisiti | In-degree | Teorema Principale | Corollario Chiave | Template Interattivo |
|---|---|---|:---:|---|---|---|
| `lin_alg_01_tuples` | Spazio Vettoriale Rn e Concetto di n-upla Ordinata | `mat_add_01`, `mat_pythagoras_01` | 2 | Metrica Euclidea in $\mathbb{R}^n$ | Proprietà assiomatiche metrica; Unicità origine $\mathbf{0}$ | `vector_2d` (punto & metrica) |
| `lin_alg_02_vectors` | Vettori Geometrici, Norma e Coordinate Canoniche | `lin_alg_01_tuples` | 1 | Scomposizione canonica e norma | Normalizzazione versore unitario; Invarianza per traslazione | `vector_2d` (modulo & direzione) |
| `lin_alg_03_operations` | Operazioni Vettoriali Fondamentali e Assiomi di Spazio Vettoriale | `lin_alg_02_vectors` | 1 | Equivalenza parallelogramma/coordinate | Annullamento $0\mathbf{v}=\mathbf{0}$; Opposto $(-1)\mathbf{v}=-\mathbf{v}$ | `vector_2d` (somma & scalare) |
| `lin_alg_04_span` | Combinazioni Lineari e Spazio Vettoriale Generato (Span) | `lin_alg_03_operations` | 1 | $\text{Span}(S)$ è sottospazio vettoriale | Minimalità dello span; Collasso di vettori collineari | `vector_2d` (span & reticolo) |
| `lin_alg_05_independence` | Dipendenza e Indipendenza Lineare dei Vettori | `lin_alg_04_span` | 1 | Criterio combinazione lineare | Inclusione vettore nullo; Determinante e area 2D | `vector_2d` (indipendenza & area) |
