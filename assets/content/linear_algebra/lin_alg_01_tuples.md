---
id: lin_alg_01_tuples
title: "Spazio Vettoriale Rn e Concetto di n-upla Ordinata"
category: "Matematica"
subCategory: "Algebra Lineare"
prerequisites:
  - mat_add_01
  - mat_pythagoras_01
interactive:
  template: vector_2d
  unit: ""
  equations:
    - "sqrt(x1 * x1 + x2 * x2)"
  parameters:
    - variable: x1
      label: "Coordinata x₁"
      unit: ""
      min: -10.0
      max: 10.0
      default: 3.0
      step: 0.5
    - variable: x2
      label: "Coordinata x₂"
      unit: ""
      min: -10.0
      max: 10.0
      default: 4.0
      step: 0.5
---

### Dalle Coordinate Cartesiane allo Spazio Euclideo n-Dimensionale

Lo spazio euclideo $\mathbb{R}^n$ costituisce il fondamento algebrico e geometrico dell'algebra lineare. Esso generalizza in modo naturale la nozione intuitiva di punto e vettore dal piano cartesiano bidimensionale ($\mathbb{R}^2$) e dallo spazio tridimensionale ($\mathbb{R}^3$) a un numero arbitrario $n$ di dimensioni.

Formalmente, lo spazio $\mathbb{R}^n$ è definito come il prodotto cartesiano di $n$ copie dell'insieme dei numeri reali $\mathbb{R}$:

$$\mathbb{R}^n \equiv \underbrace{\mathbb{R} \times \mathbb{R} \times \dots \times \mathbb{R}}_{n \text{ volte}} = \left\{ (x_1, x_2, \dots, x_n) \mid x_i \in \mathbb{R}, \; \forall i \in \{1, 2, \dots, n\} \right\}$$

Ogni elemento $\mathbf{x} \in \mathbb{R}^n$ è una **$n$-upla ordinata** di numeri reali, in cui la posizione di ciascun elemento è rigorosamente determinata. Due $n$-uple ordinate sono identiche se e solo se coincidono ordinatamente in tutte le loro componenti:

$$(x_1, x_2, \dots, x_n) = (y_1, y_2, \dots, y_n) \iff x_i = y_i \quad \forall i \in \{1, 2, \dots, n\}$$

> **Insight:** L'ordinamento è essenziale: la coppia $(3, 4)$ individua un punto ben distinto da $(4, 3)$ nel piano. Ogni coordinata rappresenta l'intensità della proiezione lungo una direzione indipendente dello spazio.

Su questo insieme si definiscono naturalmente due operazioni algebriche fondamentali:
1. **Somma componente per componente**:
$$\mathbf{x} + \mathbf{y} = (x_1 + y_1, x_2 + y_2, \dots, x_n + y_n)$$
2. **Moltiplicazione per uno scalare** $\lambda \in \mathbb{R}$:
$$\lambda \mathbf{x} = (\lambda x_1, \lambda x_2, \dots, \lambda x_n)$$

La distanza geometrica tra due punti nello spazio euclideo $\mathbb{R}^n$ si fonda sull'estensione per induzione del Teorema di Pitagora:

$$d(\mathbf{x}, \mathbf{y}) = \sqrt{\sum_{i=1}^n (x_i - y_i)^2}$$

> **Insight:** La geometria multidimensionale non richiede una visione spaziale a $n$ dimensioni: la metrica algebrica calcola lunghezze e distanze con identica semplicità in 2, 3 o 1000 dimensioni.

## Dimostrazione: Costruzione della Metrica Euclidea e Proprietà dello Spazio Rn

### 1. Definizione e Ipotesi Metrica nel Piano R2
Dati due punti $P_1(x_1, x_2)$ e $P_2(y_1, y_2)$ nel piano cartesiano $\mathbb{R}^2$, consideriamo il triangolo rettangolo avente per cateti i segmenti paralleli agli assi coordinati di lunghezze $|x_1 - y_1|$ e $|x_2 - y_2|$. Per il Teorema di Pitagora, il quadrato della distanza euclidea tra $P_1$ e $P_2$ vale:
$$d_2(P_1, P_2)^2 = (x_1 - y_1)^2 + (x_2 - y_2)^2$$
> **Insight:** La distanza è l'ipotenusa del triangolo formato dalle differenze coordinate lungo le direzioni ortogonali.

### 2. Generalizzazione per Induzione a R3
Introducendo una terza coordinata ortogonale $x_3, y_3$, la nuova distanza al quadrato $d_3^2$ è data dalla somma del quadrato della distanza piana $d_2^2$ e del quadrato dell'ulteriore variazione ortogonale $(x_3 - y_3)^2$:
$$d_3^2 = d_2^2 + (x_3 - y_3)^2 = (x_1 - y_1)^2 + (x_2 - y_2)^2 + (x_3 - y_3)^2$$
> **Insight:** Ciascuna nuova dimensione ortogonale aggiunge semplicemente un termine quadratico additivo indipendente.

