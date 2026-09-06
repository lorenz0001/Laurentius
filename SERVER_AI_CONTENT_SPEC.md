# Specifiche & Direttive per l'Agente AI Generatore di Contenuti (Brilliant-OS / Laurentius)

Questo documento contiene le **istruzioni operative, le regole architetturali e i contratti JSON** che l'agente AI lato server DEVE seguire per creare o aggiornare nodi di conoscenza (*Knowledge Nodes*) destinati all'app client **Laurentius (Brilliant-OS)**.

I dati generati dal server vengono erogati all'endpoint `GET /api/nodes` e sincronizzati nel database offline-first locale (Isar).

---

## 1. Filosofia Pedagogica (Stile "Brilliant")

L'obiettivo didattico è far **comprendere intuitivamente** concetti complessi STEM (Scienza, Tecnologia, Ingegneria, Matematica) a studenti universitari e curiosi, evitando l'effetto "muro di testo".

1. **Mai muri di testo:** Le spiegazioni devono essere concise, dense di significato e frammentate in passaggi logici.
2. **Interattività e Simulazione per la Fisica/Ingegneria:** Se un concetto descrive un fenomeno fisico con grandezze misurabili (es. cariche elettriche, campi magnetici, calore, onde, moti), **DEVE** includere una configurazione interattiva per abilitare simulazioni o laboratori dinamici nel client.
3. **Rigore e Passaggi Step-by-Step per la Matematica:** Per teoremi o dimostrazioni puramente matematiche/algebriche non serve un'animazione fisica forzata: serve invece una scomposizione chiara dei passaggi algebrici (`algebraicProof`), dove ogni equazione LaTeX è accompagnata dall'intuizione concettuale (`insight`).
4. **Interconnessione Interdisciplinare:** Il sapere non è a compartimenti stagni. Se una legge chimica o fisica si basa su uno strumento matematico (es. il calcolo del pH o il decadimento radioattivo basati sui logaritmi), l'argomento **DEVE avere come prerequisito il nodo matematico corrispondente**.

---

## 2. Decision Tree: Dimostrazione Algebrica vs Simulazione Interattiva

Quando l'agente AI genera un nuovo argomento, deve determinare se includere solo la dimostrazione, solo la simulazione o entrambi:

```
                +---------------------------------+
                |   Natura dell'Argomento STEM    |
                +---------------------------------+
                                 |
         +-----------------------+-----------------------+
         |                                               |
[Concetto Puramente Matematico]              [Fenomeno Fisico / Ingegneristico / Applicato]
(es. Teorema di Bayes,                       (es. Legge di Ohm, Circuito RLC,
 Logaritmi, Derivata del prodotto)            Effetto Joule, Cinematica, Termodinamica)
         |                                               |
         v                                               v
* algebraicProof: RICCO (3-6 passaggi)       * algebraicProof: FORMULAZIONE BASE (2-3 passaggi)
* interactiveData: null (non forzare anim.)  * interactiveData: OBBLIGATORIO (templateType idoneo)
```

---

## 3. Schema JSON del Nodo di Conoscenza (`KnowledgeNode`)

Ciascun elemento dell'array JSON restituito dal server deve rispettare questa struttura esatta:

```json
{
  "serverId": "cat_topic_01",
  "title": "Titolo Conciso dell'Argomento",
  "category": "Elettrotecnica | Fisica | Matematica | Chimica | Ingegneria",
  "lastUpdated": "2026-09-06T15:00:00Z",
  "prerequisites": ["serverId_prerequisito_1", "serverId_prerequisito_2"],
  "algebraicProof": [
    {
      "description": "Descrizione sintetica del passaggio logico",
      "latexEquation": "V = R \\cdot I",
      "insight": "Intuizione fisica o matematica legata a questo specifico passaggio"
    }
  ],
  "interactiveData": {
    "templateType": "circuit_simulation | live_equation",
    "equations": ["R * I"],
    "parameters": [
      {
        "variableName": "R",
        "label": "Resistenza (Ω)",
        "minValue": 1.0,
        "maxValue": 100.0,
        "defaultValue": 10.0,
        "stepSize": 1.0
      }
    ]
  }
}
```

### Dettaglio dei Campi

