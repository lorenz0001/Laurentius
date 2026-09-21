import '../../domain/models/university_course_model.dart';

/// Corso Completo di Geometria e Algebra Lineare (Politecnico di Milano)
/// Docente: Prof. Alexandru Constantinescu
/// Scomposizione didattica rigorosa del Capitolo 1: Fondamenti (pp. 1-81).
class UniversityLinearAlgebraCourse {
  static const UniversityCourse course = UniversityCourse(
    id: 'polimi_geometria_algebra_lineare',
    title: 'Geometria e Algebra Lineare',
    university: 'Politecnico di Milano',
    professor: 'Prof. Alexandru Constantinescu',
    academicYear: '2026/2027',
    semester: 'Primo Semestre',
    description:
        'Corso universitario completo per Ingegneria e Matematica. '
        'Trattazione assiomatica, rigorosa e visiva partendo dai fondamenti logici e insiemistici '
        'fino alle strutture algebriche superiori (gruppi, anelli, campi).',
    chapters: [
      UniversityChapter(
        id: 'cap_01_fondamenti',
        title: 'Capitolo 1: Fondamenti',
        description:
            'Linguaggio della logica proposizionale, insiemi e paradossi, teoria delle applicazioni, '
            'relazioni di equivalenza e quozienti, divisibilità intera e strutture algebriche (Gruppi, Anelli, Campi).',
        lectures: [
          lecture1,
          lecture2,
          lecture3,
          lecture4,
          lecture5,
          lecture6,
        ],
      ),
    ],
  );

  // ==========================================================================
  // LEZIONE 1.1: LOGICA PROPOSIZIONALE ED ENUNCIATI MATEMATICI (pp. 8-16)
  // ==========================================================================
  static const UniversityLecture lecture1 = UniversityLecture(
    id: 'polimi_gal_1_1_logica',
    number: '1.1',
    title: 'Enunciati Matematici e Logica Proposizionale',
    subtitle: 'Valori di verità, connettivi, quantificatori, implicazioni e dimostrazione per contrapposizione',
    pageRange: 'pp. 8-16',
    defaultColor: LectureColorCode.essential,
    estimatedMinutes: 35,
    keyTermIds: [
      'enunciato_matematico',
      'tabella_verita',
      'negazione',
      'congiunzione_disgiunzione',
      'quantificatori',
      'implicazione_logica',
      'contrapposta',
      'inversione_inversa',
      'condizione_necessaria_sufficiente',
      'tautologia_contraddizione',
    ],
    markdownContent: r'''
# 1.1 Enunciati Matematici

> *"I fatti logici che sussistono tra giudizi, concetti ecc. trovano la loro rappresentazione mediante formule, la cui interpretazione è libera dalle ambiguità che possono facilmente comparire nell'espressione linguistica."* — David Hilbert & Wilhelm Ackermann [HA72]

Al centro di ogni teoria matematica si trovano relazioni logiche tra enunciati formulati con assoluta chiarezza.

---

### 1.1.1 Definizione ed Esempi

**Definizione 1.1:** Un [Enunciato Matematico](term:enunciato_matematico) è una frase che è **vera oppure falsa** — ma non entrambe le cose contemporaneamente.

Il valore di verità di un enunciato matematico non deve dipendere dalle circostanze, dal momento o dalla persona che lo pronuncia o lo legge:

- *"2 + 2 = 4"* (Enunciato Vero)
- *"0 = 1"* (Enunciato Falso)
- *"Oggi è lunedì"* (NON è un enunciato matematico: dipende dal giorno)
- *"Questo enunciato è falso"* (Paradosso insolubile: se è vero è falso, se è falso è vero)

> **Osservazione 1.2 (Nota del Docente):** Vorrei evitare la scrittura astratta ed esasperata della logica dei predicati. Trovo più bella la matematica quando è formulata in un linguaggio naturale rigoroso. Tuttavia, la precisione non deve mai essere sacrificata.

---

### 1.1.2 Tabelle di Verità e Negazione

Come stabilito, un enunciato può assumere solo due valori. Lo registriamo in una [Tabella di Verità](term:tabella_verita):

\$\$\\begin{array}{|c|} \\hline A \\\\ \\hline \\text{vero} \\\\ \\text{falso} \\\\ \\hline \\end{array}\$\$

**Definizione 1.3:** La [Negazione Logica](term:negazione) dell'enunciato \$A\$ si indica con \$\\text{non}(A)\$ oppure \$\\neg A\$, ed è l'opposto contraddittorio di \$A\$: se \$A\$ è vero, \$\\neg A\$ è falso, e viceversa.

\$\$\\begin{array}{|c|c|c|} \\hline A & \\neg A & \\neg(\\neg A) \\\\ \\hline \\text{vero} & \\text{falso} & \\text{vero} \\\\ \\text{falso} & \\text{vero} & \\text{falso} \\\\ \\hline \\end{array}\$\$

**Osservazione 1.5:** La negazione della negazione di un enunciato è logicamente equivalente all'enunciato originale: \$\\neg(\\neg A) \\equiv A\$.

---

### 1.1.3 Connettivi Logici: Congiunzione e Disgiunzione

Due enunciati possono essere combinati mediante [Congiunzione e Disgiunzione](term:congiunzione_disgiunzione):

1. **La congiunzione** (\$A \\land B\$, "e"): è vera soltanto quando sia \$A\$ sia \$B\$ sono veri.
2. **La disgiunzione** (\$A \\lor B\$, "o"): in matematica è **sempre inclusiva** (dal latino *vel*). "\$A \\lor B\$" è vera se almeno uno dei due enunciati è vero, compreso il caso in cui siano entrambi veri.

\$\$\\begin{array}{|c|c|c|c|} \\hline A & B & A \\land B & A \\lor B \\\\ \\hline \\text{v} & \\text{v} & \\text{v} & \\text{v} \\\\ \\text{v} & \\text{f} & \\text{f} & \\text{v} \\\\ \\text{f} & \\text{v} & \\text{f} & \\text{v} \\\\ \\text{f} & \\text{f} & \\text{f} & \\text{f} \\\\ \\hline \\end{array}\$\$

**Leggi di De Morgan (Teorema):** Per tutti gli enunciati \$A\$ e \$B\$ valgono:
\$\$\\neg(A \\land B) \\equiv \\neg A \\lor \\neg B\$\$
\$\$\\neg(A \\lor B) \\equiv \\neg A \\land \\neg B\$\$

---

### 1.1.4 Quantificatori: Universale ed Esistenziale

I [Quantificatori](term:quantificatori) permettono di specificare l'estensione di verità di una proprietà che dipende da una variabile:

- **Universale** (\$\\forall\$, "per ogni"): \$\\forall a \\in \\mathbb{N}, 2a + 1 \\text{ è dispari}\$.
- **Esistenziale** (\$\\exists\$, "esiste"): \$\\exists a \\in \\mathbb{N} : 2a + 3 = 5\$.
- **Esistenza e Unicità** (\$\\exists!\$, "esiste ed è unico"): significa che ne esiste uno e che ogni altro elemento con la stessa proprietà coincide con esso.

> **ATTENZIONE:** \$\\forall\$ ed \$\\exists\$ **NON commutano!**
> 
> \$\\forall a \\in \\mathbb{N}, \\exists b \\in \\mathbb{N} : b > a\$ *(Vero: non esiste il massimo numero naturale).*
> 
> \$\\exists b \\in \\mathbb{N} : \\forall a \\in \\mathbb{N}, b > a\$ *(Falso: esisterebbe un numero più grande di tutti).*

---

### 1.1.5 Implicazioni Logiche e Dimostrazione per Contrapposizione

Un'[Implicazione Logica](term:implicazione_logica) è un enunciato della forma: *"Se A è vero, allora B è vero"*, scritto:

\$\$A \\implies B\$\$

\$A\$ si chiama **ipotesi** (o premessa), \$B\$ si chiama **conclusione** (o tesi).

\$\$\\begin{array}{|c|c|c|} \\hline A & B & A \\implies B \\\\ \\hline \\text{v} & \\text{v} & \\text{v} \\\\ \\text{v} & \\text{f} & \\text{f} \\\\ \\text{f} & \\text{v} & \\text{v} \\\\ \\text{f} & \\text{f} & \\text{v} \\\\ \\hline \\end{array}\$\$

> **Principio Fondamentale:** Un'ipotesi falsa produce **SEMPRE un'implicazione vera**.
> Pertanto, la verità di \$A \\implies B\$ non dice nulla su \$B\$ né su \$A\$. Solo se sia \$A\$ sia \$A \\implies B\$ sono veri, possiamo dedurre con certezza che \$B\$ è vero (*Modus Ponens*).

**Negazione dell'Implicazione:** La negazione di \$A \\implies B\$ NON è un'altra implicazione, bensì:
\$\$\\neg(A \\implies B) \\equiv A \\land \\neg B\$\$

**La Proposizione Contrapposta (Osservazione 1.9):**
La [Proposizione Contrapposta](term:contrapposta) di \$A \\implies B\$ è \$\\neg B \\implies \\neg A\$. Esse sono **logicamente equivalenti**:

\$\$\\begin{array}{|c|c|c|c|c|c|} \\hline A & B & \\neg A & \\neg B & A \\implies B & \\neg B \\implies \\neg A \\\\ \\hline \\text{v} & \\text{v} & \\text{f} & \\text{f} & \\text{v} & \\text{v} \\\\ \\text{v} & \\text{f} & \\text{f} & \\text{v} & \\text{f} & \\text{f} \\\\ \\text{f} & \\text{v} & \\text{v} & \\text{f} & \\text{v} & \\text{v} \\\\ \\text{f} & \\text{f} & \\text{v} & \\text{v} & \\text{v} & \\text{v} \\\\ \\hline \\end{array}\$\$

Questa osservazione è la base della **dimostrazione per contrapposizione**: invece di dimostrare che \$A \\implies B\$, si dimostra che \$\\neg B \\implies \\neg A\$.

---

### 1.1.6 Condizione Necessaria e Sufficiente

La terminologia [Condizione Necessaria e Sufficiente](term:condizione_necessaria_sufficiente) esprime relazioni di implicazione:
- *"\$A\$ è sufficiente per \$B\$"* \$\\iff (A \\implies B)\$.
- *"\$A\$ è necessario per \$B\$"* \$\\iff (B \\implies A)\$.
- *"\$A\$ è necessario e sufficiente per \$B\$"* \$\\iff (A \\iff B)\$.

---

### 1.1.7 Tautologie e Contraddizioni

- Una [Tautologia](term:tautologia_contraddizione) è un'espressione logica che risulta SEMPRE vera per ogni possibile assegnazione di verità delle sue variabili (es. \$A \\lor \\neg A\$).
- Una **Contraddizione** è un'espressione sempre falsa (es. \$A \\land \\neg A\$). Nelle dimostrazioni per assurdo, supporre la falsità della tesi e ricavare una contraddizione prova la verità dell'enunciato originario.
''',
  );

