---
id: lin_alg_04_span
title: "Combinazioni Lineari e Spazio Vettoriale Generato (Span)"
category: "Matematica"
subCategory: "Algebra Lineare"
prerequisites:
  - lin_alg_03_operations
interactive:
  template: linear_combination
  unit: ""
  equations:
    - "c1 * v1x + c2 * v2x"
    - "c1 * v1y + c2 * v2y"
  parameters:
    - variable: c1
      label: "Coefficiente c₁"
      unit: ""
      min: -3.0
      max: 3.0
      default: 2.0
      step: 0.1
    - variable: c2
      label: "Coefficiente c₂"
      unit: ""
      min: -3.0
      max: 3.0
      default: -1.0
      step: 0.1
    - variable: v1x
      label: "Vettore v₁ (x)"
      unit: ""
      min: -5.0
      max: 5.0
      default: 2.0
      step: 0.5
    - variable: v1y
      label: "Vettore v₁ (y)"
      unit: ""
      min: -5.0
      max: 5.0
      default: 1.0
      step: 0.5
    - variable: v2x
      label: "Vettore v₂ (x)"
      unit: ""
      min: -5.0
      max: 5.0
      default: 0.0
      step: 0.5
    - variable: v2y
      label: "Vettore v₂ (y)"
      unit: ""
      min: -5.0
      max: 5.0
      default: 2.0
      step: 0.5
---

### Combinazioni Lineari e la Geometria dello Spazio Generato

Nel cuore dell'algebra lineare risiede l'interrogativo fondamentale: quali regioni dello spazio geometrico possiamo raggiungere combinando tra loro un insieme prefissato di vettori mediante scalari?

Sia dato uno spazio vettoriale $V$ su $\mathbb{R}$ e sia $\mathcal{S} = \{\mathbf{v}_1, \mathbf{v}_2, \dots, \mathbf{v}_k\}$ una collezione finita di vettori in $V$.
Una **combinazione lineare** dei vettori di $\mathcal{S}$ è un'espressione della forma:

$$\mathbf{w} = c_1 \mathbf{v}_1 + c_2 \mathbf{v}_2 + \dots + c_k \mathbf{v}_k = \sum_{i=1}^k c_i \mathbf{v}_i$$

dove i coefficienti $c_1, c_2, \dots, c_k \in \mathbb{R}$ sono detti *pesi* o *scalari* della combinazione.

L'insieme di **tutte** le possibili combinazioni lineari ottenibili al variare arbitrario dei pesi scalari in $\mathbb{R}$ prende il nome di **Spazio Vettoriale Generato** (o **Span** lineare) dell'insieme $\mathcal{S}$, denotato con $\text{Span}(\mathcal{S})$ o $\mathcal{L}(\mathbf{v}_1, \dots, \mathbf{v}_k)$:

$$\text{Span}(\mathbf{v}_1, \dots, \mathbf{v}_k) \equiv \left\{ \sum_{i=1}^k c_i \mathbf{v}_i \;\middle|\; c_1, \dots, c_k \in \mathbb{R} \right\}$$

> **Insight:** Lo Span è una "macchina generatrice di spazi": variando i pesi continui $c_1, c_2$, i vettori elementari tessono un reticolato che copre intere linee, piani o iperpiani.

Geometricamente, la dimensione dello Span segue una rigorosa gerarchia:
- **Un vettore non nullo $\mathbf{v}_1$**: $\text{Span}(\mathbf{v}_1) = \{c_1 \mathbf{v}_1 \mid c_1 \in \mathbb{R}\}$ è una **retta** passante per l'origine (spazio 1-dimensionale).
- **Due vettori non paralleli $\mathbf{v}_1, \mathbf{v}_2$**: $\text{Span}(\mathbf{v}_1, \mathbf{v}_2)$ è un **piano** passante per l'origine (spazio 2-dimensionale). In $\mathbb{R}^2$, esso coincide con l'intero piano cartesiano.
- **Tre vettori non complanari in $\mathbb{R}^3$**: generano l'intero spazio tridimensionale $\mathbb{R}^3$.
- **$k$ vettori in $\mathbb{R}^n$**: generano un sottospazio o **iperpiano** lineare passante per l'origine di dimensione al più $k$.

Un sottoinsieme non vuoto $W \subseteq V$ è un **sottospazio vettoriale** di $V$ se eredita la struttura di spazio vettoriale, ovvero se:
1. Contiene il vettore nullo: $\mathbf{0} \in W$
2. È chiuso rispetto alla somma: $\mathbf{u}, \mathbf{w} \in W \implies \mathbf{u} + \mathbf{w} \in W$
3. È chiuso rispetto al prodotto scalare: $\lambda \in \mathbb{R}, \mathbf{w} \in W \implies \lambda \mathbf{w} \in W$