### 3. Formulazione della Metrica Euclidea in Rn
Iterando il ragionamento per un numero finito qualsiasi $n \in \mathbb{N}$ di coordinate mutuamente ortogonali, estraendo la radice quadrata principale non negativa si ottiene la funzione metrica standard di $\mathbb{R}^n$:
$$d(\mathbf{x}, \mathbf{y}) = \sqrt{\sum_{i=1}^n (x_i - y_i)^2}$$
> **Insight:** La metrica euclidea traduce il concetto fisico di distanza geometrica in una formula algebrica rigorosa applicabile a qualunque dimensione.

### Corollario: Norma Euclidea e Disuguaglianza di Cauchy-Schwarz
Posta la norma euclidea di un'ordinata $n$-upla come la sua distanza dall'origine $\|\mathbf{x}\| = d(\mathbf{x}, \mathbf{0}) = \sqrt{\sum_{i=1}^n x_i^2}$, per ogni coppia di vettori $\mathbf{x}, \mathbf{y} \in \mathbb{R}^n$ vale la disuguaglianza fondamentale di Cauchy-Schwarz:
$$\left| \sum_{i=1}^n x_i y_i \right| \le \|\mathbf{x}\| \cdot \|\mathbf{y}\| = \sqrt{\sum_{i=1}^n x_i^2} \cdot \sqrt{\sum_{i=1}^n y_i^2}$$
#### Dimostrazione del Corollario
Consideriamo la funzione quadratica ausiliaria definita per ogni $t \in \mathbb{R}$ da $P(t) = \sum_{i=1}^n (x_i t + y_i)^2 \ge 0$.
Sviluppando il quadrato del binomio per ciascun termine della sommatoria:
$$P(t) = \sum_{i=1}^n (x_i^2 t^2 + 2 x_i y_i t + y_i^2) = t^2 \left( \sum_{i=1}^n x_i^2 \right) + 2 t \left( \sum_{i=1}^n x_i y_i \right) + \left( \sum_{i=1}^n y_i^2 \right) \ge 0$$
Poiché il trinomio di secondo grado $A t^2 + B t + C \ge 0$ è non negativo per ogni $t \in \mathbb{R}$ con $A = \|\mathbf{x}\|^2 > 0$, il suo discriminante ridotto $\Delta / 4$ deve essere necessariamente minore o uguale a zero:
$$\frac{\Delta}{4} = \left( \sum_{i=1}^n x_i y_i \right)^2 - \left( \sum_{i=1}^n x_i^2 \right) \left( \sum_{i=1}^n y_i^2 \right) \le 0$$
Isolando il quadrato del prodotto scalare ed estraendo la radice quadrata ambo i membri:
$$\left( \sum_{i=1}^n x_i y_i \right)^2 \le \|\mathbf{x}\|^2 \|\mathbf{y}\|^2 \implies \left| \sum_{i=1}^n x_i y_i \right| \le \|\mathbf{x}\| \|\mathbf{y}\|$$
> **Insight:** La disuguaglianza di Cauchy-Schwarz garantisce che il coseno dell'angolo tra due direzioni nello spazio $n$-dimensionale sia sempre compreso nell'intervallo $[-1, 1]$, fondando la geometria degli angoli in $\mathbb{R}^n$.

### Corollario: Unicità dell'Elemento Neutro e Inverso Additivo
Nello spazio $\mathbb{R}^n$ dotato della somma componente per componente, esiste un unico elemento neutro additivo $\mathbf{0} = (0, 0, \dots, 0)$ e ogni elemento $\mathbf{x} = (x_1, \dots, x_n)$ ammette un unico inverso additivo $-\mathbf{x} = (-x_1, \dots, -x_n)$:
$$\mathbf{x} + \mathbf{0} = \mathbf{x} \quad \land \quad \mathbf{x} + (-\mathbf{x}) = \mathbf{0}$$
#### Dimostrazione del Corollario
Per la definizione di somma in $\mathbb{R}^n$:
$$\mathbf{x} + \mathbf{0} = (x_1 + 0, x_2 + 0, \dots, x_n + 0) = (x_1, x_2, \dots, x_n) = \mathbf{x}$$
Se esistesse un secondo elemento neutro $\mathbf{0}' \in \mathbb{R}^n$, applicando l'ipotesi di neutralità di entrambi:
$$\mathbf{0} = \mathbf{0} + \mathbf{0}' = \mathbf{0}' \implies \mathbf{0} = \mathbf{0}'$$
Analogamente, sommando $\mathbf{x}$ con $(-\mathbf{x})$:
$$\mathbf{x} + (-\mathbf{x}) = (x_1 + (-x_1), x_2 + (-x_2), \dots, x_n + (-x_n)) = (0, 0, \dots, 0) = \mathbf{0}$$
Se $\mathbf{y}$ fosse un altro inverso additivo tale che $\mathbf{x} + \mathbf{y} = \mathbf{0}$, sommando $(-\mathbf{x})$ ad ambo i membri:
$$(-\mathbf{x}) + (\mathbf{x} + \mathbf{y}) = (-\mathbf{x}) + \mathbf{0} \implies ((-\mathbf{x}) + \mathbf{x}) + \mathbf{y} = -\mathbf{x} \implies \mathbf{0} + \mathbf{y} = -\mathbf{x} \implies \mathbf{y} = -\mathbf{x}$$
> **Insight:** L'unicità dell'origine e del vettore opposto discende direttamente dalle proprietà di campo algebrico dei numeri reali su ciascuna coordinata.
