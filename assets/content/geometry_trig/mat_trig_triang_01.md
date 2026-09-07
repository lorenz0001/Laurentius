---
id: mat_trig_triang_01
title: "Teoremi dei Triangoli: Carnot, Seni e Formula dell'Area"
category: "Matematica"
subCategory: "Trigonometria dei Triangoli"
prerequisites:
  - mat_trig_add_01
  - mat_pythagoras_01
interactive:
  template: triangle_solver
  parameters: []
---

### Risoluzione dei Triangoli Qualsiasi: Carnot e Seni

Mentre il Teorema di Pitagora si applica esclusivamente ai triangoli rettangoli, la trigonometria consente di risolvere qualsiasi triangolo obliquo mediante il **Teorema del Coseno** (o di Carnot):

$$c^2 = a^2 + b^2 - 2ab \cos\gamma$$

Quando l'angolo $\gamma = 90^\circ$, il termine $-2ab\cos(90^\circ)$ svanisce, riducendosi esattamente a $c^2 = a^2 + b^2$.

> **Insight:** Il Teorema dei Seni $\frac{a}{\sin\alpha} = \frac{b}{\sin\beta} = \frac{c}{\sin\gamma} = 2R$ connette i lati del triangolo al diametro $2R$ della circonferenza circoscritta.

## Dimostrazione Logico-Algebrica

### 1. Tracciamento dell'altezza in un triangolo qualunque
$$h = b \sin\gamma, \quad x = b \cos\gamma \implies \text{base rimanente: } (a - x) = a - b \cos\gamma$$
> **Insight:** Proietta il lato b sulla base a usando seno e coseno dell'angolo compreso γ.

### 2. Applicazione di Pitagora al secondo triangolo rettangolo
$$c^2 = h^2 + (a - b \cos\gamma)^2 = (b \sin\gamma)^2 + a^2 - 2 a b \cos\gamma + b^2 \cos^2\gamma$$
> **Insight:** Sviluppando il quadrato del binomio e raccogliendo b²(sin²γ + cos²γ) = b².

### 3. Teorema di Carnot (o del Coseno)
$$c^2 = a^2 + b^2 - 2 a b \cos\gamma$$
> **Insight:** Se γ = 90°, cos(90°) = 0 e la formula restituisce esattamente il Teorema di Pitagora c² = a² + b².

### 4. Corollario: Teorema dei Seni e Formula Goniometrica dell'Area
$$\frac{a}{\sin\alpha} = \frac{b}{\sin\beta} = \frac{c}{\sin\gamma} = 2 R \quad \land \quad \text{Area} = \frac{1}{2} a b \sin\gamma$$
> **Insight:** Il Teorema dei Seni lega i lati al raggio R della circonferenza circoscritta; l'area si calcola con due lati e il seno dell'angolo compreso.