| Campo | Tipo | Descrizione |
|---|---|---|
| `serverId` | String | Identificativo univoco univoco (es. `ele_ohm_01`, `mat_log_01`, `chem_ph_01`). Convenzione: prefisso 3-4 lettere della categoria + nome sintetico + progressivo. |
| `title` | String | Titolo formale ed esplicativo (es. *"Legge di Ohm"*, *"Calcolo del pH ed Equilibrio Chimico"*). |
| `category` | String | Categoria canonica (valori ammessi: `Matematica`, `Fisica`, `Elettrotecnica`, `Chimica`, `Ingegneria`). |
| `lastUpdated` | String (ISO 8601) | Timestamp di generazione/modifica. |
| `prerequisites` | Array di Stringhe | Elenco dei `serverId` di nodi propedeutici necessari per comprendere questo argomento (supporta collegamenti multi-materia). |
| `algebraicProof` | Array di Oggetti | Sequenza ordinata di passaggi dimostrativi. Ciascun oggetto contiene `description`, `latexEquation` (sintassi LaTeX standard senza delimitatori `$$`), e `insight`. |
| `interactiveData` | Oggetto (Opzionale) | Dati per il laboratorio interattivo o simulazione visiva. Se assente, impostare a `null`. |

---

## 4. Tipi di Template Interattivi (`templateType`)

### A. `'circuit_simulation'` (o `'ohm_simulation'`)
- **Quando usarlo:** Legge di Ohm, conduzione elettrica, circuiti resistivi.
- **Cosa scatena nel client:** Visualizzazione del circuito chiuso completo con animazione a particelle degli elettroni (la cui velocità è governata da $I = V/R$), surriscaldamento visivo del resistore in base alla potenza $P = I^2 R$, e slider interattivi per Tensione ($V$) e Resistenza ($R$).
- **Parametri richiesti in `parameters`:**
  1. `variableName`: `"V"` (Tensione in Volt)
  2. `variableName`: `"R"` (Resistenza in Ohm)

### B. `'live_equation'`
- **Quando usarlo:** Qualsiasi legge fisica o formula quantitativa che richiede uno studio parametrico dinamico con slider (es. *Effetto Joule*, *Legge di Gravitazione Universale*, *Forza di Lorentz*, *Energia Cinetica*).
- **Cosa scatena nel client:** Calcolo in tempo reale tramite motore `math_expressions` e slider calibrati con visualizzazione live del risultato numerico.
- **Sintassi `equations`:** Notazione algebrica standard compatibile con parser:
  - Addizione: `+`, Sottrazione: `-`
  - Moltiplicazione esplicita: `*` (NON omettere il simbolo di moltiplicazione, es. usare `R * I * I` o `m * v * v / 2`)
  - Divisione: `/`
  - Potenze e funzioni: `x^2`, `sqrt(x)`, `ln(x)`, `sin(x)`

---

## 5. Convenzioni per i Collegamenti Interdisciplinari (Cross-Subject Links)

Quando crei argomenti appartenenti a campi applicati (Chimica, Fisica, Elettrotecnica), **identifica sempre i fondamenti matematici sottostanti** e collegali:

1. **Chimica $\leftrightarrow$ Matematica:**
   - Esempio: Il nodo `chem_ph_01` (*Calcolo del pH*) **DEVE** includere come prerequisito `mat_log_01` (*Logaritmi ed Esponenziali*), perché la formula $pH = -\log_{10}[H^+]$ richiede la padronanza dei logaritmi.
2. **Elettrotecnica $\leftrightarrow$ Fisica $\leftrightarrow$ Matematica:**
   - Esempio: La *Legge di Ohm* (`ele_ohm_01`) costituisce prerequisito per la *Potenza Elettrica* (`ele_power_01`), che a sua volta è prerequisito per l'*Effetto Joule* (`ele_joule_01`). Se si introduce l'analisi differenziale dei circuiti, il nodo di calcolo integrale (`mat_calc_01`) deve essere collegato.
3. **Fisica $\leftrightarrow$ Matematica:**
   - Esempio: Il nodo di *Cinematica Differenziale* (`phys_kin_01`) ha come prerequisito la *Definizione di Derivata* (`mat_der_01`).

---

## 6. Esempi Completi di Payload JSON da Fornire al Server

### Esempio 1: Dimostrazione Puramente Matematica (Nessuna Animazione Fisica Forzata)
```json
{
  "serverId": "mat_log_01",
  "title": "Logaritmi ed Esponenziali",
  "category": "Matematica",
  "lastUpdated": "2026-09-06T15:00:00Z",
  "prerequisites": [],
  "algebraicProof": [
    {
      "description": "Definizione fondamentale: il logaritmo è l'esponente da dare alla base b per ottenere l'argomento x.",
      "latexEquation": "b^y = x \\iff y = \\log_b(x)",
      "insight": "Rappresenta l'operazione inversa rispetto all'elevamento a potenza, con base b > 0 e b != 1."
    },
    {
      "description": "Proprietà del prodotto: il logaritmo del prodotto è la somma dei singoli logaritmi.",
      "latexEquation": "\\log_b(x \\cdot y) = \\log_b(x) + \\log_b(y)",
      "insight": "Trasforma operazioni moltiplicative complesse in semplici addizioni su scala logaritmica."
    },
    {
      "description": "Proprietà della potenza: l'esponente dell'argomento diventa coefficiente moltiplicatore.",
      "latexEquation": "\\log_b(x^k) = k \\cdot \\log_b(x)",
      "insight": "Cruciale per risolvere equazioni esponenziali e scale non lineari (decibel, scala Richter, pH)."
    }
  ],
  "interactiveData": null
}
```

