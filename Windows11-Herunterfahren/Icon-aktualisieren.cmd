@echo off
setlocal EnableExtensions
title Windows 11 - Icon aktualisieren
rem ============================================================
rem  Repariert die Anzeige des Herunterfahren-Icons:
rem    1) prueft die Icon-Datei und setzt die Icon-Zuweisung
rem       der Desktop-Verknuepfung neu
rem    2) auf Wunsch: Explorer neu starten + Windows-Icon-Cache
rem       loeschen (danach zeigt Windows das Symbol garantiert neu)
rem  Diese Datei enthaelt absichtlich keine Umlaute.
rem ============================================================

echo.
echo   ==========================================================
echo    Icon des Herunterfahren-Shortcuts aktualisieren
echo   ==========================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -EncodedCommand JABFAHIAcgBvAHIAQQBjAHQAaQBvAG4AUAByAGUAZgBlAHIAZQBuAGMAZQA9ACcAQwBvAG4AdABpAG4AdQBlACcACgAkAHoAaQBlAGwAPQBKAG8AaQBuAC0AUABhAHQAaAAgACQAZQBuAHYAOgBMAE8AQwBBAEwAQQBQAFAARABBAFQAQQAgACcASABlAHIAdQBuAHQAZQByAGYAYQBoAHIAZQBuACcACgAkAGkAYwBvAD0ASgBvAGkAbgAtAFAAYQB0AGgAIAAkAHoAaQBlAGwAIAAnAGgAZQByAHUAbgB0AGUAcgBmAGEAaAByAGUAbgAuAGkAYwBvACcACgBpAGYAKAAtAG4AbwB0ACAAKABUAGUAcwB0AC0AUABhAHQAaAAgAC0ATABpAHQAZQByAGEAbABQAGEAdABoACAAJABpAGMAbwApACkAewAnAEYARQBIAEwARQBSADoAIABJAGMAbwBuAC0ARABhAHQAZQBpACAAZgBlAGgAbAB0ADoAIAAnACsAJABpAGMAbwA7AGUAeABpAHQAIAAyAH0ACgAnAEkAYwBvAG4ALQBEAGEAdABlAGkAIAA6ACAAJwArACQAaQBjAG8ACgAnAEQAYQB0AGUAaQBnAHIAbwBlAHMAcwBlADoAIAAnACsAWwBtAGEAdABoAF0AOgA6AFIAbwB1AG4AZAAoACgARwBlAHQALQBJAHQAZQBtACAALQBMAGkAdABlAHIAYQBsAFAAYQB0AGgAIAAkAGkAYwBvACkALgBMAGUAbgBnAHQAaAAvADEASwBCACkAKwAnACAASwBCACcACgAnACcACgAkAGsAYQBuAGQAPQBAACgAKQAKACQAawBhAG4AZAArAD0AKABKAG8AaQBuAC0AUABhAHQAaAAgACQAZQBuAHYAOgBVAFMARQBSAFAAUgBPAEYASQBMAEUAIAAnAEQAZQBzAGsAdABvAHAAJwApAAoAaQBmACgAJABlAG4AdgA6AFAAVQBCAEwASQBDACkAewAkAGsAYQBuAGQAKwA9ACgASgBvAGkAbgAtAFAAYQB0AGgAIAAkAGUAbgB2ADoAUABVAEIATABJAEMAIAAnAEQAZQBzAGsAdABvAHAAJwApAH0ACgAkAGcAZQBmAHUAbgBkAGUAbgA9ACQAZgBhAGwAcwBlAAoAZgBvAHIAZQBhAGMAaAAoACQAZAAgAGkAbgAgACQAawBhAG4AZAApAHsACgAgACAAJABsAD0ASgBvAGkAbgAtAFAAYQB0AGgAIAAkAGQAIAAnAEgAZQByAHUAbgB0AGUAcgBmAGEAaAByAGUAbgAuAGwAbgBrACcACgAgACAAaQBmACgAVABlAHMAdAAtAFAAYQB0AGgAIAAtAEwAaQB0AGUAcgBhAGwAUABhAHQAaAAgACQAbAApAHsACgAgACAAIAAgACQAZwBlAGYAdQBuAGQAZQBuAD0AJAB0AHIAdQBlAAoAIAAgACAAIAAkAHMAaAA9AE4AZQB3AC0ATwBiAGoAZQBjAHQAIAAtAEMAbwBtAE8AYgBqAGUAYwB0ACAAVwBTAGMAcgBpAHAAdAAuAFMAaABlAGwAbAAKACAAIAAgACAAJABzAD0AJABzAGgALgBDAHIAZQBhAHQAZQBTAGgAbwByAHQAYwB1AHQAKAAkAGwAKQAKACAAIAAgACAAJwBWAGUAcgBrAG4AdQBlAHAAZgB1AG4AZwA6ACAAJwArACQAbAAKACAAIAAgACAAJwAgACAAIABJAGMAbwBuACAAdwBhAHIAIAA6ACAAJwArACQAcwAuAEkAYwBvAG4ATABvAGMAYQB0AGkAbwBuAAoAIAAgACAAIAAkAHMALgBJAGMAbwBuAEwAbwBjAGEAdABpAG8AbgA9ACQAaQBjAG8ACgAgACAAIAAgACQAcwAuAFMAYQB2AGUAKAApAAoAIAAgACAAIAAkAHMAaAAyAD0ATgBlAHcALQBPAGIAagBlAGMAdAAgAC0AQwBvAG0ATwBiAGoAZQBjAHQAIABXAFMAYwByAGkAcAB0AC4AUwBoAGUAbABsAAoAIAAgACAAIAAkAHMAMgA9ACQAcwBoADIALgBDAHIAZQBhAHQAZQBTAGgAbwByAHQAYwB1AHQAKAAkAGwAKQAKACAAIAAgACAAJwAgACAAIABJAGMAbwBuACAAaQBzAHQAIAA6ACAAJwArACQAcwAyAC4ASQBjAG8AbgBMAG8AYwBhAHQAaQBvAG4ACgAgACAAIAAgACcAJwAKACAAIAB9AAoAfQAKAGkAZgAoAC0AbgBvAHQAIAAkAGcAZQBmAHUAbgBkAGUAbgApAHsAJwBIAEkATgBXAEUASQBTADoAIABLAGUAaQBuAGUAIABWAGUAcgBrAG4AdQBlAHAAZgB1AG4AZwAgAGcAZQBmAHUAbgBkAGUAbgAuACcAOwAnAEIAaQB0AHQAZQAgAHoAdQBlAHIAcwB0ACAAIgBEAGUAcwBrAHQAbwBwAC0AVgBlAHIAawBuAHUAZQBwAGYAdQBuAGcALQBhAG4AbABlAGcAZQBuAC4AYwBtAGQAIgAgAGEAdQBzAGYAdQBlAGgAcgBlAG4ALgAnADsAZQB4AGkAdAAgADMAfQAKACcATwBLACAALQAgAEkAYwBvAG4ALQBaAHUAdwBlAGkAcwB1AG4AZwAgAGkAcwB0ACAAZwBlAHMAZQB0AHoAdAAuACcACgBlAHgAaQB0ACAAMAA=
if errorlevel 3 goto kein_lnk
if errorlevel 2 goto kein_ico
if errorlevel 1 goto fehler

