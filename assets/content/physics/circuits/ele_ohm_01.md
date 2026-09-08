---
id: ele_ohm_01
title: "Legge di Ohm e Resistenza Elettrica"
category: "Elettrotecnica"
subCategory: "Circuiti in Corrente Continua"
prerequisites:
  - mat_frac_01
interactive:
  template: circuit_simulation
  unit: "A"
  equations:
    - "V / R"
  parameters:
    - variable: V
      label: "Tensione (Volt)"
      unit: "V"
      min: 1.0
      max: 24.0
      default: 12.0
      step: 1.0
    - variable: R
      label: "Resistenza (Ohm)"
      unit: "Ω"
      min: 1.0
      max: 50.0
      default: 10.0
      step: 1.0
---

### La Conduzione Elettrica e la Legge di Ohm

La prima legge fondamentale dell'elettrotecnica stabilisce che, a temperatura costante, la differenza di potenziale $V$ applicata ai capi di un conduttore ohmico è direttamente proporzionale all'intensità della corrente $I$ che lo attraversa.

$$V = R \cdot I \iff I = \frac{V}{R}$$

> **Insight:** La costante di proporzionalità $R$ è la **resistenza elettrica**, misurata in Ohm ($\Omega$). Essa dipende geometricamente dalla lunghezza $L$ del conduttore e dalla sezione trasversale $A$ tramite la resistività del materiale ($R = \rho \frac{L}{A}$).

## Dimostrazione: Teoria Microscopica della Conduzione e Resistenza Elettrica

### 1. Legge di Ohm microscopica e densità di corrente
In un conduttore metallico omogeneo sotto l'azione di un campo elettrico $\vec{E}$, la densità di corrente $\vec{J}$ soddisfa la relazione costitutiva locale:
$$\vec{J} = \sigma \vec{E} = \frac{1}{\rho} \vec{E}$$
> **Insight:** La conducibilità sigma e la resistività rho quantificano la mobilità dei portatori di carica nel reticolo cristallino.

### 2. Espressione macroscopica della corrente e del potenziale
Per un conduttore cilindrico di sezione trasversale costante $A$ e lunghezza $L$ con campo uniforme $E = \frac{V}{L}$:
$$I = \iint_A \vec{J} \cdot d\vec{A} = J \cdot A \implies J = \frac{I}{A}$$
> **Insight:** Integra la densità vettoriale su tutta la sezione del filo conduttore.

### 3. Seconda Legge di Ohm e geometria del conduttore
Sostituendo la relazione microscopica $J = \frac{1}{\rho} E$:
$$\frac{I}{A} = \frac{1}{\rho} \frac{V}{L} \iff V = \left(\rho \frac{L}{A}\right) \cdot I$$
> **Insight:** Isola tra parentesi la resistenza R come fattore puramente geometrico e materiale.

## Dimostrazione: Corollario - Prima Legge di Ohm e Formule Inverse

### 1. Definizione della Resistenza Elettrica Macroscopica
Ponendo per definizione la resistenza del conduttore come parametro di scala:
$$R \equiv \rho \frac{L}{A}$$
> **Insight:** R quantifica l'opposizione al passaggio degli elettroni misurata in Ohm (Ω = V/A).

### 2. Deduzione diretta della Prima Legge di Ohm
Sostituendo la definizione di resistenza nell'equazione di potenziale $V = (\rho L/A) I$:
$$V = R \cdot I$$
> **Insight:** La caduta di tensione è linearmente proporzionale all'intensità di corrente erogata.

### 3. Isolamento della corrente di circolazione
Dividendo ambo i membri per la resistenza non nulla $R > 0$:
$$I = \frac{V}{R}$$
> **Insight:** A parità di tensione applicata, aumentando la resistenza la corrente circolante decresce iperbolicamente.

### 4. Corollario: Formule Inverse della Legge di Ohm
Isolando alternativamente la resistenza come rapporto tensione/corrente:
$$V = R \cdot I \iff I = \frac{V}{R} \iff R = \frac{V}{I}$$
> **Insight:** Governa il funzionamento operativo di tutti i circuiti in regime stazionario continuo (DC) e il dimensionamento dei carichi elettrici.

## Dimostrazione: Corollario - Resistori in Serie e Additività delle Cadute di Tensione

### 1. Ipotesi del collegamento in serie e unicità della corrente
Consideriamo due resistori $R_1$ e $R_2$ collegati in cascata (in serie) percorsi dalla medesima corrente continua $I$:
$$I_1 = I_2 = I$$
> **Insight:** La conservazione della carica elettrica impone che nessun elettrone si accumuli nel nodo intermedio.

### 2. Principio di conservazione dell'energia e secondo principio di Kirchhoff
La differenza di potenziale complessiva $V_{\text{tot}}$ applicata alla serie è la somma delle cadute parziali:
$$V_{\text{tot}} = V_1 + V_2$$
> **Insight:** Il lavoro totale compiuto dal campo elettrico è la somma dei lavori compiuti su ciascun resistore.

### 3. Sostituzione della Prima Legge di Ohm su ciascun componente
Applicando $V_1 = R_1 I$ e $V_2 = R_2 I$:
$$V_{\text{tot}} = R_1 I + R_2 I = (R_1 + R_2) \cdot I$$
> **Insight:** Si raccoglie la corrente comune I a fattore comune totale.

### 4. Corollario: Resistenza Equivalente Serie
Dividendo per la corrente $I$, definiamo la resistenza equivalente $R_{\text{eq}} \equiv \frac{V_{\text{tot}}}{I}$:
$$R_{\text{eq}} = R_1 + R_2 \iff R_{\text{eq,serie}} = \sum_{k=1}^n R_k$$
> **Insight:** La resistenza equivalente di resistori in serie è la somma algebrica pura delle singole resistenze.
