---
id: ele_joule_01
title: "Effetto Joule e Dissipazione Termica"
category: "Elettrotecnica"
subCategory: "Termodinamica & Circuiti"
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

## Dimostrazione Logico-Algebrica

### 1. Integrazione della potenza dissipata nel tempo
$$Q = \int_0^{\Delta t} P \, dt = P \cdot \Delta t \quad (\text{per } P \text{ costante})$$
> **Insight:** Gli urti anelastici dei portatori di carica trasferiscono energia cinetica al reticolo cristallino sotto forma di calore in Joule (J).

### 2. Sostituzione della potenza resistiva P = R * I²
$$Q = R \cdot I^2 \cdot \Delta t$$
> **Insight:** La dissipazione cresce con il quadrato dell'intensità di corrente.

### 3. Corollario: Equivalente Meccanico del Calore e Calcolo in Calorie
$$Q_{\text{cal}} = \frac{R \cdot I^2 \cdot \Delta t}{4.186}$$
> **Insight:** Consente il calcolo dell'innalzamento termico e il dimensionamento dei dissipatori termici.
