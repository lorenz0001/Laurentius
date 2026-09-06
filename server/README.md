# Brilliant-OS - Knowledge Nodes Backend (Step 7)

Backend server locale in Python con **FastAPI** progettato per la sincronizzazione offline-first con il client Flutter di **Brilliant-OS**.

La *Single Source of Truth* è costituita da file `.json` salvati nella directory `data_nodes/`. Non è richiesto alcun database SQL: i nodi possono essere aggiunti o modificati direttamente modificando o aggiungendo file JSON.

---

## 📁 Struttura del Progetto

```text
server/
├── data_nodes/
│   ├── ohm.json       # Legge di Ohm (ele_ohm_01)
│   └── power.json     # Potenza elettrica (ele_power_01, prerequisito: ele_ohm_01)
├── main.py            # Applicazione FastAPI con rotte REST e CORS
├── requirements.txt   # Dipendenze Python (fastapi, uvicorn)
└── README.md          # Questa guida
```

---

## 🚀 Setup e Avvio

### 1. (Opzionale) Creare e attivare un virtual environment
```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
```

### 2. Installare le dipendenze
```powershell
pip install -r requirements.txt
```

### 3. Avviare il Server

Puoi avviare il server in due modi:

**Opzione A (Consigliata su Windows):**
Fai doppio clic su `start.bat` o eseguilo da terminale:
```powershell
.\start.bat
```

**Opzione B (Manuale):**
```powershell
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

> **Nota sull'host `0.0.0.0`**: Permette l'ascolto su tutte le interfacce di rete del PC, rendendo il server raggiungibile sia dalla macchina locale sia da dispositivi mobili (iPhone o Android) connessi alla medesima rete Wi-Fi.

---

## 📱 Collegamento con il Client Flutter

In base all'ambiente in cui esegui l'app Flutter, imposta l'URL di base del server:

| Ambiente Client | Base URL da usare in Flutter |
| :--- | :--- |
| **iOS Simulator** | `http://127.0.0.1:8000` o `http://localhost:8000` |
| **Android Emulator** | `http://10.0.2.2:8000` (alias speciale di loopback per l'host del PC) |
| **iPhone Fisico (Wi-Fi)** | `http://<IP_LOCALE_DEL_PC>:8000` (es. `http://192.168.1.50:8000`) |
| **Flutter Web** | `http://localhost:8000` |

> 💡 Per trovare l'IP locale del tuo PC su Windows, esegui nel terminale:
> ```powershell
> ipconfig
> ```
> Cerca la voce **Indirizzo IPv4** dell'adattatore Wi-Fi o Ethernet (es. `192.168.1.X`). Assicurati inoltre che il firewall di Windows consenta le connessioni in entrata sulla porta 8000 per la rete privata.

---

## 🌐 Endpoint API Disponibili

- **`GET /`**: Stato del server e conteggio nodi caricati.
- **`GET /docs`**: Documentazione interattiva Swagger UI (testa le chiamate direttamente dal browser).
- **`GET /api/nodes`**: Restituisce la lista completa di tutti i nodi di conoscenza presenti in `data_nodes/`.
- **`GET /api/nodes/sync?last_sync=<timestamp>`**:
  - Se `last_sync` è omesso o `0`, restituisce tutti i nodi.
  - Se `last_sync` è specificato (timestamp UNIX in secondi o millisecondi come `DateTime.now().millisecondsSinceEpoch` in Dart), restituisce solo i nodi modificati dopo quella data.
- **`GET /api/nodes/{server_id}`**: Restituisce i dettagli di un singolo nodo.

---

## 📝 Aggiungere Nuovi Nodi

Per aggiungere un nuovo nodo didattico al grafo:
1. Crea un nuovo file `.json` all'interno di `data_nodes/` (es. `data_nodes/kirchhoff.json`).
2. Rispetta lo schema JSON:
```json
{
  "serverId": "ele_kirchhoff_01",
  "title": "Leggi di Kirchhoff",
  "category": "Elettrotecnica",
  "prerequisites": ["ele_ohm_01"],
  "algebraicProof": [
    {
      "description": "La somma algebrica delle correnti in un nodo è nulla (KCL).",
      "latexEquation": "\\sum_{k=1}^n I_k = 0",
      "insight": "Principio di conservazione della carica elettrica."
    }
  ],
  "interactiveData": {
    "templateType": "live_equation",
    "equations": ["I1 + I2"],
    "parameters": [
      {
        "variableName": "I1",
        "label": "Corrente I1 (A)",
        "minValue": 0.0,
        "maxValue": 10.0,
        "defaultValue": 2.5,
        "stepSize": 0.1
      }
    ]
  }
}
```
3. Con il flag `--reload` attivo, FastAPI rileverà automaticamente le modifiche e le servirà alla prossima richiesta del client!
