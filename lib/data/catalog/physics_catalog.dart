import '../../domain/models/knowledge_node.dart';
import 'curriculum_registry.dart';

/// Catalogo compatto di fallback per le scienze applicate (Fisica, Elettrotecnica, Chimica).
/// Il contenuto didattico completo è memorizzato in `assets/content/physics/`.
class PhysicsCatalog {
  static List<KnowledgeNode> getAllNodes() {
    return [
      _createKinematicsNode(),
      _createOhmNode(),
      _createPowerNode(),
      _createJouleNode(),
      _createPhNode(),
    ];
  }

  static InteractiveParameter _param(
    String name,
    String label,
    String unit, {
    required double min,
    required double max,
    required double def,
    required double step,
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

  static KnowledgeNode _createKinematicsNode() {
    return CurriculumRegistry.createFallbackNode(
      serverId: 'phys_kin_01',
      title: 'Cinematica: Moto Rettilineo e Corollario di Torricelli',
      category: 'Fisica',
      subCategory: 'Cinematica e Dinamica',
      interactiveData: InteractiveData()
        ..templateType = 'kinematics_simulation'
        ..unit = 'm/s'
        ..equations = ['v0 + a * t']
        ..parameters = [
          _param('v0', 'Velocità Iniziale (v₀)', 'm/s',
              min: 0.0, max: 30.0, def: 5.0, step: 1.0),
          _param('a', 'Accelerazione Costante (a)', 'm/s²',
              min: -5.0, max: 10.0, def: 2.0, step: 0.5),
        ],
      corollary: 'Formula Senza Tempo di Torricelli v² = v₀² + 2aΔx.',
    );
  }

  static KnowledgeNode _createOhmNode() {
    return CurriculumRegistry.createFallbackNode(
      serverId: 'ele_ohm_01',
      title: 'Legge di Ohm e Resistenza Elettrica',
      category: 'Elettrotecnica',
      subCategory: 'Circuiti in Corrente Continua',
      interactiveData: InteractiveData()
        ..templateType = 'circuit_simulation'
        ..unit = 'A'
        ..equations = ['V / R']
        ..parameters = [
          _param('V', 'Tensione (Volt)', 'V',
              min: 1.0, max: 24.0, def: 12.0, step: 1.0),
          _param('R', 'Resistenza (Ohm)', 'Ω',
              min: 1.0, max: 50.0, def: 10.0, step: 1.0),
        ],
      corollary: 'Prima Legge di Ohm e Formule Inverse V = R * I.',
    );
  }

  static KnowledgeNode _createPowerNode() {
    return CurriculumRegistry.createFallbackNode(
      serverId: 'ele_power_01',
      title: 'Potenza Elettrica nei Circuiti',
      category: 'Elettrotecnica',
      subCategory: 'Circuiti in Corrente Continua',
      interactiveData: InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'W'
        ..equations = ['V * I']
        ..parameters = [
          _param('V', 'Tensione (V)', 'V',
              min: 1.0, max: 48.0, def: 12.0, step: 1.0),
          _param('I', 'Corrente (A)', 'A',
              min: 0.1, max: 10.0, def: 2.0, step: 0.1),
        ],
      corollary: 'Formule di Potenza per Carichi Resistivi P = R * I² = V² / R.',
    );
  }

  static KnowledgeNode _createJouleNode() {
    return CurriculumRegistry.createFallbackNode(
      serverId: 'ele_joule_01',
      title: 'Effetto Joule e Dissipazione Termica',
      category: 'Elettrotecnica',
      subCategory: 'Termodinamica & Circuiti',
      interactiveData: InteractiveData()
        ..templateType = 'live_equation'
        ..unit = 'J'
        ..equations = ['R * I * I * t']
        ..parameters = [
          _param('R', 'Resistenza (Ohm)', 'Ω',
              min: 1.0, max: 20.0, def: 5.0, step: 1.0),
          _param('I', 'Corrente (A)', 'A',
              min: 0.5, max: 5.0, def: 2.0, step: 0.5),
          _param('t', 'Tempo (s)', 's',
              min: 1.0, max: 60.0, def: 10.0, step: 1.0),
        ],
      corollary:
          'Equivalente Meccanico del Calore e Calcolo in Calorie Q = R * I² * t.',
    );
  }

  static KnowledgeNode _createPhNode() {
    return CurriculumRegistry.createFallbackNode(
      serverId: 'chem_ph_01',
      title: 'Chimica Fisica: Soluzioni Acido-Base e Calcolo del pH',
      category: 'Fisica',
      subCategory: 'Chimica Fisica',
      interactiveData: InteractiveData()
        ..templateType = 'live_equation'
        ..unit = ''
        ..equations = ['-log(c) / 2.302585']
        ..parameters = [
          _param('c', '[H⁺] Concentrazione Molare', 'mol/L',
              min: 0.0000001, max: 0.1, def: 0.001, step: 0.001),
        ],
      corollary: 'Relazione Fondamentale pH + pOH = 14.',
    );
  }
}
