---
id: mat_lim_sinc_01
title: "Limite Notevole del Seno: sin(x)/x e Teorema dei Carabinieri"
category: "Matematica"
subCategory: "Limiti e Continuità"
prerequisites:
  - mat_limits_01
  - mat_trig_circ_01
interactive:
  template: squeeze_theorem
  unit: ""
  equations:
    - "sin(k * x) / x"
  parameters:
    - variable: k
      label: "Fattore di Frequenza Angolare (k)"
      unit: ""
      min: 0.5
      max: 3.0
      default: 1.0
      step: 0.5
    - variable: delta
      label: "Ampiezza Intorno Delta"
      unit: ""
      min: 0.05
      max: 1.5
      default: 0.8
      step: 0.05
---

### La Forma Indeterminata [0/0] nel Rapporto Goniometrico

Calcolando direttamente il limite per $x \to 0$ del rapporto tra la funzione trigonometrica $\sin x$ e il suo argomento lineare $x$, ci si imbatte nella forma indeterminata $\left[\frac{0}{0}\right]$: sia il numeratore che il denominatore svaniscono all'origine.

$$\lim_{x \to 0} \frac{\sin x}{x} = 1$$

Questo limite è la pietra angolare di tutto il calcolo differenziale goniometrico: senza di esso non è possibile calcolare la derivata fondamentale di $\sin x$ né sviluppare l'ottica ondulatoria, la teoria dei segnali o l'analisi di Fourier.

### Confronto Geometrico sulla Circonferenza Goniometrica

Consideriamo una circonferenza di raggio unitario $R = 1$ centrata nell'origine degli assi cartesiani. Per un angolo $x$ misurato in radianti nel primo quadrante, con $0 < x < \frac{\pi}{2}$, confrontiamo tre figure geometriche ordinate per inclusione spaziale:

1. **Triangolo inscritto $\triangle OAP$:** base unitaria $\overline{OA} = 1$, altezza $\overline{PH} = \sin x$, con $\text{Area}(\triangle OAP) = \frac{1}{2} \cdot 1 \cdot \sin x = \frac{1}{2}\sin x$.
2. **Settore circolare $OAP$:** raggio $1$, arco di ampiezza $x$ radianti, con $\text{Area}(\text{settore } OAP) = \frac{1}{2} \cdot 1^2 \cdot x = \frac{1}{2}x$.
3. **Triangolo circoscritto $\triangle OAT$:** base unitaria $\overline{OA} = 1$, altezza tangente $\overline{AT} = \tan x$, con $\text{Area}(\triangle OAT) = \frac{1}{2} \cdot 1 \cdot \tan x = \frac{1}{2}\tan x$.

Dall'inclusione stretta $\triangle OAP \subset \text{settore } OAP \subset \triangle OAT$ scaturisce l'ordine fondamentale delle rispettive aree.

## Dimostrazione: Il Limite Fondamentale sin(x)/x tramite il Teorema dei Carabinieri

### 1. Confronto geometrico delle aree sulla circonferenza goniometrica
$$\frac{1}{2}\sin x < \frac{1}{2}x < \frac{1}{2}\tan x \implies \sin x < x < \tan x \quad \forall x \in \left(0, \frac{\pi}{2}\right)$$
> **Insight:** L'area del settore circolare è geometricamente stretta tra l'area del triangolo rettangolo inscritto e quella del triangolo rettangolo circoscritto.

### 2. Divisione per sin(x) e conservazione dell'ordinamento
$$1 < \frac{x}{\sin x} < \frac{1}{\cos x}$$
> **Insight:** Poiché sin(x) > 0 nell'intervallo aperto (0, π/2), dividere ciascun termine per sin(x) preserva rigorosamente il verso delle disuguaglianze.

### 3. Inversione dei reciproci ed estensione per simmetria
$$\cos x < \frac{\sin x}{x} < 1 \quad \forall x \in \left(-\frac{\pi}{2}, \frac{\pi}{2}\right) \setminus \{0\}$$
> **Insight:** Il passaggio ai reciproci inverte il verso della disuguaglianza; inoltre la parità di cos(x) e sin(x)/x garantisce la validità nell'intero intorno forato dell'origine.

### 4. Applicazione del Teorema del Confronto (dei Carabinieri)
$$\lim_{x \to 0} \cos x = \cos(0) = 1 \quad \land \quad \lim_{x \to 0} 1 = 1 \implies \lim_{x \to 0} \frac{\sin x}{x} = 1$$
> **Insight:** Le due funzioni sentinella convergono entrambe al valore 1 all'avvicinarsi a zero, costringendo la funzione centrale a convergere esattamente a 1.

