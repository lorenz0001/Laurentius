import 'package:isar/isar.dart';

import '../../domain/models/knowledge_node.dart';

/// Servizio per la popolazione iniziale del database locale Isar con dati dimostrativi STEM.
/// Include nodi interdisciplinari (Matematica, Chimica, Elettrotecnica) e nodi sia puramente algebrici
/// che con simulazione fisica interattiva ad animazione continua.
class MockDataService {
  static Future<void> populateDatabase(Isar isar) async {
    final nodesToUpsert = [
      _createLogarithmsNode(),
      _createPhNode(),
      _createOhmNode(),
      _createPowerNode(),
      _createJouleNode(),
    ];

    // Fase 1: Upsert di tutti i nodi (preservando gli ID locali per mantenere le relazioni)
    await isar.writeTxn(() async {
      for (final node in nodesToUpsert) {
        final existing = await isar.knowledgeNodes
            .where()
            .serverIdEqualTo(node.serverId)
            .findFirst();
        if (existing != null) {
          node.id = existing.id;
        }
        await isar.knowledgeNodes.put(node);
      }
    });

    // Fase 2: Salvataggio e collegamento delle dipendenze del grafo (anche interdisciplinari)
    await isar.writeTxn(() async {
      final logNode = await isar.knowledgeNodes.where().serverIdEqualTo('mat_log_01').findFirst();
      final phNode = await isar.knowledgeNodes.where().serverIdEqualTo('chem_ph_01').findFirst();
      final ohmNode = await isar.knowledgeNodes.where().serverIdEqualTo('ele_ohm_01').findFirst();
      final powerNode = await isar.knowledgeNodes.where().serverIdEqualTo('ele_power_01').findFirst();
      final jouleNode = await isar.knowledgeNodes.where().serverIdEqualTo('ele_joule_01').findFirst();

      // Chimica (pH) richiede Matematica (Logaritmi) -> Collegamento Interdisciplinare
      if (phNode != null && logNode != null) {
        await phNode.prerequisites.load();
        if (!phNode.prerequisites.contains(logNode)) {
          phNode.prerequisites.add(logNode);
          await phNode.prerequisites.save();
        }
      }

      // Potenza richiede Legge di Ohm
      if (powerNode != null && ohmNode != null) {
        await powerNode.prerequisites.load();
        if (!powerNode.prerequisites.contains(ohmNode)) {
          powerNode.prerequisites.add(ohmNode);
          await powerNode.prerequisites.save();
        }
      }

      // Effetto Joule richiede Potenza Elettrica
      if (jouleNode != null && powerNode != null) {
        await jouleNode.prerequisites.load();
        if (!jouleNode.prerequisites.contains(powerNode)) {
          jouleNode.prerequisites.add(powerNode);
          await jouleNode.prerequisites.save();
        }
      }
    });
  }

  /// Nodo Matematico: Dimostrazione pura senza animazione fisica superflua
  static KnowledgeNode _createLogarithmsNode() {
    return KnowledgeNode()
      ..serverId = 'mat_log_01'
      ..title = 'Logaritmi ed Esponenziali'
      ..category = 'Matematica'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description =
              'Definizione fondamentale: il logaritmo è l\'esponente da assegnare alla base b per ottenere x.'
          ..latexEquation = r'b^y = x \iff y = \log_b(x)'
          ..insight =
              'Rappresenta l\'operazione inversa della funzione esponenziale per basi positive diverse da 1.',
        ProofStep()
          ..description =
              'Proprietà del prodotto: trasforma la moltiplicazione in una somma su scala logaritmica.'
          ..latexEquation = r'\log_b(x \cdot y) = \log_b(x) + \log_b(y)'
          ..insight =
              'Alla base del funzionamento dei regoli calcolatori e dell\'elaborazione di segnali su ordini di grandezza.',
        ProofStep()
          ..description =
              'Proprietà della potenza: l\'esponente dell\'argomento diventa fattore moltiplicativo.'
          ..latexEquation = r'\log_b(x^k) = k \cdot \log_b(x)'
          ..insight =
              'Fondamentale per la risoluzione di equazioni esponenziali e per la definizione di scale come il pH.',
      ]
      ..interactiveData = null; // Puramente matematico: niente simulazione fisica forzata
  }

  /// Nodo Chimico: Collegato a Matematica (Logaritmi) come prerequisito
  static KnowledgeNode _createPhNode() {
    return KnowledgeNode()
      ..serverId = 'chem_ph_01'
      ..title = 'Calcolo del pH ed Equilibrio Acido-Base'
      ..category = 'Chimica'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description =
              'Definizione di Sørensen: il pH misura la concentrazione idrogenionica in scala logaritmica negativa.'
          ..latexEquation = r'pH = -\log_{10}[H_3O^+]'
          ..insight =
              'Il segno meno fa sì che a concentrazioni ioniche maggiori corrisponda un pH più basso (maggiore acidità).',
        ProofStep()
          ..description =
              'Costante di autoionizzazione dell\'acqua (Kw a 25°C) e relazione col pOH.'
          ..latexEquation = r'K_w = [H^+][OH^-] = 10^{-14} \implies pH + pOH = 14'
          ..insight =
              'In acqua pura le due specie sono in perfetto equilibrio (pH = 7, punto neutro).',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'live_equation'
        ..equations = ['-1 * (log(h) / log(10))']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'h'
            ..label = 'Concentrazione [H+] (mol/L)'
            ..minValue = 0.0000001
            ..maxValue = 0.1
            ..defaultValue = 0.0001
            ..stepSize = 0.00001,
        ]);
  }

  /// Nodo Elettrico: Con Simulazione Grafica Animata di Elettroni
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
        ..templateType = 'circuit_simulation' // Attiva la simulazione con particelle ed elettroni in moto
        ..equations = ['V / R']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'V'
            ..label = 'Tensione Batteria (V)'
            ..minValue = 1.0
            ..maxValue = 48.0
            ..defaultValue = 12.0
            ..stepSize = 1.0,
          InteractiveParameter()
            ..variableName = 'R'
            ..label = 'Resistenza Carico (Ω)'
            ..minValue = 1.0
            ..maxValue = 48.0
            ..defaultValue = 6.0
            ..stepSize = 1.0,
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
