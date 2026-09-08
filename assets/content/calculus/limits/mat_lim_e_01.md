---
id: mat_lim_e_01
title: "Il Limite Fondamentale del Numero di Eulero e la Crescita Esponenziale"
category: "Matematica"
subCategory: "Limiti e Continuità"
prerequisites:
  - mat_limits_01
  - mat_binom_01
interactive:
  template: function_graph
  unit: ""
  equations:
    - "(1 + 1 / x)^x"
  parameters:
    - variable: n
      label: "Frequenza di Capitalizzazione (n)"
      unit: ""
      min: 1.0
      max: 50.0
      default: 10.0
      step: 1.0
---

### L'Intuizione Finanziaria di Jacob Bernoulli e l'Origine di e

La costante matematica fondamentale $e \approx 2.718281828459...$, nota come numero di Nepero o numero di Eulero, emerse nel 1683 dagli studi di Jacob Bernoulli sull'interesse composto continuo.

Supponiamo di depositare un capitale unitario $C_0 = 1$ al tasso di interesse annuo nominale del $100\%$. Se gli interessi vengono accreditati in $n$ frazioni uguali durante l'anno, il montante finale accumulato al termine dell'anno è pari a:

$$M_n = \left(1 + \frac{1}{n}\right)^n$$

*   Se la capitalizzazione è annuale ($n = 1$): $M_1 = (1 + 1)^1 = 2$.
*   Se la capitalizzazione è mensile ($n = 12$): $M_{12} = \left(1 + \frac{1}{12}\right)^{12} \approx 2.613$.
*   Se la capitalizzazione è giornaliera ($n = 365$): $M_{365} = \left(1 + \frac{1}{365}\right)^{365} \approx 2.7145$.
*   Portando la suddivisione temporale al limite continuo per $n \to \infty$, il rendimento non esplode all'infinito ma converge asintoticamente alla costante universale $e$.

$$\lim_{x \to \pm\infty} \left(1 + \frac{1}{x}\right)^x = e$$

## Dimostrazione: Convergenza della Successione di Bernoulli al Numero di Eulero

### 1. Espansione della successione tramite il Binomio di Newton
$$a_n = \left(1 + \frac{1}{n}\right)^n = \sum_{k=0}^n \binom{n}{k} \frac{1}{n^k} = 1 + n \cdot \frac{1}{n} + \frac{n(n-1)}{2!} \frac{1}{n^2} + \dots + \frac{n(n-1)\dots 1}{n!} \frac{1}{n^n}$$
> **Insight:** La formula binomiale sviluppa la potenza n-esima in una sommatoria finita di addendi positivi ordinati per grado.

### 2. Forma analitica dei singoli termini e dimostrazione di stretta monotonia
$$a_n = 1 + 1 + \frac{1}{2!}\left(1 - \frac{1}{n}\right) + \frac{1}{3!}\left(1 - \frac{1}{n}\right)\left(1 - \frac{2}{n}\right) + \dots + \frac{1}{n!}\prod_{j=1}^{n-1}\left(1 - \frac{j}{n}\right)$$
> **Insight:** Al crescere di n ciascun fattore (1 - j/n) aumenta e si aggiunge un ulteriore termine positivo, provando che aₙ₊₁ > aₙ.

### 3. Limitazione superiore tramite serie geometrica di ragione 1/2
$$a_n < 1 + 1 + \frac{1}{2} + \frac{1}{4} + \dots + \frac{1}{2^{n-1}} < 1 + \sum_{k=0}^\infty \left(\frac{1}{2}\right)^k = 1 + 2 = 3 \implies \exists \lim_{n \to \infty} a_n = e \in (2, 3)$$
> **Insight:** Una successione reale monotona crescente e superiormente limitata da 3 ammette limite finito per il Teorema di Completezza di Dedekind.

### 4. Estensione alla variabile reale x tendente a infinito
$$\lfloor x \rfloor \le x < \lfloor x \rfloor + 1 \implies \lim_{x \to +\infty} \left(1 + \frac{1}{x}\right)^x = \lim_{x \to -\infty} \left(1 + \frac{1}{x}\right)^x = e$$
> **Insight:** L'intrappolamento tra parti intere consente di applicare il Teorema dei Carabinieri estendendo il limite da n naturale a x reale.

