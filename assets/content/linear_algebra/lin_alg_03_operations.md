---
id: lin_alg_03_operations
title: "Operazioni Vettoriali Fondamentali e Assiomi di Spazio Vettoriale"
category: "Matematica"
subCategory: "Algebra Lineare"
prerequisites:
  - lin_alg_02_vectors
interactive:
  template: vector_addition
  unit: ""
  equations:
    - "v1x + v2x"
    - "v1y + v2y"
  parameters:
    - variable: v1x
      label: "Vettore v₁ (x)"
      unit: ""
      min: -5.0
      max: 5.0
      default: 3.0
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
      default: 1.0
      step: 0.5
    - variable: v2y
      label: "Vettore v₂ (y)"
      unit: ""
      min: -5.0
      max: 5.0
      default: 4.0
      step: 0.5
---

### Somma Vettoriale, Moltiplicazione Scalare e la Struttura di Spazio Vettoriale

L'algebra lineare prende vita nel momento in cui definiamo come combinare i vettori tra loro e come riscalarmi tramite numeri reali (detti *scalari*).

Sia dato un insieme non vuoto $V$ su cui sono definite due operazioni:
1. **Somma vettoriale interna**: $+ : V \times V \to V$, che associa a ogni coppia $(\mathbf{u}, \mathbf{v})$ il vettore $\mathbf{u} + \mathbf{v}$.
2. **Moltiplicazione per uno scalare esterna**: $\cdot : \mathbb{R} \times V \to V$, che associa a ogni scalare $\lambda \in \mathbb{R}$ e vettore $\mathbf{v} \in V$ il vettore $\lambda \mathbf{v}$.

Geometricamente nel piano cartesiano, la somma tra due vettori $\mathbf{u}$ e $\mathbf{v}$ ammette due interpretazioni del tutto equivalenti:
- **Regola del parallelogramma**: applicando entrambi i vettori nell'origine $O$, il vettore somma $\mathbf{u} + \mathbf{v}$ coincide con la diagonale principale del parallelogramma avente per lati adiacenti $\mathbf{u}$ e $\mathbf{v}$.
- **Regola punta-coda**: traslando il secondo vettore $\mathbf{v}$ in modo che la sua coda coincida con la punta di $\mathbf{u}$, la somma è il segmento orientato che congiunge la coda di $\mathbf{u}$ con la punta di $\mathbf{v}$.

Algebricamente in $\mathbb{R}^n$, la somma e il prodotto scalare operano componente per componente:

$$\mathbf{u} + \mathbf{v} = \begin{pmatrix} u_1 + v_1 \\ \vdots \\ u_n + v_n \end{pmatrix}, \quad \lambda \mathbf{v} = \begin{pmatrix} \lambda v_1 \\ \vdots \\ \lambda v_n \end{pmatrix}$$

> **Insight:** Il metodo punta-coda illustra la composizione intuitiva degli spostamenti nel piano: compiere prima lo spostamento $\mathbf{u}$ e successivamente lo spostamento $\mathbf{v}$ porta esattamente al punto finale dato dal vettore somma $\mathbf{u} + \mathbf{v}$.

Per elevare questa struttura geometrica a teoria algebrica universale, $(V, +, \cdot)$ deve soddisfare gli **8 Assiomi di Spazio Vettoriale**:
1. *Associatività della somma*: $(\mathbf{u} + \mathbf{v}) + \mathbf{w} = \mathbf{u} + (\mathbf{v} + \mathbf{w})$
2. *Commutatività della somma*: $\mathbf{u} + \mathbf{v} = \mathbf{v} + \mathbf{u}$
3. *Elemento neutro additivo*: $\exists \mathbf{0} \in V \text{ tale che } \mathbf{v} + \mathbf{0} = \mathbf{v}, \; \forall \mathbf{v} \in V$
4. *Elemento opposto additivo*: $\forall \mathbf{v} \in V, \; \exists (-\mathbf{v}) \in V \text{ tale che } \mathbf{v} + (-\mathbf{v}) = \mathbf{0}$
5. *Distributività dello scalare rispetto alla somma vettoriale*: $\lambda (\mathbf{u} + \mathbf{v}) = \lambda \mathbf{u} + \lambda \mathbf{v}$
6. *Distributività del vettore rispetto alla somma scalare*: $(\lambda + \mu)\mathbf{v} = \lambda \mathbf{v} + \mu \mathbf{v}$
7. *Compatibilità tra prodotti*: $(\lambda \mu)\mathbf{v} = \lambda (\mu \mathbf{v})$
8. *Elemento neutro moltiplicativo*: $1 \cdot \mathbf{v} = \mathbf{v}$

