---
id: mat_quad_spuria_01
title: "Equazioni di Secondo Grado Spurie"
category: "Matematica"
subCategory: "Equazioni di Secondo Grado"
prerequisites:
  - mat_quad_monomia_01
  - mat_binom_01
interactive:
  template: function_graph
  unit: ""
  equations:
    - "a * x * x + b * x"
  parameters:
    - variable: a
      label: "Coeff. a"
      min: -3.0
      max: 3.0
      default: 1.0
      step: 0.5
    - variable: b
      label: "Coeff. b"
      min: -6.0
      max: 6.0
      default: -2.0
      step: 0.5
---

### Equazioni di Secondo Grado Spurie: Fattorizzazione e Radici

Un'equazione di secondo grado si dice **spuria** quando il termine noto è identicamente nullo ($c = 0$), mentre il coefficiente del termine lineare è non nullo ($b \neq 0$), assumendo la forma canonica:

$$a x^2 + b x = 0 \quad \text{con } a, b \in \mathbb{R}, \; a \neq 0, \; b \neq 0$$

Nel piano cartesiano, la parabola $y = ax^2 + bx$ interseca l'asse delle ascisse in due punti ben distinti. Poiché per $x = 0$ si ottiene $y = a(0)^2 + b(0) = 0$, la curva passa necessariamente per l'origine degli assi cartesiani $(0, 0)$.

> **Insight:** L'assenza del termine noto consente di non ricorrere al completamento del quadrato né alla formula con radice quadrata: è sufficiente il raccoglimento a fattor comune totale della variabile $x$ per ricondurre l'equazione a due fattori di primo grado.

## Dimostrazione: Risoluzione dell'Equazione Spuria

### 1. Scomposizione analitica per raccoglimento a fattor comune
$$a x^2 + b x = 0 \iff x \cdot (a x + b) = 0$$
> **Insight:** Il fattore comune x viene estratto da entrambi i termini, trasformando un binomio di secondo grado nel prodotto di due monomi/binomi lineari.

### 2. Applicazione della legge di annullamento del prodotto
$$x \cdot (a x + b) = 0 \iff x = 0 \quad \lor \quad a x + b = 0$$
> **Insight:** Un prodotto di fattori reali si annulla se e solo se almeno uno dei fattori che lo compongono e uguale a zero.

### 3. Risoluzione dell'equazione lineare residua
$$a x + b = 0 \iff a x = -b \iff x = -\frac{b}{a} \quad (a \neq 0)$$
> **Insight:** La seconda soluzione discende direttamente dai principi di equivalenza applicati al binomio lineare di primo grado.

### 4. Corollario: Sempre Due Soluzioni Reali Distinte e Zeri Geometrici
$$x_1 = 0, \quad x_2 = -\frac{b}{a} \quad (x_1 \neq x_2 \text{ poiche } b \neq 0)$$
> **Insight:** Un'equazione spuria ammette sempre due soluzioni reali distinte: la parabola interseca l'asse x sia nell'origine (0, 0) sia nel punto (-b/a, 0).
