# Curriculum & Corollaries Exhaustive Audit Report (Requirement R2)

**Auditor Archetype**: Curriculum & Corollaries Explorer / Auditor  
**Working Directory**: `c:\Users\catte\Desktop\Laurentius\.agents\teamwork_preview_explorer_survey_1`  
**Date/Timestamp**: 2026-09-08T00:15:00Z  
**Scope**: All 35 curriculum topics across `arithmetic`, `algebra`, `calculus` (limits, derivatives, integrals), `geometry_trig` (geometry, trigonometry), and `physics` (circuits, mechanics, physical chemistry).

---

## 1. Observation

### 1.1 Curriculum Census & Distribution
An automated recursive traversal and parse of `assets/content/` was executed using Dart 3.13.2 against `MarkdownContentParser` (`audit_data.json`). Exactly 35 Markdown educational articles exist in the repository, distributed across 5 major subject domains:

| Category Directory | Subdirectories | Files Count | Topics IDs |
|---|---|:---:|---|
| `assets/content/arithmetic/` | `operations/` (2), root (2) | 4 | `mat_frac_01`, `mat_pow_01`, `mat_add_01`, `mat_mul_01` |
| `assets/content/algebra/` | `quadratics/` (5), root (3) | 8 | `mat_binom_01`, `mat_log_01`, `mat_parabola_01`, `mat_quad_eq_01`, `mat_quad_monomia_01`, `mat_quad_pura_01`, `mat_quad_spuria_01`, `mat_quad_viete_01` |
| `assets/content/calculus/` | `limits/` (6), `derivatives/` (3), `integrals/` (4) | 13 | `mat_limits_01`, `mat_lim_sinc_01`, `mat_lim_cos_01`, `mat_lim_exp_01`, `mat_lim_log_01`, `mat_lim_e_01`, `mat_deriv_def_01`, `mat_deriv_rules_01`, `mat_deriv_theorems_01`, `mat_riemann_01`, `mat_fund_calc_01`, `mat_integ_parts_01`, `mat_integ_subst_01` |
| `assets/content/geometry_trig/` | `geometry/` (2), `trigonometry/` (3) | 5 | `mat_pythagoras_01`, `mat_triang_01`, `mat_trig_circ_01`, `mat_trig_add_01`, `mat_trig_triang_01` |
| `assets/content/physics/` | `circuits/` (3), root (2) | 5 | `phys_kin_01`, `ele_ohm_01`, `ele_power_01`, `ele_joule_01`, `chem_ph_01` |
| **Total Curriculum** | **9 Subdirectories** | **35 Topics** | **35 Markdown Articles** |

### 1.2 Mathematical Rigor Audit: Corollaries Status
Every single topic contains at least one step mentioning `"Corollario"`, satisfying the superficial string-matching test in `test/curriculum_dag_test.dart` (line 153). However, our exhaustive inspection of all 52 corollary occurrences revealed a **100% failure rate** against Requirement R2 ("Complete, Unabridged Proofs for All Corollaries"):

- **Topics with multi-step algebraic demonstrations for Corollaries**: **0 / 35 (0.0%)**
- **Topics where Corollaries merely state the final formula in a single concluding step**: **35 / 35 (100.0%)**
- **Total Corollaries identified in curriculum**: **52**
  - Stated as single final step (`### N. Corollario: ...`): **52**
  - Having explicit intermediate algebraic substitutions/expansions: **0**
  - Bundling multiple disparate theorems into a single equation line: **14**

### 1.3 Verbatim Evidence of Systematic Shortcuts
Below are direct quotations from current curriculum files demonstrating the complete omission of intermediate algebraic derivations:

1. **`assets/content/physics/phys_kin_01.md` (Lines 58–64)**:
   ```markdown
   ### 4. Sostituzione di t nella legge oraria dello spostamento
   $$\Delta x = v_0 \left(\frac{v - v_0}{a}\right) + \frac{1}{2} a \left(\frac{v - v_0}{a}\right)^2$$
   > **Insight:** Espansione del quadrato di binomio e somma a denominatore comune 2a.

   ### 5. Corollario: Formula Senza Tempo di Torricelli
   $$v^2 = v_0^2 + 2 a \Delta x$$
   > **Insight:** Collega direttamente la velocità finale allo spazio percorso senza necessità di misurare il tempo.
   ```
   *Deficiency*: The expansion of $(v-v_0)^2 = v^2 - 2v v_0 + v_0^2$, multiplication by $2a$, cancellation of $2v v_0$, and isolation of $v^2$ are completely omitted from the proof steps and only hinted at in an insight callout.

