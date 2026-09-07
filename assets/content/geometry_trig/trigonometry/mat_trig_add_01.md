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

### Formule Goniometriche Fondamentali: Analisi Armonica e Identità

Le formule goniometriche collegano le funzioni circolari di somme, differenze, multipli e frazioni di angoli. Esse costituiscono l'architettura matematica essenziale per l'analisi armonica di Fourier, l'elaborazione dei segnali elettrici e la risoluzione di integrali trigonometrici.

La pietra miliare è la formula di sottrazione del coseno, ricavata per via metrica euclidea sulla circonferenza unitaria:

$$\cos(\alpha - \beta) = \cos\alpha \cos\beta + \sin\alpha \sin\beta$$

Da questa singola identità, applicando le proprietà di simmetria, parità e gli angoli associati, discendono a catena tutte le formule di addizione, duplicazione, bisezione, le formule parametriche razionali di Weierstrass e le formule di prostaferesi e Werner.

> **Insight:** Ogni famiglia di formule possiede una propria vocazione applicativa: la duplicazione permette di esprimere armoniche doppie; la bisezione riduce il grado quadratico; le formule parametriche trasformano qualsiasi funzione trigonometrica in una frazione algebrica razionale in t = tan(α/2).

## Dimostrazione: Formule di Addizione e Sottrazione

### 1. Distanza euclidea tra due punti sulla circonferenza unitaria
$$d^2 = (\cos\alpha - \cos\beta)^2 + (\sin\alpha - \sin\beta)^2 = 2 - 2(\cos\alpha \cos\beta + \sin\alpha \sin\beta)$$
> **Insight:** Si considerano i punti P(cos α, sin α) e Q(cos β, sin β): la loro distanza al quadrato dipende unicamente dalla differenza angolare tra i due raggi vettori.

### 2. Rotazione rigida e formula fondamentale di sottrazione del coseno
$$d^2 = (\cos(\alpha - \beta) - 1)^2 + (\sin(\alpha - \beta) - 0)^2 = 2 - 2\cos(\alpha - \beta) \implies \cos(\alpha - \beta) = \cos\alpha \cos\beta + \sin\alpha \sin\beta$$
> **Insight:** Ruotando rigidamente l'arco affinche il secondo punto coincida con (1, 0), la distanza tra i punti si conserva per invarianza delle isometrie euclidee.

### 3. Angolo opposto e formula di addizione del coseno
$$\cos(\alpha + \beta) = \cos(\alpha - (-\beta)) = \cos\alpha \cos(-\beta) + \sin\alpha \sin(-\beta) = \cos\alpha \cos\beta - \sin\alpha \sin\beta$$
> **Insight:** Si sfrutta la parita del coseno (cos(-β) = cos β) e la disparita del seno (sin(-β) = -sin β).

### 4. Angoli complementari e formule di addizione del seno
$$\sin(\alpha \pm \beta) = \cos\left(\frac{\pi}{2} - (\alpha \pm \beta)\right) = \sin\alpha \cos\beta \pm \cos\alpha \sin\beta$$
> **Insight:** Il passaggio tra seno e coseno avviene mediante l'identita degli angoli complementari.

### 5. Corollario: Formule di Addizione e Sottrazione della Tangente
$$\tan(\alpha \pm \beta) = \frac{\sin(\alpha \pm \beta)}{\cos(\alpha \pm \beta)} = \frac{\tan\alpha \pm \tan\beta}{1 \mp \tan\alpha \tan\beta}$$
> **Insight:** Si divide numeratore e denominatore per cos(α)cos(β), fornendo una formula razionale nelle sole tangenti degli angoli componenti.

## Dimostrazione: Formule di Duplicazione

### 1. Sovrapposizione angolare nelle formule di addizione (β = α)
$$\sin(2\alpha) = \sin(\alpha + \alpha) = \sin\alpha \cos\alpha + \cos\alpha \sin\alpha = 2\sin\alpha \cos\alpha$$
> **Insight:** Ponendo β = α nella formula di addizione del seno, i due termini si sommano direttamente generando il doppio prodotto.

