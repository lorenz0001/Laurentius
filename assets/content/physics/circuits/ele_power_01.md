---
id: ele_power_01
title: "Potenza Elettrica nei Circuiti"
category: "Elettrotecnica"
subCategory: "Circuiti in Corrente Continua"
prerequisites:
  - ele_ohm_01
interactive:
  template: live_equation
  unit: "W"
  equations:
    - "V * I"
  parameters:
    - variable: V
      label: "Tensione (V)"
      unit: "V"
      min: 1.0
      max: 48.0
      default: 12.0
      step: 1.0
    - variable: I
      label: "Corrente (A)"
      unit: "A"
      min: 0.1
      max: 10.0
      default: 2.0
      step: 0.1
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

## Dimostrazione Logico-Algebrica

### 1. Definizione di potenza istantanea come derivata del lavoro
$$P = \frac{dL}{dt} = \frac{V \cdot dq}{dt}$$
> **Insight:** Quantifica il tasso di trasferimento di energia potenziale per unità di tempo.

### 2. Sostituzione dell'intensità di corrente: I = dq / dt
$$P = V \cdot I$$
> **Insight:** Relazione universale per la potenza assorbita o erogata da qualsiasi bipolo elettrico.

### 3. Corollario: Formule di Potenza per Carichi Resistivi
$$P = R \cdot I^2 = \frac{V^2}{R}$$
> **Insight:** Ottenute sostituendo la Legge di Ohm V = R*I; governano il dimensionamento dei componenti in Watt (W).
