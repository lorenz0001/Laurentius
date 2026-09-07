---
id: mat_quad_pura_01
title: "Equazioni di Secondo Grado Pure"
category: "Matematica"
subCategory: "Equazioni di Secondo Grado"
prerequisites:
  - mat_quad_monomia_01
  - mat_frac_01
interactive:
  template: function_graph
  unit: ""
  equations:
    - "a * x * x + c"
  parameters:
    - variable: a
      label: "Coeff. a"
      min: -3.0
      max: 3.0
      default: 1.0
      step: 0.5
    - variable: c
      label: "Termine c"
      min: -9.0
      max: 9.0
      default: -4.0
      step: 0.5
---

### Equazioni di Secondo Grado Pure: Struttura e Segno

Un'equazione di secondo grado si definisce **pura** quando il coefficiente del termine lineare è nullo ($b = 0$), mentre il termine noto è non nullo ($c \neq 0$), assumendo la forma:

$$a x^2 + c = 0 \quad \text{con } a, c \in \mathbb{R}, \; a \neq 0, \; c \neq 0$$

Nel piano cartesiano, la funzione associata $y = ax^2 + c$ descrive una parabola avente come asse di simmetria l'asse delle ordinate $y$, il cui vertice è traslato verticalmente nel punto $V(0, c)$. L'esistenza di radici reali coincide con l'intersezione effettiva della curva con l'asse delle ascisse.

> **Insight:** Il valore di $x^2$ deve eguagliare il rapporto $-\frac{c}{a}$. Poiché nel campo reale il quadrato di un numero è sempre non negativo ($x^2 \ge 0$), l'equazione ammette soluzioni reali se e solo se $a$ e $c$ hanno segno discorde ($ac < 0$), rendendo positivo il secondo membro.

## Dimostrazione: Risoluzione dell'Equazione Pura

### 1. Trasposizione del termine noto e isolamento quadratico
$$a x^2 + c = 0 \iff a x^2 = -c \iff x^2 = -\frac{c}{a}$$
> **Insight:** Si applicano i principi di equivalenza delle equazioni algebriche per isolare la potenza x^2 al primo membro.

### 2. Discussione algebrica del segno del rapporto
$$\text{Se } a \cdot c < 0 \implies -\frac{c}{a} > 0; \quad \text{Se } a \cdot c > 0 \implies -\frac{c}{a} < 0$$
> **Insight:** Se i coefficienti a e c sono concordi, il rapporto e negativo e l'equazione e impossibile nel campo reale; se sono discordi, il rapporto e positivo.

### 3. Estrazione della radice quadrata e calcolo delle radici
$$x^2 = -\frac{c}{a} \implies x = \pm \sqrt{-\frac{c}{a}}$$
> **Insight:** L'operazione di estrazione di radice quadrata genera due valori opposti di identico modulo.

### 4. Corollario: Simmetria Radici Reali e Traslazione Assiale
$$x_1 = -\sqrt{-\frac{c}{a}}, \quad x_2 = +\sqrt{-\frac{c}{a}} \implies x_1 = -x_2 \quad (x_1 + x_2 = 0)$$
> **Insight:** Le due soluzioni reali di un'equazione pura sono sempre opposte: la parabola e perfettamente speculare rispetto all'asse y con vertice V(0, c).
