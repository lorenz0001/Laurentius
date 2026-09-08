---
id: mat_deriv_theorems_01
title: "Teoremi di Rolle, Lagrange e Criterio di Monotonia"
category: "Matematica"
subCategory: "Calcolo Differenziale"
prerequisites:
  - mat_deriv_rules_01
interactive:
  template: rolle_lagrange
  unit: ""
  equations:
    - "x * x * x / 3 - x"
  parameters:
    - variable: a
      label: "Estremo sinistro (a)"
      min: -2.4
      max: -0.2
      default: -1.8
      step: 0.1
    - variable: b
      label: "Estremo destro (b)"
      min: 0.2
      max: 2.4
      default: 1.4
      step: 0.1
---

### L'Intuizione Geometrica dei Grandi Teoremi Differenziali

I teoremi differenziali del valor medio costituiscono l'impalcatura analitica per lo studio del comportamento globale delle funzioni a partire dalle loro proprietà locali istantanee.

Immagina di percorrere un tragitto di 130 km in esattamente un'ora: la tua velocità media è stata di 130 km/h. Anche se hai accelerato o frenato, c'è stato sicuramente almeno un istante lungo il viaggio in cui il tachimetro segnava esattamente 130 km/h. Questo è il cuore del **Teorema del Valor Medio di Lagrange**:

$$f'(c) = \frac{f(b) - f(a)}{b - a} \quad \text{con } c \in (a, b)$$

Quando gli estremi si trovano alla stessa quota ($f(a) = f(b)$), come una traiettoria balistica che parte e atterra allo stesso livello, la secante è orizzontale e il teorema si riduce alla formulazione classica di **Rolle**:

$$f'(c) = 0$$

> **Insight:** Da questi teoremi discendono gli strumenti più potenti della matematica applicata: il Criterio di Monotonia (il segno della derivata prima determina se una funzione cresce o decresce) e la Regola di De L'Hôpital (per risolvere forme indeterminate 0/0 e ∞/∞ tramite il Teorema di Cauchy).

## Dimostrazione: Teorema di Fermat sui Punti Estremanti Interni

### 1. Definizione di massimo relativo interno
$$f(x) \le f(x_0) \quad \forall x \in (x_0 - \delta, x_0 + \delta) \subseteq (a, b)$$
> **Insight:** Il punto x₀ è un punto di massimo locale interno all'intervallo aperto in cui la funzione è definita e derivabile.

### 2. Studio del rapporto incrementale destro (h > 0)
$$h > 0 \implies f(x_0 + h) - f(x_0) \le 0 \implies \frac{f(x_0 + h) - f(x_0)}{h} \le 0 \implies f'_+(x_0) \le 0$$
> **Insight:** Avvicinandosi da destra, il numeratore è non positivo e il denominatore è positivo, producendo un rapporto incrementale non positivo.

### 3. Studio del rapporto incrementale sinistro (h < 0)
$$h < 0 \implies f(x_0 + h) - f(x_0) \le 0 \implies \frac{f(x_0 + h) - f(x_0)}{h} \ge 0 \implies f'_-(x_0) \ge 0$$
> **Insight:** Avvicinandosi da sinistra, la divisione tra due quantità negative genera un rapporto incrementale non negativo.

### 4. Corollario: Annullamento della Derivata Istantanea (f'(x_0) = 0)
$$f'(x_0) = f'_+(x_0) = f'_-(x_0) \implies f'(x_0) \le 0 \land f'(x_0) \ge 0 \iff f'(x_0) = 0$$
> **Insight:** L'unica possibilità affinché i limiti destro e sinistro coincidano è che la derivata sia identicamente nulla: la retta tangente nei massimi e minimi interni è rigorosamente orizzontale.

## Dimostrazione: Teorema di Rolle (Quota Coincidente agli Estremi)

### 1. Teorema di Weierstrass sui compatti e ipotesi di quota
$$f(a) = f(b), \quad \exists x_m, x_M \in [a, b] : f(x_m) = m = \min_{[a, b]} f, \; f(x_M) = M = \max_{[a, b]} f$$
> **Insight:** Essendo f continua sul chiuso e limitato [a, b], ammette certamente minimo assoluto m e massimo assoluto M per Weierstrass.

### 2. Caso degenere: funzione costante su tutto l'intervallo
$$m = M \implies f(x) = C \quad \forall x \in [a, b] \implies f'(x) = 0 \quad \forall x \in (a, b)$$
> **Insight:** Se il minimo coincide con il massimo, la curva è una retta orizzontale e qualsiasi punto c interno soddisfa la tesi.

