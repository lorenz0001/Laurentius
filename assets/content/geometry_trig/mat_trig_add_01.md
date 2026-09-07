---
id: mat_trig_add_01
title: "Formule Goniometriche: Addizione, Duplicazione e Bisezione"
category: "Matematica"
subCategory: "Goniometria Fondamentale"
prerequisites:
  - mat_trig_circ_01
interactive:
  template: trig_circle
  parameters: []
---

### Formule Goniometriche: Addizione, Duplicazione e Bisezione

Le formule di addizione e sottrazione consentono di calcolare i valori di seno e coseno per combinazioni angolari $(\alpha \pm \beta)$, costituendo la base per la decomposizione in serie di Fourier e l'analisi armonica.

$$\cos(\alpha - \beta) = \cos\alpha \cos\beta + \sin\alpha \sin\beta$$
$$\sin(\alpha \pm \beta) = \sin\alpha \cos\beta \pm \cos\alpha \sin\beta$$

> **Insight:** Dalle formule di addizione discendono per sovrapposizione $(\alpha = \beta)$ le formule di duplicazione $\sin(2\alpha) = 2\sin\alpha\cos\alpha$ e $\cos(2\alpha) = \cos^2\alpha - \sin^2\alpha$, essenziali per abbassare il grado trigonometrico negli integrali.

## Dimostrazione Logico-Algebrica

### 1. Distanza euclidea tra due punti sulla circonferenza unitaria
$$d^2 = (\cos\alpha - \cos\beta)^2 + (\sin\alpha - \sin\beta)^2 = 2 - 2(\cos\alpha\cos\beta + \sin\alpha\sin\beta)$$
> **Insight:** La distanza tra i punti dipende solo dalla differenza angolare (α - β).

### 2. Eguaglianza con la distanza ruotata da (1, 0)
$$\cos(\alpha - \beta) = \cos\alpha \cos\beta + \sin\alpha \sin\beta$$
> **Insight:** Formula fondamentale di sottrazione da cui derivano tutte le altre identità goniometriche.

### 3. Sostituzione con angolo opposto e parità trigonometrica
$$\cos(\alpha + \beta) = \cos\alpha \cos\beta - \sin\alpha \sin\beta, \quad \sin(\alpha \pm \beta) = \sin\alpha \cos\beta \pm \cos\alpha \sin\beta$$
> **Insight:** Formule di addizione complete per seno e coseno.

### 4. Corollario: Formule di Duplicazione e Formule di Bisezione
$$\sin(2\alpha) = 2\sin\alpha\cos\alpha, \quad \cos(2\alpha) = \cos^2\alpha - \sin^2\alpha \implies \sin^2\left(\frac{\alpha}{2}\right) = \frac{1 - \cos\alpha}{2}$$
> **Insight:** Indispensabili per il calcolo degli integrali trigonometrici e l'analisi delle armoniche.
