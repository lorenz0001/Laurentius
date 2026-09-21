---
id: lin_alg_02_vectors
title: "Vettori Geometrici, Norma e Coordinate Canoniche"
category: "Matematica"
subCategory: "Algebra Lineare"
prerequisites:
  - lin_alg_01_tuples
interactive:
  template: vector_2d
  unit: ""
  equations:
    - "sqrt(vx * vx + vy * vy)"
  parameters:
    - variable: vx
      label: "Componente vx"
      unit: ""
      min: -10.0
      max: 10.0
      default: 4.0
      step: 0.5
    - variable: vy
      label: "Componente vy"
      unit: ""
      min: -10.0
      max: 10.0
      default: 3.0
      step: 0.5
---

### Il Vettore come Oggetto Geometrico e Algebrico

In fisica e in geometria, molte grandezze non sono identificabili da un singolo numero reale (scalare), ma richiedono l'indicazione di un'intensità, di una direzione e di un verso.

Un **segmento orientato** $\vec{AB}$ è una coppia ordinata di punti dello spazio euclideo, dove $A$ è detto *punto di applicazione* (o coda) e $B$ è l'estremo finale (o punta).

Due segmenti orientati $\vec{AB}$ e $\vec{CD}$ si dicono **equipollenti** se hanno:
1. La medesima lunghezza: $\|\vec{AB}\| = \|\vec{CD}\|$
2. La medesima direzione (giacciono su rette parallele o coincidenti)
3. Il medesimo verso di percorrenza

La relazione di equipollenza è una relazione di equivalenza (riflessiva, simmetrica e transitiva). Definiamo **vettore geometrico libero** $\mathbf{v}$ la classe di equivalenza di tutti i segmenti orientati reciprocamente equipollenti:

$$\mathbf{v} = [\vec{AB}]_{\sim} = \left\{ \vec{CD} \;\middle|\; \vec{CD} \sim \vec{AB} \right\}$$

Applicando il vettore nell'origine delle coordinate $O(0, 0)$, il punto terminale $P(v_x, v_y)$ definisce in modo biunivoco le componenti cartesiane del vettore:

$$\mathbf{v} = \begin{pmatrix} v_x \\ v_y \end{pmatrix} \in \mathbb{R}^2$$

> **Insight:** Un vettore libero è indipendente dalla sua posizione nello spazio: può essere traslato parallelamente a se stesso senza subire alcuna alterazione algebrica o geometrica.

Nel piano cartesiano $\mathbb{R}^2$, la **base canonica ortonormale** $\mathcal{E} = \{\mathbf{e}_1, \mathbf{e}_2\}$ è costituita dai vettori unitari orientati lungo gli assi positivi:

$$\mathbf{e}_1 = \begin{pmatrix} 1 \\ 0 \end{pmatrix}, \quad \mathbf{e}_2 = \begin{pmatrix} 0 \\ 1 \end{pmatrix}$$

Ogni vettore $\mathbf{v}$ ammette una rappresentazione unica come combinazione lineare dei vettori della base canonica:

$$\mathbf{v} = v_x \mathbf{e}_1 + v_y \mathbf{e}_2$$

La **norma euclidea** (o magnitudine) del vettore misura la sua lunghezza geometrica invariante:

$$\|\mathbf{v}\| = \sqrt{v_x^2 + v_y^2}$$

> **Insight:** La scomposizione sulla base canonica proietta l'oggetto geometrico continuo in coordinate discrete indipendenti: $v_x$ quantifica lo spostamento orizzontale e $v_y$ quello verticale.

## Dimostrazione: Scomposizione Canonica e Calcolo della Norma

### 1. Definizione delle Componenti e della Base Canonica
Siano dati i versori fondamentali $\mathbf{e}_1 = (1, 0)^T$ e $\mathbf{e}_2 = (0, 1)^T$ nel piano euclideo $\mathbb{R}^2$, e sia $\mathbf{v} = (v_x, v_y)^T$ un generico vettore applicato nell'origine. Per le leggi di moltiplicazione scalare e somma in $\mathbb{R}^2$:
$$v_x \mathbf{e}_1 = v_x \begin{pmatrix} 1 \\ 0 \end{pmatrix} = \begin{pmatrix} v_x \\ 0 \end{pmatrix}, \quad v_y \mathbf{e}_2 = v_y \begin{pmatrix} 0 \\ 1 \end{pmatrix} = \begin{pmatrix} 0 \\ v_y \end{pmatrix}$$
> **Insight:** La moltiplicazione scalare allunga o inverte il versore unitario fino a coprire la proiezione cartesiana del vettore lungo l'asse corrispondente.

### 2. Scomposizione Unica sulla Base Canonica
Sommando le due proiezioni ortogonali membro a membro:
$$v_x \mathbf{e}_1 + v_y \mathbf{e}_2 = \begin{pmatrix} v_x \\ 0 \end{pmatrix} + \begin{pmatrix} 0 \\ v_y \end{pmatrix} = \begin{pmatrix} v_x + 0 \\ 0 + v_y \end{pmatrix} = \begin{pmatrix} v_x \\ v_y \end{pmatrix} = \mathbf{v}$$
L'unicità discende direttamente dall'uguaglianza tra coppie ordinate: se $a \mathbf{e}_1 + b \mathbf{e}_2 = v_x \mathbf{e}_1 + v_y \mathbf{e}_2$, allora necessariamente $a = v_x$ e $b = v_y$.
> **Insight:** Ogni punto del piano possiede una sola «impronta digitale» di coordinate rispetto alla base di riferimento.

