---
id: mat_quad_eq_01
title: "Equazione di Secondo Grado Completa & Formula Risolutiva"
category: "Matematica"
subCategory: "Equazioni di Secondo Grado"
prerequisites:
  - mat_quad_pura_01
  - mat_quad_spuria_01
interactive:
  template: completing_square
  unit: ""
  equations:
    - "a * x * x + b * x + c"
  parameters:
    - variable: a
      label: "Coeff. a"
      min: 0.5
      max: 3.0
      default: 1.0
      step: 0.5
    - variable: b
      label: "Coeff. b"
      min: 1.0
      max: 8.0
      default: 4.0
      step: 0.5
    - variable: c
      label: "Coeff. c"
      min: -8.0
      max: 4.0
      default: -5.0
      step: 0.5
---

### Equazioni di Secondo Grado Complete: Teoria e Formula Risolutiva

L'equazione algebrica di secondo grado nella sua forma generale **completa** presenta tutti i coefficienti non nulli:

$$a x^2 + b x + c = 0 \quad \text{con } a, b, c \in \mathbb{R}, \; a \neq 0, \; b \neq 0, \; c \neq 0$$

Il termine quadratico $ax^2$ conferisce la curvatura parabolica, il termine lineare $bx$ determina la pendenza nell'origine e la traslazione orizzontale, mentre il termine noto $c$ fissa l'intercetta sull'asse delle ordinate $y = c$.

### Dimostrazione Visiva: La Dissezione Geometrica di al-Khwarizmi

La formula risolutiva non è una mera manipolazione di simboli, ma una proprietà geometrica tangibile legata alla conservazione dell'area:

1. **Area Iniziale**: Dividendo per $a$, l'equazione diventa $x^2 + \frac{b}{a}x = -\frac{c}{a}$. Immaginiamo un quadrato di lato $x$ (area $x^2$) e un rettangolo di lati $x$ e $\frac{b}{a}$ (area $\frac{b}{a}x$). La loro somma d'area è pari a $-\frac{c}{a}$.
2. **Taglio a "L" (Gnomone)**: Dividiamo a metà il rettangolo in due strisce di larghezza $\frac{b}{2a}$ e altezza $x$. Posizionando una striscia a destra del quadrato e l'altra sopra di esso, otteniamo una figura a "L".
3. **Il Tassello Mancante**: Notiamo che per completare il grande quadrato manca esattamente l'angolo in alto a destra, uno spazio quadrato di lato $\frac{b}{2a}$ e area $\left(\frac{b}{2a}\right)^2 = \frac{b^2}{4a^2}$.
4. **Completamento del Quadrato**: Aggiungendo questo tassello d'angolo a entrambi i membri, l'area totale diventa un quadrato perfetto di lato $\left(x + \frac{b}{2a}\right)$ e area complessiva:
   $$\left(x + \frac{b}{2a}\right)^2 = -\frac{c}{a} + \frac{b^2}{4a^2} = \frac{b^2 - 4ac}{4a^2} = \frac{\Delta}{4a^2}$$
5. **Deduzione della Formula**: Estraendo la radice quadrata della misura del lato:
   $$x + \frac{b}{2a} = \pm \frac{\sqrt{\Delta}}{2a} \implies x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$$

> **Insight:** Nella visualizzazione cartesiana, il termine $-\frac{b}{2a}$ indica l'asse di simmetria orizzontale della parabola, mentre $\pm \frac{\sqrt{\Delta}}{2a}$ quantifica la semidistanza esatta tra l'asse di simmetria e le due radici reali. Se $\Delta = 0$, la semidistanza collassa a zero (radice doppia al vertice); se $\Delta < 0$, la curva non tocca mai l'asse $x$.

## Dimostrazione: Formula Risolutiva Generale (Completamento del Quadrato)

### 1. Moltiplicazione per 4a ed eliminazione delle frazioni
$$a x^2 + b x + c = 0 \iff 4a^2 x^2 + 4abx + 4ac = 0 \quad (a \neq 0)$$
> **Insight:** Moltiplicare per 4a e una tecnica classica che rende 4a^2 x^2 il quadrato perfetto esatto di 2ax, evitando calcoli frazionari intermedi.

