import 'package:isar/isar.dart';

import '../../domain/models/knowledge_node.dart';

class MockDataService {
  static Future<void> populateDatabase(Isar isar) async {
    final existingCount = await isar.knowledgeNodes.count();
    if (existingCount > 0) {
      return;
    }

    final ohmNode = KnowledgeNode()
      ..serverId = 'ele_ohm_01'
      ..title = 'Legge di Ohm'
      ..category = 'Elettrotecnica'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description = 'La differenza di potenziale è direttamente proporzionale all\'intensità di corrente.'
          ..latexEquation = r'V = R \cdot I'
          ..insight = 'La resistenza R rappresenta la costante di proporzionalità caratteristica del conduttore.',
        ProofStep()
          ..description = 'Formulazione esplicita per determinare la corrente circolante.'
          ..latexEquation = r'I = \frac{V}{R}'
          ..insight = 'A tensione costante, una resistenza maggiore riduce linearmente il flusso di corrente.',
        ProofStep()
          ..description = 'Definizione operativa di resistenza elettrica.'
          ..latexEquation = r'R = \frac{V}{I}'
          ..insight = 'Unità di misura: 1 Ohm = 1 Volt / 1 Ampere.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'live_equation'
        ..equations = ['R * I']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'R'
            ..label = 'Resistenza (Ω)'
            ..minValue = 1.0
            ..maxValue = 100.0
            ..defaultValue = 10.0
            ..stepSize = 1.0,
          InteractiveParameter()
            ..variableName = 'I'
            ..label = 'Corrente (A)'
            ..minValue = 0.0
            ..maxValue = 10.0
            ..defaultValue = 2.0
            ..stepSize = 0.5,
        ]);

    final powerNode = KnowledgeNode()
      ..serverId = 'ele_power_01'
      ..title = 'Potenza Elettrica'
      ..category = 'Elettrotecnica'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description = 'Definizione fondamentale di potenza elettrica erogata o assorbita.'
          ..latexEquation = r'P = V \cdot I'
          ..insight = 'Rappresenta l\'energia elettrica convertita nell\'unità di tempo (Watt).',
        ProofStep()
          ..description = 'Sostituendo la legge di Ohm (V = R * I) per ottenere la legge di Joule.'
          ..latexEquation = r'P = (R \cdot I) \cdot I = R \cdot I^2'
          ..insight = 'Mostra la dissipazione termica per effetto Joule dipendente quadraticamente dalla corrente.',
        ProofStep()
          ..description = 'Espressione in funzione della sola tensione e della resistenza.'
          ..latexEquation = r'P = \frac{V^2}{R}'
          ..insight = 'Utile quando la tensione ai capi del carico è fissa.',
      ];

    await isar.writeTxn(() async {
      await isar.knowledgeNodes.putAll([ohmNode, powerNode]);
      powerNode.prerequisites.add(ohmNode);
      await powerNode.prerequisites.save();
    });
  }
}
