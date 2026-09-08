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

## Dimostrazione: Costruzione dell'Integrale Definito di Riemann

### 1. Partizione dell'intervallo [a, b] in N sotto-intervalli
$$a = x_0 < x_1 < x_2 < \dots < x_N = b, \quad \Delta x_i = x_i - x_{i-1}$$
> **Insight:** Discretizza il dominio continuo per approssimare la superficie mediante strisce rettangolari verticali.

### 2. Somma inferiore s(P) e somma superiore S(P) di Darboux-Riemann
$$s(P) = \sum_{i=1}^N \inf_{[x_{i-1}, x_i]} f(x) \Delta x_i, \quad S(P) = \sum_{i=1}^N \sup_{[x_{i-1}, x_i]} f(x) \Delta x_i$$
> **Insight:** L'area sottesa esatta è geometricamente intrappolata tra l'area dei plurirettangoli inscritti per difetto e quella per eccesso.

### 3. Definizione di funzione Riemann-integrabile
$$\lim_{\|P\| \to 0} s(P) = \lim_{\|P\| \to 0} S(P) \equiv \int_a^b f(x) \, dx$$
> **Insight:** Quando l'ampiezza massima delle strisce tende a zero, le somme per difetto e per eccesso collassano su un unico valore reale: l'integrale definito di Riemann.

## Dimostrazione: Corollario - Linearità dell'Integrale di Riemann

### 1. Impostazione della combinazione lineare nelle somme di Riemann
Siano $f, g$ due funzioni integrabili su $[a, b]$ e siano $\alpha, \beta \in \mathbb{R}$ due costanti scalari. Consideriamo una partizione $P$ con nodi campione $\xi_i \in [x_{i-1}, x_i]$:
$$S(P, \alpha f + \beta g) = \sum_{i=1}^N [\alpha f(\xi_i) + \beta g(\xi_i)] \Delta x_i$$
> **Insight:** Si costruisce la somma di Riemann approssimante per la combinazione lineare ponderata delle due funzioni.

### 2. Proprietà distributiva e commutativa della sommatoria finita
Sfruttando la linearità algebrica delle sommatorie a numero finito di termini:
$$\sum_{i=1}^N [\alpha f(\xi_i) + \beta g(\xi_i)] \Delta x_i = \sum_{i=1}^N \alpha f(\xi_i) \Delta x_i + \sum_{i=1}^N \beta g(\xi_i) \Delta x_i = \alpha \sum_{i=1}^N f(\xi_i) \Delta x_i + \beta \sum_{i=1}^N g(\xi_i) \Delta x_i$$
> **Insight:** Le costanti scalari possono essere fattorizzate all'esterno di ciascuna sommatoria parziale.

### 3. Passaggio al limite per finezza della partizione tendente a zero
Prendiamo il limite per il parametro di finezza $\|P\| = \max \Delta x_i \to 0$:
$$\lim_{\|P\| \to 0} S(P, \alpha f + \beta g) = \alpha \lim_{\|P\| \to 0} \left( \sum_{i=1}^N f(\xi_i) \Delta x_i \right) + \beta \lim_{\|P\| \to 0} \left( \sum_{i=1}^N g(\xi_i) \Delta x_i \right)$$
> **Insight:** Il limite della somma algebrica converge alla combinazione lineare dei singoli limiti finiti garantiti dall'integrabilità di f e g.

### 4. Formulazione definitiva della linearità integrale
Sostituendo la definizione dell'operatore integrale di Riemann:
$$\int_a^b [\alpha f(x) + \beta g(x)] \, dx = \alpha \int_a^b f(x) \, dx + \beta \int_a^b g(x) \, dx$$
> **Insight:** Corollario: l'integrazione definita è un operatore funzionale lineare; preserva la sovrapposizione degli effetti fisici e il calcolo differenziato dei contributi energetici.

## Dimostrazione: Corollario - Additività dell'Integrale rispetto all'Intervallo

### 1. Decomposizione dell'intervallo con un punto intermedio
Sia $c \in (a, b)$ un punto interno. Consideriamo una partizione $P_1$ del sotto-intervallo $[a, c]$ avente $N_1$ elementi e una partizione $P_2$ di $[c, b]$ con $N_2$ elementi:
$$P = P_1 \cup P_2 = \{x_0, x_1, \dots, x_{N_1} = c, x_{N_1+1}, \dots, x_{N_1+N_2} = b\}$$
> **Insight:** L'unione delle due partizioni indipendenti genera una partizione globale compatibile dell'intero intervallo [a, b].

### 2. Spezzamento della sommatoria di Riemann
Scriviamo la somma integrale di Riemann globale su $P$:
$$\sum_{i=1}^{N_1 + N_2} f(\xi_i) \Delta x_i = \sum_{j=1}^{N_1} f(\xi_j) \Delta x_j + \sum_{k=N_1+1}^{N_1 + N_2} f(\xi_k) \Delta x_k$$
> **Insight:** La sommatoria su tutti i rettangoli si suddivide esattamente nella somma dei rettangoli a sinistra di c e dei rettangoli a destra di c.

### 3. Passaggio al limite per le partizioni parziali
Facendo tendere a zero la finezza delle partizioni $\|P_1\| \to 0$ e $\|P_2\| \to 0$ simultaneamente:
$$\lim_{\|P\| \to 0} \sum_{i=1}^{N_1 + N_2} f(\xi_i) \Delta x_i = \lim_{\|P_1\| \to 0} \sum_{j=1}^{N_1} f(\xi_j) \Delta x_j + \lim_{\|P_2\| \to 0} \sum_{k=N_1+1}^{N_1 + N_2} f(\xi_k) \Delta x_k$$
> **Insight:** La convergenza di Riemann su ciascun sottodominio è indipendente e preserva l'identità algebrica al limite.

### 4. Deduzione della formula di additività dell'integrale
Sostituendo gli integrali definiti corrispondenti:
$$\int_a^b f(x) \, dx = \int_a^c f(x) \, dx + \int_c^b f(x) \, dx$$
> **Insight:** Corollario fondamentale: l'area totale è la somma diretta delle aree parziali adiacenti; la proprietà si estende a qualunque terna a, b, c ponendo ∫_b^a f = - ∫_a^b f.
