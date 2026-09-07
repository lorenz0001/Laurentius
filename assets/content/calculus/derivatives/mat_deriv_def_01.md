---
id: mat_deriv_def_01
title: "Rapporto Incrementale e Definizione di Derivata"
category: "Matematica"
subCategory: "Calcolo Differenziale"
prerequisites:
  - mat_limits_01
interactive:
  template: derivative_tangent
  parameters: []
---

### Il Concetto di Derivata

La **derivata** esprime il tasso di variazione istantaneo di una grandezza. Geometricamente, corrisponde al coefficiente angolare della **retta tangente** al grafico della funzione in un punto fissato $x_0$.

Si costruisce considerando il limite del rapporto incrementale al tendere a zero dell'incremento $h$:

$$f'(x_0) = \lim_{h \to 0} \frac{f(x_0 + h) - f(x_0)}{h}$$

> **Insight:** La derivabilità è una proprietà locale più forte della semplice continuità: se una funzione ammette derivata finita in $x_0$, allora è garantita anche la sua continuità in tale punto.

## Dimostrazione Logico-Algebrica

### 1. Definizione di rapporto incrementale
$$\frac{\Delta y}{\Delta x} = \frac{f(x_0 + h) - f(x_0)}{h}$$
> **Insight:** Misura la velocità di variazione media della grandezza nell'intervallo [x₀, x₀+h].

### 2. Passaggio al limite per h -> 0: pendenza istantanea
$$f'(x_0) = \frac{df}{dx}(x_0) \equiv \lim_{h \to 0} \frac{f(x_0 + h) - f(x_0)}{h}$$
> **Insight:** Se il limite esiste finito, la funzione è derivabile in x₀ e la retta secante collassa sulla retta tangente.

### 3. Equazione cartesiana della retta tangente
$$y - f(x_0) = f'(x_0) \cdot (x - x_0)$$
> **Insight:** La derivata prima f'(x₀) è esattamente il coefficiente angolare m della retta tangente.

### 4. Corollario: Continuità delle Funzioni Derivabili
$$f \text{ derivabile in } x_0 \implies \lim_{h \to 0} [f(x_0+h) - f(x_0)] = \lim_{h \to 0} \left[ h \cdot \frac{f(x_0+h)-f(x_0)}{h} \right] = 0 \cdot f'(x_0) = 0$$
> **Insight:** Ogni funzione derivabile è necessariamente continua nel punto (la derivabilità è una condizione più forte della continuità).
