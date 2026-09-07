---
id: mat_frac_01
title: "Frazioni, Rapporti e Numeri Razionali"
category: "Matematica"
subCategory: "Frazioni e Rapporti"
prerequisites:
  - mat_mul_01
interactive:
  template: live_equation
  unit: ""
  equations:
    - "a / b"
  parameters:
    - variable: a
      label: "Numeratore (a)"
      min: -20.0
      max: 20.0
      default: 6.0
      step: 1.0
    - variable: b
      label: "Denominatore (b ≠ 0)"
      min: 1.0
      max: 20.0
      default: 8.0
      step: 1.0
---

### Frazioni e Numeri Razionali

Una **frazione** $\frac{a}{b}$ con $b \neq 0$ rappresenta la suddivisione di una quantità intera in parti uguali e introduce l'insieme dei numeri razionali $\mathbb{Q}$.

La divisione è l'operazione inversa della moltiplicazione: dividere per $b$ equivale a moltiplicare per il reciproco $\frac{1}{b}$.

$$\frac{a}{b} = a \cdot b^{-1} \quad (b \neq 0)$$

> **Insight:** Il rapporto tra due grandezze preserva l'invarianza per moltiplicazione o divisione comune: questa proprietà consente di ridurre ai minimi termini qualsiasi frazione.

## Dimostrazione Logico-Algebrica

### 1. Definizione di inverso moltiplicativo (reciproco)
$$\forall b \neq 0, \quad \exists b^{-1} = \frac{1}{b} : b \cdot \frac{1}{b} = 1$$
> **Insight:** La divisione a : b equivale alla moltiplicazione di a per l'inverso moltiplicativo di b.

### 2. Somma di frazioni mediante comune denominatore
$$\frac{a}{b} + \frac{c}{d} = \frac{a \cdot d}{b \cdot d} + \frac{c \cdot b}{d \cdot b} = \frac{a d + b c}{b d}$$
> **Insight:** Riconduce due partizioni a una scala metrica comune per consentirne la somma algebrica.

### 3. Moltiplicazione e divisione tra frazioni
$$\frac{a}{b} \cdot \frac{c}{d} = \frac{a c}{b d}, \quad \frac{a}{b} : \frac{c}{d} = \frac{a}{b} \cdot \frac{d}{c} = \frac{a d}{b c}$$
> **Insight:** Dividere per una frazione corrisponde a moltiplicare per la frazione invertita.

### 4. Corollario: Proprietà Invariantiva e Semplificazione di Frazioni
$$\frac{a \cdot k}{b \cdot k} = \frac{a}{b} \quad (k \neq 0)$$
> **Insight:** Moltiplicando o dividendo numeratore e denominatore per una stessa quantità non nulla il rapporto resta invariato.