  // ==========================================================================
  // LEZIONE 1.2: TEORIA DEGLI INSIEMI, PARADOSSI E PRODOTTO CARTESIANO (pp. 17-24)
  // ==========================================================================
  static const UniversityLecture lecture2 = UniversityLecture(
    id: 'polimi_gal_1_2_insiemi',
    number: '1.2',
    title: 'Insiemi, Paradossi e Prodotto Cartesiano',
    subtitle: 'Definizione di Cantor, paradossi di Russell e Berry, coppie di Kuratowski e spazio ℝⁿ',
    pageRange: 'pp. 17-24',
    defaultColor: LectureColorCode.essential,
    estimatedMinutes: 30,
    keyTermIds: [
      'insieme_cantor',
      'insieme_vuoto',
      'insieme_parti',
      'paradosso_russell',
      'paradosso_berry',
      'prodotto_cartesiano',
      'coppia_ordinata_kuratowski',
      'nupla_spazio_rn',
      'operazioni_insiemi',
    ],
    markdownContent: r'''
# 1.2 Insiemi e Prodotto Cartesiano

Uno schema ricorrente in algebra è il seguente: poco dopo aver introdotto un tipo di oggetto, si definiscono le corrispondenze ammesse tra di essi.
- Insiemi \$\\longrightarrow\$ [Applicazioni](term:applicazione_funzione)
- Gruppi \$\\longrightarrow\$ [Omomorfismi di Gruppo](term:omomorfismo_gruppi)
- Spazi Vettoriali \$\\longrightarrow\$ Applicazioni Lineari

---

### 1.2.1 La Definizione di Insieme (Cantor 1895)

**Definizione 1.11:** Per [Insieme](term:insieme_cantor) intendiamo ogni raggruppamento ben definito di oggetti determinati e distinti della nostra intuizione o del nostro pensiero (chiamati elementi di \$M\$) in un tutto:

\$\$M = \\{m\\}\$\$

Se \$x\$ è elemento di \$M\$, scriviamo \$x \\in M\$. Altrimenti \$x \\notin M\$.
Esiste un unico insieme privo di elementi: l'[Insieme Vuoto](term:insieme_vuoto), denotato con \$\\emptyset\$.

**Le tre modalità per definire un insieme da zero:**
1. **Per elenco:** \$\\{1, 2, 3, 4, 5\\}\$. L'ordine non ha importanza: \$\\{1, 2\\} = \\{2, 1\\}\$. La molteplicità non conta: \$\\{1, 1, 2\\} = \\{1, 2\\}\$.
2. **Per proprietà caratteristica:** \$\\{x \\in M \\mid P(x)\\}\$.
3. **Applicando una formula:** \$\\{f(x) \\mid x \\in M\\}\$, ad esempio \$2\\mathbb{Z} = \\{2x \\mid x \\in \\mathbb{Z}\\}\$.

**Uguaglianza di Insiemi (Doppia Inclusione):**
Due insiemi sono uguali (\$M = N\$) quando contengono gli stessi elementi. Per dimostrarlo si dimostrano separatamente le due inclusioni:
\$\$(x \\in M \\implies x \\in N) \\quad \\text{e} \\quad (x \\in N \\implies x \\in M)\$\$

**Inclusione e Sottoinsiemi:**
- \$N \\subseteq M\$ (sottoinsieme): ogni elemento di \$N\$ appartiene anche a \$M\$.
- \$N \\subsetneq M\$ (sottoinsieme proprio): \$N \\subseteq M\$ e \$N \\neq M\$.

---

### Insieme delle Parti (Definizione 1.16)

L'[Insieme delle Parti](term:insieme_parti) di \$M\$, indicato con \$\\mathcal{P}(M)\$ oppure \$2^M\$, è l'insieme di tutti i possibili sottoinsiemi di \$M\$:

\$\$\\mathcal{P}(M) = 2^M := \\{N : N \\subseteq M\\}\$\$

Se la cardinalità di \$M\$ è \$m\$, allora la cardinalità dell'insieme delle parti è esattamente \$2^m\$. Per qualsiasi insieme \$M\$, si ha sempre:
\$\$\\emptyset \\in 2^M \\quad \\text{e} \\quad M \\in 2^M\$\$

---

### 1.2.2 Due Paradossi Fondamentali

La definizione intuitiva di Cantor conduce a contraddizioni insanabili se non limitata assiomaticamente:

1. **Il [Paradosso di Russell (1903)](term:paradosso_russell):**
   Sia \$S = \\{M \\mid M \\text{ è un insieme}\\}\$ la collezione di tutti gli insiemi. Se \$S\$ fosse un insieme, potremmo considerare:
   \$\$T = \\{M \\in S : M \\notin M\\}\$\$
   Ci chiediamo: \$T \\in T\$?
   - Se \$T \\in T \\implies T \\notin T\$ (assurdo).
   - Se \$T \\notin T \\implies T \\in T\$ (assurdo).
   In altre parole: \$T \\in T \\iff T \\notin T\$, una **contraddizione logica netta**.
   *Conclusione:* La totalità di tutti gli insiemi non è un insieme, ma una **classe**.

2. **Il [Paradosso di Berry](term:paradosso_berry):**
   Mostra che il linguaggio comune non può essere la base rigorosa della matematica, poiché genera contraddizioni semantiche basate sulla ricchezza descrittiva delle parole.

---

### 1.2.3 Il Prodotto Cartesiano e le Coppie di Kuratowski

Negli insiemi l'ordine non conta. Ma in geometria e fisica abbiamo bisogno di elenchi ordinati. Come definire una coppia ordinata senza introdurre concetti magici estranei agli insiemi?

**Definizione 1.17 ([Kuratowski 1921](term:coppia_ordinata_kuratowski)):**
Siano \$M\$ e \$N\$ insiemi, con \$m \\in M\$ e \$n \\in N\$. La coppia ordinata con primo elemento \$m\$ e secondo elemento \$n\$ è definita rigorosamente da:

\$\$(m, n) := \\{\\{m\\}, \\{m, n\\}\\}\$\$

Questa definizione garantisce la proprietà fondamentale dell'ordine:
\$\$(m_1, m_2) = (n_1, n_2) \\iff m_1 = n_1 \\land m_2 = n_2\$\$

**Definizione 1.19 ([Prodotto Cartesiano](term:prodotto_cartesiano)):**
\$\$M \\times N := \\{(m, n) \\mid m \\in M \\land n \\in N\\}\$\$

**Generalizzazione a n-uple e Spazio \$\\mathbb{R}^n\$ (Definizione 1.20):**
Per induzione, una [n-upla ordinata](term:nupla_spazio_rn) è una coppia avente per primo elemento una \$(n-1)\$-upla:
\$\$(a_1, \\dots, a_n) := ((a_1, \\dots, a_{n-1}), a_n)\$\$
Lo spazio euclideo reale \$n\$-dimensionale è:
\$\$\\mathbb{R}^n = \\{(x_1, \\dots, x_n) : x_i \\in \\mathbb{R} \\quad \\forall i = 1, \\dots, n\\}\$\$

---

### 1.2.4 Operazioni con gli Insiemi

- **Unione:** \$M_1 \\cup M_2 := \\{x \\in M \\mid x \\in M_1 \\lor x \\in M_2\\}\$
- **Intersezione:** \$M_1 \\cap M_2 := \\{x \\in M \\mid x \\in M_1 \\land x \\in M_2\\}\$
- **Differenza:** \$M_1 \\setminus M_2 := \\{x \\in M \\mid x \\in M_1 \\land x \\notin M_2\\}\$
- **Complemento:** Se \$M_2 \\subseteq M_1\$, \$\\complement_{M_1} M_2 := M_1 \\setminus M_2\$.
''',
  );

