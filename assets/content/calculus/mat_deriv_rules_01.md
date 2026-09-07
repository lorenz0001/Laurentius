---
id: mat_deriv_rules_01
title: "Regole di Derivazione: Prodotto, Quoziente e Catena"
category: "Matematica"
subCategory: "Calcolo Differenziale"
prerequisites:
  - mat_deriv_def_01
  - mat_binom_01
interactive:
  template: derivative_tangent
  parameters: []
---

### Come Derivare Espressioni Complesse

Quando conosciamo la derivata di funzioni base, come calcoliamo la derivata del loro prodotto o della loro composizione?

#### 1. Regola del Prodotto (Formula di Leibniz)
Pensa a un rettangolo di lati $u(x)$ e $v(x)$. Se entrambi i lati crescono di una piccola quantità $\Delta u$ e $\Delta v$, la nuova area cresce sia per l'allargamento della base che per l'innalzamento dell'altezza. La derivata del prodotto non è semplicemente il prodotto delle derivate, ma una combinazione bilineare:

$$(u \cdot v)' = u' \cdot v + u \cdot v'$$

#### 2. Regola della Catena (Funzioni Composte)
Se una grandezza $y$ dipende da $u$, e a sua volta $u$ dipende da $x$, come ruote dentate di un ingranaggio, la velocità complessiva di rotazione è il prodotto dei singoli tassi di variazione:

$$\frac{dy}{dx} = \frac{dy}{du} \cdot \frac{du}{dx} \iff [f(g(x))]' = f'(g(x)) \cdot g'(x)$$

> **Insight:** Grazie a queste regole e alla derivata trigonometrica $(\sin x)' = \cos x$, possiamo determinare istantaneamente il tasso di variazione di qualsiasi modello scientifico o ingegneristico.

## Dimostrazione Logico-Algebrica

### 1. Rapporto incrementale del prodotto con termine misto
$$\frac{f(x+h)g(x+h) - f(x)g(x)}{h} = f(x+h)\frac{g(x+h)-g(x)}{h} + g(x)\frac{f(x+h)-f(x)}{h}$$
> **Insight:** Tecnica algebrica classica per scomporre l'incremento congiunto di due funzioni.

### 2. Regola del Prodotto di Leibniz per h -> 0
$$(f \cdot g)'(x) = f'(x) g(x) + f(x) g'(x)$$
> **Insight:** La derivata di un prodotto non è il prodotto delle derivate, ma una combinazione bilineare simmetrica.

### 3. Derivata del seno mediante limite notevole
$$(\sin x)' = \lim_{h \to 0} \frac{\sin(x+h) - \sin x}{h} = \lim_{h \to 0} \left[ \sin x \frac{\cos h - 1}{h} + \cos x \frac{\sin h}{h} \right] = \cos x$$
> **Insight:** Poiché (cos h - 1)/h -> 0 e (sin h)/h -> 1, la derivata di sin(x) è esattamente cos(x).

### 4. Corollario: Derivata delle Potenze, Quoziente e Regola della Catena
$$(x^n)' = n x^{n-1}, \quad \left(\frac{f}{g}\right)' = \frac{f'g - f g'}{g^2}, \quad [f(g(x))]' = f'(g(x)) \cdot g'(x)$$
> **Insight:** Permette di derivare qualsiasi funzione composta algebrica, trigonometrica ed esponenziale.