> **Insight:** Ogni sottospazio vettoriale deve passare inderogabilmente per l'origine: se una retta o un piano non interseca $\mathbf{0}$, non può essere un sottospazio vettoriale perché violerebbe la chiusura algebrica.

## Dimostrazione: Lo Spazio Generato Span(S) è un Sottospazio Vettoriale

### 1. Appartenenza del Vettore Nullo
Poniamo tutti i coefficienti scalari della combinazione lineare pari a zero: $c_1 = c_2 = \dots = c_k = 0 \in \mathbb{R}$.
Calcolando la combinazione lineare risultante:
$$\mathbf{w}_0 = \sum_{i=1}^k 0 \cdot \mathbf{v}_i = 0 \cdot \mathbf{v}_1 + \dots + 0 \cdot \mathbf{v}_k = \mathbf{0} + \dots + \mathbf{0} = \mathbf{0}$$
Poiché i pesi nulli sono numeri reali ammissibili, deduciamo che $\mathbf{0} \in \text{Span}(\mathcal{S})$.
> **Insight:** L'origine dello spazio è sempre raggiungibile ponendo a zero tutti i contributi dei vettori generatori.

### 2. Chiusura rispetto alla Somma Vettoriale
Siano $\mathbf{u}, \mathbf{w} \in \text{Span}(\mathcal{S})$. Per definizione di Span, esistono scalari $a_1, \dots, a_k \in \mathbb{R}$ e $b_1, \dots, b_k \in \mathbb{R}$ tali che:
$$\mathbf{u} = \sum_{i=1}^k a_i \mathbf{v}_i, \quad \mathbf{w} = \sum_{i=1}^k b_i \mathbf{v}_i$$
Sommiamo i due vettori applicando l'associatività e la commutatività della somma vettoriale:
$$\mathbf{u} + \mathbf{w} = \left( \sum_{i=1}^k a_i \mathbf{v}_i \right) + \left( \sum_{i=1}^k b_i \mathbf{v}_i \right) = \sum_{i=1}^k (a_i \mathbf{v}_i + b_i \mathbf{v}_i) = \sum_{i=1}^k (a_i + b_i) \mathbf{v}_i$$
Poiché $\mathbb{R}$ è un campo chiuso rispetto all'addizione, ciascun coefficiente $(a_i + b_i) \in \mathbb{R}$. Dunque la somma $\mathbf{u} + \mathbf{w}$ è ancora una combinazione lineare di vettori di $\mathcal{S}$, ossia $\mathbf{u} + \mathbf{w} \in \text{Span}(\mathcal{S})$.
> **Insight:** Sommare due elementi dello Span equivale semplicemente a sommare i rispettivi pesi scalari coordinata per coordinata.

### 3. Chiusura rispetto alla Moltiplicazione Scalare
Sia $\mathbf{u} \in \text{Span}(\mathcal{S})$ con $\mathbf{u} = \sum_{i=1}^k a_i \mathbf{v}_i$, e sia $\lambda \in \mathbb{R}$ un qualsiasi scalare reale.
Calcoliamo il prodotto scalare $\lambda \mathbf{u}$:
$$\lambda \mathbf{u} = \lambda \left( \sum_{i=1}^k a_i \mathbf{v}_i \right) = \sum_{i=1}^k \lambda (a_i \mathbf{v}_i) = \sum_{i=1}^k (\lambda a_i) \mathbf{v}_i$$
Poiché il prodotto $\lambda a_i \in \mathbb{R}$ per ogni $i$, il vettore $\lambda \mathbf{u}$ è una combinazione lineare lecita di elementi di $\mathcal{S}$, dunque $\lambda \mathbf{u} \in \text{Span}(\mathcal{S})$.
Tutte e tre le condizioni di sottospazio sono rigorosamente verificate.
> **Insight:** Riscalare un elemento non fa mai uscire il vettore dalla regione geometrica generata dai vettori base.

