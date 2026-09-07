import '../../domain/models/knowledge_node.dart';
import 'curriculum_registry.dart';

/// Catalogo compatto di fallback per i fondamenti dell'Aritmetica.
/// Il contenuto didattico completo è memorizzato in `assets/content/arithmetic/`.
class ArithmeticCatalog {
  static List<KnowledgeNode> getAllNodes() {
    return [
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_add_01',
        title: 'Addizione e Struttura Algebrica',
        category: 'Matematica',
        subCategory: 'Aritmetica e Fondamenti',
        interactiveData: InteractiveData()
          ..templateType = 'live_equation'
          ..equations = ['a + b'],
        corollary: "Unicità dell'opposto e definizione rigorosa di sottrazione.",
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_mul_01',
        title: 'Moltiplicazione e Proprietà Distributiva',
        category: 'Matematica',
        subCategory: 'Aritmetica e Fondamenti',
        interactiveData: InteractiveData()
          ..templateType = 'live_equation'
          ..equations = ['a * b'],
        corollary: "Legge di annullamento del prodotto ed elemento assorbente zero.",
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_frac_01',
        title: 'Frazioni, Rapporti e Numeri Razionali',
        category: 'Matematica',
        subCategory: 'Frazioni e Rapporti',
        interactiveData: InteractiveData()
          ..templateType = 'live_equation'
          ..equations = ['a / b'],
        corollary: "Densità dei razionali e impossibilità della divisione per zero.",
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_pow_01',
        title: 'Potenze, Radici ed Esponenti Reali',
        category: 'Matematica',
        subCategory: 'Potenze e Radicali',
        interactiveData: InteractiveData()
          ..templateType = 'live_equation'
          ..equations = ['pow(a, b)'],
        corollary: "Esponenti frazionari ed equivalenza con i radicali algebrici.",
      ),
    ];
  }
}
