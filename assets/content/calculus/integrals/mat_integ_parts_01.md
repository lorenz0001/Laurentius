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
> **Insight:** Si assume che f e g siano funzioni derivabili con continuità (di classe C¹) sull'intervallo di integrazione.

### 2. Integrazione indefinita termine a termine
$$\int [f(x) g(x)]' \, dx = \int f'(x)g(x) \, dx + \int f(x)g'(x) \, dx$$
> **Insight:** L'integrale della somma di due funzioni equivale alla somma dei rispettivi integrali per la linearità dell'operatore integrale.

### 3. Applicazione del Teorema Fondamentale e isolamento del termine desiderato
$$f(x)g(x) = \int f'(x)g(x) \, dx + \int f(x)g'(x) \, dx \iff \int f(x)g'(x) \, dx = f(x)g(x) - \int f'(x)g(x) \, dx$$
> **Insight:** L'integrale della derivata restituisce la funzione originaria f(x)g(x) a meno di una costante arbitraria inglobata nell'integrale residuo.

## Dimostrazione: Corollario - Integrazione per Parti negli Integrali Definiti

### 1. Integrazione su intervallo compatto [a, b]
Integriamo ambo i membri dell'identità differenziale di Leibniz sul dominio chiuso e limitato $[a, b]$:
$$\int_a^b [f(x)g(x)]' \, dx = \int_a^b f'(x)g(x) \, dx + \int_a^b f(x)g'(x) \, dx$$
> **Insight:** La linearità dell'integrale definito di Riemann si applica direttamente alla somma delle funzioni integrande.

### 2. Applicazione della Formula di Newton-Leibniz al primo membro
Poiché la funzione $H(x) = f(x)g(x)$ è una primitiva esatta della propria derivata $[f(x)g(x)]'$:
$$\int_a^b [f(x)g(x)]' \, dx = [f(x)g(x)]_a^b = f(b)g(b) - f(a)g(a)$$
> **Insight:** Il primo membro collassa esattamente nella differenza dei valori assunti dalla funzione prodotto nei punti di confine.

### 3. Sostituzione algebrica nell'identità integrale
Sostituendo il termine finito calcolato:
$$[f(x)g(x)]_a^b = \int_a^b f'(x)g(x) \, dx + \int_a^b f(x)g'(x) \, dx$$
> **Insight:** L'equazione mette in relazione la variazione al contorno con i due integrali d'area sul dominio.

### 4. Isolamento dell'integrale definito ricercato
Sottraendo il termine $\int_a^b f'(x)g(x)dx$ da entrambi i membri:
$$\int_a^b f(x)g'(x) \, dx = [f(x)g(x)]_a^b - \int_a^b f'(x)g(x) \, dx = [f(b)g(b) - f(a)g(a)] - \int_a^b f'(x)g(x) \, dx$$
> **Insight:** Corollario: la formula per integrali definiti valuta il termine integrato [uv]_a^b direttamente agli estremi senza necessità di calcolare a parte la primitiva indefinita.

## Dimostrazione: Applicazione a Funzioni Trascendenti (Logaritmi e Polinomi)

### 1. Tecnica del fattore unitario nascosto (1 · dx) per il logaritmo
$$\int \ln x \, dx = \int (\ln x) \cdot 1 \, dx \implies u = \ln x \; \left(u' = \frac{1}{x}\right), \quad dv = 1\,dx \; (v = x)$$
Sviluppando algebricamente:
$$\int \ln x \, dx = x \ln x - \int x \cdot \frac{1}{x} \, dx = x \ln x - \int 1 \, dx = x \ln x - x + C$$
> **Insight:** Moltiplicare per 1 trasforma una singola funzione logaritmica in un prodotto idoneo per l'integrazione per parti; il secondo integrale si riduce banalmente all'integrale di 1.

### 2. Abbassamento del grado polinomiale per prodotti con esponenziale
$$\int x e^x \, dx \implies u = x \; (u' = 1), \quad dv = e^x \, dx \; (v = e^x)$$
Applicando la formula:
$$\int x e^x \, dx = x e^x - \int 1 \cdot e^x \, dx = x e^x - e^x + C = (x - 1)e^x + C$$
> **Insight:** La derivazione del fattore algebrico x abbassa il grado a 0, lasciando unicamente l'integrale immediato dell'esponenziale naturale.

## Dimostrazione: Corollario - Risoluzione Algebrica degli Integrali Ciclici Ricorsivi

### 1. Prima integrazione per parti dell'integrale e^x cos(x)
Definiamo l'integrale incognito $I = \int e^x \cos x \, dx$. Scegliamo come fattore finito $u = \cos x$ ($u' = -\sin x$) e come fattore differenziale $dv = e^x dx$ ($v = e^x$):
$$I = \int e^x \cos x \, dx = e^x \cos x - \int e^x (-\sin x) \, dx = e^x \cos x + \int e^x \sin x \, dx$$
> **Insight:** La prima iterazione converte il coseno in seno, generando un integrale residuo di identica complessità trascendente.

### 2. Seconda integrazione per parti sull'integrale residuo
Applichiamo una seconda integrazione per parti al termine $J = \int e^x \sin x \, dx$, scegliendo $u_2 = \sin x$ ($u_2' = \cos x$) e $dv_2 = e^x dx$ ($v_2 = e^x$):
$$J = \int e^x \sin x \, dx = e^x \sin x - \int e^x \cos x \, dx = e^x \sin x - I$$
> **Insight:** La seconda iterazione rigenera esattamente l'integrale di partenza I preceduto dal segno meno.

### 3. Sostituzione ed equazione algebrica lineare nell'incognita I
Sostituendo l'espressione di $J$ nella formula del passaggio 1:
$$I = e^x \cos x + (e^x \sin x - I) = e^x (\cos x + \sin x) - I$$
> **Insight:** Il problema analitico di integrazione si è trasformato in una semplice equazione algebrica di primo grado in cui l'incognita è la funzione integrale I.

### 4. Isolamento algebrico della primitiva e costante arbitraria
Trasportando il termine $-I$ a primo membro e sommando:
$$I + I = 2I = e^x (\sin x + \cos x) \implies I = \int e^x \cos x \, dx = \frac{e^x (\sin x + \cos x)}{2} + C$$
> **Insight:** Corollario fondamentale: la tecnica dell'integrale ciclico ricorsivo isola algebricamente la primitiva dividendo per il coefficiente di rigenerazione 2, senza richiedere ulteriori sviluppi integrali.
