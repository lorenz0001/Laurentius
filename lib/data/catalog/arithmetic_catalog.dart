import '../../domain/models/knowledge_node.dart';

/// Catalogo dei nodi per i fondamenti dell'Aritmetica:
/// Addizione, Moltiplicazione, Frazioni e Potenze.
class ArithmeticCatalog {
  static List<KnowledgeNode> getAllNodes() {
    return [
      _createAdditionNode(),
      _createMultiplicationNode(),
      _createFractionsNode(),
      _createPowersNode(),
    ];
  }

  /// 1. Addizione e Proprietà Fondamentali
  static KnowledgeNode _createAdditionNode() {
    return KnowledgeNode()
      ..serverId = 'mat_add_01'
      ..title = 'Addizione e Struttura Algebrica'
      ..category = 'Aritmetica'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description = 'Definizione assiomatica dell\'operazione binaria di addizione su insieme numerico.'
          ..latexEquation = r'a + b = c \quad \forall a,b \in \mathbb{R}'
          ..insight = 'L\'addizione quantifica l\'unione di quantità disgiunte o la traslazione orientata sulla retta reale.',
        ProofStep()
          ..description = 'Proprietà commutativa e associativa: l\'ordine e il raggruppamento non alterano la somma.'
          ..latexEquation = r'a + b = b + a \quad \land \quad (a + b) + c = a + (b + c)'
          ..insight = 'Garantisce che la somma di una sequenza finita di numeri sia indipendente dall\'ordine di calcolo.',
        ProofStep()
          ..description = 'Esistenza dell\'elemento neutro (zero) e dell\'elemento opposto (-a).'
          ..latexEquation = r'a + 0 = a \quad \land \quad a + (-a) = 0'
          ..insight = 'Rende l\'insieme dei numeri reali un gruppo abeliano rispetto all\'addizione.',
        ProofStep()
          ..description = 'Corollario: Unicità dell\'opposto e definizione di Sottrazione.'
          ..latexEquation = r'a - b \equiv a + (-b)'
          ..insight = 'La sottrazione non è un\'operazione primitiva distinta, ma l\'addizione con l\'elemento opposto.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'live_equation'
        ..equations = ['a + b']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Primo Addendo (a)'
            ..minValue = -20.0
            ..maxValue = 20.0
            ..defaultValue = 5.0
            ..stepSize = 1.0,
          InteractiveParameter()
            ..variableName = 'b'
            ..label = 'Secondo Addendo (b)'
            ..minValue = -20.0
            ..maxValue = 20.0
            ..defaultValue = 7.0
            ..stepSize = 1.0,
        ]);
  }

  /// 2. Moltiplicazione e Proprietà Distributiva
  static KnowledgeNode _createMultiplicationNode() {
    return KnowledgeNode()
      ..serverId = 'mat_mul_01'
      ..title = 'Moltiplicazione e Proprietà Distributiva'
      ..category = 'Aritmetica'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description = 'Definizione della moltiplicazione come addizione ripetuta b volte dell\'addendo a.'
          ..latexEquation = r'a \cdot b = \underbrace{a + a + \dots + a}_{b \text{ volte}} \quad (b \in \mathbb{N}^*)'
          ..insight = 'Rappresenta geometricamente l\'area di un rettangolo di dimensioni a e b.',
        ProofStep()
          ..description = 'Proprietà distributiva della moltiplicazione rispetto all\'addizione.'
          ..latexEquation = r'a \cdot (b + c) = a \cdot b + a \cdot c'
          ..insight = 'Ponte fondamentale tra addizione e moltiplicazione; base di ogni sviluppo di prodotti polinomiali.',
        ProofStep()
          ..description = 'Dimostrazione della regola dei segni: a * 0 = a * (1 - 1) = 0.'
          ..latexEquation = r'(-a) \cdot (-b) + (-a \cdot b) = (-a) \cdot (-b + b) = (-a) \cdot 0 = 0'
          ..insight = 'Poiché sia (-a)*(-b) sia a*b sommati a (-a*b) danno 0, per unicità dell\'opposto coincidono.',
        ProofStep()
          ..description = 'Corollario: Regola dei Segni e Legge di Annullamento del Prodotto.'
          ..latexEquation = r'(-a) \cdot (-b) = + (a \cdot b) \quad \land \quad (a \cdot b = 0 \iff a = 0 \lor b = 0)'
          ..insight = 'L\'annullamento del prodotto è il cardine algebrico per la risoluzione di ogni equazione polinomiale.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'live_equation'
        ..equations = ['a * b']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Fattore a'
            ..minValue = -10.0
            ..maxValue = 10.0
            ..defaultValue = 4.0
            ..stepSize = 1.0,
          InteractiveParameter()
            ..variableName = 'b'
            ..label = 'Fattore b'
            ..minValue = -10.0
            ..maxValue = 10.0
            ..defaultValue = -3.0
            ..stepSize = 1.0,
        ]);
  }

  /// 3. Frazioni e Numeri Razionali
  static KnowledgeNode _createFractionsNode() {
    return KnowledgeNode()
      ..serverId = 'mat_frac_01'
      ..title = 'Frazioni, Rapporti e Numeri Razionali'
      ..category = 'Aritmetica'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description = 'Definizione di inverso moltiplicativo (reciproco) per ogni numero non nullo.'
          ..latexEquation = r'\forall b \neq 0, \quad \exists b^{-1} = \frac{1}{b} : b \cdot \frac{1}{b} = 1'
          ..insight = 'La divisione a : b equivale alla moltiplicazione di a per l\'inverso moltiplicativo di b.',
        ProofStep()
          ..description = 'Somma di frazioni mediante ricerca del comune denominatore.'
          ..latexEquation = r'\frac{a}{b} + \frac{c}{d} = \frac{a \cdot d}{b \cdot d} + \frac{c \cdot b}{d \cdot b} = \frac{a d + b c}{b d}'
          ..insight = 'Riconduce due partizioni a una scala metrica comune per consentirne la somma algebrica.',
        ProofStep()
          ..description = 'Moltiplicazione e divisione tra frazioni.'
          ..latexEquation = r'\frac{a}{b} \cdot \frac{c}{d} = \frac{a c}{b d}, \quad \frac{a}{b} : \frac{c}{d} = \frac{a}{b} \cdot \frac{d}{c} = \frac{a d}{b c}'
          ..insight = 'Dividere per una frazione corrisponde a moltiplicare per la frazione invertita.',
        ProofStep()
          ..description = 'Corollario: Proprietà Invariantiva e Semplificazione di Frazioni.'
          ..latexEquation = r'\frac{a \cdot k}{b \cdot k} = \frac{a}{b} \quad (k \neq 0)'
          ..insight = 'Moltiplicando o dividendo numeratore e denominatore per una stessa quantità non nulla il rapporto resta invariato.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'live_equation'
        ..equations = ['a / b']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Numeratore (a)'
            ..minValue = -20.0
            ..maxValue = 20.0
            ..defaultValue = 6.0
            ..stepSize = 1.0,
          InteractiveParameter()
            ..variableName = 'b'
            ..label = 'Denominatore (b ≠ 0)'
            ..minValue = 1.0
            ..maxValue = 20.0
            ..defaultValue = 8.0
            ..stepSize = 1.0,
        ]);
  }

  /// 4. Potenze ed Esponenti
  static KnowledgeNode _createPowersNode() {
    return KnowledgeNode()
      ..serverId = 'mat_pow_01'
      ..title = 'Potenze, Radici ed Esponenti Reali'
      ..category = 'Aritmetica'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description = 'Definizione di potenza con esponente intero positivo come moltiplicazione ripetuta.'
          ..latexEquation = r'a^n = \underbrace{a \cdot a \cdot \dots \cdot a}_{n \text{ volte}} \quad (n \in \mathbb{N}^*)'
          ..insight = 'Esprime la crescita esponenziale e l\'iper-volume in n dimensioni.',
        ProofStep()
          ..description = 'Prodotto e quoziente di potenze aventi la stessa base.'
          ..latexEquation = r'a^n \cdot a^m = a^{n+m}, \quad \frac{a^n}{a^m} = a^{n-m}'
          ..insight = 'Gli esponenti si sommano nel prodotto e si sottraggono nel quoziente.',
        ProofStep()
          ..description = 'Deduzione dell\'esponente zero: a^n / a^n = a^{n-n} = a^0 = 1.'
          ..latexEquation = r'a^0 = 1 \quad (a \neq 0), \quad a^{-n} = \frac{1}{a^n}'
          ..insight = 'L\'esponente negativo sposta il fattore al denominatore con segno dell\'esponente invertito.',
        ProofStep()
          ..description = 'Corollario: Esponenti Frazionari ed Equivalenza con i Radicali.'
          ..latexEquation = r'a^{\frac{m}{n}} = \sqrt[n]{a^m} \quad (a > 0, n \in \mathbb{N}^*)'
          ..insight = 'Unifica la teoria delle potenze con quella dei radicali, rendendo applicabili le stesse leggi algebriche.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'live_equation'
        ..equations = ['pow(a, b)']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Base (a)'
            ..minValue = 0.5
            ..maxValue = 5.0
            ..defaultValue = 2.0
            ..stepSize = 0.5,
          InteractiveParameter()
            ..variableName = 'b'
            ..label = 'Esponente (b)'
            ..minValue = -3.0
            ..maxValue = 4.0
            ..defaultValue = 3.0
            ..stepSize = 1.0,
        ]);
  }
}
