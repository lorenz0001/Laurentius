import '../../domain/models/knowledge_node.dart';
import 'curriculum_registry.dart';

/// Catalogo compatto di fallback per Geometria Euclidea e Trigonometria.
/// Il contenuto didattico completo è memorizzato in `assets/content/geometry_trig/`.
class GeometryTrigCatalog {
  static List<KnowledgeNode> getAllNodes() {
    return [
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_triang_01',
        title: 'Geometria del Triangolo e Angoli Interni',
        category: 'Matematica',
        subCategory: 'Geometria Euclidea Piana',
        interactiveData: InteractiveData()..templateType = 'triangle_solver',
        corollary: "Teorema dell'angolo esterno ed equiscomponibilità dei poligoni.",
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_pythagoras_01',
        title: 'Teorema di Pitagora ed Euclide',
        category: 'Matematica',
        subCategory: 'Geometria Euclidea Piana',
        interactiveData: InteractiveData()..templateType = 'triangle_solver',
        corollary: "Incommensurabilità della diagonale del quadrato e numeri irrazionali.",
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_trig_circ_01',
        title: 'Circonferenza Goniometrica e Relazione Fondamentale',
        category: 'Matematica',
        subCategory: 'Goniometria Fondamentale',
        interactiveData: InteractiveData()..templateType = 'trig_circle',
        corollary: "Disuguaglianza notevole tra seno, arco e tangente per x tendente a zero.",
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_trig_add_01',
        title: 'Formule Goniometriche: Addizione, Duplicazione e Bisezione',
        category: 'Matematica',
        subCategory: 'Goniometria Fondamentale',
        interactiveData: InteractiveData()..templateType = 'trig_circle',
        corollary: "Formule parametriche razionali universali in t = tan(x/2).",
      ),
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_trig_triang_01',
        title: "Teoremi dei Triangoli: Carnot, Seni e Formula dell'Area",
        category: 'Matematica',
        subCategory: 'Trigonometria dei Triangoli',
        interactiveData: InteractiveData()..templateType = 'triangle_solver',
        corollary: "Formula di Erone per l'area del triangolo in funzione del semiperimetro.",
      ),
    ];
  }
}
