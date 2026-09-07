@echo off
title Laurentius - Widget Debug & Preview Launcher
cd /d "%~dp0"

echo ===============================================================
echo      Laurentius (Brilliant-OS) - Widget Debug Gallery Launcher
echo ===============================================================
echo.
echo  Questo launcher avvia direttamente la galleria di debug di TUTTI
echo  i widget (animati e statici) senza dover navigare nel grafo didattico.
echo.
echo  Widget disponibili per il collaudo immediato:
echo    - Circonferenza Goniometrica (tangente, seno, coseno, asintoti)
echo    - Teoremi del Valor Medio (Rolle & Lagrange con secante e tangenti)
echo    - Teorema dei Carabinieri (Squeeze theorem e curve di contenimento)
echo    - Teorema di Carnot (Pitagora generalizzato e triangolo interattivo)
echo    - Grafico Cartesiano 2D & Deformazione curve
echo    - Rapporto Incrementale & Derivata
echo    - Somme di Riemann per integrali definiti
echo    - Cinematica Rettilinea & Torricelli
echo    - Circuito Elettrico di Ohm & Corrente
echo    - Laboratorio Equazioni Algebriche Live
echo    - Dimostrazioni Step-by-Step, KaTeX e blocchi didattici
echo.
echo  Seleziona la modalita di avvio:
echo    [1] Microsoft Edge (Web Live - Consigliato)
echo    [2] Google Chrome (Web Live)
echo    [3] App Windows Desktop nativa (Massime prestazioni 60/120fps)
echo    [4] Web Server su porta 8086 (Hot Reload abilitato)
echo.

set /p choice="Scelta [Default 1]: "
if "%choice%"=="" set choice=1

if "%choice%"=="1" goto run_edge
if "%choice%"=="2" goto run_chrome
if "%choice%"=="3" goto run_windows
if "%choice%"=="4" goto run_webserver

:run_edge
echo.
echo ===============================================================
echo [AVVIO] Lancio Galleria Widget su Microsoft Edge (porta 8086)...
echo ===============================================================
start http://localhost:8086
flutter run -t lib/main_widgets.dart -d web-server --web-port 8086
goto end

:run_chrome
echo.
echo ===============================================================
echo [AVVIO] Lancio Galleria Widget su Google Chrome (porta 8086)...
echo ===============================================================
start http://localhost:8086
flutter run -t lib/main_widgets.dart -d web-server --web-port 8086
goto end

:run_windows
echo.
echo ===============================================================
echo [AVVIO] Lancio Galleria Widget come App Windows Desktop...
echo ===============================================================
flutter run -t lib/main_widgets.dart -d windows
goto end

:run_webserver
echo.
echo ===============================================================
echo [AVVIO] Web Server su http://localhost:8086...
echo ===============================================================
start http://localhost:8086
flutter run -t lib/main_widgets.dart -d web-server --web-port 8086
goto end

:end
pause
