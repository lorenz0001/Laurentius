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

## Dimostrazione: Prodotti Notevoli Fondamentali

### 1. Sviluppo del quadrato di un binomio applicando la proprietà distributiva
$$(a + b)^2 = (a + b)(a + b) = a^2 + a b + b a + b^2 = a^2 + 2 a b + b^2$$
> **Insight:** Geometricamente rappresenta l'area di un quadrato di lato (a+b) suddiviso in due quadrati e due rettangoli uguali.

### 2. Sviluppo della differenza di quadrati
$$(a + b)(a - b) = a^2 - a b + b a - b^2 = a^2 - b^2$$
> **Insight:** I termini misti (+ab e -ab) si annullano perfettamente per simmetria opposta.

### 3. Cubo di binomio ed espansione algebrica
$$(a + b)^3 = (a + b)^2(a + b) = (a^2 + 2ab + b^2)(a + b) = a^3 + 3 a^2 b + 3 a b^2 + b^3$$
> **Insight:** I coefficienti (1, 3, 3, 1) corrispondono alla riga 3 del Triangolo di Tartaglia.

## Dimostrazione: Corollario - Scomposizione di Somma e Differenza di Cubi

### 1. Ipotesi del prodotto tra binomio e falso quadrato
Consideriamo l'espressione algebrica formata dal prodotto di un binomio per il rispettivo trinomio falso quadrato:
$$P_\pm = (a \pm b)(a^2 \mp a b + b^2)$$
> **Insight:** Vogliamo verificare se l'espansione di questo prodotto elimini tutti i termini intermedi di secondo grado.

### 2. Applicazione della proprietà distributiva termine a termine
Sviluppiamo il prodotto moltiplicando ciascun termine del binomio per il trinomio:
$$P_\pm = a \cdot (a^2 \mp a b + b^2) \pm b \cdot (a^2 \mp a b + b^2)$$
$$P_\pm = (a^3 \mp a^2 b + a b^2) \pm (a^2 b \mp a b^2 + b^3)$$
> **Insight:** La moltiplicazione produce sei termini monomiali distinti.

### 3. Semplificazione algebrica ed elisione dei termini misti
Riorganizzando i termini simili e sommando gli opposti:
$$P_\pm = a^3 + (\mp a^2 b \pm a^2 b) + (a b^2 - a b^2) \pm b^3 = a^3 + 0 + 0 \pm b^3$$
> **Insight:** I termini misti incrociati di secondo grado si cancellano perfettamente per simmetria dei segni.

### 4. Corollario: Identità di Fattorizzazione dei Cubi
Riconoscendo l'identità fondamentale nei due casi di segno:
$$a^3 \pm b^3 = (a \pm b)(a^2 \mp ab + b^2)$$
> **Insight:** Permette di scomporre istantaneamente la somma o la differenza di cubi nel prodotto di un binomio lineare per un trinomio irriducibile in R (falso quadrato).

## Dimostrazione: Corollario - Teorema del Binomio di Newton

### 1. Espansione combinatoria del prodotto di n binomi identici
Consideriamo la potenza $n$-esima del binomio come moltiplicazione iterata di $n$ fattori:
$$(a + b)^n = \underbrace{(a + b)(a + b) \dots (a + b)}_{n \text{ fattori}}$$
> **Insight:** Ogni singolo monomio nello sviluppo finale si ottiene scegliendo 'a' oppure 'b' da ciascuno degli n fattori.

### 2. Determinazione della struttura dei monomi e conteggio combinatorio
Moltiplicando le scelte, ciascun monomio generato assume la forma $a^{n-k} b^k$, dove $k$ è il numero di volte in cui è stato selezionato il termine $b$:
$$\text{Numero di scelte per } k \text{ fattori } b \text{ su } n \text{ disponibili} = \binom{n}{k}$$
> **Insight:** Il coefficiente coincide esattamente con le combinazioni semplici di n elementi presi a k a k.

### 3. Formulazione esplicita del coefficiente binomiale
Il coefficiente binomiale è definito algebricamente tramite i fattoriali:
$$\binom{n}{k} = \frac{n!}{k!(n - k)!} \quad \text{con } 0 \le k \le n$$
> **Insight:** Questi coefficienti formano gli elementi della riga n-esima del Triangolo di Tartaglia/Pascal.

### 4. Corollario: Formula Generale del Binomio di Newton
Sommando tutti i monomi distinti al variare dell'indice $k$ da $0$ a $n$:
$$(a + b)^n = \sum_{k=0}^n \binom{n}{k} a^{n-k} b^k$$
> **Insight:** Fornisce la formula chiusa universale per sviluppare qualsiasi potenza naturale di un binomio senza eseguire moltiplicazioni manuali a catena.
