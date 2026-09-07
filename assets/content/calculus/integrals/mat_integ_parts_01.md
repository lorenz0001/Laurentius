---
id: mat_integ_parts_01
title: "Integrazione per Parti"
category: "Matematica"
subCategory: "Calcolo Integrale"
prerequisites:
  - mat_fund_calc_01
  - mat_deriv_rules_01
interactive:
  template: function_graph
  unit: ""
  equations:
    - "x * exp(x)"
  parameters:
    - variable: a
      label: "Scala"
      min: 0.5
      max: 2.0
      default: 1.0
      step: 0.1
---

### Integrazione per Parti: Inversione della Regola di Leibniz

Il metodo di **integrazione per parti** è la controparte integrale della celebre regola di Leibniz per la derivazione del prodotto di due funzioni. Esso consente di trasformare un integrale complesso nel prodotto di due funzioni noto, meno un secondo integrale generalmente più semplice da calcolare:

$$\int f(x) g'(x) \, dx = f(x) g(x) - \int f'(x) g(x) \, dx$$

In notazione differenziale compatta, ponendo $u = f(x)$ e $dv = g'(x)dx$, la formula assume la forma classica:

$$\int u \, dv = u v - \int v \, du$$

La scelta strategica del fattore finito $u$ (da derivare) e del fattore differenziale $dv$ (da integrare) viene guidata dall'acronimo euristico **LIATE**:
1. **L**: Funzioni Logaritmiche ($\ln x$)
2. **I**: Funzioni Inverse trigonometriche ($\arcsin x, \arctan x$)
3. **A**: Funzioni Algebriche e polinomi ($x^n, P(x)$)
4. **T**: Funzioni Trigonometriche ($\sin x, \cos x$)
5. **E**: Funzioni Esponenziali ($e^x, a^x$)

> **Insight:** Il principio guida è scegliere come fattore finito u la funzione che si semplifica derivandola (es. i polinomi o i logaritmi), e come fattore differenziale dv una funzione la cui primitiva sia immediata e non introduca complessità (es. esponenziali o seni/coseni).

## Dimostrazione: Formula Generale di Integrazione per Parti

### 1. Regola di derivazione del prodotto di due funzioni derivabili
$$[f(x) \cdot g(x)]' = f'(x)g(x) + f(x)g'(x)$$
> **Insight:** Si assume che f e g siano funzioni derivabili con continuita (di classe C^1) sull'intervallo di integrazione.

### 2. Integrazione indefinita termine a termine
$$\int [f(x) g(x)]' \, dx = \int f'(x)g(x) \, dx + \int f(x)g'(x) \, dx$$
> **Insight:** L'integrale della somma di due funzioni equivale alla somma dei rispettivi integrali per la linearita dell'operatore integrale.

### 3. Applicazione del Teorema Fondamentale e isolamento del termine desiderato
$$f(x)g(x) = \int f'(x)g(x) \, dx + \int f(x)g'(x) \, dx \iff \int f(x)g'(x) \, dx = f(x)g(x) - \int f'(x)g(x) \, dx$$
> **Insight:** L'integrale della derivata restituisce la funzione originaria f(x)g(x) a meno di una costante arbitraria inglobata nell'integrale residuo.

### 4. Corollario: Integrazione per Parti negli Integrali Definiti
$$\int_a^b f(x)g'(x) \, dx = [f(x)g(x)]_a^b - \int_a^b f'(x)g(x) \, dx = [f(b)g(b) - f(a)g(a)] - \int_a^b f'(x)g(x) \, dx$$
> **Insight:** La valutazione agli estremi del termine fuori integrale [uv]_a^b preserva rigorosamente la consistenza con la formula di Newton-Leibniz.

## Dimostrazione: Euristica di Scelta LIATE e Integrali Notevoli

### 1. Tecnica del fattore unitario nascosto (1 · dx) per il logaritmo
$$\int \ln x \, dx = \int \ln x \cdot 1 \, dx \implies u = \ln x \; (u' = \frac{1}{x}), \quad dv = 1\,dx \; (v = x)$$
> **Insight:** Moltiplicare per 1 trasforma una singola funzione logaritmica o trigonometrica inversa in un prodotto idoneo per l'integrazione per parti.

### 2. Sviluppo algebrico dell'integrale del logaritmo
$$\int \ln x \, dx = x \ln x - \int x \cdot \frac{1}{x} \, dx = x \ln x - \int 1 \, dx = x \ln x - x + C$$
> **Insight:** Il prodotto tra la primitiva x e la derivata del logaritmo 1/x si semplifica esattamente a 1, rendendo banale il calcolo del secondo integrale.

### 3. Abbassamento del grado polinomiale per prodotti con esponenziale
$$\int x e^x \, dx \implies u = x \; (u' = 1), \quad dv = e^x \, dx \; (v = e^x) \implies \int x e^x \, dx = x e^x - \int 1 \cdot e^x \, dx = (x - 1)e^x + C$$
> **Insight:** La derivazione del polinomio x riduce il grado a 0, lasciando unicamente l'integrale immediato dell'esponenziale.

### 4. Corollario: Integrali Ciclici Ricorsivi
$$\int e^x \cos x \, dx = e^x \sin x - \int e^x \sin x \, dx = e^x \sin x - [ -e^x \cos x + \int e^x \cos x \, dx ] \implies \int e^x \cos x \, dx = \frac{e^x (\sin x + \cos x)}{2} + C$$
> **Insight:** Integrando per parti due volte consecutive si rigenera l'integrale di partenza con segno opposto, risolvendo l'equazione algebrica per via puramente simbolica senza calcolare ulteriori primitive.