## Dimostrazione: Corollario - Forma del Limite Notevole nell'Origine (t -> 0)

### 1. Definizione del cambio di variabile reciproco
Consideriamo la trasformazione algebrica ponendo la nuova variabile $t$ come il reciproco di $x$:
$$t = \frac{1}{x} \iff x = \frac{1}{t}$$
> **Insight:** Questa mappa trasforma la regione asintotica all'infinito in un intorno dell'origine e viceversa.

### 2. Analisi del comportamento asintotico dei limiti laterali
Analizziamo la convergenza della variabile ausiliaria $t$:
$$x \to +\infty \implies t \to 0^+, \quad x \to -\infty \implies t \to 0^-$$
> **Insight:** Esaminare separatamente il limite destro e sinistro a zero garantisce la consistenza con entrambi i rami infiniti.

### 3. Sostituzione delle espressioni nella funzione potenza
Sostituendo $x = 1/t$ e $1/x = t$ nella funzione generatrice del limite di Eulero:
$$\left(1 + \frac{1}{x}\right)^x = (1 + t)^{\frac{1}{t}}$$
> **Insight:** La struttura algebrica assume la caratteristica forma esponenziale di una base tendente a 1 elevata a un esponente divergente all'infinito.

### 4. Deduzione del limite notevole all'origine
Applicando il teorema sul limite delle funzioni composte biiettive:
$$\lim_{t \to 0} (1 + t)^{\frac{1}{t}} = \lim_{x \to \pm\infty} \left(1 + \frac{1}{x}\right)^x = e$$
> **Insight:** Corollario: la forma nell'origine (1 + t)^(1/t) tende al numero di Eulero e, costituendo il ponte analitico fondamentale per la derivazione dei logaritmi.

## Dimostrazione: Corollario - Limite Generalizzato di Potenza (1 + k/x)^x = e^k

### 1. Riorganizzazione algebrica del termine additivo interno
Sia $k \in \mathbb{R} \setminus \{0\}$. Esprimiamo la frazione $k/x$ inserendo il parametro a denominatore del denominatore:
$$1 + \frac{k}{x} = 1 + \frac{1}{\frac{x}{k}}$$
> **Insight:** Questa manipolazione conforma il termine interno alla struttura canonica 1 + 1/y.

### 2. Cambio di variabile e ridimensionamento dell'esponente
Introduciamo la variabile ausiliaria $y = \frac{x}{k}$, da cui ricaviamo $x = k \cdot y$. Poiché $k$ è finito e non nullo:
$$x \to \pm\infty \implies y \to \pm\infty$$
Sostituendo entrambe le relazioni nell'espressione iniziale:
$$\left(1 + \frac{k}{x}\right)^x = \left(1 + \frac{1}{y}\right)^{k \cdot y}$$
> **Insight:** L'esponente originale x viene scomposto nel prodotto tra la variabile coordinata y e la costante moltiplicativa k.

### 3. Proprietà della potenza di potenza
Applicando la legge algebrica delle potenze ad esponente reale:
$$\left(1 + \frac{1}{y}\right)^{k \cdot y} = \left[ \left(1 + \frac{1}{y}\right)^y \right]^k$$
> **Insight:** L'operazione isola la base tendente a e all'interno di una potenza con esponente costante k.

### 4. Calcolo del limite tramite continuità della funzione potenza
Poiché la funzione $g(w) = w^k$ è continua per ogni $w > 0$, scambiamo l'operatore limite con la potenza:
$$\lim_{x \to \pm\infty} \left(1 + \frac{k}{x}\right)^x = \left[ \lim_{y \to \pm\infty} \left(1 + \frac{1}{y}\right)^y \right]^k = [e]^k = e^k$$
> **Insight:** Corollario: l'interesse composto continuo al tasso annuo k produce un fattore di crescita esponenziale esatto pari a e^k (formula del decadimento e della crescita continua).
