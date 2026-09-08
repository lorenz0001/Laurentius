---
id: mat_integ_subst_01
title: "Integrazione per Sostituzione e Integrali Quasi-Immediati"
category: "Matematica"
subCategory: "Calcolo Integrale"
prerequisites:
  - mat_fund_calc_01
  - mat_deriv_rules_01
interactive:
  template: function_graph
  unit: ""
  equations:
    - "2 * x / (x * x + 1)"
  parameters:
    - variable: a
      label: "Coeff. a"
      min: 0.5
      max: 3.0
      default: 1.0
      step: 0.5
---

### Integrazione per Sostituzione: Il Cambio di Variabile

Il metodo di **integrazione per sostituzione** rappresenta l'operazione duale della regola di derivazione delle funzioni composte (*Chain Rule*). Esso consente di riscrivere un integrale dipendente da una variabile $x$ in termini di una nuova variabile ausiliaria $t$, semplificando la forma algebrica dell'integrando:

$$\int f(g(t)) \cdot g'(t) \, dt = \left[ \int f(u) \, du \right]_{u = g(t)} = F(g(t)) + C$$

La relazione tra i differenziali delle due variabili $x = g(t)$ è governata dal fattore di scala dato dalla derivata prima della trasformazione:

$$dx = g'(t) \, dt \iff dt = \frac{dx}{g'(t)}$$

Questo principio genera la fondamentale famiglia degli **integrali quasi-immediati**, nei quali la presenza simultanea di una funzione $f(x)$ e della sua derivata $f'(x)$ permette di determinare la primitiva per via puramente sintetica.

> **Insight:** Nel cambio di variabile non basta sostituire l'incognita x con g(t): è categorico sostituire anche l'elemento differenziale dx con g'(t)dt. Tale termine riflette la deformazione locale della metrica dell'intervallo di integrazione.

## Dimostrazione: Teorema del Cambio di Variabile negli Integrali

