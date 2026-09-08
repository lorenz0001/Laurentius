---
id: mat_quad_pura_01
title: "Equazioni di Secondo Grado Pure"
category: "Matematica"
subCategory: "Equazioni di Secondo Grado"
prerequisites:
  - mat_quad_monomia_01
  - mat_frac_01
interactive:
  template: function_graph
  unit: ""
  equations:
    - "a * x * x + c"
  parameters:
    - variable: a
      label: "Coeff. a"
      min: -3.0
      max: 3.0
      default: 1.0
      step: 0.5
    - variable: c
      label: "Termine c"
      min: -9.0
      max: 9.0
      default: -4.0
      step: 0.5
---

### Equazioni di Secondo Grado Pure: Struttura e Segno

Un'equazione di secondo grado si definisce **pura** quando il coefficiente del termine lineare è nullo ($b = 0$), mentre il termine noto è non nullo ($c \neq 0$), assumendo la forma:

$$a x^2 + c = 0 \quad \text{con } a, c \in \mathbb{R}, \; a \neq 0, \; c \neq 0$$

Nel piano cartesiano, la funzione associata $y = ax^2 + c$ descrive una parabola avente come asse di simmetria l'asse delle ordinate $y$, il cui vertice è traslato verticalmente nel punto $V(0, c)$. L'esistenza di radici reali coincide con l'intersezione effettiva della curva con l'asse delle ascisse.

> **Insight:** Il valore di $x^2$ deve eguagliare il rapporto $-\frac{c}{a}$. Poiché nel campo reale il quadrato di un numero è sempre non negativo ($x^2 \ge 0$), l'equazione ammette soluzioni reali se e solo se $a$ e $c$ hanno segno discorde ($ac < 0$), rendendo positivo il secondo membro.

## Dimostrazione: Risoluzione dell'Equazione Pura

### 1. Trasposizione del termine noto e isolamento quadratico
$$a x^2 + c = 0 \iff a x^2 = -c \iff x^2 = -\frac{c}{a} \quad (a \neq 0)$$
> **Insight:** Si applicano i principi di equivalenza delle equazioni algebriche per isolare la potenza x^2 al primo membro.

### 2. Condizione di realtà ed estrazione della radice
$$a \cdot c < 0 \implies -\frac{c}{a} > 0 \implies |x| = \sqrt{-\frac{c}{a}} \iff x = \pm \sqrt{-\frac{c}{a}}$$
> **Insight:** Se i coefficienti sono discordi, il rapporto è strettamente positivo e l'estrazione genera due valori reali opposti.

## Dimostrazione: Corollario - Simmetria delle Radici Reali e Traslazione Assiale

### 1. Ipotesi di coefficienti discordi per soluzioni reali
Siano $a, c \in \mathbb{R}$ con $ac < 0$, garantendo la positività del radicando $-\frac{c}{a} > 0$:
$$x_1 = -\sqrt{-\frac{c}{a}}, \qquad x_2 = +\sqrt{-\frac{c}{a}}$$
> **Insight:** Vogliamo provare che le due radici sono simmetriche rispetto all'origine e che la loro somma si annulla.

### 2. Somma algebrica delle due radici reali
Eseguiamo la somma delle soluzioni opposte:
$$x_1 + x_2 = \left(-\sqrt{-\frac{c}{a}}\right) + \left(+\sqrt{-\frac{c}{a}}\right) = 0$$
> **Insight:** I due radicali hanno modulo identico e segno discorde, determinando la cancellazione esatta della somma.

### 3. Calcolo del punto medio delle soluzioni
L'ascissa del punto medio tra le due radici sull'asse cartesiano orizzontale è:
$$x_M = \frac{x_1 + x_2}{2} = \frac{0}{2} = 0$$
> **Insight:** Il punto medio coincide esattamente con l'asse delle ordinate x = 0.

### 4. Corollario: Simmetria Radici Reali e Traslazione Assiale
Le radici reali di un'equazione pura sono sempre opposte e la parabola associata $y = ax^2+c$ è simmetrica rispetto all'asse $y$:
$$x_1 = -x_2 \iff x_1 + x_2 = 0 \quad \text{con Vertice } V(0, c)$$
> **Insight:** Il vertice della parabola giace sull'asse delle ordinate nel punto V(0, c), confermando l'assoluta specularità della curva rispetto all'asse verticale.

## Dimostrazione: Corollario - Condizione di Esistenza in Campo Reale e Radici Complesse

### 1. Calcolo del discriminante con termine lineare nullo
Sostituendo il coefficiente lineare $b = 0$ nella definizione generale del discriminante $\Delta = b^2 - 4ac$:
$$\Delta = 0^2 - 4ac = -4ac$$
> **Insight:** Il discriminante dell'equazione pura dipende unicamente dal prodotto dei coefficienti a e c.

### 2. Studio della disequazione per la realtà delle soluzioni
Affinché esistano soluzioni nel campo reale, il discriminante deve essere non negativo:
$$\Delta \ge 0 \iff -4ac \ge 0 \iff ac \le 0$$
> **Insight:** Dividendo per il numero negativo -4, il verso della disuguaglianza si inverte.

### 3. Caso di coefficienti concordi ed estrazione complessa
Se $a$ e $c$ sono concordi ($ac > 0$), si ha $\Delta < 0$ e $-\frac{c}{a} < 0$. Ponendo l'unità immaginaria $i = \sqrt{-1}$:
$$x = \pm \sqrt{-\frac{c}{a}} = \pm \sqrt{-1 \cdot \frac{c}{a}} = \pm i \sqrt{\frac{c}{a}}$$
> **Insight:** Nel campo complesso emergono due radici puramente immaginarie coniugate.

### 4. Corollario: Dicotomia dell'Equazione Pura
L'equazione pura ammette soluzioni reali se e solo se $a$ e $c$ sono discordi; altrimenti ammette radici immaginarie coniugate:
$$\begin{cases} ac < 0 \implies x_{1,2} = \pm \sqrt{-\frac{c}{a}} \in \mathbb{R} \quad (\text{2 soluzioni reali opposte}) \\ ac > 0 \implies x_{1,2} = \pm i \sqrt{\frac{c}{a}} \in \mathbb{C} \setminus \mathbb{R} \quad (\text{nessuna soluzione reale}) \end{cases}$$
> **Insight:** Fornisce il criterio immediato per valutare la risolubilità reale senza calcolare per esteso l'intera formula quadratica.