### 3. Caso non degenere: esistenza di un estremo all'interno dell'intervallo aperto
$$m < M \implies \text{Almeno uno tra } x_m \text{ o } x_M \text{ appartiene a } (a, b)$$
> **Insight:** Poiché f(a) = f(b), entrambi gli estremi non possono trovarsi contemporaneamente su a e b senza che la funzione sia costante.

### 4. Corollario: Esistenza del Punto a Tangente Orizzontale
$$\exists c \in (a, b) : f'(c) = 0 \quad \text{per il Teorema di Fermat}$$
> **Insight:** Il punto interno c che realizza il massimo o il minimo relativo soddisfa Fermat e possiede derivata prima nulla.

## Dimostrazione: Teorema del Valor Medio di Lagrange

### 1. Costruzione della funzione ausiliaria di scarto cordale
$$F(x) = f(x) - \left[ f(a) + \frac{f(b) - f(a)}{b - a}(x - a) \right]$$
> **Insight:** F(x) misura la distanza verticale tra la curva f(x) e la retta secante passante per i punti estremi (a, f(a)) e (b, f(b)).

### 2. Verifica delle ipotesi del Teorema di Rolle su F(x)
$$F(a) = f(a) - f(a) = 0, \quad F(b) = f(b) - [f(a) + f(b) - f(a)] = 0 \implies F(a) = F(b) = 0$$
> **Insight:** F(x) è continua in [a, b], derivabile in (a, b) e assume lo stesso valore nullo agli estremi: Rolle è pienamente applicabile!

### 3. Calcolo della derivata prima di F(x)
$$F'(x) = f'(x) - \frac{f(b) - f(a)}{b - a}$$
> **Insight:** La derivata della retta secante è semplicemente la sua pendenza costante data dal rapporto tra dislivello e ampiezza.

### 4. Corollario: Parallelismo tra Tangente e Secante
$$\exists c \in (a, b) : F'(c) = 0 \iff f'(c) = \frac{f(b) - f(a)}{b - a}$$
> **Insight:** Esiste almeno un punto interno c in cui la retta tangente ha esattamente la medesima pendenza della corda secante congiungente gli estremi.

## Dimostrazione: Teorema di Cauchy (Valor Medio Generalizzato)

### 1. Funzione ausiliaria di Cauchy su due funzioni f e g
$$H(x) = [f(b) - f(a)]g(x) - [g(b) - g(a)]f(x)$$
> **Insight:** Combina linearmente due curve continue f e g con g'(x) non nulla nell'intervallo aperto (a, b).

