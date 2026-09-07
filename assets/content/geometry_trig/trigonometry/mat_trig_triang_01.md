---
id: mat_trig_triang_01
title: "Teoremi dei Triangoli: Carnot, Seni e Formula dell'Area"
category: "Matematica"
subCategory: "Trigonometria dei Triangoli"
prerequisites:
  - mat_trig_add_01
  - mat_pythagoras_01
interactive:
  template: triangle_solver
  parameters: []
---

### Risoluzione dei Triangoli Qualsiasi: Carnot, Seni ed Erone

Mentre il Teorema di Pitagora è vincolato all'ipotesi rigida di triangolo rettangolo, la trigonometria piana consente di risolvere qualsiasi triangolo scaleno e obliquo combinando due grandi leggi:
1. Il **Teorema del Coseno** (o Teorema di Carnot), che generalizza Pitagora a qualsiasi angolo $\gamma$:
   $$c^2 = a^2 + b^2 - 2ab \cos\gamma$$
2. Il **Teorema dei Seni** (o Legge dei Seni), che stabilisce la proporzionalità diretta tra i lati e i seni degli angoli opposti, con costante di proporzionalità pari al diametro $2R$ del cerchio circoscritto:
   $$\frac{a}{\sin\alpha} = \frac{b}{\sin\beta} = \frac{c}{\sin\gamma} = 2R$$

> **Insight:** Quando l'angolo compreso è retto ($\gamma = 90^\circ$), $\cos(90^\circ) = 0$ e il termine correttivo $-2ab\cos\gamma$ svanisce, confermando che Carnot contiene Pitagora come caso speciale limite.

## Dimostrazione: Teorema di Carnot (Legge del Coseno)

### 1. Scomposizione del triangolo scaleno mediante l'altezza h
$$h = b \sin\gamma, \quad p = b \cos\gamma \implies \text{segmento residuo: } d = a - p = a - b \cos\gamma$$
> **Insight:** L'altezza divide il triangolo obliquo in due triangoli rettangoli adiacenti: l'ipotenusa b viene proiettata sulla base a.

### 2. Applicazione del Teorema di Pitagora al triangolo rettangolo contenente il lato c
$$c^2 = h^2 + d^2 = (b \sin\gamma)^2 + (a - b \cos\gamma)^2$$
> **Insight:** Il lato c e l'ipotenusa del secondo triangolo rettangolo avente cateti h e d.

### 3. Sviluppo algebrico e raccoglimento della relazione fondamentale
$$c^2 = b^2 \sin^2\gamma + a^2 - 2ab\cos\gamma + b^2 \cos^2\gamma = a^2 + b^2(\sin^2\gamma + \cos^2\gamma) - 2ab\cos\gamma$$
> **Insight:** Poiche sin^2(γ) + cos^2(γ) = 1, la somma dei due termini trigonometrici si compatta esattamente a b^2.

### 4. Corollario: Teorema di Carnot e Riduzione a Pitagora
$$c^2 = a^2 + b^2 - 2 a b \cos\gamma \implies (\gamma = 90^\circ \implies \cos(90^\circ) = 0 \implies c^2 = a^2 + b^2)$$
> **Insight:** Il termine correttivo -2ab cos(γ) quantifica esattamente la deviazione dell'angolo compreso rispetto all'angolo retto (allunga c se γ e ottuso, lo accorcia se e acuto).

## Dimostrazione: Teorema dei Seni e Circonferenza Circoscritta (2R)

### 1. Inserimento del triangolo nella circonferenza di raggio R e tracciamento del diametro
$$CD = 2R \quad \text{con diametro condotto dal vertice } C$$
> **Insight:** Si congiunge il punto D con il vertice B, formando il triangolo rettangolo CBD inscritto nella semicirconferenza.

### 2. Teorema degli angoli alla circonferenza che insistono sulla stessa corda
$$\angle CDB = \angle CAB = \alpha \implies \sin(\angle CDB) = \sin\alpha$$
> **Insight:** Angoli alla circonferenza che sottendono il medesimo arco BC hanno esattamente la stessa ampiezza.

### 3. Relazione trigonometrica nel triangolo rettangolo CBD
$$\sin\alpha = \frac{a}{CD} = \frac{a}{2R} \iff \frac{a}{\sin\alpha} = 2R$$
> **Insight:** Il cateto a e uguale all'ipotenusa (diametro 2R) moltiplicata per il seno dell'angolo opposto α.

### 4. Corollario: La Legge dei Seni per Qualsiasi Triangolo
$$\frac{a}{\sin\alpha} = \frac{b}{\sin\beta} = \frac{c}{\sin\gamma} = 2 R$$
> **Insight:** Il rapporto tra la misura di qualsiasi lato e il seno dell'angolo a esso opposto e costante e coincide esattamente con il diametro della circonferenza circoscritta.

## Dimostrazione: Formula Goniometrica dell'Area e Formula di Erone

### 1. Calcolo dell'area tramite altezza espressa con il seno
$$\text{Area} = \frac{\text{base} \cdot \text{altezza}}{2} = \frac{a \cdot h}{2} = \frac{a \cdot (b \sin\gamma)}{2} = \frac{1}{2} a b \sin\gamma$$
> **Insight:** Permette di calcolare l'area di qualsiasi triangolo conoscendo unicamente due lati e l'angolo tra essi compreso.

### 2. Espressione di sen(gamma) tramite la formula di Carnot
$$\sin\gamma = \sqrt{1 - \cos^2\gamma} = \sqrt{1 - \left(\frac{a^2 + b^2 - c^2}{2ab}\right)^2}$$
> **Insight:** Il coseno viene isolato direttamente dal Teorema di Carnot e convertito in seno con la relazione fondamentale.

### 3. Fattorizzazione per differenza di quadrati e semiperimetro
$$p = \frac{a + b + c}{2} \implies \text{Area} = \sqrt{p(p - a)(p - b)(p - c)}$$
> **Insight:** Lo sviluppo algebrico decompone i fattori esattamente nella somma e nelle differenze dei tre lati rispetto al semiperimetro p.

### 4. Corollario: La Formula di Erone per il Calcolo dell'Area dai Soli Lati
$$\text{Area} = \sqrt{p(p-a)(p-b)(p-c)} \quad \text{con } p = \frac{a+b+c}{2}$$
> **Insight:** Consente di calcolare l'area di un triangolo qualunque conoscendo esclusivamente le lunghezze dei suoi tre lati, senza richiedere il calcolo di angoli o altezze.
