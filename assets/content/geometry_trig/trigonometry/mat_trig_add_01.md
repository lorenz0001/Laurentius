---
id: mat_trig_add_01
title: "Formule Goniometriche: Addizione, Duplicazione e Bisezione"
category: "Matematica"
subCategory: "Goniometria e Trigonometria"
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

## Dimostrazione: Corollario - Formule di Addizione e Sottrazione della Tangente

### 1. Definizione della tangente come quoziente tra seno e coseno
Esprimiamo la tangente della somma o differenza mediante il rapporto goniometrico fondamentale:
$$\tan(\alpha \pm \beta) = \frac{\sin(\alpha \pm \beta)}{\cos(\alpha \pm \beta)}$$
> **Insight:** Vogliamo ottenere un'espressione dipendente unicamente dalle tangenti dei singoli angoli.

### 2. Espansione mediante formule di addizione e sottrazione
Sostituendo gli sviluppi per seno e coseno:
$$\tan(\alpha \pm \beta) = \frac{\sin\alpha\cos\beta \pm \cos\alpha\sin\beta}{\cos\alpha\cos\beta \mp \sin\alpha\sin\beta}$$
> **Insight:** Numeratore e denominatore sono costituiti da somme di prodotti di funzioni armoniche.

### 3. Divisione per il prodotto dei coseni
Dividendo numeratore e denominatore per $\cos\alpha \cos\beta \neq 0$:
$$\tan(\alpha \pm \beta) = \frac{\frac{\sin\alpha\cos\beta}{\cos\alpha\cos\beta} \pm \frac{\cos\alpha\sin\beta}{\cos\alpha\cos\beta}}{\frac{\cos\alpha\cos\beta}{\cos\alpha\cos\beta} \mp \frac{\sin\alpha\sin\beta}{\cos\alpha\cos\beta}}$$
> **Insight:** La frazione principale si normalizza facendo comparire il termine 1 a denominatore.

### 4. Corollario: Formule Razionali per la Tangente della Somma
Semplificando i fattori identici ed applicando la definizione $\tan = \sin/\cos$:
$$\tan(\alpha \pm \beta) = \frac{\tan\alpha \pm \tan\beta}{1 \mp \tan\alpha \tan\beta}$$
> **Insight:** Fornisce la legge di composizione per le pendenze di rette nel piano cartesiano e la deflessione angolare.

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

## Dimostrazione: Corollario - Duplicazione della Tangente e Abbassamento del Grado

### 1. Duplicazione della tangente per sovrapposizione
Ponendo $\beta = \alpha$ nella formula di addizione della tangente:
$$\tan(2\alpha) = \frac{\tan\alpha + \tan\alpha}{1 - \tan\alpha\tan\alpha} = \frac{2\tan\alpha}{1 - \tan^2\alpha}$$
> **Insight:** Esprime la tangente dell'angolo doppio come frazione razionale nella tangente semplice.

### 2. Inversione algebrica per il seno quadro
Dalla formula $\cos(2\alpha) = 1 - 2\sin^2\alpha$, isoliamo il termine quadratico:
$$2\sin^2\alpha = 1 - \cos(2\alpha) \implies \sin^2\alpha = \frac{1 - \cos(2\alpha)}{2}$$
> **Insight:** Dimezza l'esponente quadratico al prezzo di raddoppiare la frequenza dell'argomento.

### 3. Inversione algebrica per il coseno quadro
Dalla formula $\cos(2\alpha) = 2\cos^2\alpha - 1$, isoliamo il termine in coseno:
$$2\cos^2\alpha = 1 + \cos(2\alpha) \implies \cos^2\alpha = \frac{1 + \cos(2\alpha)}{2}$$
> **Insight:** Consente la linearizzazione esatta dei quadrati trigonometrici.

### 4. Corollario: Formule di Abbassamento del Grado
Le formule di linearizzazione quadratica e duplicazione risultano:
$$\sin^2\alpha = \frac{1 - \cos(2\alpha)}{2}, \quad \cos^2\alpha = \frac{1 + \cos(2\alpha)}{2}, \quad \tan(2\alpha) = \frac{2\tan\alpha}{1 - \tan^2\alpha}$$
> **Insight:** Strumento fondamentale per l'integrazione indefinita di funzioni trigonometriche e il calcolo della potenza attiva in corrente alternata.

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

## Dimostrazione: Corollario - Determinazione Univoca del Segno nei Quadranti

### 1. Ipotesi dalle soluzioni con doppio segno
Le formule di bisezione contengono il simbolo di ambiguità algebrica $\pm$:
$$\sin\left(\frac{\alpha}{2}\right) = \pm \sqrt{\frac{1 - \cos\alpha}{2}}, \quad \cos\left(\frac{\alpha}{2}\right) = \pm \sqrt{\frac{1 + \cos\alpha}{2}}$$
> **Insight:** Vogliamo stabilire la regola geometrica univoca per la scelta del segno corretto.

### 2. Mappatura angolare tra l'angolo intero e l'angolo metà
Dato $\alpha \in [0, 2\pi)$, l'angolo metà $\theta = \frac{\alpha}{2}$ varia nell'intervallo $[0, \pi)$:
$$0 \le \alpha < 2\pi \implies 0 \le \frac{\alpha}{2} < \pi$$
> **Insight:** L'angolo metà appartiene sempre al primo o al secondo quadrante goniometrico.

