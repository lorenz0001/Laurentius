---
id: chem_ph_01
title: "Chimica Fisica: Soluzioni Acido-Base e Calcolo del pH"
category: "Fisica"
subCategory: "Chimica Fisica"
prerequisites:
  - mat_log_01
interactive:
  template: live_equation
  unit: ""
  equations:
    - "-log(c) / 2.302585"
  parameters:
    - variable: c
      label: "[H+] Concentrazione Molare"
      unit: "mol/L"
      min: 0.0000001
      max: 0.1
      default: 0.001
      step: 0.001
---

### La Scala del pH: Domare i Grandi Numeri

La concentrazione di ioni idronio $[\text{H}_3\text{O}^+]$ in una soluzione acquosa può variare enormemente:
- Da $1$ mole per litro in un acido molto forte
- Fino a $0.00000000000001$ ($10^{-14}$) moli per litro in una base fortissima.

Lavorare con quattordici zeri decimali è poco pratico. Per questo si utilizza la scala logaritmica del **pH**, che comprime questi ordini di grandezza in un comodo intervallo da $0$ a $14$:

$$\text{pH} = -\log_{10}([\text{H}_3\text{O}^+])$$

> **Insight:** **Guida Rapida al pH:**
> - $\text{pH} = 7$: Neutro (acqua pura a 25°C)
> - $\text{pH} < 7$: Acido (succo di limone $\approx 2.4$, caffè $\approx 5$)
> - $\text{pH} > 7$: Basico (sapone $\approx 9$, ammoniaca $\approx 11.5$)
> Ogni salto di 1 unità di pH indica una concentrazione dieci volte superiore o inferiore!

## Dimostrazione Logico-Algebrica

### 1. Equilibrio di autoionizzazione dell'acqua pura a 25°C
$$K_w = [\text{H}_3\text{O}^+] \cdot [\text{OH}^-] = 1.0 \times 10^{-14} \text{ M}^2$$
> **Insight:** In soluzione acquosa neutra, la concentrazione di ioni idronio e idrossido è identica: 10^-7 M.

### 2. Definizione dell'operatore logaritmico p = -log10
$$\text{pH} = -\log_{10}([\text{H}_3\text{O}^+]), \quad \text{pOH} = -\log_{10}([\text{OH}^-])$$
> **Insight:** Trasforma variazioni di quattordici ordini di grandezza in una scala lineare comoda da 0 a 14.

### 3. Proprietà del logaritmo del prodotto applicata al prodotto ionico
$$-\log_{10}(K_w) = -\log_{10}([\text{H}_3\text{O}^+]) - \log_{10}([\text{OH}^-])$$
> **Insight:** La moltiplicazione delle concentrazioni si traduce nella somma delle grandezze p.

### 4. Corollario: Relazione Fondamentale pH + pOH = 14
$$\text{pH} + \text{pOH} = 14.00 \iff \text{pH} = 14 - \text{pOH}$$
> **Insight:** Permette di determinare istantaneamente il pH di soluzioni fortemente basiche conoscendo la concentrazione di OH-.
