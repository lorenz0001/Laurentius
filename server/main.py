"""
=============================================================================
Brilliant-OS - Knowledge Nodes Sync Server (Step 7)
=============================================================================
Server locale FastAPI per esporre i Nodi di Conoscenza (JSON) al client Flutter.

COMANDO PER L'AVVIO:
    uvicorn main:app --reload --host 0.0.0.0 --port 8000

NOTE DI RETE:
- L'uso di --host 0.0.0.0 è fondamentale per permettere a dispositivi fisici
  (es. iPhone / Android) collegati alla stessa rete Wi-Fi di raggiungere il server
  usando l'indirizzo IP locale del PC (es. http://192.168.1.X:8000).
- Sul Simulatore iOS o Browser puoi usare direttamente: http://127.0.0.1:8000
- Sull'Emulatore Android usa: http://10.0.2.2:8000
- Documentazione Swagger interattiva disponibile su: http://127.0.0.1:8000/docs
=============================================================================
"""

import json
import logging
from pathlib import Path
from typing import List, Optional

from fastapi import FastAPI, HTTPException, Query, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, ConfigDict, Field

# Configurazione del logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s"
)
logger = logging.getLogger("brilliant-os-server")

# Percorso della directory dei file JSON (Single Source of Truth)
BASE_DIR = Path(__file__).resolve().parent
DATA_DIR = BASE_DIR / "data_nodes"

# =============================================================================
# Modelli Pydantic (allineati con le entità Isar di Flutter)
# =============================================================================

class ProofStep(BaseModel):
    model_config = ConfigDict(extra="allow")
    
    description: str = Field(..., description="Descrizione testuale del passaggio")
    latexEquation: str = Field(..., description="Equazione in formato LaTeX")
    insight: Optional[str] = Field(None, description="Intuizione o nota didattica")


class Parameter(BaseModel):
    model_config = ConfigDict(extra="allow")
    
    variableName: str = Field(..., description="Nome della variabile (es. R, I, V)")
    label: str = Field(..., description="Etichetta leggibile dall'utente")
    minValue: float = Field(..., description="Valore minimo per lo slider")
    maxValue: float = Field(..., description="Valore massimo per lo slider")
    defaultValue: float = Field(..., description="Valore iniziale predefinito")
    stepSize: float = Field(..., description="Passo di incremento dello slider")


class InteractiveData(BaseModel):
    model_config = ConfigDict(extra="allow")
    
    templateType: str = Field(..., description="Tipo di template interattivo (es. live_equation)")
    equations: List[str] = Field(default_factory=list, description="Lista di formule interattive")
    parameters: List[Parameter] = Field(default_factory=list, description="Parametri controllabili da slider")


class KnowledgeNode(BaseModel):
    model_config = ConfigDict(extra="allow")
    
    serverId: str = Field(..., description="Identificativo univoco del nodo sul server")
    title: str = Field(..., description="Titolo del nodo di conoscenza")
    category: str = Field(..., description="Categoria tematica (es. Elettrotecnica)")
    prerequisites: List[str] = Field(default_factory=list, description="ID dei nodi prerequisiti")
    algebraicProof: List[ProofStep] = Field(default_factory=list, description="Dimostrazione o passaggi algebrici")
    interactiveData: Optional[InteractiveData] = Field(None, description="Dati per la visualizzazione interattiva")


# =============================================================================
# Inizializzazione FastAPI
# =============================================================================

app = FastAPI(
    title="Brilliant-OS Knowledge Server",
    description="API REST per la sincronizzazione offline-first dei Nodi di Conoscenza con Flutter.",
    version="1.0.0"
)

# Abilitazione CORS per consentire l'accesso da qualsiasi client (Flutter Web, mobile, etc.)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# =============================================================================
# Funzioni di utilità per la lettura dei file JSON
# =============================================================================

