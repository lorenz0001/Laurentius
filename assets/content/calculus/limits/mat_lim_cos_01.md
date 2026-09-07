---
id: mat_lim_cos_01
title: "Limite Notevole del Coseno: (1 - cos x)/x² e Curvatura Locale"
category: "Matematica"
subCategory: "Limiti e Continuità"
prerequisites:
  - mat_lim_sinc_01
interactive:
  template: function_graph
  unit: ""
  equations:
    - "(1 - cos(x)) / (x * x)"
  parameters:
    - variable: a
      label: "Fattore di Curvatura Parabolica"
      unit: ""
      min: 0.2
      max: 2.0
      default: 1.0
      step: 0.1
---

### Il Comportamento del Coseno nell'Intorno dell'Origine

Mentre la funzione seno nell'intorno dell'origine si discosta linearmente dall'asse orizzontale ($\sin x \approx x$), la funzione coseno presenta un punto stazionario di massimo relativo in $(0, 1)$. Di conseguenza, la deviazione del coseno dall'unità è di secondo ordine:

$$\lim_{x \to 0} \frac{1 - \cos x}{x^2} = \frac{1}{2}$$

La quantità $1 - \cos x$, nota storicamente come **senoverso** (*versine*), misura la freccia dell'arco circolare o la distanza orizzontale tra l'arco di cerchio unitario e la retta tangente verticale in $(1, 0)$. Poiché tale distanza si assottiglia proporzionalmente al quadrato dell'angolo $x^2$, il quoziente tende esattamente a $\frac{1}{2}$, corrispondente al raggio di curvatura locale della parabola osculatrice $y \approx 1 - \frac{1}{2}x^2$.

## Dimostrazione Logico-Algebrica

### 1. Razionalizzazione mediante coniugato trigonometrico
$$\frac{1 - \cos x}{x^2} = \frac{(1 - \cos x)(1 + \cos x)}{x^2 (1 + \cos x)} = \frac{1 - \cos^2 x}{x^2 (1 + \cos x)}$$
> **Insight:** La moltiplicazione per il fattore coniugato (1 + cos x) trasforma la differenza a numeratore nella differenza di quadrati.

### 2. Sostituzione con la relazione fondamentale della goniometria
$$\frac{\sin^2 x}{x^2 (1 + \cos x)} = \left(\frac{\sin x}{x}\right)^2 \cdot \frac{1}{1 + \cos x}$$
> **Insight:** Ricorrendo a sin²(x) + cos²(x) = 1 si isola esplicitamente il quadrato del limite notevole fondamentale di sin(x)/x.

### 3. Calcolo del limite del prodotto di fattori continui
$$\lim_{x \to 0} \left[ \left(\frac{\sin x}{x}\right)^2 \cdot \frac{1}{1 + \cos x} \right] = (1)^2 \cdot \frac{1}{1 + \cos(0)} = 1 \cdot \frac{1}{2} = \frac{1}{2}$$
> **Insight:** La forma indeterminata [0/0] è risolta: il primo fattore tende a 1 e il secondo a 1/2.

### 4. Corollario: Sviluppo di Taylor del Coseno e Limite del Primo Ordine
$$\cos x = 1 - \frac{1}{2}x^2 + o(x^2) \quad \land \quad \lim_{x \to 0} \frac{1 - \cos x}{x} = 0$$
> **Insight:** Il numeratore decresce quadraticamente; diviso per la sola x il limite si annulla, dimostrando che la derivata del coseno in zero è nulla.
