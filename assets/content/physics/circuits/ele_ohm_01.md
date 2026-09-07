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

## Dimostrazione Logico-Algebrica

### 1. Formulazione microscopica e velocità di deriva
$$\vec{J} = \sigma \vec{E} = \frac{1}{\rho} \vec{E}$$
> **Insight:** La densità di corrente è direttamente proporzionale al gradiente di potenziale elettrico.

### 2. Seconda Legge di Ohm: dipendenza geometrica
$$R = \rho \frac{L}{A}$$
> **Insight:** La resistenza aumenta con la lunghezza del filo e diminuisce con la sezione trasversale.

### 3. Corollario: Prima Legge di Ohm e Formule Inverse
$$V = R \cdot I \iff I = \frac{V}{R} \iff R = \frac{V}{I}$$
> **Insight:** Regola il rapporto lineare tra potenziale e intensità di corrente nei bipoli resistivi ideali.
