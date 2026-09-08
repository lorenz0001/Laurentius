---
id: mat_quad_viete_01
title: "Relazioni di Viète, Scomposizione e Regola di Cartesio"
category: "Matematica"
subCategory: "Equazioni di Secondo Grado"
prerequisites:
  - mat_quad_eq_01
interactive:
  template: live_equation
  unit: ""
  equations:
    - "-b / a"
  parameters:
    - variable: a
      label: "Coeff. a"
      min: -5.0
      max: 5.0
      default: 1.0
      step: 0.5
    - variable: b
      label: "Coeff. b"
      min: -10.0
      max: 10.0
      default: -5.0
      step: 0.5
    - variable: c
      label: "Coeff. c"
      min: -10.0
      max: 10.0
      default: 6.0
      step: 0.5
---

### Relazioni tra Radici e Coefficienti: Viète, Fattorizzazione e Cartesio

Le celebri relazioni stabilite dal matematico francese François Viète collegano direttamente le soluzioni $x_1$ e $x_2$ di un'equazione di secondo grado $ax^2 + bx + c = 0$ ai suoi coefficienti, senza richiedere il calcolo esplicito della radice quadrata del discriminante:

$$s = x_1 + x_2 = -\frac{b}{a}, \qquad p = x_1 \cdot x_2 = \frac{c}{a}$$

Queste relazioni costituiscono lo strumento cardine per la scomposizione in fattori dei trinomi, la determinazione di due numeri nota la loro somma e il loro prodotto, e lo studio qualitativo dei segni delle soluzioni tramite la storica **Regola di Cartesio**.

> **Insight:** Se l'equazione è monica ($a = 1$), la somma delle radici è semplicemente l'opposto del coefficiente di primo grado ($-b$), mentre il prodotto coincide esattamente con il termine noto ($c$): $x^2 - sx + p = 0$.

## Dimostrazione: Formule di Viète (Somma e Prodotto delle Radici)

### 1. Calcolo esplicito della somma delle radici
$$x_1 + x_2 = \frac{-b - \sqrt{\Delta}}{2a} + \frac{-b + \sqrt{\Delta}}{2a} = \frac{-2b}{2a} = -\frac{b}{a}$$
> **Insight:** I termini irrazionali contenenti la radice di Delta hanno segni opposti e si cancellano perfettamente nell'addizione.

### 2. Calcolo algebrico del prodotto delle radici
$$x_1 \cdot x_2 = \frac{(-b - \sqrt{\Delta})(-b + \sqrt{\Delta})}{4a^2} = \frac{(-b)^2 - (\sqrt{\Delta})^2}{4a^2} = \frac{b^2 - (b^2 - 4ac)}{4a^2} = \frac{4ac}{4a^2} = \frac{c}{a}$$
> **Insight:** Il prodotto algebrico si sviluppa come differenza di quadrati, semplificando il fattore 4a a numeratore e denominatore.

## Dimostrazione: Corollario - Equazione Parametrica Ricostruita da Somma e Prodotto

### 1. Formulazione del polinomio fattorizzato monico con zeri x1 e x2
Consideriamo un'equazione quadratica avente come radici note $x_1$ e $x_2$:
$$(x - x_1)(x - x_2) = 0$$
> **Insight:** Per la legge di annullamento del prodotto, questa equazione ha come uniche soluzioni x = x1 e x = x2.

### 2. Sviluppo algebrico mediante proprietà distributiva
Eseguiamo la moltiplicazione termine a termine:
$$x^2 - x_1 x - x_2 x + x_1 x_2 = 0$$
> **Insight:** Emergono due termini lineari di primo grado e il prodotto costante finale.

### 3. Raccoglimento a fattor comune del termine lineare
Raccogliamo la variabile $x$ con segno negativo:
$$x^2 - (x_1 + x_2)x + (x_1 x_2) = 0$$
> **Insight:** La parentesi lineare isola esattamente la somma delle due radici.

### 4. Corollario: Equazione Parametrica Noti Somma e Prodotto
Sostituendo la somma $s = x_1 + x_2$ e il prodotto $p = x_1 \cdot x_2$:
$$x^2 - s x + p = 0$$
> **Insight:** Permette di ricostruire all'istante l'equazione quadratica conoscendo unicamente la somma e il prodotto di due numeri incogniti.

## Dimostrazione: Corollario - Scomposizione Lineare del Trinomio di Secondo Grado

### 1. Raccoglimento a fattor comune del primo coefficiente
Consideriamo il trinomio $ax^2 + bx + c$ con $a \neq 0$ e $\Delta \ge 0$:
$$ax^2 + bx + c = a\left(x^2 + \frac{b}{a}x + \frac{c}{a}\right)$$
> **Insight:** Si isola il coefficiente direttivo a trasformando la parentesi in un trinomio monico.

### 2. Sostituzione delle relazioni di Viète
Sostituendo $\frac{b}{a} = -(x_1 + x_2)$ e $\frac{c}{a} = x_1 x_2$:
$$ax^2 + bx + c = a\left(x^2 - (x_1 + x_2)x + x_1 x_2\right) = a\left(x^2 - x_1 x - x_2 x + x_1 x_2\right)$$
> **Insight:** Il trinomio viene espresso interamente in funzione delle due radici reali.