  // ==========================================================================
  // LEZIONE 1.3: APPLICAZIONI (FUNZIONI), COMPOSIZIONE E INVERTIBILITÀ (pp. 25-36)
  // ==========================================================================
  static const UniversityLecture lecture3 = UniversityLecture(
    id: 'polimi_gal_1_3_applicazioni',
    number: '1.3',
    title: 'Applicazioni, Composizione e Invertibilità',
    subtitle: 'Grafico, fibre, iniettività, suriettività, biiettività, retrazioni, sezioni e Teorema 1.31',
    pageRange: 'pp. 25-36',
    defaultColor: LectureColorCode.essential,
    estimatedMinutes: 40,
    keyTermIds: [
      'applicazione_funzione',
      'dominio_codominio_immagine',
      'fibra_controimmagine',
      'composizione_applicazioni',
      'applicazione_iniettiva',
      'applicazione_suriettiva',
      'applicazione_biiettiva',
      'retrazione_sezione',
      'monomorfismo_epimorfismo',
    ],
    markdownContent: r'''
# 1.3 Applicazioni (Funzioni) e loro Proprietà

> *"Poiché 'regola' non è un concetto definito chiaramente, dobbiamo assicurarci di poter dare una definizione rigorosa basandoci soltanto sugli insiemi."* — Prof. Constantinescu

---

### 1.2.5 Definizione Formale di Applicazione

**Definizione 1.22:** Un'[Applicazione (Funzione)](term:applicazione_funzione) \$f\$ da un insieme \$A\$ in un insieme \$B\$ è una **terna**:

\$\$f = (A, B, \\Gamma_f)\$\$

dove:
- \$A\$ è il [Dominio](term:dominio_codominio_immagine)
- \$B\$ è il [Codominio](term:dominio_codominio_immagine)
- \$\\Gamma_f \\subseteq A \\times B\$ è il **grafico** di \$f\$, che soddisfa l'assioma di unicità:
\$\$\\forall x \\in A, \\quad \\exists! y \\in B : (x, y) \\in \\Gamma_f\$\$

Indichiamo questo unico \$y\$ con \$f(x)\$ (l'**immagine** di \$x\$ sotto \$f\$).
L'**immagine complessiva** dell'applicazione è:
\$\$\\text{Im}(f) := \\{f(x) : x \\in A\\} \\subseteq B\$\$

**Controimmagine e Fibra:**
- Per ogni sottoinsieme \$B' \\subseteq B\$, la controimmagine è \$f^{-1}(B') := \\{x \\in A \\mid f(x) \\in B'\\}\$.
- Per ogni elemento \$y \\in B\$, la [Fibra sopra y](term:fibra_controimmagine) è la controimmagine del singoletto:
\$\$f^{-1}(y) := \\{x \\in A : f(x) = y\\}\$\$

**Uguaglianza di Applicazioni (Osservazione 1.23):**
Due applicazioni \$f = (A, B, \\Gamma_f)\$ e \$g = (C, D, \\Gamma_g)\$ sono uguali se e solo se:
\$\$A = C, \\quad B = D, \\quad \\text{e} \\quad f(x) = g(x) \\; \\forall x \\in A\$\$

---

### 1.2.6 Composizione delle Applicazioni

**Definizione 1.24:** Siano \$f: A \\to B\$ e \$g: C \\to D\$. Si dicono **componibili** se e solo se \$B = C\$. In tal caso la [Composizione](term:composizione_applicazioni) \$g \\circ f: A \\to D\$ è data da:

\$\$(g \\circ f)(x) := g(f(x))\$\$

**Proprietà Fondamentali (Osservazione 1.25):**
1. **Associatività:** \$h \\circ (g \\circ f) = (h \\circ g) \\circ f =: h \\circ g \\circ f\$.
2. **Elemento Neutro (Identità):** Per ogni insieme \$M\$, l'applicazione identica \$\\text{id}_M(x) = x\$ funge da neutro:
\$\$f \\circ \\text{id}_A = f \\quad \\text{e} \\quad \\text{id}_B \\circ f = f\$\$
3. **NON Commutatività:** In generale, \$g \\circ f \\neq f \\circ g\$.

---

### 1.2.7 Proprietà Fondamentali: Iniettività, Suriettività, Biiettività

**Definizione 1.26:** Un'applicazione \$f: A \\to B\$ si dice:

1. **[Iniettiva](term:applicazione_iniettiva):** se ad elementi distinti assegna immagini distinte:
\$\$\\forall x, y \\in A, \\quad x \\neq y \\implies f(x) \\neq f(y) \\iff f(x) = f(y) \\implies x = y\$\$
*(In termini di fibre: ogni fibra \$f^{-1}(b)\$ contiene **al massimo un elemento**).*

2. **[Suriettiva](term:applicazione_suriettiva):** se ogni elemento del codominio è raggiunto:
\$\$\\forall b \\in B, \\quad \\exists x \\in A : f(x) = b \\iff \\text{Im}(f) = B\$\$
*(In termini di fibre: ogni fibra \$f^{-1}(b)\$ contiene **almeno un elemento**).*

3. **[Biiettiva](term:applicazione_biiettiva):** se è contemporaneamente iniettiva e suriettiva:
\$\$\\forall b \\in B, \\quad \\exists! x \\in A : f(x) = b\$\$
*(In termini di fibre: ogni fibra \$f^{-1}(b)\$ contiene **esattamente un elemento**).*

4. **Invertibile:** se esiste un'applicazione inversa \$f^{-1}: B \\to A\$ tale che:
\$\$f \\circ f^{-1} = \\text{id}_B \\quad \\text{e} \\quad f^{-1} \\circ f = \\text{id}_A\$\$

---

### Retrazione, Sezione e Teorema 1.31

**Definizione 1.30 ([Retrazione e Sezione](term:retrazione_sezione)):**
- Un'applicazione \$\\bar{f}: B \\to A\$ con \$\\bar{f} \\circ f = \\text{id}_A\$ si chiama **inversa sinistra** o **retrazione**.
- Un'applicazione \$\\tilde{f}: B \\to A\$ con \$f \\circ \\tilde{f} = \\text{id}_B\$ si chiama **inversa destra** o **sezione**.

**Teorema 1.31 (Teorema Cardine delle Applicazioni):**
Sia \$f: A \\to B\$ tra due insiemi non vuoti. Allora:
1. \$f\$ è iniettiva \$\\iff f\$ ammette una retrazione.
2. \$f\$ è suriettiva \$\\iff f\$ ammette una sezione (dimostrazione con Assioma della Scelta).
3. \$f\$ è biiettiva \$\\iff f\$ è invertibile.

*Dimostrazione dell'Unicità (Proposizione 1.29):*
Se \$f\$ ammette un'inversa sinistra \$\\bar{f}\$ e un'inversa destra \$\\tilde{f}\$, allora per associatività:
\$\$\\bar{f} = \\bar{f} \\circ \\text{id}_B = \\bar{f} \\circ (f \\circ \\tilde{f}) = (\\bar{f} \\circ f) \\circ \\tilde{f} = \\text{id}_A \\circ \\tilde{f} = \\tilde{f}\$\$
Le due inverse coincidono necessariamente e l'inversa \$f^{-1}\$ è **unica**. Q.E.D.

**Corollario 1.34 (Composizione e Proprietà):**
- Se \$f\$ e \$g\$ sono biiettive, allora \$g \\circ f\$ è biiettiva e \$(g \\circ f)^{-1} = f^{-1} \\circ g^{-1}\$.
- Se \$g \\circ f\$ è iniettiva \$\\implies f\$ è iniettiva.
- Se \$g \\circ f\$ è suriettiva \$\\implies g\$ è suriettiva.

---

### Descrizione Categoriale: Monomorfismi ed Epimorfismi

> [!NOTE]
> Il **Teorema 1.35 e 1.36** caratterizzano le funzioni in termini astratti di "cancellazione" ([Monomorfismi ed Epimorfismi](term:monomorfismo_epimorfismo)):
> - \$f\$ è iniettiva \$\\iff (f \\circ g = f \\circ g' \\implies g = g')\$ *(cancellabile a sinistra)*.
> - \$f\$ è suriettiva \$\\iff (g \\circ f = g' \\circ f \\implies g = g')\$ *(cancellabile a destra)*.
''',
  );

