---
id: mat_quad_spuria_01
title: "Equazioni di Secondo Grado Spurie"
category: "Matematica"
subCategory: "Equazioni di Secondo Grado"
prerequisites:
  - mat_quad_monomia_01
  - mat_binom_01
interactive:
  template: function_graph
  unit: ""
  equations:
    - "a * x * x + b * x"
  parameters:
    - variable: a
      label: "Coeff. a"
      min: -3.0
      max: 3.0
      default: 1.0
      step: 0.5
    - variable: b
      label: "Coeff. b"
      min: -6.0
      max: 6.0
      default: -2.0
      step: 0.5
---

### Equazioni di Secondo Grado Spurie: Fattorizzazione e Radici

Un'equazione di secondo grado si dice **spuria** quando il termine noto è identicamente nullo ($c = 0$), mentre il coefficiente del termine lineare è non nullo ($b \neq 0$), assumendo la forma canonica:

$$a x^2 + b x = 0 \quad \text{con } a, b \in \mathbb{R}, \; a \neq 0, \; b \neq 0$$

Nel piano cartesiano, la parabola $y = ax^2 + bx$ interseca l'asse delle ascisse in due punti ben distinti. Poiché per $x = 0$ si ottiene $y = a(0)^2 + b(0) = 0$, la curva passa necessariamente per l'origine degli assi cartesiani $(0, 0)$.

> **Insight:** L'assenza del termine noto consente di non ricorrere al completamento del quadrato né alla formula con radice quadrata: è sufficiente il raccoglimento a fattor comune totale della variabile $x$ per ricondurre l'equazione a due fattori di primo grado.

## Dimostrazione: Risoluzione dell'Equazione Spuria

### 1. Scomposizione analitica per raccoglimento a fattor comune
$$a x^2 + b x = 0 \iff x \cdot (a x + b) = 0 \quad (a \neq 0, \; b \neq 0)$$
> **Insight:** Il fattore comune x viene estratto da entrambi i termini, trasformando un binomio di secondo grado nel prodotto di due fattori lineari.

### 2. Applicazione della legge di annullamento del prodotto
$$x \cdot (a x + b) = 0 \iff x = 0 \quad \lor \quad a x + b = 0$$
> **Insight:** Un prodotto di fattori reali si annulla se e solo se almeno uno dei fattori che lo compongono è uguale a zero.

### 3. Risoluzione dell'equazione lineare residua
$$a x + b = 0 \iff a x = -b \iff x = -\frac{b}{a}$$
> **Insight:** La seconda soluzione discende direttamente dai principi di equivalenza applicati al binomio lineare di primo grado.

## Dimostrazione: Corollario - Positività Assoluta del Discriminante ed Esistenza di Due Zeri Distinti

### 1. Ipotesi e calcolo formale del discriminante con c = 0
Nel trinomio generale $ax^2 + bx + c = 0$, sostituiamo il termine noto nullo $c = 0$:
$$\Delta = b^2 - 4ac = b^2 - 4a(0) = b^2$$
> **Insight:** Il discriminante di un'equazione spuria coincide esattamente con il quadrato del coefficiente di primo grado.

### 2. Studio della stretta positività del quadrato
Poiché per ipotesi fondamentale di equazione spuria il coefficiente $b$ non è nullo ($b \neq 0$):
$$b \neq 0 \implies b^2 > 0 \implies \Delta > 0$$
> **Insight:** Un numero reale non nullo elevato al quadrato è inderogabilmente strettamente positivo.

### 3. Risoluzione mediante formula generale e modulo di b
Applicando la formula generale con $\Delta = b^2$:
$$x = \frac{-b \pm \sqrt{b^2}}{2a} = \frac{-b \pm |b|}{2a}$$
$$x_1 = \frac{-b + b}{2a} = 0, \qquad x_2 = \frac{-b - b}{2a} = -\frac{2b}{2a} = -\frac{b}{a}$$
> **Insight:** Il calcolo tramite formula quadratica generale coincide perfettamente con la fattorizzazione per raccoglimento a fattor comune.

### 4. Corollario: Esistenza Universale di Due Soluzioni Reali Distinte
Poiché $-\frac{b}{a} \neq 0$ per $b \neq 0$, le due soluzioni non possono mai coincidere:
$$x_1 = 0, \quad x_2 = -\frac{b}{a} \quad \implies x_1 \neq x_2 \quad (\forall a,b \neq 0)$$
> **Insight:** Un'equazione spuria ammette sempre due soluzioni reali distinte: la parabola interseca l'asse x sia nell'origine O(0,0) sia nel punto (-b/a, 0).

## Dimostrazione: Corollario - Punto Medio delle Radici e Coordinate del Vertice

### 1. Definizione della media aritmetica degli zeri
Calcoliamo il punto medio $x_M$ tra le due intersezioni reali $x_1 = 0$ e $x_2 = -\frac{b}{a}$:
$$x_M = \frac{x_1 + x_2}{2} = \frac{0 + \left(-\frac{b}{a}\right)}{2}$$
> **Insight:** La parabola è una curva a simmetria bilaterale: l'asse di simmetria deve cadere a metà esatta tra gli zeri.

### 2. Semplificazione della frazione algebrica
Dividendo per 2 la frazione al numeratore:
$$x_M = -\frac{b}{2a}$$
> **Insight:** L'ascissa del punto medio coincide perfettamente con la coordinata dell'asse di simmetria x_V = -b/(2a).

### 3. Valutazione della quota del vertice per sostituzione
Calcoliamo l'ordinata del vertice sostituendo $x_M$ nell'equazione della parabola $y = ax^2+bx$:
$$y_V = a\left(-\frac{b}{2a}\right)^2 + b\left(-\frac{b}{2a}\right) = a \frac{b^2}{4a^2} - \frac{b^2}{2a} = \frac{b^2 - 2b^2}{4a} = -\frac{b^2}{4a}$$
> **Insight:** Lo sviluppo delle frazioni algebriche conduce direttamente alla quota estrema.

### 4. Corollario: Posizione del Vertice della Parabola Spuria
Il vertice $V$ della parabola spuria ha coordinate esatte:
$$V\left(-\frac{b}{2a}, \; -\frac{b^2}{4a}\right) \quad \text{con asse } x = -\frac{b}{2a}$$
> **Insight:** Poiché b^2 > 0, l'ordinata del vertice ha sempre segno opposto al coefficiente a (sotto l'asse x per concavità verso l'alto, sopra per concavità verso il basso).
