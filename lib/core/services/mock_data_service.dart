import 'package:isar/isar.dart';

import '../../domain/models/knowledge_node.dart';

/// Servizio per la popolazione iniziale del database locale Isar con dati dimostrativi STEM.
/// Include nodi interdisciplinari (Matematica, Chimica, Fisica, Elettrotecnica) con corollari
/// algebrici dettagliati e template di simulazione (circuito, cinematica rettilinea, grafici cartesiani).
class MockDataService {
  static Future<void> populateDatabase(Isar isar) async {
    final nodesToUpsert = [
      _createLogarithmsNode(),
      _createParabolaNode(),
      _createPhNode(),
      _createKinematicsNode(),
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
      final parabolaNode = await isar.knowledgeNodes.where().serverIdEqualTo('mat_parabola_01').findFirst();
      final phNode = await isar.knowledgeNodes.where().serverIdEqualTo('chem_ph_01').findFirst();
      final kinNode = await isar.knowledgeNodes.where().serverIdEqualTo('phys_kin_01').findFirst();
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

      // Fisica (Cinematica) richiede Matematica (Parabola) -> Collegamento Interdisciplinare
      if (kinNode != null && parabolaNode != null) {
        await kinNode.prerequisites.load();
        if (!kinNode.prerequisites.contains(parabolaNode)) {
          kinNode.prerequisites.add(parabolaNode);
          await kinNode.prerequisites.save();
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
              'Corollario: Cambiamento di base per il calcolo numerico e computazionale.'
          ..latexEquation = r'\log_a(x) = \frac{\log_b(x)}{\log_b(a)}'
          ..insight =
              'Permette di convertire qualsiasi logaritmo in base naturale (ln) o decimale, fondamentale nei calcoli fisici e chimici.',
      ]
      ..interactiveData = null;
  }

  /// Nodo Matematico con Grafico Cartesiano Interattivo
  static KnowledgeNode _createParabolaNode() {
    return KnowledgeNode()
      ..serverId = 'mat_parabola_01'
      ..title = 'Funzione Quadratica e Parabola'
      ..category = 'Matematica'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description =
              'Forma canonica polinomiale di secondo grado sul piano cartesiano.'
          ..latexEquation = r'y = a x^2 + b x + c \quad (a \neq 0)'
          ..insight =
              'Il coefficiente quadratico a governa l\'apertura e il verso della concavità.',
        ProofStep()
          ..description =
              'Completamento del quadrato per individuare l\'estremante della funzione.'
          ..latexEquation = r'y = a \left(x + \frac{b}{2a}\right)^2 - \frac{\Delta}{4a}'
          ..insight =
              'La forma vertice esplicita la traslazione orizzontale e verticale sul piano.',
        ProofStep()
          ..description =
              'Corollario: Coordinate del Vertice e Asse di Simmetria.'
          ..latexEquation = r'V = \left(-\frac{b}{2a}, -\frac{\Delta}{4a}\right)'
          ..insight =
              'Identifica l\'apice della traiettoria nei moti balistici e proiettivi.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'function_graph'
        ..equations = ['a * x * x + b * x + c']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Curvatura (a)'
            ..minValue = -3.0
            ..maxValue = 3.0
            ..defaultValue = 1.0
            ..stepSize = 0.1,
          InteractiveParameter()
            ..variableName = 'b'
            ..label = 'Traslazione (b)'
            ..minValue = -4.0
            ..maxValue = 4.0
            ..defaultValue = 0.0
            ..stepSize = 0.2,
          InteractiveParameter()
            ..variableName = 'c'
            ..label = 'Termine Noto (c)'
            ..minValue = -5.0
            ..maxValue = 5.0
            ..defaultValue = -2.0
            ..stepSize = 0.5,
        ]);
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

  /// Nodo Fisico di Cinematica con Corollario di Torricelli e Simulatore Vettura
  static KnowledgeNode _createKinematicsNode() {
    return KnowledgeNode()
      ..serverId = 'phys_kin_01'
      ..title = 'Cinematica: MRUA e Corollario di Torricelli'
      ..category = 'Fisica'
      ..lastUpdated = DateTime.now()
      ..algebraicProof = [
        ProofStep()
          ..description =
              'Definizione fondamentale: accelerazione costante come derivata prima della velocità nel tempo.'
          ..latexEquation = r'a = \frac{dv}{dt} = \text{cost.} \implies v(t) = v_0 + a t'
          ..insight =
              'La velocità cresce linearmente con pendenza pari ad a.',
        ProofStep()
          ..description =
              'Legge oraria della posizione ottenuta per integrazione della velocità nel tempo.'
          ..latexEquation = r'\Delta x = \int_0^t (v_0 + a \tau) d\tau = v_0 t + \frac{1}{2} a t^2'
          ..insight =
              'Il secondo termine esprime l\'area del triangolo delle velocità dovuto all\'accelerazione.',
        ProofStep()
          ..description =
              'Isolamento algebrico della variabile tempo t dalla prima equazione cinematica.'
          ..latexEquation = r't = \frac{v - v_0}{a}'
          ..insight =
              'Passaggio algebrico esplicito per eliminare la dipendenza temporale tra le grandezze.',
        ProofStep()
          ..description =
              'Sostituzione ed espansione del quadrato del binomio nella legge dello spostamento.'
          ..latexEquation = r'\Delta x = v_0 \left(\frac{v - v_0}{a}\right) + \frac{a}{2}\left(\frac{v - v_0}{a}\right)^2 = \frac{v^2 - v_0^2}{2a}'
          ..insight =
              'I termini incrociati 2*v0*v si semplificano algebricamente a numeratore.',
        ProofStep()
          ..description =
              'Corollario: Formula senza tempo di Torricelli per il moto rettilineo.'
          ..latexEquation = r'v^2 = v_0^2 + 2 a \Delta x'
          ..insight =
              'Fondamentale corollario: determina la velocità finale o lo spazio di frenata senza dover cronometrare il tempo!',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'kinematics_simulation'
        ..equations = ['v0 + a * t']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'v0'
            ..label = 'Velocità Iniziale (m/s)'
            ..minValue = 0.0
            ..maxValue = 30.0
            ..defaultValue = 5.0
            ..stepSize = 1.0,
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Accelerazione (m/s²)'
            ..minValue = -5.0
            ..maxValue = 10.0
            ..defaultValue = 2.0
            ..stepSize = 0.5,
        ]);
  }

  /// Nodo Elettrotecnico: Con Simulazione Grafica Animata di Elettroni
  static KnowledgeNode _createOhmNode() {
    return KnowledgeNode()
      ..serverId = 'ele_ohm_01'
      ..title = 'Legge di Ohm e Conduzione Elettrica'
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
        ..templateType = 'circuit_simulation'
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
              'Corollario: Espressione in funzione della tensione e della resistenza.'
          ..latexEquation = r'P = \frac{V^2}{R}'
          ..insight = 'Essenziale quando la tensione ai capi del carico è fissa.',
      ];
  }

  static KnowledgeNode _createJouleNode() {
    return KnowledgeNode()
      ..serverId = 'ele_joule_01'
      ..title = 'Effetto Joule e Dissipazione Termica'
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
              'Corollario: Calore generato in funzione della corrente e della resistenza.'
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