### 2. Annullamento agli estremi e applicazione di Rolle a H(x)
$$H(a) = f(b)g(a) - g(b)f(a) = H(b) \implies \exists c \in (a, b) : H'(c) = 0 \iff \frac{f'(c)}{g'(c)} = \frac{f(b) - f(a)}{g(b) - g(a)}$$
> **Insight:** Il Teorema di Cauchy generalizza Lagrange stabilendo che il rapporto tra le derivate calcolate nel punto comune c eguaglia il rapporto tra gli incrementi complessivi.

## Dimostrazione: Corollario - La Regola di De L'Hôpital per Forme Indeterminate

### 1. Ipotesi di forma indeterminata [0/0] ed estensione continua
Siano $f$ e $g$ derivabili in un intorno forato di $x_0$, con $g'(x) \neq 0$ e:
$$\lim_{x \to x_0} f(x) = 0 \quad \land \quad \lim_{x \to x_0} g(x) = 0$$
Estendiamo con continuità $f$ e $g$ in $x_0$ ponendo $f(x_0) = 0$ e $g(x_0) = 0$.
> **Insight:** L'estensione per continuità garantisce che f e g siano continue nell'intervallo chiuso compreso tra x₀ e x.

### 2. Applicazione del Teorema di Cauchy sull'intervallo [x₀, x]
Per ogni $x \neq x_0$ nell'intorno considerato, applichiamo il Teorema di Cauchy all'intervallo avente estremi $x_0$ e $x$:
$$\frac{f(x)}{g(x)} = \frac{f(x) - f(x_0)}{g(x) - g(x_0)} = \frac{f'(c_x)}{g'(c_x)}$$
dove $c_x$ è un punto interno strettamente compreso tra $x_0$ e $x$.
> **Insight:** Poiché f(x₀) = g(x₀) = 0, il rapporto tra le funzioni si converte esattamente nel rapporto tra le rispettive derivate calcolate in c_x.

### 3. Intrappolamento del punto intermedio per il teorema del confronto
Poiché $c_x$ appartiene all'intervallo aperto compreso tra $x_0$ e $x$:
$$\min(x_0, x) < c_x < \max(x_0, x) \implies \lim_{x \to x_0} c_x = x_0$$
> **Insight:** Al convergere di x verso x₀, il punto intermedio c_x viene inesorabilmente schiacciato verso x₀ per il Teorema dei Carabinieri.

### 4. Passaggio al limite e formulazione di De L'Hôpital
Passando al limite per $x \to x_0$ ed effettuando la sostituzione continua con $c_x$:
$$\lim_{x \to x_0} \frac{f(x)}{g(x)} = \lim_{x \to x_0} \frac{f'(c_x)}{g'(c_x)} = \lim_{c_x \to x_0} \frac{f'(c_x)}{g'(c_x)} = \lim_{x \to x_0} \frac{f'(x)}{g'(x)}$$
> **Insight:** Corollario: se il limite del rapporto delle derivate f'(x)/g'(x) esiste (finito o infinito), esso coincide con il limite originario della forma indeterminata [0/0].

## Dimostrazione: Criterio di Monotonia e Segno della Derivata

### 1. Applicazione di Lagrange a una coppia arbitraria x1 < x2
Siano $x_1, x_2 \in (a, b)$ due punti arbitrari con $x_1 < x_2$. Per il Teorema di Lagrange applicato a $[x_1, x_2]$:
$$\frac{f(x_2) - f(x_1)}{x_2 - x_1} = f'(c) \quad \text{con } c \in (x_1, x_2)$$
> **Insight:** Il rapporto incrementale tra qualsiasi coppia di punti coincide con la derivata calcolata in un punto intermedio c.

### 2. Condizione di crescenza e decrescenza stretta
$$f'(x) > 0 \implies \frac{f(x_2) - f(x_1)}{x_2 - x_1} > 0 \implies f(x_2) > f(x_1) \quad (\forall x_1 < x_2)$$
> **Insight:** Se la derivata prima è ovunque positiva, la funzione è strettamente crescente; se è negativa, è strettamente decrescente.

## Dimostrazione: Corollario - Caratterizzazione delle Funzioni Costanti

### 1. Ipotesi di derivata identicamente nulla
Sia $f$ derivabile sull'intervallo connesso $(a, b)$ con derivata prima identicamente nulla in ogni punto:
$$f'(x) = 0 \quad \forall x \in (a, b)$$
Fissiamo due generici punti distinti $x_1, x_2 \in (a, b)$ con $x_1 < x_2$.
> **Insight:** Vogliamo dimostrare che l'assenza di pendenza istantanea impedisce qualsiasi variazione di quota complessiva tra punti distanti.

### 2. Applicazione del Teorema di Lagrange sull'intervallo [x1, x2]
Poiché $f$ è continua in $[x_1, x_2]$ e derivabile in $(x_1, x_2)$, per Lagrange esiste un punto $c \in (x_1, x_2)$ tale che:
$$f(x_2) - f(x_1) = f'(c) \cdot (x_2 - x_1)$$
> **Insight:** La differenza globale tra i valori della funzione è proporzionale alla derivata nel punto intermedio c.

### 3. Sostituzione dell'ipotesi di annullamento della derivata
Essendo $c \in (a, b)$, l'ipotesi $f'(c) = 0$ implica direttamente:
$$f(x_2) - f(x_1) = 0 \cdot (x_2 - x_1) = 0 \implies f(x_2) = f(x_1)$$
> **Insight:** Il dislivello tra i due punti è rigorosamente nullo indipendentemente dalla loro distanza reciproca x₂ - x₁.

### 4. Deduzione della costanza globale e funzioni con stessa derivata
Dall'arbitrarietà di $x_1$ e $x_2$ segue che $f(x)$ assume sempre il medesimo valore numerico $C \in \mathbb{R}$:
$$f(x) = C \quad \forall x \in (a, b) \quad \land \quad [f'(x) = g'(x) \implies (f - g)'(x) = 0 \implies f(x) = g(x) + C]$$
> **Insight:** Corollario fondamentale: una funzione è costante su un intervallo se e solo se la sua derivata prima è ovunque nulla; due funzioni con la stessa derivata differiscono per una costante additiva C (unicità della primitiva a meno di una costante).
