import '../../domain/models/university_course_model.dart';

/// Catalogo dei termini matematici del Glossario Ipertestuale di Geometria e Algebra Lineare
/// Direttamente desunti dalle definizioni, teoremi e note del Prof. Alexandru Constantinescu.
class UniversityGlossaryCatalog {
  static final Map<String, UniversityTerm> terms = {
    'enunciato_matematico': const UniversityTerm(
      id: 'enunciato_matematico',
      name: 'Enunciato Matematico',
      symbol: 'A, B, C',
      category: 'Logica ed Enunciati',
      shortDefinition: 'Una frase che è vera oppure falsa, ma non entrambe le cose.',
      formalLatex: r'\text{Val}(A) \in \{\text{Vero}, \text{Falso}\}',
      pedagogicalExplanation:
          'Il valore di verità di un enunciato matematico è oggettivo: non deve dipendere dal momento, '
          'dalle circostanze o dalla persona che lo pronuncia. Frasi ambigue o contestuali ("Oggi è una bella giornata") '
          'non sono enunciati. Enunciati come "2 + 2 = 4" (vero) o "0 = 1" (falso) lo sono pienamente.',
      visualType: VisualDiagramType.truthValueDiagram,
      exampleTitle: 'Esempi di Enunciati e Non-Enunciati',
      exampleText:
          '• "2 + 2 = 4" è un enunciato (vero).\n'
          '• "0 = 1" è un enunciato (falso).\n'
          '• "x è un numero dispari" non è un enunciato finché non specifichiamo x (è una variabile proposizionale).\n'
          '• "Questo enunciato è falso" è un paradosso autoreferenziale insolubile.',
      relatedTermIds: ['tabella_verita', 'negazione', 'implicazione_logica'],
    ),

    'tabella_verita': const UniversityTerm(
      id: 'tabella_verita',
      name: 'Tabella di Verità',
      symbol: r'\begin{array}{c|c} A & \neg A \end{array}',
      category: 'Logica ed Enunciati',
      shortDefinition: 'Tabella che elenca tutti i possibili valori di verità degli ingressi e le rispettive uscite logiche.',
      formalLatex: r'\text{Ingressi } (A_1, \dots, A_n) \longmapsto \text{Uscita } F(A_1, \dots, A_n)',
      pedagogicalExplanation:
          'Le tabelle di verità sono lo strumento per eccellenza per verificare equivalence logiche e tautologie. '
          'Due formule sono logicamente equivalenti se e solo se le corrispondenti colonne di uscita coincidono riga per riga.',
      visualType: VisualDiagramType.truthTableImplication,
      exampleTitle: 'Tabella della Negazione',
      exampleText:
          'Ingresso A: Vero ⇒ Uscita non(A): Falso.\n'
          'Ingresso A: Falso ⇒ Uscita non(A): Vero.\n'
          'La negazione della negazione restituisce la colonna originale: non(non(A)) ≡ A.',
      relatedTermIds: ['enunciato_matematico', 'negazione', 'contrapposta'],
    ),

    'negazione': const UniversityTerm(
      id: 'negazione',
      name: 'Negazione Logica',
      symbol: r'\neg A \text{ oppure } \text{non}(A)',
      category: 'Logica ed Enunciati',
      shortDefinition: "L'opposto contraddittorio di A: se A è vero allora non(A) è falso, e viceversa.",
      formalLatex: r'\neg A \text{ è vero} \iff A \text{ è falso}',
      pedagogicalExplanation:
          'Negare un enunciato significa scambiare il suo valore di verità. Attenzione alle negazioni di enunciati '
          'quantificati: la negazione di "Tutti i gatti sono grigi" non è "Nessun gatto è grigio", bensì "Esiste almeno un gatto che non è grigio".',
      visualType: VisualDiagramType.truthValueDiagram,
      exampleTitle: 'Negazione con Parità',
      exampleText:
          'Se A: "n è un numero naturale pari", allora la negazione non(A) è: "n non è pari", '
          'ovvero (nei numeri naturali) "n è dispari".',
      relatedTermIds: ['enunciato_matematico', 'quantificatori', 'contrapposta'],
    ),

    'congiunzione_disgiunzione': const UniversityTerm(
      id: 'congiunzione_disgiunzione',
      name: 'Congiunzione (e) e Disgiunzione (o)',
      symbol: r'\land, \lor',
      category: 'Logica ed Enunciati',
      shortDefinition: 'Connettivi logici: "e" (vero solo se entrambi veri), "o" (inclusivo, vero se almeno uno è vero).',
      formalLatex: r'A \land B \quad\text{vs}\quad A \lor B',
      pedagogicalExplanation:
          'In matematica il connettivo "o" è SEMPRE inteso in senso inclusivo (dal latino "vel"): '
          '"A o B" è vero se è vero A, se è vero B, oppure se sono veri entrambi. '
          'Per l\'esclusione netta ("aut-aut") si usa la formula: (A o B) e non(A e B).',
      visualType: VisualDiagramType.truthTableImplication,
      exampleTitle: 'Leggi di De Morgan',
      exampleText:
          '• non(A e B) ≡ non(A) o non(B)\n'
          '• non(A o B) ≡ non(A) e non(B)\n'
          'La negazione trasforma la congiunzione in disgiunzione e viceversa.',
      relatedTermIds: ['tabella_verita', 'negazione', 'implicazione_logica'],
    ),

    'quantificatori': const UniversityTerm(
      id: 'quantificatori',
      name: 'Quantificatori (Universale ed Esistenziale)',
      symbol: r'\forall, \exists, \exists!',
      category: 'Logica ed Enunciati',
      shortDefinition: 'Operatori logici che specificano per quanti elementi di un dominio è valida una proprietà.',
      formalLatex: r'\forall x \in M : P(x) \quad\text{e}\quad \exists x \in M : P(x)',
      pedagogicalExplanation:
          '• ∀ ("per ogni"): quantificatore universale. Per verificarlo, x deve essere un elemento generico arbitrario.\n'
          '• ∃ ("esiste"): quantificatore esistenziale. Per verificarlo basta esibire un singolo elemento che soddisfi la condizione.\n'
          '• ∃! ("esiste ed è unico"): esistenza combinata con l\'unicità.\n'
          'ATTENZIONE: ∀ ed ∃ NON commutano! "∀a ∃b (b > a)" è vero in ℕ (non c\'è massimo), ma "∃b ∀a (b > a)" è falso (ci sarebbe un intero maggiore di tutti).',
      visualType: VisualDiagramType.truthValueDiagram,
      exampleTitle: 'Regole di Negazione dei Quantificatori',
      exampleText:
          '• non(∀x, A(x)) ≡ ∃x tale che non(A(x))\n'
          '• non(∃x tale che A(x)) ≡ ∀x, non(A(x))\n'
          'Negare "Tutti gli x soddisfano A" equivale a trovare un controesempio x che non lo soddisfa.',
      relatedTermIds: ['enunciato_matematico', 'negazione'],
    ),

    'implicazione_logica': const UniversityTerm(
      id: 'implicazione_logica',
      name: 'Implicazione Logica',
      symbol: r'A \implies B',
      category: 'Logica ed Enunciati',
      shortDefinition: 'Enunciato condizionale: "Se A è vero, allora B è vero". A è l\'ipotesi, B è la conclusione.',
      formalLatex: r'A \implies B \iff \neg A \lor B',
      pedagogicalExplanation:
          'Punto cardine del ragionamento matematico: un\'ipotesi falsa produce SEMPRE un\'implicazione vera! '
          'Pertanto, la verità di A ⇒ B non assicura che B sia vero: solo se l\'ipotesi A è vera possiamo dedurre '
          'che la conclusione B è vera (Modus Ponens). Se l\'ipotesi è falsa, l\'implicazione è vacuamente vera.',
      visualType: VisualDiagramType.truthTableImplication,
      exampleTitle: 'Negazione di un\'Implicazione',
      exampleText:
          'La negazione di "A ⇒ B" NON è un\'altra implicazione, bensì: "A e non(B)".\n'
          'Per confutare "Se p è primo allora p è dispari", basta esibire il controesempio: p = 2 è primo e 2 non è dispari.',
      relatedTermIds: ['contrapposta', 'inversione_inversa', 'condizione_necessaria_sufficiente'],
    ),

    'contrapposta': const UniversityTerm(
      id: 'contrapposta',
      name: 'Proposizione Contrapposta',
      symbol: r'\neg B \implies \neg A',
      category: 'Logica ed Enunciati',
      shortDefinition: "L'implicazione ottenuta invertendo e negando sia ipotesi che tesi: è logicamente equivalente all'implicazione originaria.",
      formalLatex: r'(A \implies B) \iff (\neg B \implies \neg A)',
      pedagogicalExplanation:
          'Dimostrare la validità di A ⇒ B è assolutamente equivalente a dimostrare non(B) ⇒ non(A). '
          'Questo principio è la chiave di volta di molte dimostrazioni matematiche: quando partire da A risulta difficile, '
          'si suppone che B sia falso e si dimostra che necessariamente anche A deve essere falso.',
      visualType: VisualDiagramType.contrapositiveMatrix,
      exampleTitle: 'Esempio di Dimostrazione per Contrapposizione',
      exampleText:
          'Teorema: "Se a² è pari, allora a è pari".\n'
          'Contrapposta: "Se a è dispari, allora a² è dispari".\n'
          'Dimostrazione: Se a = 2k + 1, allora a² = (2k+1)² = 4k² + 4k + 1 = 2(2k² + 2k) + 1, che è dispari. Q.E.D.',
      relatedTermIds: ['implicazione_logica', 'inversione_inversa'],
    ),

    'inversione_inversa': const UniversityTerm(
      id: 'inversione_inversa',
      name: 'Implicazione Inversa ed Inversione',
      symbol: r'B \implies A \quad\text{vs}\quad \neg A \implies \neg B',
      category: 'Logica ed Enunciati',
      shortDefinition: 'Attenzione a non confonderle: l\'inversa scambia le parti (B ⇒ A), l\'inversione nega entrambe (¬A ⇒ ¬B).',
      formalLatex: r'\text{Inversa: } B \implies A, \quad \text{Inversione: } \neg A \implies \neg B',
      pedagogicalExplanation:
          'Nessuna delle due è logicamente equivalente all\'implicazione originale A ⇒ B! '
          'Ad esempio, se "a ≥ 20 ⇒ a ≥ 10" è vero, la sua inversione "a < 20 ⇒ a < 10" è palesemente falsa (es. a = 15). '
          'Quando sia A ⇒ B sia la sua inversa B ⇒ A sono contemporaneamente vere, diciamo che A e B sono logicamente equivalenti (A ⇔ B).',
      visualType: VisualDiagramType.truthTableImplication,
      exampleTitle: 'Differenza nel Linguaggio Comune',
      exampleText:
          '"Se non metti in ordine, non avrai il gelato". Un bambino deduce che mettendolo in ordine avrà il gelato (inversione). '
          'Ma dal punto di vista logico, la frase nulla dice su cosa accadrà mettendo in ordine!',
      relatedTermIds: ['implicazione_logica', 'contrapposta'],
    ),

    'condizione_necessaria_sufficiente': const UniversityTerm(
      id: 'condizione_necessaria_sufficiente',
      name: 'Condizione Necessaria e Sufficiente',
      symbol: r'A \implies B \quad\text{vs}\quad B \implies A',
      category: 'Logica ed Enunciati',
      shortDefinition: 'A è sufficiente per B se A ⇒ B. A è necessaria per B se B ⇒ A.',
      formalLatex: r'A \text{ suff. per } B \iff (A \implies B); \quad A \text{ nec. per } B \iff (B \implies A)',
      pedagogicalExplanation:
          '• Sufficiente: essere a Milano è sufficiente per essere in Italia (Milano ⇒ Italia).\n'
          '• Necessaria: essere in Italia è necessario per essere a Milano, ma non garantisce di essere a Milano (Milano ⇒ Italia, non viceversa).\n'
          '• Necessaria e Sufficiente: equivale all\'equivalenza logica A ⇔ B ("se e solo se").',
      visualType: VisualDiagramType.truthTableImplication,
      exampleTitle: 'Esempio con la Divisibilità',
      exampleText:
          'Per a, b naturali positivi: "a ≤ b" è condizione necessaria affinché a divida b (a | b ⇒ a ≤ b). '
          'Tuttavia non è sufficiente (es. 4 ≤ 6, ma 4 non divide 6).',
      relatedTermIds: ['implicazione_logica', 'contrapposta'],
    ),

    'tautologia_contraddizione': const UniversityTerm(
      id: 'tautologia_contraddizione',
      name: 'Tautologie e Contraddizioni',
      symbol: r'A \lor \neg A \quad\text{vs}\quad A \land \neg A',
      category: 'Logica ed Enunciati',
      shortDefinition: 'Tautologia: enunciato sempre vero per qualsiasi sostituzione. Contraddizione: enunciato sempre falso.',
      formalLatex: r'\text{Tautologia: } \top, \quad \text{Contraddizione: } \bot',
      pedagogicalExplanation:
          'Una forma proposizionale è una tautologia se la sua colonna nella tabella di verità è composta unicamente da valori "Vero". '
          'Le contraddizioni sono enunciati falsi per ragioni puramente logiche: ottenere una contraddizione in una dimostrazione '
          'per assurdo prova la falsità della premessa ipotizzata.',
      visualType: VisualDiagramType.truthValueDiagram,
      exampleTitle: 'Tautologie Famose',
      exampleText:
          '• Principio del terzo escluso: A o non(A)\n'
          '• Principio di non contraddizione: non(A e non(A))\n'
          '• Sillogismo ipotetico: [(A ⇒ B) ∧ (B ⇒ C)] ⇒ (A ⇒ C)',
      relatedTermIds: ['enunciato_matematico', 'tabella_verita'],
    ),

    'insieme_cantor': const UniversityTerm(
      id: 'insieme_cantor',
      name: 'Insieme (Definizione di Cantor 1895)',
      symbol: r'M = \{m\}',
      category: 'Teoria degli Insiemi',
      shortDefinition: 'Ogni raggruppamento ben definito di oggetti determinati e distinti della nostra intuizione in un tutto.',
      formalLatex: r'x \in M \quad\text{oppure}\quad x \notin M',
      pedagogicalExplanation:
          'Un elemento appartiene a un insieme o non vi appartiene: non esiste ordine tra gli elementi ({1, 2} = {2, 1}) '
          'né conta la molteplicità ({1, 1, 2} = {1, 2}). Le tre modalità fondamentali per definire un insieme sono: '
          '1) per elenco; 2) per proprietà caratteristica {x ∈ M | P(x)}; 3) applicando una formula {f(x) | x ∈ M}.',
      visualType: VisualDiagramType.subsetsLattice,
      exampleTitle: 'Insiemi Numerici Fondamentali',
      exampleText:
          'ℕ = {0, 1, 2, ...} (il corso assume 0 ∈ ℕ)\n'
          'ℤ = {..., -2, -1, 0, 1, 2, ...}\n'
          'ℚ = {a/b : a, b ∈ ℤ, b ≠ 0}\n'
          'ℝ = insieme dei numeri reali\n'
          'ℂ = {a + ib : a, b ∈ ℝ, i² = -1}',
      relatedTermIds: ['insieme_vuoto', 'insieme_parti', 'paradosso_russell'],
    ),

    'insieme_vuoto': const UniversityTerm(
      id: 'insieme_vuoto',
      name: 'Insieme Vuoto',
      symbol: r'\emptyset',
      category: 'Teoria degli Insiemi',
      shortDefinition: "L'unico insieme privo di elementi: per ogni elemento y, l'enunciato y ∈ ∅ è falso.",
      formalLatex: r'\forall y, \quad y \notin \emptyset',
      pedagogicalExplanation:
          'L\'insieme vuoto esiste per assioma ed è unico. Esso è sottoinsieme di qualsiasi insieme M (∅ ⊆ M). '
          'Attenzione a non confondere ∅ con {∅}: il primo ha 0 elementi (|∅| = 0), il secondo ha 1 elemento (|{∅}| = 1).',
      visualType: VisualDiagramType.subsetsLattice,
      exampleTitle: 'Esempi',
      exampleText:
          '• {x ∈ ℝ | x² + 1 = 0} = ∅\n'
          '• 2^∅ = {∅} (l\'insieme delle parti del vuoto non è vuoto, contiene ∅).\n'
          '• ∅ è sottoinsieme proprio di ogni insieme M ≠ ∅.',
      relatedTermIds: ['insieme_cantor', 'insieme_parti'],
    ),

    'insieme_parti': const UniversityTerm(
      id: 'insieme_parti',
      name: 'Insieme delle Parti (Insieme Potenza)',
      symbol: r'\mathcal{P}(M) \text{ o } 2^M',
      category: 'Teoria degli Insiemi',
      shortDefinition: 'L\'insieme che contiene come elementi tutti i possibili sottoinsiemi di M.',
      formalLatex: r'\mathcal{P}(M) = 2^M := \{N : N \subseteq M\}',
      pedagogicalExplanation:
          'Se un insieme finito M ha cardinalità |M| = m, allora il suo insieme delle parti ha esattamente 2ᵐ elementi. '
          'Per questo motivo si indica con 2ᴹ. Per qualsiasi insieme M, abbiamo sempre ∅ ∈ 2ᴹ e M ∈ 2ᴹ.',
      visualType: VisualDiagramType.subsetsLattice,
      exampleTitle: 'Calcolo di Insiemi delle Parti',
      exampleText:
          '• M = {1, 2} ⇒ 2ᴹ = {∅, {1}, {2}, {1, 2}} (2² = 4 elementi)\n'
          '• M = {1, 2, 3} ⇒ 2ᴹ ha 2³ = 8 elementi.\n'
          '• Se M ha 10 elementi, 2ᴹ ha 1024 elementi.',
      relatedTermIds: ['insieme_cantor', 'teorema_cantor_parti', 'cardinalita_equipotenza'],
    ),

    'paradosso_russell': const UniversityTerm(
      id: 'paradosso_russell',
      name: 'Paradosso di Russell (1903)',
      symbol: r'T = \{M \in S : M \notin M\}',
      category: 'Teoria degli Insiemi',
      shortDefinition: 'Antinomia logica che dimostra l\'insostenibilità della teoria ingenua degli insiemi non assiomatizzata.',
      formalLatex: r'T \in T \iff T \notin T',
      pedagogicalExplanation:
          'Se consideriamo la "collezione di tutti gli insiemi" S e definiamo il sottoinsieme T di quegli insiemi che non contengono '
          'se stessi come elementi, ci chiediamo: T appartiene a T? Se sì, allora per definizione T ∉ T (contraddizione). '
          'Se no, allora soddisfa la condizione e deve valere T ∈ T (contraddizione). '
          'Conclusione: la totalità di tutti gli insiemi non è un insieme, ma una classe.',
      visualType: VisualDiagramType.truthValueDiagram,
      exampleTitle: 'Paradosso del Barbiere',
      exampleText:
          '"Il barbiere del villaggio rade tutti e soli gli uomini che non si radono da soli. Chi rade il barbiere?" '
          'Se si rade da solo viola la regola; se non si rade, deve farsi radere da sé.',
      relatedTermIds: ['insieme_cantor', 'paradosso_berry'],
    ),

    'paradosso_berry': const UniversityTerm(
      id: 'paradosso_berry',
      name: 'Paradosso di Berry',
      symbol: r'T := \{n \in \mathbb{N} : \text{descrivibili con } < 16 \text{ parole}\}',
      category: 'Teoria degli Insiemi',
      shortDefinition: 'Paradosso semantico che evidenzia come il linguaggio comune non possa fondare rigorosamente la matematica.',
      formalLatex: r'k \notin T \land k \in T',
      pedagogicalExplanation:
          'Poiché esistono un numero finito di parole e combinazioni di al più 15 parole, l\'insieme T è finito. '
          'Esiste quindi il più piccolo numero naturale k non descrivibile con meno di 16 parole. '
          'Tuttavia, la frase: "Il più piccolo numero naturale che non si può descrivere con meno di sedici parole" '
          'ha 14 parole ed è una descrizione di k! Dunque k è descrivibile con meno di 16 parole: contraddizione.',
      visualType: VisualDiagramType.truthValueDiagram,
      exampleTitle: 'Significato Didattico',
      exampleText:
          'Questo paradosso dimostra l\'esigenza di definire gli oggetti matematici tramite formule logiche precise '
          'e simboliche anziché affidarsi alla semantica informale delle lingue naturali.',
      relatedTermIds: ['paradosso_russell', 'enunciato_matematico'],
    ),

    'prodotto_cartesiano': const UniversityTerm(
      id: 'prodotto_cartesiano',
      name: 'Prodotto Cartesiano',
      symbol: r'M \times N',
      category: 'Teoria degli Insiemi',
      shortDefinition: 'L\'insieme di tutte le coppie ordinate (m, n) con m ∈ M e n ∈ N.',
      formalLatex: r'M \times N := \{(m, n) : m \in M \land n \in N\}',
      pedagogicalExplanation:
          'Mentre negli insiemi l\'ordine non conta ({a, b} = {b, a}), nelle coppie ordinate l\'ordine è fondamentale: '
          '(m₁, m₂) = (n₁, n₂) se e solo se m₁ = n₁ e m₂ = n₂. '
          'Il piano cartesiano euclideo è il prodotto ℝ² = ℝ × ℝ.',
      visualType: VisualDiagramType.cartesianGrid,
      exampleTitle: 'Esempio Discreto',
      exampleText:
          'Sia M = {0, 1} e N = {a, b, c}:\n'
          'M × N = {(0, a), (0, b), (0, c), (1, a), (1, b), (1, c)}.\n'
          'La cardinalità è |M × N| = |M| · |N| = 2 · 3 = 6.',
      relatedTermIds: ['coppia_ordinata_kuratowski', 'nupla_spazio_rn', 'proprieta_universale_prodotto'],
    ),

    'coppia_ordinata_kuratowski': const UniversityTerm(
      id: 'coppia_ordinata_kuratowski',
      name: 'Coppia Ordinata (Definizione di Kuratowski 1921)',
      symbol: r'(m, n) := \{\{m\}, \{m, n\}\}',
      category: 'Teoria degli Insiemi',
      shortDefinition: 'Costruzione rigorosa della coppia ordinata usando esclusivamente il concetto primitivo di insieme.',
      formalLatex: r'(m, n) := \{\{m\}, \{m, n\}\}',
      pedagogicalExplanation:
          'Come codificare l\'ordine usando insiemi non ordinati? Kuratowski identifica il primo elemento come '
          'l\'unico elemento del singoletto {m}, mentre il secondo elemento compare nell\'insieme a due elementi {m, n}. '
          'Questo garantisce che (m, n) = (p, q) ⇔ m = p ∧ n = q.',
      visualType: VisualDiagramType.subsetsLattice,
      exampleTitle: 'Confronto con Hausdorff (1914)',
      exampleText:
          'Hausdorff propose: (m₁, m₂) := {{1, m₁}, {2, m₂}}, utilizzando due etichette distinte 1 e 2. '
          'La definizione di Kuratowski è universalmente preferita perché non presuppone numeri a priori.',
      relatedTermIds: ['prodotto_cartesiano', 'nupla_spazio_rn'],
    ),

    'nupla_spazio_rn': const UniversityTerm(
      id: 'nupla_spazio_rn',
      name: 'n-upla e Spazio Reale ℝⁿ',
      symbol: r'(a_1, \dots, a_n) \in \mathbb{R}^n',
      category: 'Teoria degli Insiemi',
      shortDefinition: 'Estensione induttiva della coppia ordinata a n elementi. ℝⁿ è il prodotto cartesiano di n copie di ℝ.',
      formalLatex: r'(a_1, \dots, a_n) := ((a_1, \dots, a_{n-1}), a_n)',
      pedagogicalExplanation:
          'Due n-uple sono uguali se e solo se coincidono ordinatamente in tutte le loro n componenti: '
          '(a₁, ..., aₙ) = (b₁, ..., bₙ) ⇔ aᵢ = bᵢ per ogni i = 1, ..., n. '
          'Questo costituisce la base formale per lo spazio vettoriale numerico ℝⁿ.',
      visualType: VisualDiagramType.cartesianGrid,
      exampleTitle: 'Dimensioni',
      exampleText:
          '• n = 1: ℝ (la retta reale)\n'
          '• n = 2: ℝ² = {(x, y) : x, y ∈ ℝ} (il piano cartesiano)\n'
          '• n = 3: ℝ³ = {(x, y, z) : x, y, z ∈ ℝ} (lo spazio tridimensionale ordinario)',
      relatedTermIds: ['prodotto_cartesiano', 'coppia_ordinata_kuratowski'],
    ),

    'operazioni_insiemi': const UniversityTerm(
      id: 'operazioni_insiemi',
      name: 'Operazioni con gli Insiemi',
      symbol: r'\cup, \cap, \setminus, \complement',
      category: 'Teoria degli Insiemi',
      shortDefinition: 'Unione (elementi in M₁ o M₂), Intersezione (in entrambi), Differenza (in M₁ ma non in M₂).',
      formalLatex: r'M_1 \cup M_2, \quad M_1 \cap M_2, \quad M_1 \setminus M_2',
      pedagogicalExplanation:
          'Le operazioni insiemistiche corrispondono alle operazioni logiche: l\'unione corrisponde alla disgiunzione (o), '
          'l\'intersezione alla congiunzione (e), la differenza alla congiunzione con la negazione. '
          'Due insiemi si dicono disgiunti se la loro intersezione è vuota: M₁ ∩ M₂ = ∅.',
      visualType: VisualDiagramType.subsetsLattice,
      exampleTitle: 'Esempio',
      exampleText:
          'Siano M = {1, 2, 3, 4} e N = {2, 4, 6, 8}:\n'
          '• M ∪ N = {1, 2, 3, 4, 6, 8}\n'
          '• M ∩ N = {2, 4}\n'
          '• M \\ N = {1, 3}',
      relatedTermIds: ['insieme_cantor', 'insieme_vuoto', 'congiunzione_disgiunzione'],
    ),

    'applicazione_funzione': const UniversityTerm(
      id: 'applicazione_funzione',
      name: 'Applicazione (Funzione)',
      symbol: r'f : A \to B',
      category: 'Applicazioni e Funzioni',
      shortDefinition: 'Terna f = (A, B, Γ_f) dove il grafico Γ_f ⊆ A × B associa ad ogni x ∈ A uno ed un solo y ∈ B.',
      formalLatex: r'\forall x \in A, \quad \exists! y \in B : (x, y) \in \Gamma_f',
      pedagogicalExplanation:
          'Nel formalismo moderno, un\'applicazione non è semplicemente una "formula algebrica", ma una terna ben definita: '
          'dominio A, codominio B, e grafico Γ_f. Due applicazioni sono uguali se e solo se hanno lo stesso dominio, '
          'lo stesso codominio e la stessa legge di corrispondenza.',
      visualType: VisualDiagramType.arrowMappingGeneral,
      exampleTitle: 'Formula uguale, funzioni diverse!',
      exampleText:
          'f: ℤ → ℤ, f(x) = x e g: ℕ → ℕ, g(x) = x NON sono formalmente uguali poiché hanno domini e codomini distinti. '
          'La formula x ↦ x - 1 è un\'applicazione da ℤ in ℤ, ma NON è un\'applicazione da ℕ in ℕ (non assegna immagine a 0).',
      relatedTermIds: ['dominio_codominio_immagine', 'fibra_controimmagine', 'composizione_applicazioni'],
    ),

    'dominio_codominio_immagine': const UniversityTerm(
      id: 'dominio_codominio_immagine',
      name: 'Dominio, Codominio ed Immagine',
      symbol: r'\text{dom}(f), \text{cod}(f), \text{Im}(f)',
      category: 'Applicazioni e Funzioni',
      shortDefinition: 'Dominio: insieme di partenza A. Codominio: insieme di arrivo B. Immagine: sottoinsieme dei valori effettivamente assunti.',
      formalLatex: r'\text{Im}(f) := \{f(x) : x \in A\} \subseteq B',
      pedagogicalExplanation:
          'L\'immagine Im(f) può essere un sottoinsieme proprio del codominio B. Se Im(f) = B, l\'applicazione si dice suriettiva. '
          'Per ogni sottoinsieme A\' ⊆ A, f(A\') = {f(x) | x ∈ A\'} è l\'immagine di A\' tramite f.',
      visualType: VisualDiagramType.arrowMappingGeneral,
      exampleTitle: 'Esempio di Discrepanza',
      exampleText:
          'Consideriamo f: ℝ → ℝ definita da f(x) = x².\n'
          '• Dominio: ℝ\n'
          '• Codominio: ℝ\n'
          '• Immagine: [0, +∞) ⊊ ℝ (nessun numero reale negativo è nell\'immagine).',
      relatedTermIds: ['applicazione_funzione', 'applicazione_suriettiva'],
    ),

    'fibra_controimmagine': const UniversityTerm(
      id: 'fibra_controimmagine',
      name: 'Controimmagine e Fibra',
      symbol: r"f^{-1}(B'), \quad f^{-1}(y)",
      category: 'Applicazioni e Funzioni',
      shortDefinition: 'Controimmagine: elementi del dominio che mappano in B\'. Fibra sopra y: controimmagine del singoletto {y}.',
      formalLatex: r'f^{-1}(y) := \{x \in A : f(x) = y\}',
      pedagogicalExplanation:
          'La fibra sopra y rappresenta l\'insieme di tutti i punti x nel dominio che "vanno a finire" in y. '
          'Le fibre permettono di caratterizzare le proprietà fondamentali con grande eleganza:\n'
          '• Iniettiva ⇔ ogni fibra contiene al massimo 1 elemento.\n'
          '• Suriettiva ⇔ ogni fibra contiene almeno 1 elemento.\n'
          '• Biiettiva ⇔ ogni fibra contiene esattamente 1 elemento.',
      visualType: VisualDiagramType.arrowMappingInjective,
      exampleTitle: 'Fibra di una Parabola',
      exampleText:
          'Per f: ℝ → ℝ con f(x) = x²:\n'
          '• Fibra f⁻¹(4) = {-2, 2} (contiene 2 elementi: f non è iniettiva)\n'
          '• Fibra f⁻¹(0) = {0} (1 elemento)\n'
          '• Fibra f⁻¹(-1) = ∅ (0 elementi: f non è suriettiva)',
      relatedTermIds: ['applicazione_funzione', 'applicazione_iniettiva', 'applicazione_suriettiva'],
    ),

    'composizione_applicazioni': const UniversityTerm(
      id: 'composizione_applicazioni',
      name: 'Composizione di Applicazioni',
      symbol: r'(g \circ f)(x) = g(f(x))',
      category: 'Applicazioni e Funzioni',
      shortDefinition: 'Incatenamento di due applicazioni: applicare la seconda al risultato della prima. Richiede codominio(f) = dominio(g).',
      formalLatex: r'g \circ f : A \to D, \quad x \mapsto g(f(x))',
      pedagogicalExplanation:
          'La composizione è associativa: h ∘ (g ∘ f) = (h ∘ g) ∘ f. '
          'Possiede un elemento neutro dato dall\'applicazione identità: f ∘ id_A = f e id_B ∘ f = f. '
          'Tuttavia, in generale la composizione NON è commutativa: g ∘ f ≠ f ∘ g anche quando entrambe sono definite.',
      visualType: VisualDiagramType.commutativeDiagram,
      exampleTitle: 'Non Commutatività',
      exampleText:
          'Siano f(x) = x² e g(x) = 2x su ℝ:\n'
          '• (f ∘ g)(x) = f(2x) = (2x)² = 4x²\n'
          '• (g ∘ f)(x) = g(x²) = 2(x²) = 2x²\n'
          'Per x = 1: (f ∘ g)(1) = 4 ≠ 2 = (g ∘ f)(1).',
      relatedTermIds: ['applicazione_funzione', 'retrazione_sezione', 'applicazione_biiettiva'],
    ),

    'applicazione_iniettiva': const UniversityTerm(
      id: 'applicazione_iniettiva',
      name: 'Applicazione Iniettiva (Iniezione)',
      symbol: r'f(x) = f(y) \implies x = y',
      category: 'Applicazioni e Funzioni',
      shortDefinition: 'Mappa elementi distinti del dominio in elementi distinti del codominio.',
      formalLatex: r'\forall x, y \in A, \quad x \neq y \implies f(x) \neq f(y) \iff (f(x) = f(y) \implies x = y)',
      pedagogicalExplanation:
          'In pratica, per dimostrare l\'iniettività si usa quasi sempre la contrapposta: si suppone f(x) = f(y) '
          'e si deduce algebricamente che x = y. In termini di controimmagini, per ogni elemento b ∈ B la sua fibra contiene AL MASSIMO un elemento.',
      visualType: VisualDiagramType.arrowMappingInjective,
      exampleTitle: 'Dimostrazione di Iniettività',
      exampleText:
          'Sia f: ℝ → ℝ², f(x) = (x + 1, x² + 1).\n'
          'Se f(x) = f(y) ⇒ (x + 1, x² + 1) = (y + 1, y² + 1) ⇒ x + 1 = y + 1 ⇒ x = y. f è iniettiva.',
      relatedTermIds: ['applicazione_suriettiva', 'applicazione_biiettiva', 'retrazione_sezione'],
    ),

    'applicazione_suriettiva': const UniversityTerm(
      id: 'applicazione_suriettiva',
      name: 'Applicazione Suriettiva (Suriezione)',
      symbol: r'\text{Im}(f) = B',
      category: 'Applicazioni e Funzioni',
      shortDefinition: 'Ogni elemento del codominio è immagine di almeno un elemento del dominio.',
      formalLatex: r'\forall b \in B, \quad \exists a \in A : f(a) = b',
      pedagogicalExplanation:
          'Nessun elemento del codominio rimane escluso. In termini di controimmagini, per ogni b ∈ B la sua fibra '
          'contiene ALMENO un elemento (|f⁻¹(b)| ≥ 1). Per dimostrare che f non è suriettiva, basta esibire un singolo elemento b ∈ B privo di controimmagine.',
      visualType: VisualDiagramType.arrowMappingSurjective,
      exampleTitle: 'Controesempio di Suriettività',
      exampleText:
          'Per f: ℝ → ℝ², f(x) = (x + 1, x² + 1):\n'
          'Prendiamo b = (1, 0) ∈ ℝ². Se esistesse x con f(x) = (1, 0) avremmo x + 1 = 1 (quindi x = 0) e x² + 1 = 0 (quindi 1 = 0, impossibile!). '
          'Dunque (1, 0) ∉ Im(f), quindi f non è suriettiva.',
      relatedTermIds: ['applicazione_iniettiva', 'applicazione_biiettiva', 'retrazione_sezione'],
    ),

    'applicazione_biiettiva': const UniversityTerm(
      id: 'applicazione_biiettiva',
      name: 'Applicazione Biiettiva (Biiezione / Invertibile)',
      symbol: r'f : A \longleftrightarrow B',
      category: 'Applicazioni e Funzioni',
      shortDefinition: 'Applicazione contemporaneamente iniettiva e suriettiva: stabilisce una corrispondenza biunivoca perfetta.',
      formalLatex: r'\forall b \in B, \quad \exists! a \in A : f(a) = b',
      pedagogicalExplanation:
          'Per le applicazioni tra insiemi, essere biiettiva equivale ad essere invertibile (Teorema 1.31): '
          'esiste un\'unica applicazione inversa f⁻¹: B → A tale che f ∘ f⁻¹ = id_B e f⁻¹ ∘ f = id_A. '
          'La composizione di due biiezioni è a sua volta biiettiva con (g ∘ f)⁻¹ = f⁻¹ ∘ g⁻¹.',
      visualType: VisualDiagramType.arrowMappingBijective,
      exampleTitle: 'Esempio di Biiezione',
      exampleText:
          'f: ℝ → ℝ, f(x) = 3x è biiettiva. La sua inversa è f⁻¹(x) = (1/3)x.\n'
          '(f ∘ f⁻¹)(x) = 3(x/3) = x = id(x).\n'
          'Invece g: ℤ → ℤ, g(x) = 3x non è suriettiva su ℤ (es. 1 non ha controimmagine intera), quindi non è biiettiva né invertibile.',
      relatedTermIds: ['applicazione_iniettiva', 'applicazione_suriettiva', 'retrazione_sezione'],
    ),

    'retrazione_sezione': const UniversityTerm(
      id: 'retrazione_sezione',
      name: 'Retrazione (Inversa Sinistra) e Sezione (Inversa Destra)',
      symbol: r'\bar{f} \circ f = \text{id}_A, \quad f \circ \tilde{f} = \text{id}_B',
      category: 'Applicazioni e Funzioni',
      shortDefinition: 'Retrazione: inversa da sinistra (caratterizza l\'iniettività). Sezione: inversa da destra (caratterizza la suriettività).',
      formalLatex: r'f \text{ iniettiva} \iff \exists \text{ retrazione}; \quad f \text{ suriettiva} \iff \exists \text{ sezione}',
      pedagogicalExplanation:
          'Teorema 1.31 (PoliMi): Una mappa f ammette un\'inversa sinistra se e solo se è iniettiva; '
          'ammette un\'inversa destra se e solo se è suriettiva. Se possiede sia inversa destra che sinistra, '
          'allora per associatività le due inverse coincidono necessariamente e f è biiettiva.',
      visualType: VisualDiagramType.arrowMappingBijective,
      exampleTitle: 'Unicità per Associatività',
      exampleText:
          'Sia f retrazione e f̃ sezione: f̄ = f̄ ∘ id_B = f̄ ∘ (f ∘ f̃) = (f̄ ∘ f) ∘ f̃ = id_A ∘ f̃ = f̃. '
          'Dunque se esistono entrambe, coincidono con l\'inversa unica f⁻¹.',
      relatedTermIds: ['applicazione_iniettiva', 'applicazione_suriettiva', 'applicazione_biiettiva'],
    ),

    'monomorfismo_epimorfismo': const UniversityTerm(
      id: 'monomorfismo_epimorfismo',
      name: 'Monomorfismi ed Epimorfismi',
      symbol: r"f \circ g = f \circ g' \implies g = g'",
      category: 'Applicazioni e Funzioni',
      shortDefinition: 'Descrizione algebrica/categoriale: monomorfismo cancella a sinistra (iniettività), epimorfismo cancella a destra (suriettività).',
      formalLatex: r"\text{Monomorfismo: } f \circ g = f \circ g' \implies g = g'",
      pedagogicalExplanation:
          'Nei contesti astratti delle categorie dove non si possono "guardare gli elementi interni", '
          'l\'iniettività viene definita dalla proprietà di poter semplificare f a sinistra (Teorema 1.35), '
          'e la suriettività dalla cancellabilità a destra (Teorema 1.36).',
      visualType: VisualDiagramType.commutativeDiagram,
      exampleTitle: 'Dualità Categoriale',
      exampleText:
          'Insieme delle frecce: per ogni coppia di morfismi paralleli g, g\', '
          'se f ∘ g = f ∘ g\' allora g = g\'. Nella categoria degli insiemi coincide esattamente con l\'iniettività.',
      relatedTermIds: ['applicazione_iniettiva', 'applicazione_suriettiva'],
    ),

    'cardinalita_equipotenza': const UniversityTerm(
      id: 'cardinalita_equipotenza',
      name: 'Cardinalità ed Equipotenza',
      symbol: r'|A| = |B| \iff A \approx B',
      category: 'Teoria degli Insiemi',
      shortDefinition: 'Due insiemi sono equipotenti se e solo se esiste una biiezione tra di essi.',
      formalLatex: r'A \approx B \iff \exists f : A \to B \text{ biiettiva}',
      pedagogicalExplanation:
          'Confrontare il numero di elementi tramite funzioni è il fulcro della teoria moderna:\n'
          '• Esiste f: A → B iniettiva ⇒ |A| ≤ |B|\n'
          '• Esiste f: A → B suriettiva ⇒ |A| ≥ |B|\n'
          '• Esiste f: A → B biiettiva ⇒ |A| = |B| (stessa potenza).',
      visualType: VisualDiagramType.arrowMappingBijective,
      exampleTitle: 'Insiemi Infiniti',
      exampleText:
          'I numeri pari 2ℤ hanno la stessa cardinalità di ℤ: l\'applicazione f(n) = 2n è una biiezione perfetta tra ℤ e 2ℤ!',
      relatedTermIds: ['infinita_dedekind', 'teorema_cantor_parti'],
    ),

    'infinita_dedekind': const UniversityTerm(
      id: 'infinita_dedekind',
      name: 'Infinità secondo Dedekind',
      symbol: r"\exists M' \subsetneq M \text{ t.c. } M' \approx M",
      category: 'Teoria degli Insiemi',
      shortDefinition: 'Un insieme è infinito se e solo se è equipotente a un suo sottoinsieme proprio.',
      formalLatex: r"M \text{ infinito} \iff \exists M' \subsetneq M, \quad M \approx M'",
      pedagogicalExplanation:
          'Un insieme finito non può MAI essere in biiezione con una sua parte propria (principio dei cassetti). '
          'Gli insiemi infiniti invece lo permettono: l\'applicazione f: ℕ → ℕ data da f(n) = n + 1 mostra che ℕ '
          'è equipotente a ℕ_{>0} = ℕ \\ {0}.',
      visualType: VisualDiagramType.arrowMappingInjective,
      exampleTitle: 'Hotel Infinito di Hilbert',
      exampleText:
          'Un albergo con infinite stanze tutte occupate può sempre accogliere un nuovo ospite: basta spostare '
          'l\'ospite della stanza n nella stanza n + 1, liberando la stanza 1!',
      relatedTermIds: ['cardinalita_equipotenza', 'teorema_cantor_parti'],
    ),

    'teorema_cantor_parti': const UniversityTerm(
      id: 'teorema_cantor_parti',
      name: 'Teorema di Cantor sull\'Insieme delle Parti',
      symbol: r'|M| < |2^M|',
      category: 'Teoria degli Insiemi',
      shortDefinition: 'Per qualunque insieme M, non esiste alcuna biiezione tra M e il suo insieme delle parti 2ᴹ.',
      formalLatex: r'\nexists f : M \to \mathcal{P}(M) \text{ biiettiva}',
      pedagogicalExplanation:
          'Dimostrazione per assurdo (Argomento Diagonale): Supponiamo esista una biiezione f: M → 2ᴹ. '
          'Consideriamo l\'insieme B = {m ∈ M : m ∉ f(m)} ∈ 2ᴹ. Essendo f suriettiva, deve esistere un b ∈ M con f(b) = B. '
          'Ma allora: b ∈ B ⇔ b ∉ f(b) ⇔ b ∉ B (contraddizione logica!). Dunque nessuna biiezione può esistere.',
      visualType: VisualDiagramType.subsetsLattice,
      exampleTitle: 'Gerarchia degli Infiniti',
      exampleText:
          'Il teorema dimostra che esistono infiniti strettamente più grandi di altri: |ℕ| < |2^ℕ| = |ℝ| < |2^ℝ| < ... '
          'L\'infinito non è un numero unico, ma una scala infinita di grandezze.',
      relatedTermIds: ['insieme_parti', 'cardinalita_equipotenza', 'infinita_dedekind'],
    ),

    'assioma_scelta': const UniversityTerm(
      id: 'assioma_scelta',
      name: 'Assioma della Scelta (ZFC)',
      symbol: r'\prod_{X \in \mathcal{P}} X \neq \emptyset',
      category: 'Teoria degli Insiemi',
      shortDefinition: 'Per ogni famiglia di insiemi non vuoti, esiste una funzione di scelta che seleziona un elemento da ciascun insieme.',
      formalLatex: r'\forall \mathcal{P} \text{ con } X \neq \emptyset, \quad \exists f : \mathcal{P} \to \bigcup \mathcal{P} \text{ t.c. } f(X) \in X',
      pedagogicalExplanation:
          'Fondamentale per l\'algebra lineare universitaria: senza l\'Assioma della Scelta non si può dimostrare '
          'che OGNI spazio vettoriale (anche a dimensione infinita) ammette una base. '
          'È equivalente al Lemma di Zorn, al Teorema del buon ordinamento e all\'esistenza di una sezione per ogni funzione suriettiva.',
      visualType: VisualDiagramType.commutativeDiagram,
      exampleTitle: 'Forme Equivalenti Famose',
      exampleText:
          '1. Esistenza di una base: Ogni spazio vettoriale ammette una base.\n'
          '2. Lemma di Zorn: Ogni insieme ordinato induttivo ammette un elemento massimale.\n'
          '3. Inversa destra: Ogni funzione suriettiva ammette una sezione.',
      relatedTermIds: ['cardinalita_equipotenza', 'retrazione_sezione'],
    ),

    'proprieta_universale_prodotto': const UniversityTerm(
      id: 'proprieta_universale_prodotto',
      name: 'Proprietà Universale del Prodotto Cartesiano',
      symbol: r'p_i \circ u = u_i',
      category: 'Teoria degli Insiemi',
      shortDefinition: 'Caratterizzazione categoriale del prodotto cartesiano tramite l\'esistenza e unicità di una mappa compatibile.',
      formalLatex: r'\forall (u_i : N \to M_i), \quad \exists! u : N \to \prod M_i \text{ t.c. } p_i \circ u = u_i',
      pedagogicalExplanation:
          'Invece di costruire il prodotto cartesiano manipolando coppie di elementi, la proprietà universale lo definisce '
          'come l\'unico oggetto P dotato di proiezioni pᵢ tale che mappare dentro P equivale a mappare contemporaneamente '
          'in tutti i suoi fattori Mᵢ. Questa prospettiva unifica tutta l\'algebra superiore.',
      visualType: VisualDiagramType.commutativeDiagram,
      exampleTitle: 'Diagramma Triangolare',
      exampleText:
          'Dato N con due mappe u₁: N → M₁ e u₂: N → M₂, esiste un\'unica mappa u(n) = (u₁(n), u₂(n)) '
          'che rende commutativi i due triangoli con le proiezioni canoniche p₁ e p₂.',
      relatedTermIds: ['prodotto_cartesiano', 'monomorfismo_epimorfismo'],
    ),

    'relazione_binaria': const UniversityTerm(
      id: 'relazione_binaria',
      name: 'Relazione Binaria',
      symbol: r'R \subseteq M \times M',
      category: 'Relazioni e Quozienti',
      shortDefinition: 'Un sottoinsieme del prodotto cartesiano M × M. Si scrive x R y se (x, y) ∈ R.',
      formalLatex: r'(x, y) \in R \iff x \sim_R y',
      pedagogicalExplanation:
          'Le 4 proprietà fondamentali di una relazione sono:\n'
          '1. Riflessiva: x ~ x per ogni x\n'
          '2. Simmetrica: x ~ y ⇒ y ~ x\n'
          '3. Antisimmetrica: x ~ y ∧ y ~ x ⇒ x = y\n'
          '4. Transitiva: x ~ y ∧ y ~ z ⇒ x ~ z.\n'
          'Se soddisfa 1, 2, 4 è di Equivalenza; se soddisfa 1, 3, 4 è d\'Ordine.',
      visualType: VisualDiagramType.partitionBubbles,
      exampleTitle: 'Esempi',
      exampleText:
          '• L\'uguaglianza (=) soddisfa tutte e quattro.\n'
          '• "≤" sui numeri è una relazione d\'ordine (riflessiva, antisimmetrica, transitiva).\n'
          '• "Avere la stessa età" è una relazione di equivalenza.',
      relatedTermIds: ['relazione_equivalenza', 'classe_equivalenza'],
    ),

    'relazione_equivalenza': const UniversityTerm(
      id: 'relazione_equivalenza',
      name: 'Relazione di Equivalenza',
      symbol: r'x \sim y',
      category: 'Relazioni e Quozienti',
      shortDefinition: 'Relazione binaria riflessiva, simmetrica e transitiva. Serve a "identificare" oggetti con proprietà comuni.',
      formalLatex: r'x \sim x; \quad x \sim y \implies y \sim x; \quad (x \sim y \land y \sim z) \implies x \sim z',
      pedagogicalExplanation:
          'Una relazione di equivalenza generalizza il concetto di uguaglianza. '
          'Permette di raggruppare gli elementi in classi di equivalenza e di costruire un nuovo insieme: l\'insieme quoziente.',
      visualType: VisualDiagramType.partitionBubbles,
      exampleTitle: 'Congruenza Modulo 3',
      exampleText:
          'Su ℤ: a ≡ b mod 3 ⇔ 3 divide (a - b).\n'
          '• Riflessiva: 3 | (a - a) = 0.\n'
          '• Simmetrica: se 3 | (a - b) allora 3 | (b - a).\n'
          '• Transitiva: se 3 | (a - b) e 3 | (b - c), allora 3 | [(a - b) + (b - c)] = (a - c).',
      relatedTermIds: ['relazione_binaria', 'classe_equivalenza', 'insieme_quoziente', 'congruenza_modulo_n'],
    ),

    'classe_equivalenza': const UniversityTerm(
      id: 'classe_equivalenza',
      name: 'Classe di Equivalenza e Rappresentanti',
      symbol: r'[x]_\sim = \{m \in M : m \sim x\}',
      category: 'Relazioni e Quozienti',
      shortDefinition: 'Il sottoinsieme di tutti gli elementi di M che sono in relazione con x. x è detto rappresentante della classe.',
      formalLatex: r'[x]_\sim := \{m \in M : m \sim x\}',
      pedagogicalExplanation:
          'Proprietà fondamentale: due classi di equivalenza o sono completamente disgiunte o coincidono perfettamente ([x] = [y] ⇔ x ~ y). '
          'Un elemento qualsiasi di una classe può essere scelto come suo rappresentante. '
          'Un "sistema di rappresentanti" contiene esattamente un elemento per ogni classe.',
      visualType: VisualDiagramType.partitionBubbles,
      exampleTitle: 'Classi Modulo 3 in ℤ',
      exampleText:
          '[0] = {..., -6, -3, 0, 3, 6, 9, ...}\n'
          '[1] = {..., -5, -2, 1, 4, 7, 10, ...}\n'
          '[2] = {..., -4, -1, 2, 5, 8, 11, ...}\n'
          'Un sistema canonico di rappresentanti è {0, 1, 2}.',
      relatedTermIds: ['relazione_equivalenza', 'partizione_insieme', 'insieme_quoziente'],
    ),

    'partizione_insieme': const UniversityTerm(
      id: 'partizione_insieme',
      name: 'Partizione di un Insieme',
      symbol: r'\mathcal{P} \subseteq 2^M',
      category: 'Relazioni e Quozienti',
      shortDefinition: 'Famiglia di sottoinsiemi non vuoti, a due a due disgiunti, la cui unione totale restituisce l\'intero insieme M.',
      formalLatex: r'A \cap B = \emptyset \quad\forall A \neq B \in \mathcal{P}, \quad \bigcup_{A \in \mathcal{P}} A = M',
      pedagogicalExplanation:
          'Teorema 1.65: C\'è una corrispondenza biunivoca perfetta tra le relazioni di equivalenza su M '
          'e le partizioni di M! Ogni relazione di equivalenza partiziona M nelle sue classi di equivalenza, '
          'e viceversa ogni partizione definisce una relazione di equivalenza ponendo x ~ y se e solo se appartengono allo stesso blocco.',
      visualType: VisualDiagramType.partitionBubbles,
      exampleTitle: 'Esempio Visivo',
      exampleText:
          'Dividere un mazzo di 52 carte per seme genera una partizione in 4 blocchi disgiunti da 13 carte: '
          'Picche, Fiori, Quadri, Cuori.',
      relatedTermIds: ['classe_equivalenza', 'relazione_equivalenza', 'insieme_quoziente'],
    ),

    'insieme_quoziente': const UniversityTerm(
      id: 'insieme_quoziente',
      name: 'Insieme Quoziente',
      symbol: r'M/\sim := \{[x] : x \in M\}',
      category: 'Relazioni e Quozienti',
      shortDefinition: 'L\'insieme che ha come elementi le singole classi di equivalenza di M modulo ~.',
      formalLatex: r'M/\sim := \{C \subseteq M : C \text{ è una classe di equivalenza per } \sim\}',
      pedagogicalExplanation:
          'L\'insieme quoziente è uno dei concetti più potenti della matematica moderna: '
          'permette di "collassare" differenze non volute, considerando uguali oggetti che differiscono solo per dettagli trascurabili. '
          'La proiezione canonica p: M → M/~ associa ad ogni elemento la sua classe: p(x) = [x].',
      visualType: VisualDiagramType.partitionBubbles,
      exampleTitle: 'Costruzione dei Numeri Razionali ℚ',
      exampleText:
          'ℚ è l\'insieme quoziente di ℤ × (ℤ \\ {0}) rispetto alla relazione (a, b) ~ (c, d) ⇔ a·d = b·c. '
          'La frazione 1/2 è la classe di equivalenza che contiene (1, 2), (2, 4), (3, 6), (-1, -2)...',
      relatedTermIds: ['relazione_equivalenza', 'classe_equivalenza', 'partizione_insieme', 'anello_quoziente_zn'],
    ),

    'buon_ordinamento': const UniversityTerm(
      id: 'buon_ordinamento',
      name: 'Buon Ordinamento di ℕ',
      symbol: r'\forall S \subseteq \mathbb{N}, S \neq \emptyset \implies \exists \min S',
      category: 'Aritmetica e Divisibilità',
      shortDefinition: 'Ogni sottoinsieme non vuoto di numeri naturali contiene un elemento minimo.',
      formalLatex: r'\forall S \subseteq \mathbb{N}, \quad S \neq \emptyset \implies \exists m \in S : m \le s \quad \forall s \in S',
      pedagogicalExplanation:
          'Proprietà fondamentale dei numeri naturali: garantisce che i processi di divisione o induzione non scendano '
          'all\'infinito. È lo strumento con cui si dimostra rigorosamente il Teorema della divisione con resto e l\'esistenza del MCD.',
      visualType: VisualDiagramType.wellOrderingRay,
      exampleTitle: 'Esempio',
      exampleText:
          'L\'insieme dei numeri primi dispari S = {3, 5, 7, 11, ...} ha minimo 3.\n'
          'In ℤ o ℝ questa proprietà NON vale: l\'intervallo aperto (0, 1) in ℝ non ha minimo.',
      relatedTermIds: ['divisibilita_interi', 'divisione_resto'],
    ),

    'divisibilita_interi': const UniversityTerm(
      id: 'divisibilita_interi',
      name: 'Divisibilità negli Interi',
      symbol: r'a \mid b \iff \exists c \in \mathbb{Z} : b = ac',
      category: 'Aritmetica e Divisibilità',
      shortDefinition: 'Diciamo che a divide b (o b è divisibile per a) se esiste un intero c tale che b = ac.',
      formalLatex: r'a \mid b \iff \exists c \in \mathbb{Z} : b = ac',
      pedagogicalExplanation:
          'Su ℕ la divisibilità è una relazione d\'ordine parziale (riflessiva, antisimmetrica, transitiva). '
          'Il suo elemento minimo è 1 (1 divide tutto) e il suo elemento massimo è 0 (tutto divide 0, poiché 0 = a · 0). '
          'Su ℤ invece non è antisimmetrica poiché 7 | -7 e -7 | 7 ma 7 ≠ -7.',
      visualType: VisualDiagramType.divisionTimeline,
      exampleTitle: 'Ordine Parziale vs Totale',
      exampleText:
          'La divisibilità su ℕ non è un ordine totale: 2 non divide 3 e 3 non divide 2 (elementi incomparabili). '
          'Tuttavia, ammette sempre estremo inferiore (MCD) ed estremo superiore (mcm).',
      relatedTermIds: ['buon_ordinamento', 'divisione_resto', 'massimo_comune_divisore_mcm'],
    ),

    'divisione_resto': const UniversityTerm(
      id: 'divisione_resto',
      name: 'Teorema della Divisione con Resto',
      symbol: r'a = qb + r, \quad 0 \le r < b',
      category: 'Aritmetica e Divisibilità',
      shortDefinition: 'Dati a, b interi con b > 0, esistono unici interi quoziente q e resto r tali che a = qb + r con 0 ≤ r < b.',
      formalLatex: r'\forall a, b \in \mathbb{Z} (b > 0), \quad \exists! q, r \in \mathbb{Z} : a = qb + r \land 0 \le r < b',
      pedagogicalExplanation:
          'La dimostrazione usa il buon ordinamento sull\'insieme S = {a - sb : s ∈ ℤ, a - sb ≥ 0} ⊆ ℕ. '
          'Il resto r è definito proprio come il minimo di S, garantendo al contempo l\'esistenza e la condizione r < b. '
          'L\'unicità si dimostra mostrando che una seconda coppia produrrebbe una contraddizione con b.',
      visualType: VisualDiagramType.divisionTimeline,
      exampleTitle: 'Esempio Numerico',
      exampleText:
          'Per a = 161 e b = 28: 161 = 5 · 28 + 21, con q = 5 e r = 21 (0 ≤ 21 < 28).\n'
          'Per a = -17 e b = 5: -17 = (-4) · 5 + 3, con q = -4 e r = 3 (0 ≤ 3 < 5).',
      relatedTermIds: ['buon_ordinamento', 'divisibilita_interi', 'algoritmo_euclideo'],
    ),

    'massimo_comune_divisore_mcm': const UniversityTerm(
      id: 'massimo_comune_divisore_mcm',
      name: 'Massimo Comune Divisore (MCD) e mcm',
      symbol: r'\gcd(a, b), \quad \text{mcm}(a, b)',
      category: 'Aritmetica e Divisibilità',
      shortDefinition: 'MCD d: d divide a e b, e qualunque altro divisore comune divide d. mcm m: multiplo comune diviso da qualunque altro multiplo.',
      formalLatex: r'd = \gcd(a, b), \quad m = \text{mcm}(a, b) \implies |ab| = d \cdot m',
      pedagogicalExplanation:
          'Nel reticolo della divisibilità, il MCD rappresenta l\'infimum (il più grande nel senso della divisibilità) '
          'e il mcm rappresenta il supremum. Vale sempre la fondamentale relazione di reciprocità: |ab| = MCD(a, b) · mcm(a, b).',
      visualType: VisualDiagramType.euclideanLadder,
      exampleTitle: 'Casi Notevoli',
      exampleText:
          '• MCD(0, a) = |a| (poiché ogni numero divide 0)\n'
          '• mcm(0, a) = 0\n'
          '• Se a | b, allora MCD(a, b) = |a| e mcm(a, b) = |b|.',
      relatedTermIds: ['lemma_bezout', 'algoritmo_euclideo', 'lemma_euclide'],
    ),

    'lemma_bezout': const UniversityTerm(
      id: 'lemma_bezout',
      name: 'Identità e Lemma di Bézout',
      symbol: r'd = as + bt',
      category: 'Aritmetica e Divisibilità',
      shortDefinition: 'Il MCD di due interi a e b può sempre essere espresso come combinazione lineare intera di a e b.',
      formalLatex: r'd = \gcd(a, b) \iff \exists s, t \in \mathbb{Z} : as + bt = d',
      pedagogicalExplanation:
          'In particolare, due interi a e b sono coprimi (MCD = 1) se e solo se esistono coefficienti interi s, t '
          'tali che as + bt = 1. Questo lemma è la chiave per trovare gli inversi moltiplicativi nell\'aritmetica modulare ℤ/nℤ.',
      visualType: VisualDiagramType.euclideanLadder,
      exampleTitle: 'Applicazione',
      exampleText:
          'Per a = 161 e b = 28: MCD(161, 28) = 7.\n'
          'Risalendo le divisioni dell\'algoritmo euclideo:\n'
          '7 = 28 - 1 · 21 = 28 - (161 - 5 · 28) = 6 · 28 - 1 · 161. Quindi s = -1, t = 6.',
      relatedTermIds: ['massimo_comune_divisore_mcm', 'algoritmo_euclideo', 'anello_quoziente_zn'],
    ),

    'algoritmo_euclideo': const UniversityTerm(
      id: 'algoritmo_euclideo',
      name: 'Algoritmo Euclideo delle Divisioni Successive',
      symbol: r'r_{i-1} = q r_i + r_{i+1}',
      category: 'Aritmetica e Divisibilità',
      shortDefinition: 'Algoritmo per calcolare il MCD eseguendo divisioni con resto successive fino ad ottenere resto nullo.',
      formalLatex: r'\gcd(a, b) = \gcd(b, r_1) = \gcd(r_1, r_2) = \dots = r_k \quad (\text{ultimo resto } \neq 0)',
      pedagogicalExplanation:
          'L\'algoritmo si basa sul Lemma 1.84: i divisori comuni di a e b coincidono esattamente con i divisori comuni di b e r. '
          'Poiché la successione dei resti è strettamente decrescente (b > r₁ > r₂ > ... ≥ 0), l\'algoritmo termina '
          'necessariamente in un numero finito di passi. L\'ultimo resto non nullo è il MCD cercato.',
      visualType: VisualDiagramType.euclideanLadder,
      exampleTitle: 'Passaggi con 161 e 28',
      exampleText:
          'Passo 1: 161 = 5 · 28 + 21\n'
          'Passo 2:  28 = 1 · 21 + 7  (ultimo resto non nullo)\n'
          'Passo 3:  21 = 3 · 7  + 0  ⇒ MCD(161, 28) = 7.',
      relatedTermIds: ['divisione_resto', 'massimo_comune_divisore_mcm', 'lemma_bezout'],
    ),

    'lemma_euclide': const UniversityTerm(
      id: 'lemma_euclide',
      name: 'Lemma di Euclide',
      symbol: r'd \mid ab \land \gcd(a, d) = 1 \implies d \mid b',
      category: 'Aritmetica e Divisibilità',
      shortDefinition: 'Se un numero d divide un prodotto ab ed è coprimo con a, allora deve necessariamente dividere b.',
      formalLatex: r'(d \mid ab \land \gcd(a, d) = 1) \implies d \mid b',
      pedagogicalExplanation:
          'Dimostrazione immediata tramite Bézout: poiché MCD(a, d) = 1, esistono k, l tali che ka + ld = 1. '
          'Moltiplicando per b: kab + lbd = b. Poiché d divide kab (poiché d | ab) e divide lbd, d divide la loro somma, quindi d | b! Q.E.D.',
      visualType: VisualDiagramType.divisionTimeline,
      exampleTitle: 'Caratterizzazione dei Numeri Primi',
      exampleText:
          'Un numero naturale p > 1 è primo se e solo se soddisfa: se p | ab allora p | a oppure p | b.',
      relatedTermIds: ['lemma_bezout', 'massimo_comune_divisore_mcm'],
    ),

    'congruenza_modulo_n': const UniversityTerm(
      id: 'congruenza_modulo_n',
      name: 'Congruenza Modulo n',
      symbol: r'a \equiv b \pmod n',
      category: 'Aritmetica Modulare',
      shortDefinition: 'Due interi a e b sono congrui modulo n se la loro differenza (a - b) è divisibile per n.',
      formalLatex: r'a \equiv b \pmod n \iff n \mid (a - b)',
      pedagogicalExplanation:
          'La congruenza modulo n è una relazione di equivalenza su ℤ. '
          'Due numeri sono congrui modulo n se e solo se hanno lo stesso resto nella divisione per n. '
          'L\'insieme quoziente si indica con ℤ/nℤ e contiene esattamente n classi: {[0], [1], ..., [n - 1]}.',
      visualType: VisualDiagramType.moduloClock,
      exampleTitle: 'Aritmetica dell\'Orologio',
      exampleText:
          'Le ore su un orologio analogico funzionano modulo 12: le 15:00 corrispondono alle 3:00 perché 15 ≡ 3 mod 12 (15 - 3 = 12, divisibile per 12).',
      relatedTermIds: ['anello_quoziente_zn', 'relazione_equivalenza', 'classe_equivalenza'],
    ),

    'anello_quoziente_zn': const UniversityTerm(
      id: 'anello_quoziente_zn',
      name: 'Anello Quoziente ℤ/nℤ e Invertibilità',
      symbol: r"\mathbb{Z}/n\mathbb{Z}, \quad [a]_n \cdot [a']_n = [1]_n",
      category: 'Aritmetica Modulare',
      shortDefinition: 'Le operazioni di addizione e moltiplicazione sono ben definite su ℤ/nℤ. Una classe è invertibile ⇔ gcd(a, n) = 1.',
      formalLatex: r'[a]_n \in U(\mathbb{Z}/n\mathbb{Z}) \iff \gcd(a, n) = 1',
      pedagogicalExplanation:
          'Teorema 1.92: Una classe [a] ammette inverso moltiplicativo in ℤ/nℤ se e solo se a ed n sono coprimi. '
          'Dimostrazione: se gcd(a, n) = 1, per Bézout esistono s, t tali che as + nt = 1. '
          'Passando alle classi modulo n: [as + nt] = [a][s] + [n][t] = [a][s] + [0] = [1]. Quindi [s] è l\'inverso di [a]!',
      visualType: VisualDiagramType.moduloClock,
      exampleTitle: 'Campi Finiti 𝔽_p',
      exampleText:
          'Se n = p è un numero primo, ogni elemento non nullo {1, 2, ..., p - 1} è coprimo con p. '
          'Di conseguenza tutti gli elementi non nulli sono invertibili, e ℤ/pℤ è un CAMPO (indicato con 𝔽_p).',
      relatedTermIds: ['congruenza_modulo_n', 'lemma_bezout', 'campo_finito_fp'],
    ),

    'operazione_interna': const UniversityTerm(
      id: 'operazione_interna',
      name: 'Operazione Interna (Algebrica)',
      symbol: r'* : M \times M \to M',
      category: 'Strutture Algebriche',
      shortDefinition: 'Applicazione che associa ad ogni coppia ordinata (a, b) di elementi di M un elemento ben definito a * b ∈ M.',
      formalLatex: r'* : M \times M \to M, \quad (a, b) \mapsto a * b',
      pedagogicalExplanation:
          'Le 3 proprietà fondamentali sono:\n'
          '1. Associatività: a * (b * c) = (a * b) * c\n'
          '2. Commutatività: a * b = b * a\n'
          '3. Elemento neutro e: e * m = m * e = m. Se esiste, il neutro è UNICO (e = e * e\' = e\'). '
          'In presenza di associatività, anche l\'elemento inverso è UNICO.',
      visualType: VisualDiagramType.cayleyTableGrid,
      exampleTitle: 'Esempio di Non Associatività',
      exampleText:
          'L\'elevamento a potenza su ℕ con a * b = aᵇ è un\'operazione interna, ma NON è associativa:\n'
          '2^(3^4) = 2^81 ≈ 2.4 · 10²⁴ ≠ 4096 = (2³)^4.',
      relatedTermIds: ['gruppo', 'gruppo_abeliano', 'anello_unitario'],
    ),

    'gruppo': const UniversityTerm(
      id: 'gruppo',
      name: 'Gruppo (G, *)',
      symbol: r'(G, *)',
      category: 'Strutture Algebriche',
      shortDefinition: 'Insieme G dotato di operazione interna associativa, con elemento neutro e inverso per ogni elemento.',
      formalLatex: r'\text{Assiomi: Gr1 (Associativa), Gr2 (Neutro } e \in G), \text{Gr3 (Inverso } g^{-1} \in G)',
      pedagogicalExplanation:
          'Il gruppo è la struttura algebrica fondamentale per studiare le simmetrie. '
          'Nei gruppi valgono le regole di cancellazione a sinistra e a destra (g₁ * g₂ = g₁ * g₃ ⇒ g₂ = g₃). '
          'La tavola di moltiplicazione (Tavola di Cayley) di un gruppo finito obbedisce alla regola del Sudoku: '
          'ogni elemento appare esattamente una volta in ogni riga e in ogni colonna.',
      visualType: VisualDiagramType.cayleyTableGrid,
      exampleTitle: 'Non-Esempi e Gruppi',
      exampleText:
          '• (ℕ, +) NON è un gruppo (mancano gli inversi dei numeri positivi).\n'
          '• (ℤ, +), (ℚ, +), (ℝ, +) sono gruppi.\n'
          '• (ℚ \\ {0}, ·) è un gruppo moltiplicativo.\n'
          '• (ℤ \\ {0}, ·) NON è un gruppo (gli unici invertibili sono ±1).',
      relatedTermIds: ['gruppo_abeliano', 'sottogruppo', 'omomorfismo_gruppi', 'gruppo_simmetrico'],
    ),

    'gruppo_abeliano': const UniversityTerm(
      id: 'gruppo_abeliano',
      name: 'Gruppo Abeliano (Commutativo)',
      symbol: r'a * b = b * a',
      category: 'Strutture Algebriche',
      shortDefinition: 'Gruppo in cui l\'operazione soddisfa anche la proprietà commutativa per ogni coppia di elementi.',
      formalLatex: r'\forall a, b \in G, \quad a * b = b * a',
      pedagogicalExplanation:
          'Prende il nome dal matematico norvegese Niels Henrik Abel (1802-1829). '
          'Nei gruppi abeliani l\'operazione viene spesso denotata con il simbolo di addizione (+), '
          'l\'elemento neutro con 0 e l\'inverso di a con -a.',
      visualType: VisualDiagramType.cayleyTableGrid,
      exampleTitle: 'Gruppi Abeliani Noti',
      exampleText:
          '(ℤ, +), (ℝⁿ, +), (ℤ/nℤ, +) sono tutti gruppi abeliani.\n'
          'Il più piccolo gruppo NON commutativo è il gruppo simmetrico S₃ (6 elementi).',
      relatedTermIds: ['gruppo', 'gruppo_simmetrico', 'sottogruppo'],
    ),

    'sottogruppo': const UniversityTerm(
      id: 'sottogruppo',
      name: 'Sottogruppo e Criterio di Sottogruppo',
      symbol: r'H \le G',
      category: 'Strutture Algebriche',
      shortDefinition: 'Sottoinsieme non vuoto H ⊆ G che è esso stesso un gruppo rispetto alla restrizione dell\'operazione.',
      formalLatex: r'H \le G \iff H \neq \emptyset \land \forall a, b \in H : ab^{-1} \in H',
      pedagogicalExplanation:
          'Teorema 1.107: Per verificare che H sia un sottogruppo non occorre controllare tutti gli assiomi uno per uno. '
          'Basta verificare la condizione compatta: H ≠ ∅ e per ogni a, b ∈ H vale ab⁻¹ ∈ H. '
          'Tutti i sottogruppi del gruppo additivo (ℤ, +) sono della forma nℤ = {nz : z ∈ ℤ} per un unico n ∈ ℕ (Teorema 1.109).',
      visualType: VisualDiagramType.subgroupVenn,
      exampleTitle: 'Esempio dei Sottogruppi di ℤ',
      exampleText:
          'I numeri pari 2ℤ formano un sottogruppo di (ℤ, +). 3ℤ, 4ℤ, ... sono tutti sottogruppi. '
          'Il sottogruppo banale è {0} = 0ℤ.',
      relatedTermIds: ['gruppo', 'omomorfismo_gruppi', 'teorema_cayley'],
    ),

    'omomorfismo_gruppi': const UniversityTerm(
      id: 'omomorfismo_gruppi',
      name: 'Omomorfismo di Gruppi e Nucleo',
      symbol: r'\varphi(g * h) = \varphi(g) \star \varphi(h)',
      category: 'Strutture Algebriche',
      shortDefinition: 'Applicazione tra gruppi che rispetta le rispettive operazioni algebriche. Il nucleo Ker(φ) va nell\'elemento neutro.',
      formalLatex: r'\varphi(g * h) = \varphi(g) \star \varphi(h), \quad \text{Ker}(\varphi) := \{g \in G_1 : \varphi(g) = e_2\}',
      pedagogicalExplanation:
          'Un omomorfismo trasforma la struttura di G₁ in quella di G₂: manda sempre il neutro nel neutro (φ(e₁) = e₂) '
          'e l\'inverso nell\'inverso (φ(g⁻¹) = φ(g)⁻¹). Un omomorfismo biiettivo è detto isomorfismo (G₁ ≅ G₂): '
          'gruppi isomorfi sono algebricamente indistinguibili.',
      visualType: VisualDiagramType.commutativeDiagram,
      exampleTitle: 'Omomorfismi su ℤ',
      exampleText:
          'Teorema 1.110: Tutti gli omomorfismi di gruppo φ: ℤ → ℤ sono della forma φ(z) = a · z per qualche a ∈ ℤ.',
      relatedTermIds: ['isomorfismo_gruppi', 'gruppo', 'sottogruppo', 'teorema_cayley', 'sottogruppo_alterno'],
    ),

    'isomorfismo_gruppi': const UniversityTerm(
      id: 'isomorfismo_gruppi',
      name: 'Isomorfismo di Gruppi',
      symbol: r'G_1 \cong G_2',
      category: 'Strutture Algebriche',
      shortDefinition: 'Omomorfismo di gruppi biiettivo la cui applicazione inversa è anch\'essa un omomorfismo di gruppi.',
      formalLatex: r'\varphi : G_1 \xrightarrow{\sim} G_2 \text{ con } \varphi \circ \varphi^{-1} = \text{id}_{G_2}, \; \varphi^{-1} \circ \varphi = \text{id}_{G_1}',
      pedagogicalExplanation:
          'Definizione 1.102: Due gruppi G₁ e G₂ si dicono isomorfi (G₁ ≅ G₂) se esiste un isomorfismo tra loro. '
          'Dal punto di vista algebrico, due gruppi isomorfi condividono identiche proprietà strutturali: '
          'hanno la stessa cardinalità, lo stesso reticolo di sottogruppi e le stesse simmetrie interne.',
      visualType: VisualDiagramType.commutativeDiagram,
      exampleTitle: 'Esempio di Isomorfismo',
      exampleText:
          'Il gruppo additivo (ℝ, +) è isomorfo al gruppo moltiplicativo dei reali positivi (ℝ_{>0}, ·) '
          'tramite l\'esponenziale: φ(x) = eˣ, con inversa data dal logaritmo naturale ln(x).',
      relatedTermIds: ['omomorfismo_gruppi', 'gruppo', 'teorema_cayley'],
    ),

    'gruppo_simmetrico': const UniversityTerm(
      id: 'gruppo_simmetrico',
      name: 'Gruppo Simmetrico Sₙ e Permutazioni',
      symbol: r'S_n = \text{Sym}(\{1, \dots, n\})',
      category: 'Gruppi di Permutazioni',
      shortDefinition: 'Il gruppo di tutte le biiezioni (permutazioni) dell\'insieme {1, ..., n} rispetto alla composizione. Ha n! elementi.',
      formalLatex: r'|S_n| = n! = 1 \cdot 2 \cdot \dots \cdot n',
      pedagogicalExplanation:
          'S₁ e S₂ sono abeliani (rispettivamente 1 e 2 elementi). '
          'Per ogni n ≥ 3, Sₙ è NON commutativo. Il gruppo S₃ (6 elementi) è il più piccolo gruppo non commutativo dell\'intera matematica.',
      visualType: VisualDiagramType.permutationBipartite,
      exampleTitle: 'Notazione a Matrice',
      exampleText:
          'Una permutazione σ si scrive indicando sotto ciascun elemento la sua immagine:\n'
          'σ = [ 1 2 3 ; 2 3 1 ] significa σ(1) = 2, σ(2) = 3, σ(3) = 1 (è il ciclo (1 2 3)).',
      relatedTermIds: ['ciclo_permutazione', 'trasposizione', 'segnatura_permutazione', 'teorema_cayley'],
    ),

    'ciclo_permutazione': const UniversityTerm(
      id: 'ciclo_permutazione',
      name: 'k-Ciclo e Decomposizione in Cicli Disgiunti',
      symbol: r'(i_1 \quad i_2 \quad \dots \quad i_k)',
      category: 'Gruppi di Permutazioni',
      shortDefinition: 'Permutazione che scambia ciclicamente k elementi mandando i_j in i_{j+1} e lascia fissi tutti gli altri.',
      formalLatex: r'\sigma = \gamma_1 \cdot \gamma_2 \cdot \dots \cdot \gamma_r \quad (\text{cicli disgiunti unici})',
      pedagogicalExplanation:
          'Teorema 1.114 (Teorema Fondamentale): Cicli disgiunti (con orbite disgiunte) commutano sempre tra loro. '
          'Ogni permutazione σ ∈ Sₙ si decompone in modo UNICO come prodotto di cicli disgiunti.',
      visualType: VisualDiagramType.cycleGraph,
      exampleTitle: 'Esempio di Decomposizione',
      exampleText:
          'In S₄, la permutazione che manda 1 in 2, 2 in 1, 3 in 4 e 4 in 3 si scrive in cicli disgiunti come (1 2)(3 4).',
      relatedTermIds: ['gruppo_simmetrico', 'trasposizione', 'segnatura_permutazione'],
    ),

    'trasposizione': const UniversityTerm(
      id: 'trasposizione',
      name: 'Trasposizione',
      symbol: r'(i \quad j)',
      category: 'Gruppi di Permutazioni',
      shortDefinition: 'Un 2-ciclo che scambia tra loro due elementi distinti i e j lasciando invariati tutti gli altri.',
      formalLatex: r'(i \quad j)^2 = \text{id}, \quad (i \quad j)^{-1} = (i \quad j)',
      pedagogicalExplanation:
          'Le trasposizioni sono i "mattoni atomici" di Sₙ: ogni permutazione può essere generata componendo trasposizioni. '
          'Sebbene il numero di trasposizioni in una scomposizione non sia univoco, la sua PARITÀ (pari o dispari) è rigorosamente invariante!',
      visualType: VisualDiagramType.permutationBipartite,
      exampleTitle: 'Generazione tramite Trasposizioni Adiacenti',
      exampleText:
          'Qualsiasi permutazione in Sₙ si può scrivere come prodotto delle trasposizioni elementari (1 2), (2 3), ..., (n-1 n).',
      relatedTermIds: ['ciclo_permutazione', 'segnatura_permutazione', 'sottogruppo_alterno'],
    ),

    'segnatura_permutazione': const UniversityTerm(
      id: 'segnatura_permutazione',
      name: 'Segnatura (Signum) e Inversioni',
      symbol: r'\text{sgn}(\sigma) \in \{+1, -1\}',
      category: 'Gruppi di Permutazioni',
      shortDefinition: 'Parità intrinseca di una permutazione: +1 se pari (numero pari di inversioni), -1 se dispari.',
      formalLatex: r'\text{sgn}(\sigma) = \prod_{1 \le i < j \le n} \frac{\sigma(j) - \sigma(i)}{j - i} = (-1)^{|\text{inv}(\sigma)|}',
      pedagogicalExplanation:
          'Teorema 1.121: L\'applicazione sgn: Sₙ → {+1, -1} è un omomorfismo di gruppi (sgn(σ · τ) = sgn(σ) · sgn(τ)). '
          'Ogni trasposizione ha segnatura -1. Il determinante di una matrice sarà poi definito proprio pesando le permutazioni con la loro segnatura.',
      visualType: VisualDiagramType.parityGauge,
      exampleTitle: 'Inversioni',
      exampleText:
          'Un\'inversione è una coppia i < j con σ(i) > σ(j). La trasposizione (1 2) ha una sola inversione: sgn(1 2) = (-1)¹ = -1.',
      relatedTermIds: ['gruppo_simmetrico', 'trasposizione', 'sottogruppo_alterno'],
    ),

    'sottogruppo_alterno': const UniversityTerm(
      id: 'sottogruppo_alterno',
      name: 'Sottogruppo Alterno Aₙ',
      symbol: r'A_n = \ker(\text{sgn})',
      category: 'Gruppi di Permutazioni',
      shortDefinition: 'Il sottogruppo formato da tutte e sole le permutazioni pari di Sₙ. Ha cardinalità n! / 2 e indice 2.',
      formalLatex: r'A_n := \{\sigma \in S_n : \text{sgn}(\sigma) = +1\}, \quad |A_n| = \frac{n!}{2}',
      pedagogicalExplanation:
          'Essendo il nucleo dell\'omomorfismo segnatura sgn: Sₙ → {±1}, Aₙ è un sottogruppo normale di indice [Sₙ : Aₙ] = 2. '
          'Per ogni trasposizione τ, Sₙ si partiziona nell\'unione disgiunta Sₙ = Aₙ ⊔ τAₙ.',
      visualType: VisualDiagramType.subgroupVenn,
      exampleTitle: 'Dimensioni',
      exampleText:
          '• S₃ ha 6 elementi ⇒ A₃ ha 3 elementi (le rotazioni {id, (1 2 3), (1 3 2)}).\n'
          '• S₄ ha 24 elementi ⇒ A₄ ha 12 elementi.',
      relatedTermIds: ['gruppo_simmetrico', 'segnatura_permutazione', 'sottogruppo'],
    ),

    'teorema_cayley': const UniversityTerm(
      id: 'teorema_cayley',
      name: 'Teorema di Cayley',
      symbol: r'G \hookrightarrow S_{|G|}',
      category: 'Strutture Algebriche',
      shortDefinition: 'Ogni gruppo finito G è isomorfo a un sottogruppo del gruppo simmetrico S_|G|.',
      formalLatex: r'\forall G \text{ finito}, \quad \exists H \le S_{|G|} \text{ t.c. } G \cong H',
      pedagogicalExplanation:
          'Teorema 1.126: Ogni elemento g di un gruppo agisce come una permutazione biiettiva m_g: G → G data dalla moltiplicazione '
          'a sinistra x ↦ g · x. La mappa g ↦ m_g è un omomorfismo iniettivo da G a S_|G|. '
          'Questo prova che la teoria astratta dei gruppi finiti coincide con la teoria dei gruppi di permutazioni.',
      visualType: VisualDiagramType.cayleyEmbedding,
      exampleTitle: 'Esempio con ℤ/3ℤ',
      exampleText:
          'Gli elementi {0, 1, 2} di ℤ/3ℤ corrispondono in S₃ all\'identità, al 3-ciclo (1 2 3) e a (1 3 2).',
      relatedTermIds: ['gruppo', 'gruppo_simmetrico', 'isomorfismo_gruppi'],
    ),

    'anello_unitario': const UniversityTerm(
      id: 'anello_unitario',
      name: 'Anello Unitario e Commutativo',
      symbol: r'(R, +, \cdot)',
      category: 'Strutture Algebriche',
      shortDefinition: 'Insieme R dotato di somma (gruppo abeliano) e moltiplicazione (associativa con elemento neutro 1), legate da distributività.',
      formalLatex: r'(R, +) \text{ gr. abeliano}, \quad \cdot \text{ assoc. con } 1_R, \quad a(b + c) = ab + ac',
      pedagogicalExplanation:
          'Il prototipo di anello è (ℤ, +, ·). In ogni anello vale 0 · a = 0 e (-1) · a = -a. '
          'Se la moltiplicazione è commutativa, l\'anello si dice commutativo. '
          'Esempi non commutativi importanti includono l\'anello delle matrici quadrate Mat_{n×n}(ℝ).',
      visualType: VisualDiagramType.ringDoubleStructure,
      exampleTitle: 'Esempi di Anelli',
      exampleText:
          '• ℤ è un anello commutativo unitario.\n'
          '• ℤ[i] = {a + ib : a, b ∈ ℤ} è l\'anello degli interi di Gauss.\n'
          '• R[x] è l\'anello dei polinomi a coefficienti in R.\n'
          '• Mat_{2×2}(ℝ) è un anello non commutativo.',
      relatedTermIds: ['campo', 'campo_finito_fp', 'polinomi_anello', 'matrici_2x2'],
    ),

    'campo': const UniversityTerm(
      id: 'campo',
      name: 'Campo (Corpo Commutativo)',
      symbol: r'(\mathbb{K}, +, \cdot)',
      category: 'Strutture Algebriche',
      shortDefinition: 'Anello commutativo unitario in cui ogni elemento non nullo possiede un inverso moltiplicativo.',
      formalLatex: r'(\mathbb{K}, +) \text{ gr. abeliano}, \quad (\mathbb{K} \setminus \{0\}, \cdot) \text{ gr. abeliano}, \quad a(b + c) = ab + ac',
      pedagogicalExplanation:
          'I campi sono le strutture algebriche sulle quali si sviluppa l\'algebra lineare: gli scalari di uno spazio vettoriale '
          'devono appartenere a un campo per poter dividere per qualsiasi scalare non nullo. '
          'Nei campi non esistono divisori dello zero: ab = 0 implica a = 0 oppure b = 0.',
      visualType: VisualDiagramType.fieldStar,
      exampleTitle: 'Campi Noti e Non-Campi',
      exampleText:
          '• ℚ, ℝ, ℂ sono campi infiniti.\n'
          '• ℤ NON è un campo (gli interi non nulli diversi da ±1 non hanno inverso moltiplicativo in ℤ).\n'
          '• ℚ[√2] = {a + b√2 : a, b ∈ ℚ} è un campo (l\'inverso di a + b√2 è (a - b√2)/(a² - 2b²)).',
      relatedTermIds: ['anello_unitario', 'campo_finito_fp'],
    ),

    'campo_finito_fp': const UniversityTerm(
      id: 'campo_finito_fp',
      name: 'Campi Finiti (Campi Primi 𝔽_p)',
      symbol: r'\mathbb{F}_p = \mathbb{Z}/p\mathbb{Z}',
      category: 'Strutture Algebriche',
      shortDefinition: 'Per ogni numero primo p, l\'anello modulare ℤ/pℤ è un campo finito con p elementi.',
      formalLatex: r'\mathbb{Z}/n\mathbb{Z} \text{ è un campo} \iff n = p \text{ è primo}',
      pedagogicalExplanation:
          'In informatica e crittografia, i campi finiti 𝔽_p permettono di fare algebra lineare esatta '
          'senza problemi di approssimazione decimale o overflow di memoria. '
          'Ogni elemento non nullo ha inverso calcolabile efficientemente con l\'algoritmo euclideo esteso.',
      visualType: VisualDiagramType.fieldStar,
      exampleTitle: 'Inversi in 𝔽₅',
      exampleText:
          'In 𝔽₅ = {0, 1, 2, 3, 4}:\n'
          '• 1 · 1 ≡ 1 ⇒ 1⁻¹ = 1\n'
          '• 2 · 3 = 6 ≡ 1 ⇒ 2⁻¹ = 3 e 3⁻¹ = 2\n'
          '• 4 · 4 = 16 ≡ 1 ⇒ 4⁻¹ = 4.',
      relatedTermIds: ['campo', 'anello_quoziente_zn', 'congruenza_modulo_n'],
    ),

    'polinomi_anello': const UniversityTerm(
      id: 'polinomi_anello',
      name: 'Anello dei Polinomi R[x]',
      symbol: r'R[x] = \left\{\sum_{i=0}^d a_i x^i : a_i \in R\right\}',
      category: 'Strutture Algebriche',
      shortDefinition: 'Espressioni formali a coefficienti in un anello R, equivalenti a successioni definitivamente nulle.',
      formalLatex: r'f = a_0 + a_1 x + \dots + a_d x^d, \quad \deg(f) := \max\{k \in \mathbb{N} : a_k \neq 0\}',
      pedagogicalExplanation:
          'La variabile x è un simbolo formale, non un numero. Due polinomi sono uguali se e solo se tutti i loro coefficienti '
          'coincidono ordinatamente. Dotato della consueta somma e del prodotto di Cauchy, R[x] è un anello.',
      visualType: VisualDiagramType.ringDoubleStructure,
      exampleTitle: 'Grado del Polinomio Nullo',
      exampleText:
          'Per convenzione rigorosa, il grado del polinomio nullo non è determinato (o posto a -∞), '
          'per preservare la legge deg(f · g) = deg(f) + deg(g).',
      relatedTermIds: ['anello_unitario', 'matrici_2x2'],
    ),

    'matrici_2x2': const UniversityTerm(
      id: 'matrici_2x2',
      name: 'Anello delle Matrici Mat₂ₓ₂(ℝ)',
      symbol: r'\text{Mat}_{2\times 2}(\mathbb{R})',
      category: 'Strutture Algebriche',
      shortDefinition: 'Tabelle quadrate 2×2 con coefficienti reali, con somma termine a termine e prodotto riga per colonna.',
      formalLatex: r'A = \begin{pmatrix} a & b \\ c & d \end{pmatrix}, \quad I_2 = \begin{pmatrix} 1 & 0 \\ 0 & 1 \end{pmatrix}',
      pedagogicalExplanation:
          'Teorema 1.133: La terna (Mat₂ₓ₂(ℝ), +, ·) è un anello NON commutativo con unità I₂. '
          'In generale A · B ≠ B · A. Inoltre contiene divisori dello zero: due matrici non nulle possono moltiplicarsi dando la matrice nulla!',
      visualType: VisualDiagramType.ringDoubleStructure,
      exampleTitle: 'Non Commutatività del Prodotto',
      exampleText:
          'Siano A = [0 1 ; 0 0] e B = [0 0 ; 1 0]:\n'
          '• A · B = [1 0 ; 0 0]\n'
          '• B · A = [0 0 ; 0 1]\n'
          'A · B ≠ B · A. Inoltre A² = A · A = [0 0 ; 0 0] (A è nilpotente pur non essendo nulla).',
      relatedTermIds: ['anello_unitario', 'campo'],
    ),
  };

  static UniversityTerm? getTerm(String id) => terms[id];

  static List<UniversityTerm> getAllTerms() {
    final list = terms.values.toList();
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }
}