### Corollario: Minimalità del Sottospazio Generato (Intersezione di Sottospazi)
Lo spazio generato $\text{Span}(\mathcal{S})$ è il **più piccolo** sottospazio vettoriale di $V$ contenente l'insieme di vettori $\mathcal{S}$. In modo equivalente, esso coincide esattamente con l'intersezione di tutti i sottospazi vettoriali di $V$ che contengono $\mathcal{S}$:
$$\text{Span}(\mathcal{S}) = \bigcap \{ U \subseteq V \mid U \text{ è sottospazio vettoriale di } V \text{ e } \mathcal{S} \subseteq U \}$$
#### Dimostrazione del Corollario
Sia $U$ un generico sottospazio vettoriale di $V$ tale che $\mathcal{S} \subseteq U$.
Ciò significa che $\mathbf{v}_i \in U$ per ogni $i \in \{1, \dots, k\}$.
Poiché $U$ è un sottospazio vettoriale, esso è chiuso rispetto alla moltiplicazione per scalari: per qualunque $c_i \in \mathbb{R}$, il vettore $c_i \mathbf{v}_i \in U$.
Inoltre, $U$ è chiuso rispetto alla somma vettoriale: per ogni successione finita di termini in $U$, la loro somma appartiene ancora a $U$:
$$\sum_{i=1}^k c_i \mathbf{v}_i \in U \quad \forall c_1, \dots, c_k \in \mathbb{R}$$
Questo dimostra che qualsiasi combinazione lineare di elementi di $\mathcal{S}$ deve necessariamente appartenere a $U$:
$$\text{Span}(\mathcal{S}) \subseteq U$$
Poiché questo vale per ogni sottospazio $U$ contenente $\mathcal{S}$, e poiché $\text{Span}(\mathcal{S})$ è esso stesso un sottospazio contenente $\mathcal{S}$ (in quanto $\mathbf{v}_i = 1 \cdot \mathbf{v}_i \in \text{Span}(\mathcal{S})$), concludiamo che $\text{Span}(\mathcal{S})$ coincide con l'intersezione di tutti tali sottospazi ed è quindi il minimo assoluto.
> **Insight:** Lo Span non include elementi superflui: contiene solo e soltanto i vettori strettamente indispensabili a soddisfare le leggi di chiusura algebrica.

### Corollario: Collasso Dimensionale per Vettori Paralleli
Se due vettori $\mathbf{v}_1, \mathbf{v}_2 \in V$ sono collineari (ovvero esiste uno scalare $k \in \mathbb{R}$ tale che $\mathbf{v}_2 = k \mathbf{v}_1$), allora lo spazio generato dalla coppia collassa dimensionalmente sullo spazio generato dal singolo vettore:
$$\mathbf{v}_2 = k \mathbf{v}_1 \implies \text{Span}(\mathbf{v}_1, \mathbf{v}_2) = \text{Span}(\mathbf{v}_1)$$
#### Dimostrazione del Corollario
Dimostriamo la doppia inclusione insiemistica:
1. *Inclusione $\text{Span}(\mathbf{v}_1) \subseteq \text{Span}(\mathbf{v}_1, \mathbf{v}_2)$*:
Sia $\mathbf{w} \in \text{Span}(\mathbf{v}_1)$, ossia $\mathbf{w} = c_1 \mathbf{v}_1$. Possiamo riscrivere $\mathbf{w} = c_1 \mathbf{v}_1 + 0 \cdot \mathbf{v}_2 \in \text{Span}(\mathbf{v}_1, \mathbf{v}_2)$.
2. *Inclusione $\text{Span}(\mathbf{v}_1, \mathbf{v}_2) \subseteq \text{Span}(\mathbf{v}_1)$*:
Sia $\mathbf{w} \in \text{Span}(\mathbf{v}_1, \mathbf{v}_2)$, dunque esistono $c_1, c_2 \in \mathbb{R}$ tali che $\mathbf{w} = c_1 \mathbf{v}_1 + c_2 \mathbf{v}_2$.
Sostituendo l'ipotesi di collinearità $\mathbf{v}_2 = k \mathbf{v}_1$:
$$\mathbf{w} = c_1 \mathbf{v}_1 + c_2 (k \mathbf{v}_1)$$
Applicando la compatibilità scalare e raccogliendo a fattor comune $\mathbf{v}_1$ tramite distributività:
$$\mathbf{w} = c_1 \mathbf{v}_1 + (c_2 k)\mathbf{v}_1 = (c_1 + c_2 k)\mathbf{v}_1$$
Ponendo $\gamma = c_1 + c_2 k \in \mathbb{R}$, otteniamo $\mathbf{w} = \gamma \mathbf{v}_1 \in \text{Span}(\mathbf{v}_1)$.
Essendo verificate entrambe le inclusioni, si ha l'uguaglianza rigorosa degli insiemi: $\text{Span}(\mathbf{v}_1, \mathbf{v}_2) = \text{Span}(\mathbf{v}_1)$.
> **Insight:** Il secondo vettore non introduce alcuna nuova traiettoria indipendente: l'intero piano potenziale collassa in una singola retta monodimensionale passante per l'origine.
