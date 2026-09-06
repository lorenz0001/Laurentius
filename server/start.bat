@echo off
title Brilliant-OS Server
cd /d "%~dp0"

echo =======================================================
echo          Brilliant-OS - Knowledge Sync Server
echo =======================================================
echo.

:: Se esiste un virtual environment nella cartella "venv", attivalo
if exist "venv\Scripts\activate.bat" (
    echo [INFO] Attivazione ambiente virtuale venv...
    call venv\Scripts\activate.bat
) else (
    echo [INFO] Nessun venv locale trovato, uso Python di sistema...
)

:: Verifica la presenza di Python
where python >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ERRORE] Python non e installato o non e presente nel PATH!
    pause
    exit /b 1
)

:: Verifica rapida delle dipendenze essenziali
python -c "import fastapi, uvicorn" >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [INFO] Dipendenze mancanti. Installazione da requirements.txt in corso...
    python -m pip install -r requirements.txt
    if %ERRORLEVEL% neq 0 (
        echo [ERRORE] Installazione delle dipendenze fallita!
        pause
        exit /b 1
    )
)

echo.
echo [INFO] Avvio del server su 0.0.0.0:8000...
echo.
echo   - Local URL:         http://127.0.0.1:8000
echo   - Swagger Docs:      http://127.0.0.1:8000/docs
echo   - API Nodi:          http://127.0.0.1:8000/api/nodes
echo.
echo   Per collegare un iPhone/Android fisico sulla stessa Wi-Fi:
echo   apri un altro terminale, digita 'ipconfig' e usa http://^<TUO_IP_LOCALE^>:8000
echo.
echo Premi CTRL+C per arrestare il server.
echo =======================================================
echo.

python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000

if %ERRORLEVEL% neq 0 (
    echo.
    echo [AVVISO] Il server si e arrestato con un codice di errore.
    pause
)
