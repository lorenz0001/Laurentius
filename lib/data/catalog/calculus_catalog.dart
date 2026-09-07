import '../../domain/models/knowledge_node.dart';
import 'curriculum_registry.dart';

/// Catalogo compatto di fallback per il Calcolo Differenziale e Integrale.
/// Il contenuto didattico completo è memorizzato in `assets/content/calculus/`.
class CalculusCatalog {
  static List<KnowledgeNode> getAllNodes() {
    return [
      CurriculumRegistry.createFallbackNode(
        serverId: 'mat_limits_01',
        title: 'Limiti di Funzione e Limiti Notevoli',
        category: 'Matematica',
        subCategory: 'Limiti e Continuità',
        interactiveData: InteractiveData()
          ..templateType = 'function_graph'
          ..equations = ['sin(k * x) / x'],
        corollary: 'Limiti notevoli goniometrici ed esponenziali fondamentali.',
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
    ];
  }
}
