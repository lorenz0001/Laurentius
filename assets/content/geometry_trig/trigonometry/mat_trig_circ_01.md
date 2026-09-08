---
id: mat_trig_circ_01
title: "Circonferenza Goniometrica e Relazione Fondamentale"
category: "Matematica"
subCategory: "Goniometria e Trigonometria"
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

## Dimostrazione: Prima Relazione Fondamentale della Goniometria

### 1. Definizione del cerchio goniometrico unitario
$$x^2 + y^2 = 1 \quad \text{sul piano cartesiano}$$
> **Insight:** Ogni semiretta uscente dall'origine forma un angolo θ con il semiasse positivo delle x.

### 2. Definizione analitica di Coseno e Seno come coordinate
$$x_P \equiv \cos\theta, \quad y_P \equiv \sin\theta$$
> **Insight:** Il coseno è l'ascissa e il seno è l'ordinata del punto P sulla circonferenza unitaria.

### 3. Sostituzione nell'equazione cartesiana della circonferenza
$$(\cos\theta)^2 + (\sin\theta)^2 = 1 \implies \cos^2\theta + \sin^2\theta = 1$$
> **Insight:** La prima relazione fondamentale della goniometria è la formulazione trigonometrica del Teorema di Pitagora per il raggio unitario.

## Dimostrazione: Corollario - Relazione Fondamentale Secondaria tra Tangente e Coseno

### 1. Ipotesi dalla prima relazione fondamentale
Consideriamo l'identità fondamentale valida per ogni angolo reale $\theta$:
$$\sin^2\theta + \cos^2\theta = 1$$
> **Insight:** Vogliamo collegare la tangente trigonometrica direttamente al coseno dell'angolo.

### 2. Divisione membro a membro per il quadrato del coseno
Imponendo la condizione di esistenza $\theta \neq \frac{\pi}{2} + k\pi$ (ovvero $\cos\theta \neq 0$), dividiamo ambo i membri per $\cos^2\theta$:
$$\frac{\sin^2\theta + \cos^2\theta}{\cos^2\theta} = \frac{1}{\cos^2\theta}$$
> **Insight:** La divisione è lecita e definita in tutti i punti non asintotici della tangente.

### 3. Scomposizione della frazione algebrica
Decomponiamo la frazione a primo membro nella somma di due frazioni parziali:
$$\frac{\sin^2\theta}{\cos^2\theta} + \frac{\cos^2\theta}{\cos^2\theta} = \left(\frac{\sin\theta}{\cos\theta}\right)^2 + 1$$
> **Insight:** La semplificazione del secondo termine produce l'unità 1.

### 4. Corollario: Sostituzione della Tangente e Formula Risolutiva
Sostituendo la definizione geometrica della tangente $\tan\theta \equiv \frac{\sin\theta}{\cos\theta}$:
$$1 + \tan^2\theta = \frac{1}{\cos^2\theta} \iff \cos^2\theta = \frac{1}{1 + \tan^2\theta}$$
> **Insight:** Permette di determinare il coseno conoscendo unicamente la tangente dell'angolo, eliminando la necessità di calcolare separatamente il seno.

## Dimostrazione: Corollario - Relazione Fondamentale per la Cotangente

### 1. Ipotesi e condizione di esistenza per il seno non nullo
Consideriamo nuovamente la prima relazione fondamentale $\cos^2\theta + \sin^2\theta = 1$, con $\theta \neq k\pi$ ($\sin\theta \neq 0$):
$$\cos^2\theta + \sin^2\theta = 1 \quad (\sin\theta \neq 0)$$
> **Insight:** Vogliamo dedurre la relazione duale per la funzione cotangente.

### 2. Divisione termine a termine per il quadrato del seno
Dividiamo entrambi i membri per $\sin^2\theta$:
$$\frac{\cos^2\theta}{\sin^2\theta} + \frac{\sin^2\theta}{\sin^2\theta} = \frac{1}{\sin^2\theta}$$
> **Insight:** Analoga operazione condotta sul seno al quadrato per isolare il rapporto cos/sen.

### 3. Riconoscimento del rapporto cotangenziale
Applicando le proprietà delle frazioni e semplificando:
$$\left(\frac{\cos\theta}{\sin\theta}\right)^2 + 1 = \frac{1}{\sin^2\theta}$$
> **Insight:** Il termine quadratico è il quadrato esatto della cotangente.

### 4. Corollario: Relazione Fondamentale della Cotangente
Sostituendo la definizione di cotangente $\cot\theta \equiv \frac{\cos\theta}{\sin\theta}$:
$$1 + \cot^2\theta = \frac{1}{\sin^2\theta} \iff \sin^2\theta = \frac{1}{1 + \cot^2\theta}$$
> **Insight:** Stabilisce la relazione algebrica duale tra la cotangente e il seno dell'angolo.