  // ==========================================================================
  // LEZIONE 1.4: FAMIGLIE DI INSIEMI, CARDINALITÀ E ASSIOMA DELLA SCELTA (pp. 37-45)
  // ==========================================================================
  static const UniversityLecture lecture4 = UniversityLecture(
    id: 'polimi_gal_1_4_cardinalita',
    number: '1.4',
    title: 'Famiglie, Cardinalità e Assioma della Scelta',
    subtitle: 'Famiglie indicizzate, infinità di Dedekind, Teorema di Cantor 2ᴹ e proprietà universale del prodotto',
    pageRange: 'pp. 37-45',
    defaultColor: LectureColorCode.advanced,
    estimatedMinutes: 35,
    keyTermIds: [
      'cardinalita_equipotenza',
      'infinita_dedekind',
      'teorema_cantor_parti',
      'assioma_scelta',
      'proprieta_universale_prodotto',
      'insieme_parti',
    ],
    markdownContent: r'''
# 1.4 Famiglie di Insiemi, Cardinalità e Assioma della Scelta

Per poter operare simultaneamente con un numero infinito di insiemi dobbiamo formalizzare il concetto di famiglia indicizzata.

---

### 1.2.8 Famiglie di Insiemi e Prodotto Generale

Una famiglia di insiemi indicizzata da \$I\$ è una terna composta da un insieme indice \$I\$, una collezione di insiemi e un'applicazione che ad ogni indice \$i \\in I\$ assegna un insieme \$M_i\$: \$\\mathcal{F} = (M_i)_{i \\in I}\$.

- **Unione di famiglia:** \$\\bigcup_{i \\in I} M_i := \\{x \\mid \\exists i \\in I : x \\in M_i\\}\$.
- **Intersezione di famiglia:** \$\\bigcap_{i \\in I} M_i := \\{x \\mid \\forall i \\in I, x \\in M_i\\}\$.

**Definizione 1.38 (Prodotto Cartesiano Arbitrario):**
Il prodotto cartesiano di una famiglia \$(M_i)_{i \\in I}\$ è l'insieme delle funzioni:
\$\$\\prod_{i \\in I} M_i := \\left\\{ f : I \\to \\bigcup_{i \\in I} M_i \\;\\middle|\\; f(i) \\in M_i \\quad \\forall i \\in I \\right\\}\$\$
I suoi elementi si chiamano **tuple** generalizzate (per \$I = \\{1, \\dots, n\\}\$ ritroviamo le consuete \$n\$-uple).

---

### 1.2.9 Definizione Rigorosa di Cardinalità

**Definizione 1.42:** Due insiemi \$A\$ e \$B\$ si dicono **[Equipotenti](term:cardinalita_equipotenza)** (\$A \\approx B\$) se e solo se esiste una **biiezione** tra di essi:

\$\$A \\approx B \\iff \\exists f: A \\to B \\text{ biiettiva}\$\$

**Definizione 1.43 ([Infinità di Dedekind](term:infinita_dedekind)):**
Un insieme \$M\$ è **infinito** se e solo se esiste un sottoinsieme proprio \$M' \\subsetneq M\$ equipotente a \$M\$. Un insieme è finito se non è infinito.

*Osservazione 1.44:* \$M\$ è infinito \$\\iff\$ esiste un'applicazione iniettiva \$f: M \\to M\$ che NON è suriettiva (es. \$f(n) = n + 1\$ su \$\\mathbb{N}\$).

**Definizione 1.45:** Un insieme si dice **numerabile** se è equipotente all'insieme dei numeri naturali \$\\mathbb{N}\$.

---

### Teorema 1.48 (Teorema di Cantor sull'Insieme delle Parti)

**Teorema 1.48:** Sia \$M\$ un insieme qualsiasi e \$2^M\$ il suo insieme delle parti. **Non esiste alcuna biiezione tra \$M\$ e \$2^M\$.**

*Dimostrazione (Argomento Diagonale di Cantor):*
Supponiamo per assurdo che esista una biiezione \$f: M \\to 2^M\$.
Definiamo il sottoinsieme:
\$\$B := \\{m \\in M \\mid m \\notin f(m)\\} \\in 2^M\$\$
Poiché \$f\$ è suriettiva, deve esistere un elemento \$b \\in M\$ tale che \$f(b) = B\$.
Ci chiediamo ora se \$b \\in B\$:
\$\$b \\in B \\iff b \\notin f(b) \\iff b \\notin B\$\$
Abbiamo ottenuto una **contraddizione logica netta**: \$b \\in B \\iff b \\notin B\$.
Dunque nessuna biiezione può esistere. **Q.E.D.**

> **Corollario Fondamentale:** Per ogni insieme \$M\$, la cardinalità delle parti è strettamente superiore:
> \$\$|M| < |2^M|\$\$
> Questo dimostra l'esistenza di infiniti di ordine superiore: \$\\mathbb{R} \\approx 2^\\mathbb{N}\$ non è numerabile (Teorema 1.50).

---

### 1.2.10 L'Assioma della Scelta (ZFC)

**L'[Assioma della Scelta](term:assioma_scelta):** Per ogni insieme \$\\mathcal{P}\$ di insiemi non vuoti, esiste una funzione \$f\$ che associa ad ogni \$X \\in \\mathcal{P}\$ un elemento \$f(X) \\in X\$.

**Formulazioni Equivalenti Cruciali per l'Algebra Lineare (Osservazione 1.54):**
1. **Esistenza di una Base:** Ogni spazio vettoriale ammette una base.
2. **Estensione a una Base:** Ogni insieme linearmente indipendente di uno spazio vettoriale è contenuto in una base.
3. **Lemma di Zorn:** Ogni insieme parzialmente ordinato induttivo ammette un elemento massimale.
4. **Sezione:** Ogni funzione suriettiva ammette un'inversa destra.

---

### 1.2.11 Proprietà Universale del Prodotto Cartesiano

> [!NOTE]
> Il **Teorema 1.55** stabilisce che il prodotto cartesiano \$P = \\prod M_i\$ con le proiezioni \$p_i\$ è l'unico oggetto per cui, data qualsiasi famiglia di morfismi \$u_i: N \\to M_i\$, esiste un'**unica** applicazione \$u: N \\to P\$ tale che:
> \$\$p_i \\circ u = u_i \\quad \\forall i \\in I\$\$
> Questo determina il prodotto cartesiano in modo canonico a meno di isomorfismo unico.
''',
  );

