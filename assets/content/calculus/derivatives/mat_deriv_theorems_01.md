---
id: mat_deriv_theorems_01
title: "Teoremi di Rolle, Lagrange e Criterio di Monotonia"
category: "Matematica"
subCategory: "Teoremi Differenziali"
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
> **Insight:** Il punto x_0 e un punto di massimo locale interno all'intervallo aperto.

### 2. Studio del rapporto incrementale destro (h > 0)
$$h > 0 \implies f(x_0 + h) - f(x_0) \le 0 \implies \frac{f(x_0 + h) - f(x_0)}{h} \le 0 \implies f'_+(x_0) \le 0$$
> **Insight:** Avvicinandosi da destra, il numeratore e non positivo e il denominatore e positivo.

### 3. Studio del rapporto incrementale sinistro (h < 0)
$$h < 0 \implies f(x_0 + h) - f(x_0) \le 0 \implies \frac{f(x_0 + h) - f(x_0)}{h} \ge 0 \implies f'_-(x_0) \ge 0$$
> **Insight:** Avvicinandosi da sinistra, la divisione tra due quantita negative genera un rapporto incrementale non negativo.

### 4. Corollario: Annullamento della Derivata Istantanea (f'(x_0) = 0)
$$f'(x_0) = f'_+(x_0) = f'_-(x_0) \implies f'(x_0) \le 0 \land f'(x_0) \ge 0 \iff f'(x_0) = 0$$
> **Insight:** L'unica possibilita affinche i limiti destro e sinistro coincidano e che la derivata sia identicamente nulla: la retta tangente nei massimi e minimi interni e rigorosamente orizzontale.

## Dimostrazione: Teorema di Rolle (Quota Coincidente agli Estremi)

### 1. Teorema di Weierstrass sui compatti e ipotesi di quota
$$f(a) = f(b), \quad \exists x_m, x_M \in [a, b] : f(x_m) = m = \min_{[a, b]} f, \; f(x_M) = M = \max_{[a, b]} f$$
> **Insight:** Essendo f continua sul chiuso e limitato [a, b], ammette certamente minimo assoluto m e massimo assoluto M.

### 2. Caso degenere: funzione costante su tutto l'intervallo
$$m = M \implies f(x) = C \quad \forall x \in [a, b] \implies f'(x) = 0 \quad \forall x \in (a, b)$$
> **Insight:** Se il minimo coincide con il massimo, la curva e una retta orizzontale e qualsiasi punto c interno soddisfa la tesi.

### 3. Caso non degenere: esistenza di un estremo all'interno dell'intervallo aperto
$$m < M \implies \text{Almeno uno tra } x_m \text{ o } x_M \text{ appartiene a } (a, b)$$
> **Insight:** Poiche f(a) = f(b), entrambi gli estremi non possono trovarsi contemporaneamente su a e b senza che la funzione sia costante.

### 4. Corollario: Esistenza del Punto a Tangente Orizzontale
$$\exists c \in (a, b) : f'(c) = 0 \quad \text{per il Teorema di Fermat}$$
> **Insight:** Il punto interno c che realizza il massimo o il minimo relativo soddisfa Fermat e possiede derivata prima nulla.

## Dimostrazione: Teorema del Valor Medio di Lagrange

### 1. Costruzione della funzione ausiliaria di scarto cordale
$$F(x) = f(x) - \left[ f(a) + \frac{f(b) - f(a)}{b - a}(x - a) \right]$$
> **Insight:** F(x) misura la distanza verticale tra la curva f(x) e la retta secante passante per i punti (a, f(a)) e (b, f(b)).

### 2. Verifica delle ipotesi del Teorema di Rolle su F(x)
$$F(a) = f(a) - f(a) = 0, \quad F(b) = f(b) - [f(a) + f(b) - f(a)] = 0 \implies F(a) = F(b) = 0$$
> **Insight:** F(x) e continua in [a, b], derivabile in (a, b) e assume lo stesso valore nullo agli estremi: Rolle e applicabile!

### 3. Calcolo della derivata prima di F(x)
$$F'(x) = f'(x) - \frac{f(b) - f(a)}{b - a}$$
> **Insight:** La derivata della retta secante e semplicemente il suo coefficiente angolare costante.

### 4. Corollario: Parallelismo tra Tangente e Secante
$$\exists c \in (a, b) : F'(c) = 0 \iff f'(c) = \frac{f(b) - f(a)}{b - a}$$
> **Insight:** Esiste almeno un punto interno c in cui la retta tangente ha esattamente la medesima pendenza della corda secante congiungente gli estremi.

## Dimostrazione: Teorema di Cauchy e Regola di De L'Hôpital

### 1. Funzione ausiliaria di Cauchy su due funzioni f e g
$$H(x) = [f(b) - f(a)]g(x) - [g(b) - g(a)]f(x)$$
> **Insight:** Generalizzazione a due curve continue f e g con g'(x) non nulla.

### 2. Annullamento agli estremi e applicazione di Rolle a H(x)
$$H(a) = f(b)g(a) - g(b)f(a) = H(b) \implies \exists c \in (a, b) : H'(c) = 0 \iff \frac{f'(c)}{g'(c)} = \frac{f(b) - f(a)}{g(b) - g(a)}$$
> **Insight:** Teorema di Cauchy del valor medio generalizzato.

### 3. Corollario: La Regola di De L'Hôpital per Forme Indeterminate
$$\lim_{x \to x_0} \frac{f(x)}{g(x)} = \lim_{x \to x_0} \frac{f(x) - f(x_0)}{g(x) - g(x_0)} = \lim_{x \to x_0} \frac{f'(c_x)}{g'(c_x)} = \lim_{x \to x_0} \frac{f'(x)}{g'(x)}$$
> **Insight:** Se f(x0) = g(x0) = 0, il rapporto tra le funzioni coincide con il limite del rapporto tra le rispettive derivate prime.

## Dimostrazione: Criterio di Monotonia e Concavità

### 1. Applicazione di Lagrange a una coppia arbitraria di punti x1 < x2
$$\frac{f(x_2) - f(x_1)}{x_2 - x_1} = f'(c) \quad \text{con } c \in (x_1, x_2)$$
> **Insight:** Il segno del rapporto incrementale globale dipende unicamente dal segno della derivata prima calcolata nel punto intermedio c.

### 2. Condizione di crescenza e decrescenza stretta
$$f'(x) > 0 \implies \frac{f(x_2) - f(x_1)}{x_2 - x_1} > 0 \implies f(x_2) > f(x_1) \quad (\forall x_1 < x_2)$$
> **Insight:** Se la derivata prima e positiva, la funzione e strettamente crescente; se e negativa, e strettamente decrescente.

### 3. Corollario: Caratterizzazione delle Funzioni Costanti
$$f'(x) = 0 \quad \forall x \in (a, b) \implies f(x_2) - f(x_1) = 0 \iff f(x) = C$$
> **Insight:** Una funzione ha derivata ovunque nulla se e solo se e identicamente costante su tutto l'intervallo connesso.
