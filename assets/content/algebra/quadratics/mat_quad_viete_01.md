---
id: mat_quad_viete_01
title: "Relazioni di Viète, Scomposizione e Regola di Cartesio"
category: "Matematica"
subCategory: "Equazioni di Secondo Grado"
prerequisites:
  - mat_quad_eq_01
interactive:
  template: live_equation
  unit: ""
  equations:
    - "-b / a"
  parameters:
    - variable: a
      label: "Coeff. a"
      min: -5.0
      max: 5.0
      default: 1.0
      step: 0.5
    - variable: b
      label: "Coeff. b"
      min: -10.0
      max: 10.0
      default: -5.0
      step: 0.5
    - variable: c
      label: "Coeff. c"
      min: -10.0
      max: 10.0
      default: 6.0
      step: 0.5
---

### Relazioni tra Radici e Coefficienti: Viète, Fattorizzazione e Cartesio

Le celebri relazioni stabilite dal matematico francese François Viète collegano direttamente le soluzioni $x_1$ e $x_2$ di un'equazione di secondo grado $ax^2 + bx + c = 0$ ai suoi coefficienti, senza richiedere il calcolo esplicito della radice quadrata del discriminante:

$$s = x_1 + x_2 = -\frac{b}{a}, \qquad p = x_1 \cdot x_2 = \frac{c}{a}$$

Queste relazioni costituiscono lo strumento cardine per la scomposizione in fattori dei trinomi, la determinazione di due numeri nota la loro somma e il loro prodotto, e lo studio qualitativo dei segni delle soluzioni tramite la storica **Regola di Cartesio**.

> **Insight:** Se l'equazione è monica ($a = 1$), la somma delle radici è semplicemente l'opposto del coefficiente di primo grado ($-b$), mentre il prodotto coincide esattamente con il termine noto ($c$): $x^2 - sx + p = 0$.

## Dimostrazione: Formule di Viète (Somma e Prodotto delle Radici)

### 1. Calcolo esplicito della somma delle radici
$$x_1 + x_2 = \frac{-b - \sqrt{\Delta}}{2a} + \frac{-b + \sqrt{\Delta}}{2a} = \frac{-2b}{2a} = -\frac{b}{a}$$
> **Insight:** I termini irrazionali contenenti la radice di Delta hanno segni opposti e si cancellano perfettamente nell'addizione.

### 2. Calcolo algebrico del prodotto delle radici
$$x_1 \cdot x_2 = \frac{(-b - \sqrt{\Delta})(-b + \sqrt{\Delta})}{4a^2} = \frac{(-b)^2 - (\sqrt{\Delta})^2}{4a^2} = \frac{b^2 - (b^2 - 4ac)}{4a^2} = \frac{4ac}{4a^2} = \frac{c}{a}$$
> **Insight:** Il prodotto algebrico si sviluppa come differenza di quadrati, semplificando il fattore 4a a numeratore e denominatore.

### 3. Corollario: Equazione Parametrica Noti Somma e Prodotto
$$x^2 - s x + p = 0 \quad \text{con } s = x_1 + x_2, \; p = x_1 \cdot x_2$$
> **Insight:** Permette di ricostruire all'istante l'equazione quadratica conoscendo unicamente la somma e il prodotto di due numeri incogniti.

## Dimostrazione: Scomposizione in Fattori del Trinomio di Secondo Grado

### 1. Divisione per il primo coefficiente e sostituzione delle relazioni di Viète
$$ax^2 + bx + c = a\left(x^2 + \frac{b}{a}x + \frac{c}{a}\right) = a\left(x^2 - (x_1 + x_2)x + x_1 x_2\right)$$
> **Insight:** Il primo coefficiente a viene raccolto a fattor comune, permettendo di sostituire b/a con -(x1 + x2) e c/a con x1*x2.

### 2. Sviluppo e raggruppamento parziale a fattor comune
$$x^2 - x_1 x - x_2 x + x_1 x_2 = x(x - x_1) - x_2(x - x_1) = (x - x_1)(x - x_2)$$
> **Insight:** Il binomio (x - x1) emerge come fattore comune evidente tra i primi due e gli ultimi due termini.

### 3. Corollario: Teorema di Scomposizione Lineare del Trinomio
$$a x^2 + b x + c = a (x - x_1)(x - x_2) \quad (\text{se } \Delta \ge 0)$$
> **Insight:** Qualsiasi trinomio quadratico con discriminante non negativo si fattorizza nel prodotto del coefficiente a per i binomi lineari delle radici.

## Dimostrazione: Regola dei Segni di Cartesio

### 1. Definizione di permanenza e variazione di segno
$$\text{Permanenza: due segni consecutivi concordi } (+, +) \text{ o } (-, -); \quad \text{Variazione: due segni discordi } (+, -) \text{ o } (-, +)$$
> **Insight:** L'analisi si effettua sulla terna ordinata dei coefficienti (a, b, c).

### 2. Studio dei segni della somma e del prodotto
$$p = \frac{c}{a} > 0 \implies x_1, x_2 \text{ concordi}; \quad p = \frac{c}{a} < 0 \implies x_1, x_2 \text{ discordi}$$
> **Insight:** Il segno del prodotto p stabilisce se le radici hanno lo stesso segno o segno opposto; il segno della somma s stabilisce se prevale la radice positiva o negativa.

### 3. Corollario: Teorema dei Segni di Cartesio per Equazioni di 2° Grado
$$\text{A ogni variazione corrisponde una radice positiva } (x > 0); \quad \text{A ogni permanenza corrisponde una radice negativa } (x < 0)$$
> **Insight:** Permette di dedurre a priori e con assoluta certezza i segni delle soluzioni reali prima ancora di intraprendere qualsiasi calcolo algebrico.
