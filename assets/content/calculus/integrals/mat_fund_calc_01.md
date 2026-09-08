---
id: mat_fund_calc_01
title: "Teorema Fondamentale del Calcolo (Torricelli-Barrow)"
category: "Matematica"
subCategory: "Calcolo Integrale"
prerequisites:
  - mat_riemann_01
  - mat_deriv_def_01
interactive:
  template: riemann_sum
  parameters: []
---

### Il Ponte tra Differenziazione e Integrazione

Il **Teorema Fondamentale del Calcolo Integrale** (noto storicamente come Teorema di Torricelli-Barrow e sviluppato da Newton e Leibniz) costituisce il ponte concettuale più profondo dell'intera analisi matematica. Esso unifica due problemi nati come completamente separati:
1. Il problema geometrico della **tangente** (tasso di variazione istantaneo e derivazione).
2. Il problema geometrico dell'**area** (somma di infinitesimi e integrazione secondo Riemann).

Se $f: [a, b] \to \mathbb{R}$ è una funzione continua, la sua **funzione integrale** $F(x) = \int_a^x f(t) \, dt$ non solo è continua, ma risulta ovunque derivabile nell'intervallo aperto $(a, b)$, con derivata coincidente esattamente con la funzione integranda:

$$F'(x) = \frac{d}{dx} \left[ \int_a^x f(t) \, dt \right] = f(x)$$

Questo straordinario risultato sancisce che l'integrazione e la derivazione sono l'una l'operazione inversa dell'altra.

> **Insight:** Grazie alla formula di Newton-Leibniz che ne discende come corollario immediato, il calcolo dell'area sottesa da una curva $\int_a^b f(x)dx$ non richiede più la faticosa convergenza di somme infinite di rettangoli, ma si riduce alla semplice differenza dei valori di una sua primitiva agli estremi: $G(b) - G(a)$.

## Dimostrazione: Teorema della Media Integrale

### 1. Teorema di Weierstrass sui compatti
$$m \le f(x) \le M \quad \forall x \in [a, b] \quad \text{con } m = \min_{[a, b]} f, \; M = \max_{[a, b]} f$$
> **Insight:** Poiché f è continua su un intervallo chiuso e limitato, assume per Weierstrass il suo valore minimo assoluto m e il suo valore massimo assoluto M.

### 2. Monotonia dell'integrale definito rispetto all'ordinamento
$$\int_a^b m \, dt \le \int_a^b f(t) \, dt \le \int_a^b M \, dt \iff m(b - a) \le \int_a^b f(t) \, dt \le M(b - a)$$
> **Insight:** L'integrale di una costante su [a, b] equivale all'area del rettangolo di base (b - a) e altezza pari alla costante stessa.

### 3. Divisione per l'ampiezza dell'intervallo (b - a)
$$m \le \frac{1}{b - a} \int_a^b f(t) \, dt \le M$$
> **Insight:** La quantità media μ = 1/(b - a) ∫ f(t)dt è un numero reale compreso tra il valore minimo e il valore massimo di f.

### 4. Corollario: Esistenza del Punto Medio Integrale c
$$\exists c \in [a, b] : \quad f(c) = \frac{1}{b - a} \int_a^b f(t) \, dt \iff \int_a^b f(t) \, dt = f(c)(b - a)$$
> **Insight:** Per il Teorema dei Valori Intermedi, la funzione continua f assume tutti i valori compresi tra m e M, esistendo almeno un punto c in cui l'altezza f(c) eguaglia il valor medio dell'area.

## Dimostrazione: Primo Teorema Fondamentale (Torricelli-Barrow)

### 1. Definizione della funzione integrale e calcolo del rapporto incrementale
$$\frac{F(x+h) - F(x)}{h} = \frac{1}{h} \left[ \int_a^{x+h} f(t) \, dt - \int_a^x f(t) \, dt \right] = \frac{1}{h} \int_x^{x+h} f(t) \, dt$$
> **Insight:** Per l'additività dell'integrale rispetto all'intervallo, la differenza tra le due aree lascia unicamente la striscia di base h compresa tra x e x+h.

### 2. Applicazione del Teorema della Media Integrale alla striscia h
$$\frac{1}{h} \int_x^{x+h} f(t) \, dt = f(c_h) \quad \text{con } c_h \in [x, x+h]$$
> **Insight:** Esiste un punto intermedio c_h compreso nell'intorno [x, x+h] tale che l'area esatta coincide con il rettangolo di altezza f(c_h).