> **Insight:** Gli 8 assiomi garantiscono che manipolare i vettori rispetti le stesse regole dell'aritmetica lineare ordinaria, permettendo di trattare collezioni di numeri come singoli oggetti algebrici.

## Dimostrazione: Assiomi di Spazio Vettoriale e Proprietà Fondamentali

### 1. Verifica della Commutatività e Associatività in Rn
Siano $\mathbf{u} = (u_1, \dots, u_n)^T$ e $\mathbf{v} = (v_1, \dots, v_n)^T$. Poiché la somma in $\mathbb{R}$ è commutativa ($u_i + v_i = v_i + u_i$ per ogni $i$):
$$\mathbf{u} + \mathbf{v} = \begin{pmatrix} u_1 + v_1 \\ \vdots \\ u_n + v_n \end{pmatrix} = \begin{pmatrix} v_1 + u_1 \\ \vdots \\ v_n + u_n \end{pmatrix} = \mathbf{v} + \mathbf{u}$$
Analogamente, l'associatività $(u_i + v_i) + w_i = u_i + (v_i + w_i)$ si estende termine a termine garantendo $(\mathbf{u} + \mathbf{v}) + \mathbf{w} = \mathbf{u} + (\mathbf{v} + \mathbf{w})$.
> **Insight:** Le proprietà del gruppo abeliano $(V, +)$ derivano direttamente dall'eredità algebrica del campo dei numeri reali su ciascuna coordinata.

### 2. Verifica delle Proprietà Distributive
Siano $\lambda, \mu \in \mathbb{R}$. Applicando la proprietà distributiva dei numeri reali a ciascuna componente:
$$\lambda (\mathbf{u} + \mathbf{v}) = \begin{pmatrix} \lambda(u_1 + v_1) \\ \vdots \\ \lambda(u_n + v_n) \end{pmatrix} = \begin{pmatrix} \lambda u_1 + \lambda v_1 \\ \vdots \\ \lambda u_n + \lambda v_n \end{pmatrix} = \lambda \mathbf{u} + \lambda \mathbf{v}$$
$$(\lambda + \mu)\mathbf{v} = \begin{pmatrix} (\lambda + \mu)v_1 \\ \vdots \\ (\lambda + \mu)v_n \end{pmatrix} = \begin{pmatrix} \lambda v_1 + \mu v_1 \\ \vdots \\ \lambda v_n + \mu v_n \end{pmatrix} = \lambda \mathbf{v} + \mu \mathbf{v}$$
> **Insight:** La linearità è duplice: rispetto alla composizione dei vettori e rispetto alla variazione continua dei parametri scalari.

### 3. Equivalenza Geometrica: Regola del Parallelogramma e Proiezioni
Nel piano $\mathbb{R}^2$, le proiezioni ortogonali della diagonale del parallelogramma sugli assi $x$ e $y$ corrispondono alla somma delle proiezioni dei singoli vettori addendi:
$$x_{\text{somma}} = u_x + v_x, \quad y_{\text{somma}} = u_y + v_y$$
La composizione geometrica dei vettori coincide esattamente con l'operazione algebrica di somma in coordinate.
> **Insight:** La geometria sintetica euclidea e l'algebra lineare cartesiana convergono nella medesima formulazione rigorosa.