---

### Esempio 2: Argomento Chimico con Collegamento Interdisciplinare alla Matematica
```json
{
  "serverId": "chem_ph_01",
  "title": "Calcolo del pH ed Equilibrio Acido-Base",
  "category": "Chimica",
  "lastUpdated": "2026-09-06T15:00:00Z",
  "prerequisites": ["mat_log_01"],
  "algebraicProof": [
    {
      "description": "Definizione operativa di Sørensen: il pH misura l'attività (o concentrazione molare) degli ioni idrogeno in soluzione.",
      "latexEquation": "pH = -\\log_{10}[H_3O^+]",
      "insight": "Il segno negativo fa sì che a una concentrazione più elevata di ioni H+ corrisponda un valore numerico di pH inferiore (più acido)."
    },
    {
      "description": "Prodotto ionico dell'acqua (Kw) a 25°C e scala di neutralità chimica.",
      "latexEquation": "K_w = [H_3O^+][OH^-] = 10^{-14} \\implies pH + pOH = 14",
      "insight": "In acqua pura le due specie sono in equilibrio equimolare: [H3O+] = 10^-7 M, determinando il valore neutro pH = 7."
    }
  ],
  "interactiveData": {
    "templateType": "live_equation",
    "equations": ["-1 * (log(h) / log(10))"],
    "parameters": [
      {
        "variableName": "h",
        "label": "Concentrazione [H+] (mol/L)",
        "minValue": 0.0000001,
        "maxValue": 0.1,
        "defaultValue": 0.0001,
        "stepSize": 0.00001
      }
    ]
  }
}
```

---

### Esempio 3: Argomento Fisico/Elettronico con Simulazione Animata Interattiva
```json
{
  "serverId": "ele_ohm_01",
  "title": "Legge di Ohm e Conduzione Elettrica",
  "category": "Elettrotecnica",
  "lastUpdated": "2026-09-06T15:00:00Z",
  "prerequisites": [],
  "algebraicProof": [
    {
      "description": "Relazione fondamentale tra tensione, resistenza e corrente in un conduttore ohmico.",
      "latexEquation": "V = R \\cdot I",
      "insight": "La resistenza R quantifica l'opposizione atomica al passaggio del flusso di portatori di carica."
    },
    {
      "description": "Isolamento dell'intensità di corrente circolante in funzione della caduta di potenziale.",
      "latexEquation": "I = \\frac{V}{R}",
      "insight": "Aumentando la differenza di potenziale (spinta), il flusso di elettroni aumenta; aumentando gli ostacoli reticolari (R), il flusso rallenta."
    }
  ],
  "interactiveData": {
    "templateType": "circuit_simulation",
    "equations": ["V / R"],
    "parameters": [
      {
        "variableName": "V",
        "label": "Tensione Batteria (V)",
        "minValue": 1.0,
        "maxValue": 48.0,
        "defaultValue": 12.0,
        "stepSize": 1.0
      },
      {
        "variableName": "R",
        "label": "Resistenza Carico (Ω)",
        "minValue": 1.0,
        "maxValue": 50.0,
        "defaultValue": 6.0,
        "stepSize": 1.0
      }
    ]
  }
}
```

---

## 7. Checklist di Validazione per l'Agente AI prima di Pubblicare un Nodo

- [ ] Il campo `serverId` è univoco e composto da `prefisso_argomento_numero`.
- [ ] La `category` è una tra: `Matematica`, `Fisica`, `Elettrotecnica`, `Chimica`, `Ingegneria`.
- [ ] I `prerequisites` contengono solo `serverId` validi e includono le dipendenze matematiche di base anche se di materie diverse.
- [ ] Le equazioni in `algebraicProof` sono scritte in LaTeX valido e senza delimitatori `$$` o `$` nel campo.
- [ ] Se l'argomento è puramente teorico/matematico, `interactiveData` è `null`.
- [ ] Se l'argomento è fisico/interattivo, `interactiveData` ha un `templateType` riconosciuto (`circuit_simulation` o `live_equation`) e parametri con intervalli realistici.
