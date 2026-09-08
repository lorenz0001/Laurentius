---
id: mat_limits_01
title: "Definizione Rigorosa di Limite e Continuità (Epsilon-Delta)"
category: "Matematica"
subCategory: "Limiti e Continuità"
prerequisites:
  - mat_frac_01
  - mat_parabola_01
interactive:
  template: function_graph
  unit: ""
  equations:
    - "2 * x + 1"
  parameters:
    - variable: L
      label: "Valore Limite Atteso (L)"
      unit: ""
      min: 1.0
      max: 10.0
      default: 7.0
      step: 1.0
    - variable: eps
      label: "Tolleranza Epsilon (ε)"
      unit: ""
      min: 0.1
      max: 2.0
      default: 0.5
      step: 0.1
    - variable: x0
      label: "Punto di Accumulazione (x₀)"
      unit: ""
      min: 0.0
      max: 5.0
      default: 3.0
      step: 0.5
---

### Il Concetto di Limite e la Formalizzazione di Cauchy-Weierstrass

Nella matematica pre-calcolo e nelle descrizioni intuitive elementari, si afferma spesso che il limite di una funzione $f(x)$ per $x$ che tende a $x_0$ rappresenta il valore $L$ a cui la funzione *"si avvicina indefinitamente"*. Tuttavia, tale descrizione cinetica risulta inadeguata quando si affrontano singolarità rimovibili, oscillazioni patologiche o discontinuità essenziali.

La formalizzazione rigorosa introdotta da Cauchy e perfezionata da Weierstrass trasforma il concetto di avvicinamento continuo in una precisa relazione quantitativa governata da due parametri reali positivi: la **tolleranza verticale** $\varepsilon$ e il **raggio di controllo orizzontale** $\delta$.

$$\lim_{x \to x_0} f(x) = L \iff \forall \varepsilon > 0, \; \exists \delta > 0 : 0 < |x - x_0| < \delta \implies |f(x) - L| < \varepsilon$$

> **Insight:** Il limite è una sfida: scelto un intorno arbitrariamente stretto $(L - \varepsilon, L + \varepsilon)$ sull'asse delle ordinate, esiste sempre un intorno forato $(x_0 - \delta, x_0 + \delta) \setminus \{x_0\}$ sull'asse delle ascisse le cui immagini cadono interamente dentro la fascia di tolleranza richiesta.

### Significato Geometrico

Sul piano cartesiano, la condizione $\varepsilon$-$\delta$ stabilisce che il grafico della funzione $y = f(x)$ attraversa interamente la finestra rettangolare aperta $(x_0 - \delta, x_0 + \delta) \times (L - \varepsilon, L + \varepsilon)$ entrando dal lato verticale sinistro ed uscendo dal lato verticale destro, senza mai violare le barriere orizzontali $y = L \pm \varepsilon$.

Il punto $(x_0, f(x_0))$ può persino non appartenere al grafico o essere dislocato altrove: il limite esamina esclusivamente il comportamento nei punti adiacenti a $x_0$ ($0 < |x - x_0|$).

## Dimostrazione: Verifica del Limite Epsilon-Delta

Consideriamo la verifica rigorosa del limite della funzione lineare $f(x) = 2x + 1$ nel punto di accumulazione $x_0 = 3$, con valore presunto $L = 7$.

### 1. Impostazione della disuguaglianza di tolleranza
$$|(2x + 1) - 7| < \varepsilon \iff |2x - 6| < \varepsilon$$
> **Insight:** Si impone che la distanza euclidea tra l'immagine della funzione f(x) e il valore presunto di limite L=7 sia rigidamente inferiore a ε per ogni epsilon positivo fissato.

### 2. Semplificazione algebrica ed estrazione del modulo
$$2|x - 3| < \varepsilon \iff |x - 3| < \frac{\varepsilon}{2}$$
> **Insight:** Raccogliendo a fattore comune il coefficiente angolare m=2 e dividendo ambo i membri, si isola la distanza euclidea |x - x₀| sull'asse delle ascisse.

### 3. Determinazione esplicita del raggio di controllo delta
$$\delta(\varepsilon) = \frac{\varepsilon}{2} \implies 0 < |x - 3| < \delta \implies |(2x+1) - 7| < \varepsilon$$
> **Insight:** Poiché il raggio delta trovato dipende esclusivamente da epsilon ed è strettamente positivo per ogni epsilon > 0, l'esistenza del limite L=7 è matematicamente dimostrata.

## Dimostrazione: Corollario - Teorema di Unicità del Limite