def read_nodes_from_disk(last_sync_timestamp: Optional[float] = None) -> List[KnowledgeNode]:
    """
    Legge tutti i file .json nella cartella data_nodes/.
    Se last_sync_timestamp è fornito (> 0), filtra solo i file modificati dopo quel momento.
    """
    if not DATA_DIR.exists():
        logger.warning(f"La cartella {DATA_DIR} non esiste ancora. Creazione automatica...")
        DATA_DIR.mkdir(parents=True, exist_ok=True)
        return []

    nodes: List[KnowledgeNode] = []
    json_files = sorted(DATA_DIR.glob("*.json"))

    for file_path in json_files:
        try:
            # Se è richiesto un filtro di sincronizzazione incrementale basato su mtime
            if last_sync_timestamp is not None and last_sync_timestamp > 0:
                file_mtime = file_path.stat().st_mtime
                if file_mtime <= last_sync_timestamp:
                    continue  # File non modificato dopo l'ultimo sync

            content = file_path.read_text(encoding="utf-8")
            raw_data = json.loads(content)
            node = KnowledgeNode.model_validate(raw_data)
            nodes.append(node)
        except json.JSONDecodeError as jde:
            logger.error(f"Errore di sintassi JSON nel file {file_path.name}: {jde}")
        except Exception as exc:
            logger.error(f"Errore nella validazione del file {file_path.name}: {exc}")

    return nodes


# =============================================================================
# Rotte API
# =============================================================================

@app.get(
    "/",
    summary="Root Status Check",
    tags=["General"]
)
def root():
    """Restituisce lo stato del server e il conteggio attuale dei nodi disponibili."""
    all_nodes = read_nodes_from_disk()
    return {
        "status": "online",
        "service": "Brilliant-OS Knowledge Server",
        "total_nodes": len(all_nodes),
        "docs_url": "/docs",
        "endpoints": {
            "all_nodes": "/api/nodes",
            "sync": "/api/nodes/sync"
        }
    }


@app.get(
    "/api/nodes",
    response_model=List[KnowledgeNode],
    summary="Recupera tutti i nodi di conoscenza",
    tags=["Nodes"]
)
def get_all_nodes() -> List[KnowledgeNode]:
    """
    Legge tutti i file .json presenti nella cartella `data_nodes/`
    e restituisce la lista completa dei nodi per il client Flutter.
    """
    try:
        nodes = read_nodes_from_disk()
        logger.info(f"Restituiti {len(nodes)} nodi a /api/nodes")
        return nodes
    except Exception as exc:
        logger.error(f"Errore durante la lettura dei nodi: {exc}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Impossibile leggere i nodi dal filesystem: {str(exc)}"
        )


@app.get(
    "/api/nodes/sync",
    response_model=List[KnowledgeNode],
    summary="Sincronizzazione incrementale dei nodi",
    tags=["Nodes"]
)
def sync_nodes(
    last_sync: Optional[float] = Query(
        None,
        description="Timestamp UNIX dell'ultimo sync. Può essere espresso in secondi o millisecondi (es. DateTime.now().millisecondsSinceEpoch in Flutter)."
    )
) -> List[KnowledgeNode]:
    """
    Rotta preparatoria per la sincronizzazione offline-first:
    - Se last_sync è nullo o 0, restituisce tutti i nodi.
    - Se last_sync è specificato, confronta con la data di ultima modifica del file sul filesystem (st_mtime).
    """
    try:
        normalized_timestamp = last_sync

        # Gestione timestamp in millisecondi (tipico in Flutter/Dart DateTime)
        if normalized_timestamp is not None and normalized_timestamp > 1e11:
            normalized_timestamp = normalized_timestamp / 1000.0

        nodes = read_nodes_from_disk(last_sync_timestamp=normalized_timestamp)
        logger.info(f"Sync richiesto con last_sync={last_sync}. Restituiti {len(nodes)} nodi aggiornati.")
        return nodes
    except Exception as exc:
        logger.error(f"Errore durante la sincronizzazione: {exc}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Errore nel sync: {str(exc)}"
        )


@app.get(
    "/api/nodes/{server_id}",
    response_model=KnowledgeNode,
    summary="Recupera un singolo nodo per serverId",
    tags=["Nodes"]
)
def get_node_by_id(server_id: str) -> KnowledgeNode:
    """Restituisce il singolo nodo di conoscenza corrispondente al serverId fornito."""
    all_nodes = read_nodes_from_disk()
    for node in all_nodes:
        if node.serverId == server_id:
            return node
    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail=f"Nodo con serverId '{server_id}' non trovato."
    )


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
