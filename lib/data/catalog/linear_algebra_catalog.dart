import '../../domain/models/knowledge_node.dart';
import 'curriculum_registry.dart';

/// Catalogo compatto di fallback per i fondamenti dell'Algebra Lineare.
/// Il contenuto didattico completo è memorizzato in `assets/content/linear_algebra/`.
class LinearAlgebraCatalog {
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
        serverId: 'lin_alg_01_tuples',
        title: 'Spazio Vettoriale Rn e Concetto di n-upla Ordinata',
        category: 'Matematica',
        subCategory: 'Algebra Lineare',
        interactiveData: InteractiveData()
          ..templateType = 'vector_2d'
          ..equations = ['sqrt(x1 * x1 + x2 * x2)']
          ..parameters = [
            _param('x1', 'Coordinata x₁', min: -10.0, max: 10.0, def: 3.0, step: 0.5),
            _param('x2', 'Coordinata x₂', min: -10.0, max: 10.0, def: 4.0, step: 0.5),
          ],
        corollary: 'Norma Euclidea e Disuguaglianza di Cauchy-Schwarz.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'lin_alg_02_vectors',
        title: 'Vettori Geometrici, Norma e Coordinate Canoniche',
        category: 'Matematica',
        subCategory: 'Algebra Lineare',
        interactiveData: InteractiveData()
          ..templateType = 'vector_2d'
          ..equations = ['sqrt(vx * vx + vy * vy)']
          ..parameters = [
            _param('vx', 'Componente vx', min: -10.0, max: 10.0, def: 4.0, step: 0.5),
            _param('vy', 'Componente vy', min: -10.0, max: 10.0, def: 3.0, step: 0.5),
          ],
        corollary: 'Normalizzazione e Versore di un Vettore.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'lin_alg_03_operations',
        title: 'Operazioni Vettoriali Fondamentali e Assiomi di Spazio Vettoriale',
        category: 'Matematica',
        subCategory: 'Algebra Lineare',
        interactiveData: InteractiveData()
          ..templateType = 'vector_addition'
          ..equations = ['v1x + v2x', 'v1y + v2y']
          ..parameters = [
            _param('v1x', 'Vettore v₁ (x)', min: -5.0, max: 5.0, def: 3.0, step: 0.5),
            _param('v1y', 'Vettore v₁ (y)', min: -5.0, max: 5.0, def: 1.0, step: 0.5),
            _param('v2x', 'Vettore v₂ (x)', min: -5.0, max: 5.0, def: 1.0, step: 0.5),
            _param('v2y', 'Vettore v₂ (y)', min: -5.0, max: 5.0, def: 4.0, step: 0.5),
          ],
        corollary: 'Annullamento del Prodotto Scalare-Vettore (0 v = 0).',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'lin_alg_04_span',
        title: 'Combinazioni Lineari e Spazio Vettoriale Generato (Span)',
        category: 'Matematica',
        subCategory: 'Algebra Lineare',
        interactiveData: InteractiveData()
          ..templateType = 'linear_combination'
          ..equations = ['c1 * v1x + c2 * v2x', 'c1 * v1y + c2 * v2y']
          ..parameters = [
            _param('c1', 'Coefficiente c₁', min: -3.0, max: 3.0, def: 2.0, step: 0.1),
            _param('c2', 'Coefficiente c₂', min: -3.0, max: 3.0, def: -1.0, step: 0.1),
            _param('v1x', 'Vettore v₁ (x)', min: -5.0, max: 5.0, def: 2.0, step: 0.5),
            _param('v1y', 'Vettore v₁ (y)', min: -5.0, max: 5.0, def: 1.0, step: 0.5),
            _param('v2x', 'Vettore v₂ (x)', min: -5.0, max: 5.0, def: 0.0, step: 0.5),
            _param('v2y', 'Vettore v₂ (y)', min: -5.0, max: 5.0, def: 2.0, step: 0.5),
          ],
        corollary: 'Minimalità del Sottospazio Generato e Collasso Dimensionale per Vettori Paralleli.',
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'lin_alg_05_independence',
        title: 'Dipendenza e Indipendenza Lineare dei Vettori',
        category: 'Matematica',
        subCategory: 'Algebra Lineare',
        interactiveData: InteractiveData()
          ..templateType = 'span_2d'
          ..equations = ['v1x * v2y - v1y * v2x']
          ..parameters = [
            _param('v1x', 'Vettore v₁ (x)', min: -5.0, max: 5.0, def: 2.0, step: 0.5),
            _param('v1y', 'Vettore v₁ (y)', min: -5.0, max: 5.0, def: 3.0, step: 0.5),
            _param('v2x', 'Vettore v₂ (x)', min: -5.0, max: 5.0, def: -4.0, step: 0.5),
            _param('v2y', 'Vettore v₂ (y)', min: -5.0, max: 5.0, def: -6.0, step: 0.5),
          ],
        corollary: 'Criterio del Determinante 2D e Indipendenza di Due Vettori nel Piano.',
      ),
    ];
  }
}
