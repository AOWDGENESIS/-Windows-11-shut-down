@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Windows 11 - Desktop aufraeumen
rem ============================================================
rem  Entfernt alle Desktop-Verknuepfungen AUSSER "Herunterfahren".
rem
rem  Sicher statt radikal: Die Verknuepfungen werden in einen
rem  Sicherungsordner verschoben (Desktop-Sicherung-DATUM).
rem  Zurueckholen: "Desktop-Wiederherstellen.cmd".
rem
rem  Es werden nur Verknuepfungen (*.lnk / *.url) verschoben -
rem  KEINE Dokumente, Ordner oder eigenen Dateien.
rem
rem  Optional: Windows-Systemsymbole (Papierkorb, Dieser PC,
rem  Netzwerk ...) ausblenden.
rem
rem  Diese Datei enthaelt absichtlich keine Umlaute.
rem ============================================================

set "BEHALTEN=Herunterfahren"
set "SICHER=%USERPROFILE%\Desktop-Sicherung"

echo.
echo   ==========================================================
echo    Desktop aufraeumen - nur "Herunterfahren" behalten
echo   ==========================================================
echo.

for /f "usebackq delims=" %%T in (`powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm"`) do set "STAMP=%%T"
if not defined STAMP set "STAMP=manuell"
if not exist "%SICHER%" mkdir "%SICHER%" >nul 2>&1
set "ZIELORDNER=%SICHER%\%STAMP%"

set "N=0"
set "BEHALTEN_N=0"

for /f "usebackq delims=" %%D in (`powershell -NoProfile -ExecutionPolicy Bypass -EncodedCommand JABkAD0AQAAoACkACgB0AHIAeQB7ACQAZAArAD0AKABOAGUAdwAtAE8AYgBqAGUAYwB0ACAALQBDAG8AbQBPAGIAagBlAGMAdAAgAFcAUwBjAHIAaQBwAHQALgBTAGgAZQBsAGwAKQAuAFMAcABlAGMAaQBhAGwARgBvAGwAZABlAHIAcwAuAEkAdABlAG0AKAAnAEQAZQBzAGsAdABvAHAAJwApAH0AYwBhAHQAYwBoAHsAfQAKAHQAcgB5AHsAJABkACsAPQBbAEUAbgB2AGkAcgBvAG4AbQBlAG4AdABdADoAOgBHAGUAdABGAG8AbABkAGUAcgBQAGEAdABoACgAJwBEAGUAcwBrAHQAbwBwACcAKQB9AGMAYQB0AGMAaAB7AH0ACgBpAGYAKAAkAGUAbgB2ADoAVQBTAEUAUgBQAFIATwBGAEkATABFACkAewAkAGQAKwA9ACgASgBvAGkAbgAtAFAAYQB0AGgAIAAkAGUAbgB2ADoAVQBTAEUAUgBQAFIATwBGAEkATABFACAAJwBEAGUAcwBrAHQAbwBwACcAKQB9AAoAZgBvAHIAZQBhAGMAaAAoACQAdgAgAGkAbgAgAEAAKAAkAGUAbgB2ADoATwBuAGUARAByAGkAdgBlACwAJABlAG4AdgA6AE8AbgBlAEQAcgBpAHYAZQBDAG8AbgBzAHUAbQBlAHIALAAkAGUAbgB2ADoATwBuAGUARAByAGkAdgBlAEMAbwBtAG0AZQByAGMAaQBhAGwAKQApAHsAaQBmACgAJAB2ACkAewAkAGQAKwA9ACgASgBvAGkAbgAtAFAAYQB0AGgAIAAkAHYAIAAnAEQAZQBzAGsAdABvAHAAJwApAH0AfQAKAGkAZgAoACQAZQBuAHYAOgBQAFUAQgBMAEkAQwApAHsAJABkACsAPQAoAEoAbwBpAG4ALQBQAGEAdABoACAAJABlAG4AdgA6AFAAVQBCAEwASQBDACAAJwBEAGUAcwBrAHQAbwBwACcAKQB9AAoAJABkAHwAVwBoAGUAcgBlAC0ATwBiAGoAZQBjAHQAewAkAF8AfQB8AEYAbwByAEUAYQBjAGgALQBPAGIAagBlAGMAdAB7ACQAXwAuAFQAcgBpAG0ARQBuAGQAKAAnAFwAJwApAH0AfABTAG8AcgB0AC0ATwBiAGoAZQBjAHQAIAAtAFUAbgBpAHEAdQBlAHwAVwBoAGUAcgBlAC0ATwBiAGoAZQBjAHQAewBUAGUAcwB0AC0AUABhAHQAaAAgAC0ATABpAHQAZQByAGEAbABQAGEAdABoACAAJABfAH0A`) do call :scannen "%%D"

echo.
if "%N%"=="0" goto nichts_zu_tun
echo   Gefunden: %N% Verknuepfung(en) - behalten wird "%BEHALTEN%.lnk".
echo.
choice /c VLN /n /t 30 /d N /m "   [V]erschieben (mit Sicherung) / [L]oeschen / [N]ein (30s): "
if errorlevel 3 goto abbruch

if errorlevel 2 goto loeschen
goto verschieben

:verschieben
if not exist "%ZIELORDNER%" mkdir "%ZIELORDNER%" >nul 2>&1
set "GT=0"
for /l %%I in (1,1,%N%) do (
    move /y "!L%%I!" "%ZIELORDNER%\" >nul 2>&1
    if not errorlevel 1 set /a GT+=1
)
echo.
echo   %GT% Verknuepfung(en) verschoben nach:
echo   %ZIELORDNER%
echo.
echo   Zurueckholen jederzeit mit "Desktop-Wiederherstellen.cmd".
goto ende

