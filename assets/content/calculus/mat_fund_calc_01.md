---
id: mat_fund_calc_01
title: "Teorema Fondamentale del Calcolo (Torricelli-Barrow)"
category: "Matematica"
subCategory: "Calcolo Integrale"
prerequisites:
  - mat_riemann_01
  - mat_deriv_def_01
interactive:
  template: riemann_sum
  parameters: []
---

### Il Ponte tra Differenziazione e Integrazione

Il **Teorema Fondamentale del Calcolo Integrale** (noto anche come Teorema di Torricelli-Barrow) stabilisce l'incredibile connessione biunivoca tra due branche apparentemente distinte:
- Il problema della **tangente** (velocità e derivate)
- Il problema dell'**area** (accumulazione e integrali)

Se $f(t)$ è continua in $[a, b]$, allora la funzione integrale definita da $F(x) = \int_a^x f(t) dt$ è derivabile e la sua derivata è la funzione integranda stessa:

$$F'(x) = \frac{d}{dx} \left[ \int_a^x f(t) dt \right] = f(x)$$

> **Insight:** Grazie alla **Formula di Barrow**, ogni integrale definito può essere calcolato tramite una qualsiasi primitiva $G(x)$: $\int_a^b f(x)dx = G(b) - G(a)$. Non è più necessario calcolare somme infinite di rettangoli!

## Dimostrazione Logico-Algebrica

### 1. Definizione della funzione integrale F(x)
$$F(x) = \int_a^x f(t) dt \quad (x \in [a, b])$$
> **Insight:** Misura l'area netta accumulata sotto la curva f(t) dal punto iniziale a fino alla coordinata mobile x.

### 2. Rapporto incrementale della funzione integrale
$$\frac{F(x+h) - F(x)}{h} = \frac{1}{h} \left[ \int_a^{x+h} f(t)dt - \int_a^x f(t)dt \right] = \frac{1}{h} \int_x^{x+h} f(t)dt$$
> **Insight:** Isola l'area della stretta striscia di larghezza h compresa tra x e x+h.

### 3. Applicazione del Teorema della Media Integrale
$$F'(x) = \lim_{h \to 0} \frac{F(x+h) - F(x)}{h} = \lim_{h \to 0} f(c_h) = f(x)$$
> **Insight:** La derivata della funzione integrale è esattamente la funzione integranda: F'(x) = f(x)!

### 4. Corollario: Formula di Barrow e Integrazione per Parti
$$\int_a^b f(x) dx = G(b) - G(a) \quad \land \quad \int u v' dx = u v - \int u' v dx$$
> **Insight:** Unifica differenziazione e integrazione come operazioni inverse; calcola qualsiasi area tramite le primitive.
