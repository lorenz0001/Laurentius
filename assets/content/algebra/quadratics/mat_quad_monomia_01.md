---
id: mat_quad_monomia_01
title: "Equazioni di Secondo Grado Monomie"
category: "Matematica"
subCategory: "Equazioni di Secondo Grado"
prerequisites:
  - mat_mul_01
  - mat_pow_01
interactive:
  template: function_graph
  unit: ""
  equations:
    - "a * x * x"
  parameters:
    - variable: a
      label: "Coeff. a"
      min: -3.0
      max: 3.0
      default: 1.0
      step: 0.5
---

### Equazioni di Secondo Grado Monomie: Forma Fondamentale

Un'equazione algebrica di secondo grado si definisce **monomia** quando sia il coefficiente di primo grado sia il termine noto sono identicamente nulli ($b = 0$ e $c = 0$), assumendo la forma canonica:

$$a x^2 = 0 \quad \text{con } a \in \mathbb{R}, \; a \neq 0$$

Dal punto di vista della geometria analitica, il polinomio $P(x) = ax^2$ rappresenta una parabola con vertice posizionato esattamente nell'origine degli assi cartesiani $V(0, 0)$ e asse di simmetria coincidente con l'asse delle ordinate $y$.

> **Insight:** Poiché il coefficiente $a$ non può essere nullo per la definizione stessa di secondo grado, l'unica grandezza variabile è $x^2$. Di conseguenza, la concavità della parabola dipende esclusivamente dal segno di $a$, ma la sua intersezione con l'asse orizzontale rimane invariabilmente ancorata nell'origine.

## Dimostrazione: Risoluzione dell'Equazione Monomia

### 1. Forma canonica e divisione per il primo coefficiente
$$a x^2 = 0 \iff x^2 = \frac{0}{a} = 0 \quad (a \neq 0)$$
> **Insight:** Il primo principio di equivalenza consente di dividere ambo i membri per il coefficiente non nullo a, isolando il monomio quadratico elementare.

### 2. Scomposizione per la legge di annullamento del prodotto
$$x^2 = 0 \iff x \cdot x = 0 \implies x_1 = 0 \quad \lor \quad x_2 = 0$$
> **Insight:** Il quadrato di un numero reale si annulla se e solo se la base è nulla, generando due fattori lineari identici.

## Dimostrazione: Corollario - Molteplicità Algebrica e Tangenza nell'Origine

### 1. Ipotesi delle due radici coincidenti
Dalla scomposizione in fattori lineari $x \cdot x = 0$, otteniamo le soluzioni distinte in apparenza ma coincidenti in valore:
$$x_1 = 0 \quad \land \quad x_2 = 0$$
> **Insight:** Vogliamo quantificare la molteplicità algebrica dell'azzeramento del polinomio quadratico.

### 2. Fattorizzazione del polinomio mediante binomi lineari
Per il Teorema Fondamentale dell'Algebra, il polinomio $P(x) = ax^2$ si esprime come prodotto con le sue radici:
$$P(x) = a(x - x_1)(x - x_2) = a(x - 0)(x - 0) = a(x - 0)^2$$
> **Insight:** L'esponente 2 associato al binomio lineare (x - 0) definisce rigorosamente la molteplicità algebrica mu = 2.

### 3. Calcolo analitico della pendenza della retta tangente
Valutando il limite del rapporto incrementale (o la derivata prima) della parabola $y = ax^2$ nell'origine $x = 0$:
$$m_{\text{tg}} = \lim_{h \to 0} \frac{a(0 + h)^2 - a(0)^2}{h} = \lim_{h \to 0} \frac{a h^2}{h} = \lim_{h \to 0} (ah) = 0$$
> **Insight:** Il coefficiente angolare della tangente è nullo: la tangente è una retta perfettamente orizzontale.

### 4. Corollario: Tangenza all'Asse delle Ascisse nel Vertice
Poiché la retta tangente ha equazione $y - 0 = 0 \cdot (x - 0) \iff y = 0$, essa coincide con l'asse $x$:
$$x_1 = x_2 = 0 \iff x = 0 \text{ con molteplicità algebrica } \mu = 2$$
> **Insight:** L'asse delle ascisse è la retta tangente al vertice della parabola nell'origine O(0,0), confermando geometricamente la molteplicità doppia della radice.

## Dimostrazione: Corollario - Segno Costante del Monomio e Unicità dello Zero

### 1. Ipotesi di variabile reale non nulla
Consideriamo la funzione quadratica monomia $P(x) = ax^2$ valutata su qualsiasi $x \in \mathbb{R}$ con $x \neq 0$:
$$x \neq 0 \implies x^2 > 0$$
> **Insight:** Nel campo reale il quadrato di qualsiasi numero diverso da zero è strettamente positivo.

### 2. Prodotto per il coefficiente direttivo non nullo a
Moltiplicando la disuguaglianza stretta per il coefficiente costante $a \neq 0$:
$$\text{Se } a > 0 \implies a x^2 > 0; \qquad \text{Se } a < 0 \implies a x^2 < 0$$
> **Insight:** Il segno della funzione è interamente determinato dal solo segno del parametro a.

### 3. Esclusione di radici secondarie fuori dall'origine
Poiché per ogni $x \neq 0$ si ha $ax^2 \neq 0$:
$$P(x) = 0 \iff x = 0$$
> **Insight:** Non esistono ulteriori valori reali in grado di annullare il polinomio.

### 4. Corollario: Conservazione del Segno e Punto di Estremo Globale
La funzione monomia conserva segno costante in tutto $\mathbb{R} \setminus \{0\}$, e l'origine è l'unico zero e l'estremo assoluto:
$$\begin{cases} a > 0 \implies ax^2 \ge 0 \; (\forall x \in \mathbb{R}), \quad \min_{x \in \mathbb{R}} (ax^2) = 0 \text{ in } x = 0 \\ a < 0 \implies ax^2 \le 0 \; (\forall x \in \mathbb{R}), \quad \max_{x \in \mathbb{R}} (ax^2) = 0 \text{ in } x = 0 \end{cases}$$
> **Insight:** La parabola non attraversa mai l'asse x, ma vi rimbalza contro toccandolo unicamente nell'origine.
