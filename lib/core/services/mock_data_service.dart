import 'package:isar/isar.dart';

import '../../domain/models/knowledge_node.dart';

class MockDataService {
  static Future<void> populateDatabase(Isar isar) async {
    final existingCount = await isar.knowledgeNodes.count();

    if (existingCount == 0) {
      final ohmNode = _createOhmNode();
      final powerNode = _createPowerNode();
      final jouleNode = _createJouleNode();

      await isar.writeTxn(() async {
        await isar.knowledgeNodes.putAll([ohmNode, powerNode, jouleNode]);
        powerNode.prerequisites.add(ohmNode);
        await powerNode.prerequisites.save();
        jouleNode.prerequisites.add(powerNode);
        await jouleNode.prerequisites.save();
      });
    } else {
      // Assicura l'esistenza del terzo nodo anche se il database era già stato creato negli step precedenti
      final jouleExists = await isar.knowledgeNodes
          .where()
          .serverIdEqualTo('ele_joule_01')
          .findFirst();

      if (jouleExists == null) {
        final powerNode = await isar.knowledgeNodes
            .where()
            .serverIdEqualTo('ele_power_01')
            .findFirst();

        final jouleNode = _createJouleNode();

        await isar.writeTxn(() async {
          await isar.knowledgeNodes.put(jouleNode);
          if (powerNode != null) {
            jouleNode.prerequisites.add(powerNode);
            await jouleNode.prerequisites.save();
          }
        });
      }
    }
  }

  static KnowledgeNode _createOhmNode() {
    return KnowledgeNode()
      ..serverId = 'ele_ohm_01'
      ..title = 'Legge di Ohm'
      ..category = 'Elettrotecnica'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description =
              'La differenza di potenziale è direttamente proporzionale all\'intensità di corrente.'
          ..latexEquation = r'V = R \cdot I'
          ..insight =
              'La resistenza R rappresenta la costante di proporzionalità caratteristica del conduttore.',
        ProofStep()
          ..description =
              'Formulazione esplicita per determinare la corrente circolante.'
          ..latexEquation = r'I = \frac{V}{R}'
          ..insight =
              'A tensione costante, una resistenza maggiore riduce linearmente il flusso di corrente.',
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
  }

  static KnowledgeNode _createPowerNode() {
    return KnowledgeNode()
      ..serverId = 'ele_power_01'
      ..title = 'Potenza Elettrica'
      ..category = 'Elettrotecnica'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description =
              'Definizione fondamentale di potenza elettrica erogata o assorbita.'
          ..latexEquation = r'P = V \cdot I'
          ..insight =
              'Rappresenta l\'energia elettrica convertita nell\'unità di tempo (Watt).',
        ProofStep()
          ..description =
              'Sostituendo la legge di Ohm (V = R * I) per ottenere la legge di Joule.'
          ..latexEquation = r'P = (R \cdot I) \cdot I = R \cdot I^2'
          ..insight =
              'Mostra la dissipazione termica per effetto Joule dipendente quadraticamente dalla corrente.',
        ProofStep()
          ..description =
              'Espressione in funzione della sola tensione e della resistenza.'
          ..latexEquation = r'P = \frac{V^2}{R}'
          ..insight = 'Utile quando la tensione ai capi del carico è fissa.',
      ];
  }

  static KnowledgeNode _createJouleNode() {
    return KnowledgeNode()
      ..serverId = 'ele_joule_01'
      ..title = 'Effetto Joule'
      ..category = 'Elettrotecnica'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description =
              'L\'energia termica dissipata (Calore Q) per effetto Joule è pari alla potenza istantanea moltiplicata per il tempo.'
          ..latexEquation = r'Q = P \cdot t'
          ..insight =
              'Descrive la conversione irreversibile dell\'energia cinetica dei portatori di carica in agitazione termica nel reticolo cristallino.',
        ProofStep()
          ..description =
              'Sostituendo la formula della potenza in funzione della resistenza e della corrente (P = R * I^2).'
          ..latexEquation = r'Q = R \cdot I^2 \cdot t'
          ..insight =
              'La quantità di calore generata aumenta quadraticamente rispetto all\'intensità della corrente.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'live_equation'
        ..equations = ['R * I * I']
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
  }
}
