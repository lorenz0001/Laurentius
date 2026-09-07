import '../../domain/models/knowledge_node.dart';
import 'curriculum_registry.dart';

/// Catalogo compatto di fallback per i fondamenti dell'Aritmetica.
/// Il contenuto didattico completo è memorizzato in `assets/content/arithmetic/`.
class ArithmeticCatalog {
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
        serverId: 'mat_add_01',
        title: 'Addizione e Struttura Algebrica',
        category: 'Matematica',
        subCategory: 'Aritmetica e Fondamenti',
        interactiveData: InteractiveData()
          ..templateType = 'live_equation'
          ..equations = ['a + b']
          ..parameters = [
            _param('a', 'Primo Addendo (a)', min: -20.0, max: 20.0, def: 5.0, step: 1.0),
            _param('b', 'Secondo Addendo (b)', min: -20.0, max: 20.0, def: 7.0, step: 1.0),
          ],
        corollary: "Unicità dell'opposto e definizione rigorosa di sottrazione.",
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_mul_01',
        title: 'Moltiplicazione e Proprietà Distributiva',
        category: 'Matematica',
        subCategory: 'Aritmetica e Fondamenti',
        interactiveData: InteractiveData()
          ..templateType = 'live_equation'
          ..equations = ['a * b']
          ..parameters = [
            _param('a', 'Primo Fattore (a)', min: -10.0, max: 10.0, def: 3.0, step: 1.0),
            _param('b', 'Secondo Fattore (b)', min: -10.0, max: 10.0, def: 4.0, step: 1.0),
          ],
        corollary: "Legge di annullamento del prodotto ed elemento assorbente zero.",
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_frac_01',
        title: 'Frazioni, Rapporti e Numeri Razionali',
        category: 'Matematica',
        subCategory: 'Frazioni e Rapporti',
        interactiveData: InteractiveData()
          ..templateType = 'live_equation'
          ..equations = ['a / b']
          ..parameters = [
            _param('a', 'Numeratore (a)', min: -20.0, max: 20.0, def: 6.0, step: 1.0),
            _param('b', 'Denominatore (b)', min: 1.0, max: 20.0, def: 2.0, step: 1.0),
          ],
        corollary: "Densità dei razionali e impossibilità della divisione per zero.",
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_pow_01',
        title: 'Potenze, Radici ed Esponenti Reali',
        category: 'Matematica',
        subCategory: 'Potenze e Radicali',
        interactiveData: InteractiveData()
          ..templateType = 'live_equation'
          ..equations = ['pow(a, b)']
          ..parameters = [
            _param('a', 'Base (a)', min: 0.5, max: 10.0, def: 2.0, step: 0.5),
            _param('b', 'Esponente (b)', min: -3.0, max: 5.0, def: 3.0, step: 1.0),
          ],
        corollary: "Esponenti frazionari ed equivalenza con i radicali algebrici.",
      ),
    ];
  }
}