## Dimostrazione: Corollario - Limite Notevole della Tangente (tan x / x)

### 1. Definizione della tangente e fattorizzazione del rapporto
Dalla definizione trigonometrica fondamentale $\tan x = \frac{\sin x}{\cos x}$, esprimiamo il rapporto incrementale della tangente come prodotto di due fattori distinti:
$$\frac{\tan x}{x} = \frac{\frac{\sin x}{\cos x}}{x} = \frac{\sin x}{x} \cdot \frac{1}{\cos x}$$
> **Insight:** La scomposizione separa l'argomento nella componente nota del limite notevole del seno e nel fattore continuo reciproco del coseno.

### 2. Applicazione del teorema del limite del prodotto
Poiché entrambi i fattori convergono a valori finiti all'origine, applichiamo il teorema del prodotto dei limiti:
$$\lim_{x \to 0} \frac{\tan x}{x} = \lim_{x \to 0} \left( \frac{\sin x}{x} \cdot \frac{1}{\cos x} \right) = \left( \lim_{x \to 0} \frac{\sin x}{x} \right) \cdot \left( \lim_{x \to 0} \frac{1}{\cos x} \right)$$
> **Insight:** Il limite del prodotto coincide con il prodotto dei singoli limiti purché entrambi esistano finiti.

### 3. Valutazione dei singoli limiti componenti
Sostituendo il limite notevole fondamentale e sfruttando la continuità della funzione coseno nel punto $x = 0$:
$$\lim_{x \to 0} \frac{\sin x}{x} = 1, \quad \lim_{x \to 0} \cos x = \cos(0) = 1 \implies \lim_{x \to 0} \frac{1}{\cos x} = \frac{1}{1} = 1$$
> **Insight:** La funzione coseno non presenta alcuna singolarità o indeterminazione nell'origine, assumendo il valore unitario.

### 4. Conclusione del limite notevole della tangente
Moltiplicando i valori ottenuti:
$$\lim_{x \to 0} \frac{\tan x}{x} = 1 \cdot 1 = 1$$
> **Insight:** Corollario: la retta tangente alla curva y = tan(x) nell'origine coincide con la bisettrice y = x, avendo coefficiente angolare m = 1 e derivata unitaria.

## Dimostrazione: Corollario - Riscalamento dell'Argomento del Seno (Frequenza k)

### 1. Impostazione del limite con fattore di scala k non nullo
Consideriamo il limite del rapporto goniometrico con frequenza angolare o parametro moltiplicativo $k \in \mathbb{R} \setminus \{0\}$:
$$\lim_{x \to 0} \frac{\sin(kx)}{x}$$
> **Insight:** Il parametro k modula la velocità di variazione dell'argomento angolare rispetto alla variabile lineare x.

### 2. Moltiplicazione e divisione per il fattore k
Riorganizziamo algebricamente l'espressione moltiplicando e dividendo il rapporto per la costante non nulla $k$:
$$\frac{\sin(kx)}{x} = k \cdot \frac{\sin(kx)}{kx}$$
> **Insight:** Questo artificio algebrico uniforma l'espressione a denominatore all'esatto argomento della funzione seno.

### 3. Cambio di variabile continuo
Introduciamo la variabile ausiliaria $u = kx$. Poiché $k$ è una costante finita non nulla:
$$x \to 0 \implies u = k \cdot 0 = 0$$
Possiamo quindi riscrivere il limite sfruttando la linearità dell'operatore limite:
$$\lim_{x \to 0} \frac{\sin(kx)}{x} = \lim_{u \to 0} \left( k \cdot \frac{\sin u}{u} \right) = k \cdot \lim_{u \to 0} \frac{\sin u}{u}$$
> **Insight:** Il cambio di variabile u = kx riconduce la frazione interna direttamente alla forma del limite notevole standard nell'origine.

### 4. Conclusione algebrica del riscalamento
Sostituendo il valore noto del limite fondamentale $\lim_{u \to 0} \frac{\sin u}{u} = 1$:
$$\lim_{x \to 0} \frac{\sin(kx)}{x} = k \cdot 1 = k$$
> **Insight:** Corollario: la pendenza nell'origine scala proporzionalmente al fattore di frequenza k; in generale vale lim_{x -> 0} sin(kx)/sin(mx) = k/m.
