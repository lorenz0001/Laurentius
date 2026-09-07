---
id: mat_limits_01
title: "Limiti di Funzione e Limiti Notevoli"
category: "Matematica"
subCategory: "Limiti e Continuità"
prerequisites:
  - mat_trig_circ_01
  - mat_frac_01
interactive:
  template: function_graph
  unit: ""
  equations:
    - "sin(k * x) / x"
  parameters:
    - variable: k
      label: "Fattore di scala k in sin(k·x)/x"
      min: 0.5
      max: 3.0
      default: 1.0
      step: 0.5
---

### Limiti di Funzione e il Limite Notevole di $\frac{\sin x}{x}$

Il concetto di **limite** descrive il comportamento di una funzione nell'intorno di un punto di accumulazione, permettendo di analizzare forme indeterminate come $\left[\frac{0}{0}\right]$.

Il limite notevole fondamentale della goniometria è:
$$\lim_{x \to 0} \frac{\sin x}{x} = 1$$

> **Insight:** Il Teorema del Confronto (o dei Carabinieri) intrappola la funzione $\frac{\sin x}{x}$ tra $\cos x$ e $1$, forzando la convergenza verso $1$ per $x \to 0$.

## Dimostrazione Logico-Algebrica

### 1. Confronto geometrico sulla circonferenza goniometrica
$$\text{Area}(\triangle OAP) < \text{Area}(\text{settore } OAP) < \text{Area}(\triangle OAT) \implies \sin x < x < \tan x$$
> **Insight:** L'arco di circonferenza x è compreso tra la semicorda del seno e il segmento della tangente.

### 2. Divisione per sin x e passaggio ai reciproci
$$1 < \frac{x}{\sin x} < \frac{1}{\cos x} \implies \cos x < \frac{\sin x}{x} < 1$$
> **Insight:** Inverte il verso delle disuguaglianze intrappolando sin(x)/x tra cos(x) e 1.

### 3. Passaggio al limite e Teorema dei Carabinieri
$$\lim_{x \to 0} \cos x = 1 \implies \lim_{x \to 0} \frac{\sin x}{x} = 1$$
> **Insight:** Poiché entrambi gli estremi tendono a 1, la funzione centrale converge necessariamente a 1.

### 4. Corollario: Limiti Notevoli Goniometrici ed Esponenziali
$$\lim_{x \to 0} \frac{1 - \cos x}{x^2} = \frac{1}{2} \quad \land \quad \lim_{x \to 0} \frac{e^x - 1}{x} = 1$$
> **Insight:** Derivati per sostituzione e moltiplicazione per (1+cos x); fondamentali per calcolare le derivate prime.
