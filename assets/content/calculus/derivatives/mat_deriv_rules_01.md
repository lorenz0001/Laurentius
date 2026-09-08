---
id: mat_deriv_rules_01
title: "Regole di Derivazione: Prodotto, Quoziente e Catena"
category: "Matematica"
subCategory: "Calcolo Differenziale"
prerequisites:
  - mat_deriv_def_01
  - mat_binom_01
interactive:
  template: derivative_tangent
  parameters: []
---

### Come Derivare Espressioni Complesse

Quando conosciamo la derivata di funzioni base, come calcoliamo la derivata del loro prodotto o della loro composizione?

#### 1. Regola del Prodotto (Formula di Leibniz)
Pensa a un rettangolo di lati $u(x)$ e $v(x)$. Se entrambi i lati crescono di una piccola quantità $\Delta u$ e $\Delta v$, la nuova area cresce sia per l'allargamento della base che per l'innalzamento dell'altezza. La derivata del prodotto non è semplicemente il prodotto delle derivate, ma una combinazione bilineare:

$$(u \cdot v)' = u' \cdot v + u \cdot v'$$

#### 2. Regola della Catena (Funzioni Composte)
Se una grandezza $y$ dipende da $u$, e a sua volta $u$ dipende da $x$, come ruote dentate di un ingranaggio, la velocità complessiva di rotazione è il prodotto dei singoli tassi di variazione:

$$\frac{dy}{dx} = \frac{dy}{du} \cdot \frac{du}{dx} \iff [f(g(x))]' = f'(g(x)) \cdot g'(x)$$

> **Insight:** Grazie a queste regole e alla derivata trigonometrica $(\sin x)' = \cos x$, possiamo determinare istantaneamente il tasso di variazione di qualsiasi modello scientifico o ingegneristico.

## Dimostrazione: Regola di Leibniz per la Derivata del Prodotto

### 1. Rapporto incrementale del prodotto con termine misto
$$\frac{f(x+h)g(x+h) - f(x)g(x)}{h} = f(x+h)\frac{g(x+h)-g(x)}{h} + g(x)\frac{f(x+h)-f(x)}{h}$$
> **Insight:** Tecnica algebrica fondamentale: si somma e sottrae il termine misto f(x+h)g(x) al numeratore per separare gli incrementi parziali.

### 2. Passaggio al limite per h tendente a zero
$$\lim_{h \to 0} \left[ f(x+h)\frac{g(x+h)-g(x)}{h} + g(x)\frac{f(x+h)-f(x)}{h} \right] = \lim_{h \to 0} f(x+h) \cdot g'(x) + g(x) \cdot f'(x)$$
> **Insight:** Per la continuità garantita dalla derivabilità di f, lim f(x+h) = f(x); i due rapporti incrementali convergono alle rispettive derivate.

### 3. Formulazione definitiva della Regola di Leibniz
$$(f \cdot g)'(x) = f'(x) g(x) + f(x) g'(x)$$
> **Insight:** La derivata di un prodotto non è il prodotto delle derivate, ma una combinazione bilineare simmetrica che governa l'espansione differenziale delle aree.

## Dimostrazione: Corollario - Regola di Derivazione del Quoziente

### 1. Rappresentazione del quoziente come prodotto con funzione reciproca
Siano $f$ e $g$ funzioni derivabili con $g(x) \neq 0$. Esprimiamo il quoziente come prodotto tra il numeratore e la frazione reciproca del denominatore:
$$\frac{f(x)}{g(x)} = f(x) \cdot \frac{1}{g(x)} = f(x) \cdot [g(x)]^{-1}$$
> **Insight:** Trasforma il calcolo della derivata del quoziente nell'applicazione combinata della regola di Leibniz e della derivata del reciproco.

