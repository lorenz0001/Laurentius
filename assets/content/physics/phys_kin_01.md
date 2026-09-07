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

## Dimostrazione Logico-Algebrica

### 1. Definizione di accelerazione costante come derivata temporale
$$a = \frac{dv}{dt} = \text{costante} \implies v(t) = v_0 + a t$$
> **Insight:** La velocità cresce in modo direttamente proporzionale al tempo trascorso.

### 2. Integrazione della velocità nel tempo
$$x(t) = x_0 + \int_0^t v(t) dt = x_0 + v_0 t + \frac{1}{2} a t^2$$
> **Insight:** L'area sotto la retta delle velocità nel piano (t, v) genera il termine parabolico quadratico.

### 3. Isolamento del tempo t dalla relazione della velocità
$$t = \frac{v - v_0}{a}$$
> **Insight:** Elimina il parametro temporale unificando cinematica e geometria cartesiana.

### 4. Sostituzione di t nella legge oraria dello spostamento
$$\Delta x = v_0 \left(\frac{v - v_0}{a}\right) + \frac{1}{2} a \left(\frac{v - v_0}{a}\right)^2$$
> **Insight:** Espansione del quadrato di binomio e somma a denominatore comune 2a.

### 5. Corollario: Formula Senza Tempo di Torricelli
$$v^2 = v_0^2 + 2 a \Delta x$$
> **Insight:** Collega direttamente la velocità finale allo spazio percorso senza necessità di misurare il tempo.
