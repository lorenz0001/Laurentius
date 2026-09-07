---
id: mat_pythagoras_01
title: "Teorema di Pitagora ed Euclide"
category: "Matematica"
subCategory: "Geometria Euclidea Piana"
prerequisites:
  - mat_triang_01
  - mat_binom_01
interactive:
  template: triangle_solver
  parameters: []
---

### Il Teorema di Pitagora

In ogni triangolo rettangolo, il quadrato costruito sull'ipotenusa è equivalente alla somma dei quadrati costruiti sui cateti.

Questo principio geometrico è alla base di tutta la **metrica euclidea** nello spazio a due e tre dimensioni.

$$a^2 + b^2 = c^2 \implies c = \sqrt{a^2 + b^2}$$

> **Insight:** Dal Teorema di Pitagora discendono direttamente i **Teoremi di Euclide**: l'altezza relativa all'ipotenusa è medio proporzionale tra le proiezioni dei cateti ($h^2 = p_1 \cdot p_2$).

## Dimostrazione Logico-Algebrica

### 1. Costruzione di un quadrato di lato (a+b)
$$\text{Area}_{\text{tot}} = (a + b)^2 = 4 \cdot \left(\frac{1}{2} a b\right) + c^2$$
> **Insight:** Dimostrazione algebrico-geometrica intuitiva basata sulla conservazione dell'area.

### 2. Espansione del binomio (a+b)^2 ed eguaglianza delle aree
$$a^2 + 2 a b + b^2 = 2 a b + c^2$$
> **Insight:** I 4 triangoli rettangoli occupano insieme un'area pari a 2ab.

### 3. Semplificazione algebrica del termine misto 2ab
$$a^2 + b^2 = c^2 \implies c = \sqrt{a^2 + b^2}$$
> **Insight:** In ogni triangolo rettangolo la somma delle aree dei quadrati sui cateti è uguale all'area del quadrato sull'ipotenusa.

### 4. Corollario: Primo e Secondo Teorema di Euclide
$$c_1^2 = i \cdot p_1 \quad \land \quad h^2 = p_1 \cdot p_2$$
> **Insight:** L'altezza relativa all'ipotenusa è medio proporzionale tra le proiezioni dei cateti (Euclide II).
