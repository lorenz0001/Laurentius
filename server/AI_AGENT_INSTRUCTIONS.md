# Specifiche per Agente AI Lato Server

Fai riferimento al documento completo delle direttive situato nella root del progetto:
[SERVER_AI_CONTENT_SPEC.md](../SERVER_AI_CONTENT_SPEC.md)

### Sintesi Operativa per `server/data_nodes/`
1. Ciascun argomento deve essere salvato come file `.json` in questa directory (`server/data_nodes/`).
2. Per argomenti prettamente matematici: definire `algebraicProof` dettagliata e impostare `"interactiveData": null`.
3. Per fenomeni fisici / elettrotecnici: definire `algebraicProof` e `"interactiveData"` con `"templateType": "circuit_simulation"` (oppure `"live_equation"`).
4. Per argomenti interdisciplinari: aggiungere nel campo `"prerequisites"` i `serverId` dei nodi propedeutici di qualsiasi materia (es. `"chem_ph_01"` include `"mat_log_01"`).
