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
      ..category = 'Analisi Matematica'
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
          ..description = 'Corollario: Limiti Notevoli Goniometrici ed Esponenziali.'
          ..latexEquation = r"\lim_{x \to 0} \frac{1 - \cos x}{x^2} = \frac{1}{2} \quad \land \quad \lim_{x \to 0} \frac{e^x - 1}{x} = 1"
          ..insight = 'Derivati per sostituzione e moltiplicazione per (1+cos x); fondamentali per calcolare le derivate prime.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['sin(x) / x']
        ..parameters = []);
  }

  /// 2. Rapporto Incrementale e Derivata
  static KnowledgeNode _createDerivativeDefinitionNode() {
    return KnowledgeNode()
      ..serverId = 'mat_deriv_def_01'
      ..title = 'Rapporto Incrementale e Definizione di Derivata'
      ..category = 'Analisi Matematica'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description = 'Definizione di rapporto incrementale: pendenza della retta secante passante per P(x₀, f(x₀)) e Q(x₀+h, f(x₀+h)).'
          ..latexEquation = r"\frac{\Delta y}{\Delta x} = \frac{f(x_0 + h) - f(x_0)}{h}"
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
      ..category = 'Analisi Matematica'
      ..lastUpdated = DateTime.now()
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
      ..category = 'Analisi Matematica'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description = 'Teorema di Fermat sui punti estremanti interni: se x₀ è punto di massimo o minimo locale e f è derivabile.'
          ..latexEquation = r"\frac{f(x_0+h)-f(x_0)}{h} \le 0 \text{ per } h>0 \quad \land \quad \ge 0 \text{ per } h<0 \implies f'(x_0) = 0"
          ..insight = 'Nei punti di massimo o minimo la retta tangente alla funzione deve essere orizzontale.',
        ProofStep()
          ..description = 'Teorema di Rolle: funzione continua in [a, b], derivabile in (a, b) con f(a) = f(b).'
          ..latexEquation = r"f(a) = f(b) \implies \exists c \in (a, b) : f'(c) = 0"
          ..insight = 'Se gli estremi coincidono, la funzione deve avere almeno un punto a derivata nulla.',
        ProofStep()
          ..description = 'Teorema del Valor Medio di Lagrange: applicazione di Rolle alla retta secante g(x) = f(x) - [(f(b)-f(a))/(b-a)](x-a).'
          ..latexEquation = r"\exists c \in (a, b) : f'(c) = \frac{f(b) - f(a)}{b - a}"
          ..insight = 'Esiste almeno un punto interno c in cui la retta tangente è perfettamente parallela alla retta secante passante per gli estremi.',
        ProofStep()
          ..description = 'Corollario: Criterio di Monotonia e Caratterizzazione delle Costanti.'
          ..latexEquation = r"f'(x) \ge 0 \iff f(x) \text{ crescente} \quad \land \quad (f'(x) = 0 \implies f(x) = C)"
          ..insight = 'Il segno della derivata governa la crescita della funzione; se la derivata è identicamente nulla, la funzione è costante.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'cartesian_plot'
        ..equations = ['x * x * x / 3 - x']
        ..parameters = []);
  }

  /// 5. Integrale di Riemann e Somme di Rettangoli
  static KnowledgeNode _createRiemannIntegralNode() {
    return KnowledgeNode()
      ..serverId = 'mat_riemann_01'
      ..title = 'Integrale di Riemann e Somme di Rettangoli'
      ..category = 'Analisi Matematica'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description = 'Partizione dell\'intervallo [a, b] in N sotto-intervalli di ampiezza Δx = (b-a)/N.'
          ..latexEquation = r"a = x_0 < x_1 < x_2 < \dots < x_N = b, \quad \Delta x_i = x_i - x_{i-1}"
          ..insight = 'Discretizza il dominio per approssimare l\'area con strisce rettangolari verticali.',
        ProofStep()
          ..description = 'Somma inferiore s(P) e somma superiore S(P) di Darboux-Riemann.'
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
      ..category = 'Analisi Matematica'
      ..lastUpdated = DateTime.now()
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
          ..description = 'Corollario: Formula di Barrow e Integrazione per Parti.'
          ..latexEquation = r"\int_a^b f(x) dx = G(b) - G(a) \quad \land \quad \int u v' dx = u v - \int u' v dx"
          ..insight = 'Unifica differenziazione e integrazione come operazioni inverse; calcola qualsiasi area tramite le primitive.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'riemann_sum'
        ..parameters = []);
  }
}
