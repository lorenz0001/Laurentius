---
id: mat_triang_01
title: "Geometria del Triangolo e Angoli Interni"
category: "Matematica"
subCategory: "Geometria Euclidea Piana"
prerequisites:
  - mat_add_01
interactive:
  template: triangle_solver
  parameters: []
---

### Perché la Somma degli Angoli Interni è Sempre 180°?

Prendi un triangolo qualsiasi, anche scaleno o allungato. Se tracciamo una linea retta parallela alla base che tocca appena il vertice superiore, accade una meraviglia geometrica:
- I due angoli alla base si riflettono esattamente in alto grazie alla proprietà degli **angoli alterni interni**.
- Insieme all'angolo del vertice, i tre angoli si incastrano perfettamente uno accanto all'altro formando una linea dritta: un angolo piatto di $180^\circ$ ($\pi$ radianti)!

$$\alpha + \beta + \gamma = 180^\circ = \pi \text{ rad}$$

> **Insight:** **Teorema dell'Angolo Esterno:** In qualunque triangolo, l'ampiezza di ciascun angolo esterno è esattamente uguale alla somma dei due angoli interni non adiacenti: $\delta = \alpha + \beta$.

## Dimostrazione Logico-Algebrica

### 1. Tracciamento della retta parallela alla base passante per il vertice opposto
$$r \parallel AB \quad \text{passante per } C$$
> **Insight:** Costruzione euclidea classica per applicare le proprietà degli angoli alterni interni.

### 2. Eguaglianza degli angoli alterni interni formati dalle trasversali AC e BC
$$\alpha' = \alpha \quad \land \quad \beta' = \beta$$
> **Insight:** Gli angoli adiacenti al vertice C formano con gamma un angolo piatto di 180°.

### 3. Somma degli angoli sul vertice C che formano l'angolo piatto
$$\alpha' + \gamma + \beta' = 180^\circ \implies \alpha + \beta + \gamma = 180^\circ = \pi \text{ rad}$$
> **Insight:** Teorema fondamentale della geometria euclidea piana.

### 4. Corollario: Teorema dell'Angolo Esterno
$$\delta_{\text{ext}} = 180^\circ - \gamma = \alpha + \beta$$
> **Insight:** In qualunque triangolo, ogni angolo esterno ha ampiezza esattamente pari alla somma dei due interni non adiacenti.
