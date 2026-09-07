---
id: mat_mul_01
title: "Moltiplicazione e Proprietà Distributiva"
category: "Matematica"
subCategory: "Aritmetica e Fondamenti"
prerequisites:
  - mat_add_01
interactive:
  template: live_equation
  unit: ""
  equations:
    - "a * b"
  parameters:
    - variable: a
      label: "Fattore a"
      min: -10.0
      max: 10.0
      default: 4.0
      step: 1.0
    - variable: b
      label: "Fattore b"
      min: -10.0
      max: 10.0
      default: -3.0
      step: 1.0
---

### La Moltiplicazione e la Struttura Distributiva

La **moltiplicazione** estende l'addizione ripetuta e geometricamente quantifica l'area di un rettangolo di lati $a$ e $b$.

La proprietà cardine che connette moltiplicazione e addizione è la **distributività**:
$$a \cdot (b + c) = a \cdot b + a \cdot c$$

> **Insight:** La proprietà distributiva è il ponte tra le due operazioni fondamentali dell'aritmetica ed è alla base di ogni espansione polinomiale e fattorizzazione.

## Dimostrazione Logico-Algebrica

### 1. Definizione della moltiplicazione come addizione ripetuta
$$a \cdot b = \underbrace{a + a + \dots + a}_{b \text{ volte}} \quad (b \in \mathbb{N}^*)$$
> **Insight:** Rappresenta geometricamente l'area di un rettangolo di dimensioni a e b.

### 2. Proprietà distributiva rispetto all'addizione
$$a \cdot (b + c) = a \cdot b + a \cdot c$$
> **Insight:** Ponte fondamentale tra addizione e moltiplicazione; base di ogni sviluppo di prodotti polinomiali.

### 3. Dimostrazione della regola dei segni
$$(-a) \cdot (-b) + (-a \cdot b) = (-a) \cdot (-b + b) = (-a) \cdot 0 = 0$$
> **Insight:** Poiché sia (-a)*(-b) sia a*b sommati a (-a*b) danno 0, per unicità dell'opposto coincidono.

### 4. Corollario: Regola dei Segni e Legge di Annullamento del Prodotto
$$(-a) \cdot (-b) = + (a \cdot b) \quad \land \quad (a \cdot b = 0 \iff a = 0 \lor b = 0)$$
> **Insight:** L'annullamento del prodotto è il cardine algebrico per la risoluzione di ogni equazione polinomiale.
