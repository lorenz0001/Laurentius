---
id: mat_riemann_01
title: "Integrale di Riemann e Somme di Rettangoli"
category: "Matematica"
subCategory: "Calcolo Integrale"
prerequisites:
  - mat_deriv_theorems_01
  - mat_limits_01
interactive:
  template: riemann_sum
  parameters: []
---

### Misurare l'Area sotto una Curva

Come possiamo calcolare con precisione l'area racchiusa sotto una curva non lineare?
Bernhard Riemann ebbe un'intuizione semplice ed elegante: suddividere la superficie complessa in tante piccole striscioline verticali rettangolari, facili da calcolare (base per altezza!).

Se dividiamo l'intervallo $[a, b]$ in $N$ parti uguali di ampiezza $\Delta x = \frac{b-a}{N}$, l'area totale approssimata è la somma delle aree dei singoli rettangoli:

$$S_N = \sum_{i=1}^N f(x_i^*) \cdot \Delta x$$

### Il Limite all'Infinito: La Somma Diventa Integrale

Cosa succede aumentando il numero $N$ di rettangoli all'infinito ($N \to \infty$ e $\Delta x \to 0$)?
I gradini e gli spazi vuoti tra la curva e i rettangoli svaniscono completamente: l'approssimazione diventa esatta e la sommatoria discreta diventa l'**integrale definito**:

$$\lim_{N \to \infty} \sum_{i=1}^N f(x_i^*) \Delta x = \int_a^b f(x) \, dx$$

> **Insight:** L'integrale è il cardine dell'accumulazione: permette di calcolare aree, volumi, lavoro fisico ed energia accumulata da forze variabili.

## Dimostrazione Logico-Algebrica

### 1. Partizione dell'intervallo [a, b] in N sotto-intervalli
$$a = x_0 < x_1 < x_2 < \dots < x_N = b, \quad \Delta x_i = x_i - x_{i-1}$$
> **Insight:** Discretizza il dominio per approssimare l'area con strisce rettangolari verticali.

### 2. Somma inferiore s(P) e somma superiore S(P) di Darboux-Riemann
$$s(P) = \sum_{i=1}^N \inf_{[x_{i-1}, x_i]} f(x) \Delta x_i, \quad S(P) = \sum_{i=1}^N \sup_{[x_{i-1}, x_i]} f(x) \Delta x_i$$
> **Insight:** L'area esatta è sempre racchiusa tra l'area a gradini per difetto e quella per eccesso.

### 3. Definizione di funzione Riemann-integrabile
$$\lim_{N \to \infty} \sum_{i=1}^N f(\xi_i) \Delta x = \int_a^b f(x) dx$$
> **Insight:** Al tendere di N all'infinito, le somme approssimanti convergono all'integrale definito di Riemann.

### 4. Corollario: Linearità dell'Integrale e Additività rispetto all'Intervallo
$$\int_a^b [\alpha f + \beta g] dx = \alpha \int_a^b f dx + \beta \int_a^b g dx \quad \land \quad \int_a^b f dx = \int_a^c f dx + \int_c^b f dx$$
> **Insight:** L'integrazione è un operatore lineare che preserva la sovrapposizione degli effetti fisici.