:loeschen
echo.
choice /c JN /n /t 20 /d N /m "   Endgueltig loeschen? Nicht wiederherstellbar! [J]a/[N]ein (20s): "
if errorlevel 2 goto abbruch
set "GL=0"
for /l %%I in (1,1,%N%) do (
    del /f /q "!L%%I!" >nul 2>&1
    if not errorlevel 1 set /a GL+=1
)
echo.
echo   %GL% Verknuepfung(en) geloescht.
goto ende

:ende
ie4uinit.exe -show >nul 2>&1

echo.
echo   Windows-Systemsymbole auch ausblenden?
echo   (Papierkorb, Dieser PC, Netzwerk, Benutzerdateien, Systemsteuerung)
echo.
choice /c JN /n /t 20 /d N /m "   System-Symbole ausblenden? [J]a / [N]ein (20s): "
if errorlevel 2 goto kein_hide

powershell -NoProfile -ExecutionPolicy Bypass -EncodedCommand JABrAD0AJwBIAEsAQwBVADoAXABTAG8AZgB0AHcAYQByAGUAXABNAGkAYwByAG8AcwBvAGYAdABcAFcAaQBuAGQAbwB3AHMAXABDAHUAcgByAGUAbgB0AFYAZQByAHMAaQBvAG4AXABFAHgAcABsAG8AcgBlAHIAXABIAGkAZABlAEQAZQBzAGsAdABvAHAASQBjAG8AbgBzAFwATgBlAHcAUwB0AGEAcgB0AFAAYQBuAGUAbAAnAAoAaQBmACgALQBuAG8AdAAgACgAVABlAHMAdAAtAFAAYQB0AGgAIAAkAGsAKQApAHsATgBlAHcALQBJAHQAZQBtACAALQBQAGEAdABoACAAJABrACAALQBGAG8AcgBjAGUAfABPAHUAdAAtAE4AdQBsAGwAfQAKACQAaQBkAHMAPQAnAHsANgA0ADUARgBGADAANAAwAC0ANQAwADgAMQAtADEAMAAxAEIALQA5AEYAMAA4AC0AMAAwAEEAQQAwADAAMgBGADkANQA0AEUAfQAnACwAJwB7ADIAMABEADAANABGAEUAMAAtADMAQQBFAEEALQAxADAANgA5AC0AQQAyAEQAOAAtADAAOAAwADAAMgBCADMAMAAzADAAOQBEAH0AJwAsACcAewBGADAAMgBDADEAQQAwAEQALQBCAEUAMgAxAC0ANAAzADUAMAAtADgAOABCADAALQA3ADMANgA3AEYAQwA5ADYARQBGADMAQwB9ACcALAAnAHsANQA5ADAAMwAxAEEANAA3AC0AMwBGADcAMgAtADQANABBADcALQA4ADkAQwA1AC0ANQA1ADkANQBGAEUANgBCADMAMABFAEUAfQAnACwAJwB7ADUAMwA5ADkARQA2ADkANAAtADYAQwBFADUALQA0AEQANgBDAC0AOABGAEMARQAtADEARAA4ADgANwAwAEYARABDAEIAQQAwAH0AJwAKAGYAbwByAGUAYQBjAGgAKAAkAGkAIABpAG4AIAAkAGkAZABzACkAewBTAGUAdAAtAEkAdABlAG0AUAByAG8AcABlAHIAdAB5ACAALQBQAGEAdABoACAAJABrACAALQBOAGEAbQBlACAAJABpACAALQBWAGEAbAB1AGUAIAAxACAALQBUAHkAcABlACAARABXAG8AcgBkAH0ACgAiAEEAdQBzAGcAZQBiAGwAZQBuAGQAZQB0ADoAIABQAGEAcABpAGUAcgBrAG8AcgBiACwAIABEAGkAZQBzAGUAcgAgAFAAQwAsACAATgBlAHQAegB3AGUAcgBrACwAIABCAGUAbgB1AHQAegBlAHIAZABhAHQAZQBpAGUAbgAsACAAUwB5AHMAdABlAG0AcwB0AGUAdQBlAHIAdQBuAGcAIgA=
echo.
echo   Zum Rueckgaengigmachen: Einstellungen -^> Personalisierung -^> Designs
echo   -^> "Desktopsymboleinstellungen" -^> Haekchen wieder setzen.

:kein_hide
echo.
echo   Aktualisiere Anzeige (Explorer wird kurz neu gestartet) ...
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 1 /nobreak >nul
start explorer.exe
timeout /t 3 /nobreak >nul
echo.
echo   ==========================================================
echo    FERTIG
echo   ==========================================================
echo.
echo   Auf dem Desktop liegt nur noch "Herunterfahren".
if exist "%ZIELORDNER%" echo   Sicherung: %ZIELORDNER%
echo.
pause
exit /b 0

:abbruch
echo.
echo   Abgebrochen - es wurde nichts geaendert.
echo.
pause
exit /b 0

:nichts_zu_tun
echo   Es liegen keine Verknuepfungen auf dem Desktop,
echo   die entfernt werden muessten.
echo.
pause
exit /b 0

rem ---------- Verknuepfungen im Ordner %1 sammeln ----------
:scannen
if not exist "%~1" exit /b
for /f "delims=" %%F in ('dir /b /a-d "%~1\*.lnk" "%~1\*.url" 2^>nul') do call :pruef "%~1\%%F"
exit /b

:pruef
set "FN=%~nx1"
echo %FN% | findstr /i /b "%BEHALTEN%" >nul
if not errorlevel 1 (
    echo    behalten : %FN%
    set /a BEHALTEN_N+=1
    exit /b
)
set /a N+=1
set "L!N!=%~1"
echo    entfernen: %FN%
exit /b
