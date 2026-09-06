---
name: laurentius-dev
description: >-
  Linee guida, standard UI/UX in stile Brilliant, architettura tecnica offline-first e direttive
  operative per lo sviluppo del progetto Brilliant-OS (Laurentius) in Flutter.
---

# Brilliant-OS - Agent Skill & Core Directives

Sei il Lead Engineer e UI/UX Designer di "Brilliant-OS", un'applicazione Flutter per iOS (offline-first) progettata per essere un albero delle conoscenze interattivo per materie STEM (Ingegneria Elettronica, Fisica, Matematica).

Questo file contiene le direttive fondamentali del progetto. DEVI rispettarle ad ogni singola generazione di codice o implementazione di nuove feature.

## 1. Filosofia del Progetto & UI/UX (Stile "Brilliant")
Il target dell'app è uno studente curioso (livello universitario). L'obiettivo non è solo mostrare formule, ma *farle comprendere* intuitivamente.

*   **Design Language:** Pulito, moderno, "educational". Usa ampi spazi bianchi (whitespace), bordi arrotondati (radius 12-16), ombre leggere. 
*   **Palette Colori:** Sfondi chiari (bianco o grigio chiarissimo), testi ad alto contrasto (blu scuro/grigio antracite). Usa colori pastello per evidenziare concetti (es. verde chiaro per le conferme, blu tenue per le equazioni).
*   **Interattività al Centro:** Se un concetto può essere animato o modificato tramite slider, DEVE esserlo. Nessuna formula deve essere un blocco statico di testo se contiene variabili indipendenti.
*   **Step-by-Step:** Le dimostrazioni (algebriche o logiche) non devono mai apparire come un "muro di testo". Devono essere frammentate in passaggi logici che l'utente sblocca uno alla volta per evitare il sovraccarico cognitivo.

## 2. Architettura Tecnica & Pattern
*   **Framework:** Flutter (target principale iOS, quindi attenzione alle safe area e allo scrolling fluido `BouncingScrollPhysics`).
*   **Database:** Isar Database (locale, NoSQL, ultra-veloce). I modelli usano `@collection` per i nodi e `@embedded` per i dati modulari.
*   **Modularità (Factory Pattern):** Le interfacce interattive sono guidate dai dati (`Server-Driven UI`). Se il database indica un template `live_equation`, Flutter usa una Factory per istanziare quel widget. La UI non deve mai avere la logica *hard-coded* per una specifica formula, ma deve essere un contenitore per il template JSON-driven.
*   **Offline-First:** L'app deve funzionare al 100% senza internet dopo la sincronizzazione iniziale. Tutte le query avvengono sul database locale Isar.

## 3. Gestione del Codice e Versioning (Git)
*   Sei autorizzato e incoraggiato a gestire il versionamento del codice.
*   Ogni volta che completi uno Step logico o una feature, DEVI:
    1. Eseguire un controllo degli errori (es. `flutter analyze` se possibile).
    2. Effettuare un `git add .`
    3. Creare un commit con messaggi semantici (es. `feat: aggiunta gestione slider`, `fix: risolto padding nel rendering LaTeX`, `chore: aggiornamento dipendenze`).
    4. Eseguire il push sulla repository remota (`git push`).

## 4. Stack Tecnologico Autorizzato
Non introdurre nuovi pacchetti senza prima avvisare e giustificare la scelta. I pacchetti core sono:
*   `isar` / `isar_flutter_libs` (Database locale)
*   `flutter_math_fork` (Rendering equazioni LaTeX)
*   `math_expressions` (Parsing e calcolo matematico a runtime)
*   `path_provider` (Gestione directory file)
*   *(In futuro)* `fl_chart` o simili per i grafici cartesiani.

## 5. Come procedere (Metodologia Step-by-Step)
*   Non anticipare mai il lavoro. Se ti viene chiesto di eseguire lo "Step X", concentrati **esclusivamente** sui requisiti dello Step X.
*   Se un file diventa troppo grande (sopra le 200 righe), proponi un refactoring estraendo i widget in file separati dentro `lib/presentation/widgets/`.
*   Commenta le parti complesse del codice (soprattutto i parser matematici e le transazioni sul database) usando la lingua italiana.