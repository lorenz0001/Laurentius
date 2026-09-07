---
id: mat_quad_eq_01
title: "Equazioni di Secondo Grado e Discriminante"
category: "Matematica"
subCategory: "Equazioni di Secondo Grado"
prerequisites:
  - mat_binom_01
  - mat_frac_01
interactive:
  template: function_graph
  unit: ""
  equations:
    - "a * x * x + b * x + c"
  parameters:
    - variable: a
      label: "Coeff. a"
      min: -3.0
      max: 3.0
      default: 1.0
      step: 0.5
    - variable: b
      label: "Coeff. b"
      min: -6.0
      max: 6.0
      default: -2.0
      step: 0.5
    - variable: c
      label: "Coeff. c"
      min: -6.0
      max: 6.0
      default: -3.0
      step: 0.5
---

### Equazioni di Secondo Grado e Discriminante

L'equazione algebrica di secondo grado nella forma canonica $ax^2 + bx + c = 0$ (con $a \neq 0$) è uno dei pilastri fondamentali dell'algebra classica.

Il discriminante $\Delta = b^2 - 4ac$ determina la natura delle soluzioni nel campo reale:
- Se $\Delta > 0$, esistono due soluzioni reali e distinte.
- Se $\Delta = 0$, esistono due soluzioni reali coincidenti (radice doppia).
- Se $\Delta < 0$, non esistono soluzioni reali.

$$x_{1,2} = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$$

> **Insight:** Il metodo del completamento del quadrato trasforma un trinomio quadratico nel quadrato esatto di un binomio, dimostrando in modo rigoroso la celebre formula risolutiva.

## Dimostrazione Logico-Algebrica

### 1. Forma normale dell'equazione di 2° grado con a ≠ 0
$$a x^2 + b x + c = 0 \implies x^2 + \frac{b}{a} x + \frac{c}{a} = 0$$
> **Insight:** Si divide per il primo coefficiente a per rendere monico il termine quadratico.

### 2. Completamento del quadrato
$$\left(x + \frac{b}{2a}\right)^2 - \frac{b^2}{4a^2} + \frac{c}{a} = 0 \implies \left(x + \frac{b}{2a}\right)^2 = \frac{b^2 - 4 a c}{4 a^2}$$
> **Insight:** Trasforma un trinomio quadratico nel quadrato di un binomio isolando il discriminante Delta = b^2 - 4ac.

### 3. Estrazione di radice quadrata e isolamento della variabile x
$$x + \frac{b}{2a} = \frac{\pm \sqrt{b^2 - 4 a c}}{2 a} \implies x_{1,2} = \frac{-b \pm \sqrt{\Delta}}{2 a}$$
> **Insight:** Dimostrazione rigorosa della celebre formula risolutiva di secondo grado.

### 4. Corollario: Relazioni di Viète e Scomposizione del Trinomio
$$x_1 + x_2 = -\frac{b}{a}, \quad x_1 \cdot x_2 = \frac{c}{a} \implies a x^2 + b x + c = a(x - x_1)(x - x_2)$$
> **Insight:** Consente di risalire ai coefficienti conoscendo le radici e di fattorizzare immediatamente il polinomio.
