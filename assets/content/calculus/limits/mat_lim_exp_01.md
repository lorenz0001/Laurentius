---
id: mat_lim_exp_01
title: "Limite Notevole dell'Esponenziale: (e^x - 1)/x e Derivata Naturale"
category: "Matematica"
subCategory: "Limiti e Continuità"
prerequisites:
  - mat_lim_e_01
interactive:
  template: function_graph
  unit: ""
  equations:
    - "(2.71828^x - 1) / x"
  parameters:
    - variable: a
      label: "Base dell'Esponenziale a"
      unit: ""
      min: 1.5
      max: 4.0
      default: 2.72
      step: 0.1
---

### Perché e è la Base Naturale dei Logaritmi e degli Esponenziali

Nel calcolo differenziale, la base $e$ non è una scelta arbitraria o convenzionale, bensì l'unico valore per cui il tasso di crescita istantaneo della funzione esponenziale coincide numericamente con il valore della funzione stessa.

Il limite notevole dell'esponenziale nell'origine esprime esattamente il rapporto incrementale della curva $y = e^x$ nel punto di coordinate $(0, 1)$:

$$\lim_{x \to 0} \frac{e^x - 1}{x} = 1$$

Geometricamente, ciò significa che la retta tangente al grafico di $y = e^x$ nel punto di intersezione con l'asse delle ordinate ha pendenza unitaria $m = 1$, formando un angolo esatto di $45^\circ$ ($\frac{\pi}{4}$ radianti) con l'asse orizzontale. Se usassimo una base diversa (come $2$ o $10$), comparirebbe un fattore di scala proporzionale al logaritmo naturale della base.

## Dimostrazione Logico-Algebrica

### 1. Cambio di variabile esponenziale-logaritmica
$$y = e^x - 1 \implies e^x = 1 + y \implies x = \ln(1 + y)$$
> **Insight:** Il cambio di variabile converte l'indeterminazione dell'esponenziale in una forma risolvibile con le proprietà del logaritmo.

### 2. Verifica della convergenza della nuova variabile per x -> 0
$$x \to 0 \implies y = e^0 - 1 = 1 - 1 = 0$$
> **Insight:** La continuità elementare della funzione esponenziale garantisce che quando x tende a zero anche y tenda a zero.

### 3. Riscrittura del limite e inversione frazionaria
$$\lim_{x \to 0} \frac{e^x - 1}{x} = \lim_{y \to 0} \frac{y}{\ln(1 + y)} = \lim_{y \to 0} \frac{1}{\frac{1}{y} \ln(1 + y)}$$
> **Insight:** Portando y a denominatore di denominatore si prepara l'espressione per l'applicazione delle proprietà dei logaritmi.

### 4. Applicazione dell'esponente del logaritmo e convergenza ad e
$$\frac{1}{y} \ln(1 + y) = \ln\left((1 + y)^{\frac{1}{y}}\right) \implies \lim_{y \to 0} \ln\left((1 + y)^{\frac{1}{y}}\right) = \ln(e) = 1 \implies \lim_{x \to 0} \frac{e^x - 1}{x} = \frac{1}{1} = 1$$
> **Insight:** L'argomento converge al numero di Eulero e, per la continuità del logaritmo naturale, ln(e) = 1.

### 5. Corollario: Base Esponenziale Arbitraria e Derivata Prima
$$\lim_{x \to 0} \frac{a^x - 1}{x} = \lim_{x \to 0} \frac{e^{x \ln a} - 1}{x} = \ln a \quad \land \quad \frac{d}{dx}[e^x] = e^x$$
> **Insight:** Per basi arbitrarie a > 0 compare il fattore di scala ln(a); solo per la base naturale e la derivata coincide esattamente con la funzione stessa.
