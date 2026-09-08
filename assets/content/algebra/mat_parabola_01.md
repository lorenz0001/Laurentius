---
id: mat_parabola_01
title: "Funzione Quadratica e Parabola"
category: "Matematica"
subCategory: "Funzioni e Geometria Analitica"
prerequisites:
  - mat_quad_eq_01
interactive:
  template: function_graph
  unit: ""
  equations:
    - "a * x * x + b * x + c"
  parameters:
    - variable: a
      label: "Curvatura (a)"
      min: -3.0
      max: 3.0
      default: 1.0
      step: 0.1
    - variable: b
      label: "Traslazione Orizzontale (b)"
      min: -4.0
      max: 4.0
      default: 0.0
      step: 0.2
    - variable: c
      label: "Intercetta Verticale (c)"
      min: -5.0
      max: 5.0
      default: -2.0
      step: 0.5
---

### Funzione Quadratica e Parabola

La **parabola** con asse di simmetria parallelo all'asse delle ordinate è il luogo dei punti del piano cartesiano rappresentato dall'equazione $y = ax^2 + bx + c$ ($a \neq 0$).

Le proprietà geometriche principali sono:
- Il segno di $a$ determina la concavità: verso l'alto se $a > 0$, verso il basso se $a < 0$.
- Il coefficiente $c$ corrisponde all'ordinata del punto di intersezione con l'asse $y$.
- Il vertice $V$ rappresenta il punto di estremo (minimo o massimo) assoluto della funzione.

$$y = a \left(x + \frac{b}{2a}\right)^2 - \frac{\Delta}{4a}$$

> **Insight:** La parabola è la traiettoria universale descritta da qualsiasi corpo in moto balistico sotto l'azione della gravità terrestre costante.

## Dimostrazione: Forma Canonica e Completamento del Quadrato

### 1. Forma canonica polinomiale sul piano cartesiano
$$y = a x^2 + b x + c \quad (a \neq 0)$$
> **Insight:** Il coefficiente quadratico a governa l'apertura e il verso della concavità della parabola.

### 2. Raccoglimento del coefficiente direttivo sui termini variabili
$$y = a \left(x^2 + \frac{b}{a} x\right) + c$$
> **Insight:** Isola il binomio in x per predisporre il completamento del quadrato perfetto.

### 3. Completamento del quadrato perfetto e forma vertice
$$y = a \left(x^2 + \frac{b}{a}x + \frac{b^2}{4a^2} - \frac{b^2}{4a^2}\right) + c = a \left(x + \frac{b}{2a}\right)^2 - \frac{b^2 - 4 a c}{4 a}$$
> **Insight:** La forma y - y_V = a(x - x_V)^2 esplicita geometricamente la traslazione del vertice rispetto all'origine.

## Dimostrazione: Corollario - Coordinate del Vertice e Asse di Simmetria

### 1. Ipotesi dalla forma a vertice traslato
Riscriviamo la parabola nella forma traslata canonica con discriminante $\Delta = b^2 - 4ac$:
$$y + \frac{\Delta}{4a} = a \left(x + \frac{b}{2a}\right)^2$$
> **Insight:** Vogliamo individuare l'asse di simmetria e il punto di massimo o minimo assoluto.

### 2. Studio dell'estremante e annullamento del quadrato
Poiché $\left(x + \frac{b}{2a}\right)^2 \ge 0$ per ogni $x \in \mathbb{R}$, l'estremante (minimo se $a>0$, massimo se $a<0$) si realizza esattamente quando il quadrato si annulla:
$$x + \frac{b}{2a} = 0 \iff x = -\frac{b}{2a}$$
> **Insight:** La retta verticale x = -b/(2a) funge da asse di simmetria bilaterale speculare per la curva.

### 3. Valutazione dell'ordinata estrema
Sostituendo l'ascissa di simmetria nell'equazione cartesiana:
$$y_V = a \left(-\frac{b}{2a} + \frac{b}{2a}\right)^2 - \frac{\Delta}{4a} = 0 - \frac{\Delta}{4a} = -\frac{\Delta}{4a}$$
> **Insight:** L'ordinata del vertice dipende unicamente dal discriminante Delta scalato per 4a.

### 4. Corollario: Coordinate del Vertice e Asse di Simmetria
Il vertice $V$ e l'asse di simmetria della parabola $y = ax^2+bx+c$ sono univocamente determinati:
$$V = \left(-\frac{b}{2a}, \; -\frac{\Delta}{4a}\right) \quad \land \quad x = -\frac{b}{2a}$$
> **Insight:** Individua l'apice della traiettoria nei moti balistici e il punto stazionario a derivata prima nulla.

## Dimostrazione: Corollario - Fuoco e Direttrice dalla Definizione Geometrica

### 1. Definizione della parabola come luogo geometrico equidistante
La parabola è il luogo dei punti $P(x,y)$ equidistanti dal punto fuoco $F(x_F, y_F)$ e dalla retta direttrice $d: y = y_d$:
$$\text{dist}(P, F)^2 = \text{dist}(P, d)^2 \iff (x - x_F)^2 + (y - y_F)^2 = (y - y_d)^2$$
> **Insight:** La distanza cartesiana dal fuoco eguaglia la distanza ortogonale dalla retta orizzontale direttrice.

### 2. Sviluppo algebrico dei quadrati con asse verticale
Poiché l'asse è verticale ($x_F = -b/(2a)$), sviluppiamo i quadrati di binomio in $y$:
$$\left(x + \frac{b}{2a}\right)^2 + y^2 - 2y_F y + y_F^2 = y^2 - 2y_d y + y_d^2$$
> **Insight:** Il termine y^2 si elide da entrambi i membri linearizzando la dipendenza da y.

### 3. Isolamento della forma quadratica e confronto dei coefficienti
Riorganizzando i termini:
$$\left(x + \frac{b}{2a}\right)^2 = 2(y_F - y_d)y + (y_d^2 - y_F^2) = 4p \left(y - \frac{y_F + y_d}{2}\right)$$
Ponendo la distanza focale $p = \frac{1}{4a}$ e il punto medio $\frac{y_F + y_d}{2} = y_V = -\frac{\Delta}{4a}$:
$$y_F = y_V + p = -\frac{\Delta}{4a} + \frac{1}{4a} = \frac{1 - \Delta}{4a}, \quad y_d = y_V - p = -\frac{1 + \Delta}{4a}$$
> **Insight:** Il vertice si trova esattamente a metà strada tra il fuoco e la direttrice.

### 4. Corollario: Equazioni del Fuoco e della Direttrice
Le coordinate del Fuoco $F$ e l'equazione della retta direttrice $d$ risultano:
$$F = \left(-\frac{b}{2a}, \; \frac{1 - \Delta}{4a}\right) \quad \land \quad d: y = -\frac{1 + \Delta}{4a}$$
> **Insight:** Governa la proprietà focale riflettente: qualsiasi raggio emesso dal fuoco viene riflesso parallelamente all'asse di simmetria.
