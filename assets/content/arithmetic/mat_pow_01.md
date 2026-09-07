---
id: mat_pow_01
title: "Potenze, Radici ed Esponenti Reali"
category: "Matematica"
subCategory: "Potenze e Radicali"
prerequisites:
  - mat_mul_01
interactive:
  template: live_equation
  unit: ""
  equations:
    - "pow(a, b)"
  parameters:
    - variable: a
      label: "Base (a)"
      min: 0.5
      max: 5.0
      default: 2.0
      step: 0.5
    - variable: b
      label: "Esponente (b)"
      min: -3.0
      max: 4.0
      default: 3.0
      step: 1.0
---

### Potenze ed Esponenti Reali

La **potenza** $a^n$ sintetizza la moltiplicazione ripetuta della base $a$ per se stessa $n$ volte, governando i fenomeni di scala, iper-volume e crescita esponenziale.

Dalle proprietà delle potenze con esponente intero:
$$a^n \cdot a^m = a^{n+m}, \quad \frac{a^n}{a^m} = a^{n-m}, \quad (a^n)^m = a^{n \cdot m}$$

> **Insight:** L'estensione agli esponenti frazionari $a^{\frac{m}{n}} = \sqrt[n]{a^m}$ unifica in un'unica teoria coerente il calcolo delle potenze e quello dei radicali.

## Dimostrazione Logico-Algebrica

### 1. Definizione di potenza con esponente intero positivo
$$a^n = \underbrace{a \cdot a \cdot \dots \cdot a}_{n \text{ volte}} \quad (n \in \mathbb{N}^*)$$
> **Insight:** Esprime la crescita esponenziale e l'iper-volume in n dimensioni.

### 2. Prodotto e quoziente di potenze aventi la stessa base
$$a^n \cdot a^m = a^{n+m}, \quad \frac{a^n}{a^m} = a^{n-m}$$
> **Insight:** Gli esponenti si sommano nel prodotto e si sottraggono nel quoziente.

### 3. Deduzione dell'esponente zero e negativo
$$a^0 = 1 \quad (a \neq 0), \quad a^{-n} = \frac{1}{a^n}$$
> **Insight:** L'esponente negativo sposta il fattore al denominatore con segno dell'esponente invertito.

### 4. Corollario: Esponenti Frazionari ed Equivalenza con i Radicali
$$a^{\frac{m}{n}} = \sqrt[n]{a^m} \quad (a > 0, n \in \mathbb{N}^*)$$
> **Insight:** Unifica la teoria delle potenze con quella dei radicali, rendendo applicabili le stesse leggi algebriche.