### 3. Passaggio al limite per incremento h tendente a zero
$$F'(x) = \lim_{h \to 0} \frac{F(x+h) - F(x)}{h} = \lim_{h \to 0} f(c_h) = f(x)$$
> **Insight:** Poiché c_h è intrappolato tra x e x+h, per h -> 0 si ha c_h -> x. Essendo f continua, lim f(c_h) = f(x).

### 4. Corollario: Esistenza Universale della Primitiva per Funzioni Continue
$$F'(x) = f(x) \quad \forall x \in (a, b) \implies F(x) \text{ è una primitiva di } f(x)$$
> **Insight:** Qualsiasi funzione reale continua ammette sempre almeno una primitiva: la sua stessa funzione integrale F(x).

## Dimostrazione: Secondo Teorema Fondamentale (Formula di Newton-Leibniz)

### 1. Relazione tra due primitive arbitrarie della medesima funzione
$$G'(x) = f(x) \quad \land \quad F'(x) = f(x) \implies [G(x) - F(x)]' = 0 \iff G(x) = F(x) + C$$
> **Insight:** Due funzioni aventi la medesima derivata prima su un intervallo connesso differiscono unicamente per una costante additiva reale C.

### 2. Valutazione nel punto iniziale a
$$G(a) = F(a) + C = \int_a^a f(t) \, dt + C = 0 + C = C \implies C = G(a)$$
> **Insight:** Poiché un integrale con estremi coincidenti è nullo, la costante C è univocamente determinata dal valore della primitiva in a.

### 3. Valutazione nel punto finale b
$$G(b) = F(b) + G(a) = \int_a^b f(t) \, dt + G(a) \iff \int_a^b f(t) \, dt = G(b) - G(a)$$
> **Insight:** Riorganizzando i termini si isola l'integrale definito sull'intero intervallo [a, b].

### 4. Corollario: La Formula Fondamentale del Calcolo Integrale
$$\int_a^b f(x) \, dx = [G(x)]_a^b = G(b) - G(a)$$
> **Insight:** Trasforma il calcolo dell'area in una semplice valutazione della differenza di potenziale primitivo agli estremi del dominio.

## Dimostrazione: Corollario - Regola di Derivazione di Leibniz per Integrali con Estremi Variabili

### 1. Impostazione della funzione integrale con estremi mobili
Sia $f$ una funzione continua e siano $a(x)$ e $b(x)$ due funzioni differenziabili. Consideriamo la funzione definita dall'integrale a estremi variabili:
$$I(x) = \int_{a(x)}^{b(x)} f(t) \, dt$$
Fissiamo un punto costante arbitrario $x_0 \in \mathbb{R}$.
> **Insight:** Questa funzione modella sistemi a volume o intervallo variabile nel tempo, come l'espansione dei cilindri termodinamici.

### 2. Decomposizione dell'intervallo tramite la funzione integrale
Applicando l'additività dell'integrale di Riemann rispetto all'intervallo mediante il polo intermedio $x_0$:
$$I(x) = \int_{x_0}^{b(x)} f(t) \, dt - \int_{x_0}^{a(x)} f(t) \, dt = F(b(x)) - F(a(x))$$
dove $F(u) = \int_{x_0}^u f(t) \, dt$ è la funzione integrale fondamentale di $f$.
> **Insight:** L'integrale a estremi doppiamente mobili viene scomposto nella differenza di due funzioni composte monodimensionali.

### 3. Applicazione della Regola della Catena (Chain Rule)
Deriviamo entrambi i termini rispetto alla variabile indipendente $x$ applicando la derivata di funzione composta:
$$\frac{d}{dx}[F(b(x))] = F'(b(x)) \cdot b'(x), \quad \frac{d}{dx}[F(a(x))] = F'(a(x)) \cdot a'(x)$$
> **Insight:** La derivata della funzione esterna F rispetto all'estremo viene moltiplicata per la velocità istantanea di espansione dell'estremo stesso.

### 4. Sostituzione del Primo Teorema Fondamentale e formula finale
Poiché per il Teorema di Torricelli-Barrow $F'(u) = f(u)$, sostituendo $F'(b(x)) = f(b(x))$ e $F'(a(x)) = f(a(x))$:
$$\frac{d}{dx} \left[ \int_{a(x)}^{b(x)} f(t) \, dt \right] = f(b(x)) \cdot b'(x) - f(a(x)) \cdot a'(x)$$
> **Insight:** Corollario fondamentale (Regola di Leibniz): permette di differenziare istantaneamente integrali a confini mobili senza calcolare esplicitamente alcuna primitiva analitica.
