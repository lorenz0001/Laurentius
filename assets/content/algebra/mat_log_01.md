---
id: mat_log_01
title: "Logaritmi ed Esponenziali"
category: "Matematica"
subCategory: "Funzioni Esponenziali e Logaritmiche"
prerequisites:
  - mat_pow_01
interactive:
  template: live_equation
  unit: ""
  equations:
    - "log(x) / log(b)"
  parameters:
    - variable: x
      label: "Argomento (x > 0)"
      min: 0.5
      max: 50.0
      default: 8.0
      step: 0.5
    - variable: b
      label: "Base (b > 0, ≠ 1)"
      min: 1.5
      max: 10.0
      default: 2.0
      step: 0.5
---

### Logaritmi ed Esponenziali

Il **logaritmo** in base $b$ di un numero positivo $x$ è l'esponente a cui occorre elevare la base $b$ per ottenere l'argomento $x$:

$$b^y = x \iff y = \log_b(x) \quad (b > 0, b \neq 1, x > 0)$$

I logaritmi convertono moltiplicazioni in somme, divisioni in sottrazioni e potenze in prodotti lineari:
- $\log_b(x \cdot y) = \log_b(x) + \log_b(y)$
- $\log_b(x / y) = \log_b(x) - \log_b(y)$
- $\log_b(x^k) = k \cdot \log_b(x)$

> **Insight:** I logaritmi consentono di comprimere scale numeriche immense in intervalli maneggevoli, come nella misurazione dei terremoti (scala Richter), dell'intensità sonora (decibel) e dell'acidità chimica (pH).

## Dimostrazione Logico-Algebrica

### 1. Definizione fondamentale del logaritmo come inversa dell'esponenziale
$$b^y = x \iff y = \log_b(x) \quad (b > 0, b \neq 1, x > 0)$$
> **Insight:** Rappresenta l'operazione inversa della funzione esponenziale per basi positive.

### 2. Proprietà del prodotto: trasformazione del prodotto in somma
$$\log_b(x \cdot y) = \log_b(x) + \log_b(y)$$
> **Insight:** Alla base del funzionamento dei regoli calcolatori e dell'elaborazione di segnali in decibel.

### 3. Proprietà delle potenze: linearizzazione dell'esponente
$$\log_b(x^k) = k \cdot \log_b(x)$$
> **Insight:** Permette di linearizzare equazioni esponenziali non algebriche.

### 4. Corollario: Formula del Cambiamento di Base
$$\log_a(x) = \frac{\log_b(x)}{\log_b(a)} = \frac{\ln(x)}{\ln(a)}$$
> **Insight:** Consente di calcolare qualsiasi logaritmo usando la base naturale (e) o decimale (10), essenziale in chimica e fisica.
