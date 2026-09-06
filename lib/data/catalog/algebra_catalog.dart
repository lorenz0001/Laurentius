import '../../domain/models/knowledge_node.dart';

/// Catalogo dei nodi per l'Algebra:
/// Prodotti Notevoli, Equazioni di 2° Grado, Parabola e Logaritmi.
class AlgebraCatalog {
  static List<KnowledgeNode> getAllNodes() {
    return [
      _createBinomialNode(),
      _createQuadraticEquationNode(),
      _createParabolaNode(),
      _createLogarithmsNode(),
    ];
  }

  /// 1. Prodotti Notevoli e Binomio
  static KnowledgeNode _createBinomialNode() {
    return KnowledgeNode()
      ..serverId = 'mat_binom_01'
      ..title = 'Prodotti Notevoli e Scomposizioni'
      ..category = 'Matematica'
      ..subCategory = 'Polinomi e Prodotti Notevoli'
      ..lastUpdated = DateTime.now()
      ..blocks = [
        ContentBlock()
          ..type = 'text_markdown'
          ..content =
              r'### Espansione Polinomiale e Geometria dei Prodotti'
              '\n\n'
              r'I **prodotti notevoli** sono identità algebriche fondamentali che abbreviano il calcolo del prodotto tra polinomi.'
              '\n\n'
              r'Il quadrato di un binomio $(a + b)^2$ descrive la suddivisione geometrica di un quadrato di lato $a+b$ in 4 regioni:'
              '\n'
              r'- Un quadrato grande di area $a^2$'
              '\n'
              r'- Un quadrato piccolo di area $b^2$'
              '\n'
              r'- Due rettangoli uguali di area $a \cdot b$'
              '\n\n'
              r'Sommando le 4 aree si ottiene la formula esatta: $(a+b)^2 = a^2 + 2ab + b^2$.',
        ContentBlock()
          ..type = 'math_latex'
          ..content = r'(a + b)^2 = a^2 + 2ab + b^2',
        ContentBlock()
          ..type = 'info_box'
          ..content = r'La celebre differenza di quadrati $(a+b)(a-b) = a^2 - b^2$ annulla simmetricamente i termini misti $(+ab)$ e $(-ab)$, costituendo il fondamento per la razionalizzazione dei denominatori.',
      ]
      ..algebraicProof = [
        ProofStep()
          ..description = r'Sviluppo del quadrato di un binomio applicando la proprietà distributiva.'
          ..latexEquation = r'(a + b)^2 = (a + b)(a + b) = a^2 + a b + b a + b^2 = a^2 + 2 a b + b^2'
          ..insight = 'Geometricamente rappresenta l\'area di un quadrato di lato (a+b) suddiviso in due quadrati e due rettangoli uguali.',
        ProofStep()
          ..description = 'Sviluppo della differenza di quadrati: prodotto di somma per differenza.'
          ..latexEquation =
              r'(a + b)(a - b) = a^2 - a b + b a - b^2 = a^2 - b^2'
          ..insight = 'I termini misti (+ab e -ab) si annullano perfettamente per simmetria opposta.',
        ProofStep()
          ..description = 'Cubo di binomio: espansione di (a+b) * (a+b)^2.'
          ..latexEquation = r'(a + b)^3 = a^3 + 3 a^2 b + 3 a b^2 + b^3'
          ..insight = 'I coefficienti (1, 3, 3, 1) corrispondono alla riga 3 del Triangolo di Tartaglia.',
        ProofStep()
          ..description =
              'Corollario: Somma e Differenza di Cubi e Binomio di Newton.'
          ..latexEquation = r'a^3 \pm b^3 = (a \pm b)(a^2 \mp a b + b^2) \quad \land \quad (a+b)^n = \sum_{k=0}^n \binom{n}{k} a^{n-k} b^k'
          ..insight = 'Permette di scomporre istantaneamente polinomi di terzo grado e sviluppare potenze ennesime.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'live_equation'
        ..equations = ['a * a + 2 * a * b + b * b']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Termine a'
            ..minValue = -5.0
            ..maxValue = 5.0
            ..defaultValue = 2.0
            ..stepSize = 0.5,
          InteractiveParameter()
            ..variableName = 'b'
            ..label = 'Termine b'
            ..minValue = -5.0
            ..maxValue = 5.0
            ..defaultValue = 3.0
            ..stepSize = 0.5,
        ]);
  }

  /// 2. Equazioni di Secondo Grado e Formula Risolutiva
  static KnowledgeNode _createQuadraticEquationNode() {
    return KnowledgeNode()
      ..serverId = 'mat_quad_eq_01'
      ..title = 'Equazioni di Secondo Grado e Discriminante'
      ..category = 'Matematica'
      ..subCategory = 'Equazioni di Secondo Grado'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description = 'Forma normale dell\'equazione di 2° grado con a ≠ 0.'
          ..latexEquation = r'a x^2 + b x + c = 0 \implies x^2 + \frac{b}{a} x + \frac{c}{a} = 0'
          ..insight = 'Si divide per il primo coefficiente a per rendere monico il termine quadratico.',
        ProofStep()
          ..description = 'Completamento del quadrato: aggiunta e sottrazione di (b / 2a)^2.'
          ..latexEquation = r'\left(x + \frac{b}{2a}\right)^2 - \frac{b^2}{4a^2} + \frac{c}{a} = 0 \implies \left(x + \frac{b}{2a}\right)^2 = \frac{b^2 - 4 a c}{4 a^2}'
          ..insight = 'Trasforma un trinomio quadratico nel quadrato di un binomio isolando il discriminante Delta = b^2 - 4ac.',
        ProofStep()
          ..description =
              'Estrazione di radice quadrata e isolamento della variabile x.'
          ..latexEquation = r'x + \frac{b}{2a} = \frac{\pm \sqrt{b^2 - 4 a c}}{2 a} \implies x_{1,2} = \frac{-b \pm \sqrt{\Delta}}{2 a}'
          ..insight = 'Dimostrazione rigorosa della celebre formula risolutiva di secondo grado.',
        ProofStep()
          ..description =
              'Corollario: Relazioni di Viète e Scomposizione del Trinomio.'
          ..latexEquation = r'x_1 + x_2 = -\frac{b}{a}, \quad x_1 \cdot x_2 = \frac{c}{a} \implies a x^2 + b x + c = a(x - x_1)(x - x_2)'
          ..insight = 'Consente di risalire ai coefficienti conoscendo le radici e di fattorizzare immediatamente il polinomio.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['a * x * x + b * x + c']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Coeff. a'
            ..minValue = -3.0
            ..maxValue = 3.0
            ..defaultValue = 1.0
            ..stepSize = 0.5,
          InteractiveParameter()
            ..variableName = 'b'
            ..label = 'Coeff. b'
            ..minValue = -6.0
            ..maxValue = 6.0
            ..defaultValue = -2.0
            ..stepSize = 0.5,
          InteractiveParameter()
            ..variableName = 'c'
            ..label = 'Coeff. c'
            ..minValue = -6.0
            ..maxValue = 6.0
            ..defaultValue = -3.0
            ..stepSize = 0.5,
        ]);
  }

  /// 3. Funzione Quadratica e Parabola
  static KnowledgeNode _createParabolaNode() {
    return KnowledgeNode()
      ..serverId = 'mat_parabola_01'
      ..title = 'Funzione Quadratica e Parabola'
      ..category = 'Matematica'
      ..subCategory = 'Funzioni e Geometria Analitica'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description = 'Forma canonica polinomiale di secondo grado sul piano cartesiano.'
          ..latexEquation = r'y = a x^2 + b x + c \quad (a \neq 0)'
          ..insight = 'Il coefficiente quadratico a governa l\'apertura e il verso della concavità.',
        ProofStep()
          ..description = 'Completamento del quadrato per individuare la traslazione del vertice.'
          ..latexEquation =
              r'y = a \left(x + \frac{b}{2a}\right)^2 - \frac{b^2 - 4 a c}{4 a}'
          ..insight = 'La forma vertice y - y_V = a(x - x_V)^2 esplicita l\'origine traslata.',
        ProofStep()
          ..description =
              'Corollario: Coordinate del Vertice, Asse di Simmetria e Fuoco.'
          ..latexEquation = r'V = \left(-\frac{b}{2a}, -\frac{\Delta}{4a}\right), \quad x = -\frac{b}{2a}, \quad F = \left(-\frac{b}{2a}, \frac{1-\Delta}{4a}\right)'
          ..insight = 'Individua l\'apice della traiettoria nei moti balistici e la proprietà focale riflettente della parabola.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['a * x * x + b * x + c']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Curvatura (a)'
            ..minValue = -3.0
            ..maxValue = 3.0
            ..defaultValue = 1.0
            ..stepSize = 0.1,
          InteractiveParameter()
            ..variableName = 'b'
            ..label = 'Traslazione Orizzontale (b)'
            ..minValue = -4.0
            ..maxValue = 4.0
            ..defaultValue = 0.0
            ..stepSize = 0.2,
          InteractiveParameter()
            ..variableName = 'c'
            ..label = 'Intercetta Verticale (c)'
            ..minValue = -5.0
            ..maxValue = 5.0
            ..defaultValue = -2.0
            ..stepSize = 0.5,
        ]);
  }

  /// 4. Logaritmi ed Esponenziali
  static KnowledgeNode _createLogarithmsNode() {
    return KnowledgeNode()
      ..serverId = 'mat_log_01'
      ..title = 'Logaritmi ed Esponenziali'
      ..category = 'Matematica'
      ..subCategory = 'Funzioni Esponenziali e Logaritmiche'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description = 'Definizione fondamentale: il logaritmo è l\'esponente da assegnare alla base b per ottenere x.'
          ..latexEquation =
              r'b^y = x \iff y = \log_b(x) \quad (b > 0, b \neq 1, x > 0)'
          ..insight = 'Rappresenta l\'operazione inversa della funzione esponenziale per basi positive.',
        ProofStep()
          ..description = 'Proprietà del prodotto: trasforma la moltiplicazione in una somma su scala logaritmica.'
          ..latexEquation = r'\log_b(x \cdot y) = \log_b(x) + \log_b(y)'
          ..insight = 'Alla base del funzionamento dei regoli calcolatori e dell\'elaborazione di segnali in decibel.',
        ProofStep()
          ..description = 'Proprietà delle potenze: l\'esponente dell\'argomento diventa fattore moltiplicativo.'
          ..latexEquation = r'\log_b(x^k) = k \cdot \log_b(x)'
          ..insight =
              'Permette di linearizzare equazioni esponenziali non algebriche.',
        ProofStep()
          ..description = 'Corollario: Formula del Cambiamento di Base.'
          ..latexEquation =
              r'\log_a(x) = \frac{\log_b(x)}{\log_b(a)} = \frac{\ln(x)}{\ln(a)}'
          ..insight = 'Consente di calcolare qualsiasi logaritmo usando la base naturale (e) o decimale (10), essenziale in chimica e fisica.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'live_equation'
        ..equations = ['log(x) / log(b)']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'x'
            ..label = 'Argomento (x > 0)'
            ..minValue = 0.5
            ..maxValue = 50.0
            ..defaultValue = 8.0
            ..stepSize = 0.5,
          InteractiveParameter()
            ..variableName = 'b'
            ..label = 'Base (b > 0, ≠ 1)'
            ..minValue = 1.5
            ..maxValue = 10.0
            ..defaultValue = 2.0
            ..stepSize = 0.5,
        ]);
  }
}