### 2. Sviluppo del coseno dell'angolo doppio
$$\cos(2\alpha) = \cos(\alpha + \alpha) = \cos\alpha \cos\alpha - \sin\alpha \sin\alpha = \cos^2\alpha - \sin^2\alpha$$
> **Insight:** Il coseno dell'angolo doppio emerge naturalmente come differenza dei quadrati del coseno e del seno.

### 3. Riformulazione mediante la relazione fondamentale della goniometria
$$\cos(2\alpha) = 2\cos^2\alpha - 1 = 1 - 2\sin^2\alpha$$
> **Insight:** Sostituendo sin^2(α) = 1 - cos^2(α) o viceversa, il coseno doppio si esprime in funzione di una sola grandezza quadratica.

### 4. Corollario: Duplicazione della Tangente e Abbassamento del Grado
$$\tan(2\alpha) = \frac{2\tan\alpha}{1 - \tan^2\alpha}, \qquad \sin^2\alpha = \frac{1 - \cos(2\alpha)}{2}, \qquad \cos^2\alpha = \frac{1 + \cos(2\alpha)}{2}$$
> **Insight:** Le formule per sin^2(α) e cos^2(α) sono il fondamento per il calcolo di integrali trigonometrici indefiniti e per la potenza attiva nei circuiti in corrente alternata.

## Dimostrazione: Formule di Bisezione

### 1. Inversione della formula del coseno doppio per l'angolo metà
$$\cos(2\theta) = 1 - 2\sin^2\theta \implies \text{Ponendo } \theta = \frac{\alpha}{2}, \quad \cos\alpha = 1 - 2\sin^2\left(\frac{\alpha}{2}\right)$$
> **Insight:** Il punto di partenza e la formula di duplicazione del coseno in cui si esegue il cambio di scala temporale/angolare.

### 2. Isolamento del seno dell'angolo metà
$$2\sin^2\left(\frac{\alpha}{2}\right) = 1 - \cos\alpha \implies \sin\left(\frac{\alpha}{2}\right) = \pm \sqrt{\frac{1 - \cos\alpha}{2}}$$
> **Insight:** L'estrazione di radice quadrata richiede l'introduzione del doppio segno ±, determinato dal quadrante di appartenenza di α/2.

### 3. Isolamento del coseno dell'angolo metà
$$\cos\alpha = 2\cos^2\left(\frac{\alpha}{2}\right) - 1 \implies \cos\left(\frac{\alpha}{2}\right) = \pm \sqrt{\frac{1 + \cos\alpha}{2}}$$
> **Insight:** Analoga inversione condotta sulla forma pura in coseno.

### 4. Rapporto per la tangente e forme razionali prive di radicale
$$\tan\left(\frac{\alpha}{2}\right) = \pm \sqrt{\frac{1 - \cos\alpha}{1 + \cos\alpha}} = \frac{\sin\alpha}{1 + \cos\alpha} = \frac{1 - \cos\alpha}{\sin\alpha}$$
> **Insight:** Moltiplicando numeratore e denominatore per il coniugato sotto radice si eliminano i radicali, ottenendo espressioni razionali eleganti e sicure per il calcolo numerico.

### 5. Corollario: Determinazione Univoca del Segno nei Quadranti
$$\operatorname{sgn}\left(\sin\frac{\alpha}{2}\right) = \operatorname{sgn}\left(\sin\theta\right), \quad \operatorname{sgn}\left(\cos\frac{\alpha}{2}\right) = \operatorname{sgn}\left(\cos\theta\right) \quad \left(\theta = \frac{\alpha}{2}\right)$$
> **Insight:** Il segno algebrico delle formule di bisezione non dipende dal quadrante di α, bensi rigorosamente dal quadrante in cui cade l'angolo meta α/2.

## Dimostrazione: Formule Parametriche Razionali (t = tan(α/2))

### 1. Definizione della variabile ausiliaria t
$$t = \tan\left(\frac{\alpha}{2}\right) \quad \text{con } \alpha \neq \pi + 2k\pi$$
> **Insight:** Si introduce il parametro universale t che esprime la tangente dell'angolo dimezzato.

