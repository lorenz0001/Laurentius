---
id: ele_power_01
title: "Potenza Elettrica nei Circuiti"
category: "Elettrotecnica"
subCategory: "Circuiti in Corrente Continua"
prerequisites:
  - ele_ohm_01
interactive:
  template: circuit_simulation
  unit: "W"
  equations:
    - "V * V / R"
  parameters:
    - variable: V
      label: "Tensione del Generatore (V)"
      unit: "V"
      min: 1.0
      max: 48.0
      default: 12.0
      step: 1.0
    - variable: R
      label: "Resistenza del Carico (Ω)"
      unit: "Ω"
      min: 1.0
      max: 48.0
      default: 6.0
      step: 1.0
---

### L'Energia al Secondo: La Potenza Elettrica

La **potenza elettrica** misura il ritmo con cui l'energia elettrica viene assorbita, trasformata o erogata da un dispositivo in ogni secondo:
- In una lampadina, determina la luminosità emessa.
- In un motore elettrico, determina la forza meccanica prodotta.

Essa è data dal prodotto tra la tensione $V$ e la corrente $I$:

$$P = V \cdot I$$

### Le Formule nei Conduttori Resistivi

Combinando questa legge fondamentale con la Legge di Ohm ($V = R \cdot I$), otteniamo due espressioni pratiche:
- In funzione della corrente: $P = R \cdot I^2$
- In funzione della tensione: $P = \frac{V^2}{R}$

> **Insight:** Nota come la potenza dissipata su una resistenza cresca con il **quadrato** della corrente: raddoppiare gli ampere quadruplica la potenza termica generata!

## Dimostrazione: Potenza Elettrica Istantanea nei Bipoli

### 1. Definizione di potenza come derivata temporale del lavoro elettrico
$$P = \frac{dL}{dt} = \frac{V \cdot dq}{dt}$$
> **Insight:** Quantifica il tasso istantaneo di trasferimento di energia potenziale elettrica per unità di tempo.

### 2. Sostituzione della definizione di corrente elettrica
Poiché la corrente elettrica $I$ è la derivata temporale della carica transitante $I \equiv \frac{dq}{dt}$:
$$P = V \cdot \left(\frac{dq}{dt}\right) = V \cdot I$$
> **Insight:** Relazione termodinamica universale per la potenza assorbita o erogata da qualsiasi bipolo elettrico continuo.

## Dimostrazione: Corollario - Formule di Potenza per Carichi Resistivi (Effetto Ohmico)

### 1. Ipotesi della potenza elettrica assorbita dal bipolo
Consideriamo un bipolo resistivo lineare ideale caratterizzato da una resistenza costante $R > 0$ e assorbente una potenza:
$$P = V \cdot I$$
> **Insight:** Vogliamo esprimere la potenza dissipata in funzione di una sola grandezza variabile (tensione o corrente).

### 2. Sostituzione della Legge di Ohm diretta (V = R * I)
Sostituendo la tensione $V = R \cdot I$ nella formula della potenza:
$$P = (R \cdot I) \cdot I = R \cdot I^2$$
> **Insight:** La potenza dissipata cresce con il quadrato dell'intensità di corrente: raddoppiare la corrente quadruplica il calore generato.

### 3. Sostituzione della Legge di Ohm inversa (I = V / R)
Sostituendo alternativamente la corrente $I = \frac{V}{R}$ nella definizione di potenza:
$$P = V \cdot \left(\frac{V}{R}\right) = \frac{V^2}{R}$$
> **Insight:** La potenza dissipata cresce con il quadrato della tensione applicata ed è inversamente proporzionale alla resistenza del carico.

### 4. Corollario: Trilogia delle Formule della Potenza nei Carichi Resistivi
Unificando le tre espressioni analitiche equivalenti per bipoli ohmici:
$$P = V \cdot I = R \cdot I^2 = \frac{V^2}{R}$$
> **Insight:** Formule cardine dell'elettrotecnica: governano il dimensionamento in Watt (W) di qualsiasi componente circuitale, resistore o attuatore.

## Dimostrazione: Corollario - Limiti Operativi di Tensione e Corrente di Sicurezza

### 1. Ipotesi di potenza nominale termica massima ammissibile
Sia $P_{\max}$ la potenza massima dissipabile da un componente senza fusione o degrado termico, e $R$ la sua resistenza:
$$P \le P_{\max}$$
> **Insight:** Il costruttore specifica la potenza di targa massima nominale (es. resistore da 1/4 W o 1 W).

### 2. Inversione della relazione quadratica in corrente
Dall'uguaglianza $R \cdot I_{\max}^2 = P_{\max}$, dividiamo per $R$:
$$I_{\max}^2 = \frac{P_{\max}}{R} \implies I_{\max} = \sqrt{\frac{P_{\max}}{R}}$$
> **Insight:** Estraendo la radice quadrata si ottiene la soglia massima di corrente sopportabile prima della rottura.

### 3. Inversione della relazione quadratica in tensione
Dall'uguaglianza $\frac{V_{\max}^2}{R} = P_{\max}$, moltiplichiamo per $R$:
$$V_{\max}^2 = R \cdot P_{\max} \implies V_{\max} = \sqrt{R \cdot P_{\max}}$$
> **Insight:** Fissa la massima caduta di potenziale ammissibile ai morsetti del componente.

### 4. Corollario: Specifiche di Sicurezza Termica dei Resistori
I limiti operativi di corrente e tensione per evitare il sovraccarico termico risultano:
$$I_{\max} = \sqrt{\frac{P_{\max}}{R}}, \qquad V_{\max} = \sqrt{R \cdot P_{\max}}$$
> **Insight:** Regole progettuali irrinunciabili per la sicurezza dei circuiti elettronici e la prevenzione degli incendi.