### 3. Raccoglimento parziale a fattor comune
Raggruppando a coppie i quattro termini interni:
$$x(x - x_1) - x_2(x - x_1) = (x - x_1)(x - x_2)$$
> **Insight:** Il binomio (x - x1) emerge come fattore comune evidente.

### 4. Corollario: Teorema di Scomposizione Lineare del Trinomio
Riassemblando con il coefficiente moltiplicativo $a$:
$$a x^2 + b x + c = a (x - x_1)(x - x_2) \quad (\text{se } \Delta \ge 0)$$
> **Insight:** Qualsiasi trinomio quadratico con discriminante non negativo si fattorizza nel prodotto del coefficiente a per i binomi lineari delle radici.

## Dimostrazione: Corollario - Somma dei Quadrati e dei Reciproci delle Radici

### 1. Espansione del quadrato della somma di Viète
Consideriamo il quadrato della somma $s = x_1 + x_2$:
$$s^2 = (x_1 + x_2)^2 = x_1^2 + 2 x_1 x_2 + x_2^2 = (x_1^2 + x_2^2) + 2p$$
> **Insight:** Lo sviluppo del quadrato di binomio connette la somma dei quadrati alla somma e al prodotto.

### 2. Isolamento algebrico della somma dei quadrati
Sottraendo $2p$ da entrambi i membri e sostituendo $s = -b/a, p = c/a$:
$$x_1^2 + x_2^2 = s^2 - 2p = \left(-\frac{b}{a}\right)^2 - 2\left(\frac{c}{a}\right) = \frac{b^2 - 2ac}{a^2}$$
> **Insight:** La somma dei quadrati delle radici è sempre calcolabile direttamente dai coefficienti del trinomio.

### 3. Somma dei reciproci tramite denominatore comune
Calcoliamo la somma dei reciproci delle due radici non nulle ($c \neq 0$):
$$\frac{1}{x_1} + \frac{1}{x_2} = \frac{x_2 + x_1}{x_1 x_2} = \frac{s}{p}$$
> **Insight:** Si riconduce il calcolo al semplice rapporto tra somma s e prodotto p.

### 4. Corollario: Formule Simmetriche Dirette
Sostituendo i rapporti dei coefficienti:
$$\frac{1}{x_1} + \frac{1}{x_2} = \frac{-b/a}{c/a} = -\frac{b}{c} \quad \land \quad x_1^2 + x_2^2 = \frac{b^2 - 2ac}{a^2}$$
> **Insight:** Permette di valutare proprietà geometriche e grandezze fisiche simmetriche senza estrarre esplicitamente le singole radici.

## Dimostrazione: Corollario - Teorema dei Segni di Cartesio per Equazioni di 2° Grado

### 1. Definizione di permanenza e variazione di segno
Analizziamo la successione ordinata dei segni dei tre coefficienti $(a, b, c)$:
$$\text{Permanenza: due segni consecutivi concordi } (+,+) \text{ o } (-,-); \quad \text{Variazione: due segni discordi } (+,-) \text{ o } (-,+)$$
> **Insight:** La regola analizza il cambio di segno tra coefficienti consecutivi nell'equazione ordinata.

### 2. Studio del segno del prodotto p = c / a
Poiché $p = x_1 \cdot x_2 = \frac{c}{a}$:
$$p > 0 \iff a \text{ e } c \text{ concordi} \implies x_1, x_2 \text{ concordi}; \quad p < 0 \iff a \text{ e } c \text{ discordi} \implies x_1, x_2 \text{ discordi}$$
> **Insight:** Il segno del termine noto c rispetto ad a fissa univocamente la concordanza o discordanza delle radici.

### 3. Studio del segno della somma s = -b / a
Se $p > 0$ (radici concordi):
$$\begin{cases} s = -\frac{b}{a} > 0 \implies x_1 > 0, \; x_2 > 0 \quad (\text{due variazioni nei coefficienti}) \\ s = -\frac{b}{a} < 0 \implies x_1 < 0, \; x_2 < 0 \quad (\text{due permanenze nei coefficienti}) \end{cases}$$
Se $p < 0$ (radici discordi), vi è una variazione e una permanenza: la radice di valore assoluto maggiore ha il segno della somma.
> **Insight:** La combinazione di somma e prodotto riflette esattamente l'alternanza dei segni nella terna (a, b, c).

### 4. Corollario: Enunciato della Regola di Cartesio
A ogni variazione corrisponde una radice reale positiva, e a ogni permanenza una radice reale negativa:
$$\text{Numero radici } (x > 0) = \text{Variazioni}; \qquad \text{Numero radici } (x < 0) = \text{Permanenze}$$
> **Insight:** Permette di dedurre a priori e con assoluta certezza i segni delle soluzioni reali prima ancora di intraprendere qualsiasi calcolo algebrico.
