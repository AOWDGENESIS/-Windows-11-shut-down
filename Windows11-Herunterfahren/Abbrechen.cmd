@echo off
rem ============================================================
rem  Bricht ein laufendes, zeitgesteuertes Herunterfahren ab.
rem  Funktioniert nur solange die Wartezeit noch laeuft.
rem ============================================================
title Windows 11 - Herunterfahren abbrechen

shutdown /a
if errorlevel 1 goto nichts
echo.
echo   OK - Herunterfahren wurde abgebrochen.
timeout /t 4 /nobreak >nul
exit /b

:nichts
echo.
echo   Es war kein (zeitgesteuertes) Herunterfahren aktiv.
timeout /t 4 /nobreak >nul
exit /b
