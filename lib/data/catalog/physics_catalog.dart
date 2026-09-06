import '../../domain/models/knowledge_node.dart';

/// Catalogo dei nodi per le scienze applicate (Fisica, Elettrotecnica, Chimica):
/// Cinematica, Legge di Ohm, Potenza Elettrica, Effetto Joule e pH.
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

  /// 1. Cinematica: Moto Rettilineo Uniformemente Accelerato
  static KnowledgeNode _createKinematicsNode() {
    return KnowledgeNode()
      ..serverId = 'phys_kin_01'
      ..title = 'Cinematica: Moto Rettilineo e Corollario di Torricelli'
      ..category = 'Fisica'
      ..subCategory = 'Cinematica e Dinamica'
      ..lastUpdated = DateTime.now()
      ..blocks = [
        ContentBlock()
          ..type = 'text_markdown'
          ..content = r"""### Il Moto Rettilineo Uniformemente Accelerato

Nel moto rettilineo con accelerazione costante $a$, la variazione temporale della velocità è costante:
- La velocità è una retta nel piano $(t, v)$: $v(t) = v_0 + at$
- La posizione $x(t)$ è una parabola nel tempo, ottenuta per **integrazione definita** della velocità:

$$x(t) = x_0 + v_0 t + \frac{1}{2} a t^2$$""",
        ContentBlock()
          ..type = 'info_box'
          ..content = r"""La celebre **Formula di Torricelli** elimina il tempo $t$ dal sistema, collegando direttamente velocità e spostamento: $v^2 = v_0^2 + 2a\Delta x$.""",
        ContentBlock()
          ..type = 'math_latex'
          ..content = r'v^2 = v_0^2 + 2 a \Delta x',
      ]
      ..algebraicProof = [
        ProofStep()
          ..description = 'Definizione di accelerazione costante come derivata temporale della velocità.'
          ..latexEquation =
              r'a = \frac{dv}{dt} = \text{costante} \implies v(t) = v_0 + a t'
          ..insight = 'La velocità cresce in modo direttamente proporzionale al tempo trascorso.',
        ProofStep()
          ..description = 'Integrazione della velocità nel tempo per ottenere la legge oraria dello spostamento.'
          ..latexEquation =
              r'x(t) = x_0 + \int_0^t v(t) dt = x_0 + v_0 t + \frac{1}{2} a t^2'
          ..insight = 'L\'area sotto la retta delle velocità nel piano (t, v) genera il termine parabolico quadratico.',
        ProofStep()
          ..description = 'Isolamento del tempo t dalla relazione della velocità: t = (v - v₀) / a.'
          ..latexEquation = r't = \frac{v - v_0}{a}'
          ..insight = 'Elimina il parametro temporale unificando cinematica e geometria cartesiana.',
        ProofStep()
          ..description = 'Sostituzione di t nella legge oraria dello spostamento Δx = x - x₀.'
          ..latexEquation = r'\Delta x = v_0 \left(\frac{v - v_0}{a}\right) + \frac{1}{2} a \left(\frac{v - v_0}{a}\right)^2'
          ..insight = 'Espansione del quadrato di binomio e somma a denominatore comune 2a.',
        ProofStep()
          ..description = 'Corollario: Formula Senza Tempo di Torricelli.'
          ..latexEquation = r'v^2 = v_0^2 + 2 a \Delta x'
          ..insight = 'Collega direttamente la velocità finale allo spazio percorso senza necessità di misurare il tempo.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'kinematics_simulation'
        ..equations = ['v0 + a * t']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'v0'
            ..label = 'Velocità Iniziale v0 (m/s)'
            ..minValue = 0.0
            ..maxValue = 30.0
            ..defaultValue = 5.0
            ..stepSize = 1.0,
          InteractiveParameter()
            ..variableName = 'a'
            ..label = 'Accelerazione Costante a (m/s²)'
            ..minValue = -5.0
            ..maxValue = 10.0
            ..defaultValue = 2.0
            ..stepSize = 0.5,
        ]);
  }

  /// 2. Elettrotecnica: Legge di Ohm
  static KnowledgeNode _createOhmNode() {
    return KnowledgeNode()
      ..serverId = 'ele_ohm_01'
      ..title = 'Legge di Ohm e Resistenza Elettrica'
      ..category = 'Elettrotecnica'
      ..subCategory = 'Circuiti in Corrente Continua'
      ..lastUpdated = DateTime.now()
      ..blocks = [
        ContentBlock()
          ..type = 'text_markdown'
          ..content = r"""### La Conduzione Elettrica e la Legge di Ohm

La prima legge fondamentale dell'elettrotecnica stabilisce che, a temperatura costante, la differenza di potenziale $V$ applicata ai capi di un conduttore ohmico è direttamente proporzionale all'intensità della corrente $I$ che lo attraversa.""",
        ContentBlock()
          ..type = 'math_latex'
          ..content = r'V = R \cdot I \iff I = \frac{V}{R}',
        ContentBlock()
          ..type = 'info_box'
          ..content = r"""La costante di proporzionalità $R$ è la **resistenza elettrica**, misurata in Ohm ($\Omega$). Essa dipende geometricamente dalla lunghezza $L$ del conduttore e dalla sezione trasversale $A$ tramite la resistività del materiale ($R = \rho \frac{L}{A}$).""",
      ]
      ..algebraicProof = [
        ProofStep()
          ..description = 'Formulazione microscopica: campo elettrico interno e velocità di deriva degli elettroni.'
          ..latexEquation = r'\vec{J} = \sigma \vec{E} = \frac{1}{\rho} \vec{E}'
          ..insight = 'La densità di corrente è direttamente proporzionale al gradiente di potenziale elettrico.',
        ProofStep()
          ..description = 'Seconda Legge di Ohm: dipendenza geometrica della resistenza del conduttore.'
          ..latexEquation = r'R = \rho \frac{L}{A}'
          ..insight = 'La resistenza aumenta con la lunghezza del filo e diminuisce con la sezione trasversale.',
        ProofStep()
          ..description = 'Corollario: Prima Legge di Ohm e Formule Inverse.'
          ..latexEquation =
              r'V = R \cdot I \iff I = \frac{V}{R} \iff R = \frac{V}{I}'
          ..insight = 'Regola il rapporto lineare tra potenziale e intensità di corrente nei bipoli resistivi ideali.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'circuit_simulation'
        ..equations = ['V / R']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'V'
            ..label = 'Tensione (Volt)'
            ..minValue = 1.0
            ..maxValue = 24.0
            ..defaultValue = 12.0
            ..stepSize = 1.0,
          InteractiveParameter()
            ..variableName = 'R'
            ..label = 'Resistenza (Ohm)'
            ..minValue = 1.0
            ..maxValue = 50.0
            ..defaultValue = 10.0
            ..stepSize = 1.0,
        ]);
  }

  /// 3. Elettrotecnica: Potenza Elettrica
  static KnowledgeNode _createPowerNode() {
    return KnowledgeNode()
      ..serverId = 'ele_power_01'
      ..title = 'Potenza Elettrica nei Circuiti'
      ..category = 'Elettrotecnica'
      ..subCategory = 'Circuiti in Corrente Continua'
      ..lastUpdated = DateTime.now()
      ..blocks = [
        ContentBlock()
          ..type = 'text_markdown'
          ..content = r"""### L'Energia al Secondo: La Potenza Elettrica

La **potenza elettrica** misura il ritmo con cui l'energia elettrica viene assorbita, trasformata o erogata da un dispositivo in ogni secondo:
- In una lampadina, determina la luminosità emessa.
- In un motore elettrico, determina la forza meccanica prodotta.

Essa è data dal prodotto tra la tensione $V$ e la corrente $I$:""",
        ContentBlock()
          ..type = 'math_latex'
          ..content = r"P = V \cdot I",
        ContentBlock()
          ..type = 'text_markdown'
          ..content = r"""### Le Formule nei Conduttori Resistivi

Combinando questa legge fondamentale con la Legge di Ohm ($V = R \cdot I$), otteniamo due espressioni pratiche:
- In funzione della corrente: $P = R \cdot I^2$
- In funzione della tensione: $P = \frac{V^2}{R}$""",
        ContentBlock()
          ..type = 'info_box'
          ..content = r"""Nota come la potenza dissipata su una resistenza cresca con il **quadrato** della corrente: raddoppiare gli ampere quadruplica la potenza termica generata!""",
      ]
      ..algebraicProof = [
        ProofStep()
          ..description = 'Definizione di potenza istantanea come derivata temporale del lavoro elettrico.'
          ..latexEquation = r'P = \frac{dL}{dt} = \frac{V \cdot dq}{dt}'
          ..insight = 'Quantifica il tasso di trasferimento di energia potenziale per unità di tempo.',
        ProofStep()
          ..description =
              'Sostituzione dell\'intensità di corrente: I = dq / dt.'
          ..latexEquation = r'P = V \cdot I'
          ..insight = 'Relazione universale per la potenza assorbita o erogata da qualsiasi bipolo elettrico.',
        ProofStep()
          ..description =
              'Corollario: Formule di Potenza per Carichi Resistivi.'
          ..latexEquation = r'P = R \cdot I^2 = \frac{V^2}{R}'
          ..insight = 'Ottenute sostituendo la Legge di Ohm V = R*I; governano il dimensionamento dei componenti.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'live_equation'
        ..equations = ['V * I']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'V'
            ..label = 'Tensione (V)'
            ..minValue = 1.0
            ..maxValue = 48.0
            ..defaultValue = 12.0
            ..stepSize = 1.0,
          InteractiveParameter()
            ..variableName = 'I'
            ..label = 'Corrente (A)'
            ..minValue = 0.1
            ..maxValue = 10.0
            ..defaultValue = 2.0
            ..stepSize = 0.1,
        ]);
  }

  /// 4. Elettrotecnica: Effetto Joule
  static KnowledgeNode _createJouleNode() {
    return KnowledgeNode()
      ..serverId = 'ele_joule_01'
      ..title = 'Effetto Joule e Dissipazione Termica'
      ..category = 'Elettrotecnica'
      ..subCategory = 'Termodinamica & Circuiti'
      ..lastUpdated = DateTime.now()
      ..blocks = [
        ContentBlock()
          ..type = 'text_markdown'
          ..content = r"""### Perché i Fili si Scaldano? L'Effetto Joule

Quando la corrente elettrica attraversa un materiale conduttore, miliardi di elettroni urtano costantemente gli atomi del reticolo cristallino del metallo.
A ogni urto microscopico, parte dell'energia cinetica degli elettroni si trasferisce al reticolo facendolo vibrare: questa agitazione termica su scala macroscopica è esattamente il **calore**.

L'energia termica $Q$ dissipata in un intervallo di tempo $\Delta t$ è:""",
        ContentBlock()
          ..type = 'math_latex'
          ..content = r"Q = R \cdot I^2 \cdot \Delta t",
        ContentBlock()
          ..type = 'info_box'
          ..content = r"""L'effetto Joule è utilissimo quando vogliamo riscaldare (ferro da stiro, forno elettrico, boiler), ma è una delle principali cause di perdita di energia nelle linee elettriche e nei microprocessori.""",
      ]
      ..algebraicProof = [
        ProofStep()
          ..description = 'Integrazione della potenza dissipata nel tempo: energia termica generata per attrito reticolare.'
          ..latexEquation = r'Q = \int_0^{\Delta t} P \, dt = P \cdot \Delta t \quad (\text{per } P \text{ costante})'
          ..insight = 'Gli urti anelastici dei portatori di carica trasferiscono energia cinetica al reticolo cristallino sotto forma di calore.',
        ProofStep()
          ..description = 'Sostituzione della potenza resistiva P = R * I² nella relazione dell\'energia.'
          ..latexEquation = r'Q = R \cdot I^2 \cdot \Delta t'
          ..insight = 'La dissipazione cresce con il quadrato dell\'intensità di corrente.',
        ProofStep()
          ..description = 'Corollario: Equivalente Meccanico del Calore e Calcolo in Calorie.'
          ..latexEquation =
              r'Q_{\text{cal}} = \frac{R \cdot I^2 \cdot \Delta t}{4.186}'
          ..insight = 'Consente il calcolo dell\'innalzamento termico e il dimensionamento dei dissipatori termici.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'live_equation'
        ..equations = ['R * I * I * t']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'R'
            ..label = 'Resistenza (Ohm)'
            ..minValue = 1.0
            ..maxValue = 20.0
            ..defaultValue = 5.0
            ..stepSize = 1.0,
          InteractiveParameter()
            ..variableName = 'I'
            ..label = 'Corrente (A)'
            ..minValue = 0.5
            ..maxValue = 5.0
            ..defaultValue = 2.0
            ..stepSize = 0.5,
          InteractiveParameter()
            ..variableName = 't'
            ..label = 'Tempo (s)'
            ..minValue = 1.0
            ..maxValue = 60.0
            ..defaultValue = 10.0
            ..stepSize = 1.0,
        ]);
  }

  /// 5. Chimica: pH e Logaritmi
  static KnowledgeNode _createPhNode() {
    return KnowledgeNode()
      ..serverId = 'chem_ph_01'
      ..title = 'Chimica Fisica: Soluzioni Acido-Base e Calcolo del pH'
      ..category = 'Fisica'
      ..subCategory = 'Chimica Fisica'
      ..lastUpdated = DateTime.now()
      ..blocks = [
        ContentBlock()
          ..type = 'text_markdown'
          ..content = r"""### La Scala del pH: Domare i Grandi Numeri

La concentrazione di ioni idronio $[\text{H}_3\text{O}^+]$ in una soluzione acquosa può variare enormemente:
- Da $1$ mole per litro in un acido molto forte
- Fino a $0.00000000000001$ ($10^{-14}$) moli per litro in una base fortissima.

Lavorare con quattordici zeri decimali è poco pratico. Per questo si utilizza la scala logaritmica del **pH**, che comprime questi ordini di grandezza in un comodo intervallo da $0$ a $14$:""",
        ContentBlock()
          ..type = 'math_latex'
          ..content = r"\text{pH} = -\log_{10}([\text{H}_3\text{O}^+])",
        ContentBlock()
          ..type = 'info_box'
          ..content = r"""**Guida Rapida al pH:**
- $\text{pH} = 7$: Neutro (acqua pura a 25°C)
- $\text{pH} < 7$: Acido (succo di limone $\approx 2.4$, caffè $\approx 5$)
- $\text{pH} > 7$: Basico (sapone $\approx 9$, ammoniaca $\approx 11.5$)
Ogni salto di 1 unità di pH indica una concentrazione dieci volte superiore o inferiore!""",
      ]
      ..algebraicProof = [
        ProofStep()
          ..description = 'Equilibrio di autoionizzazione dell\'acqua pura a 25°C e prodotto ionico Kw.'
          ..latexEquation = r'K_w = [\text{H}_3\text{O}^+] \cdot [\text{OH}^-] = 1.0 \times 10^{-14} \text{ M}^2'
          ..insight = 'In soluzione acquosa neutra, la concentrazione di ioni idronio e idrossido è identica: 10^-7 M.',
        ProofStep()
          ..description = 'Definizione dell\'operatore logaritmico p = -log10 per comprimere scale esponenziali.'
          ..latexEquation = r'\text{pH} = -\log_{10}([\text{H}_3\text{O}^+]), \quad \text{pOH} = -\log_{10}([\text{OH}^-])'
          ..insight = 'Trasforma variazioni di quattordici ordini di grandezza in una scala lineare comoda da 0 a 14.',
        ProofStep()
          ..description = 'Applicazione della proprietà del logaritmo del prodotto al prodotto ionico dell\'acqua.'
          ..latexEquation = r'-\log_{10}(K_w) = -\log_{10}([\text{H}_3\text{O}^+]) - \log_{10}([\text{OH}^-])'
          ..insight = 'La moltiplicazione delle concentrazioni si traduce nella somma delle grandezze p.',
        ProofStep()
          ..description = 'Corollario: Relazione Fondamentale pH + pOH = 14.'
          ..latexEquation =
              r'\text{pH} + \text{pOH} = 14.00 \iff \text{pH} = 14 - \text{pOH}'
          ..insight = 'Permette di determinare istantaneamente il pH di soluzioni fortemente basiche conoscendo la concentrazione di OH-.',
      ]
      ..interactiveData = (InteractiveData()
        ..templateType = 'live_equation'
        ..equations = ['-log(c) / 2.302585']
        ..parameters = [
          InteractiveParameter()
            ..variableName = 'c'
            ..label = '[H+] Concentrazione Molare'
            ..minValue = 0.0000001
            ..maxValue = 0.1
            ..defaultValue = 0.001
            ..stepSize = 0.001,
        ]);
  }
}