### 2. Riscrittura di sen(α) mediante duplicazione e divisione per l'identità fondamentale
$$\sin\alpha = 2\sin\left(\frac{\alpha}{2}\right)\cos\left(\frac{\alpha}{2}\right) = \frac{2\sin\left(\frac{\alpha}{2}\right)\cos\left(\frac{\alpha}{2}\right)}{\cos^2\left(\frac{\alpha}{2}\right) + \sin^2\left(\frac{\alpha}{2}\right)} = \frac{2\tan\left(\frac{\alpha}{2}\right)}{1 + \tan^2\left(\frac{\alpha}{2}\right)} = \frac{2t}{1 + t^2}$$
> **Insight:** La divisione di numeratore e denominatore per cos^2(α/2) converte immediatamente l'espressione in una funzione razionale in t.

### 3. Riscrittura di cos(α) in funzione di t
$$\cos\alpha = \frac{\cos^2\left(\frac{\alpha}{2}\right) - \sin^2\left(\frac{\alpha}{2}\right)}{\cos^2\left(\frac{\alpha}{2}\right) + \sin^2\left(\frac{\alpha}{2}\right)} = \frac{1 - \tan^2\left(\frac{\alpha}{2}\right)}{1 + \tan^2\left(\frac{\alpha}{2}\right)} = \frac{1 - t^2}{1 + t^2}$$
> **Insight:** Il coseno si esprime come quoziente tra (1 - t^2) e (1 + t^2).

### 4. Corollario: Sostituzione Razionale Universale di Weierstrass negli Integrali
$$\sin\alpha = \frac{2t}{1+t^2}, \quad \cos\alpha = \frac{1-t^2}{1+t^2}, \quad \tan\alpha = \frac{2t}{1-t^2}, \quad d\alpha = \frac{2}{1+t^2}dt$$
> **Insight:** Trasforma qualsiasi integrale di funzioni razionali in seno e coseno in un integrale puramente algebrico razionale in t, risolvibile con il metodo dei fratti semplici.

## Dimostrazione: Formule di Prostaferesi e Werner

### 1. Somma e differenza delle formule di addizione (Formule di Werner)
$$\cos\alpha \cos\beta = \frac{1}{2}\left[\cos(\alpha + \beta) + \cos(\alpha - \beta)\right], \quad \sin\alpha \sin\beta = \frac{1}{2}\left[\cos(\alpha - \beta) - \cos(\alpha + \beta)\right]$$
> **Insight:** Le formule di Werner consentono di trasformare prodotti di funzioni trigonometriche in somme algebriche lineari, facilitando l'integrazione immediata.

### 2. Cambio di variabili per la trasformazione inversa da somme a prodotti
$$p = \alpha + \beta, \quad q = \alpha - \beta \implies \alpha = \frac{p + q}{2}, \quad \beta = \frac{p - q}{2}$$
> **Insight:** Il sistema lineare invertito permette di passare direttamente dalla somma di due angoli p e q alle formule di prostaferesi.

### 3. Sostituzione e deduzione delle formule di Prostaferesi
$$\sin p + \sin q = 2\sin\left(\frac{p+q}{2}\right)\cos\left(\frac{p-q}{2}\right), \quad \cos p + \cos q = 2\cos\left(\frac{p+q}{2}\right)\cos\left(\frac{p-q}{2}\right)$$
> **Insight:** Le formule di prostaferesi trasformano somme e differenze di seni e coseni in un unico prodotto di fattori.

### 4. Corollario: Fenomeno dei Battimenti e Modulazione di Frequenza
$$\cos(\omega_1 t) + \cos(\omega_2 t) = 2\cos\left(\frac{\omega_1 - \omega_2}{2}t\right)\cos\left(\frac{\omega_1 + \omega_2}{2}t\right)$$
> **Insight:** Spiega l'insorgere dei battimenti acustici e la modulazione di ampiezza nei circuiti a radiofrequenza quando due onde di frequenza vicina interferiscono.
