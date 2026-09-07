import '../../domain/models/knowledge_node.dart';
import 'curriculum_registry.dart';

/// Catalogo compatto di fallback per i fondamenti dell'Algebra.
/// Il contenuto didattico completo è memorizzato in `assets/content/algebra/`.
class AlgebraCatalog {
  static List<KnowledgeNode> getAllNodes() {
    return [
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_binom_01',
        title: 'Prodotti Notevoli e Scomposizioni',
        category: 'Matematica',
        subCategory: 'Polinomi e Prodotti Notevoli',
        interactiveData: InteractiveData()
          ..templateType = 'live_equation'
          ..equations = ['a * a + 2 * a * b + b * b'],
        corollary: 'Differenza di quadrati e scomposizione in fattori irriducibili.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_quad_eq_01',
        title: 'Equazioni di Secondo Grado e Discriminante',
        category: 'Matematica',
        subCategory: 'Equazioni di Secondo Grado',
        interactiveData: InteractiveData()
          ..templateType = 'function_graph'
          ..equations = ['a * x * x + b * x + c'],
        corollary: 'Relazioni radici-coefficienti di Viète e fattorizzazione del trinomio.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_parabola_01',
        title: 'Funzione Quadratica e Parabola',
        category: 'Matematica',
        subCategory: 'Funzioni e Geometria Analitica',
        interactiveData: InteractiveData()
          ..templateType = 'function_graph'
          ..equations = ['a * x * x + b * x + c'],
        corollary: 'Proprietà focale della parabola e tangenti dal vertice.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_log_01',
        title: 'Logaritmi ed Esponenziali',
        category: 'Matematica',
        subCategory: 'Funzioni Esponenziali e Logaritmiche',
        interactiveData: InteractiveData()
          ..templateType = 'live_equation'
          ..equations = ['log(x) / log(b)'],
        corollary: 'Formula del cambio di base e convergenza della scala logaritmica.',
      ),
    ];
  }
}