### 3. Derivazione della Norma tramite il Teorema di Pitagora
I due vettori componenti $v_x \mathbf{e}_1$ e $v_y \mathbf{e}_2$ sono tra loro ortogonali, poiché giacciono rispettivamente sull'asse delle ascisse e sull'asse delle ordinate. Applicando il Teorema di Pitagora al triangolo rettangolo avente per ipotenusa il segmento orientato $\mathbf{v}$:
$$\|\mathbf{v}\|^2 = \|v_x \mathbf{e}_1\|^2 + \|v_y \mathbf{e}_2\|^2 = v_x^2 + v_y^2 \implies \|\mathbf{v}\| = \sqrt{v_x^2 + v_y^2}$$
> **Insight:** La lunghezza del vettore è rigorosamente non negativa ed è nulla se e solo se entrambe le coordinate sono nulle ($v_x = v_y = 0$).

### Corollario: Normalizzazione e Versore di un Vettore
Dato un generico vettore non nullo $\mathbf{v} \in \mathbb{R}^2 \setminus \{\mathbf{0}\}$, il vettore scalato $\hat{\mathbf{u}} = \frac{1}{\|\mathbf{v}\|} \mathbf{v}$ è un versore avente norma esattamente unitaria, con la medesima direzione e verso di $\mathbf{v}$:
$$\|\hat{\mathbf{u}}\| = \left\| \frac{\mathbf{v}}{\|\mathbf{v}\|} \right\| = 1$$
#### Dimostrazione del Corollario
Sia $\mathbf{v} = (v_x, v_y)^T \neq \mathbf{0}$, tale che $\|\mathbf{v}\| = \sqrt{v_x^2 + v_y^2} > 0$.
Definiamo il vettore $\hat{\mathbf{u}}$ moltiplicando $\mathbf{v}$ per lo scalare positivo $\lambda = \frac{1}{\|\mathbf{v}\|} > 0$:
$$\hat{\mathbf{u}} = \begin{pmatrix} \hat{u}_x \\ \hat{u}_y \end{pmatrix} = \begin{pmatrix} \frac{v_x}{\|\mathbf{v}\|} \\ \frac{v_y}{\|\mathbf{v}\|} \end{pmatrix}$$
Calcoliamo la norma euclidea di $\hat{\mathbf{u}}$ applicando la formula della norma algebrica:
$$\|\hat{\mathbf{u}}\| = \sqrt{\hat{u}_x^2 + \hat{u}_y^2} = \sqrt{\left( \frac{v_x}{\|\mathbf{v}\|} \right)^2 + \left( \frac{v_y}{\|\mathbf{v}\|} \right)^2} = \sqrt{\frac{v_x^2 + v_y^2}{\|\mathbf{v}\|^2}}$$
Sostituendo l'identità fondamentale $\|\mathbf{v}\|^2 = v_x^2 + v_y^2$:
$$\|\hat{\mathbf{u}}\| = \sqrt{\frac{\|\mathbf{v}\|^2}{\|\mathbf{v}\|^2}} = \sqrt{1} = 1$$
Poiché $\lambda > 0$, la direzione e il verso rimangono inalterati.
> **Insight:** La normalizzazione separa l'orientamento spaziale puro (racchiuso nel versore $\hat{\mathbf{u}}$) dall'intensità scalare della grandezza vettoriale (la norma $\|\mathbf{v}\|$): $\mathbf{v} = \|\mathbf{v}\| \hat{\mathbf{u}}$.

### Corollario: Invarianza della Norma per Traslazione Euclidea
Siano $A(x_A, y_A)$ e $B(x_B, y_B)$ i punti iniziale e finale del segmento orientato che definisce il vettore $\mathbf{v} = B - A$. Se trasliamo rigidamente entrambi i punti di un vettore costante di traslazione $\mathbf{t} = (t_x, t_y)^T$, ottenendo $A' = A + \mathbf{t}$ e $B' = B + \mathbf{t}$, la norma del vettore risultante $\vec{A'B'}$ rimane identica:
$$\|\vec{A'B'}\| = \|\vec{AB}\| = \|\mathbf{v}\|$$
#### Dimostrazione del Corollario
Calcoliamo le coordinate dei punti traslati $A'$ e $B'$:
$$A' = (x_A + t_x, y_A + t_y)^T, \quad B' = (x_B + t_x, y_B + t_y)^T$$
Determiniamo le componenti cartesiane del segmento orientato traslato $\vec{A'B'}$ sottraendo le coordinate:
$$\vec{A'B'} = B' - A' = \begin{pmatrix} (x_B + t_x) - (x_A + t_x) \\ (y_B + t_y) - (y_A + t_y) \end{pmatrix} = \begin{pmatrix} x_B - x_A + t_x - t_x \\ y_B - y_A + t_y - t_y \end{pmatrix} = \begin{pmatrix} x_B - x_A \\ y_B - y_A \end{pmatrix} = \vec{AB}$$
Calcolando la norma euclidea di $\vec{A'B'}$:
$$\|\vec{A'B'}\| = \sqrt{((x_B - x_A))^2 + ((y_B - y_A))^2} = \|\vec{AB}\|$$
> **Insight:** Le traslazioni rigide preservano tutte le grandezze metriche: l'equipollenza garantisce che le proprietà fisiche e geometriche di un vettore non dipendano dalla scelta arbitraria dell'origine cartesiana.
