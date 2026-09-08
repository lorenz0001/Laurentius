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

## Dimostrazione: Proprietà Fondamentali della Moltiplicazione e Distributività

### 1. Definizione della moltiplicazione come addizione ripetuta
$$a \cdot b = \underbrace{a + a + \dots + a}_{b \text{ volte}} \quad (b \in \mathbb{N}^*)$$
> **Insight:** Rappresenta geometricamente l'area di un rettangolo di dimensioni a e b sul piano continuo.

### 2. Proprietà distributiva rispetto all'addizione
$$a \cdot (b + c) = a \cdot b + a \cdot c$$
> **Insight:** Ponte algebrico fondamentale tra addizione e moltiplicazione, alla base di ogni espansione polinomiale.

### 3. Proprietà di annullamento per moltiplicazione per zero
$$a \cdot 0 = a \cdot (0 + 0) = a \cdot 0 + a \cdot 0 \implies a \cdot 0 = 0$$
> **Insight:** Sottraendo a*0 da ambo i membri segue che lo zero è l'elemento assorbente della moltiplicazione.

## Dimostrazione: Corollario - Regola dei Segni per Numeri Relativi

### 1. Prodotto di un numero positivo per l'opposto
Consideriamo il prodotto $a \cdot (-b)$ con $a, b > 0$. Sfruttando la proprietà distributiva su $(b + (-b)) = 0$:
$$a \cdot (b + (-b)) = a \cdot 0 = 0 \iff a \cdot b + a \cdot (-b) = 0$$
> **Insight:** Poiché la somma di a*b e a*(-b) è zero, a*(-b) è per definizione l'opposto di a*b: $a \cdot (-b) = -(a \cdot b)$.

### 2. Sviluppo del prodotto tra opposti (-a) e la somma nulla
Applichiamo la distributività al prodotto tra l'opposto $(-a)$ e la somma nulla $(b + (-b))$:
$$(-a) \cdot (b + (-b)) = (-a) \cdot 0 = 0 \iff (-a) \cdot b + (-a) \cdot (-b) = 0$$
> **Insight:** La somma tra (-a)*b e (-a)*(-b) deve uguagliare identicamente zero per assorbimento dello zero.

### 3. Sostituzione dell'opposto misto ed elisione
Dal passaggio precedente sappiamo che $(-a) \cdot b = -(a \cdot b)$. Sostituendo nell'equazione:
$$-(a \cdot b) + (-a) \cdot (-b) = 0$$
> **Insight:** Sommiamo +(a*b) ad ambo i membri per isolare il prodotto dei due numeri negativi.

### 4. Corollario: La Regola dei Segni
Isolando algebricamente il prodotto $(-a) \cdot (-b)$:
$$(-a) \cdot (-b) = + (a \cdot b)$$
> **Insight:** Il prodotto di due numeri negativi è rigorosamente un numero positivo, preservando la coerenza logica della distributività.

## Dimostrazione: Corollario - Legge di Annullamento del Prodotto

### 1. Ipotesi del prodotto nullo con fattore non nullo
Siano $a, b \in \mathbb{R}$ tali che $a \cdot b = 0$. Supponiamo senza perdita di generalità che $a \neq 0$:
$$a \cdot b = 0 \quad \text{con } a \neq 0$$
> **Insight:** Vogliamo dimostrare che se il primo fattore non è zero, il secondo fattore deve necessariamente annullarsi.

### 2. Moltiplicazione a sinistra per l'inverso moltiplicativo
Poiché $a \neq 0$, nel campo reale esiste l'inverso moltiplicativo $a^{-1} = \frac{1}{a}$. Moltiplichiamo ambo i membri per $a^{-1}$:
$$a^{-1} \cdot (a \cdot b) = a^{-1} \cdot 0$$
> **Insight:** Il principio di equivalenza moltiplicativo mantiene intatta la relazione d'uguaglianza.

### 3. Riorganizzazione per proprietà associativa e assorbimento dello zero
Applicando la proprietà associativa della moltiplicazione al primo membro e l'assorbimento dello zero al secondo membro:
$$(a^{-1} \cdot a) \cdot b = 0 \iff 1 \cdot b = 0$$
> **Insight:** Il prodotto tra un elemento e il proprio reciproco è per assioma l'elemento neutro unitario 1.

### 4. Corollario: Deduzione della Legge di Annullamento del Prodotto
Poiché $1 \cdot b = b$, concludiamo che $b = 0$. Generalizzando a fattori arbitrari:
$$a \cdot b = 0 \iff a = 0 \quad \lor \quad b = 0$$
> **Insight:** Un prodotto di numeri reali è zero se e solo se almeno uno dei fattori è nullo: pilastro algebrico per la risoluzione di ogni equazione polinomiale.
