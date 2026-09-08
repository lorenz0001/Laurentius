---
id: ele_joule_01
title: "Effetto Joule e Dissipazione Termica"
category: "Elettrotecnica"
subCategory: "Circuiti in Corrente Continua"
prerequisites:
  - ele_power_01
  - mat_fund_calc_01
interactive:
  template: live_equation
  unit: "J"
  equations:
    - "R * I * I * t"
  parameters:
    - variable: R
      label: "Resistenza (Ohm)"
      unit: "Ω"
      min: 1.0
      max: 20.0
      default: 5.0
      step: 1.0
    - variable: I
      label: "Corrente (A)"
      unit: "A"
      min: 0.5
      max: 5.0
      default: 2.0
      step: 0.5
    - variable: t
      label: "Tempo (s)"
      unit: "s"
      min: 1.0
      max: 60.0
      default: 10.0
      step: 1.0
---

### Perché i Fili si Scaldano? L'Effetto Joule

Quando la corrente elettrica attraversa un materiale conduttore, miliardi di elettroni urtano costantemente gli atomi del reticolo cristallino del metallo.
A ogni urto microscopico, parte dell'energia cinetica degli elettroni si trasferisce al reticolo facendolo vibrare: questa agitazione termica su scala macroscopica è esattamente il **calore**.

L'energia termica $Q$ dissipata in un intervallo di tempo $\Delta t$ è:

$$Q = R \cdot I^2 \cdot \Delta t$$

> **Insight:** L'effetto Joule è utilissimo quando vogliamo riscaldare (ferro da stiro, forno elettrico, boiler), ma è una delle principali cause di perdita di energia nelle linee elettriche e nei microprocessori.

## Dimostrazione: Legge di Joule ed Energia Termica Dissipata

### 1. Definizione microscopica del lavoro elettrico e potenza dissipata
$$P = \frac{dW}{dt} = V \cdot \frac{dq}{dt} = V \cdot I$$
> **Insight:** Il lavoro compiuto dal campo elettrico per muovere la carica unitaria $dq$ attraverso una differenza di potenziale $V$ corrisponde istantaneamente alla potenza elettrica erogata.

### 2. Integrazione temporale dell'energia in regime stazionario
$$W_e = \int_0^{\Delta t} P(t) \, dt = P \int_0^{\Delta t} dt = P \cdot \Delta t$$
> **Insight:** In regime di corrente continua stazionaria (DC), la potenza dissipata è costante nel tempo, rendendo l'energia pari al semplice prodotto algebrico $P \cdot \Delta t$.

### 3. Sostituzione della caratteristica costitutiva ohmica macroscopica
$$V = R \cdot I \implies W_e = (R \cdot I) \cdot I \cdot \Delta t = R \cdot I^2 \cdot \Delta t$$
> **Insight:** Applicando la legge di Ohm, il lavoro elettrico dipende quadraticamente dall'intensità di corrente che fluisce nel reticolo conduttore.

### 4. Bilancio termodinamico del primo principio
$$Q = W_e \implies Q = R \cdot I^2 \cdot \Delta t$$
> **Insight:** A livello stazionario senza lavoro meccanico o chimico utile compiuto, l'intera energia elettrica viene convertita irreversibilmente in agitazione termica atomica (calore espresso in Joule).

## Dimostrazione: Corollario - Equivalente Meccanico del Calore e Conversione in Calorie

### 1. Ipotesi iniziale e fattore di conversione termomeccanico
$$Q_{\text{J}} = R \cdot I^2 \cdot \Delta t \quad \text{con} \quad 1 \text{ cal} = 4.186 \text{ J} \iff 1 \text{ J} = \frac{1}{4.186} \text{ cal}$$
> **Insight:** James Prescott Joule stabilì sperimentalmente l'equivalenza esatta tra lavoro meccanico/elettrico in Joule e incremento entalpico dell'acqua in calorie standard.

### 2. Rapporto di proporzionalità per la quantità di calore in calorie
$$Q_{\text{cal}} = \frac{Q_{\text{J}}}{4.186} = \frac{R \cdot I^2 \cdot \Delta t}{4.186}$$
> **Insight:** Il calore espresso nella vecchia unità calorimetrica si ottiene dividendo l'energia in Joule per il valore specifico dell'equivalente meccanico del calore.

### 3. Valutazione del coefficiente decimale di conversione
$$\frac{1}{4.186} \approx 0.2389 \implies Q_{\text{cal}} \approx 0.2389 \cdot R \cdot I^2 \cdot \Delta t$$
> **Insight:** Moltiplicando l'energia Joule per circa $0.239$, otteniamo direttamente le calorie sviluppate all'interno del sistema termico.

### 4. Determinazione del rendimento di riscaldamento in calorimetro
$$Q_{\text{cal}} = m \cdot c_s \cdot \Delta T \implies \Delta T = \frac{0.2389 \cdot R \cdot I^2 \cdot \Delta t}{m \cdot c_s}$$
> **Insight:** Questa equazione consente di dimensionare con precisione la potenza e il tempo di funzionamento di resistori riscaldanti a immersione per liquidi termici.

## Dimostrazione: Corollario - Innalzamento Adiabatico di Temperatura e Sovraccarico

### 1. Ipotesi iniziale di impulso transitorio adiabatico
$$\Delta t \to 0 \implies Q_{\text{perso}} \approx 0 \implies Q_{\text{J}} = Q_{\text{accumulato}}$$
> **Insight:** In presenza di impulsi di sovracorrente o corto circuito ad alta velocità, il calore generato non ha il tempo materiale di disperdersi verso l'ambiente esterno.

### 2. Equazione calorimetrica del conduttore metallico
$$Q = m \cdot c_s \cdot \Delta T = (\delta \cdot V_{\text{vol}}) \cdot c_s \cdot \Delta T = (\delta \cdot A \cdot L) \cdot c_s \cdot \Delta T$$
> **Insight:** La capacità termica del conduttore è data dalla massa (densità volumica $\delta$ moltiplicata per sezione trasversale $A$ e lunghezza $L$) per il calore specifico $c_s$.

### 3. Uguaglianza con l'energia dissipata dalla seconda legge di Ohm
$$\left(\rho \frac{L}{A}\right) \cdot I^2 \cdot \Delta t = (\delta \cdot A \cdot L) \cdot c_s \cdot \Delta T$$
> **Insight:** Esprimendo la resistenza in funzione della resistività $\rho$, della lunghezza $L$ e della sezione $A$, la lunghezza compare su entrambi i lati del bilancio.

### 4. Semplificazione e dipendenza dalla densità di corrente J
$$\Delta T = \frac{\rho \cdot I^2 \cdot \Delta t}{\delta \cdot c_s \cdot A^2} = \left(\frac{\rho}{\delta \cdot c_s}\right) \cdot J^2 \cdot \Delta t \quad \left(\text{con } J = \frac{I}{A}\right)$$
> **Insight:** L'innalzamento termico adiabatico è indipendente dalla lunghezza del cavo e cresce con il quadrato della densità di corrente $J$, parametro critico per i fusibili e le tracce PCB.