### 3. Valutazione dei segni nei quadranti di destinazione
Nel semipiano superiore ($0 \le \theta < \pi$), $\sin(\theta) \ge 0$ è sempre positivo o nullo; il coseno è positivo nel primo quadrante e negativo nel secondo:
$$\begin{cases} 0 < \frac{\alpha}{2} < \frac{\pi}{2} \implies \sin\frac{\alpha}{2} > 0, \; \cos\frac{\alpha}{2} > 0 \\ \frac{\pi}{2} < \frac{\alpha}{2} < \pi \implies \sin\frac{\alpha}{2} > 0, \; \cos\frac{\alpha}{2} < 0 \end{cases}$$
> **Insight:** Il seno dell'angolo metà è sempre non negativo per angoli compresi nel primo giro ordinario.

### 4. Corollario: Regola dei Segni di Bisezione
Il segno algebrico è fissato rigorosamente ed esclusivamente dal quadrante dell'angolo metà $\alpha/2$:
$$\operatorname{sgn}\left(\sin\frac{\alpha}{2}\right) = \operatorname{sgn}\left(\sin\theta\right), \quad \operatorname{sgn}\left(\cos\frac{\alpha}{2}\right) = \operatorname{sgn}\left(\cos\theta\right) \quad \left(\theta = \frac{\alpha}{2}\right)$$
> **Insight:** Il segno non dipende dal quadrante di α, bensì rigorosamente dal quadrante in cui cade l'angolo dimezzato α/2.

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

## Dimostrazione: Corollario - Sostituzione Razionale Universale di Weierstrass negli Integrali

### 1. Inversione analitica della sostituzione parametrica
Consideriamo la relazione tra l'angolo $\alpha$ e la variabile ausiliaria $t$:
$$t = \tan\left(\frac{\alpha}{2}\right) \iff \frac{\alpha}{2} = \arctan(t) \iff \alpha = 2\arctan(t)$$
> **Insight:** Esprime la variabile angolare come funzione continua dell'argomento razionale t.

### 2. Differenziazione per il calcolo del differenziale dα
Differenziando ambo i membri rispetto a $t$:
$$d\alpha = \frac{d}{dt}\left[2\arctan(t)\right] dt = 2 \cdot \frac{1}{1 + t^2} dt$$
> **Insight:** La derivata della funzione arcotangente genera una frazione razionale priva di radici.

### 3. Sostituzione congiunta delle funzioni circolari
Raccogliendo le formule parametriche razionali per $\sin\alpha, \cos\alpha, \tan\alpha$:
$$\sin\alpha = \frac{2t}{1+t^2}, \qquad \cos\alpha = \frac{1-t^2}{1+t^2}, \qquad \tan\alpha = \frac{2t}{1-t^2}$$
> **Insight:** Ogni grandezza trigonometrica elementare viene trascritta in forma puramente algebrica in t.

### 4. Corollario: Trasformazione Universale di Weierstrass
Qualsiasi espressione differenziale trigonometrica razionale si trasforma in un quoziente di polinomi:
$$\int R(\sin\alpha, \cos\alpha) \, d\alpha = \int R\left(\frac{2t}{1+t^2}, \frac{1-t^2}{1+t^2}\right) \frac{2}{1+t^2} \, dt$$
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

## Dimostrazione: Corollario - Fenomeno dei Battimenti e Modulazione di Frequenza

### 1. Sovrapposizione di onde a frequenze angolari vicine
Consideriamo la somma di due oscillazioni armoniche isofasiche di frequenze $\omega_1$ e $\omega_2$:
$$s(t) = \cos(\omega_1 t) + \cos(\omega_2 t)$$
> **Insight:** Modella l'interferenza temporale di due suoni o due segnali elettromagnetici a frequenze simili.

### 2. Applicazione della formula di prostaferesi
Ponendo $p = \omega_1 t$ e $q = \omega_2 t$ nella formula della somma tra due coseni:
$$\cos(\omega_1 t) + \cos(\omega_2 t) = 2\cos\left(\frac{\omega_1 t - \omega_2 t}{2}\right)\cos\left(\frac{\omega_1 t + \omega_2 t}{2}\right)$$
> **Insight:** Il segnale somma si scompone nel prodotto di due oscillazioni a frequenze ben distinte.

### 3. Separazione dell'inviluppo lento dalla portante rapida
Fattorizzando il tempo $t$:
$$s(t) = \underbrace{2\cos\left(\frac{\omega_1 - \omega_2}{2}t\right)}_{A(t) \text{ (inviluppo di battimento)}} \cdot \underbrace{\cos\left(\frac{\omega_1 + \omega_2}{2}t\right)}_{\text{oscillazione portante}}$$
> **Insight:** La semidifferenza genera una modulazione lenta dell'ampiezza, mentre la semisomma definisce la frequenza portante.

### 4. Corollario: Equazione dei Battimenti Acustici
L'intensità del segnale oscilla alla frequenza di battimento $f_{\text{beat}} = |f_1 - f_2|$:
$$\cos(\omega_1 t) + \cos(\omega_2 t) = 2\cos\left(\frac{\omega_1 - \omega_2}{2}t\right)\cos\left(\frac{\omega_1 + \omega_2}{2}t\right)$$
> **Insight:** Spiega l'insorgere dei battimenti acustici e la modulazione di ampiezza nei circuiti a radiofrequenza quando due onde di frequenza vicina interferiscono.
