---
id: mat_quad_monomia_01
title: "Equazioni di Secondo Grado Monomie"
category: "Matematica"
subCategory: "Equazioni di Secondo Grado"
prerequisites:
  - mat_mul_01
  - mat_pow_01
interactive:
  template: function_graph
  unit: ""
  equations:
    - "a * x * x"
  parameters:
    - variable: a
      label: "Coeff. a"
      min: -3.0
      max: 3.0
      default: 1.0
      step: 0.5
---

### Equazioni di Secondo Grado Monomie: Forma Fondamentale

Un'equazione algebrica di secondo grado si definisce **monomia** quando sia il coefficiente di primo grado sia il termine noto sono identicamente nulli ($b = 0$ e $c = 0$), assumendo la forma canonica:

$$a x^2 = 0 \quad \text{con } a \in \mathbb{R}, \; a \neq 0$$

Dal punto di vista della geometria analitica, il polinomio $P(x) = ax^2$ rappresenta una parabola con vertice posizionato esattamente nell'origine degli assi cartesiani $V(0, 0)$ e asse di simmetria coincidente con l'asse delle ordinate $y$.

> **Insight:** Poiché il coefficiente $a$ non può essere nullo per la definizione stessa di secondo grado, l'unica grandezza variabile è $x^2$. Di conseguenza, la concavità della parabola dipende esclusivamente dal segno di $a$, ma la sua intersezione con l'asse orizzontale rimane invariabilmente ancorata nell'origine.

## Dimostrazione: Risoluzione dell'Equazione Monomia

### 1. Forma canonica e divisione per il primo coefficiente
$$a x^2 = 0 \iff x^2 = \frac{0}{a} = 0 \quad (a \neq 0)$$
> **Insight:** Il primo principio di equivalenza consente di dividere ambo i membri per il coefficiente non nullo a, isolando il monomio quadratico elementare.

### 2. Scomposizione per la legge di annullamento del prodotto
$$x^2 = 0 \iff x \cdot x = 0 \implies x_1 = 0 \quad \lor \quad x_2 = 0$$
> **Insight:** Il quadrato di un numero reale si annulla se e solo se la base è nulla, generando due fattori lineari identici.

### 3. Corollario: Molteplicità Algebrica e Tangenza nell'Origine
$$x_1 = x_2 = 0 \iff x = 0 \text{ con molteplicità algebrica } \mu = 2$$
> **Insight:** Un'equazione monomia ammette sempre e solo due radici reali coincidenti nell'origine: geometricamente l'asse x è la retta tangente al vertice della parabola.
