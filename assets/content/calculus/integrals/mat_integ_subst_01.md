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
> **Insight:** Se F e una primitiva di f (F' = f) e g e derivabile con continuita, la derivata della composizione genera il fattore moltiplicativo g'(t).

### 2. Integrazione indefinita di entrambi i membri
$$\int \frac{d}{dt} [F(g(t))] \, dt = \int f(g(t)) \cdot g'(t) \, dt \iff F(g(t)) + C = \int f(g(t)) \cdot g'(t) \, dt$$
> **Insight:** L'integrale della derivata prima restituisce la funzione originaria F(g(t)) a meno di una costante reale arbitraria C.

### 3. Sostituzione formale di variabile e differenziale
$$u = g(t) \implies du = g'(t) \, dt \implies \int f(g(t)) g'(t) \, dt = \int f(u) \, du = F(u) + C$$
> **Insight:** La notazione differenziale di Leibniz du = g'(t)dt formalizza in modo naturale la sostituzione algebrica della grandezza di raccordo.

### 4. Corollario: Cambio degli Estremi negli Integrali Definiti
$$\int_a^b f(x) \, dx = \int_\alpha^\beta f(g(t)) \cdot g'(t) \, dt \quad \text{con } g(\alpha) = a, \; g(\beta) = b$$
> **Insight:** Nei problemi definiti non e necessario ritornare alla variabile originaria x: e sufficiente traslare i confini dell'intervallo [a, b] nei rispettivi valori parametrici [α, β], calcolando direttamente il risultato numerico.

## Dimostrazione: Famiglia degli Integrali Quasi-Immediati

### 1. Integrazione della derivata fratta (Forma Logaritmica)
$$\int \frac{f'(x)}{f(x)} \, dx \implies u = f(x) \; (du = f'(x)dx) \implies \int \frac{1}{u} \, du = \ln|u| + C = \ln|f(x)| + C$$
> **Insight:** Ogni qualvolta il numeratore e la derivata esatta del denominatore, la primitiva e sempre il logaritmo naturale del valore assoluto del denominatore.

### 2. Integrazione della potenza funzionale generalizzata
$$\int [f(x)]^n \cdot f'(x) \, dx \implies \int u^n \, du = \frac{u^{n+1}}{n+1} + C = \frac{[f(x)]^{n+1}}{n+1} + C \quad (n \neq -1)$$
> **Insight:** La presenza del fattore differenziale f'(x) consente di applicare la regola elementare della potenza direttamente all'intera funzione f(x).

### 3. Corollario: Primitive Fondamentali della Tangente e della Cotangente
$$\int \tan x \, dx = \int \frac{\sin x}{\cos x} \, dx = - \int \frac{-\sin x}{\cos x} \, dx = -\ln|\cos x| + C = \ln|\sec x| + C$$
> **Insight:** Risolve l'integrale della funzione tangente interpretando il seno a numeratore come l'opposto della derivata del coseno a denominatore.
