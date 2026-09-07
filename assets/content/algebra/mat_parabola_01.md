---
id: mat_parabola_01
title: "Funzione Quadratica e Parabola"
category: "Matematica"
subCategory: "Funzioni e Geometria Analitica"
prerequisites:
  - mat_quad_eq_01
interactive:
  template: function_graph
  unit: ""
  equations:
    - "a * x * x + b * x + c"
  parameters:
    - variable: a
      label: "Curvatura (a)"
      min: -3.0
      max: 3.0
      default: 1.0
      step: 0.1
    - variable: b
      label: "Traslazione Orizzontale (b)"
      min: -4.0
      max: 4.0
      default: 0.0
      step: 0.2
    - variable: c
      label: "Intercetta Verticale (c)"
      min: -5.0
      max: 5.0
      default: -2.0
      step: 0.5
---

### Funzione Quadratica e Parabola

La **parabola** con asse di simmetria parallelo all'asse delle ordinate è il luogo dei punti del piano cartesiano rappresentato dall'equazione $y = ax^2 + bx + c$ ($a \neq 0$).

Le proprietà geometriche principali sono:
- Il segno di $a$ determina la concavità: verso l'alto se $a > 0$, verso il basso se $a < 0$.
- Il coefficiente $c$ corrisponde all'ordinata del punto di intersezione con l'asse $y$.
- Il vertice $V$ rappresenta il punto di estremo (minimo o massimo) assoluto della funzione.

$$y = a \left(x + \frac{b}{2a}\right)^2 - \frac{\Delta}{4a}$$

> **Insight:** La parabola è la traiettoria universale descritta da qualsiasi corpo in moto balistico sotto l'azione della gravità terrestre costante.

## Dimostrazione Logico-Algebrica

### 1. Forma canonica polinomiale di secondo grado sul piano cartesiano
$$y = a x^2 + b x + c \quad (a \neq 0)$$
> **Insight:** Il coefficiente quadratico a governa l'apertura e il verso della concavità.

### 2. Completamento del quadrato per individuare la traslazione del vertice
$$y = a \left(x + \frac{b}{2a}\right)^2 - \frac{b^2 - 4 a c}{4 a}$$
> **Insight:** La forma vertice y - y_V = a(x - x_V)^2 esplicita l'origine traslata.

### 3. Corollario: Coordinate del Vertice, Asse di Simmetria e Fuoco
$$V = \left(-\frac{b}{2a}, -\frac{\Delta}{4a}\right), \quad x = -\frac{b}{2a}, \quad F = \left(-\frac{b}{2a}, \frac{1-\Delta}{4a}\right)$$
> **Insight:** Individua l'apice della traiettoria nei moti balistici e la proprietà focale riflettente della parabola.
