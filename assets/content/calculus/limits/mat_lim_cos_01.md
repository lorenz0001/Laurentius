---
id: mat_lim_cos_01
title: "Limite Notevole del Coseno: (1 - cos x)/x² e Curvatura Locale"
category: "Matematica"
subCategory: "Limiti e Continuità"
prerequisites:
  - mat_lim_sinc_01
interactive:
  template: function_graph
  unit: ""
  equations:
    - "(1 - cos(x)) / (x * x)"
  parameters:
    - variable: a
      label: "Fattore di Curvatura Parabolica"
      unit: ""
      min: 0.2
      max: 2.0
      default: 1.0
      step: 0.1
---

### Il Comportamento del Coseno nell'Intorno dell'Origine

Mentre la funzione seno nell'intorno dell'origine si discosta linearmente dall'asse orizzontale ($\sin x \approx x$), la funzione coseno presenta un punto stazionario di massimo relativo in $(0, 1)$. Di conseguenza, la deviazione del coseno dall'unità è di secondo ordine:

$$\lim_{x \to 0} \frac{1 - \cos x}{x^2} = \frac{1}{2}$$

La quantità $1 - \cos x$, nota storicamente come **senoverso** (*versine*), misura la freccia dell'arco circolare o la distanza orizzontale tra l'arco di cerchio unitario e la retta tangente verticale in $(1, 0)$. Poiché tale distanza si assottiglia proporzionalmente al quadrato dell'angolo $x^2$, il quoziente tende esattamente a $\frac{1}{2}$, corrispondente al raggio di curvatura locale della parabola osculatrice $y \approx 1 - \frac{1}{2}x^2$.

## Dimostrazione: Il Limite Notevole Fondamentale del Coseno (1 - cos x) / x²

### 1. Razionalizzazione mediante coniugato trigonometrico
$$\frac{1 - \cos x}{x^2} = \frac{(1 - \cos x)(1 + \cos x)}{x^2 (1 + \cos x)} = \frac{1 - \cos^2 x}{x^2 (1 + \cos x)}$$
> **Insight:** Moltiplicando numeratore e denominatore per il fattore coniugato (1 + cos x) si trasforma il numeratore nella differenza di quadrati.

### 2. Sostituzione con la relazione fondamentale della goniometria
$$\frac{1 - \cos^2 x}{x^2 (1 + \cos x)} = \frac{\sin^2 x}{x^2 (1 + \cos x)} = \left(\frac{\sin x}{x}\right)^2 \cdot \frac{1}{1 + \cos x}$$
> **Insight:** Ricorrendo all'identità sin²(x) + cos²(x) = 1 si isola esplicitamente il quadrato del limite notevole fondamentale sin(x)/x.

### 3. Calcolo del limite del prodotto di fattori continui
$$\lim_{x \to 0} \left[ \left(\frac{\sin x}{x}\right)^2 \cdot \frac{1}{1 + \cos x} \right] = (1)^2 \cdot \frac{1}{1 + \cos(0)} = 1 \cdot \frac{1}{2} = \frac{1}{2}$$
> **Insight:** La forma indeterminata [0/0] è risolta: il primo fattore converge a 1 per il teorema precedente, e il secondo fattore converge con continuità a 1/2.

## Dimostrazione: Corollario - Limite del Coseno al Primo Ordine (1 - cos x) / x

### 1. Scomposizione del quoziente lineare mediante fattorizzazione
Consideriamo il limite del rapporto al primo ordine nell'origine per $x \to 0$:
$$\lim_{x \to 0} \frac{1 - \cos x}{x}$$
Moltiplichiamo e dividiamo la frazione per la variabile indipendente $x \neq 0$:
$$\frac{1 - \cos x}{x} = x \cdot \frac{1 - \cos x}{x^2}$$
> **Insight:** L'artificio algebrico isola il fattore lineare x moltiplicato per l'espressione nota del limite di secondo ordine del coseno.

