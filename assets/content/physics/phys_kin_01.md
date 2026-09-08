---
id: phys_kin_01
title: "Cinematica: Moto Rettilineo e Corollario di Torricelli"
category: "Fisica"
subCategory: "Cinematica e Dinamica"
prerequisites:
  - mat_parabola_01
  - mat_deriv_rules_01
  - mat_fund_calc_01
interactive:
  template: kinematics_simulation
  unit: "m/s"
  equations:
    - "v0 + a * t"
  parameters:
    - variable: v0
      label: "Velocità Iniziale v0 (m/s)"
      unit: "m/s"
      min: 0.0
      max: 30.0
      default: 5.0
      step: 1.0
    - variable: a
      label: "Accelerazione Costante a (m/s²)"
      unit: "m/s²"
      min: -5.0
      max: 10.0
      default: 2.0
      step: 0.5
---

### Il Moto Rettilineo Uniformemente Accelerato

Nel moto rettilineo con accelerazione costante $a$, la variazione temporale della velocità è costante:
- La velocità è una retta nel piano $(t, v)$: $v(t) = v_0 + at$
- La posizione $x(t)$ è una parabola nel tempo, ottenuta per **integrazione definita** della velocità:

$$x(t) = x_0 + v_0 t + \frac{1}{2} a t^2$$

> **Insight:** La celebre **Formula di Torricelli** elimina il tempo $t$ dal sistema, collegando direttamente velocità e spostamento: $v^2 = v_0^2 + 2a\Delta x$.

$$v^2 = v_0^2 + 2 a \Delta x$$

## Dimostrazione: Legge Oraria del Moto Rettilineo Uniformemente Accelerato

### 1. Definizione di accelerazione costante come derivata temporale
$$a = \frac{dv}{dt} = \text{costante} \implies v(t) = v_0 + a t$$
> **Insight:** La velocità cresce in modo direttamente proporzionale al tempo trascorso con pendenza costante a.

### 2. Integrazione definita della velocità nel tempo
$$x(t) = x_0 + \int_0^t v(t') \, dt' = x_0 + \int_0^t (v_0 + a t') \, dt' = x_0 + v_0 t + \frac{1}{2} a t^2$$
> **Insight:** L'integrale orario calcola l'area del trapezio sotteso dalla retta delle velocità nel piano (t, v).

### 3. Definizione dello spostamento netto
Definendo la variazione di posizione $\Delta x \equiv x(t) - x_0$:
$$\Delta x = v_0 t + \frac{1}{2} a t^2$$
> **Insight:** Isola la componente geometrica del percorso netto compiuto dal punto materiale in funzione di v0 e a.

## Dimostrazione: Corollario - Formula Senza Tempo di Torricelli

### 1. Isolamento del tempo t dalla legge lineare della velocità
Dalla relazione cinematica $v = v_0 + at$, supponendo $a \neq 0$, isoliamo la variabile temporale $t$:
$$v - v_0 = a t \implies t = \frac{v - v_0}{a}$$
> **Insight:** Esprime il tempo trascorso come rapporto tra il salto di velocità e l'accelerazione impressa.

### 2. Sostituzione di t nella legge dello spostamento
Sostituiamo l'espressione di $t$ nell'equazione dello spostamento $\Delta x = v_0 t + \frac{1}{2}at^2$:
$$\Delta x = v_0 \left(\frac{v - v_0}{a}\right) + \frac{1}{2} a \left(\frac{v - v_0}{a}\right)^2 = \frac{v_0 v - v_0^2}{a} + \frac{a (v - v_0)^2}{2 a^2}$$
> **Insight:** Eliminiamo il parametro temporale, riconducendo il sistema a una relazione algebrica tra velocità e spazio.

### 3. Sviluppo algebrico del quadrato di binomio e semplificazione dell'accelerazione
Semplificando il fattore $a$ al secondo addendo e sviluppando il quadrato $(v - v_0)^2 = v^2 - 2v v_0 + v_0^2$:
$$\Delta x = \frac{v_0 v - v_0^2}{a} + \frac{v^2 - 2 v v_0 + v_0^2}{2a}$$
> **Insight:** Il denominatore comune 2a consente di sommare algebricamente le due frazioni.

### 4. Somma a denominatore comune 2a ed elisione dei termini misti
Portando l'intera espressione sotto il denominatore comune $2a$:
$$\Delta x = \frac{2(v_0 v - v_0^2) + (v^2 - 2 v v_0 + v_0^2)}{2a} = \frac{2v_0 v - 2v_0^2 + v^2 - 2v_0 v + v_0^2}{2a} = \frac{v^2 - v_0^2}{2a}$$
> **Insight:** I doppi prodotti incrociati +2v0*v e -2v0*v si elidono esattamente, mentre -2v0^2 + v0^2 produce -v0^2.

### 5. Corollario: Formula Indipendente dal Tempo di Torricelli
Moltiplicando ambo i membri per $2a$ e isolando $v^2$:
$$2a\Delta x = v^2 - v_0^2 \iff v^2 = v_0^2 + 2 a \Delta x$$
> **Insight:** Collega direttamente la velocità finale allo spazio percorso senza necessità di conoscere o misurare il tempo impiegato: cardine del teorema delle forze vive.

## Dimostrazione: Corollario - Spazio di Arresto e Velocità Media

### 1. Condizione di arresto di un veicolo in frenata
Consideriamo un corpo in frenata con accelerazione discorde $a = -a_{\text{freno}}$ ($a_{\text{freno}} > 0$) che si arresta ($v = 0$):
$$0^2 = v_0^2 - 2 a_{\text{freno}} d_{\text{stop}}$$
> **Insight:** La velocità finale si annulla all'istante di fermata completa del punto materiale.

### 2. Isolamento dello spazio di arresto
Trasponendo il termine frenante:
$$2 a_{\text{freno}} d_{\text{stop}} = v_0^2 \implies d_{\text{stop}} = \frac{v_0^2}{2 a_{\text{freno}}}$$
> **Insight:** Mostra chiaramente la dipendenza quadratica dello spazio di frenata dalla velocità iniziale.

### 3. Calcolo della velocità media di transito
Calcoliamo il rapporto tra spostamento totale $\Delta x$ e tempo totale $t$:
$$v_m = \frac{\Delta x}{t} = \frac{\frac{v^2 - v_0^2}{2a}}{\frac{v - v_0}{a}} = \frac{(v - v_0)(v + v_0)}{2a} \cdot \frac{a}{v - v_0}$$
> **Insight:** Scomponiamo la differenza di quadrati a numeratore per semplificare il salto di velocità.

### 4. Corollario: Formula della Velocità Media e Spazio di Arresto
Semplificando i termini comuni:
$$v_m = \frac{v_0 + v}{2} \quad \land \quad d_{\text{stop}} = \frac{v_0^2}{2|a|}$$
> **Insight:** Nel moto uniformemente accelerato la velocità media coincide perfettamente con la media aritmetica tra velocità iniziale e velocità finale.