### Corollario: Annullamento del Prodotto Scalare-Vettore (0 v = 0)
Per qualunque vettore $\mathbf{v}$ appartenente a uno spazio vettoriale $V$, il prodotto tra lo scalare zero $0 \in \mathbb{R}$ e il vettore $\mathbf{v}$ produce invariabilmente il vettore nullo $\mathbf{0} \in V$:
$$0 \cdot \mathbf{v} = \mathbf{0}$$
#### Dimostrazione del Corollario
Nei numeri reali, lo zero è l'elemento neutro additivo: $0 + 0 = 0$.
Moltiplichiamo entrambi i membri di questa uguaglianza reale per il vettore $\mathbf{v}$:
$$(0 + 0)\mathbf{v} = 0 \cdot \mathbf{v}$$
Applicando l'assioma di distributività della moltiplicazione rispetto alla somma di scalari $(\lambda + \mu)\mathbf{v} = \lambda \mathbf{v} + \mu \mathbf{v}$:
$$0 \cdot \mathbf{v} + 0 \cdot \mathbf{v} = 0 \cdot \mathbf{v}$$
Poiché $0 \cdot \mathbf{v} \in V$, esso possiede un opposto additivo $-(0 \cdot \mathbf{v})$. Aggiungiamo $-(0 \cdot \mathbf{v})$ a entrambi i membri dell'equazione:
$$(0 \cdot \mathbf{v} + 0 \cdot \mathbf{v}) + (-(0 \cdot \mathbf{v})) = 0 \cdot \mathbf{v} + (-(0 \cdot \mathbf{v}))$$
Sfruttando l'associatività della somma vettoriale a primo membro e la definizione di opposto a secondo membro:
$$0 \cdot \mathbf{v} + (0 \cdot \mathbf{v} + (-(0 \cdot \mathbf{v}))) = \mathbf{0} \implies 0 \cdot \mathbf{v} + \mathbf{0} = \mathbf{0}$$
Poiché $\mathbf{0}$ è l'elemento neutro additivo:
$$0 \cdot \mathbf{v} = \mathbf{0}$$
> **Insight:** L'annullamento non è una convenzione arbitraria: è una conseguenza logica necessaria degli assiomi di distributività e dell'esistenza dell'inverso additivo.

### Corollario: Opposto Vettoriale e Moltiplicazione per -1
Per ogni vettore $\mathbf{v} \in V$, l'inverso additivo $-\mathbf{v}$ coincide esattamente con il prodotto tra lo scalare $-1$ e il vettore $\mathbf{v}$:
$$(-1)\mathbf{v} = -\mathbf{v}$$
#### Dimostrazione del Corollario
Consideriamo la somma vettoriale tra $\mathbf{v}$ e $(-1)\mathbf{v}$:
$$\mathbf{v} + (-1)\mathbf{v}$$
Per l'assioma dell'elemento neutro moltiplicativo, possiamo scrivere $\mathbf{v} = 1 \cdot \mathbf{v}$:
$$\mathbf{v} + (-1)\mathbf{v} = 1 \cdot \mathbf{v} + (-1)\mathbf{v}$$
Raccogliendo a fattor comune il vettore $\mathbf{v}$ mediante l'assioma di distributività della somma scalare:
$$1 \cdot \mathbf{v} + (-1)\mathbf{v} = (1 + (-1))\mathbf{v}$$
Nel campo dei numeri reali, $1 + (-1) = 0$. Sostituendo:
$$(1 + (-1))\mathbf{v} = 0 \cdot \mathbf{v}$$
Per il corollario precedente sull'annullamento scalare, $0 \cdot \mathbf{v} = \mathbf{0}$. Si deduce pertanto:
$$\mathbf{v} + (-1)\mathbf{v} = \mathbf{0}$$
Per l'unicità dell'inverso additivo dimostrata negli assiomi di gruppo, l'elemento che sommato a $\mathbf{v}$ restituisce $\mathbf{0}$ è univocamente determinato ed è l'opposto $-\mathbf{v}$:
$$(-1)\mathbf{v} = -\mathbf{v}$$
> **Insight:** Moltiplicare un vettore per lo scalare negativo $-1$ ne inverte geometricamente il verso di 180°, conservandone inalterati il modulo e la direzione.
