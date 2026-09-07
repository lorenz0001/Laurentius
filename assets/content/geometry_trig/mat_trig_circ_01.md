---
id: mat_trig_circ_01
title: "Circonferenza Goniometrica e Relazione Fondamentale"
category: "Matematica"
subCategory: "Goniometria Fondamentale"
prerequisites:
  - mat_pythagoras_01
interactive:
  template: trig_circle
  parameters: []
---

### La Circonferenza Goniometrica: Il Motore della Trigonometria

Immagina un cerchio di raggio unitario ($R = 1$) centrato nell'origine degli assi cartesiani: l'equazione cartesiana è $x^2 + y^2 = 1$.
Tracciando un raggio inclinato di un angolo $\theta$:
- Il **Coseno** ($\cos\theta$) è la proiezione orizzontale (l'ascissa $x$).
- Il **Seno** ($\sin\theta$) è la proiezione verticale (l'ordinata $y$).
- La **Tangente** ($\tan\theta$) è il rapporto tra proiezione verticale e orizzontale: $\frac{\sin\theta}{\cos\theta}$.

$$\sin^2\theta + \cos^2\theta = 1$$

> **Insight:** La celebre **Relazione Fondamentale della Goniometria** non è altro che il Teorema di Pitagora applicato al triangolo rettangolo interno avente per cateti il seno e il coseno e per ipotenusa il raggio unitario $1$.

## Dimostrazione Logico-Algebrica

### 1. Definizione del cerchio goniometrico unitario
$$x^2 + y^2 = 1 \quad \text{sul piano cartesiano}$$
> **Insight:** Ogni semiretta uscente dall'origine forma un angolo θ con il semiasse positivo delle x.

### 2. Definizione analitica di Coseno e Seno come coordinate
$$x_P \equiv \cos(\theta), \quad y_P \equiv \sin(\theta)$$
> **Insight:** Il coseno è l'ascissa e il seno è l'ordinata del punto P sulla circonferenza unitaria.

### 3. Sostituzione nell'equazione della circonferenza
$$(\cos\theta)^2 + (\sin\theta)^2 = 1 \implies \sin^2\theta + \cos^2\theta = 1$$
> **Insight:** La prima relazione fondamentale della goniometria è la formulazione trigonometrica del Teorema di Pitagora.

### 4. Corollario: Definizione di Tangente e Relazione Fondamentale Secondaria
$$\tan\theta \equiv \frac{\sin\theta}{\cos\theta} \implies 1 + \tan^2\theta = \frac{1}{\cos^2\theta}$$
> **Insight:** Dividendo l'identità fondamentale per cos²θ si ottiene la relazione diretta tra tangente e coseno.