  // ==========================================================================
  // LEZIONE 1.5: RELAZIONI DI EQUIVALENZA, QUOZIENTI E ARITMETICA INTERA (pp. 46-57)
  // ==========================================================================
  static const UniversityLecture lecture5 = UniversityLecture(
    id: 'polimi_gal_1_5_relazioni',
    number: '1.5',
    title: 'Relazioni, Insiemi Quoziente e Aritmetica Intera',
    subtitle: 'Relazioni di equivalenza, partizioni, proiezione quoziente, divisione euclidea, Bézout e ℤ/nℤ',
    pageRange: 'pp. 46-57',
    defaultColor: LectureColorCode.essential,
    estimatedMinutes: 45,
    keyTermIds: [
      'relazione_binaria',
      'relazione_equivalenza',
      'classe_equivalenza',
      'partizione_insieme',
      'insieme_quoziente',
      'buon_ordinamento',
      'divisibilita_interi',
      'divisione_resto',
      'massimo_comune_divisore_mcm',
      'lemma_bezout',
      'algoritmo_euclideo',
      'congruenza_modulo_n',
      'anello_quoziente_zn',
      'campo_finito_fp',
    ],
    markdownContent: r'''
# 1.5 Relazioni, Insiemi Quoziente e Divisibilità Intera

> *"L'insieme quoziente è fondamentale per molte costruzioni matematiche: occorre dedicare il tempo necessario per capire a fondo la sua definizione."* — Prof. Constantinescu

---

### 1.3 Relazioni Binarie e Proprietà Fondamentali

**Definizione 1.58:** Una [Relazione Binaria](term:relazione_binaria) su un insieme \$M\$ è un sottoinsieme \$R \\subseteq M \\times M\$. Scriviamo \$x \\sim y\$ se \$(x, y) \\in R\$.

Una relazione può essere:
1. **Riflessiva:** \$x \\sim x \\quad \\forall x \\in M\$.
2. **Simmetrica:** \$x \\sim y \\implies y \\sim x\$.
3. **Antisimmetrica:** \$(x \\sim y \\land y \\sim x) \\implies x = y\$.
4. **Transitiva:** \$(x \\sim y \\land y \\sim z) \\implies x \\sim z\$.

---

### 1.3.1 Relazioni di Equivalenza e Partizioni

**Definizione 1.60:** Una [Relazione di Equivalenza](term:relazione_equivalenza) è una relazione contemporaneamente **riflessiva, simmetrica e transitiva**.

**Definizione 1.61 ([Classe di Equivalenza](term:classe_equivalenza)):**
Per ogni \$x \\in M\$, la sua classe di equivalenza è l'insieme:
\$\\[x\\]_\\sim := \\{m \\in M : m \\sim x\\}\$\$
Ogni elemento di \$\\[x\\]\$ si chiama **rappresentante** della classe. Un sottoinsieme \$M' \\subseteq M\$ che contiene esattamente un elemento per ciascuna classe è detto **sistema di rappresentanti**.

**Teorema 1.65 (Teorema Fondamentale delle Relazioni di Equivalenza):**
Sia \$\\sim\$ una relazione di equivalenza su \$M\$.
1. Due classi di equivalenza \$\\[x\\]\$ e \$\\[y\\]\$ o sono **disgiunte** o **coincidono**:
\$\$\\[x\\] \\cap \\[y\\] = \\emptyset \\quad \\text{oppure} \\quad \\[x\\] = \\[y\\] \\iff x \\sim y\$\$
2. L'insieme \$M\$ è l'unione disgiunta di tutte le classi di equivalenza:
\$\$M = \\bigsqcup_{C \\in M/\\sim} C\$\$

> **Corollario (Osservazione 1.66-1.67):** Ogni relazione di equivalenza definisce una [Partizione](term:partizione_insieme) di \$M\$, e viceversa ogni partizione di \$M\$ definisce una relazione di equivalenza ponendo \$x \\sim y \\iff x, y\$ appartengono allo stesso blocco della partizione.

---

### Definizione 1.68: L'Insieme Quoziente

L'[Insieme Quoziente](term:insieme_quoziente) di \$M\$ modulo \$\\sim\$ è l'insieme che ha come elementi le singole classi di equivalenza:

\$\$M/\\sim := \\{ [x] : x \\in M \\}\$\$

L'applicazione \$p: M \\to M/\\sim\$, data da \$x \\mapsto [x]\$, è la **proiezione canonica al quoziente** (sempre suriettiva).

**Teorema 1.71 (Proprietà Universale del Quoziente):**
Un'applicazione \$\\hat{f}: M/\\sim \\to A\$ data da \$\\hat{f}([m]) := f(m)\$ è **ben definita** (cioè indipendente dalla scelta del rappresentante \$m\$) se e solo se:
\$\$a \\sim b \\implies f(a) = f(b)\$\$

---

### 1.4 Divisibilità nei Numeri Interi ed Algoritmo Euclideo

Ricordiamo il **[Buon Ordinamento di ℕ](term:buon_ordinamento)**: ogni sottoinsieme non vuoto di numeri naturali contiene un elemento minimo.

**Definizione 1.72 ([Divisibilità](term:divisibilita_interi)):**
Dati \$a, b \\in \\mathbb{Z}\$, diciamo che \$a\$ divide \$b\$ (\$a \\mid b\$) se esiste \$c \\in \\mathbb{Z}\$ tale che \$b = ac\$.

**Teorema 1.76 ([Divisione con Resto](term:divisione_resto)):**
Siano \$a, b \\in \\mathbb{Z}\$ con \$b > 0\$. Allora esistono e sono **unici** due interi quoziente \$q\$ e resto \$r\$ tali che:
\$\$a = qb + r \\quad \\text{con} \\quad 0 \\le r < b\$\$

*Dimostrazione dell'Esistenza (tramite Buon Ordinamento):*
Consideriamo l'insieme \$S := \\{a - sb \\mid s \\in \\mathbb{Z} \\land a - sb \\ge 0\\} \\subseteq \\mathbb{N}\$.
Poiché \$S \\neq \\emptyset\$, per il buon ordinamento di \$\\mathbb{N}\$ esiste il minimo \$r := \\min S\$.
Ponendo \$q = s_0\$ (il valore per cui \$r = a - qb\$), si dimostra che necessariamente \$r < b\$ (altrimenti \$r - b \\in S\$, contraddicendo la minimalità di \$r\$). Q.E.D.

**Il [Lemma di Bézout (Lemma 1.80)](term:lemma_bezout):**
Se \$d = \\gcd(a, b)\$, allora esistono due interi \$s, t \\in \\mathbb{Z}\$ tali che:
\$\$d = as + bt\$\$
In particolare, due interi sono coprimi (\$\\gcd(a, b) = 1\$) se e solo se esistono \$s, t\$ con \$as + bt = 1\$.

**L'[Algoritmo Euclideo (Teorema 1.83)](term:algoritmo_euclideo):**
Calcola il MCD effettuando divisioni successive:
\$\$r_{i-1} = q_i r_i + r_{i+1} \\quad (0 \\le r_{i+1} < r_i)\$\$
Termina in un numero finito di passi; l'ultimo resto non nullo è esattamente \$\\gcd(a, b)\$.

---

### 1.5 Aritmetica Modulare e l'Anello ℤ/nℤ

**Definizione 1.89 ([Congruenza Modulo n](term:congruenza_modulo_n)):**
Due interi \$a, b\$ sono congrui modulo \$n\$ se \$n\$ divide la loro differenza:
\$\$a \\equiv b \\pmod n \\iff n \\mid (a - b)\$\$

L'[Anello Quoziente ℤ/nℤ](term:anello_quoziente_zn) è:
\$\$\\mathbb{Z}/n\\mathbb{Z} = \\{[0], [1], \\dots, [n-1]\\}\$\$

Le operazioni di addizione e moltiplicazione sono ben definite:
\$\$[a] + [b] := [a + b], \\quad [a] \\cdot [b] := [a \\cdot b]\$\$

**Teorema 1.92 (Invertibilità in ℤ/nℤ):**
Una classe non nulla \$[a] \\in \\mathbb{Z}/n\\mathbb{Z}\$ ammette inverso moltiplicativo se e solo se \$\\gcd(a, n) = 1\$.

> **[Campi Finiti (Campi Primi 𝔽_p)](term:campo_finito_fp):**
> Se \$n = p\$ è un numero **primo**, ogni classe non nulla ha \$\\gcd(a, p) = 1\$ ed è quindi invertibile.
> Pertanto, **\$\\mathbb{Z}/p\\mathbb{Z}\$ è un CAMPO** (indicato con \$\\mathbb{F}_p\$), fondamento dell'algebra lineare a corpi finiti.
''',
  );

