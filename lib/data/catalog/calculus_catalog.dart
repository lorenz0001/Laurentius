import '../../domain/models/knowledge_node.dart';

/// Catalogo dei nodi per l'Analisi Matematica:
/// Limiti Notevoli, Derivata & Rapporto Incrementale, Regole di Derivazione,
/// Teoremi di Rolle/Lagrange/Monotonia, Somme di Riemann e Teorema Fondamentale del Calcolo.
class CalculusCatalog {
  static List<KnowledgeNode> getAllNodes() {
    return [
      _createLimitsNode(),
      _createDerivativeDefinitionNode(),
      _createDerivativeRulesNode(),
      _createDerivativeTheoremsNode(),
      _createRiemannIntegralNode(),
      _createFundamentalTheoremOfCalculusNode(),
    ];
  }

  /// 1. Limiti e Limiti Notevoli
  static KnowledgeNode _createLimitsNode() {
    return KnowledgeNode()
      ..serverId = 'mat_limits_01'
      ..title = 'Limiti di Funzione e Limiti Notevoli'
      ..category = 'Matematica'
      ..subCategory = 'Limiti e Continuità'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description = 'Confronto geometrico sulla circonferenza goniometrica per x nel primo quadrante.'
          ..latexEquation = r"\text{Area}(\triangle OAP) < \text{Area}(\text{settore } OAP) < \text{Area}(\triangle OAT) \implies \sin x < x < \tan x"
          ..insight = 'L\'arco di circonferenza x è compreso tra la semicorda del seno e il segmento della tangente.',
        ProofStep()
          ..description = 'Divisione per sin x (positivo in (0, π/2)) e passaggio ai reciproci.'
          ..latexEquation = r"1 < \frac{x}{\sin x} < \frac{1}{\cos x} \implies \cos x < \frac{\sin x}{x} < 1"
          ..insight = 'Inverte il verso delle disuguaglianze intrappolando sin(x)/x tra cos(x) e 1.',
        ProofStep()
          ..description = 'Passaggio al limite per x -> 0 e Teorema del Confronto (dei Carabinieri).'
          ..latexEquation = r"\lim_{x \to 0} \cos x = 1 \implies \lim_{x \to 0} \frac{\sin x}{x} = 1"
          ..insight = 'Poiché entrambi gli estremi tendono a 1, la funzione centrale converge necessariamente a 1.',
        ProofStep()
          ..description =
              'Corollario: Limiti Notevoli Goniometrici ed Esponenziali.'
          ..latexEquation = r"\lim_{x \to 0} \frac{1 - \cos x}{x^2} = \frac{1}{2} \quad \land \quad \lim_{x \to 0} \frac{e^x - 1}{x} = 1"
          ..insight = 'Derivati per sostituzione e moltiplicazione per (1+cos x); fondamentali per calcolare le derivate prime.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['sin(k * x) / x']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'k'
            ..label = 'Fattore di scala k in sin(k·x)/x'
            ..minValue = 0.5
            ..maxValue = 3.0
            ..defaultValue = 1.0
            ..stepSize = 0.5,
        ]);
  }

  /// 2. Rapporto Incrementale e Derivata
  static KnowledgeNode _createDerivativeDefinitionNode() {
    return KnowledgeNode()
      ..serverId = 'mat_deriv_def_01'
      ..title = 'Rapporto Incrementale e Definizione di Derivata'
      ..category = 'Matematica'
      ..subCategory = 'Calcolo Differenziale'
      ..lastUpdated = DateTime.now()
      ..blocks = [
        ContentBlock()
          ..type = 'text_markdown'
          ..content = r"""### Il Concetto di Derivata

La **derivata** esprime il tasso di variazione istantaneo di una grandezza. Geometricamente, corrisponde al coefficiente angolare della **retta tangente** al grafico della funzione in un punto fissato $x_0$.

Si costruisce considerando il limite del rapporto incrementale al tendere a zero dell'incremento $h$:""",
        ContentBlock()
          ..type = 'math_latex'
          ..content = r"f'(x_0) = \lim_{h \to 0} \frac{f(x_0 + h) - f(x_0)}{h}",
        ContentBlock()
          ..type = 'info_box'
          ..content = r"""La derivabilità è una proprietà locale più forte della semplice continuità: se una funzione ammette derivata finita in $x_0$, allora è garantita anche la sua continuità in tale punto.""",
      ]
      ..algebraicProof = [
        ProofStep()
          ..description = 'Definizione di rapporto incrementale: pendenza della retta secante passante per P(x₀, f(x₀)) e Q(x₀+h, f(x₀+h)).'
          ..latexEquation =
              r"\frac{\Delta y}{\Delta x} = \frac{f(x_0 + h) - f(x_0)}{h}"
          ..insight = 'Misura la velocità di variazione media della grandezza nell\'intervallo [x₀, x₀+h].',
        ProofStep()
          ..description = 'Passaggio al limite per incremento h -> 0: pendenza istantanea della retta tangente.'
          ..latexEquation = r"f'(x_0) = \frac{df}{dx}(x_0) \equiv \lim_{h \to 0} \frac{f(x_0 + h) - f(x_0)}{h}"
          ..insight = 'Se il limite esiste finito, la funzione è derivabile in x₀ e la retta secante collassa sulla retta tangente.',
        ProofStep()
          ..description = 'Equazione cartesiana della retta tangente alla curva nel punto (x₀, f(x₀)).'
          ..latexEquation = r"y - f(x_0) = f'(x_0) \cdot (x - x_0)"
          ..insight = 'La derivata prima f\'(x₀) è esattamente il coefficiente angolare m della retta tangente.',
        ProofStep()
          ..description = 'Corollario: Continuità delle Funzioni Derivabili.'
          ..latexEquation = r"f \text{ derivabile in } x_0 \implies \lim_{h \to 0} [f(x_0+h) - f(x_0)] = \lim_{h \to 0} \left[ h \cdot \frac{f(x_0+h)-f(x_0)}{h} \right] = 0 \cdot f'(x_0) = 0"
          ..insight = 'Ogni funzione derivabile è necessariamente continua nel punto (la derivabilità è una condizione più forte della continuità).',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'derivative_tangent'
        ..parameters = []);
  }

  /// 3. Regole di Derivazione e Funzioni Goniometriche
  static KnowledgeNode _createDerivativeRulesNode() {
    return KnowledgeNode()
      ..serverId = 'mat_deriv_rules_01'
      ..title = 'Regole di Derivazione: Prodotto, Quoziente e Catena'
      ..category = 'Matematica'
      ..subCategory = 'Calcolo Differenziale'
      ..lastUpdated = DateTime.now()
      ..blocks = [
        ContentBlock()
          ..type = 'text_markdown'
          ..content = r"""### Come Derivare Espressioni Complesse

Quando conosciamo la derivata di funzioni base, come calcoliamo la derivata del loro prodotto o della loro composizione?

#### 1. Regola del Prodotto (Formula di Leibniz)
Pensa a un rettangolo di lati $u(x)$ e $v(x)$. Se entrambi i lati crescono di una piccola quantità $\Delta u$ e $\Delta v$, la nuova area cresce sia per l'allargamento della base che per l'innalzamento dell'altezza. La derivata del prodotto non è semplicemente il prodotto delle derivate, ma una combinazione bilineare:""",
        ContentBlock()
          ..type = 'math_latex'
          ..content = r"(u \cdot v)' = u' \cdot v + u \cdot v'",
        ContentBlock()
          ..type = 'text_markdown'
          ..content = r"""#### 2. Regola della Catena (Funzioni Composte)
Se una grandezza $y$ dipende da $u$, e a sua volta $u$ dipende da $x$, come ruote dentate di un ingranaggio, la velocità complessiva di rotazione è il prodotto dei singoli tassi di variazione:""",
        ContentBlock()
          ..type = 'math_latex'
          ..content = r"\frac{dy}{dx} = \frac{dy}{du} \cdot \frac{du}{dx} \iff [f(g(x))]' = f'(g(x)) \cdot g'(x)",
        ContentBlock()
          ..type = 'info_box'
          ..content = r"""Grazie a queste regole e alla derivata trigonometrica $(\sin x)' = \cos x$, possiamo determinare istantaneamente il tasso di variazione di qualsiasi modello scientifico o ingegneristico.""",
      ]
      ..algebraicProof = [
        ProofStep()
          ..description = 'Rapporto incrementale del prodotto f(x)*g(x) con artificio +f(x+h)g(x) - f(x+h)g(x).'
          ..latexEquation = r"\frac{f(x+h)g(x+h) - f(x)g(x)}{h} = f(x+h)\frac{g(x+h)-g(x)}{h} + g(x)\frac{f(x+h)-f(x)}{h}"
          ..insight = 'Tecnica algebrica classica per scomporre l\'incremento congiunto di due funzioni.',
        ProofStep()
          ..description = 'Regola del Prodotto di Leibniz per h -> 0: sfruttando la continuità di f(x+h) -> f(x).'
          ..latexEquation = r"(f \cdot g)'(x) = f'(x) g(x) + f(x) g'(x)"
          ..insight = 'La derivata di un prodotto non è il prodotto delle derivate, ma una combinazione bilineare simmetrica.',
        ProofStep()
          ..description = 'Derivata delle funzioni goniometriche fondamentali mediante limite notevole: (sin x)\'.'
          ..latexEquation = r"(\sin x)' = \lim_{h \to 0} \frac{\sin(x+h) - \sin x}{h} = \lim_{h \to 0} \left[ \sin x \frac{\cos h - 1}{h} + \cos x \frac{\sin h}{h} \right] = \cos x"
          ..insight = 'Poiché (cos h - 1)/h -> 0 e (sin h)/h -> 1, la derivata di sin(x) è esattamente cos(x).',
        ProofStep()
          ..description = 'Corollario: Derivata delle Potenze, Quoziente e Regola della Catena.'
          ..latexEquation = r"(x^n)' = n x^{n-1}, \quad \left(\frac{f}{g}\right)' = \frac{f'g - f g'}{g^2}, \quad [f(g(x))]' = f'(g(x)) \cdot g'(x)"
          ..insight = 'Permette di derivare qualsiasi funzione composta algebrica, trigonometrica ed esponenziale.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'derivative_tangent'
        ..parameters = []);
  }

  /// 4. Teoremi di Fermat, Rolle, Lagrange e Monotonia
  static KnowledgeNode _createDerivativeTheoremsNode() {
    return KnowledgeNode()
      ..serverId = 'mat_deriv_theorems_01'
      ..title = 'Teoremi di Rolle, Lagrange e Criterio di Monotonia'
      ..category = 'Matematica'
      ..subCategory = 'Teoremi Differenziali'
      ..lastUpdated = DateTime.now()
      ..blocks = [
        ContentBlock()
          ..type = 'text_markdown'
          ..content = r"""### L'Intuizione dei Teoremi del Calcolo

Immagina di percorrere un tratto autostradale di 130 km in esattamente un'ora. La tua **velocità media** è stata di 130 km/h. Anche se hai accelerato o frenato, c'è stato sicuramente almeno un istante durante il viaggio in cui il tuo tachimetro segnava esattamente 130 km/h!

Questo principio intuitivo e fondamentale è il **Teorema del Valor Medio di Lagrange**: se una curva è continua e liscia, esiste sempre almeno un punto interno $c$ in cui la **pendenza istantanea** della tangente coincide con la pendenza media della corda secante:""",
        ContentBlock()
          ..type = 'math_latex'
          ..content = r"f'(c) = \frac{f(b) - f(a)}{b - a}",
        ContentBlock()
          ..type = 'text_markdown'
          ..content = r"""### Il Teorema di Rolle: Tornare alla Stessa Quota

Cosa accade se gli estremi si trovano alla stessa altezza, ossia $f(a) = f(b)$?
Pensa a una palla lanciata verticalmente in aria: sale, raggiunge il punto di massima quota e ricade al punto di partenza. Nel punto più alto, per una frazione infinitesima di secondo, la palla si arresta prima di invertire la direzione: la sua velocità istantanea è zero!

Questo è il **Teorema di Rolle**: se $f(a) = f(b)$, esiste almeno un punto $c \in (a, b)$ in cui la tangente è orizzontale:""",
        ContentBlock()
          ..type = 'math_latex'
          ..content = r"f'(c) = 0",
        ContentBlock()
          ..type = 'info_box'
          ..content = r"""**Conseguenza Fondamentale (Criterio di Monotonia):**
- Se $f'(x) > 0$, la curva sale (funzione crescente).
- Se $f'(x) < 0$, la curva scende (funzione decrescente).
- Se $f'(x) = 0$ su un intero intervallo, la curva è perfettamente orizzontale e piatta: la funzione è costante ($f(x) = C$).""",
      ]
      ..algebraicProof = [
        ProofStep()
          ..description = 'Teorema di Fermat sui punti estremanti interni: se x₀ è punto di massimo o minimo locale e f è derivabile.'
          ..latexEquation = r"\frac{f(x_0+h)-f(x_0)}{h} \le 0 \text{ per } h>0 \quad \land \quad \ge 0 \text{ per } h<0 \implies f'(x_0) = 0"
          ..insight = 'Nei punti di massimo o minimo la retta tangente alla funzione deve essere orizzontale.',
        ProofStep()
          ..description = 'Teorema di Rolle: funzione continua in [a, b], derivabile in (a, b) con f(a) = f(b).'
          ..latexEquation =
              r"f(a) = f(b) \implies \exists c \in (a, b) : f'(c) = 0"
          ..insight = 'Se gli estremi coincidono, la funzione deve avere almeno un punto a derivata nulla.',
        ProofStep()
          ..description = 'Teorema del Valor Medio di Lagrange: applicazione di Rolle alla retta secante g(x) = f(x) - [(f(b)-f(a))/(b-a)](x-a).'
          ..latexEquation =
              r"\exists c \in (a, b) : f'(c) = \frac{f(b) - f(a)}{b - a}"
          ..insight = 'Esiste almeno un punto interno c in cui la retta tangente è perfettamente parallela alla retta secante passante per gli estremi.',
        ProofStep()
          ..description = 'Corollario: Criterio di Monotonia e Caratterizzazione delle Costanti.'
          ..latexEquation = r"f'(x) \ge 0 \iff f(x) \text{ crescente} \quad \land \quad (f'(x) = 0 \implies f(x) = C)"
          ..insight = 'Il segno della derivata governa la crescita della funzione; se la derivata è identicamente nulla, la funzione è costante.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'rolle_lagrange'
        ..equations = ['x * x * x / 3 - x']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Estremo sinistro (a)'
            ..minValue = -2.4
            ..maxValue = -0.2
            ..defaultValue = -1.8
            ..stepSize = 0.1,
          InteractiveParameter()
            ..variableName = 'b'
            ..label = 'Estremo destro (b)'
            ..minValue = 0.2
            ..maxValue = 2.4
            ..defaultValue = 1.4
            ..stepSize = 0.1,
        ]);
  }

  /// 5. Integrale di Riemann e Somme di Rettangoli
  static KnowledgeNode _createRiemannIntegralNode() {
    return KnowledgeNode()
      ..serverId = 'mat_riemann_01'
      ..title = 'Integrale di Riemann e Somme di Rettangoli'
      ..category = 'Matematica'
      ..subCategory = 'Calcolo Integrale'
      ..lastUpdated = DateTime.now()
      ..blocks = [
        ContentBlock()
          ..type = 'text_markdown'
          ..content = r"""### Misurare l'Area sotto una Curva

Come possiamo calcolare con precisione l'area racchiusa sotto una curva non lineare?
Bernhard Riemann ebbe un'intuizione semplice ed elegante: suddividere la superficie complessa in tante piccole striscioline verticali rettangolari, facili da calcolare (base per altezza!).

Se dividiamo l'intervallo $[a, b]$ in $N$ parti uguali di ampiezza $\Delta x = \frac{b-a}{N}$, l'area totale approssimata è la somma delle aree dei singoli rettangoli:""",
        ContentBlock()
          ..type = 'math_latex'
          ..content = r"S_N = \sum_{i=1}^N f(x_i^*) \cdot \Delta x",
        ContentBlock()
          ..type = 'text_markdown'
          ..content = r"""### Il Limite all'Infinito: La Somma Diventa Integrale

Cosa succede aumentando il numero $N$ di rettangoli all'infinito ($N \to \infty$ e $\Delta x \to 0$)?
I gradini e gli spazi vuoti tra la curva e i rettangoli svaniscono completamente: l'approssimazione diventa esatta e la sommatoria discreta diventa l'**integrale definito**:""",
        ContentBlock()
          ..type = 'math_latex'
          ..content = r"\lim_{N \to \infty} \sum_{i=1}^N f(x_i^*) \Delta x = \int_a^b f(x) \, dx",
        ContentBlock()
          ..type = 'info_box'
          ..content = r"""L'integrale è il cardine dell'accumulazione: permette di calcolare aree, volumi, lavoro fisico ed energia accumulata da forze variabili.""",
      ]
      ..algebraicProof = [
        ProofStep()
          ..description = 'Partizione dell\'intervallo [a, b] in N sotto-intervalli di ampiezza Δx = (b-a)/N.'
          ..latexEquation = r"a = x_0 < x_1 < x_2 < \dots < x_N = b, \quad \Delta x_i = x_i - x_{i-1}"
          ..insight = 'Discretizza il dominio per approssimare l\'area con strisce rettangolari verticali.',
        ProofStep()
          ..description =
              'Somma inferiore s(P) e somma superiore S(P) di Darboux-Riemann.'
          ..latexEquation = r"s(P) = \sum_{i=1}^N \inf_{[x_{i-1}, x_i]} f(x) \Delta x_i, \quad S(P) = \sum_{i=1}^N \sup_{[x_{i-1}, x_i]} f(x) \Delta x_i"
          ..insight = 'L\'area esatta è sempre racchiusa tra l\'area a gradini per difetto e quella per eccesso.',
        ProofStep()
          ..description = 'Definizione di funzione Riemann-integrabile quando sup s(P) = inf S(P).'
          ..latexEquation = r"\lim_{N \to \infty} \sum_{i=1}^N f(\xi_i) \Delta x = \int_a^b f(x) dx"
          ..insight = 'Al tendere di N all\'infinito, le somme approssimanti convergono all\'integrale definito di Riemann.',
        ProofStep()
          ..description = 'Corollario: Linearità dell\'Integrale e Additività rispetto all\'Intervallo.'
          ..latexEquation = r"\int_a^b [\alpha f + \beta g] dx = \alpha \int_a^b f dx + \beta \int_a^b g dx \quad \land \quad \int_a^b f dx = \int_a^c f dx + \int_c^b f dx"
          ..insight = 'L\'integrazione è un operatore lineare che preserva la sovrapposizione degli effetti fisici.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'riemann_sum'
        ..parameters = []);
  }

  /// 6. Teorema Fondamentale del Calcolo Integrale (Torricelli-Barrow)
  static KnowledgeNode _createFundamentalTheoremOfCalculusNode() {
    return KnowledgeNode()
      ..serverId = 'mat_fund_calc_01'
      ..title = 'Teorema Fondamentale del Calcolo (Torricelli-Barrow)'
      ..category = 'Matematica'
      ..subCategory = 'Calcolo Integrale'
      ..lastUpdated = DateTime.now()
      ..blocks = [
        ContentBlock()
          ..type = 'text_markdown'
          ..content = r"""### Il Ponte tra Differenziazione e Integrazione

Il **Teorema Fondamentale del Calcolo Integrale** (noto anche come Teorema di Torricelli-Barrow) stabilisce l'incredibile connessione biunivoca tra due branche apparentemente distinte:
- Il problema della **tangente** (velocità e derivate)
- Il problema dell'**area** (accumulazione e integrali)

Se $f(t)$ è continua in $[a, b]$, allora la funzione integrale definita da $F(x) = \int_a^x f(t) dt$ è derivabile e la sua derivata è la funzione integranda stessa:""",
        ContentBlock()
          ..type = 'math_latex'
          ..content =
              r"F'(x) = \frac{d}{dx} \left[ \int_a^x f(t) dt \right] = f(x)",
        ContentBlock()
          ..type = 'info_box'
          ..content = r"""Grazie alla **Formula di Barrow**, ogni integrale definito può essere calcolato tramite una qualsiasi primitiva $G(x)$: $\int_a^b f(x)dx = G(b) - G(a)$. Non è più necessario calcolare somme infinite di rettangoli!""",
      ]
      ..algebraicProof = [
        ProofStep()
          ..description = 'Definizione della funzione integrale F(x) con punto iniziale a fissato.'
          ..latexEquation = r"F(x) = \int_a^x f(t) dt \quad (x \in [a, b])"
          ..insight = 'Misura l\'area netta accumulata sotto la curva f(t) dal punto iniziale a fino alla coordinata mobile x.',
        ProofStep()
          ..description = 'Calcolo del rapporto incrementale di F(x) applicando l\'additività degli intervalli.'
          ..latexEquation = r"\frac{F(x+h) - F(x)}{h} = \frac{1}{h} \left[ \int_a^{x+h} f(t)dt - \int_a^x f(t)dt \right] = \frac{1}{h} \int_x^{x+h} f(t)dt"
          ..insight = 'Isola l\'area della stretta striscia di larghezza h compresa tra x e x+h.',
        ProofStep()
          ..description = 'Applicazione del Teorema della Media Integrale: esiste c_h tra x e x+h tale che (1/h) * ∫ = f(c_h).'
          ..latexEquation = r"F'(x) = \lim_{h \to 0} \frac{F(x+h) - F(x)}{h} = \lim_{h \to 0} f(c_h) = f(x)"
          ..insight = 'La derivata della funzione integrale è esattamente la funzione integranda: F\'(x) = f(x)!',
        ProofStep()
          ..description =
              'Corollario: Formula di Barrow e Integrazione per Parti.'
          ..latexEquation = r"\int_a^b f(x) dx = G(b) - G(a) \quad \land \quad \int u v' dx = u v - \int u' v dx"
          ..insight = 'Unifica differenziazione e integrazione come operazioni inverse; calcola qualsiasi area tramite le primitive.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'riemann_sum'
        ..parameters = []);
  }
}
