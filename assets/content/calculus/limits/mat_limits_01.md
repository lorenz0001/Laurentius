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

## Dimostrazione Logico-Algebrica

Consideriamo la verifica rigorosa del limite della funzione lineare $f(x) = 2x + 1$ nel punto di accumulazione $x_0 = 3$, con valore presunto $L = 7$.

### 1. Impostazione della disuguaglianza di tolleranza
$$|(2x + 1) - 7| < \varepsilon \iff |2x - 6| < \varepsilon$$
> **Insight:** Si impone che la distanza euclidea tra l'immagine della funzione f(x) e il valore presunto di limite L=7 sia rigidamente inferiore a ε.

### 2. Semplificazione algebrica ed estrazione del modulo
$$2|x - 3| < \varepsilon \iff |x - 3| < \frac{\varepsilon}{2}$$
> **Insight:** L'operazione isola la distanza |x - x₀| lungo l'asse delle ascisse mediante divisione per la pendenza m=2.

### 3. Determinazione esplicita del raggio di controllo delta
$$\delta(\varepsilon) = \frac{\varepsilon}{2} \implies 0 < |x - 3| < \delta \implies |f(x) - 7| < \varepsilon$$
> **Insight:** Il delta trovato dipende unicamente da epsilon e non da x, provando che il limite esiste ed è rigorosamente verificato.

### 4. Corollario: Teorema di Unicità del Limite e Definizione di Continuità
$$\lim_{x \to x_0} f(x) = L_1 \land \lim_{x \to x_0} f(x) = L_2 \implies |L_1 - L_2| \le |L_1 - f(x)| + |f(x) - L_2| < 2\varepsilon \implies L_1 = L_2$$
> **Insight:** Una funzione non può convergere a due valori distinti; se inoltre L coincide con f(x₀), la funzione è continua in x₀.
