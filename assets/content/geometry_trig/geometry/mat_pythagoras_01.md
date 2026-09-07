---
id: mat_pythagoras_01
title: "Teorema di Pitagora ed Euclide"
category: "Matematica"
subCategory: "Geometria Euclidea Piana"
prerequisites:
  - mat_triang_01
  - mat_binom_01
interactive:
  template: triangle_solver
  parameters: []
---

### Il Teorema di Pitagora e la Geometria Euclidea dei Triangoli Rettangoli

In ogni triangolo rettangolo, l'area del quadrato costruito sull'ipotenusa è equivalente alla somma delle aree dei quadrati costruiti sui due cateti:

$$a^2 + b^2 = c^2 \iff c = \sqrt{a^2 + b^2}$$

Questo enunciato rappresenta la base fondativa della **metrica euclidea** nello spazio a due, tre e $n$ dimensioni, definendo la distanza geometrica fondamentale:

$$d = \sqrt{\Delta x^2 + \Delta y^2}$$

In stretta continuità con Pitagora si collocano i due **Teoremi di Euclide**, ricavati dalla similitudine tra i triangoli rettangoli formati tracciando l'altezza relativa all'ipotenusa.

> **Insight:** Il Teorema di Pitagora non è un mero calcolo algebrico: è una conservazione esatta di superfici geometriche. Il quadrato sull'ipotenusa può essere fisicamente ritagliato e ricomposto perfettamente nei due quadrati sui cateti.

## Dimostrazione: Teorema di Pitagora (Equiscomponibilità delle Aree)

### 1. Costruzione di un quadrato di lato (a + b)
$$\text{Area}_{\text{tot}} = (a + b)^2 = 4 \cdot \left(\frac{1}{2} a b\right) + c^2$$
> **Insight:** Si dispongono 4 copie identiche del triangolo rettangolo ai quattro angoli di un quadrato di lato (a+b): al centro rimane esattamente un quadrato inclinato di lato c.

### 2. Espansione algebrica del quadrato di binomio
$$(a + b)^2 = a^2 + 2ab + b^2 \iff a^2 + 2ab + b^2 = 2ab + c^2$$
> **Insight:** I 4 triangoli rettangoli hanno un'area complessiva pari a 4 * (ab/2) = 2ab.

### 3. Sottrazione del termine misto 2ab da entrambi i membri
$$a^2 + 2ab + b^2 - 2ab = 2ab + c^2 - 2ab \iff a^2 + b^2 = c^2$$
> **Insight:** Sottraendo l'area dei 4 triangoli rimane l'uguaglianza rigorosa tra i quadrati costruiti sui cateti e il quadrato costruito sull'ipotenusa.

### 4. Corollario: Metrica Euclidea e Diagonale del Quadrato
$$c = \sqrt{a^2 + b^2}, \qquad d_{\text{quadrato}} = \sqrt{l^2 + l^2} = l\sqrt{2}$$
> **Insight:** Fornisce la formula universale della distanza cartesiana euclidea e la dimostrazione dell'irrazionalita della diagonale del quadrato unitario.

## Dimostrazione: Primo Teorema di Euclide (Similitudine dei Triangoli)

### 1. Tracciamento dell'altezza h relativa all'ipotenusa c
$$\text{Ipotenusa: } c = p_1 + p_2 \quad \text{con } p_1 \text{ proiezione del cateto } a, \; p_2 \text{ proiezione del cateto } b$$
> **Insight:** L'altezza h suddivide il triangolo ABC nei due triangoli rettangoli minori ACH e BCH.

### 2. Similitudine tra il triangolo originario ABC e il sottomodulo ACH
$$\angle A \text{ in comune}, \quad \angle AHC = \angle ACB = 90^\circ \implies \triangle ABC \sim \triangle ACH$$
> **Insight:** Per il primo criterio di similitudine, due triangoli con gli stessi angoli hanno lati omologhi in proporzione diretta.

### 3. Rapporto di proporzionalità tra ipotenuse e cateti
$$\frac{\text{ipotenusa } ABC}{\text{cateto } AC} = \frac{\text{ipotenusa } ACH}{\text{proiezione } AH} \iff \frac{c}{b} = \frac{b}{p_2} \iff b^2 = c \cdot p_2$$
> **Insight:** Il cateto e medio proporzionale tra l'intera ipotenusa e la propria proiezione su di essa.

### 4. Corollario: Primo Teorema di Euclide e Deduzione Alternativa di Pitagora
$$a^2 = c \cdot p_1, \quad b^2 = c \cdot p_2 \implies a^2 + b^2 = c(p_1 + p_2) = c \cdot c = c^2$$
> **Insight:** Sommando membro a membro i due enunciati di Euclide I si ottiene una dimostrazione elegantissima e istantanea del Teorema di Pitagora.

## Dimostrazione: Secondo Teorema di Euclide (Altezza Medio Proporzionale)

### 1. Similitudine tra i due triangoli rettangoli adiacenti ACH e BCH
$$\angle CAH = 90^\circ - \angle ACH = \angle BCH \implies \triangle ACH \sim \triangle CBH$$
> **Insight:** I due triangoli minori condividono gli stessi angoli complementari rispetto all'altezza comune h.

### 2. Impostazione della proporzione tra i cateti omologhi
$$\frac{\text{cateto lungo } ACH}{\text{cateto corto } ACH} = \frac{\text{cateto lungo } CBH}{\text{cateto corto } CBH} \iff \frac{h}{p_1} = \frac{p_2}{h}$$
> **Insight:** L'altezza h funge da cateto maggiore per il primo triangolo e da cateto minore per il secondo.

### 3. Prodotto dei medi e dei primi estremi
$$\frac{h}{p_1} = \frac{p_2}{h} \iff h^2 = p_1 \cdot p_2 \iff h = \sqrt{p_1 \cdot p_2}$$
> **Insight:** Il quadrato dell'altezza relativa all'ipotenusa e equivalente al rettangolo avente per lati le proiezioni dei due cateti.

### 4. Corollario: Secondo Teorema di Euclide e Media Geometrica
$$h = \sqrt{p_1 \cdot p_2} = \text{Media Geometrica}(p_1, p_2)$$
> **Insight:** Fornisce la classica costruzione geometrica con riga e compasso per calcolare esattamente la radice quadrata del prodotto di due segmenti.