### 2. Formazione del quadrato di binomio e definizione del Discriminante
$$(2ax)^2 + 2 \cdot (2ax) \cdot b + b^2 - b^2 + 4ac = 0 \iff (2ax + b)^2 = b^2 - 4ac$$
> **Insight:** Aggiungendo e sottraendo b^2 si completa il quadrato perfetto del binomio (2ax + b)^2, isolando al secondo membro il discriminante Delta = b^2 - 4ac.

### 3. Estrazione della radice quadrata e isolamento della variabile x
$$2ax + b = \pm \sqrt{b^2 - 4ac} \iff 2ax = -b \pm \sqrt{\Delta}$$
> **Insight:** L'estrazione di radice su entrambi i membri conduce all'espressione lineare in x.

### 4. Corollario: La Celebre Formula Quadratica Risolutiva
$$x_{1,2} = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a} = \frac{-b \pm \sqrt{\Delta}}{2a}$$
> **Insight:** Formula universale che fornisce l'insieme completo delle soluzioni esatte di qualsiasi equazione quadratica a coefficienti reali.

## Dimostrazione: Formula Risolutiva Ridotta per b Pari

### 1. Definizione del semi-coefficiente beta
$$b = 2\beta \quad \text{con } \beta = \frac{b}{2} \in \mathbb{R}$$
> **Insight:** Quando il coefficiente b e pari o divisibile per 2, la formula si semplifica drasticamente riducendo l'onere computazionale.

### 2. Sostituzione nella formula generale e raccoglimento del fattore 4
$$x_{1,2} = \frac{-2\beta \pm \sqrt{(2\beta)^2 - 4ac}}{2a} = \frac{-2\beta \pm \sqrt{4(\beta^2 - ac)}}{2a}$$
> **Insight:** Il fattore 4 puo essere estratto dalla radice quadrata diventando un fattore moltiplicativo 2.

### 3. Semplificazione del fattore comune 2
$$x_{1,2} = \frac{-2\beta \pm 2\sqrt{\beta^2 - ac}}{2a} = \frac{2(-\beta \pm \sqrt{\beta^2 - ac})}{2a}$$
> **Insight:** Il 2 a numeratore e a denominatore si elidono esattamente.

### 4. Corollario: Formula Ridotta e Discriminante Ridotto (Delta/4)
$$x_{1,2} = \frac{-\beta \pm \sqrt{\frac{\Delta}{4}}}{a} = \frac{-\frac{b}{2} \pm \sqrt{\left(\frac{b}{2}\right)^2 - ac}}{a}$$
> **Insight:** Elimina la moltiplicazione per 4 nel discriminante e la divisione per 2 a denominatore, velocizzando i calcoli sia manuali sia algoritmici.

## Dimostrazione: Natura Geometrica del Discriminante e Zeri della Parabola

### 1. Coordinate cartesiane del vertice della parabola
$$V\left(-\frac{b}{2a}, \; -\frac{\Delta}{4a}\right) \quad \text{con ordinata } y_V = -\frac{b^2 - 4ac}{4a}$$
> **Insight:** Il punto di massimo o minimo assoluto della parabola riflette direttamente il valore del discriminante scalato per 4a.

### 2. Riscrittura canonica dell'ordinata in funzione della distanza dall'asse x
$$y = a\left(x + \frac{b}{2a}\right)^2 - \frac{\Delta}{4a}$$
> **Insight:** Evidenzia che la parabola tocca l'asse x (y = 0) se e solo se il termine quadratico eguaglia Delta / (4a^2).

### 3. Corollario: Posizioni Reciproche tra Parabola e Asse delle Ascisse
$$\begin{cases} \Delta > 0 \implies \text{2 intersezioni reali distinte } (x_1 \neq x_2) \\ \Delta = 0 \implies \text{1 intersezione reale (vertice tangente } x_1 = x_2) \\ \Delta < 0 \implies \text{0 intersezioni reali (parabola strettamente positiva o negativa)} \end{cases}$$
> **Insight:** Il segno di Delta governa l'esistenza e la cardinalita degli zeri reali di qualsiasi trinomio di secondo grado.
