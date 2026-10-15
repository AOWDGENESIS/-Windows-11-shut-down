@echo off
setlocal EnableExtensions
title Windows 11 - Herunterfahren (30 Sekunden)
rem ============================================================
rem  Wie Herunterfahren.cmd, aber mit 30 Sekunden Vorlaufzeit.
rem  Abbrechen: dieses Fenster schliessen oder Strg+C druecken.
rem  Diese Datei enthaelt absichtlich keine Umlaute.
rem ============================================================

echo.
echo   ============================================
echo    Windows 11 - Herunterfahren in 30 Sekunden
echo   ============================================
echo.
echo   Der Bildschirm bleibt 30 Sekunden bedienbar.
echo   Danach: alle Temp-Ordner aufraeumen + herunterfahren.
echo   Abbrechen: Fenster schliessen oder Strg+C druecken.
echo.
timeout /t 30 /nobreak

echo.
echo   Zeit abgelaufen - starte Aufraeumen und Herunterfahren ...
call "%~dp0Herunterfahren.cmd"
exit /b %errorlevel%