### 2. Derivazione della funzione reciproca 1/g(x)
Calcoliamo la derivata prima della funzione reciproca mediante il limite del rapporto incrementale:
$$\left( \frac{1}{g(x)} \right)' = \lim_{h \to 0} \frac{\frac{1}{g(x+h)} - \frac{1}{g(x)}}{h} = \lim_{h \to 0} \frac{g(x) - g(x+h)}{h \cdot g(x+h) g(x)} = \lim_{h \to 0} \left( -\frac{g(x+h) - g(x)}{h} \cdot \frac{1}{g(x+h) g(x)} \right)$$
Sfruttando la continuità di $g$ e la definizione di derivata:
$$\left( \frac{1}{g(x)} \right)' = -g'(x) \cdot \frac{1}{[g(x)]^2} = -\frac{g'(x)}{[g(x)]^2}$$
> **Insight:** La derivata del reciproco introduce il segno negativo e il quadrato del denominatore algebrico.

### 3. Applicazione della regola del prodotto di Leibniz
Applichiamo la regola del prodotto alla funzione $f(x) \cdot [g(x)]^{-1}$:
$$\left( \frac{f}{g} \right)'(x) = f'(x) \cdot \frac{1}{g(x)} + f(x) \cdot \left( \frac{1}{g(x)} \right)' = \frac{f'(x)}{g(x)} + f(x) \left( -\frac{g'(x)}{[g(x)]^2} \right)$$
> **Insight:** La somma differenziale combina il contributo della variazione del numeratore e la contrazione del denominatore.

### 4. Riduzione a denominatore comune e formula finale
Moltiplicando numeratore e denominatore del primo addendo per $g(x)$:
$$\left( \frac{f}{g} \right)'(x) = \frac{f'(x) g(x)}{[g(x)]^2} - \frac{f(x) g'(x)}{[g(x)]^2} = \frac{f'(x) g(x) - f(x) g'(x)}{[g(x)]^2}$$
> **Insight:** Corollario: la derivata del quoziente è la frazione avente a numeratore la differenza incrociata (derivata del numeratore per denominatore non derivato meno numeratore per derivata del denominatore) e a denominatore il quadrato del denominatore.

## Dimostrazione: Corollario - Regola delle Potenze Intere (x^n)'

### 1. Definizione di rapporto incrementale per f(x) = x^n
Sia $n \in \mathbb{N}^*$ e consideriamo la funzione monomia $f(x) = x^n$. Il suo rapporto incrementale è:
$$\frac{\Delta f}{h} = \frac{(x + h)^n - x^n}{h}$$
> **Insight:** Si valuta come la variazione orizzontale h modifica il volume o l'iper-volume n-dimensionale xⁿ.

### 2. Espansione binomiale di Newton
Sviluppiamo la potenza di binomio $(x + h)^n$ tramite la formula del binomio di Newton:
$$(x + h)^n = \sum_{k=0}^n \binom{n}{k} x^{n-k} h^k = x^n + \binom{n}{1} x^{n-1} h + \binom{n}{2} x^{n-2} h^2 + \dots + h^n$$
Sapendo che $\binom{n}{1} = n$:
$$(x + h)^n - x^n = n x^{n-1} h + \sum_{k=2}^n \binom{n}{k} x^{n-k} h^k$$
> **Insight:** La differenza elimina il termine principale xⁿ, lasciando unicamente potenze crescenti dell'incremento h.

### 3. Semplificazione del fattore incrementale h
Dividendo ciascun termine della sommatoria per l'incremento non nullo $h$:
$$\frac{(x + h)^n - x^n}{h} = n x^{n-1} + h \cdot \left[ \sum_{k=2}^n \binom{n}{k} x^{n-k} h^{k-2} \right]$$
> **Insight:** L'infinitesimo h a denominatore si cancella esattamente con il termine lineare, lasciando tutti gli ordini superiori moltiplicati per almeno un fattore h.

### 4. Passaggio al limite per h tendente a zero
Prendendo il limite per $h \to 0$:
$$\frac{d}{dx}[x^n] = \lim_{h \to 0} \left( n x^{n-1} + h \cdot P(x, h) \right) = n x^{n-1} + 0 = n x^{n-1}$$
> **Insight:** Corollario fondamentale: la derivata della potenza n-esima scala il grado a n-1 moltiplicando per l'esponente originale n; la formula si estende per continuità analitica a ogni esponente reale α ∈ ℝ: (x^α)' = α x^(α-1).

## Dimostrazione: Corollario - Regola della Catena (Funzione Composta)

### 1. Composizione funzionale e incremento intermedio
Sia data la funzione composta $F(x) = (f \circ g)(x) = f(g(x))$, con $g$ derivabile in $x$ e $f$ derivabile in $u = g(x)$. Definiamo l'incremento intermedio della variabile $u$:
$$\Delta u = g(x + h) - g(x) \implies g(x + h) = u + \Delta u$$
> **Insight:** La grandezza intermedia u subisce una perturbazione Δu causata dall'incremento iniziale h della variabile indipendente x.

### 2. Scomposizione del rapporto incrementale complessivo
Supponendo $\Delta u \neq 0$ per $h$ sufficientemente piccolo, fattorizziamo il rapporto incrementale complessivo moltiplicando e dividendo per $\Delta u$:
$$\frac{F(x + h) - F(x)}{h} = \frac{f(g(x + h)) - f(g(x))}{h} = \frac{f(u + \Delta u) - f(u)}{\Delta u} \cdot \frac{g(x + h) - g(x)}{h}$$
> **Insight:** La frazione complessiva si scompone nel prodotto tra il rapporto incrementale di f rispetto a u e il rapporto incrementale di g rispetto a x.

### 3. Continuità di g e convergenza dell'incremento intermedio
Poiché $g$ è derivabile in $x$, essa è anche continua nel medesimo punto, implicando:
$$\lim_{h \to 0} \Delta u = \lim_{h \to 0} [g(x + h) - g(x)] = 0$$
> **Insight:** Quando l'incremento primario h tende a zero, anche la variazione intermedia Δu collassa a zero con continuità.

### 4. Calcolo del limite del prodotto e formulazione della Chain Rule
Passando al limite per $h \to 0$ di entrambi i fattori:
$$[f(g(x))]' = \left( \lim_{\Delta u \to 0} \frac{f(u + \Delta u) - f(u)}{\Delta u} \right) \cdot \left( \lim_{h \to 0} \frac{g(x + h) - g(x)}{h} \right) = f'(u) \cdot g'(x) = f'(g(x)) \cdot g'(x)$$
> **Insight:** Corollario: la velocità di variazione complessiva è il prodotto dei tassi di variazione istantanei a cascata lungo la catena di dipendenza: dy/dx = (dy/du) · (du/dx).
