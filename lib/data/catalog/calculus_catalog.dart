import '../../domain/models/knowledge_node.dart';
import 'curriculum_registry.dart';

/// Catalogo compatto di fallback per il Calcolo Differenziale e Integrale.
/// Il contenuto didattico completo è memorizzato in `assets/content/calculus/`.
class CalculusCatalog {
  static List<KnowledgeNode> getAllNodes() {
    return [
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_limits_01',
        title: 'Definizione Rigorosa di Limite e Continuità (Epsilon-Delta)',
        category: 'Matematica',
        subCategory: 'Limiti e Continuità',
        interactiveData: InteractiveData()
          ..templateType = 'function_graph'
          ..equations = ['2 * x + 1']
          ..parameters = [
            InteractiveParameter()
              ..variableName = 'L'
              ..label = 'Valore Limite Atteso (L)'
              ..unit = ''
              ..minValue = 1.0
              ..maxValue = 10.0
              ..defaultValue = 7.0
              ..stepSize = 1.0,
            InteractiveParameter()
              ..variableName = 'eps'
              ..label = 'Tolleranza Epsilon (ε)'
              ..unit = ''
              ..minValue = 0.1
              ..maxValue = 2.0
              ..defaultValue = 0.5
              ..stepSize = 0.1,
            InteractiveParameter()
              ..variableName = 'x0'
              ..label = 'Punto di Accumulazione (x₀)'
              ..unit = ''
              ..minValue = 0.0
              ..maxValue = 5.0
              ..defaultValue = 3.0
              ..stepSize = 0.5,
          ],
        corollary: 'Teorema di unicità del limite e definizione topologica di continuità.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_lim_sinc_01',
        title: 'Limite Notevole del Seno: sin(x)/x e Teorema dei Carabinieri',
        category: 'Matematica',
        subCategory: 'Limiti e Continuità',
        interactiveData: InteractiveData()
          ..templateType = 'squeeze_theorem'
          ..equations = ['sin(k * x) / x']
          ..parameters = [
            InteractiveParameter()
              ..variableName = 'k'
              ..label = 'Fattore di Frequenza Angolare (k)'
              ..unit = ''
              ..minValue = 0.5
              ..maxValue = 3.0
              ..defaultValue = 1.0
              ..stepSize = 0.5,
            InteractiveParameter()
              ..variableName = 'delta'
              ..label = 'Ampiezza Intorno Delta'
              ..unit = ''
              ..minValue = 0.05
              ..maxValue = 1.5
              ..defaultValue = 0.8
              ..stepSize = 0.05,
          ],
        corollary: 'Limite notevole della tangente tan(x)/x = 1 e frequenza angolare k.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_lim_cos_01',
        title: 'Limite Notevole del Coseno: (1 - cos x)/x² e Curvatura Locale',
        category: 'Matematica',
        subCategory: 'Limiti e Continuità',
        interactiveData: InteractiveData()
          ..templateType = 'function_graph'
          ..equations = ['(1 - cos(x)) / (x * x)']
          ..parameters = [
            InteractiveParameter()
              ..variableName = 'a'
              ..label = 'Fattore di Curvatura Parabolica'
              ..unit = ''
              ..minValue = 0.2
              ..maxValue = 2.0
              ..defaultValue = 1.0
              ..stepSize = 0.1,
          ],
        corollary: 'Sviluppo di Taylor del coseno cos(x) = 1 - x²/2 + o(x²) e annullamento del limite del primo ordine.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_lim_e_01',
        title: 'Il Limite Fondamentale del Numero di Eulero e la Crescita Esponenziale',
        category: 'Matematica',
        subCategory: 'Limiti e Continuità',
        interactiveData: InteractiveData()
          ..templateType = 'function_graph'
          ..equations = ['(1 + 1 / x)^x']
          ..parameters = [
            InteractiveParameter()
              ..variableName = 'n'
              ..label = 'Frequenza di Capitalizzazione (n)'
              ..unit = ''
              ..minValue = 1.0
              ..maxValue = 50.0
              ..defaultValue = 10.0
              ..stepSize = 1.0,
          ],
        corollary: 'Forma equivalente nell’origine (1+t)^(1/t) = e e generalizzazione a esponente k.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_lim_exp_01',
        title: 'Limite Notevole dell\'Esponenziale: (e^x - 1)/x e Derivata Naturale',
        category: 'Matematica',
        subCategory: 'Limiti e Continuità',
        interactiveData: InteractiveData()
          ..templateType = 'function_graph'
          ..equations = ['(2.71828^x - 1) / x']
          ..parameters = [
            InteractiveParameter()
              ..variableName = 'a'
              ..label = 'Base dell\'Esponenziale a'
              ..unit = ''
              ..minValue = 1.5
              ..maxValue = 4.0
              ..defaultValue = 2.72
              ..stepSize = 0.1,
          ],
        corollary: 'Limite esponenziale a base generica (a^x - 1)/x = ln(a) e derivata naturale di e^x.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_lim_log_01',
        title: 'Limite Notevole del Logaritmo: ln(1+x)/x e Linearizzazione',
        category: 'Matematica',
        subCategory: 'Limiti e Continuità',
        interactiveData: InteractiveData()
          ..templateType = 'function_graph'
          ..equations = ['ln(1 + x) / x']
          ..parameters = [
            InteractiveParameter()
              ..variableName = 'k'
              ..label = 'Fattore di Scala Lineare (k)'
              ..unit = ''
              ..minValue = 0.5
              ..maxValue = 3.0
              ..defaultValue = 1.0
              ..stepSize = 0.5,
          ],
        corollary: 'Limite logaritmico a base generica log_a(1+x)/x = 1/ln(a) e derivata del logaritmo.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_deriv_def_01',
        title: 'Rapporto Incrementale e Definizione di Derivata',
        category: 'Matematica',
        subCategory: 'Calcolo Differenziale',
        interactiveData: InteractiveData()..templateType = 'derivative_tangent',
        corollary: 'Differenziabilità e derivata delle potenze reali x^n.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_deriv_rules_01',
        title: 'Regole di Derivazione: Prodotto, Quoziente e Catena',
        category: 'Matematica',
        subCategory: 'Calcolo Differenziale',
        interactiveData: InteractiveData()..templateType = 'derivative_tangent',
        corollary: 'Derivata delle funzioni composte e della funzione inversa.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_deriv_theorems_01',
        title: 'Teoremi di Rolle, Lagrange e Criterio di Monotonia',
        category: 'Matematica',
        subCategory: 'Teoremi Differenziali',
        interactiveData: InteractiveData()
          ..templateType = 'rolle_lagrange'
          ..equations = ['x * x * x / 3 - x'],
        corollary: 'Criterio di monotonia e test della derivata seconda per i punti di flesso.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_riemann_01',
        title: 'Integrale di Riemann e Somme di Rettangoli',
        category: 'Matematica',
        subCategory: 'Calcolo Integrale',
        interactiveData: InteractiveData()..templateType = 'riemann_sum',
        corollary: 'Teorema della media integrale e convergenza uniforme delle somme superiori e inferiori.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_fund_calc_01',
        title: 'Teorema Fondamentale del Calcolo (Torricelli-Barrow)',
        category: 'Matematica',
        subCategory: 'Calcolo Integrale',
        interactiveData: InteractiveData()..templateType = 'riemann_sum',
        corollary: 'Formula fondamentale di Torricelli-Barrow per il calcolo delle aree tramite primitiva.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_integ_parts_01',
        title: 'Integrazione per Parti',
        category: 'Matematica',
        subCategory: 'Calcolo Integrale',
        interactiveData: InteractiveData()
          ..templateType = 'function_graph'
          ..equations = ['x * exp(x)']
          ..parameters = [
            InteractiveParameter()
              ..variableName = 'a'
              ..label = 'Scala'
              ..minValue = 0.5
              ..maxValue = 2.0
              ..defaultValue = 1.0
              ..stepSize = 0.1,
          ],
        corollary: 'Regola di Leibniz integrata, criterio LIATE e risoluzione di integrali ciclici.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_integ_subst_01',
        title: 'Integrazione per Sostituzione e Integrali Quasi-Immediati',
        category: 'Matematica',
        subCategory: 'Calcolo Integrale',
        interactiveData: InteractiveData()
          ..templateType = 'function_graph'
          ..equations = ['2 * x / (x * x + 1)']
          ..parameters = [
            InteractiveParameter()
              ..variableName = 'a'
              ..label = 'Coeff. a'
              ..minValue = 0.5
              ..maxValue = 3.0
              ..defaultValue = 1.0
              ..stepSize = 0.5,
          ],
        corollary: 'Cambio di variabile negli integrali definiti e famiglia delle derivate fratte logaritmiche.',
      ),
    ];
  }
}
