---
id: lin_alg_05_independence
title: "Dipendenza e Indipendenza Lineare dei Vettori"
category: "Matematica"
subCategory: "Algebra Lineare"
prerequisites:
  - lin_alg_04_span
interactive:
  template: span_2d
  unit: ""
  equations:
    - "v1x * v2y - v1y * v2x"
  parameters:
    - variable: v1x
      label: "Vettore v₁ (x)"
      unit: ""
      min: -10.0
      max: 10.0
      default: 2.0
      step: 0.5
    - variable: v1y
      label: "Vettore v₁ (y)"
      unit: ""
      min: -10.0
      max: 10.0
      default: 3.0
      step: 0.5
    - variable: v2x
      label: "Vettore v₂ (x)"
      unit: ""
      min: -10.0
      max: 10.0
      default: -4.0
      step: 0.5
    - variable: v2y
      label: "Vettore v₂ (y)"
      unit: ""
      min: -10.0
      max: 10.0
      default: -6.0
      step: 0.5
---

### Informazione Geometrica, Ridondanza e Indipendenza Lineare

Uno dei cardini dell'algebra lineare è comprendere quando un insieme di vettori offre direzioni di movimento realmente nuove oppure include elementi ridondanti, già interamente descrivibili come combinazione lineare dei rimanenti.

Sia $V$ uno spazio vettoriale su $\mathbb{R}$. Un insieme finito di vettori $\mathcal{S} = \{\mathbf{v}_1, \mathbf{v}_2, \dots, \mathbf{v}_k\}$ si definisce **linearmente indipendente** se l'unica combinazione lineare che produce il vettore nullo è quella avente tutti i coefficienti scalari identicamente nulli (la soluzione banale):

$$\sum_{i=1}^k c_i \mathbf{v}_i = c_1 \mathbf{v}_1 + c_2 \mathbf{v}_2 + \dots + c_k \mathbf{v}_k = \mathbf{0} \implies c_1 = c_2 = \dots = c_k = 0$$

Al contrario, l'insieme $\mathcal{S}$ si dice **linearmente dipendente** se esiste almeno una combinazione lineare nulla a coefficienti **non tutti nulli**:

$$\exists (c_1, c_2, \dots, c_k) \neq (0, 0, \dots, 0) \quad \text{tale che} \quad \sum_{i=1}^k c_i \mathbf{v}_i = \mathbf{0}$$

> **Insight:** Se un insieme è linearmente dipendente, almeno una delle frecce è superflua: essa non aggiunge alcuna dimensione geometrica allo spazio generato, poiché giace già nel territorio tracciato dalle altre.

