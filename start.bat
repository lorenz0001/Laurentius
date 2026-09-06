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
echo [AVVIO] Lancio su Microsoft Edge con Flutter Dev Server...
flutter run -d edge
goto end

:run_chrome
echo.
echo [AVVIO] Lancio su Google Chrome con Flutter Dev Server...
flutter run -d chrome
goto end

:run_webserver
echo.
echo [AVVIO] Lancio Web Server Flutter su porta 8080...
echo [INFO] Apri il browser su http://localhost:8080 se non si apre automaticamente.
start http://localhost:8080
flutter run -d web-server --web-port 8080
goto end

:run_static
echo.
echo [AVVIO] Avvio server statico su http://localhost:8080...
if not exist "build\web\index.html" (
    echo Compilazione iniziale build web...
    call flutter build web
)
start http://localhost:8080
python -m http.server 8080 -d build\web
goto end

:run_backend
echo.
echo [AVVIO] Avvio del Knowledge Sync Server Python...
call "%~dp0server\start.bat"
goto end

:end
pause