echo.
choice /c JN /n /t 15 /d N /m "   Jetzt Explorer neu starten + Icon-Cache loeschen? [J]a / [N]ein (15s): "
if errorlevel 2 goto ende

echo.
echo   Beende Explorer ...
taskkill /f /im explorer.exe >nul 2>&1
echo   Loesche Icon-Cache ...
del /f /q "%LOCALAPPDATA%\IconCache.db" >nul 2>&1
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\iconcache*.db" >nul 2>&1
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache*.db" >nul 2>&1
ie4uinit.exe -show >nul 2>&1
echo   Starte Explorer neu ...
start explorer.exe
timeout /t 3 /nobreak >nul
echo.
echo   FERTIG - das Icon sollte jetzt korrekt angezeigt werden.

:ende
echo.
echo   Tipp fuer den Notfall: Verknuepfung auf dem Desktop
echo   umbenennen (z.B. in "Herunterfahren 2") - damit vergibt
echo   Windows einen neuen Cache-Eintrag und zeichnet das Icon neu.
echo.
pause
exit /b 0

:kein_ico
echo   Bitte zuerst "Installieren.cmd" ausfuehren - die Icon-Datei
echo   wurde nicht gefunden.
echo.
pause
exit /b 2

:kein_lnk
echo   Es wurde keine Desktop-Verknuepfung gefunden.
echo   Bitte "Desktop-Verknuepfung-anlegen.cmd" ausfuehren.
echo.
pause
exit /b 3

:fehler
echo.
echo   Unerwarteter Fehler - bitte den Text oben pruefen.
echo.
pause
exit /b 1