### 1. Ipotesi per assurdo e quantificazione della distanza
Sia data una funzione $f(x)$ avente per $x \to x_0$ due presunti limiti distinti $L_1$ e $L_2$ con $L_1 \neq L_2$. La loro distanza euclidea è strettamente positiva:
$$|L_1 - L_2| > 0 \implies \varepsilon \equiv \frac{|L_1 - L_2|}{2} > 0$$
> **Insight:** Fissare la tolleranza epsilon alla metà esatta della distanza reciproca tra i due valori limite separa rigidamente i rispettivi intorni sferici, rendendoli completamente disgiunti.

### 2. Esistenza dei raggi di controllo e intorno comune
Applicando la definizione di limite separatamente a $L_1$ e $L_2$ con la tolleranza $\varepsilon$ scelta, esistono $\delta_1 > 0$ e $\delta_2 > 0$ tali che:
$$0 < |x - x_0| < \delta_1 \implies |f(x) - L_1| < \varepsilon, \quad 0 < |x - x_0| < \delta_2 \implies |f(x) - L_2| < \varepsilon$$
Ponendo $\delta = \min(\delta_1, \delta_2) > 0$, per ogni $x$ nell'intorno forato $0 < |x - x_0| < \delta$ entrambe le disuguaglianze valgono contemporaneamente.
> **Insight:** L'intersezione di due intorni aperti di x₀ produce un intorno aperto non vuoto in cui la funzione deve soddisfare simultaneamente entrambi i vincoli di prossimità.

### 3. Valutazione della distanza tramite disuguaglianza triangolare
Esprimiamo la distanza costante $|L_1 - L_2|$ inserendo artificialmente il termine intermedio $f(x)$ e applicando la disuguaglianza triangolare $|a + b| \le |a| + |b|$:
$$|L_1 - L_2| = |(L_1 - f(x)) + (f(x) - L_2)| \le |L_1 - f(x)| + |f(x) - L_2|$$
> **Insight:** La disuguaglianza triangolare assicura che la distanza euclidea diretta tra i due punti non può superare la somma delle distanze passanti per il valore transitorio f(x).

### 4. Contraddizione algebrica e deduzione dell'unicità
Sostituendo le maggiorazioni delle ipotesi valide nell'intorno comune $0 < |x - x_0| < \delta$:
$$|L_1 - L_2| < \varepsilon + \varepsilon = 2\varepsilon = 2 \left(\frac{|L_1 - L_2|}{2}\right) = |L_1 - L_2|$$
L'assunto $L_1 \neq L_2$ conduce alla contraddizione stretta $|L_1 - L_2| < |L_1 - L_2|$, logicamente assurda in $\mathbb{R}$. Ne consegue necessariamente:
$$L_1 = L_2$$
> **Insight:** Corollario fondamentale: se il limite di una funzione in un punto esiste, esso è unico e ben determinato.

## Dimostrazione: Corollario - Teorema della Permanenza del Segno

### 1. Ipotesi di limite strettamente positivo
Sia $\lim_{x \to x_0} f(x) = L$ con $L > 0$. Scegliamo come raggio di tolleranza verticale:
$$\varepsilon = \frac{L}{2} > 0$$
> **Insight:** Scegliendo epsilon pari alla metà del valore limite L, la fascia inferiore di tolleranza L - epsilon rimane strettamente sopra lo zero dell'asse cartesiano.

### 2. Esistenza dell'intorno e scomposizione del valore assoluto
Dalla definizione di limite esiste $\delta > 0$ tale che per ogni $0 < |x - x_0| < \delta$:
$$|f(x) - L| < \varepsilon \iff -\varepsilon < f(x) - L < \varepsilon$$
> **Insight:** La disuguaglianza modulare si scompatta nella doppia disuguaglianza lineare che delimita superiormente e inferiormente il valore assunto da f(x).

### 3. Isolamento della funzione e minorazione positiva
Sommando $L$ a tutti i membri della doppia disuguaglianza e sostituendo $\varepsilon = L/2$:
$$L - \frac{L}{2} < f(x) < L + \frac{L}{2} \iff \frac{L}{2} < f(x) < \frac{3L}{2}$$
> **Insight:** Poiché L > 0, anche la quantità minorante L/2 è strettamente positiva, vincolando f(x) a valori positivi.

### 4. Conclusione sulla permanenza del segno
Poiché per ogni $x$ soddisfacente $0 < |x - x_0| < \delta$ si ha $f(x) > \frac{L}{2} > 0$:
$$\lim_{x \to x_0} f(x) = L > 0 \implies \exists \delta > 0 : f(x) > 0 \quad \forall x \in (x_0 - \delta, x_0 + \delta) \setminus \{x_0\}$$
> **Insight:** Corollario: se una funzione converge a un limite strettamente positivo, esiste un intero intorno del punto in cui la funzione conserva rigidamente segno positivo (e analogamente per limite negativo L < 0).