  // ==========================================================================
  // LEZIONE 1.6: STRUTTURE ALGEBRICHE: GRUPPI, ANELLI, CAMPI (pp. 58-81)
  // ==========================================================================
  static const UniversityLecture lecture6 = UniversityLecture(
    id: 'polimi_gal_1_6_strutture',
    number: '1.6',
    title: 'Strutture Algebriche: Gruppi, Anelli e Campi',
    subtitle: 'Gruppi abeliani, gruppo simmetrico Sₙ, cicli, segnatura, Teorema di Cayley, anelli unitari e campi',
    pageRange: 'pp. 58-81',
    defaultColor: LectureColorCode.essential,
    estimatedMinutes: 50,
    keyTermIds: [
      'operazione_interna',
      'gruppo',
      'gruppo_abeliano',
      'sottogruppo',
      'omomorfismo_gruppi',
      'gruppo_simmetrico',
      'ciclo_permutazione',
      'trasposizione',
      'segnatura_permutazione',
      'sottogruppo_alterno',
      'teorema_cayley',
      'anello_unitario',
      'campo',
      'campo_finito_fp',
      'polinomi_anello',
      'matrici_2x2',
    ],
    markdownContent: r'''
# 1.6 Strutture Algebriche: Gruppi, Anelli, Campi

> *"In molte applicazioni dell'algebra lineare, specialmente in informatica, è utile comprendere il concetto di campo. I numeri reali possono essere sostituiti da altre strutture che condividono le stesse proprietà fondamentali stabilite dalla definizione di campo."* — Prof. Constantinescu

---

### 1.6.1 Operazioni Interne ed Assiomi Fondamentali

**Definizione 1.94:** Un'[Operazione Interna](term:operazione_interna) su un insieme \$M\$ è un'applicazione:
\$\$* : M \\times M \\to M, \\quad (a, b) \\mapsto a * b\$\$

- **Associativa:** \$a * (b * c) = (a * b) * c\$ per ogni \$a, b, c \\in M\$.
- **Commutativa:** \$a * b = b * a\$ per ogni \$a, b \\in M\$.
- **Elemento Neutro:** \$e \\in M\$ tale che \$e * m = m * e = m\$. Se esiste, è **unico** (Osservazione 1.95: \$e = e * e' = e'\$).
- **Elemento Inverso:** \$m^{-1}\$ tale che \$m * m^{-1} = m^{-1} * m = e\$. Se l'operazione è associativa, l'inverso è **unico** (Osservazione 1.97).
- Inoltre: \$(a * b)^{-1} = b^{-1} * a^{-1}\$.

---

### 1.6.2 Definizioni di Base della Teoria dei Gruppi

**Definizione 1.99:** Un **[Gruppo](term:gruppo)** è una coppia ordinata \$(G, *)\$ che soddisfa tre assiomi:
- **(Gr 1)** L'operazione \$*\$ è associativa.
- **(Gr 2)** Esiste un elemento neutro \$e \\in G\$.
- **(Gr 3)** Per ogni \$g \\in G\$ esiste un inverso \$g^{-1} \\in G\$.

Se l'operazione è commutativa, il gruppo si dice **[Abeliano](term:gruppo_abeliano)**.

**Regole di Cancellazione (Lemma 1.104):**
Nei gruppi valgono sempre le semplificazioni a sinistra e a destra:
\$\$g_1 * g_2 = g_1 * g_3 \\implies g_2 = g_3\$\$
La tavola di moltiplicazione di un gruppo finito rispetta la *"regola del Sudoku"*: ogni elemento appare esattamente una volta in ogni riga e colonna.

---

### Sottogruppi e Criterio di Sottogruppo (Teorema 1.107)

Un sottoinsieme \$H \\subseteq G\$ è un **[Sottogruppo](term:sottogruppo)** (\$H \\le G\$) se è chiuso, contiene il neutro e gli inversi.

**Criterio di Sottogruppo in un solo passo:**
\$\$H \\le G \\iff H \\neq \\emptyset \\quad \\text{e} \\quad \\forall a, b \\in H, \\; ab^{-1} \\in H\$\$

**Teorema 1.109:** Tutti i sottogruppi del gruppo additivo \$(\\mathbb{Z}, +)\$ sono della forma:
\$\$n\\mathbb{Z} = \\{ nz : z \\in \\mathbb{Z} \\} \\quad \\text{per un unico } n \\in \\mathbb{N}\$\$

---

### 1.6.5 Il Gruppo Simmetrico Sₙ e le Permutazioni

**Definizione 1.103 ([Gruppo Simmetrico Sₙ](term:gruppo_simmetrico)):**
È il gruppo di tutte le biiezioni (permutazioni) di \$\\{1, \\dots, n\\}\$ rispetto alla composizione.
La sua cardinalità è \$\\#S_n = n! = 1 \\cdot 2 \\cdot \\dots \\cdot n\$.

- \$S_1\$ e \$S_2\$ sono abeliani.
- Per \$n \\ge 3\$, \$S_n\$ è **non commutativo**. \$S_3\$ (6 elementi) è il più piccolo gruppo non commutativo della matematica.

**[Cicli](term:ciclo_permutazione) e Decomposizione Unica (Teorema 1.114):**
Un \$k\$-ciclo \$\\sigma = (i_1 \\; i_2 \\; \\dots \\; i_k)\$ permuta ciclicamente tali elementi.
- Due cicli disgiunti **commutano sempre**: \$\\gamma \\cdot \\omega = \\omega \\cdot \\gamma\$.
- **Teorema 1.114:** Ogni permutazione \$\\sigma \\in S_n\$ si decompone in modo **unico** come prodotto di cicli disgiunti.

**[Trasposizioni](term:trasposizione) e [Segnatura](term:segnatura_permutazione):**
Una trasposizione è un 2-ciclo \$(i \\; j)\$. Ogni permutazione è prodotto di trasposizioni.
La **segnatura** di una permutazione è:
\$\$\\text{sgn}(\\sigma) := \\prod_{1 \\le i < j \\le n} \\frac{\\sigma(j) - \\sigma(i)}{j - i} = (-1)^{|\\text{inv}(\\sigma)|} \\in \\{+1, -1\\}\$\$

- **Teorema 1.121:** L'applicazione \$\\text{sgn}: S_n \\to \\{+1, -1\\}\$ è un **omomorfismo di gruppi**.
- Le trasposizioni hanno sempre segnatura \$-1\$.
- Il nucleo dell'omomorfismo definisce il **[Sottogruppo Alterno Aₙ](term:sottogruppo_alterno)**, formato dalle permutazioni pari, con cardinalità \$n! / 2\$.

---

### Teorema 1.126 (Teorema di Cayley)

**Teorema di Cayley:** Per ogni gruppo finito \$G\$, esiste un \$n \\in \\mathbb{N}\$ tale che \$G\$ è **isomorfo a un sottogruppo del gruppo simmetrico \$S_n\$**.

*Dimostrazione:*
Ogni elemento \$g \\in G\$ definisce la traslazione biiettiva \$m_g(x) := g \\cdot x\$.
L'applicazione \$\\Phi: G \\to S_{|G|}\$ data da \$g \\mapsto m_g\$ è un omomorfismo iniettivo (\$\\ker \\Phi = \\{e\\}\$).
Dunque \$G \\cong \\text{Im}(\\Phi) \\le S_{|G|}\$. Q.E.D.

---

### 1.6.6 Anelli Unitari e Commutativi

**Definizione 1.128:** Un **[Anello Unitario](term:anello_unitario)** è una terna \$(R, +, \\cdot)\$ dove:
- **(R 1)** \$(R, +)\$ è un gruppo abeliano (elemento neutro \$0_R\$).
- **(R 2)** La moltiplicazione \$\\cdot\$ è associativa e possiede elemento neutro unitario \$1_R\$.
- **(R 3) Leggi distributive:** \$a(b + c) = ab + ac\$ e \$(a + b)c = ac + bc\$.

Se \$ab = ba\$, l'anello si dice **commutativo**.
In ogni anello vale: \$0 \\cdot a = 0\$ e \$-a = (-1) \\cdot a\$.

---

### 1.6.7 Campi

**Definizione 1.130:** Un **[Campo](term:campo)** è una terna \$(\\mathbb{K}, +, \\cdot)\$ in cui:
- **(K 1)** \$(\\mathbb{K}, +)\$ è un gruppo abeliano (neutro \$0\$).
- **(K 2)** \$(\\mathbb{K} \\setminus \\{0\\}, \\cdot)\$ è un gruppo abeliano (ogni elemento non nullo è invertibile!).
- **(K 3)** Valgono le leggi distributive.

> **Importanza Fondamentale:** I campi sono il dominio naturale degli scalari per gli spazi vettoriali: permettono di risolvere sistemi lineari ed eseguire eliminazione gaussiana potendo dividere per qualsiasi scalare diverso da zero.
> 
> **Esempi:**
> - \$\\mathbb{Q}, \\mathbb{R}, \\mathbb{C}\$ sono campi infiniti.
> - \$\\mathbb{Z}\$ NON è un campo (gli interi diversi da \$\\pm 1\$ non hanno inverso intero).
> - \$\\mathbb{F}_p = \\mathbb{Z}/p\\mathbb{Z}\$ con \$p\$ primo sono i campi finiti primari.
> - \$\\mathbb{Q}[\\sqrt{2}] = \\{a + b\\sqrt{2} \\mid a, b \\in \\mathbb{Q}\\}\$ è un campo con inverso:
> \$\$\\frac{1}{a + b\\sqrt{2}} = \\frac{a - b\\sqrt{2}}{a^2 - 2b^2}\$\$

---

### 1.6.8 Polinomi e Matrici

- **[Anello dei Polinomi R[x]](term:polinomi_anello):** Espressioni formali \$f = \\sum a_i x^i\$ con grado \$\\deg(f)\$. Con somma termine a termine e prodotto di Cauchy, \$R[x]\$ è un anello commutativo unitario.
- **[Anello delle Matrici Mat₂ₓ₂(ℝ)](term:matrici_2x2):** L'insieme delle matrici \$2 \\times 2\$ a coefficienti reali con la somma e il prodotto riga per colonna forma un **anello non commutativo** con unità \$I_2 = \\begin{pmatrix} 1 & 0 \\\\ 0 & 1 \\end{pmatrix}\$.
''',
  );
}
