---
id: chem_ph_01
title: "Chimica Fisica: Soluzioni Acido-Base e Calcolo del pH"
category: "Fisica"
subCategory: "Chimica Fisica"
prerequisites:
  - mat_log_01
interactive:
  template: live_equation
  unit: ""
  equations:
    - "-log(c) / 2.302585"
  parameters:
    - variable: c
      label: "[H+] Concentrazione Molare"
      unit: "mol/L"
      min: 0.0000001
      max: 0.1
      default: 0.001
      step: 0.001
---

### La Scala del pH: Domare i Grandi Numeri

La concentrazione di ioni idronio $[\text{H}_3\text{O}^+]$ in una soluzione acquosa può variare enormemente:
- Da $1$ mole per litro in un acido molto forte
- Fino a $0.00000000000001$ ($10^{-14}$) moli per litro in una base fortissima.

Lavorare con quattordici zeri decimali è poco pratico. Per questo si utilizza la scala logaritmica del **pH**, che comprime questi ordini di grandezza in un comodo intervallo da $0$ a $14$:

$$\text{pH} = -\log_{10}([\text{H}_3\text{O}^+])$$

> **Insight:** **Guida Rapida al pH:**
> - $\text{pH} = 7$: Neutro (acqua pura a 25°C)
> - $\text{pH} < 7$: Acido (succo di limone $\approx 2.4$, caffè $\approx 5$)
> - $\text{pH} > 7$: Basico (sapone $\approx 9$, ammoniaca $\approx 11.5$)
> Ogni salto di 1 unità di pH indica una concentrazione dieci volte superiore o inferiore!

## Dimostrazione: Autoionizzazione dell'Acqua e Definizione della Scala di pH

### 1. Equilibrio chimico di autoprotolisi dell'acqua liquida
$$2\text{H}_2\text{O}_{(l)} \rightleftharpoons \text{H}_3\text{O}^+_{(aq)} + \text{OH}^-_{(aq)}$$
> **Insight:** Due molecole di acqua pura possono scambiarsi un protone secondo la teoria acido-base di Brønsted-Lowry, generando ioni idronio e idrossido.

### 2. Prodotto ionico dell'acqua a temperatura standard di 25°C
$$K_w = [\text{H}_3\text{O}^+] \cdot [\text{OH}^-] = 1.0 \times 10^{-14} \text{ M}^2$$
> **Insight:** Poiché l'attività del solvente acquoso è convenzionalmente unitaria nei sistemi diluiti, la costante termodinamica si riduce al prodotto ionico $K_w$.

### 3. Definizione dell'operatore cologaritmo p di Sørensen
$$\text{pH} = -\log_{10}([\text{H}_3\text{O}^+]), \quad \text{pOH} = -\log_{10}([\text{OH}^-])$$
> **Insight:** L'operatore logaritmico inverso $p = -\log_{10}$ mappa intervalli di concentrazione sterminati su una scala maneggevole di numeri compresi fra 0 e 14.

### 4. Formula di inversione esponenziale per le concentrazioni molari
$$[\text{H}_3\text{O}^+] = 10^{-\text{pH}}, \quad [\text{OH}^-] = 10^{-\text{pOH}}$$
> **Insight:** Ogni decremento di una singola unità di pH corrisponde a un incremento decuplo ($10\times$) della concentrazione degli ioni idronio in soluzione.

## Dimostrazione: Corollario - Relazione Fondamentale di Conservazione pH + pOH = 14

### 1. Ipotesi iniziale dal teorema del prodotto ionico
$$[\text{H}_3\text{O}^+] \cdot [\text{OH}^-] = K_w = 1.0 \times 10^{-14}$$
> **Insight:** In qualsiasi soluzione acquosa diluita all'equilibrio termodinamico a 25°C, il vincolo sul prodotto ionico deve restare rigorosamente costante.

### 2. Applicazione dell'operatore cologaritmo decimale ad ambo i membri
$$-\log_{10}\left([\text{H}_3\text{O}^+] \cdot [\text{OH}^-]\right) = -\log_{10}(K_w) = -\log_{10}(1.0 \times 10^{-14})$$
> **Insight:** L'operazione preserva l'uguaglianza trasformando la relazione moltiplicativa tra le concentrazioni in una relazione additiva.

### 3. Espansione del logaritmo del prodotto e valutazione numerica
$$-\left(\log_{10}[\text{H}_3\text{O}^+] + \log_{10}[\text{OH}^-]\right) = -\log_{10}(10^{-14}) = -(-14) = 14.00$$
> **Insight:** Per le proprietà elementari dei logaritmi, il logaritmo di un prodotto è la somma dei logaritmi dei singoli fattori.

### 4. Distribuzione del segno e formulazione duale del pH
$$\text{pH} + \text{pOH} = 14.00 \iff \text{pH} = 14.00 - \text{pOH}$$
> **Insight:** Questa equazione fondamentale di conservazione consente di determinare immediatamente il pH di qualsiasi base forte a partire dalla concentrazione di ioni ossidrile.

## Dimostrazione: Corollario - Neutralità Elettrolitica e pH dell'Acqua Pura

### 1. Ipotesi di elettroneutralità e dissociazione stechiometrica
$$2\text{H}_2\text{O} \rightleftharpoons \text{H}_3\text{O}^+ + \text{OH}^- \implies [\text{H}_3\text{O}^+] = [\text{OH}^-] \equiv x$$
> **Insight:** In acqua pura esente da soluti acidi o basici, per ogni ione idronio formato deve necessariamente generarsi un corrispondente ione idrossido.

### 2. Sostituzione nell'equazione del prodotto ionico
$$x \cdot x = x^2 = K_w = 1.0 \times 10^{-14}$$
> **Insight:** La condizione di equità delle concentrazioni trasforma il prodotto ionico in una semplice equazione quadratica pura in una sola incognita.

### 3. Risoluzione algebrica per estrazione di radice quadrata positiva
$$x = \sqrt{1.0 \times 10^{-14}} = (10^{-14})^{1/2} = 1.0 \times 10^{-7} \text{ M}$$
> **Insight:** In condizioni di neutralità a 25°C, esattamente una molecola d'acqua ogni dieci milioni si trova nello stato dissociato.

### 4. Calcolo rigoroso del pH del punto di neutralità
$$\text{pH}_{\text{neutro}} = -\log_{10}(1.0 \times 10^{-7}) = -\log_{10}(10^{-7}) = -(-7) = 7.00$$
> **Insight:** Il valore convenzionale di pH 7 per l'acqua neutra discende direttamente dal logaritmo negativo della radice quadrata del prodotto ionico $K_w$.
