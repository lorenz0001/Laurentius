---
id: mat_frac_01
title: "Frazioni, Rapporti e Numeri Razionali"
category: "Matematica"
subCategory: "Frazioni e Rapporti"
prerequisites:
  - mat_mul_01
interactive:
  template: live_equation
  unit: ""
  equations:
    - "a / b"
  parameters:
    - variable: a
      label: "Numeratore (a)"
      min: -20.0
      max: 20.0
      default: 6.0
      step: 1.0
    - variable: b
      label: "Denominatore (b ≠ 0)"
      min: 1.0
      max: 20.0
      default: 8.0
      step: 1.0
---

### Frazioni e Numeri Razionali

Una **frazione** $\frac{a}{b}$ con $b \neq 0$ rappresenta la suddivisione di una quantità intera in parti uguali e introduce l'insieme dei numeri razionali $\mathbb{Q}$.

La divisione è l'operazione inversa della moltiplicazione: dividere per $b$ equivale a moltiplicare per il reciproco $\frac{1}{b}$.

$$\frac{a}{b} = a \cdot b^{-1} \quad (b \neq 0)$$

> **Insight:** Il rapporto tra due grandezze preserva l'invarianza per moltiplicazione o divisione comune: questa proprietà consente di ridurre ai minimi termini qualsiasi frazione.

## Dimostrazione: Costruzione dei Numeri Razionali e Operazioni

### 1. Definizione di inverso moltiplicativo (reciproco)
$$\forall b \neq 0, \quad \exists b^{-1} = \frac{1}{b} : b \cdot \frac{1}{b} = 1$$
> **Insight:** La frazione a/b rappresenta il prodotto esatto tra il numeratore a e l'inverso del denominatore b.

### 2. Somma di frazioni mediante comune denominatore
$$\frac{a}{b} + \frac{c}{d} = \frac{a \cdot d}{b \cdot d} + \frac{c \cdot b}{d \cdot b} = \frac{a d + b c}{b d} \quad (b, d \neq 0)$$
> **Insight:** Riconduce due partizioni a una scala metrica comune per consentirne la somma algebrica.

### 3. Moltiplicazione tra frazioni
$$\frac{a}{b} \cdot \frac{c}{d} = (a \cdot b^{-1}) \cdot (c \cdot d^{-1}) = (a \cdot c) \cdot (b^{-1} \cdot d^{-1}) = \frac{a \cdot c}{b \cdot d}$$
> **Insight:** Il prodotto di frazioni è il prodotto dei numeratori fratto il prodotto dei denominatori.

## Dimostrazione: Corollario - Proprietà Invariantiva e Semplificazione di Frazioni

### 1. Espressione della frazione scalata tramite inverso moltiplicativo
Consideriamo la frazione in cui numeratore e denominatore sono moltiplicati per un medesimo fattore $k \neq 0$:
$$\frac{a \cdot k}{b \cdot k} = (a \cdot k) \cdot (b \cdot k)^{-1} \quad (b \neq 0, \; k \neq 0)$$
> **Insight:** Esprimiamo la frazione scalata come prodotto con l'elemento reciproco del denominatore composito.

### 2. Decomposizione dell'inverso di un prodotto
Nel campo dei numeri reali/razionali, l'inverso del prodotto di due elementi non nulli è il prodotto dei rispettivi inversi:
$$(b \cdot k)^{-1} = b^{-1} \cdot k^{-1} \implies \frac{a \cdot k}{b \cdot k} = (a \cdot k) \cdot (b^{-1} \cdot k^{-1})$$
> **Insight:** Deriva dall'uguaglianza $(bk)(b^{-1}k^{-1}) = (bb^{-1})(kk^{-1}) = 1 \cdot 1 = 1$.

### 3. Riorganizzazione associativa e commutativa dei fattori
Riordinando i termini moltiplicativi per accoppiare gli elementi omologhi:
$$(a \cdot k) \cdot (b^{-1} \cdot k^{-1}) = (a \cdot b^{-1}) \cdot (k \cdot k^{-1}) = \frac{a}{b} \cdot 1$$
> **Insight:** Il termine comune k si semplifica con il proprio inverso moltiplicativo k^(-1) generando l'elemento neutro unitario 1.

### 4. Corollario: Enunciato della Proprietà Invariantiva
Poiché $\frac{a}{b} \cdot 1 = \frac{a}{b}$, l'invarianza del valore razionale è rigorosamente dimostrata:
$$\frac{a \cdot k}{b \cdot k} = \frac{a}{b} \quad (k \neq 0)$$
> **Insight:** Moltiplicando o dividendo numeratore e denominatore per una stessa costante non nulla il valore numerico della frazione rimane invariato, consentendo la riduzione ai minimi termini.

## Dimostrazione: Corollario - Divisione di Frazioni e Moltiplicazione per il Reciproco

### 1. Definizione formale di quoziente tra frazioni
Siano $\frac{a}{b}$ e $\frac{c}{d}$ due numeri razionali con $b \neq 0, c \neq 0, d \neq 0$. La divisione è definita come:
$$\frac{a}{b} : \frac{c}{d} \equiv \frac{a}{b} \cdot \left(\frac{c}{d}\right)^{-1}$$
> **Insight:** Dividere per un numero razionale equivale a moltiplicare per il suo inverso moltiplicativo.

### 2. Calcolo dell'inverso moltiplicativo di una frazione
Verifichiamo che il reciproco di $\frac{c}{d}$ è $\frac{d}{c}$:
$$\frac{c}{d} \cdot \frac{d}{c} = \frac{c \cdot d}{d \cdot c} = \frac{cd}{cd} = 1 \implies \left(\frac{c}{d}\right)^{-1} = \frac{d}{c}$$
> **Insight:** Scambiando numeratore e denominatore si ottiene il candidato inverso esatto il cui prodotto è unitario.

### 3. Sostituzione ed esecuzione del prodotto razionale
Sostituendo l'inverso trovato nella definizione iniziale di divisione:
$$\frac{a}{b} : \frac{c}{d} = \frac{a}{b} \cdot \frac{d}{c} = \frac{a \cdot d}{b \cdot c}$$
> **Insight:** Il calcolo si riconduce a una moltiplicazione standard tra la prima frazione e l'inversa della seconda.

### 4. Corollario: Regola del Prodotto Incrociato per la Divisione
La divisione tra frazioni si esegue moltiplicando a croce i rispettivi termini:
$$\frac{a}{b} : \frac{c}{d} = \frac{a \cdot d}{b \cdot c}$$
> **Insight:** Questa regola unifica la gestione dei rapporti ed evita l'annidamento indefinito di linee di frazione composte.
