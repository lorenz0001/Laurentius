---
id: mat_binom_01
title: "Prodotti Notevoli e Scomposizioni"
category: "Matematica"
subCategory: "Polinomi e Prodotti Notevoli"
prerequisites:
  - mat_pow_01
interactive:
  template: live_equation
  unit: ""
  equations:
    - "a * a + 2 * a * b + b * b"
  parameters:
    - variable: a
      label: "Termine a"
      min: -5.0
      max: 5.0
      default: 2.0
      step: 0.5
    - variable: b
      label: "Termine b"
      min: -5.0
      max: 5.0
      default: 3.0
      step: 0.5
---

### Espansione Polinomiale e Geometria dei Prodotti

I **prodotti notevoli** sono identità algebriche fondamentali che abbreviano il calcolo del prodotto tra polinomi.

Il quadrato di un binomio $(a + b)^2$ descrive la suddivisione geometrica di un quadrato di lato $a+b$ in 4 regioni:
- Un quadrato grande di area $a^2$
- Un quadrato piccolo di area $b^2$
- Due rettangoli uguali di area $a \cdot b$

Sommando le 4 aree si ottiene la formula esatta: $(a+b)^2 = a^2 + 2ab + b^2$.

$$(a + b)^2 = a^2 + 2ab + b^2$$

> **Insight:** La celebre differenza di quadrati $(a+b)(a-b) = a^2 - b^2$ annulla simmetricamente i termini misti $(+ab)$ e $(-ab)$, costituendo il fondamento per la razionalizzazione dei denominatori.

## Dimostrazione Logico-Algebrica

### 1. Sviluppo del quadrato di un binomio applicando la proprietà distributiva
$$(a + b)^2 = (a + b)(a + b) = a^2 + a b + b a + b^2 = a^2 + 2 a b + b^2$$
> **Insight:** Geometricamente rappresenta l'area di un quadrato di lato (a+b) suddiviso in due quadrati e due rettangoli uguali.

### 2. Sviluppo della differenza di quadrati
$$(a + b)(a - b) = a^2 - a b + b a - b^2 = a^2 - b^2$$
> **Insight:** I termini misti (+ab e -ab) si annullano perfettamente per simmetria opposta.

### 3. Cubo di binomio ed espansione
$$(a + b)^3 = a^3 + 3 a^2 b + 3 a b^2 + b^3$$
> **Insight:** I coefficienti (1, 3, 3, 1) corrispondono alla riga 3 del Triangolo di Tartaglia.

### 4. Corollario: Somma e Differenza di Cubi e Binomio di Newton
$$a^3 \pm b^3 = (a \pm b)(a^2 \mp a b + b^2) \quad \land \quad (a+b)^n = \sum_{k=0}^n \binom{n}{k} a^{n-k} b^k$$
> **Insight:** Permette di scomporre istantaneamente polinomi di terzo grado e sviluppare potenze ennesime.