Il significato geometrico dell'indipendenza varia in base alla dimensione:
- **Nel piano $\mathbb{R}^2$**: due vettori sono linearmente dipendenti se e solo se sono **collineari** (giacciono sulla stessa retta passante per l'origine). Se non sono collineari, sono indipendenti e il loro Span genera l'intero piano $\mathbb{R}^2$.
- **Nello spazio $\mathbb{R}^3$**: tre vettori sono linearmente dipendenti se e solo se sono **complanari** (giacciono sullo stesso piano passante per l'origine). Se non sono complanari, generano l'intero spazio tridimensionale.
- **In $\mathbb{R}^n$**: ogni insieme di $k > n$ vettori è necessariamente linearmente dipendente.

La condizione di indipendenza tra due vettori nel piano $\mathbf{u} = (u_x, u_y)^T$ e $\mathbf{v} = (v_x, v_y)^T$ si traduce istantaneamente nel calcolo del **determinante 2D**:

$$\det \begin{pmatrix} u_x & v_x \\ u_y & v_y \end{pmatrix} = u_x v_y - u_y v_x$$

Il valore assoluto di questo determinante rappresenta l'**area orientata del parallelogramma** avente per lati $\mathbf{u}$ e $\mathbf{v}$. I due vettori sono indipendenti se e solo se tale area è non nulla.

> **Insight:** Il determinante misura il volume generato dai vettori. Se i vettori collassano su una retta comune, il parallelogramma si schiaccia, l'area diventa zero e il determinante si annulla.

## Dimostrazione: Teorema Fondamentale della Dipendenza Lineare

### 1. Enunciato del Criterio di Dipendenza Lineare
Sia $\mathcal{S} = \{\mathbf{v}_1, \dots, \mathbf{v}_k\}$ un insieme di $k \ge 2$ vettori in uno spazio vettoriale $V$. L'insieme $\mathcal{S}$ è linearmente dipendente se e solo se almeno uno dei vettori $\mathbf{v}_j$ può essere espresso come combinazione lineare dei rimanenti vettori di $\mathcal{S}$:
$$\exists j \in \{1, \dots, k\} \quad \text{tale che} \quad \mathbf{v}_j = \sum_{i \neq j} \lambda_i \mathbf{v}_i$$
> **Insight:** Un vettore dipendente è un duplicato informativo: può essere ricostruito come somma pesata degli altri.

### 2. Dimostrazione della Condizione Necessaria (=>)
Supponiamo per ipotesi che $\mathcal{S}$ sia linearmente dipendente.
Per definizione, esistono scalari $c_1, \dots, c_k \in \mathbb{R}$ non tutti nulli tali che:
$$\sum_{i=1}^k c_i \mathbf{v}_i = c_1 \mathbf{v}_1 + \dots + c_k \mathbf{v}_k = \mathbf{0}$$
Sia $c_j \neq 0$ uno dei coefficienti non nulli (sicuramente esistente per ipotesi).
Isoliamo il termine $j$-esimo a primo membro, sottraendo tutti gli altri termini:
$$c_j \mathbf{v}_j = - \sum_{i \neq j} c_i \mathbf{v}_i = \sum_{i \neq j} (-c_i) \mathbf{v}_i$$
Poiché $c_j \neq 0$, possiamo moltiplicare entrambi i membri per lo scalare reciproco $\frac{1}{c_j} \in \mathbb{R}$:
$$\mathbf{v}_j = \frac{1}{c_j} \left( \sum_{i \neq j} (-c_i) \mathbf{v}_i \right) = \sum_{i \neq j} \left( -\frac{c_i}{c_j} \right) \mathbf{v}_i$$
Ponendo $\lambda_i = -\frac{c_i}{c_j} \in \mathbb{R}$, abbiamo espresso $\mathbf{v}_j$ come combinazione lineare dei vettori rimanenti.
> **Insight:** Il fatto che il coefficiente sia non nullo consente la divisione algebrica senza singolarità.

### 3. Dimostrazione della Condizione Sufficiente (<=)
Supponiamo viceversa che esista un vettore $\mathbf{v}_j$ esprimibile come combinazione lineare degli altri:
$$\mathbf{v}_j = \sum_{i \neq j} a_i \mathbf{v}_i$$
Riportando $\mathbf{v}_j$ a secondo membro sottraendolo:
$$\sum_{i \neq j} a_i \mathbf{v}_i + (-1) \mathbf{v}_j = \mathbf{0}$$
Questa è una combinazione lineare nulla della forma $\sum_{i=1}^k c_i \mathbf{v}_i = \mathbf{0}$, in cui il coefficiente di $\mathbf{v}_j$ è $c_j = -1 \neq 0$.
Poiché esiste almeno un coefficiente non nullo (ovvero $-1 \neq 0$), l'insieme $\mathcal{S}$ è linearmente dipendente per definizione.
> **Insight:** Spostare il vettore al membro opposto genera immediatamente il coefficiente $-1$, garantendo l'esistenza di una soluzione non banale.

### Corollario: Criterio di Dipendenza Lineare del Vettore Nullo
Qualunque insieme finito di vettori $\mathcal{S} = \{\mathbf{v}_1, \dots, \mathbf{v}_k\} \subset V$ che contenga il vettore nullo $\mathbf{0}$ è necessariamente linearmente dipendente:
$$\mathbf{0} \in \mathcal{S} \implies \mathcal{S} \text{ è linearmente dipendente}$$
#### Dimostrazione del Corollario
Sia $\mathcal{S} = \{\mathbf{0}, \mathbf{v}_2, \dots, \mathbf{v}_k\}$.
Costruiamo la seguente combinazione lineare di elementi di $\mathcal{S}$:
$$c_1 \mathbf{0} + c_2 \mathbf{v}_2 + \dots + c_k \mathbf{v}_k$$
Scegliamo i seguenti coefficienti scalari:
$$c_1 = 1 \neq 0, \quad c_2 = 0, \quad c_3 = 0, \quad \dots, \quad c_k = 0$$
Calcoliamo il valore della combinazione lineare:
$$1 \cdot \mathbf{0} + 0 \cdot \mathbf{v}_2 + \dots + 0 \cdot \mathbf{v}_k = \mathbf{0} + \mathbf{0} + \dots + \mathbf{0} = \mathbf{0}$$
Abbiamo ottenuto una combinazione lineare nulla in cui il primo coefficiente è $c_1 = 1 \neq 0$.
Non tutti i coefficienti sono nulli, di conseguenza l'insieme $\mathcal{S}$ è linearmente dipendente per definizione.
> **Insight:** Il vettore nullo ha magnitudine zero e direzione indefinita: non può mai contribuire a una dimensione indipendente.

### Corollario: Criterio del Determinante 2D e Indipendenza di Due Vettori nel Piano
Due vettori nel piano euclideo $\mathbf{v}_1 = (v_{1x}, v_{1y})^T$ e $\mathbf{v}_2 = (v_{2x}, v_{2y})^T$ sono linearmente indipendenti se e solo se il determinante della matrice $2 \times 2$ formata dalle loro componenti per colonna è strettamente diverso da zero:
$$\det \begin{pmatrix} v_{1x} & v_{2x} \\ v_{1y} & v_{2y} \end{pmatrix} = v_{1x} v_{2y} - v_{1y} v_{2x} \neq 0 \iff \mathbf{v}_1, \mathbf{v}_2 \text{ sono linearmente indipendenti}$$
#### Dimostrazione del Corollario
Consideriamo la relazione fondamentale di annullamento lineare:
$$c_1 \mathbf{v}_1 + c_2 \mathbf{v}_2 = \mathbf{0} \iff c_1 \begin{pmatrix} v_{1x} \\ v_{1y} \end{pmatrix} + c_2 \begin{pmatrix} v_{2x} \\ v_{2y} \end{pmatrix} = \begin{pmatrix} 0 \\ 0 \end{pmatrix}$$
Questo equivale al sistema lineare omogeneo nelle incognite scalari $(c_1, c_2)$:
$$\begin{cases} v_{1x} c_1 + v_{2x} c_2 = 0 \\ v_{1y} c_1 + v_{2y} c_2 = 0 \end{cases}$$
Moltiplichiamo la prima equazione per $v_{1y}$ e la seconda equazione per $v_{1x}$:
$$\begin{cases} v_{1x} v_{1y} c_1 + v_{2x} v_{1y} c_2 = 0 \\ v_{1x} v_{1y} c_1 + v_{1x} v_{2y} c_2 = 0 \end{cases}$$
Sottraendo la prima equazione dalla seconda:
$$(v_{1x} v_{1y} c_1 - v_{1x} v_{1y} c_1) + (v_{1x} v_{2y} - v_{2x} v_{1y}) c_2 = 0 \implies (v_{1x} v_{2y} - v_{1y} v_{2x}) c_2 = 0$$
Definiamo il determinante 2D: $\Delta = \det \begin{pmatrix} v_{1x} & v_{2x} \\ v_{1y} & v_{2y} \end{pmatrix} = v_{1x} v_{2y} - v_{1y} v_{2x}$.
L'equazione algebrica diventa:
$$\Delta \cdot c_2 = 0$$
Se $\Delta \neq 0$, per la legge di annullamento del prodotto deve essere necessariamente $c_2 = 0$.
Sostituendo $c_2 = 0$ nel sistema originario, se almeno un termine tra $v_{1x}, v_{1y}$ è non nullo, si ottiene univocamente $c_1 = 0$.
L'unica soluzione del sistema è dunque la soluzione banale $(c_1, c_2) = (0, 0)$, provando che i due vettori sono linearmente indipendenti.
Se invece $\Delta = 0$, esiste una soluzione non banale $(c_1, c_2) \neq (0, 0)$ e i vettori sono linearmente dipendenti.
> **Insight:** Il valore assoluto del determinante misura l'area orientata del parallelogramma generato dai due vettori: esso è nullo se e solo se l'area collassa a zero, ovvero quando i vettori sono paralleli e linearmente dipendenti.
