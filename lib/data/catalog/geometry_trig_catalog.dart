import '../../domain/models/knowledge_node.dart';

/// Catalogo dei nodi per Geometria e Goniometria:
/// Triangolo Euclideo, Pitagora ed Euclide, Cerchio Goniometrico,
/// Formule di Addizione/Duplicazione e Risoluzione Triangoli (Carnot e Seni).
class GeometryTrigCatalog {
  static List<KnowledgeNode> getAllNodes() {
    return [
      _createTriangleGeometryNode(),
      _createPythagorasNode(),
      _createTrigCircleNode(),
      _createTrigAdditionNode(),
      _createTrigTriangleNode(),
    ];
  }

  /// 1. Geometria del Triangolo e Angoli
  static KnowledgeNode _createTriangleGeometryNode() {
    return KnowledgeNode()
      ..serverId = 'mat_triang_01'
      ..title = 'Geometria del Triangolo e Angoli Interni'
      ..category = 'Matematica'
      ..subCategory = 'Geometria Euclidea Piana'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description = 'Tracciamento della retta parallela alla base passante per il vertice opposto.'
          ..latexEquation = r"r \parallel AB \quad \text{passante per } C"
          ..insight = 'Costruzione euclidea classica per applicare le proprietà degli angoli alterni interni.',
        ProofStep()
          ..description = 'Eguaglianza degli angoli alterni interni formati dalle trasversali AC e BC.'
          ..latexEquation = r"\alpha' = \alpha \quad \land \quad \beta' = \beta"
          ..insight = 'Gli angoli adiacenti al vertice C formano con gamma un angolo piatto di 180°.',
        ProofStep()
          ..description = 'Somma degli angoli sul vertice C che formano l\'angolo piatto di 180° (π radianti).'
          ..latexEquation = r"\alpha' + \gamma + \beta' = 180^\circ \implies \alpha + \beta + \gamma = 180^\circ = \pi \text{ rad}"
          ..insight = 'Teorema fondamentale della geometria euclidea piana.',
        ProofStep()
          ..description = 'Corollario: Teorema dell\'Angolo Esterno.'
          ..latexEquation =
              r"\delta_{\text{ext}} = 180^\circ - \gamma = \alpha + \beta"
          ..insight = 'In qualunque triangolo, ogni angolo esterno ha ampiezza esattamente pari alla somma dei due interni non adiacenti.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'triangle_solver'
        ..parameters = []);
  }

  /// 2. Teorema di Pitagora e Teoremi di Euclide
  static KnowledgeNode _createPythagorasNode() {
    return KnowledgeNode()
      ..serverId = 'mat_pythagoras_01'
      ..title = 'Teorema di Pitagora ed Euclide'
      ..category = 'Matematica'
      ..subCategory = 'Geometria Euclidea Piana'
      ..lastUpdated = DateTime.now()
      ..blocks = [
        ContentBlock()
          ..type = 'text_markdown'
          ..content = r"""### Il Teorema di Pitagora

In ogni triangolo rettangolo, il quadrato costruito sull'ipotenusa è equivalente alla somma dei quadrati costruiti sui cateti.

Questo principio geometrico è alla base di tutta la **metrica euclidea** nello spazio a due e tre dimensioni.""",
        ContentBlock()
          ..type = 'math_latex'
          ..content = r'a^2 + b^2 = c^2 \implies c = \sqrt{a^2 + b^2}',
        ContentBlock()
          ..type = 'info_box'
          ..content = r"""Dal Teorema di Pitagora discendono direttamente i **Teoremi di Euclide**: l'altezza relativa all'ipotenusa è medio proporzionale tra le proiezioni dei cateti ($h^2 = p_1 \cdot p_2$).""",
      ]
      ..algebraicProof = [
        ProofStep()
          ..description = 'Costruzione di un grande quadrato di lato (a+b) contenente 4 triangoli rettangoli e un quadrato interno di lato c.'
          ..latexEquation = r"\text{Area}_{\text{tot}} = (a + b)^2 = 4 \cdot \left(\frac{1}{2} a b\right) + c^2"
          ..insight = 'Dimostrazione algebrico-geometrica intuitiva basata sulla conservazione dell\'area.',
        ProofStep()
          ..description =
              'Espansione del binomio (a+b)^2 ed eguaglianza delle aree.'
          ..latexEquation = r"a^2 + 2 a b + b^2 = 2 a b + c^2"
          ..insight =
              'I 4 triangoli rettangoli occupano insieme un\'area pari a 2ab.',
        ProofStep()
          ..description = 'Semplificazione algebrica del termine misto 2ab.'
          ..latexEquation = r"a^2 + b^2 = c^2 \implies c = \sqrt{a^2 + b^2}"
          ..insight = 'In ogni triangolo rettangolo la somma delle aree dei quadrati sui cateti è uguale all\'area del quadrato sull\'ipotenusa.',
        ProofStep()
          ..description = 'Corollario: Primo e Secondo Teorema di Euclide.'
          ..latexEquation =
              r"c_1^2 = i \cdot p_1 \quad \land \quad h^2 = p_1 \cdot p_2"
          ..insight = 'L\'altezza relativa all\'ipotenusa è medio proporzionale tra le proiezioni dei cateti (Euclide II).',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'triangle_solver'
        ..parameters = []);
  }

  /// 3. Cerchio Goniometrico e Relazione Fondamentale
  static KnowledgeNode _createTrigCircleNode() {
    return KnowledgeNode()
      ..serverId = 'mat_trig_circ_01'
      ..title = 'Circonferenza Goniometrica e Relazione Fondamentale'
      ..category = 'Matematica'
      ..subCategory = 'Goniometria Fondamentale'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description = 'Definizione del cerchio goniometrico di raggio unitario R = 1 con centro nell\'origine.'
          ..latexEquation = r"x^2 + y^2 = 1 \quad \text{sul piano cartesiano}"
          ..insight = 'Ogni semiretta uscente dall\'origine forma un angolo θ con il semiasse positivo delle x.',
        ProofStep()
          ..description = 'Definizione analitica di Coseno e Seno come coordinate del punto di intersezione P(x, y).'
          ..latexEquation =
              r"x_P \equiv \cos(\theta), \quad y_P \equiv \sin(\theta)"
          ..insight = 'Il coseno è l\'ascissa e il seno è l\'ordinata del punto P sulla circonferenza unitaria.',
        ProofStep()
          ..description = 'Sostituzione nell\'equazione della circonferenza (applicazione di Pitagora al triangolo rettangolo interno).'
          ..latexEquation = r"(\cos\theta)^2 + (\sin\theta)^2 = 1 \implies \sin^2\theta + \cos^2\theta = 1"
          ..insight = 'La prima relazione fondamentale della goniometria è la formulazione trigonometrica del Teorema di Pitagora.',
        ProofStep()
          ..description = 'Corollario: Definizione di Tangente e Relazione Fondamentale Secondaria.'
          ..latexEquation = r"\tan\theta \equiv \frac{\sin\theta}{\cos\theta} \implies 1 + \tan^2\theta = \frac{1}{\cos^2\theta}"
          ..insight = 'Dividendo l\'identità fondamentale per cos²θ si ottiene la relazione diretta tra tangente e coseno.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'trig_circle'
        ..parameters = []);
  }

  /// 4. Formule di Addizione, Duplicazione e Bisezione
  static KnowledgeNode _createTrigAdditionNode() {
    return KnowledgeNode()
      ..serverId = 'mat_trig_add_01'
      ..title = 'Formule Goniometriche: Addizione, Duplicazione e Bisezione'
      ..category = 'Matematica'
      ..subCategory = 'Goniometria Fondamentale'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description = 'Distanza euclidea tra due punti P(cos α, sin α) e Q(cos β, sin β) sulla circonferenza unitaria.'
          ..latexEquation = r"d^2 = (\cos\alpha - \cos\beta)^2 + (\sin\alpha - \sin\beta)^2 = 2 - 2(\cos\alpha\cos\beta + \sin\alpha\sin\beta)"
          ..insight = 'La distanza tra i punti dipende solo dalla differenza angolare (α - β).',
        ProofStep()
          ..description = 'Eguaglianza con la distanza da (1, 0) ruotando l\'angolo: d² = (cos(α-β) - 1)² + sin²(α-β) = 2 - 2cos(α-β).'
          ..latexEquation = r"\cos(\alpha - \beta) = \cos\alpha \cos\beta + \sin\alpha \sin\beta"
          ..insight = 'Formula fondamentale di sottrazione da cui derivano tutte le altre identità goniometriche.',
        ProofStep()
          ..description = 'Sostituendo -β e usando la parità delle funzioni goniometriche (cos(-x)=cos x, sin(-x)=-sin x).'
          ..latexEquation = r"\cos(\alpha + \beta) = \cos\alpha \cos\beta - \sin\alpha \sin\beta, \quad \sin(\alpha \pm \beta) = \sin\alpha \cos\beta \pm \cos\alpha \sin\beta"
          ..insight = 'Formule di addizione complete per seno e coseno.',
        ProofStep()
          ..description =
              'Corollario: Formule di Duplicazione e Formule di Bisezione.'
          ..latexEquation = r"\sin(2\alpha) = 2\sin\alpha\cos\alpha, \quad \cos(2\alpha) = \cos^2\alpha - \sin^2\alpha \implies \sin^2\left(\frac{\alpha}{2}\right) = \frac{1 - \cos\alpha}{2}"
          ..insight = 'Indispensabili per il calcolo degli integrali trigonometrici e l\'analisi delle armoniche.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'trig_circle'
        ..parameters = []);
  }

  /// 5. Trigonometria del Triangolo: Carnot, Seni e Area
  static KnowledgeNode _createTrigTriangleNode() {
    return KnowledgeNode()
      ..serverId = 'mat_trig_triang_01'
      ..title = 'Teoremi dei Triangoli: Carnot, Seni e Formula dell\'Area'
      ..category = 'Matematica'
      ..subCategory = 'Trigonometria dei Triangoli'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description = 'Triangolo qualunque ABC: tracciamento dell\'altezza h da C che lo suddivide in due triangoli rettangoli.'
          ..latexEquation = r"h = b \sin\gamma, \quad x = b \cos\gamma \implies \text{base rimanente: } (a - x) = a - b \cos\gamma"
          ..insight = 'Proietta il lato b sulla base a usando seno e coseno dell\'angolo compreso γ.',
        ProofStep()
          ..description = 'Applicazione del Teorema di Pitagora al secondo triangolo rettangolo di ipotenusa c.'
          ..latexEquation = r"c^2 = h^2 + (a - b \cos\gamma)^2 = (b \sin\gamma)^2 + a^2 - 2 a b \cos\gamma + b^2 \cos^2\gamma"
          ..insight = 'Sviluppando il quadrato del binomio e raccogliendo b²(sin²γ + cos²γ) = b².',
        ProofStep()
          ..description = 'Teorema di Carnot (o del Coseno): generalizzazione di Pitagora per qualsiasi triangolo.'
          ..latexEquation = r"c^2 = a^2 + b^2 - 2 a b \cos\gamma"
          ..insight = 'Se γ = 90°, cos(90°) = 0 e la formula restituisce esattamente il Teorema di Pitagora c² = a² + b².',
        ProofStep()
          ..description =
              'Corollario: Teorema dei Seni e Formula Goniometrica dell\'Area.'
          ..latexEquation = r"\frac{a}{\sin\alpha} = \frac{b}{\sin\beta} = \frac{c}{\sin\gamma} = 2 R \quad \land \quad \text{Area} = \frac{1}{2} a b \sin\gamma"
          ..insight = 'Il Teorema dei Seni lega i lati al raggio R della circonferenza circoscritta; l\'area si calcola con due lati e il seno dell\'angolo compreso.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'triangle_solver'
        ..parameters = []);
  }
}
