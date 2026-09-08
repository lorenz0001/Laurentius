---
id: mat_deriv_def_01
title: "Rapporto Incrementale e Definizione di Derivata"
category: "Matematica"
subCategory: "Calcolo Differenziale"
prerequisites:
  - mat_limits_01
interactive:
  template: derivative_tangent
  parameters: []
---

### Il Concetto di Derivata

La **derivata** esprime il tasso di variazione istantaneo di una grandezza. Geometricamente, corrisponde al coefficiente angolare della **retta tangente** al grafico della funzione in un punto fissato $x_0$.

Si costruisce considerando il limite del rapporto incrementale al tendere a zero dell'incremento $h$:

$$f'(x_0) = \lim_{h \to 0} \frac{f(x_0 + h) - f(x_0)}{h}$$

> **Insight:** La derivabilità è una proprietà locale più forte della semplice continuità: se una funzione ammette derivata finita in $x_0$, allora è garantita anche la sua continuità in tale punto.

## Dimostrazione: Costruzione della Derivata Prima dal Rapporto Incrementale

### 1. Definizione di rapporto incrementale
$$\frac{\Delta y}{\Delta x} = \frac{f(x_0 + h) - f(x_0)}{h}$$
> **Insight:** Misura la velocità di variazione media della grandezza nell'intervallo [x₀, x₀+h], corrispondente alla pendenza della corda secante passante per i punti del grafico.

### 2. Passaggio al limite per h -> 0: pendenza istantanea
$$f'(x_0) = \frac{df}{dx}(x_0) \equiv \lim_{h \to 0} \frac{f(x_0 + h) - f(x_0)}{h}$$
> **Insight:** Se il limite esiste finito, la funzione è differenziabile in x₀ e la famiglia delle rette secanti converge stabilmente alla retta tangente locale.

### 3. Equazione cartesiana della retta tangente
$$y - f(x_0) = f'(x_0) \cdot (x - x_0)$$
> **Insight:** La derivata prima f'(x₀) è esattamente il coefficiente angolare m della retta tangente che approssima linearmente il comportamento della curva.

## Dimostrazione: Corollario - Continuità delle Funzioni Derivabili

### 1. Impostazione della variazione della funzione
Sia $f(x)$ derivabile in $x_0$, con derivata finita $f'(x_0) \in \mathbb{R}$. Per dimostrare la continuità in $x_0$, occorre verificare che la variazione $\Delta f$ si annulli al tendere a zero dell'incremento $h$:
$$\lim_{x \to x_0} f(x) = f(x_0) \iff \lim_{h \to 0} [f(x_0 + h) - f(x_0)] = 0$$
> **Insight:** La continuità impone che l'incremento di quota della funzione converga a zero quando la distanza orizzontale h tende a zero.

### 2. Moltiplicazione e divisione identica per l'incremento h
Scriviamo la differenza di quota moltiplicando e dividendo per la quantità non nulla $h \neq 0$:
$$f(x_0 + h) - f(x_0) = h \cdot \frac{f(x_0 + h) - f(x_0)}{h}$$
> **Insight:** L'operazione isola esplicitamente il rapporto incrementale della funzione algebricamente bilanciato dal fattore moltiplicativo lineare h.

### 3. Applicazione del teorema del limite del prodotto
Prendendo il limite per $h \to 0$ di ambo i membri ed applicando la linearità moltiplicativa:
$$\lim_{h \to 0} [f(x_0 + h) - f(x_0)] = \lim_{h \to 0} \left[ h \cdot \frac{f(x_0 + h) - f(x_0)}{h} \right] = \left( \lim_{h \to 0} h \right) \cdot \left( \lim_{h \to 0} \frac{f(x_0 + h) - f(x_0)}{h} \right)$$
> **Insight:** Poiché entrambi i limiti esistono finiti (il primo è nullo, il secondo è la derivata prima f'(x₀)), il limite del prodotto è rigorosamente applicabile.

### 4. Deduzione della continuità locale
Sostituendo il limite fondamentale dell'incremento e la derivata:
$$\lim_{h \to 0} [f(x_0 + h) - f(x_0)] = 0 \cdot f'(x_0) = 0 \implies \lim_{h \to 0} f(x_0 + h) = f(x_0)$$
> **Insight:** Corollario fondamentale: ogni funzione derivabile è necessariamente continua nel punto; l'implicazione inversa non sussiste (es. f(x) = |x| in x=0 è continua ma non derivabile per via del punto angoloso).

## Dimostrazione: Corollario - Equazione della Retta Normale al Grafico

### 1. Definizione geometrica della retta normale
Sia $f$ derivabile in $x_0$ con derivata non nulla $f'(x_0) \neq 0$. La retta normale $r_n$ è definita come la retta perpendicolare alla retta tangente $r_t$ condotta nel medesimo punto di contatto:
$$P_0 = (x_0, f(x_0)), \quad r_n \perp r_t$$
> **Insight:** La retta normale governa le leggi di riflessione ottica, le forze vincolari normali in fisica e i vettori gradiente di superficie.

### 2. Condizione analitica di perpendicolarità cartesiana
Affinché due rette nel piano cartesiano siano reciprocamente ortogonali, il prodotto dei rispettivi coefficienti angolari deve essere pari a $-1$:
$$m_n \cdot m_t = -1 \iff m_n \cdot f'(x_0) = -1 \implies m_n = -\frac{1}{f'(x_0)}$$
> **Insight:** Il coefficiente angolare della normale è l'antireciproco (opposto del reciproco) della derivata prima calcolata nel punto di tangenza.

### 3. Equazione del fascio di rette passanti per il punto di contatto
Applicando l'equazione canonica della retta passante per $P_0(x_0, f(x_0))$ con pendenza assegnata $m_n$:
$$y - f(x_0) = m_n \cdot (x - x_0)$$
> **Insight:** La retta deve condividere esattamente il punto di appoggio P₀ appartenente al grafico della funzione.

### 4. Formulazione algebrica definitiva della normale
Sostituendo il coefficiente antireciproco calcolato:
$$y - f(x_0) = -\frac{1}{f'(x_0)} (x - x_0)$$
> **Insight:** Corollario: formula esplicita della retta normale; se f'(x₀) = 0 (tangente orizzontale), la retta normale degenera nella retta verticale x = x₀.
