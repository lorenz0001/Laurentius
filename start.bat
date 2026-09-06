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
echo    [3] Web Server locale su porta 8080 (Hot Reload 'r' abilitato)
echo    [4] Anteprima Build Web compilata (avvio immediato http.server)
echo.

set /p choice="Scelta [Default 1]: "
if "%choice%"=="" set choice=1

if "%choice%"=="1" goto run_edge
if "%choice%"=="2" goto run_chrome
if "%choice%"=="3" goto run_webserver
if "%choice%"=="4" goto run_static

:run_edge
echo.
echo [AVVIO] Lancio su Microsoft Edge con Flutter Dev Server...
flutter run -d edge --no-wasm-dry-run
goto end

:run_chrome
echo.
echo [AVVIO] Lancio su Google Chrome con Flutter Dev Server...
flutter run -d chrome --no-wasm-dry-run
goto end

:run_webserver
echo.
echo [AVVIO] Lancio Web Server su porta 8080...
start http://localhost:8080
flutter run -d web-server --web-port 8080 --no-wasm-dry-run
goto end

:run_static
echo.
echo [AVVIO] Avvio server statico su http://localhost:8080...
if not exist "build\web\index.html" (
    echo Compilazione iniziale build web...
    call flutter build web --no-wasm-dry-run
)
start http://localhost:8080
python -m http.server 8080 -d build\web
goto end

:end
pause