### 2. Applicazione del teorema del limite del prodotto
Poiché entrambi i fattori possiedono limite finito per $x \to 0$, applichiamo la linearità moltiplicativa dell'operatore limite:
$$\lim_{x \to 0} \frac{1 - \cos x}{x} = \lim_{x \to 0} \left( x \cdot \frac{1 - \cos x}{x^2} \right) = \left( \lim_{x \to 0} x \right) \cdot \left( \lim_{x \to 0} \frac{1 - \cos x}{x^2} \right)$$
> **Insight:** Il limite del prodotto coincide con il prodotto dei singoli limiti finiti dei due fattori.

### 3. Sostituzione dei valori di convergenza
Sostituendo il limite banale $\lim_{x \to 0} x = 0$ e il limite notevole dimostrato $\lim_{x \to 0} \frac{1 - \cos x}{x^2} = \frac{1}{2}$:
$$\lim_{x \to 0} \frac{1 - \cos x}{x} = 0 \cdot \frac{1}{2} = 0$$
> **Insight:** Poiché la deviazione dal punto di massimo è infinitesima di ordine 2, divisa per un infinitesimo del primo ordine si annulla identicamente.

### 4. Interpretazione differenziale e annullamento della derivata
Il limite calcolato coincide con l'opposto del rapporto incrementale della funzione coseno nel punto $x_0 = 0$:
$$\left. \frac{d}{dx} \cos x \right|_{x=0} = \lim_{h \to 0} \frac{\cos(0 + h) - \cos(0)}{h} = \lim_{h \to 0} \frac{\cos h - 1}{h} = - \lim_{h \to 0} \frac{1 - \cos h}{h} = -0 = 0$$
> **Insight:** Corollario: la retta tangente al grafico di y = cos(x) nel punto (0, 1) è perfettamente orizzontale, confermando che l'origine è un punto stazionario di massimo locale.

## Dimostrazione: Corollario - Riscalamento dell'Argomento e Curvatura (1 - cos(kx)) / x²

### 1. Impostazione del limite con fattore di curvatura k
Consideriamo il limite della deviazione del coseno con parametro di frequenza o dilatazione $k \in \mathbb{R} \setminus \{0\}$:
$$\lim_{x \to 0} \frac{1 - \cos(kx)}{x^2}$$
> **Insight:** Il parametro k modula la curvatura locale della funzione cosenoidale attorno all'apice del grafico.

### 2. Moltiplicazione e divisione per k²
Riorganizziamo la frazione algebrica moltiplicando e dividendo per la quantità costante non nulla $k^2$:
$$\frac{1 - \cos(kx)}{x^2} = k^2 \cdot \frac{1 - \cos(kx)}{k^2 x^2} = k^2 \cdot \frac{1 - \cos(kx)}{(kx)^2}$$
> **Insight:** L'elevamento al quadrato di k a denominatore pareggia perfettamente l'argomento quadratico (kx)².

### 3. Cambio di variabile continuo
Poniamo $u = kx$. Al tendere di $x \to 0$ segue immediatamente $u \to 0$. Estraendo la costante $k^2$:
$$\lim_{x \to 0} \frac{1 - \cos(kx)}{x^2} = \lim_{u \to 0} \left( k^2 \cdot \frac{1 - \cos u}{u^2} \right) = k^2 \cdot \lim_{u \to 0} \frac{1 - \cos u}{u^2}$$
> **Insight:** Il cambio di variabile riduce l'argomento al limite notevole fondamentale precedentemente verificato.

### 4. Conclusione algebrica e sviluppo di Taylor
Sostituendo il valore noto $\lim_{u \to 0} \frac{1 - \cos u}{u^2} = \frac{1}{2}$:
$$\lim_{x \to 0} \frac{1 - \cos(kx)}{x^2} = k^2 \cdot \frac{1}{2} = \frac{k^2}{2} \implies \cos(kx) = 1 - \frac{k^2}{2} x^2 + o(x^2)$$
> **Insight:** Corollario: la curvatura locale nell'origine scala con il quadrato della frequenza k², fornendo il coefficiente quadratico esatto dello sviluppo di Maclaurin.
