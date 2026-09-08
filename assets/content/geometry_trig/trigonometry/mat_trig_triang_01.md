---
id: mat_trig_triang_01
title: "Teoremi dei Triangoli: Carnot, Seni e Formula dell'Area"
category: "Matematica"
subCategory: "Goniometria e Trigonometria"
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

## Dimostrazione: Corollario - Teorema di Carnot e Riduzione a Pitagora

### 1. Ipotesi dal Teorema di Carnot per il lato opposto a gamma
Consideriamo l'equazione di Carnot per il lato $c$:
$$c^2 = a^2 + b^2 - 2ab \cos\gamma$$
> **Insight:** Vogliamo analizzare il comportamento della formula quando l'angolo compreso è retto.

### 2. Ipotesi di triangolo rettangolo con angolo compreso retto
Poniamo $\gamma = 90^\circ = \frac{\pi}{2} \text{ rad}$. Per le proprietà delle funzioni goniometriche:
$$\cos(90^\circ) = 0$$
> **Insight:** La proiezione del cateto b sulla base a si riduce al singolo punto di intersezione verticale.

### 3. Sostituzione ed elisione del termine misto
Sostituendo il valore nullo del coseno:
$$c^2 = a^2 + b^2 - 2ab(0) = a^2 + b^2 - 0$$
> **Insight:** Il termine correttivo -2ab cos(γ) svanisce completamente.

### 4. Corollario: Riduzione Rigorosa al Teorema di Pitagora
L'equazione di Carnot collassa all'uguaglianza pitagorica:
$$c^2 = a^2 + b^2 \iff c = \sqrt{a^2 + b^2}$$
> **Insight:** Dimostra che il Teorema di Pitagora è il caso particolare limite di Carnot quando l'angolo compreso è esattamente retto.

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

## Dimostrazione: Corollario - La Legge dei Seni per Qualsiasi Triangolo

### 1. Ipotesi della corda opposta al primo vertice
Dal rapporto geometrico calcolato per il vertice $A$:
$$\frac{a}{\sin\alpha} = 2R$$
> **Insight:** Il rapporto per il lato a equivale al diametro del cerchio circoscritto.

### 2. Generalizzazione per rotazione agli altri due vertici B e C
Ripetendo identicamente la costruzione diametrale per i lati $b$ e $c$:
$$\frac{b}{\sin\beta} = 2R, \qquad \frac{c}{\sin\gamma} = 2R$$
> **Insight:** La medesima costante diametrale 2R governa la proiezione di tutti e tre i lati.

### 3. Transitività dell'uguaglianza algebrica
Poiché tutti e tre i quozienti equivalgono alla stessa quantità $2R$:
$$\frac{a}{\sin\alpha} = \frac{b}{\sin\beta} = \frac{c}{\sin\gamma} = 2R$$
> **Insight:** Stabilisce una proporzionalità diretta continua tra ciascun lato e il seno dell'angolo opposto.

### 4. Corollario: Enunciato della Legge dei Seni e Raggio Circoscritto
La proporzione universale dei seni in qualsiasi triangolo è:
$$\frac{a}{\sin\alpha} = \frac{b}{\sin\beta} = \frac{c}{\sin\gamma} = 2R \iff R = \frac{a}{2\sin\alpha}$$
> **Insight:** Permette di determinare il raggio della circonferenza circoscritta e di risolvere triangoli quando sono noti un lato e due angoli.

## Dimostrazione: Formula Goniometrica dell'Area del Triangolo

### 1. Calcolo dell'area classica tramite altezza con il seno
$$\text{Area} = \frac{\text{base} \cdot \text{altezza}}{2} = \frac{a \cdot h}{2} = \frac{a \cdot (b \sin\gamma)}{2} = \frac{1}{2} a b \sin\gamma$$
> **Insight:** Permette di calcolare l'area conoscendo unicamente due lati e l'angolo compreso.

### 2. Isolamento del seno e relazione con Carnot
$$\sin^2\gamma = 1 - \cos^2\gamma = 1 - \left(\frac{a^2 + b^2 - c^2}{2ab}\right)^2$$
> **Insight:** Il coseno dell'angolo gamma viene ricavato direttamente dal Teorema di Carnot.

### 3. Moltiplicazione per 16 Area al quadrato
$$16 \cdot \text{Area}^2 = 16 \left(\frac{1}{2}ab\sin\gamma\right)^2 = 4a^2b^2\sin^2\gamma = 4a^2b^2 - (a^2+b^2-c^2)^2$$
> **Insight:** Elimina i denominatori predisponendo la scomposizione come differenza di quadrati.

## Dimostrazione: Corollario - La Formula di Erone per il Calcolo dell'Area dai Soli Lati

### 1. Scomposizione come differenza di due quadrati
Fattorizziamo l'espressione $4a^2b^2 - (a^2+b^2-c^2)^2 = (2ab)^2 - (a^2+b^2-c^2)^2$:
$$16 \cdot \text{Area}^2 = [2ab - (a^2+b^2-c^2)][2ab + (a^2+b^2-c^2)]$$
> **Insight:** Si applica la differenza di quadrati X^2 - Y^2 = (X - Y)(X + Y).

### 2. Riconoscimento dei quadrati di binomio e riordinamento
Riscrivendo i termini interni:
$$[c^2 - (a^2 - 2ab + b^2)][(a^2 + 2ab + b^2) - c^2] = [c^2 - (a-b)^2][(a+b)^2 - c^2]$$
> **Insight:** Emergono i quadrati perfetti dei binomi (a-b)^2 e (a+b)^2.

### 3. Ulteriore scomposizione in quattro fattori lineari
Scomponendo ciascuna parentesi quadra come differenza di quadrati:
$$16 \cdot \text{Area}^2 = (c - a + b)(c + a - b)(a + b - c)(a + b + c)$$
> **Insight:** I quattro fattori lineari contengono tutte le possibili permutazioni di segni dei tre lati.

### 4. Introduzione del semiperimetro p
Ponendo il semiperimetro $p = \frac{a+b+c}{2} \iff 2p = a+b+c$:
$$(a+b+c) = 2p, \quad (b+c-a) = 2(p-a), \quad (a+c-b) = 2(p-b), \quad (a+b-c) = 2(p-c)$$
$$16 \cdot \text{Area}^2 = (2p) \cdot 2(p-a) \cdot 2(p-b) \cdot 2(p-c) = 16 p (p-a)(p-b)(p-c)$$
> **Insight:** La moltiplicazione dei quattro binomi genera esattamente il fattore 16 che si elide con il primo membro.

### 5. Corollario: La Formula di Erone
Dividendo per 16 ed estraendo la radice quadrata:
$$\text{Area} = \sqrt{p(p-a)(p-b)(p-c)} \quad \text{con } p = \frac{a+b+c}{2}$$
> **Insight:** Consente di calcolare l'area di un triangolo qualunque conoscendo esclusivamente le lunghezze dei suoi tre lati, senza richiedere il calcolo di angoli o altezze.