### 1. Regola di derivazione di funzione composta (Chain Rule)
$$\frac{d}{dt} [F(g(t))] = F'(g(t)) \cdot g'(t) = f(g(t)) \cdot g'(t)$$
> **Insight:** Se F è una primitiva di f (F' = f) e g è derivabile con continuità, la derivata della composizione genera il fattore moltiplicativo g'(t).

### 2. Integrazione indefinita di entrambi i membri
$$\int \frac{d}{dt} [F(g(t))] \, dt = \int f(g(t)) \cdot g'(t) \, dt \iff F(g(t)) + C = \int f(g(t)) \cdot g'(t) \, dt$$
> **Insight:** L'integrale della derivata prima restituisce la funzione originaria F(g(t)) a meno di una costante reale arbitraria C.

### 3. Sostituzione formale di variabile e differenziale
$$u = g(t) \implies du = g'(t) \, dt \implies \int f(g(t)) g'(t) \, dt = \int f(u) \, du = F(u) + C$$
> **Insight:** La notazione differenziale di Leibniz du = g'(t)dt formalizza in modo naturale la sostituzione algebrica della grandezza di raccordo.

## Dimostrazione: Corollario - Cambio degli Estremi negli Integrali Definiti

### 1. Primitiva e Formula Fondamentale del Calcolo Integrale
Sia $f$ una funzione continua e sia $F$ una sua generica primitiva tale che $F'(x) = f(x)$. Per il Teorema di Newton-Leibniz:
$$\int_a^b f(x) \, dx = F(b) - F(a)$$
> **Insight:** Il valore numerico dell'integrale definito equivale al dislivello netto della primitiva valutata agli estremi del dominio.

### 2. Definizione della mappa di trasformazione e nuovi estremi
Sia $x = g(t)$ una trasformazione invertibile di classe $C^1$ definita sull'intervallo $[\alpha, \beta]$ tale che:
$$g(\alpha) = a, \quad g(\beta) = b, \quad dx = g'(t) \, dt$$
> **Insight:** La funzione g rimappa biiettivamente l'intervallo originale [a, b] nel dominio parametrico [α, β].

### 3. Derivata della funzione composta H(t) = F(g(t))
Definiamo la funzione ausiliaria $H(t) = F(g(t))$. Applicando la regola della catena differenziale:
$$H'(t) = \frac{d}{dt}[F(g(t))] = F'(g(t)) \cdot g'(t) = f(g(t)) \cdot g'(t)$$
> **Insight:** La funzione integranda trasformata f(g(t))g'(t) è la derivata esatta della funzione composta H(t).

### 4. Integrazione definita in t e coincidenza dei risultati
Applicando la formula di Newton-Leibniz alla derivata $H'(t)$ sul dominio $[\alpha, \beta]$:
$$\int_\alpha^\beta f(g(t)) \cdot g'(t) \, dt = [H(t)]_\alpha^\beta = H(\beta) - H(\alpha) = F(g(\beta)) - F(g(\alpha)) = F(b) - F(a) = \int_a^b f(x) \, dx$$
> **Insight:** Corollario fondamentale: trasformando direttamente gli estremi da [a, b] a [α, β] non occorre ritornare alla variabile originaria x, calcolando direttamente il valore numerico dell'integrale.

## Dimostrazione: Famiglia degli Integrali Quasi-Immediati

### 1. Integrazione della derivata fratta (Forma Logaritmica)
$$\int \frac{f'(x)}{f(x)} \, dx \implies u = f(x) \; (du = f'(x)dx) \implies \int \frac{1}{u} \, du = \ln|u| + C = \ln|f(x)| + C$$
> **Insight:** Ogni qualvolta il numeratore è la derivata esatta del denominatore, la primitiva è sempre il logaritmo naturale del valore assoluto del denominatore.

### 2. Integrazione della potenza funzionale generalizzata
$$\int [f(x)]^n \cdot f'(x) \, dx \implies \int u^n \, du = \frac{u^{n+1}}{n+1} + C = \frac{[f(x)]^{n+1}}{n+1} + C \quad (n \neq -1)$$
> **Insight:** La presenza del fattore differenziale f'(x) consente di applicare la regola elementare della potenza direttamente all'intera funzione f(x).

## Dimostrazione: Corollario - Primitiva della Funzione Tangente

### 1. Riscrittura come quoziente trigonometrico
Scriviamo la funzione tangente come rapporto tra seno e coseno:
$$\int \tan x \, dx = \int \frac{\sin x}{\cos x} \, dx$$
> **Insight:** Esplicita la struttura frazionaria per consentire l'applicazione del metodo di sostituzione diretta.

### 2. Cambio di variabile e differenziale del denominatore
Poniamo la variabile ausiliaria pari al denominatore $u = \cos x$. Differenziando:
$$du = \frac{d}{dx}[\cos x] \, dx = -\sin x \, dx \implies \sin x \, dx = -du$$
> **Insight:** Il numeratore sin(x)dx differisce dal differenziale du unicamente per il segno negativo.

### 3. Sostituzione nella forma logaritmica
Sostituendo la variabile e il differenziale nell'integrale:
$$\int \frac{\sin x}{\cos x} \, dx = \int \frac{-du}{u} = -\int \frac{1}{u} \, du = -\ln|u| + C$$
> **Insight:** L'integrale trascendente è stato ricondotto all'integrale elementare del reciproco.

### 4. Ripristino della variabile originaria e proprietà dei logaritmi
Sostituendo $u = \cos x$ ed applicando la proprietà $\ln(w^{-1}) = -\ln(w)$:
$$-\ln|\cos x| + C = \ln\left(|\cos x|^{-1}\right) + C = \ln\left|\frac{1}{\cos x}\right| + C = \ln|\sec x| + C$$
> **Insight:** Corollario: la primitiva della tangente è -ln|cos x| + C = ln|sec x| + C, definita in tutti gli intervalli in cui il coseno non si annulla (x ≠ π/2 + kπ).

## Dimostrazione: Corollario - Primitiva della Funzione Cotangente

### 1. Riscrittura come quoziente trigonometrico reciproco
Esprimiamo la cotangente mediante la definizione fondamentale $\cot x = \frac{\cos x}{\sin x}$:
$$\int \cot x \, dx = \int \frac{\cos x}{\sin x} \, dx$$
> **Insight:** Evidenzia il rapporto tra il coseno al numeratore e il seno al denominatore.

### 2. Riconoscimento del differenziale esatto
Poniamo la variabile ausiliaria $u = \sin x$. Calcolando il relativo differenziale:
$$du = \frac{d}{dx}[\sin x] \, dx = \cos x \, dx$$
> **Insight:** Il numeratore coincide già esattamente e senza necessità di fattori correttivi con il differenziale du.

### 3. Sostituzione integrale immediata
Sostituendo nell'integrale:
$$\int \frac{\cos x}{\sin x} \, dx = \int \frac{du}{u} = \ln|u| + C$$
> **Insight:** L'integrale rientra direttamente nella forma quasi-immediata logaritmica.

### 4. Ripristino della variabile originaria
Sostituendo $u = \sin x$:
$$\int \cot x \, dx = \ln|\sin x| + C$$
> **Insight:** Corollario: la primitiva della cotangente è ln|sin x| + C per ogni x ≠ kπ, completando il quadro delle primitive goniometriche fondamentali.
