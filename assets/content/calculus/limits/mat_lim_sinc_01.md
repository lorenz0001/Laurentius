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

## Dimostrazione Logico-Algebrica

### 1. Confronto geometrico delle aree sulla circonferenza goniometrica
$$\frac{1}{2}\sin x < \frac{1}{2}x < \frac{1}{2}\tan x \implies \sin x < x < \tan x \quad \forall x \in \left(0, \frac{\pi}{2}\right)$$
> **Insight:** L'area del settore circolare è geometricamente stretta tra l'area del triangolo inscritto e quella del triangolo circoscritto.

### 2. Divisione per sin(x) e conservazione dell'ordinamento
$$1 < \frac{x}{\sin x} < \frac{1}{\cos x}$$
> **Insight:** Poiché sin(x) > 0 nel primo quadrante, dividere ciascun membro per sin(x) preserva rigorosamente il verso delle disuguaglianze.

### 3. Inversione dei reciproci e simmetria per parità
$$\cos x < \frac{\sin x}{x} < 1 \quad \forall x \in \left(-\frac{\pi}{2}, \frac{\pi}{2}\right) \setminus \{0\}$$
> **Insight:** Il passaggio ai reciproci inverte il verso; la parità di cos(x) e sin(x)/x estende identicamente la validità a tutto l'intorno dell'origine.

### 4. Applicazione del Teorema del Confronto (dei Carabinieri)
$$\lim_{x \to 0} \cos x = 1 \quad \land \quad \lim_{x \to 0} 1 = 1 \implies \lim_{x \to 0} \frac{\sin x}{x} = 1$$
> **Insight:** Le due funzioni sentinella convergono entrambe a 1, costringendo la funzione centrale a convergere allo stesso limite.

### 5. Corollario: Limite Notevole della Tangente e Frequenza k
$$\lim_{x \to 0} \frac{\tan x}{x} = \lim_{x \to 0} \left(\frac{\sin x}{x} \cdot \frac{1}{\cos x}\right) = 1 \cdot 1 = 1 \quad \land \quad \lim_{x \to 0} \frac{\sin(kx)}{x} = k$$
> **Insight:** Moltiplicando e dividendo per la costante k, la rapidità di variazione dell'angolo scala linearmente il limite nell'origine.
