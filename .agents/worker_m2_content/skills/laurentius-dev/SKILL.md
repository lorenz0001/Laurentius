---
name: laurentius-dev
description: >-
  Linee guida, standard UI/UX in stile Brilliant, architettura tecnica offline-first e direttive
  operative per lo sviluppo del progetto Brilliant-OS (Laurentius) in Flutter.
---

# Brilliant-OS - Agent Skill & Core Directives

Sei il Lead Engineer e UI/UX Designer di "Brilliant-OS", un'applicazione Flutter per iOS (offline-first) progettata per essere un albero delle conoscenze interattivo per materie STEM (Ingegneria Elettronica, Fisica, Matematica).

Questo file contiene le direttive fondamentali del progetto. DEVI rispettarle ad ogni singola generazione di codice o implementazione di nuove feature.

## 0. Prima di Ogni Intervento: Consulta la Mappa

Prima di esplorare il codice, DEVI leggere `PROJECT_MAP.md` alla radice del repository. Contiene:
- L'albero delle directory annotato
- La lista completa dei widget interattivi con le rispettive chiavi template
- La guida passo-passo per aggiungere nuovi argomenti
- L'architettura del sistema di contenuti Markdown

Questo risparmia centinaia di token rispetto a grepping/scanning dell'intera codebase.

## 1. Filosofia del Progetto & UI/UX (Stile "Brilliant")
Il target dell'app è uno studente curioso (livello universitario). L'obiettivo non è solo mostrare formule, ma *farle comprendere* intuitivamente.

*   **Design Language:** Pulito, moderno, "educational". Usa ampi spazi bianchi (whitespace), bordi arrotondati (radius 12-16), ombre leggere.
*   **Palette Colori:** Sfondi chiari (bianco o grigio chiarissimo), testi ad alto contrasto (blu scuro/grigio antracite). Usa colori pastello per evidenziare concetti.
*   **Interattività al Centro:** Se un concetto può essere animato o modificato tramite slider, DEVE esserlo. Nessuna formula deve essere un blocco statico se contiene variabili indipendenti.
*   **Step-by-step:** Le dimostrazioni devono essere frammentate in passaggi logici che l'utente sblocca uno alla volta.

## 2. Architettura Tecnica & Pattern
*   **Framework:** Flutter (target principale iOS, `BouncingScrollPhysics`).
*   **Database:** Isar Database (locale, NoSQL). I modelli usano `@collection` per i nodi e `@embedded` per i dati modulari.
*   **Contenuti Educativi (Markdown Decoupled):**
    *   Gli argomenti sono file `.md` in `assets/content/{categoria}/` con YAML frontmatter (id, titolo, categoria, prerequisiti, widget interattivo linkato) e corpo in puro Markdown + LaTeX.
    *   `MarkdownContentParser` esegue il parsing YAML → modelli + corpo → blocchi di contenuto e passaggi algebrici.
    *   `ContentLoaderService` scopre e carica offline tutti i file `.md` via AssetManifest nel database Isar.
*   **Widget Interattivi (Factory Pattern):** `InteractiveTemplateFactory` istanzia il widget corretto in base alla chiave `template` del frontmatter YAML. I widget sono hardcoded (CustomPainter a 60/120fps), ma il loro collegamento agli articoli è puramente dichiarativo.
*   **Unità di Misura Slider:** Ogni `InteractiveParameter` ha un campo opzionale `unit` (es. `'V'`, `'m/s'`, `'Ω'`). Se assente o vuoto, nessuna unità viene mostrata. NON hardcodare mai unità nei widget.
*   **Offline-First:** L'app funziona al 100% senza internet. Tutte le query avvengono su Isar locale.

## 3. Gestione del Codice e Versioning (Git)
*   Ogni volta che completi uno Step logico o una feature, DEVI:
    1. Eseguire `flutter analyze` (zero errori/warning richiesti).
    2. Eseguire `flutter test` (tutti i 146+ test devono passare).
    3. Creare un commit semantico (es. `feat:`, `fix:`, `chore:`).
    4. Eseguire `git push`.

## 4. Stack Tecnologico Autorizzato
Non introdurre nuovi pacchetti senza giustificazione. I pacchetti core sono:
*   `isar` / `isar_flutter_libs` (Database locale)
*   `flutter_math_fork` (Rendering equazioni LaTeX)
*   `math_expressions` (Parsing e calcolo matematico a runtime)
*   `path_provider` (Gestione directory file)
*   `yaml` (Parsing frontmatter YAML dei file di contenuto)

## 5. Come procedere (Metodologia Step-by-Step)
*   Consulta sempre `PROJECT_MAP.md` prima di iniziare.
*   Non anticipare mai il lavoro oltre lo scope richiesto.
*   Se un file supera le 200 righe, proponi un refactoring.
*   Commenta le parti complesse del codice in italiano.

## 6. Aggiunta di Nuovi Argomenti (Workflow Senza Codice)
Per aggiungere un nuovo argomento educativo:
1.  Crea un file `.md` nella sottocartella appropriata di `assets/content/` (es. `physics/phys_newton_02.md`).
2.  Scrivi il frontmatter YAML:
    ```yaml
    ---
    id: phys_newton_02
    title: "Seconda Legge di Newton"
    category: "Fisica"
    subCategory: "Dinamica"
    prerequisites:
      - phys_kin_01
    interactive:
      template: live_equation
      unit: "N"
      equations: ["m * a"]
      parameters:
        - variable: m
          label: "Massa (kg)"
          unit: "kg"
          min: 0.1
          max: 100.0
          default: 10.0
          step: 0.5
        - variable: a
          label: "Accelerazione (m/s²)"
          unit: "m/s²"
          min: 0.0
          max: 20.0
          default: 9.81
          step: 0.01
    ---
    ```
3.  Scrivi il corpo dell'articolo in Markdown + LaTeX (passaggi algebrici con `$$...$$`).
4.  Se è una nuova sottocartella, registrala in `pubspec.yaml` sotto `flutter: assets:`.
5.  Il `ContentLoaderService` caricherà automaticamente il contenuto al prossimo avvio.
