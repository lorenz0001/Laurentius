---
id: mat_triang_01
title: "Geometria del Triangolo e Angoli Interni"
category: "Matematica"
subCategory: "Geometria Euclidea Piana"
prerequisites:
  - mat_add_01
interactive:
  template: triangle_solver
  parameters: []
---

### Perché la Somma degli Angoli Interni è Sempre 180°?

Prendi un triangolo qualsiasi, anche scaleno o allungato. Se tracciamo una linea retta parallela alla base che tocca appena il vertice superiore, accade una meraviglia geometrica:
- I due angoli alla base si riflettono esattamente in alto grazie alla proprietà degli **angoli alterni interni**.
- Insieme all'angolo del vertice, i tre angoli si incastrano perfettamente uno accanto all'altro formando una linea dritta: un angolo piatto di $180^\circ$ ($\pi$ radianti)!

$$\alpha + \beta + \gamma = 180^\circ = \pi \text{ rad}$$

> **Insight:** **Teorema dell'Angolo Esterno:** In qualunque triangolo, l'ampiezza di ciascun angolo esterno è esattamente uguale alla somma dei due angoli interni non adiacenti: $\delta = \alpha + \beta$.

## Dimostrazione: Teorema della Somma degli Angoli Interni di un Triangolo

### 1. Costruzione euclidea della retta parallela alla base
Dato un triangolo qualsiasi $ABC$ con angoli interni $\alpha, \beta, \gamma$, tracciamo per il vertice $C$ la retta $r$ parallela al lato $AB$:
$$r \parallel AB \quad \text{passante per } C$$
> **Insight:** Costruzione euclidea classica basata sul quinto postulato per intersecare la parallela con le trasversali dei lati.

### 2. Congruenza degli angoli alterni interni formati dalle trasversali AC e BC
Le rette dei lati $AC$ e $BC$ agiscono come trasversali tra le parallele $r$ e $AB$, formando gli angoli alterni interni $\alpha'$ e $\beta'$:
$$\alpha' = \alpha \quad \land \quad \beta' = \beta$$
> **Insight:** Gli angoli alterni interni determinati da rette parallele tagliate da una trasversale sono congruenti.

### 3. Somma lineare degli angoli sul vertice C
I tre angoli adiacenti $\alpha', \gamma, \beta'$ poggiano sulla retta $r$ formando complessivamente un angolo piatto:
$$\alpha' + \gamma + \beta' = 180^\circ \iff \alpha + \beta + \gamma = 180^\circ = \pi \text{ rad}$$
> **Insight:** Teorema cardine della geometria euclidea: la somma degli angoli interni di un qualsiasi triangolo piano è costante.

## Dimostrazione: Corollario - Teorema dell'Angolo Esterno

### 1. Definizione geometrica di angolo esterno e adiacenza
Sia $\delta_{\text{ext}}$ l'angolo esterno adiacente al vertice $C$, supplementare all'angolo interno $\gamma$:
$$\delta_{\text{ext}} + \gamma = 180^\circ$$
> **Insight:** Un angolo interno e il suo rispettivo angolo esterno formano insieme un angolo piatto di 180°.

### 2. Isolamento dell'angolo esterno
Isolando $\delta_{\text{ext}}$ mediante sottrazione:
$$\delta_{\text{ext}} = 180^\circ - \gamma$$
> **Insight:** L'ampiezza dell'angolo esterno misura il deficit di gamma rispetto all'angolo piatto.

### 3. Sostituzione della somma degli angoli interni
Dal teorema fondamentale sappiamo che $180^\circ = \alpha + \beta + \gamma$. Sostituendo questa identità nell'espressione:
$$\delta_{\text{ext}} = (\alpha + \beta + \gamma) - \gamma$$
> **Insight:** Sostituiamo al valore 180° la somma esatta dei tre angoli interni del triangolo.

### 4. Corollario: Cancellazione e Teorema dell'Angolo Esterno
Cancellando algebricamente l'angolo $\gamma$:
$$\delta_{\text{ext}} = \alpha + \beta$$
> **Insight:** In qualsiasi triangolo piano, ciascun angolo esterno ha un'ampiezza esattamente pari alla somma dei due angoli interni non adiacenti.

## Dimostrazione: Corollario - Somma degli Angoli Interni di un Poligono a n Lati

### 1. Decomposizione del poligono in triangoli non sovrapposti
Consideriamo un poligono convesso avente $n$ vertici e $n$ lati ($n \ge 3$). Fissato un vertice arbitrario, tracciamo tutte le diagonali uscenti verso gli altri vertici:
$$\text{Numero di diagonali tracciate da un vertice} = n - 3$$
> **Insight:** Non si tracciano diagonali verso il vertice stesso e verso i due vertici immediatamente adiacenti.

### 2. Conteggio dei triangoli generati dalla triangolazione
Le $n - 3$ diagonali suddividono la superficie interna del poligono in triangoli disgiunti:
$$N_{\text{triangoli}} = (n - 3) + 1 = n - 2$$
> **Insight:** Ogni diagonale aggiunge esattamente un triangolo alla partizione interna.

### 3. Calcolo della somma complessiva degli angoli di tutti i triangoli
Poiché per il teorema fondamentale ciascun triangolo possiede una somma angolare interna pari a $180^\circ$:
$$S_n = \sum_{k=1}^{n-2} 180^\circ = (n - 2) \cdot 180^\circ$$
> **Insight:** La somma degli angoli interni di tutti i triangoli coincide esattamente con la somma degli angoli interni dell'intero poligono.

### 4. Corollario: Formula Universale della Somma Angolare Poligonale
La somma degli angoli interni di un poligono a $n$ vertici è espressa rigorosamente da:
$$S_n = (n - 2) \cdot 180^\circ = (n - 2)\pi \text{ rad}$$
> **Insight:** Per un quadrilatero (n=4) la somma è 360°, per un pentagono (n=5) è 540°, per un esagono (n=6) è 720°.
