@echo off
title Laurentius - Brilliant-OS Browser Launcher
cd /d "%~dp0"

echo ===============================================================
echo        Laurentius (Brilliant-OS) - Browser Preview Launcher
echo ===============================================================
echo.
echo  Questo launcher avvia l'app su browser per testare al volo
echo  tutti i contenuti didattici, passaggi di dimostrazione e
echo  le animazioni interattive a 60fps senza dover ricompilare l'IPA.
echo.
echo  Seleziona la modalita di avvio:
echo    [1] Modalita Sviluppo Live (Microsoft Edge - Consigliato)
echo    [2] Modalita Sviluppo Live (Google Chrome)
echo    [3] Web Server locale Flutter su porta 8080 (Hot Reload abilitato)
echo    [4] Anteprima Build Web compilata (avvio immediato http.server)
echo    [5] Knowledge Sync Server Python (FastAPI su porta 8000)
echo.

set /p choice="Scelta [Default 1]: "
if "%choice%"=="" set choice=1

if "%choice%"=="1" goto run_edge
if "%choice%"=="2" goto run_chrome
if "%choice%"=="3" goto run_webserver
if "%choice%"=="4" goto run_static
if "%choice%"=="5" goto run_backend

:run_edge
echo.
echo ===============================================================
echo [AVVIO] Lancio dell'app didattica su Microsoft Edge...
echo ===============================================================
echo [1/2] Avvio del server web su porta 8085...
start http://localhost:8085
echo [2/2] Inizializzazione Flutter Web Server (Hot Reload abilitato)...
flutter run -d web-server --web-port 8085
goto end

:run_chrome
echo.
echo ===============================================================
echo [AVVIO] Lancio su Browser...
echo ===============================================================
start http://localhost:8085
flutter run -d web-server --web-port 8085
goto end

:run_webserver
echo.
echo [AVVIO] Web Server su porta 8085...
start http://localhost:8085
flutter run -d web-server --web-port 8085
goto end

:run_static
echo.
echo [AVVIO] Anteprima rapida su http://localhost:8085...
start http://localhost:8085
python -m http.server 8085 -d build\web
goto end

:run_backend
echo.
echo [AVVIO] Avvio del Knowledge Sync Server Python...
call "%~dp0server\start.bat"
goto end

:end
pause