2. **`assets/content/algebra/mat_binom_01.md` (Lines 57–60)**:
   ```markdown
   ### 4. Corollario: Somma e Differenza di Cubi e Binomio di Newton
   $$a^3 \pm b^3 = (a \pm b)(a^2 \mp a b + b^2) \quad \land \quad (a+b)^n = \sum_{k=0}^n \binom{n}{k} a^{n-k} b^k$$
   > **Insight:** Permette di scomporre istantaneamente polinomi di terzo grado e sviluppare potenze ennesime.
   ```
   *Deficiency*: Two monumental algebraic theorems (sum/difference of cubes factorization and Newton's Binomial Expansion) are bundled into a single step with zero algebraic multiplication, zero Pascal/Tartaglia identity derivation, and zero proof steps.

3. **`assets/content/algebra/mat_log_01.md` (Lines 55–58)**:
   ```markdown
   ### 4. Corollario: Formula del Cambiamento di Base
   $$\log_a(x) = \frac{\log_b(x)}{\log_b(a)} = \frac{\ln(x)}{\ln(a)}$$
   > **Insight:** Consente di calcolare qualsiasi logaritmo usando la base naturale (e) o decimale (10), essenziale in chimica e fisica.
   ```
   *Deficiency*: States the formula without any of the standard 4 algebraic steps ($y = \log_a x \iff a^y = x \implies \log_b(a^y) = \log_b x \implies y \log_b a = \log_b x \implies y = \dots$).

4. **`assets/content/calculus/derivatives/mat_deriv_rules_01.md` (Lines 44–47)**:
   ```markdown
   ### 4. Corollario: Derivata delle Potenze, Quoziente e Regola della Catena
   $$(x^n)' = n x^{n-1}, \quad \left(\frac{f}{g}\right)' = \frac{f'g - f g'}{g^2}, \quad [f(g(x))]' = f'(g(x)) \cdot g'(x)$$
   > **Insight:** Permette di derivare qualsiasi funzione composta algebrica, trigonometrica ed esponenziale.
   ```
   *Deficiency*: Three cornerstone differential calculus rules are crammed into a single step without a single line of derivation (power rule via binomial/induction, quotient rule via reciprocal and Leibniz, chain rule via composite limit).

5. **`assets/content/calculus/limits/mat_lim_sinc_01.md` (Lines 67–70)**:
   ```markdown
   ### 5. Corollario: Limite Notevole della Tangente e Frequenza k
   $$\lim_{x \to 0} \frac{\tan x}{x} = \lim_{x \to 0} \left(\frac{\sin x}{x} \cdot \frac{1}{\cos x}\right) = 1 \cdot 1 = 1 \quad \land \quad \lim_{x \to 0} \frac{\sin(kx)}{x} = k$$
   > **Insight:** Moltiplicando e dividendo per la costante k, la rapidità di variazione dell'angolo scala linearmente il limite nell'origine.
   ```
   *Deficiency*: Squeezes two distinct limit corollaries into an inline statement without expanding the change of variables $u = kx$.

6. **`assets/content/geometry_trig/trigonometry/mat_trig_circ_01.md` (Lines 39–42)**:
   ```markdown
   ### 4. Corollario: Definizione di Tangente e Relazione Fondamentale Secondaria
   $$\tan\theta \equiv \frac{\sin\theta}{\cos\theta} \implies 1 + \tan^2\theta = \frac{1}{\cos^2\theta}$$
   > **Insight:** Dividendo l'identità fondamentale per cos²θ si ottiene la relazione diretta tra tangente e coseno.
   ```
   *Deficiency*: Jumps from implication to result without showing the term-by-term division $\frac{\sin^2\theta}{\cos^2\theta} + \frac{\cos^2\theta}{\cos^2\theta} = \frac{1}{\cos^2\theta}$.

7. **`assets/content/physics/circuits/ele_power_01.md` (Lines 58–61)**:
   ```markdown
   ### 3. Corollario: Formule di Potenza per Carichi Resistivi
   $$P = R \cdot I^2 = \frac{V^2}{R}$$
   > **Insight:** Ottenute sostituendo la Legge di Ohm V = R*I; governano il dimensionamento dei componenti in Watt (W).
   ```
   *Deficiency*: Omits the two separate substitution branches from $P = V \cdot I$ ($V = RI \implies P = RI^2$ and $I = V/R \implies P = V^2/R$).

### 1.4 Parser & Widget Architectural Observations
Inspection of `lib/data/content/markdown_content_parser.dart` and `lib/presentation/widgets/algebraic_proof_widget.dart` reveals how proofs are processed:
1. **Section Discovery**: `MarkdownContentParser._parseBody` uses:
   `final demoRegex = RegExp(r'^##\s+Dimostrazione.*$', caseSensitive: false, multiLine: true);`
   and splits sections via:
   `proofPart.split(RegExp(r'(?=^##\s+Dimostrazione)', caseSensitive: false, multiLine: true));`
2. **Sub-Proof Grouping**: When a heading begins with `## Dimostrazione: [Name]`, the string after `:` is parsed as `groupName`. Each step becomes `ProofStep()..description = '[$groupName] $headerLine'`.
3. **Interactive Selector**: In `AlgebraicProofWidget`, `_groups` extracts all distinct `[groupName]` values and displays horizontal `FilterChip` buttons. Clicking a chip isolates the steps of that demonstration.
4. **Corollary Highlighting**: `AlgebraicProofWidget._buildProofStepCard` detects:
   `cleanDesc.trim().toLowerCase().startsWith('corollario') || cleanDesc.toLowerCase().contains('corollario:')`
   and renders a prominent amber card with a `COROLLARIO DEDOTTO` badge and gold border.
5. **Sub-level Ingestion Caveat**: The parser splits steps strictly on `RegExp(r'(?=^###\s+)', multiLine: true)`. If an author uses `#### Dimostrazione del Corollario` without updating the parser, the `####` lines will NOT be recognized as steps and will be ignored or merged into text.

---

## 2. Logic Chain

```
[Observation 1: 35 Markdown files in assets/content/]
                  │
                  ▼
[Observation 2: 100% of Corollaries are currently written as the single final step of the main proof]
                  │
                  ▼
[Observation 3: 0 of 35 files contain intermediate algebraic derivations for Corollaries]
                  │
                  ▼
[Inference A: Every Corollary is currently an unproven assertion violating Requirement R2]
                  │
                  ▼
[Observation 4: MarkdownContentParser natively groups '## Dimostrazione: [GroupName]']
                  │
                  ▼
[Inference B: Structuring Corollaries as dedicated '## Dimostrazione: Corollario - [Nome]'
               sections creates independent, multi-step proofs without requiring breaking changes]
                  │
                  ▼
[Observation 5: AlgebraicProofWidget renders FilterChips for groups and amber badges for corollaries]
                  │
                  ▼
[Conclusion: Full R2 compliance requires upgrading all 35 files so that Corollaries
             are expanded into multi-step mathematical demonstrations (3-5 steps each)
             with explicit algebraic substitutions, identities, and intermediate simplifications]
```

### Logical Step Trace:
1. **Hypothesis vs Formula**: A mathematical corollary is a proposition that follows with little or no difficulty from a previously established theorem. However, "little difficulty" does not mean zero intermediate steps. In an educational OS designed for university and engineering students (Brilliant-OS), skipping steps obscures the logical bridge between theorem and application.
2. **Current State**: Torricelli's formula, Newton-Leibniz, Heron's formula, the change of base formula, De L'Hôpital's rule, and the law of cosines reduction are currently presented as bare final equations. A student reading `phys_kin_01.md` cannot see *how* $(v-v_0)^2$ yields $v^2 - v_0^2 = 2a\Delta x$.
3. **Architectural Feasibility**: Because `MarkdownContentParser` already supports multiple `## Dimostrazione: ...` blocks per file and groups them into tabs in `AlgebraicProofWidget`, converting single-line corollaries into dedicated 3–5 step demonstrations with explicit algebraic intermediate formulas will automatically populate the UI with selectable proof tabs.
4. **Searchability (R1/R3)**: With explicit `[Corollario - Nome]` demonstration groups and dedicated step descriptions, the Spotlight Search engine will be able to index and deep-link directly into individual corollary derivations with 1 tap.

---

## 3. Caveats

1. **Read-Only Scope**: In compliance with the subagent role constraints, no changes were directly written to `assets/content/` or `lib/`. Concrete replacement templates have been generated in this report for the remediation team.
2. **Flutter Test Sensitivity**: Some existing unit tests (e.g. `test/markdown_content_loader_test.dart` lines 140–150) make exact index assertions on `node.algebraicProof` for specific mock files (e.g. `node.algebraicProof[2].description!.contains('Corollario')`). Updating files must preserve or gracefully update these test expectations.
3. **Parser Recognition**: If the team adopts `#### Dimostrazione del Corollario` instead of `## Dimostrazione: Corollario - [Nome]`, `markdown_content_parser.dart` must be patched to recognize `####` headers. Using `## Dimostrazione: Corollario - [Nome]` works immediately out of the box with zero Dart changes.

---

## 4. Comprehensive Audit & Topic-by-Topic Inventory (35 Topics)

Below is the complete, exhaustive audit of all 35 curriculum topics, detailing current corollary status, missing corollaries, and expansion requirements.

---

### Category: Aritmetica (4 Topics)

#### 1. `assets/content/arithmetic/operations/mat_add_01.md`
- **ID**: `mat_add_01`
- **Title**: Addizione e Struttura Algebrica
- **Category**: Matematica / Aritmetica e Fondamenti
- **Prerequisites**: None (Foundational root)
- **Current Theorems**: Assiomi di Gruppo Abeliano $(\mathbb{R}, +)$.
- **Existing Corollaries**:
  - `### 4. Corollario: Unicità dell'opposto e definizione di Sottrazione` (Line 55)
  - Formula: `$$a - b \equiv a + (-b)$$`
- **Current Status**: **FAIL (Formula Only)**. Asserts uniqueness without proving why two hypothetical opposites $b_1, b_2$ must coincide.
- **Missing Corollaries**:
  - *Legge di Cancellazione per l'Addizione*: $a + c = b + c \implies a = b$.
  - *Opposto dell'Opposto*: $-(-a) = a$.
- **Required Expansion**:
  - Create `## Dimostrazione: Corollario - Unicità dell'Elemento Opposto e Definizione di Sottrazione`.
  - Step 1 (Ipotesi per assurdo): Siano $b_1$ e $b_2$ due elementi opposti di $a$: $a + b_1 = 0$ e $a + b_2 = 0$.
  - Step 2 (Proprietà dell'elemento neutro): $b_1 = b_1 + 0 = b_1 + (a + b_2)$.
  - Step 3 (Associatività e commutatività): $(b_1 + a) + b_2 = (a + b_1) + b_2 = 0 + b_2 = b_2 \implies b_1 = b_2$.
  - Step 4 (Corollario e Definizione di Sottrazione): L'opposto è unico ed è denotato con $-a$; la sottrazione è l'operazione derivata $a - b \equiv a + (-b)$.

#### 2. `assets/content/arithmetic/operations/mat_mul_01.md`
- **ID**: `mat_mul_01`
- **Title**: Moltiplicazione e Proprietà Distributiva
- **Category**: Matematica / Aritmetica e Fondamenti
- **Prerequisites**: `[mat_add_01]`
- **Current Theorems**: Assiomi dell'anello $(\mathbb{R}, +, \cdot)$ e proprietà distributiva.
- **Existing Corollaries**:
  - `### 4. Corollario: Regola dei Segni e Legge di Annullamento del Prodotto` (Line 51)
  - Formula: `$$(-a) \cdot (-b) = + (a \cdot b) \quad \land \quad (a \cdot b = 0 \iff a = 0 \lor b = 0)$$`
- **Current Status**: **FAIL (Formula Only)**. Bundles two massive distinct theorems into one step without any derivations.
- **Missing Corollaries**:
  - *Assorbimento dello Zero*: $a \cdot 0 = 0$.
  - *Prodotto per l'inverso*: $(a \cdot b)^{-1} = a^{-1} \cdot b^{-1}$.
- **Required Expansion**:
  - Split into two dedicated demonstration sections:
    1. `## Dimostrazione: Corollario - Regola dei Segni per Numeri Relativi`:
       - Step 1: $a \cdot 0 = a \cdot (b + (-b)) = ab + a(-b) = 0 \implies a(-b) = -(ab)$.
       - Step 2: $0 \cdot (-b) = (a + (-a)) \cdot (-b) = a(-b) + (-a)(-b) = 0$.
       - Step 3: Sostituzione: $-(ab) + (-a)(-b) = 0$.
       - Step 4: Corollario: $(-a)(-b) = +(ab)$.
    2. `## Dimostrazione: Corollario - Legge di Annullamento del Prodotto`:
       - Step 1: Sia $a \cdot b = 0$ con $a \neq 0$.
       - Step 2: Esistenza di $a^{-1}$: moltiplicando a sinistra $a^{-1}(ab) = a^{-1} \cdot 0 = 0$.
       - Step 3: Associatività: $(a^{-1}a)b = 1 \cdot b = b = 0$.
       - Step 4: Corollario: $a \cdot b = 0 \iff a = 0 \lor b = 0$.

#### 3. `assets/content/arithmetic/mat_frac_01.md`
- **ID**: `mat_frac_01`
- **Title**: Frazioni, Rapporti e Numeri Razionali
- **Category**: Matematica / Frazioni e Rapporti
- **Prerequisites**: `[mat_add_01, mat_mul_01]`
- **Current Theorems**: Costruzione del campo quoziente $\mathbb{Q}$ e inverso moltiplicativo.
- **Existing Corollaries**:
  - `### 4. Corollario: Proprietà Invariantiva e Semplificazione di Frazioni` (Line 52)
  - Formula: `$$\frac{a \cdot k}{b \cdot k} = \frac{a}{b} \quad (k \neq 0)$$`
- **Current Status**: **FAIL (Formula Only)**. No derivation showing factorization via reciprocal product.
- **Missing Corollaries**:
  - *Reciproco di una Frazione (Divisione)*: $\frac{a}{b} / \frac{c}{d} = \frac{a}{b} \cdot \frac{d}{c}$.
  - *Prodotto in Croce per l'Equivalenza*: $\frac{a}{b} = \frac{c}{d} \iff ad = bc$.
- **Required Expansion**:
  - Create `## Dimostrazione: Corollario - Proprietà Invariantiva e Semplificazione di Frazioni`:
    - Step 1: Scrittura mediante inverso moltiplicativo: $\frac{ak}{bk} = (a \cdot k) \cdot (b \cdot k)^{-1}$.
    - Step 2: Proprietà distributiva dell'inverso su prodotto: $(b \cdot k)^{-1} = b^{-1} \cdot k^{-1}$.
    - Step 3: Associatività e commutatività: $(a \cdot b^{-1}) \cdot (k \cdot k^{-1}) = \frac{a}{b} \cdot 1$.
    - Step 4: Corollario: $\frac{ak}{bk} = \frac{a}{b}$.

#### 4. `assets/content/arithmetic/mat_pow_01.md`
- **ID**: `mat_pow_01`
- **Title**: Potenze, Radici ed Esponenti Reali
- **Category**: Matematica / Potenze e Radicali
- **Prerequisites**: `[mat_mul_01, mat_frac_01]`
- **Current Theorems**: Leggi fondamentali degli esponenti interi e razionali.
- **Existing Corollaries**:
  - `### 4. Corollario: Esponenti Frazionari ed Equivalenza con i Radicali` (Line 51)
  - Formula: `$$a^{\frac{m}{n}} = \sqrt[n]{a^m} \quad (a > 0, n \in \mathbb{N}^*)$$`
- **Current Status**: **FAIL (Formula Only)**. Asserts radical equivalence without proving consistency with power of a power.
- **Missing Corollaries**:
  - *Esponente Negativo e Reciproco*: $a^{-n} = \frac{1}{a^n}$.
  - *Prodotto di Radicali con Indice Comune*: $\sqrt[n]{a} \cdot \sqrt[n]{b} = \sqrt[n]{ab}$.
- **Required Expansion**:
  - Create `## Dimostrazione: Corollario - Esponenti Frazionari ed Equivalenza con i Radicali`:
    - Step 1: Postulazione della legge della potenza di potenza per esponenti razionali: $(a^{m/n})^n = a^{(m/n) \cdot n}$.
    - Step 2: Semplificazione algebrica dell'esponente: $\frac{m}{n} \cdot n = m \implies (a^{m/n})^n = a^m$.
    - Step 3: Definizione algebrica di radice ennesima: se $x^n = Y$ (con $x, Y > 0$), allora $x = \sqrt[n]{Y}$.
    - Step 4: Corollario: Ponendo $x = a^{m/n}$ e $Y = a^m$, segue $a^{m/n} = \sqrt[n]{a^m}$.

---

### Category: Algebra (8 Topics)

#### 5. `assets/content/algebra/mat_binom_01.md`
- **ID**: `mat_binom_01`
- **Title**: Prodotti Notevoli e Scomposizioni
- **Category**: Matematica / Polinomi e Prodotti Notevoli
- **Prerequisites**: `[mat_mul_01, mat_pow_01]`
- **Current Theorems**: Quadrato e cubo di binomio, differenza di quadrati.
- **Existing Corollaries**:
  - `### 4. Corollario: Somma e Differenza di Cubi e Binomio di Newton` (Line 57)
  - Formula: `$$a^3 \pm b^3 = (a \pm b)(a^2 \mp a b + b^2) \quad \land \quad (a+b)^n = \sum_{k=0}^n \binom{n}{k} a^{n-k} b^k$$`
- **Current Status**: **FAIL (Formula Only & Bundled)**. Completely lacks intermediate expansions for both identities.
- **Missing Corollaries**:
  - *Quadrato di Trinomio*: $(a+b+c)^2 = a^2 + b^2 + c^2 + 2ab + 2ac + 2bc$.
  - *Identità di Sophie Germain*: $a^4 + 4b^4 = (a^2 - 2ab + 2b^2)(a^2 + 2ab + 2b^2)$.
- **Required Expansion**:
  - Split into:
    1. `## Dimostrazione: Corollario - Scomposizione di Somma e Differenza di Cubi`:
       - Step 1: Prodotto algebrico $(a \pm b)(a^2 \mp ab + b^2)$.
       - Step 2: Proprietà distributiva: $a^3 \mp a^2b + ab^2 \pm a^2b - ab^2 \pm b^3$.
       - Step 3: Elisione dei termini misti opposti: $(\mp a^2b \pm a^2b) + (ab^2 - ab^2) = 0$.
       - Step 4: Corollario: $a^3 \pm b^3 = (a \pm b)(a^2 \mp ab + b^2)$.
    2. `## Dimostrazione: Corollario - Teorema del Binomio di Newton`:
       - Step 1: Espansione di $n$ fattori $(a+b)(a+b)\cdots(a+b)$.
       - Step 2: Scelta combinatoria di $k$ fattori $b$ tra gli $n$ disponibili: $\binom{n}{k}$.
       - Step 3: Somma su tutti i gradi possibili da $k=0$ a $n$.
       - Step 4: Corollario: $(a+b)^n = \sum_{k=0}^n \binom{n}{k} a^{n-k}b^k$.

#### 6. `assets/content/algebra/mat_log_01.md`
- **ID**: `mat_log_01`
- **Title**: Logaritmi ed Esponenziali
- **Category**: Matematica / Funzioni Esponenziali e Logaritmiche
- **Prerequisites**: `[mat_pow_01]`
- **Current Theorems**: Definizione di logaritmo come inversa dell'esponenziale, logaritmo del prodotto e della potenza.
- **Existing Corollaries**:
  - `### 4. Corollario: Formula del Cambiamento di Base` (Line 55)
  - Formula: `$$\log_a(x) = \frac{\log_b(x)}{\log_b(a)} = \frac{\ln(x)}{\ln(a)}$$`
- **Current Status**: **FAIL (Formula Only)**. No intermediate steps.
- **Missing Corollaries**:
  - *Inversione della Base*: $\log_a(b) = \frac{1}{\log_b(a)}$.
  - *Esponenziale con Base Logaritmica*: $a^{\log_b(c)} = c^{\log_b(a)}$.
- **Required Expansion**:
  - Create `## Dimostrazione: Corollario - Formula del Cambiamento di Base nei Logaritmi`:
    - Step 1: Variabile ausiliaria $y = \log_a(x) \iff a^y = x$.
    - Step 2: Applicazione del logaritmo in base $b$ ad ambo i membri: $\log_b(a^y) = \log_b(x)$.
    - Step 3: Proprietà della potenza nel logaritmo: $y \cdot \log_b(a) = \log_b(x)$.
    - Step 4: Corollario: Isolamento di $y$: $\log_a(x) = \frac{\log_b(x)}{\log_b(a)}$ (e per $b=e$, $\frac{\ln x}{\ln a}$).

#### 7. `assets/content/algebra/mat_parabola_01.md`
- **ID**: `mat_parabola_01`
- **Title**: Funzione Quadratica e Parabola
- **Category**: Matematica / Funzioni e Geometria Analitica
- **Prerequisites**: `[mat_binom_01]`
- **Current Theorems**: Forma canonica $y = ax^2 + bx + c$, completamento del quadrato.
- **Existing Corollaries**:
  - `### 3. Corollario: Coordinate del Vertice, Asse di Simmetria e Fuoco` (Line 57)
  - Formula: `$$V = \left(-\frac{b}{2a}, -\frac{\Delta}{4a}\right), \quad x = -\frac{b}{2a}, \quad F = \left(-\frac{b}{2a}, \frac{1-\Delta}{4a}\right)$$`
- **Current Status**: **FAIL (Formula Only)**. Bundles vertex, axis, and focus without geometric or algebraic derivation of $F$ or directrix.
- **Missing Corollaries**:
  - *Equazione della Direttrice*: $d: y = -\frac{1+\Delta}{4a}$.
  - *Distanza Focale*: $f = \frac{1}{4a}$.
- **Required Expansion**:
  - Create `## Dimostrazione: Corollario - Determinazione del Vertice e del Fuoco dalla Definizione Geometrica`:
    - Step 1: Forma traslata $y + \frac{\Delta}{4a} = a\left(x + \frac{b}{2a}\right)^2$.
    - Step 2: Riconoscimento del punto stazionario di minimo/massimo quando il termine quadratico si annulla ($x = -b/(2a)$).
    - Step 3: Luogo geometrico dei punti equidistanti da fuoco $F(x_F, y_F)$ e direttrice $y = d$: $(x - x_F)^2 + (y - y_F)^2 = (y - d)^2$.
    - Step 4: Corollario: Confronto dei coefficienti e identificazione di $V(-b/(2a), -\Delta/(4a))$, $F(-b/(2a), (1-\Delta)/(4a))$ e asse $x = -b/(2a)$.

#### 8. `assets/content/algebra/quadratics/mat_quad_eq_01.md`
- **ID**: `mat_quad_eq_01`
- **Title**: Equazione di Secondo Grado Completa & Formula Risolutiva
- **Category**: Matematica / Equazioni di Secondo Grado
- **Prerequisites**: `[mat_binom_01, mat_parabola_01]`
- **Current Theorems**: Risoluzione per completamento del quadrato, formula ridotta, interpretazione geometrica del discriminante.
- **Existing Corollaries**:
  - `### 4. Corollario: La Celebre Formula Quadratica Risolutiva` (Line 71)
  - `### 4. Corollario: Formula Ridotta e Discriminante Ridotto (Delta/4)` (Line 89)
  - `### 3. Corollario: Posizioni Reciproche tra Parabola e Asse delle Ascisse` (Line 103)
- **Current Status**: **PARTIAL / MIXED**. Has 3 demonstrations, but the concluding steps jump straight to formula summaries.
- **Missing Corollaries**:
  - *Formula Ridottissima (per $a=1, b$ pari)*: $x = -\frac{b}{2} \pm \sqrt{(\frac{b}{2})^2 - c}$.
  - *Somma e Prodotto delle Radici direttamente da $\Delta$*.
- **Required Expansion**:
  - Expand `Formula Ridotta`: Step 3 shows factoring 4 as 2 outside radical, but Step 4 must show explicit fraction simplification $\frac{2(-\beta \pm \sqrt{\Delta/4})}{2a} = \frac{-\beta \pm \sqrt{\Delta/4}}{a}$.
  - Add explicit demonstration for `Formula Ridottissima` when $a=1$.

#### 9. `assets/content/algebra/quadratics/mat_quad_monomia_01.md`
- **ID**: `mat_quad_monomia_01`
- **Title**: Equazioni di Secondo Grado Monomie
- **Category**: Matematica / Equazioni di Secondo Grado
- **Prerequisites**: `[mat_quad_eq_01]`
- **Current Theorems**: Risoluzione di $ax^2 = 0$.
- **Existing Corollaries**:
  - `### 3. Corollario: Molteplicità Algebrica e Tangenza nell'Origine` (Line 43)
  - Formula: `$$x_1 = x_2 = 0 \iff x = 0 \text{ con molteplicità algebrica } \mu = 2$$`
- **Current Status**: **FAIL (Formula Only)**.
- **Missing Corollaries**:
  - *Comportamento del Segno del Monomio*: $ax^2 \ge 0$ per $a>0$ con unico zero in $x=0$.
- **Required Expansion**:
  - Step 1: Scomposizione in fattori lineari $a \cdot x \cdot x = 0$.
  - Step 2: Applicazione della legge di annullamento del prodotto a entrambi i fattori lineari ($x=0 \lor x=0$).
  - Step 3: Definizione algebrica di molteplicità $\mu$ come ordine di annullamento.
  - Step 4: Corollario: Tangenza cartesiana della parabola $y = ax^2$ all'asse $x$ nel punto $O(0,0)$.

#### 10. `assets/content/algebra/quadratics/mat_quad_pura_01.md`
- **ID**: `mat_quad_pura_01`
- **Title**: Equazioni di Secondo Grado Pure
- **Category**: Matematica / Equazioni di Secondo Grado
- **Prerequisites**: `[mat_quad_eq_01]`
- **Current Theorems**: Risoluzione di $ax^2 + c = 0$.
- **Existing Corollaries**:
  - `### 4. Corollario: Simmetria Radici Reali e Traslazione Assiale` (Line 53)
  - Formula: `$$x_1 = -\sqrt{-\frac{c}{a}}, \quad x_2 = +\sqrt{-\frac{c}{a}} \implies x_1 = -x_2 \quad (x_1 + x_2 = 0)$$`
- **Current Status**: **FAIL (Formula Only)**.
- **Missing Corollaries**:
  - *Condizione di Esistenza in $\mathbb{R}$*: Soluzioni reali se e solo se $ac \le 0$ (discordi).
  - *Radici Complesse Coniugate*: $x_{1,2} = \pm i\sqrt{c/a}$ se $ac > 0$.
- **Required Expansion**:
  - Detail the sign discussion of $-c/a$:
    - Step 1: Isolamento $x^2 = -c/a$.
    - Step 2: Se $a, c$ concordi ($ac > 0$), $-c/a < 0 \implies$ nessuna radice reale.
    - Step 3: Se $a, c$ discordi ($ac < 0$), $-c/a > 0 \implies$ estrazione di due radici reali opposte.
    - Step 4: Corollario: $x_1 + x_2 = 0$, simmetria assiale rispetto all'asse delle ordinate.

#### 11. `assets/content/algebra/quadratics/mat_quad_spuria_01.md`
- **ID**: `mat_quad_spuria_01`
- **Title**: Equazioni di Secondo Grado Spurie
- **Category**: Matematica / Equazioni di Secondo Grado
- **Prerequisites**: `[mat_quad_eq_01]`
- **Current Theorems**: Risoluzione di $ax^2 + bx = 0$ per raccoglimento a fattore comune.
- **Existing Corollaries**:
  - `### 4. Corollario: Sempre Due Soluzioni Reali Distinte e Zeri Geometrici` (Line 53)
  - Formula: `$$x_1 = 0, \quad x_2 = -\frac{b}{a} \quad (x_1 \neq x_2 \text{ poiche } b \neq 0)$$`
- **Current Status**: **FAIL (Formula Only)**.
- **Missing Corollaries**:
  - *Ascissa del Vertice come Punto Medio*: $x_V = \frac{x_1 + x_2}{2} = -\frac{b}{2a}$.
  - *Positività di $\Delta$*: $\Delta = b^2 - 4a(0) = b^2 > 0$ sempre per $b \neq 0$.
- **Required Expansion**:
  - Create dedicated corollary proof showing:
    - Step 1: Calcolo del discriminante con termine noto nullo: $\Delta = b^2 - 4a \cdot 0 = b^2$.
    - Step 2: Poiché $b \neq 0$, $b^2 > 0 \implies \Delta > 0$ sempre e inderogabilmente.
    - Step 3: Calcolo delle radici tramite formula generale: $x = \frac{-b \pm \sqrt{b^2}}{2a} = \frac{-b \pm |b|}{2a}$.
    - Step 4: Corollario: Coincidenza perfetta con $x_1 = 0$ e $x_2 = -b/a$, e vertice esattamente nel punto medio $x_V = (0 - b/a)/2 = -b/(2a)$.

#### 12. `assets/content/algebra/quadratics/mat_quad_viete_01.md`
- **ID**: `mat_quad_viete_01`
- **Title**: Relazioni di Viète, Scomposizione e Regola di Cartesio
- **Category**: Matematica / Equazioni di Secondo Grado
- **Prerequisites**: `[mat_quad_eq_01]`
- **Current Theorems**: Formule di Viète ($s = -b/a, p = c/a$), scomposizione del trinomio, regola di Cartesio.
- **Existing Corollaries**:
  - `### 3. Corollario: Equazione Parametrica Noti Somma e Prodotto` (Line 54)
  - `### 3. Corollario: Teorema di Scomposizione Lineare del Trinomio` (Line 68)
  - `### 3. Corollario: Teorema dei Segni di Cartesio per Equazioni di 2° Grado` (Line 82)
- **Current Status**: **PARTIAL / LACKING INTERMEDIATE STEPS**.
- **Missing Corollaries**:
  - *Somma dei Quadrati delle Radici*: $x_1^2 + x_2^2 = s^2 - 2p$.
  - *Somma dei Reciproci*: $\frac{1}{x_1} + \frac{1}{x_2} = \frac{s}{p}$.
- **Required Expansion**:
  - Add explicit derivation of $x^2 - sx + p = 0$ from $(x - x_1)(x - x_2) = x^2 - (x_1+x_2)x + x_1 x_2$.
  - Add algebraic proof of the reciprocal and square sum corollaries.

---

### Category: Analisi Matematica - Limiti e Continuità (6 Topics)

#### 13. `assets/content/calculus/limits/mat_limits_01.md`
- **ID**: `mat_limits_01`
- **Title**: Definizione Rigorosa di Limite e Continuità (Epsilon-Delta)
- **Category**: Matematica / Limiti e Continuità
- **Prerequisites**: `[mat_log_01]`
- **Current Theorems**: Definizione formale $\varepsilon$-$\delta$ di limite finito in un punto.
- **Existing Corollaries**:
  - `### 4. Corollario: Teorema di Unicità del Limite e Definizione di Continuità` (Line 70)
  - Formula: `$$\lim_{x \to x_0} f(x) = L_1 \land \lim_{x \to x_0} f(x) = L_2 \implies |L_1 - L_2| \le |L_1 - f(x)| + |f(x) - L_2| < 2\varepsilon \implies L_1 = L_2$$`
- **Current Status**: **FAIL (Formula Only)**. Proof by contradiction is squeezed into a single chain of inequalities without stating the choice of $\varepsilon = |L_1 - L_2|/2$.
- **Missing Corollaries**:
  - *Teorema della Permanenza del Segno*: Se $\lim f(x) = L > 0$, allora $f(x) > 0$ in un intorno di $x_0$.
  - *Continuità della Somma e del Prodotto*.
- **Required Expansion**:
  - Create `## Dimostrazione: Corollario - Teorema di Unicità del Limite`:
    - Step 1: Ipotesi per assurdo $L_1 \neq L_2$, ponendo $\varepsilon = \frac{|L_1 - L_2|}{2} > 0$.
    - Step 2: Esistenza di intorni $\delta_1, \delta_2$ tali che $|f(x) - L_1| < \varepsilon$ e $|f(x) - L_2| < \varepsilon$.
    - Step 3: Scelta di $x \in B(x_0, \min(\delta_1, \delta_2)) \setminus \{x_0\}$ e disuguaglianza triangolare: $|L_1 - L_2| \le |L_1 - f(x)| + |f(x) - L_2| < \varepsilon + \varepsilon = 2\varepsilon = |L_1 - L_2|$.
    - Step 4: Corollario: La contraddizione $|L_1 - L_2| < |L_1 - L_2|$ impone $L_1 = L_2$.

#### 14. `assets/content/calculus/limits/mat_lim_sinc_01.md`
- **ID**: `mat_lim_sinc_01`
- **Title**: Limite Notevole del Seno: sin(x)/x e Teorema dei Carabinieri
- **Category**: Matematica / Limiti e Continuità
- **Prerequisites**: `[mat_limits_01, mat_trig_circ_01]`
- **Current Theorems**: Teorema dei Carabinieri e limite fondamentale trigonometrico $\lim_{x\to 0}\frac{\sin x}{x} = 1$.
- **Existing Corollaries**:
  - `### 5. Corollario: Limite Notevole della Tangente e Frequenza k` (Line 67)
  - Formula: `$$\lim_{x \to 0} \frac{\tan x}{x} = \lim_{x \to 0} \left(\frac{\sin x}{x} \cdot \frac{1}{\cos x}\right) = 1 \cdot 1 = 1 \quad \land \quad \lim_{x \to 0} \frac{\sin(kx)}{x} = k$$`
- **Current Status**: **FAIL (Formula Only)**.
- **Missing Corollaries**:
  - *Limite dell'Arcoseno*: $\lim_{x \to 0} \frac{\arcsin x}{x} = 1$.
  - *Limite dell'Arcotangente*: $\lim_{x \to 0} \frac{\arctan x}{x} = 1$.
- **Required Expansion**:
  - Separate into:
    1. `## Dimostrazione: Corollario - Limite Notevole della Tangente`:
       - Step 1: Definizione $\tan x = \frac{\sin x}{\cos x}$ e rapporto $\frac{\tan x}{x} = \frac{\sin x}{x} \cdot \frac{1}{\cos x}$.
       - Step 2: Teorema del limite del prodotto per funzioni convergenti.
       - Step 3: Limiti componenti: $\lim_{x\to 0}\frac{\sin x}{x} = 1$ e continuità di $\cos x$ con $\lim_{x\to 0}\cos x = \cos(0) = 1$.
       - Step 4: Corollario: $\lim_{x\to 0}\frac{\tan x}{x} = 1 \cdot \frac{1}{1} = 1$.
    2. `## Dimostrazione: Corollario - Riscalamento dell'Argomento (Frequenza k)`:
       - Step 1: Moltiplicazione e divisione per la costante $k \neq 0$: $\frac{\sin(kx)}{x} = k \cdot \frac{\sin(kx)}{kx}$.
       - Step 2: Cambio di variabile $u = kx$, notando che $x \to 0 \implies u \to 0$.
       - Step 3: Proprietà omogenea dell'operatore limite: $k \cdot \lim_{u\to 0}\frac{\sin u}{u}$.
       - Step 4: Corollario: $k \cdot 1 = k$.

#### 15. `assets/content/calculus/limits/mat_lim_cos_01.md`
- **ID**: `mat_lim_cos_01`
- **Title**: Limite Notevole del Coseno: (1 - cos x)/x² e Curvatura Locale
- **Category**: Matematica / Limiti e Continuità
- **Prerequisites**: `[mat_lim_sinc_01]`
- **Current Theorems**: Calcolo di $\lim_{x\to 0}\frac{1-\cos x}{x^2} = \frac{1}{2}$.
- **Existing Corollaries**:
  - `### 4. Corollario: Sviluppo di Taylor del Coseno e Limite del Primo Ordine` (Line 45)
  - Formula: `$$\cos x = 1 - \frac{1}{2}x^2 + o(x^2) \quad \land \quad \lim_{x \to 0} \frac{1 - \cos x}{x} = 0$$`
- **Current Status**: **FAIL (Formula Only)**.
- **Missing Corollaries**:
  - *Limite con Parametro k*: $\lim_{x \to 0} \frac{1 - \cos(kx)}{x^2} = \frac{k^2}{2}$.
- **Required Expansion**:
  - Create `## Dimostrazione: Corollario - Limite del Coseno al Primo Ordine`:
    - Step 1: Scomposizione del denominatore lineare moltiplicando per $x/x$: $\frac{1 - \cos x}{x} = x \cdot \frac{1 - \cos x}{x^2}$.
    - Step 2: Applicazione del teorema del prodotto dei limiti per fattori convergenti.
    - Step 3: Sostituzione dei valori di convergenza: $\lim_{x\to 0} x = 0$ e $\lim_{x\to 0}\frac{1-\cos x}{x^2} = \frac{1}{2}$.
    - Step 4: Corollario: $\lim_{x\to 0}\frac{1-\cos x}{x} = 0 \cdot \frac{1}{2} = 0$ (che dimostra la derivata nulla del coseno in zero).

#### 16. `assets/content/calculus/limits/mat_lim_exp_01.md`
- **ID**: `mat_lim_exp_01`
- **Title**: Limite Notevole dell'Esponenziale: (e^x - 1)/x e Derivata Naturale
- **Category**: Matematica / Limiti e Continuità
- **Prerequisites**: `[mat_lim_e_01, mat_lim_log_01]`
- **Current Theorems**: Limite fondamentale $\lim_{x\to 0}\frac{e^x - 1}{x} = 1$.
- **Existing Corollaries**:
  - `### 5. Corollario: Base Esponenziale Arbitraria e Derivata Prima` (Line 51)
  - Formula: `$$\lim_{x \to 0} \frac{a^x - 1}{x} = \lim_{x \to 0} \frac{e^{x \ln a} - 1}{x} = \ln a \quad \land \quad \frac{d}{dx}[e^x] = e^x$$`
- **Current Status**: **FAIL (Formula Only)**.
- **Missing Corollaries**:
  - *Derivata di Esponenziale Arbitrario*: $\frac{d}{dx}[a^x] = a^x \ln a$.
- **Required Expansion**:
  - Create dedicated proof for base $a$:
    - Step 1: Identità esponenziale-logaritmica $a^x = e^{\ln(a^x)} = e^{x \ln a}$.
    - Step 2: Moltiplicazione e divisione per $\ln a$: $\frac{e^{x \ln a} - 1}{x} = \ln a \cdot \frac{e^{x \ln a} - 1}{x \ln a}$.
    - Step 3: Sostituzione $u = x \ln a$ con $u \to 0$ per $x \to 0$.
    - Step 4: Corollario: $\lim_{x\to 0}\frac{a^x-1}{x} = \ln a \cdot 1 = \ln a$.
  - Create dedicated proof for derivative of $e^x$ via difference quotient.

#### 17. `assets/content/calculus/limits/mat_lim_log_01.md`
- **ID**: `mat_lim_log_01`
- **Title**: Limite Notevole del Logaritmo: ln(1+x)/x e Linearizzazione
- **Category**: Matematica / Limiti e Continuità
- **Prerequisites**: `[mat_lim_e_01]`
- **Current Theorems**: Limite fondamentale $\lim_{x\to 0}\frac{\ln(1+x)}{x} = 1$.
- **Existing Corollaries**:
  - `### 4. Corollario: Limite con Base Logaritmica Qualsiasi e Derivata Fondamentale` (Line 48)
  - Formula: `$$\lim_{x \to 0} \frac{\log_a(1 + x)}{x} = \frac{1}{\ln a} = \log_a e \quad \land \quad \frac{d}{dx}[\ln x] = \lim_{h \to 0} \frac{\ln(x+h) - \ln x}{h} = \frac{1}{x}$$`
- **Current Status**: **FAIL (Formula Only)**.
- **Missing Corollaries**:
  - *Limite Generalizzato con Potenza*: $\lim_{x \to 0} \frac{(1+x)^\alpha - 1}{x} = \alpha$.
- **Required Expansion**:
  - Detailed steps deriving $\frac{d}{dx}[\ln x] = \frac{1}{x}$ via increment $h$:
    - Step 1: $\frac{\ln(x+h) - \ln x}{h} = \frac{1}{h}\ln\left(\frac{x+h}{x}\right) = \frac{1}{h}\ln\left(1 + \frac{h}{x}\right)$.
    - Step 2: Moltiplicazione e divisione per $x$: $\frac{1}{x} \cdot \frac{\ln(1 + h/x)}{h/x}$.
    - Step 3: Cambio di variabile $t = h/x \to 0$.
    - Step 4: Corollario: $\frac{d}{dx}[\ln x] = \frac{1}{x} \cdot 1 = \frac{1}{x}$.

#### 18. `assets/content/calculus/limits/mat_lim_e_01.md`
- **ID**: `mat_lim_e_01`
- **Title**: Il Limite Fondamentale del Numero di Eulero e la Crescita Esponenziale
- **Category**: Matematica / Limiti e Continuità
- **Prerequisites**: `[mat_limits_01, mat_pow_01, mat_binom_01]`
- **Current Theorems**: Convergenza della successione $(1 + 1/n)^n \to e$.
- **Existing Corollaries**:
  - `### 5. Corollario: Forma del Limite Notevole nell'Origine e Potenza k` (Line 57)
  - Formula: `$$t = \frac{1}{x} \implies \lim_{t \to 0} (1 + t)^{\frac{1}{t}} = e \quad \land \quad \lim_{x \to \pm\infty} \left(1 + \frac{k}{x}\right)^x = e^k$$`
- **Current Status**: **FAIL (Formula Only)**.
- **Missing Corollaries**:
  - *Limite Inverso*: $\lim_{x \to \pm\infty} (1 - \frac{1}{x})^x = \frac{1}{e}$.
- **Required Expansion**:
  - Create explicit proof for $(1 + k/x)^x \to e^k$:
    - Step 1: Riscrittura della frazione interna: $1 + \frac{k}{x} = 1 + \frac{1}{x/k}$.
    - Step 2: Cambio di variabile $y = x/k$, tale che $x = k \cdot y$ e $y \to \pm\infty$.
    - Step 3: Applicazione della proprietà delle potenze ad esponente reale: $\left(1 + \frac{1}{y}\right)^{k y} = \left[ \left(1 + \frac{1}{y}\right)^y \right]^k$.
    - Step 4: Corollario: Continuità della funzione esponenziale $u^k$: $[\lim_{y\to\infty} (1 + 1/y)^y]^k = e^k$.

---

### Category: Analisi Matematica - Calcolo Differenziale (3 Topics)

#### 19. `assets/content/calculus/derivatives/mat_deriv_def_01.md`
- **ID**: `mat_deriv_def_01`
- **Title**: Rapporto Incrementale e Definizione di Derivata
- **Category**: Matematica / Calcolo Differenziale
- **Prerequisites**: `[mat_limits_01]`
- **Current Theorems**: Definizione di derivata come limite del rapporto incrementale, interpretazione geometrica.
- **Existing Corollaries**:
  - `### 4. Corollario: Continuità delle Funzioni Derivabili` (Line 37)
  - Formula: `$$f \text{ derivabile in } x_0 \implies \lim_{h \to 0} [f(x_0+h) - f(x_0)] = \lim_{h \to 0} \left[ h \cdot \frac{f(x_0+h)-f(x_0)}{h} \right] = 0 \cdot f'(x_0) = 0$$`
- **Current Status**: **FAIL (Formula Only)**. Compressed into one single line.
- **Missing Corollaries**:
  - *Non-invertibilità del Teorema (Controesempio funzione valore assoluto $|x|$ in $0$)*.
  - *Equazione Esplicita della Retta Normale*: $y - y_0 = -\frac{1}{f'(x_0)}(x - x_0)$.
- **Required Expansion**:
  - Create `## Dimostrazione: Corollario - Continuità delle Funzioni Derivabili`:
    - Step 1: Enunciato della condizione necessaria di continuità: $\lim_{x\to x_0} f(x) = f(x_0) \iff \lim_{h\to 0}[f(x_0+h) - f(x_0)] = 0$.
    - Step 2: Moltiplicazione e divisione identica per l'incremento non nullo $h \neq 0$.
    - Step 3: Limite del prodotto: $\lim_{h\to 0} h \cdot \lim_{h\to 0}\frac{f(x_0+h)-f(x_0)}{h} = 0 \cdot f'(x_0) = 0$.
    - Step 4: Corollario: $f$ è continua in $x_0$; la derivabilità è una condizione strettamente più forte della continuità.

#### 20. `assets/content/calculus/derivatives/mat_deriv_rules_01.md`
- **ID**: `mat_deriv_rules_01`
- **Title**: Regole di Derivazione: Prodotto, Quoziente e Catena
- **Category**: Matematica / Calcolo Differenziale
- **Prerequisites**: `[mat_deriv_def_01, mat_lim_sinc_01]`
- **Current Theorems**: Regola di Leibniz per il prodotto di due funzioni, derivata del seno.
- **Existing Corollaries**:
  - `### 4. Corollario: Derivata delle Potenze, Quoziente e Regola della Catena` (Line 44)
  - Formula: `$$(x^n)' = n x^{n-1}, \quad \left(\frac{f}{g}\right)' = \frac{f'g - f g'}{g^2}, \quad [f(g(x))]' = f'(g(x)) \cdot g'(x)$$`
- **Current Status**: **FAIL (Formula Only & Massively Bundled)**.
- **Missing Corollaries**:
  - *Derivata della Funzione Inversa*: $(f^{-1})'(y_0) = \frac{1}{f'(x_0)}$.
  - *Derivata della Tangente*: $(\tan x)' = 1 + \tan^2 x = \frac{1}{\cos^2 x}$.
- **Required Expansion**:
  - Create 3 separate demonstrations:
    1. `## Dimostrazione: Corollario - Regola di Derivazione del Quoziente` (4 steps).
    2. `## Dimostrazione: Corollario - Regola delle Potenze Intere (x^n)'` (4 steps).
    3. `## Dimostrazione: Corollario - Regola della Catena (Funzione Composta)` (4 steps).

#### 21. `assets/content/calculus/derivatives/mat_deriv_theorems_01.md`
- **ID**: `mat_deriv_theorems_01`
- **Title**: Teoremi di Rolle, Lagrange e Criterio di Monotonia
- **Category**: Matematica / Calcolo Differenziale
- **Prerequisites**: `[mat_deriv_rules_01]`
- **Current Theorems**: Teorema di Fermat, Teorema di Rolle, Teorema del Valor Medio di Lagrange, Teorema di Cauchy, Criterio di Monotonia.
- **Existing Corollaries**:
  - `### 4. Corollario: Annullamento della Derivata Istantanea (f'(x_0) = 0)` (Line 56)
  - `### 4. Corollario: Esistenza del Punto a Tangente Orizzontale` (Line 74)
  - `### 4. Corollario: Parallelismo tra Tangente e Secante` (Line 92)
  - `### 3. Corollario: La Regola di De L'Hôpital per Forme Indeterminate` (Line 106)
  - `### 3. Corollario: Caratterizzazione delle Funzioni Costanti` (Line 120)
- **Current Status**: **PARTIAL / LACKS DERIVATIONS FOR COROLLARIES**. De L'Hôpital and Constant Function characterization are squeezed into single lines.
- **Missing Corollaries**:
  - *Funzioni con Stessa Derivata differiscono per una Costante*: $f'(x) = g'(x) \implies f(x) = g(x) + C$.
  - *Disuguaglianza dei Rendimenti Decrescenti / Convessità*: $f''(x) \ge 0 \implies$ convessa.
- **Required Expansion**:
  - Expand `De L'Hôpital`: Detail Cauchy's ratio $\frac{f(x)-f(x_0)}{g(x)-g(x_0)} = \frac{f'(c)}{g'(c)}$, sandwiching $c$ as $x \to x_0$.
  - Expand `Caratterizzazione delle Funzioni Costanti`: Step-by-step application of Lagrange to arbitrary $x_1 < x_2$.

---

### Category: Analisi Matematica - Calcolo Integrale (4 Topics)

#### 22. `assets/content/calculus/integrals/mat_riemann_01.md`
- **ID**: `mat_riemann_01`
- **Title**: Integrale di Riemann e Somme di Rettangoli
- **Category**: Matematica / Calcolo Integrale
- **Prerequisites**: `[mat_deriv_def_01]`
- **Current Theorems**: Partizioni, somme inferiori/superiori di Darboux, integrabilità secondo Riemann.
- **Existing Corollaries**:
  - `### 4. Corollario: Linearità dell'Integrale e Additività rispetto all'Intervallo` (Line 46)
  - Formula: `$$\int_a^b [\alpha f + \beta g] dx = \alpha \int_a^b f dx + \beta \int_a^b g dx \quad \land \quad \int_a^b f dx = \int_a^c f dx + \int_c^b f dx$$`
- **Current Status**: **FAIL (Formula Only & Bundled)**.
- **Missing Corollaries**:
  - *Disuguaglianza Triangolare degli Integrali*: $|\int_a^b f(x)dx| \le \int_a^b |f(x)|dx$.
  - *Monotonia dell'Integrale rispetto all'Ordinamento delle Funzioni*.
- **Required Expansion**:
  - Create `## Dimostrazione: Corollario - Linearità dell'Integrale di Riemann`:
    - Step 1: Somme parziali su partizione $P$: $S(P, \alpha f + \beta g) = \sum [\alpha f(\xi_i) + \beta g(\xi_i)]\Delta x_i$.
    - Step 2: Proprietà distributiva e commutativa della sommatoria finita: $\alpha \sum f(\xi_i)\Delta x_i + \beta \sum g(\xi_i)\Delta x_i$.
    - Step 3: Passaggio al limite per calibro $\|P\| \to 0$.
    - Step 4: Corollario: Linearità $\int_a^b (\alpha f + \beta g)dx = \alpha \int_a^b f dx + \beta \int_a^b g dx$.
  - Create separate demonstration for interval additivity.

#### 23. `assets/content/calculus/integrals/mat_fund_calc_01.md`
- **ID**: `mat_fund_calc_01`
- **Title**: Teorema Fondamentale del Calcolo (Torricelli-Barrow)
- **Category**: Matematica / Calcolo Integrale
- **Prerequisites**: `[mat_riemann_01, mat_deriv_theorems_01]`
- **Current Theorems**: Teorema della Media Integrale, Primo Teorema Fondamentale (Funzione Integrale), Secondo Teorema Fondamentale (Formula di Newton-Leibniz).
- **Existing Corollaries**:
  - `### 4. Corollario: Esistenza del Punto Medio Integrale c` (Line 42)
  - `### 4. Corollario: Esistenza Universale della Primitiva per Funzioni Continue` (Line 60)
  - `### 4. Corollario: La Formula Fondamentale del Calcolo Integrale` (Line 78)
- **Current Status**: **PARTIAL / SHORTCUTS IN STEP 4**.
- **Missing Corollaries**:
  - *Regola di Leibniz per la Derivazione sotto il Segno di Integrale*: $\frac{d}{dx}\int_{a(x)}^{b(x)} f(t)dt = f(b(x))b'(x) - f(a(x))a'(x)$.
  - *Integrazione di Funzioni Pari e Dispari su Intervalli Simmetrici $[-a, a]$*.
- **Required Expansion**:
  - Add explicit demonstration for the Leibniz boundary derivative rule:
    - Step 1: Composizione della funzione integrale $F(u) = \int_{x_0}^u f(t)dt$ con estremi variabili $b(x)$ e $a(x)$.
    - Step 2: Decomposizione dell'intervallo: $\int_{a(x)}^{b(x)} f(t)dt = F(b(x)) - F(a(x))$.
    - Step 3: Applicazione della regola della catena: $\frac{d}{dx}[F(b(x))] = F'(b(x))b'(x) = f(b(x))b'(x)$.
    - Step 4: Corollario: $\frac{d}{dx}\int_{a(x)}^{b(x)} f(t)dt = f(b(x))b'(x) - f(a(x))a'(x)$.

#### 24. `assets/content/calculus/integrals/mat_integ_parts_01.md`
- **ID**: `mat_integ_parts_01`
- **Title**: Integrazione per Parti
- **Category**: Matematica / Calcolo Integrale
- **Prerequisites**: `[mat_fund_calc_01, mat_deriv_rules_01]`
- **Current Theorems**: Formula generale di integrazione per parti, euristica LIATE.
- **Existing Corollaries**:
  - `### 4. Corollario: Integrazione per Parti negli Integrali Definiti` (Line 56)
  - `### 4. Corollario: Integrali Ciclici Ricorsivi` (Line 74)
- **Current Status**: **FAIL (Formula Only)**.
- **Missing Corollaries**:
  - *Formula Ricorsiva per $\int \sin^n x \, dx$ (Formula di Riduzione)*.
- **Required Expansion**:
  - Create explicit demonstration for cyclic integrals ($\int e^x \cos x dx$):
    - Step 1: Prima integrazione per parti ponendo $f = \cos x, g' = e^x \implies e^x \cos x + \int e^x \sin x dx$.
    - Step 2: Seconda integrazione per parti sul residuo ponendo $u = \sin x, v' = e^x \implies e^x \sin x - \int e^x \cos x dx$.
    - Step 3: Sostituzione ed equazione simbolica: $I = e^x(\cos x + \sin x) - I$.
    - Step 4: Corollario: Isolamento algebrico: $2I = e^x(\sin x + \cos x) \implies I = \frac{e^x(\sin x + \cos x)}{2} + C$.

#### 25. `assets/content/calculus/integrals/mat_integ_subst_01.md`
- **ID**: `mat_integ_subst_01`
- **Title**: Integrazione per Sostituzione e Integrali Quasi-Immediati
- **Category**: Matematica / Calcolo Integrale
- **Prerequisites**: `[mat_fund_calc_01, mat_deriv_rules_01]`
- **Current Theorems**: Teorema del cambio di variabile, integrali quasi-immediati.
- **Existing Corollaries**:
  - `### 4. Corollario: Cambio degli Estremi negli Integrali Definiti` (Line 51)
  - `### 3. Corollario: Primitive Fondamentali della Tangente e della Cotangente` (Line 65)
- **Current Status**: **FAIL (Formula Only)**.
- **Missing Corollaries**:
  - *Integrale della Secante*: $\int \sec x \, dx = \ln|\sec x + \tan x| + C$.
  - *Sostituzione Iperbolica/Trigonometrica per $\sqrt{a^2 - x^2}$*.
- **Required Expansion**:
  - Step-by-step derivation of $\int \tan x dx = -\ln|\cos x| + C$:
    - Step 1: Riscrittura come quoziente trigonometrico: $\int \frac{\sin x}{\cos x} dx$.
    - Step 2: Identificazione del differenziale del denominatore: $u = \cos x \implies du = -\sin x dx \implies \sin x dx = -du$.
    - Step 3: Sostituzione nella forma logaritmica: $-\int \frac{du}{u} = -\ln|u| + C$.
    - Step 4: Corollario: Ripristino della variabile: $-\ln|\cos x| + C = \ln|\sec x| + C$.

---

### Category: Geometria e Trigonometria (5 Topics)

#### 26. `assets/content/geometry_trig/geometry/mat_triang_01.md`
- **ID**: `mat_triang_01`
- **Title**: Geometria del Triangolo e Angoli Interni
- **Category**: Matematica / Geometria Euclidea Piana
- **Prerequisites**: None (Foundational)
- **Current Theorems**: Teorema della somma degli angoli interni di un triangolo ($\alpha + \beta + \gamma = 180^\circ$).
- **Existing Corollaries**:
  - `### 4. Corollario: Teorema dell'Angolo Esterno` (Line 37)
  - Formula: `$$\delta_{\text{ext}} = 180^\circ - \gamma = \alpha + \beta$$`
- **Current Status**: **FAIL (Formula Only)**.
- **Missing Corollaries**:
  - *Somma degli Angoli Interni di un Poligono a $n$ Lati*: $S_n = (n-2) \cdot 180^\circ$.
  - *Complementarità degli Angoli Acuti nel Triangolo Rettangolo*: $\alpha + \beta = 90^\circ$.
- **Required Expansion**:
  - Create `## Dimostrazione: Corollario - Teorema dell'Angolo Esterno`:
    - Step 1: Definizione geometrica di angolo adiacente ed esterno: $\delta_{\text{ext}} + \gamma = 180^\circ$.
    - Step 2: Teorema principale della somma interna: $\alpha + \beta + \gamma = 180^\circ \implies \gamma = 180^\circ - (\alpha + \beta)$.
    - Step 3: Sostituzione algebrica: $\delta_{\text{ext}} = 180^\circ - [180^\circ - (\alpha + \beta)]$.
    - Step 4: Corollario: $\delta_{\text{ext}} = \alpha + \beta$.
  - Create `## Dimostrazione: Corollario - Somma degli Angoli Interni di un Poligono a n Lati` (triangolazione dal vertice).

#### 27. `assets/content/geometry_trig/geometry/mat_pythagoras_01.md`
- **ID**: `mat_pythagoras_01`
- **Title**: Teorema di Pitagora ed Euclide
- **Category**: Matematica / Geometria Euclidea Piana
- **Prerequisites**: `[mat_triang_01, mat_binom_01]`
- **Current Theorems**: Teorema di Pitagora (equiscomponibilità), Primo Teorema di Euclide, Secondo Teorema di Euclide.
- **Existing Corollaries**:
  - `### 4. Corollario: Metrica Euclidea e Diagonale del Quadrato` (Line 42)
  - `### 4. Corollario: Primo Teorema di Euclide e Deduzione Alternativa di Pitagora` (Line 60)
  - `### 4. Corollario: Secondo Teorema di Euclide e Media Geometrica` (Line 78)
- **Current Status**: **PARTIAL / LACKS DERIVATIONS IN STEP 4**.
- **Missing Corollaries**:
  - *Diagonale del Parallelepipedo Rettangolo 3D*: $D = \sqrt{a^2 + b^2 + c^2}$.
  - *Altezza del Triangolo Equilatero*: $h = \frac{l\sqrt{3}}{2}$.
- **Required Expansion**:
  - Expand Diagonale del Quadrato: Show $d^2 = l^2 + l^2 = 2l^2 \implies d = \sqrt{2l^2} = l\sqrt{2}$.
  - Add explicit derivation of 3D spatial distance metric.

#### 28. `assets/content/geometry_trig/trigonometry/mat_trig_circ_01.md`
- **ID**: `mat_trig_circ_01`
- **Title**: Circonferenza Goniometrica e Relazione Fondamentale
- **Category**: Matematica / Goniometria e Trigonometria
- **Prerequisites**: `[mat_pythagoras_01]`
- **Current Theorems**: Circonferenza unitaria $x^2 + y^2 = 1$, relazione fondamentale $\cos^2\theta + \sin^2\theta = 1$.
- **Existing Corollaries**:
  - `### 4. Corollario: Definizione di Tangente e Relazione Fondamentale Secondaria` (Line 39)
  - Formula: `$$\tan\theta \equiv \frac{\sin\theta}{\cos\theta} \implies 1 + \tan^2\theta = \frac{1}{\cos^2\theta}$$`
- **Current Status**: **FAIL (Formula Only)**.
- **Missing Corollaries**:
  - *Relazione per la Cotangente*: $1 + \cot^2\theta = \frac{1}{\sin^2\theta}$.
  - *Limitazione di Seno e Coseno*: $-1 \le \sin\theta \le 1, -1 \le \cos\theta \le 1$.
- **Required Expansion**:
  - Create `## Dimostrazione: Corollario - Relazioni Fondamentali Secondarie (Tangente e Cotangente)`:
    - Step 1: Relazione fondamentale $\sin^2\theta + \cos^2\theta = 1$.
    - Step 2: Divisione termine a termine per $\cos^2\theta \neq 0$: $\frac{\sin^2\theta}{\cos^2\theta} + \frac{\cos^2\theta}{\cos^2\theta} = \frac{1}{\cos^2\theta}$.
    - Step 3: Sostituzione della definizione di tangente: $(\tan\theta)^2 + 1 = \frac{1}{\cos^2\theta}$.
    - Step 4: Corollario: $1 + \tan^2\theta = \frac{1}{\cos^2\theta}$ e simmetricamente per divisione con $\sin^2\theta$: $1 + \cot^2\theta = \frac{1}{\sin^2\theta}$.

#### 29. `assets/content/geometry_trig/trigonometry/mat_trig_add_01.md`
- **ID**: `mat_trig_add_01`
- **Title**: Formule Goniometriche: Addizione, Duplicazione e Bisezione
- **Category**: Matematica / Goniometria e Trigonometria
- **Prerequisites**: `[mat_trig_circ_01]`
- **Current Theorems**: Formule di addizione/sottrazione, duplicazione, bisezione, formule parametriche $t$, Werner/Prostaferesi.
- **Existing Corollaries**:
  - `### 5. Corollario: Formule di Addizione e Sottrazione della Tangente` (Line 43)
  - `### 4. Corollario: Duplicazione della Tangente e Abbassamento del Grado` (Line 61)
  - `### 5. Corollario: Determinazione Univoca del Segno nei Quadranti` (Line 83)
  - `### 4. Corollario: Sostituzione Razionale Universale di Weierstrass negli Integrali` (Line 101)
  - `### 4. Corollario: Fenomeno dei Battimenti e Modulazione di Frequenza` (Line 119)
- **Current Status**: **PARTIAL / LACKS EXPLICIT FRACTION DERIVATIONS**.
- **Missing Corollaries**:
  - *Formule di Triplicazione*: $\sin(3\alpha) = 3\sin\alpha - 4\sin^3\alpha$.
- **Required Expansion**:
  - Explicit algebraic derivation for $\tan(\alpha \pm \beta)$:
    - Step 1: Quoziente $\frac{\sin(\alpha \pm \beta)}{\cos(\alpha \pm \beta)} = \frac{\sin\alpha\cos\beta \pm \cos\alpha\sin\beta}{\cos\alpha\cos\beta \mp \sin\alpha\sin\beta}$.
    - Step 2: Divisione di numeratore e denominatore per $\cos\alpha\cos\beta \neq 0$.
    - Step 3: Semplificazione frazionaria dei quattro termini.
    - Step 4: Corollario: $\tan(\alpha \pm \beta) = \frac{\tan\alpha \pm \tan\beta}{1 \mp \tan\alpha\tan\beta}$.

#### 30. `assets/content/geometry_trig/trigonometry/mat_trig_triang_01.md`
- **ID**: `mat_trig_triang_01`
- **Title**: Teoremi dei Triangoli: Carnot, Seni e Formula dell'Area
- **Category**: Matematica / Goniometria e Trigonometria
- **Prerequisites**: `[mat_trig_circ_01, mat_pythagoras_01]`
- **Current Theorems**: Teorema di Carnot (Coseno), Teorema dei Seni (2R), Formula di Erone.
- **Existing Corollaries**:
  - `### 4. Corollario: Teorema di Carnot e Riduzione a Pitagora` (Line 38)
  - `### 4. Corollario: La Legge dei Seni per Qualsiasi Triangolo` (Line 56)
  - `### 4. Corollario: La Formula di Erone per il Calcolo dell'Area dai Soli Lati` (Line 74)
- **Current Status**: **PARTIAL / COMPLEX HERON PROOF OMITS INTERMEDIATE FACTORIZATIONS**.
- **Missing Corollaries**:
  - *Raggio della Circonferenza Inscritta*: $r = \frac{\text{Area}}{p}$.
  - *Raggio della Circonferenza Circoscritta*: $R = \frac{abc}{4 \cdot \text{Area}}$.
- **Required Expansion**:
  - Expand Heron's derivation to detail the difference-of-squares factorizations:
    - $16 \cdot \text{Area}^2 = 4a^2b^2 - (a^2+b^2-c^2)^2 = (2ab - a^2 - b^2 + c^2)(2ab + a^2 + b^2 - c^2)$.
    - $=[c^2 - (a-b)^2][(a+b)^2 - c^2] = (c - a + b)(c + a - b)(a + b - c)(a + b + c)$.
    - $= (2p - 2a)(2p - 2b)(2p - 2c)(2p) = 16 p (p-a)(p-b)(p-c)$.
    - Corollario: $\text{Area} = \sqrt{p(p-a)(p-b)(p-c)}$.

---

### Category: Fisica ed Elettrotecnica (5 Topics)

#### 31. `assets/content/physics/phys_kin_01.md`
- **ID**: `phys_kin_01`
- **Title**: Cinematica: Moto Rettilineo e Corollario di Torricelli
- **Category**: Fisica / Cinematica e Dinamica
- **Prerequisites**: `[mat_parabola_01, mat_deriv_rules_01, mat_fund_calc_01]`
- **Current Theorems**: Moto rettilineo uniformemente accelerato, derivata della velocità, integrazione dello spazio.
- **Existing Corollaries**:
  - `### 5. Corollario: Formula Senza Tempo di Torricelli` (Line 62)
  - Formula: `$$v^2 = v_0^2 + 2 a \Delta x$$`
- **Current Status**: **FAIL (Formula Only)**.
- **Missing Corollaries**:
  - *Velocità Media nel MRUA*: $v_m = \frac{v_0 + v}{2}$.
  - *Spazio di Arresto*: $d_{\text{stop}} = \frac{v_0^2}{2|a|}$.
- **Required Expansion**:
  - Create `## Dimostrazione: Corollario - Formula di Torricelli (Relazione Indipendente dal Tempo)`:
    - Step 1: Isolamento temporale dalla velocità: $t = \frac{v - v_0}{a}$.
    - Step 2: Sostituzione nella legge oraria: $\Delta x = v_0\left(\frac{v - v_0}{a}\right) + \frac{1}{2}a\left(\frac{v - v_0}{a}\right)^2$.
    - Step 3: Sviluppo algebrico del binomio: $\Delta x = \frac{v_0 v - v_0^2}{a} + \frac{v^2 - 2v v_0 + v_0^2}{2a}$.
    - Step 4: Denominatore comune $2a$: $2a\Delta x = 2v_0 v - 2v_0^2 + v^2 - 2v v_0 + v_0^2 = v^2 - v_0^2$.
    - Step 5: Corollario: $v^2 = v_0^2 + 2a\Delta x$.

#### 32. `assets/content/physics/circuits/ele_ohm_01.md`
- **ID**: `ele_ohm_01`
- **Title**: Legge di Ohm e Resistenza Elettrica
- **Category**: Elettrotecnica / Circuiti in Corrente Continua
- **Prerequisites**: None (Applied root)
- **Current Theorems**: Velocità di deriva microscopica, seconda legge di Ohm $R = \rho L/A$.
- **Existing Corollaries**:
  - `### 3. Corollario: Prima Legge di Ohm e Formule Inverse` (Line 48)
  - Formula: `$$V = R \cdot I \iff I = \frac{V}{R} \iff R = \frac{V}{I}$$`
- **Current Status**: **FAIL (Formula Only)**.
- **Missing Corollaries**:
  - *Resistenza Equivalente Serie*: $R_{\text{eq}} = R_1 + R_2$.
  - *Resistenza Equivalente Parallelo*: $\frac{1}{R_{\text{eq}}} = \frac{1}{R_1} + \frac{1}{R_2}$.
- **Required Expansion**:
  - Derive $V = RI$ microscopically from current density $J = \sigma E$:
    - Step 1: Densità di corrente $J = I/A$ e campo elettrico uniforme $E = V/L$.
    - Step 2: Legge di Ohm microscopica $J = \sigma E \implies \frac{I}{A} = \sigma \frac{V}{L}$.
    - Step 3: Isolamento della tensione $V = \left(\frac{L}{\sigma A}\right) I = \left(\rho \frac{L}{A}\right) I$.
    - Step 4: Corollario: Posto $R = \rho L/A$, $V = RI$ con inverse $I = V/R$ e $R = V/I$.

#### 33. `assets/content/physics/circuits/ele_power_01.md`
- **ID**: `ele_power_01`
- **Title**: Potenza Elettrica nei Circuiti
- **Category**: Elettrotecnica / Circuiti in Corrente Continua
- **Prerequisites**: `[ele_ohm_01]`
- **Current Theorems**: Definizione di potenza come derivata temporale del lavoro, $P = V \cdot I$.
- **Existing Corollaries**:
  - `### 3. Corollario: Formule di Potenza per Carichi Resistivi` (Line 58)
  - Formula: `$$P = R \cdot I^2 = \frac{V^2}{R}$$`
- **Current Status**: **FAIL (Formula Only)**.
- **Missing Corollaries**:
  - *Teorema del Massimo Trasferimento di Potenza (Adattamento d'Impedenza)*: $R_L = R_S \implies P_{\max} = \frac{V_{\text{th}}^2}{4 R_S}$.
- **Required Expansion**:
  - Create `## Dimostrazione: Corollario - Formule della Potenza Dissipata per Effetto Ohmico`:
    - Step 1: Definizione generale della potenza elettrica assorbita da un bipolo: $P = V \cdot I$.
    - Step 2: Sostituzione della Prima Legge di Ohm $V = R \cdot I$: $P = (R \cdot I) \cdot I = R \cdot I^2$.
    - Step 3: Sostituzione della formula inversa per la corrente $I = \frac{V}{R}$: $P = V \cdot \left(\frac{V}{R}\right) = \frac{V^2}{R}$.
    - Step 4: Corollario: Equivalenza delle formulazioni $P = V I = R I^2 = \frac{V^2}{R}$ per conduttori ohmici lineari.

#### 34. `assets/content/physics/circuits/ele_joule_01.md`
- **ID**: `ele_joule_01`
- **Title**: Effetto Joule e Dissipazione Termica
- **Category**: Elettrotecnica / Circuiti in Corrente Continua
- **Prerequisites**: `[ele_power_01]`
- **Current Theorems**: Integrazione dell'energia termica dissipata $Q = \int P dt$.
- **Existing Corollaries**:
  - `### 3. Corollario: Equivalente Meccanico del Calore e Calcolo in Calorie` (Line 59)
  - Formula: `$$Q_{\text{cal}} = \frac{R \cdot I^2 \cdot \Delta t}{4.186}$$`
- **Current Status**: **FAIL (Formula Only)**.
- **Missing Corollaries**:
  - *Legge di Raffreddamento di Newton*: $\frac{dT}{dt} = -k(T - T_{\text{amb}})$.
- **Required Expansion**:
  - Detail the thermal dissipation derivation:
    - Step 1: Lavoro elettrico dissipato in intervallo $\Delta t$ a corrente costante: $E = P \cdot \Delta t = R I^2 \Delta t$ espresso in Joule ($J$).
    - Step 2: Esperimento di Joule sull'equivalente meccanico del calore: $1 \text{ cal} = 4.186 \text{ J} \implies 1 \text{ J} = \frac{1}{4.186} \text{ cal}$.
    - Step 3: Conversione dimensionale dell'energia in calore: $Q_{\text{cal}} = \frac{E}{J_{\text{cal}}}$.
    - Step 4: Corollario: $Q_{\text{cal}} = \frac{R \cdot I^2 \cdot \Delta t}{4.186}$.

#### 35. `assets/content/physics/chem_ph_01.md`
- **ID**: `chem_ph_01`
- **Title**: Chimica Fisica: Soluzioni Acido-Base e Calcolo del pH
- **Category**: Fisica / Chimica Fisica
- **Prerequisites**: `[mat_log_01]`
- **Current Theorems**: Equilibrio di autoionizzazione dell'acqua pura, definizione operativa del $\text{pH}$.
- **Existing Corollaries**:
  - `### 4. Corollario: Relazione Fondamentale pH + pOH = 14` (Line 53)
  - Formula: `$$\text{pH} + \text{pOH} = 14.00 \iff \text{pH} = 14 - \text{pOH}$$`
- **Current Status**: **FAIL (Formula Only)**.
- **Missing Corollaries**:
  - *pH di una Soluzione Neutra*: $[\text{H}^+] = 10^{-7} \implies \text{pH} = 7.00$.
  - *Equazione di Henderson-Hasselbalch per Soluzioni Tampone*: $\text{pH} = \text{p}K_a + \log\frac{[\text{A}^-]}{[\text{HA}]}$.
- **Required Expansion**:
  - Create `## Dimostrazione: Corollario - Relazione Fondamentale pH + pOH = 14`:
    - Step 1: Prodotto ionico dell'acqua a 25°C ($298 \text{ K}$): $K_w = [\text{H}_3\text{O}^+][\text{OH}^-] = 1.0 \times 10^{-14}$.
    - Step 2: Applicazione dell'operatore logaritmico negativo ad ambo i membri: $-\log_{10}(K_w) = -\log_{10}([\text{H}_3\text{O}^+][\text{OH}^-])$.
    - Step 3: Proprietà del logaritmo del prodotto e separazione dei termini: $-\log_{10}(10^{-14}) = (-\log_{10}[\text{H}_3\text{O}^+]) + (-\log_{10}[\text{OH}^-])$.
    - Step 4: Corollario: Identificazione delle definizioni operative: $14.00 = \text{pH} + \text{pOH} \iff \text{pH} = 14 - \text{pOH}$.

---

## 5. Concrete Recommendations & Expansion Blueprint for Requirement R2

To satisfy Requirement R2 and integrate seamlessly with the new Spotlight Search (R1) and Proof Switcher (R3), the remediation workers should follow this standard blueprint:

### 5.1 Syntax Standard: Dedicated Grouping
Instead of embedding a corollary as an unexpanded final step (`### N. Corollario: ...`), every corollary must be formatted as its own distinct demonstration section:

```markdown
## Dimostrazione: Corollario - [Nome Esatto del Corollario]

### 1. Ipotesi derivata dal Teorema Principale
[Enunciazione della formula o proprietà fondamentale già dimostrata]
$$...$$
> **Insight:** [Intuizione logica di partenza]

### 2. Passaggio Algebrico Intermedio: [Sostituzione / Isolamento]
[Spiegazione dell'operazione algebrica svolta]
$$...$$
> **Insight:** [Dettaglio matematico intermedio]

### 3. Semplificazione Algebrica: [Sviluppo / Raccoglimento]
[Risoluzione di prodotti, frazioni o elisioni]
$$...$$
> **Insight:** [Dettaglio sulla cancellazione dei termini]

### 4. Corollario: [Tesi e Formula Risolutiva Finale]
[Formula finale dedotta]
$$...$$
> **Insight:** [Importanza applicativa e interpretazione fisica/geometrica]
```

### 5.2 Architectural Benefits
1. **Instant UI Compatibility**: `MarkdownContentParser` will automatically parse `Corollario - [Nome]` into a separate demonstration group.
2. **Interactive Selector**: `AlgebraicProofWidget` will automatically display a clickable `FilterChip` tab for each corollary alongside the main theorem.
3. **Automatic Badging**: Because the final step is titled `### 4. Corollario: ...`, `AlgebraicProofWidget` will highlight it with the golden amber card and `COROLLARIO DEDOTTO` badge.
4. **Spotlight Search Indexing**: The search indexer can scan all `ProofStep.description` fields containing `[Corollario - ...]` and provide direct 1-tap navigation to the exact proof tab.

---

## 6. Verification Method

To independently verify this audit and any future remediation work:

1. **Static Analysis**:
   ```powershell
   flutter analyze
   ```
   *Pass Condition*: 0 errors, 0 warnings.

2. **Curriculum DAG & Corollary Presence Test**:
   ```powershell
   flutter test test/curriculum_dag_test.dart
   ```
   *Pass Condition*: Confirms all 35 nodes are loaded and DAG remains acyclic.

3. **Content Parsing Verification**:
   ```powershell
   flutter test test/markdown_content_loader_test.dart
   ```
   *Pass Condition*: Confirms Markdown frontmatter and body parsing pass cleanly.

4. **Automated Multi-Step Corollary Rigor Audit**:
   Execute the audit inspection tool created during this investigation:
   ```powershell
   dart run .agents/teamwork_preview_explorer_survey_1/audit_tool.dart
   ```
   Inspect `audit_data.json` to confirm that every corollary step has non-empty preceding algebraic steps and is not a lone final step.

5. **Full Regression Test Suite**:
   ```powershell
   flutter test
   ```
   *Pass Condition*: All 146+ tests across the repository pass without regressions.