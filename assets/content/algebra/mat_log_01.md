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
    - "ln(x) / ln(b)"
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

## Dimostrazione: Proprietà Fondamentali dei Logaritmi

### 1. Definizione fondamentale del logaritmo come inversa dell'esponenziale
$$b^y = x \iff y = \log_b(x) \quad (b > 0, b \neq 1, x > 0)$$
> **Insight:** Rappresenta l'operazione inversa della funzione esponenziale per basi positive.

### 2. Proprietà del prodotto: trasformazione del prodotto in somma
$$\log_b(x \cdot y) = \log_b(x) + \log_b(y)$$
> **Insight:** Alla base del funzionamento dei regoli calcolatori e dell'elaborazione di segnali in decibel.

### 3. Proprietà delle potenze: linearizzazione dell'esponente
$$\log_b(x^k) = k \cdot \log_b(x)$$
> **Insight:** Permette di linearizzare equazioni esponenziali non algebriche.

## Dimostrazione: Corollario - Formula del Cambiamento di Base nei Logaritmi

### 1. Definizione della variabile ausiliaria e forma esponenziale
Sia dato il logaritmo in base $a$ di $x$: poniamo $y = \log_a(x)$ con $a, b > 0, a, b \neq 1, x > 0$. Per la definizione stessa di logaritmo, passiamo alla forma esponenziale:
$$a^y = x$$
> **Insight:** L'esponente y trasforma la base a nel valore target x.

### 2. Applicazione dell'operatore logaritmico in nuova base b
Applichiamo ad ambo i membri il logaritmo nella nuova base arbitraria $b$:
$$\log_b(a^y) = \log_b(x)$$
> **Insight:** L'uguaglianza si conserva applicando la medesima funzione strettamente monotona a entrambi i membri.

### 3. Linearizzazione dell'esponente y
Sfruttando la proprietà fondamentale del logaritmo della potenza $\log_b(a^y) = y \cdot \log_b(a)$:
$$y \cdot \log_b(a) = \log_b(x)$$
> **Insight:** La potenza all'argomento viene trasformata in un coefficiente moltiplicativo lineare.

### 4. Corollario: Isolamento e Formula del Cambiamento di Base
Dividendo ambo i membri per $\log_b(a) \neq 0$ (poiché $a \neq 1$):
$$\log_a(x) = \frac{\log_b(x)}{\log_b(a)} = \frac{\ln(x)}{\ln(a)}$$
> **Insight:** Consente di calcolare qualsiasi logaritmo usando la base naturale (e) o decimale (10), essenziale in chimica e fisica.

## Dimostrazione: Corollario - Inversione di Base e Reciproco Logaritmico

### 1. Applicazione del cambiamento di base ponendo l'argomento uguale alla base
Consideriamo la formula del cambiamento di base scegliendo come argomento $x$ proprio la base $b$:
$$\log_a(b) = \frac{\log_b(b)}{\log_b(a)}$$
> **Insight:** Vogliamo determinare la relazione tra logaritmi con base e argomento scambiati.

### 2. Valutazione del logaritmo della propria base
Per definizione di potenza con esponente $1$, $b^1 = b$, dunque:
$$\log_b(b) = 1$$
> **Insight:** Il logaritmo di qualsiasi base calcolato su se stessa vale esattamente 1.

### 3. Sostituzione al numeratore
Sostituendo il valore unitario al numeratore della frazione:
$$\log_a(b) = \frac{1}{\log_b(a)}$$
> **Insight:** Emerge immediatamente una relazione di reciproco moltiplicativo tra i due logaritmi.

### 4. Corollario: Identità di Inversione di Base
Moltiplicando ambo i membri per $\log_b(a)$:
$$\log_a(b) \cdot \log_b(a) = 1 \iff \log_a(b) = \frac{1}{\log_b(a)}$$
> **Insight:** Scambiare base e argomento di un logaritmo genera il suo reciproco algebrico esatto.
