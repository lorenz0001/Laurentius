import '../../domain/models/knowledge_node.dart';
import 'curriculum_registry.dart';

/// Catalogo compatto di fallback per i fondamenti dell'Algebra.
/// Il contenuto didattico completo è memorizzato in `assets/content/algebra/`.
class AlgebraCatalog {
  static InteractiveParameter _param(
    String name,
    String label, {
    required double min,
    required double max,
    required double def,
    required double step,
    String unit = '',
  }) {
    return InteractiveParameter()
      ..variableName = name
      ..label = label
      ..unit = unit
      ..minValue = min
      ..maxValue = max
      ..defaultValue = def
      ..stepSize = step;
  }

  static List<KnowledgeNode> getAllNodes() {
    return [
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_binom_01',
        title: 'Prodotti Notevoli e Scomposizioni',
        category: 'Matematica',
        subCategory: 'Polinomi e Prodotti Notevoli',
        interactiveData: InteractiveData()
          ..templateType = 'live_equation'
          ..equations = ['a * a + 2 * a * b + b * b']
          ..parameters = [
            _param('a', 'Termine a', min: -5.0, max: 5.0, def: 2.0, step: 0.5),
            _param('b', 'Termine b', min: -5.0, max: 5.0, def: 3.0, step: 0.5),
          ],
        corollary: 'Differenza di quadrati e scomposizione in fattori irriducibili.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_quad_monomia_01',
        title: 'Equazioni di Secondo Grado Monomie',
        category: 'Matematica',
        subCategory: 'Equazioni di Secondo Grado',
        interactiveData: InteractiveData()
          ..templateType = 'function_graph'
          ..equations = ['a * x * x']
          ..parameters = [
            _param('a', 'Coeff. a', min: -3.0, max: 3.0, def: 1.0, step: 0.5),
          ],
        corollary: 'Due soluzioni reali coincidenti nulle e tangenza della parabola nell\'origine.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_quad_pura_01',
        title: 'Equazioni di Secondo Grado Pure',
        category: 'Matematica',
        subCategory: 'Equazioni di Secondo Grado',
        interactiveData: InteractiveData()
          ..templateType = 'function_graph'
          ..equations = ['a * x * x + c']
          ..parameters = [
            _param('a', 'Coeff. a', min: -3.0, max: 3.0, def: 1.0, step: 0.5),
            _param('c', 'Termine c', min: -9.0, max: 9.0, def: -4.0, step: 0.5),
          ],
        corollary: 'Simmetria assiale delle radici opposte e traslazione verticale del vertice.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_quad_spuria_01',
        title: 'Equazioni di Secondo Grado Spurie',
        category: 'Matematica',
        subCategory: 'Equazioni di Secondo Grado',
        interactiveData: InteractiveData()
          ..templateType = 'function_graph'
          ..equations = ['a * x * x + b * x']
          ..parameters = [
            _param('a', 'Coeff. a', min: -3.0, max: 3.0, def: 1.0, step: 0.5),
            _param('b', 'Coeff. b', min: -6.0, max: 6.0, def: -2.0, step: 0.5),
          ],
        corollary: 'Esistenza di due radici distinte con passaggio obbligato della parabola per l\'origine.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_quad_eq_01',
        title: 'Equazione di Secondo Grado Completa & Formula Risolutiva',
        category: 'Matematica',
        subCategory: 'Equazioni di Secondo Grado',
        interactiveData: InteractiveData()
          ..templateType = 'completing_square'
          ..equations = ['a * x * x + b * x + c']
          ..parameters = [
            _param('a', 'Coeff. a', min: 0.5, max: 3.0, def: 1.0, step: 0.5),
            _param('b', 'Coeff. b', min: 1.0, max: 8.0, def: 4.0, step: 0.5),
            _param('c', 'Coeff. c', min: -8.0, max: 4.0, def: -5.0, step: 0.5),
          ],
        corollary: 'Formula quadratica generale, formula ridotta per b pari e geometria del discriminante.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_quad_viete_01',
        title: 'Relazioni di Viète, Scomposizione e Regola di Cartesio',
        category: 'Matematica',
        subCategory: 'Equazioni di Secondo Grado',
        interactiveData: InteractiveData()
          ..templateType = 'live_equation'
          ..equations = ['-b / a']
          ..parameters = [
            _param('a', 'Coeff. a', min: -5.0, max: 5.0, def: 1.0, step: 0.5),
            _param('b', 'Coeff. b', min: -10.0, max: 10.0, def: -5.0, step: 0.5),
            _param('c', 'Coeff. c', min: -10.0, max: 10.0, def: 6.0, step: 0.5),
          ],
        corollary: 'Scomposizione in fattori lineari del trinomio e deduzione dei segni con Cartesio.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_parabola_01',
        title: 'Funzione Quadratica e Parabola',
        category: 'Matematica',
        subCategory: 'Funzioni e Geometria Analitica',
        interactiveData: InteractiveData()
          ..templateType = 'function_graph'
          ..equations = ['a * x * x + b * x + c']
          ..parameters = [
            _param('a', 'Coeff. a', min: -3.0, max: 3.0, def: 1.0, step: 0.5),
            _param('b', 'Coeff. b', min: -6.0, max: 6.0, def: 0.0, step: 0.5),
            _param('c', 'Coeff. c', min: -6.0, max: 6.0, def: -2.0, step: 0.5),
          ],
        corollary: 'Proprietà focale della parabola e tangenti dal vertice.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_log_01',
        title: 'Logaritmi ed Esponenziali',
        category: 'Matematica',
        subCategory: 'Funzioni Esponenziali e Logaritmiche',
        interactiveData: InteractiveData()
          ..templateType = 'live_equation'
          ..equations = ['log(x) / log(b)']
          ..parameters = [
            _param('x', 'Argomento (x)', min: 0.1, max: 100.0, def: 8.0, step: 0.5),
            _param('b', 'Base del Logaritmo (b)', min: 2.0, max: 10.0, def: 2.0, step: 1.0),
          ],
        corollary: 'Formula del cambio di base e convergenza della scala logaritmica.',
      ),
    ];
  }
}
