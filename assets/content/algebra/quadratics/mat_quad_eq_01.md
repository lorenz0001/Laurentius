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

## Dimostrazione: Corollario - Formula Risolutiva Ridotta per Coefficiente Lineare Pari

### 1. Definizione del semi-coefficiente beta
Sia dato il coefficiente lineare pari $b = 2\beta$ con $\beta = \frac{b}{2} \in \mathbb{R}$:
$$a x^2 + 2\beta x + c = 0$$
> **Insight:** Quando il termine di primo grado è pari o multiplo di due, la formula si semplifica riducendo la complessità aritmetica.

### 2. Sostituzione nella formula generale e raccoglimento del fattore 4
Sostituendo $b = 2\beta$ nella formula risolutiva generale:
$$x_{1,2} = \frac{-2\beta \pm \sqrt{(2\beta)^2 - 4ac}}{2a} = \frac{-2\beta \pm \sqrt{4\beta^2 - 4ac}}{2a} = \frac{-2\beta \pm \sqrt{4(\beta^2 - ac)}}{2a}$$
> **Insight:** Il fattore comune 4 all'interno del radicando può essere fattorizzato ed estratto dal segno di radice.

### 3. Estrazione del fattore moltiplicativo e raccoglimento a numeratore
Estraendo $\sqrt{4} = 2$ e raccogliendo 2 a fattor comune su entrambi i termini del numeratore:
$$x_{1,2} = \frac{-2\beta \pm 2\sqrt{\beta^2 - ac}}{2a} = \frac{2\left(-\beta \pm \sqrt{\beta^2 - ac}\right)}{2a}$$
> **Insight:** Il 2 a fattor comune a numeratore prepara la cancellazione esatta con il 2 a denominatore.

### 4. Corollario: Semplificazione e Formula Ridotta (Delta/4)
Semplificando il fattore comune 2 e definendo il discriminante ridotto $\frac{\Delta}{4} \equiv \beta^2 - ac$:
$$x_{1,2} = \frac{-\beta \pm \sqrt{\frac{\Delta}{4}}}{a} = \frac{-\frac{b}{2} \pm \sqrt{\left(\frac{b}{2}\right)^2 - ac}}{a}$$
> **Insight:** Elimina la moltiplicazione per 4 nel discriminante e la divisione per 2 a denominatore, velocizzando i calcoli sia manuali sia algoritmici.

## Dimostrazione: Corollario - Formula Ridottissima per Trinomio Monico

### 1. Ipotesi di trinomio quadratico monico con b pari
Consideriamo il caso in cui il coefficiente di secondo grado sia unitario ($a = 1$) e il coefficiente lineare sia pari ($b = 2\beta$):
$$x^2 + 2\beta x + c = 0$$
> **Insight:** Si verifica in moltissimi problemi di geometria euclidea e fattorizzazione algebrica.

### 2. Sostituzione di a = 1 nella formula ridotta
Applicando la formula ridotta con $a = 1$:
$$x_{1,2} = \frac{-\beta \pm \sqrt{\beta^2 - 1 \cdot c}}{1}$$
> **Insight:** Il denominatore della frazione collassa all'unità.

### 3. Eliminazione del denominatore
Poiché qualsiasi quantità divisa per 1 coincide con se stessa:
$$x_{1,2} = -\beta \pm \sqrt{\beta^2 - c}$$
> **Insight:** I calcoli si riducono a una sottrazione e all'estrazione di un'unica radice quadrata.

### 4. Corollario: Espressione della Formula Ridottissima
Sostituendo $\beta = \frac{b}{2}$:
$$x_{1,2} = -\frac{b}{2} \pm \sqrt{\left(\frac{b}{2}\right)^2 - c}$$
> **Insight:** Fornisce la via computazionale più rapida in assoluto per risolvere equazioni quadratiche moniche.

## Dimostrazione: Corollario - Posizioni Reciproche tra Parabola e Asse delle Ascisse

### 1. Relazione tra vertice e intersezioni cartesiane
Riscriviamo la funzione quadratica nella forma con vertice esplicitato $y = a\left(x + \frac{b}{2a}\right)^2 - \frac{\Delta}{4a}$. Le intersezioni con l'asse $x$ corrispondono a $y = 0$:
$$a\left(x + \frac{b}{2a}\right)^2 - \frac{\Delta}{4a} = 0 \iff a\left(x + \frac{b}{2a}\right)^2 = \frac{\Delta}{4a}$$
> **Insight:** La ricerca degli zeri equivale a stabilire dove la quota della parabola incrocia l'asse orizzontale.

### 2. Isolamento del termine quadratico puro
Dividendo per il coefficiente non nullo $a$:
$$\left(x + \frac{b}{2a}\right)^2 = \frac{\Delta}{4a^2}$$
> **Insight:** Poiché 4a^2 > 0 per ogni a != 0, il segno del secondo membro è identico al segno del discriminante Delta.

### 3. Discussione dei tre regimi di segno
Poiché il quadrato al primo membro non può mai essere negativo nel dominio reale:
$$\begin{cases} \Delta > 0 \implies \left(x + \frac{b}{2a}\right) = \pm \frac{\sqrt{\Delta}}{2a} \implies \text{due radici reali distinte} \\ \Delta = 0 \implies \left(x + \frac{b}{2a}\right) = 0 \implies \text{due radici reali coincidenti} \\ \Delta < 0 \implies \left(x + \frac{b}{2a}\right)^2 < 0 \implies \text{nessuna radice reale} \end{cases}$$
> **Insight:** Il discriminante quantifica la semidistanza tra l'asse di simmetria e le radici.

### 4. Corollario: Geometria delle Posizioni Reciproche
Il segno del discriminante $\Delta$ governa interamente la topologia delle intersezioni con l'asse $x$:
$$\begin{cases} \Delta > 0 \implies \text{2 intersezioni reali distinte (parabola secante)} \\ \Delta = 0 \implies \text{1 intersezione reale con molteplicità 2 (parabola tangente nel vertice)} \\ \Delta < 0 \implies \text{0 intersezioni reali (parabola strettamente esterna all'asse } x) \end{cases}$$
> **Insight:** Governa le soluzioni delle disequazioni quadratiche e la stabilità dei sistemi dinamici a tempo discreto.
