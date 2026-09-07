---
id: mat_deriv_theorems_01
title: "Teoremi di Rolle, Lagrange e Criterio di Monotonia"
category: "Matematica"
subCategory: "Teoremi Differenziali"
prerequisites:
  - mat_deriv_rules_01
interactive:
  template: rolle_lagrange
  unit: ""
  equations:
    - "x * x * x / 3 - x"
  parameters:
    - variable: a
      label: "Estremo sinistro (a)"
      min: -2.4
      max: -0.2
      default: -1.8
      step: 0.1
    - variable: b
      label: "Estremo destro (b)"
      min: 0.2
      max: 2.4
      default: 1.4
      step: 0.1
---

### L'Intuizione dei Teoremi del Calcolo

Immagina di percorrere un tratto autostradale di 130 km in esattamente un'ora. La tua **velocità media** è stata di 130 km/h. Anche se hai accelerato o frenato, c'è stato sicuramente almeno un istante durante il viaggio in cui il tuo tachimetro segnava esattamente 130 km/h!

Questo principio intuitivo e fondamentale è il **Teorema del Valor Medio di Lagrange**: se una curva è continua e liscia, esiste sempre almeno un punto interno $c$ in cui la **pendenza istantanea** della tangente coincide con la pendenza media della corda secante:

$$f'(c) = \frac{f(b) - f(a)}{b - a}$$

### Il Teorema di Rolle: Tornare alla Stessa Quota

Cosa accade se gli estremi si trovano alla stessa altezza, ossia $f(a) = f(b)$?
Pensa a una palla lanciata verticalmente in aria: sale, raggiunge il punto di massima quota e ricade al punto di partenza. Nel punto più alto, per una frazione infinitesima di secondo, la palla si arresta prima di invertire la direzione: la sua velocità istantanea è zero!

Questo è il **Teorema di Rolle**: se $f(a) = f(b)$, esiste almeno un punto $c \in (a, b)$ in cui la tangente è orizzontale:

$$f'(c) = 0$$

> **Insight:** **Conseguenza Fondamentale (Criterio di Monotonia):**
> - Se $f'(x) > 0$, la funzione è strettamente crescente.
> - Se $f'(x) < 0$, la funzione è strettamente decrescente.
> - Se $f'(x) = 0$ ovunque, la funzione è costante ($f(x) = C$).

## Dimostrazione Logico-Algebrica

### 1. Teorema di Fermat sui punti estremanti interni
$$\frac{f(x_0+h)-f(x_0)}{h} \le 0 \text{ per } h>0 \quad \land \quad \ge 0 \text{ per } h<0 \implies f'(x_0) = 0$$
> **Insight:** Nei punti di massimo o minimo la retta tangente alla funzione deve essere orizzontale.

### 2. Teorema di Rolle
$$f(a) = f(b) \implies \exists c \in (a, b) : f'(c) = 0$$
> **Insight:** Se gli estremi coincidono, la funzione deve avere almeno un punto a derivata nulla.

### 3. Teorema del Valor Medio di Lagrange
$$\exists c \in (a, b) : f'(c) = \frac{f(b) - f(a)}{b - a}$$
> **Insight:** Esiste almeno un punto interno c in cui la retta tangente è perfettamente parallela alla retta secante passante per gli estremi.

### 4. Corollario: Criterio di Monotonia e Caratterizzazione delle Costanti
$$f'(x) \ge 0 \iff f(x) \text{ crescente} \quad \land \quad (f'(x) = 0 \implies f(x) = C)$$
> **Insight:** Il segno della derivata governa la crescita della funzione; se la derivata è identicamente nulla, la funzione è costante.
