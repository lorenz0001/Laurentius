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

Prima di esplorare il codice, DEVI leggere `PROJECT_MAP.md` alla radice del repository.

## 1. Filosofia del Progetto & UI/UX (Stile "Brilliant")
Il target dell'app è uno studente curioso (livello universitario). L'obiettivo non è solo mostrare formule, ma farle comprendere intuitivamente.

* Design Language: Pulito, moderno, "educational". Usa ampi spazi bianchi, bordi arrotondati (radius 12-16), ombre leggere.
* Palette Colori: Sfondi chiari, testi ad alto contrasto. Colori pastello per concetti.
* Interattività al Centro: formule animate/modificabili con slider se contengono variabili.
* Step-by-Step: Dimostrazioni frammentate in passaggi logici sbloccabili progressivamente.

## 2. Architettura Tecnica & Pattern
* Framework: Flutter (target principale iOS, BouncingScrollPhysics).
* Database: Isar Database (locale, NoSQL).
* Contenuti: Markdown + LaTeX in assets/content/.
* Widget Interattivi: Factory pattern.
* Offline-First: Funziona al 100% offline.
