@echo off
setlocal EnableExtensions
title Windows 11 - Herunterfahren KOMPLETT entfernen
rem ============================================================
rem  Kompletter Rueckbau des Pakets "Herunterfahren":
rem    [1/6] geplante Aufgabe "Windows11-Herunterfahren"
rem    [2/6] alle Verknuepfungen (Desktop, Taskleiste, Startmenue)
rem    [3/6] Programmordner %LOCALAPPDATA%\Herunterfahren
rem    [4/6] Temp-Reste des Pakets
rem    [5/6] Windows-Icon- und Thumbnail-Cache
rem    [6/6] Explorer neu starten
rem  Diese Datei enthaelt absichtlich keine Umlaute.
rem ============================================================

set "ZIEL=%LOCALAPPDATA%\Herunterfahren"
set "SKRIPTDIR=%~dp0"
set "AUFGABE=Windows11-Herunterfahren"
if not defined HF_SKRIPTDIR set "HF_SKRIPTDIR=%SKRIPTDIR%"

if defined HF_WEITER goto start_clean

echo.
echo   ==========================================================
echo    Windows 11 - Herunterfahren KOMPLETT entfernen
echo   ==========================================================
echo.
echo    Entfernt werden:
echo      - die geplante Aufgabe "Windows11-Herunterfahren"
echo      - alle Verknuepfungen (Desktop, Taskleiste, Startmenue)
echo      - Programmordner: %ZIEL%
echo      - Temp-Reste des Pakets
echo      - Windows-Icon- und Thumbnail-Cache
echo.

choice /c JN /n /t 30 /d N /m "   Wirklich alles entfernen? [J]a / [N]ein (30 Sekunden): "
if errorlevel 2 goto abbruch

if /i "%SKRIPTDIR%"=="%ZIEL%\" goto umzug
goto start_clean

:umzug
echo.
echo   Skript liegt im Programmordner und zieht kurz in den Temp-Ordner um,
echo   damit der Ordner restlos geloescht werden kann ...
copy /y "%~f0" "%TEMP%\hf-deinstallieren.cmd" >nul 2>&1
if not exist "%TEMP%\hf-deinstallieren.cmd" goto start_clean
set "HF_WEITER=1"
start "" "%TEMP%\hf-deinstallieren.cmd"
exit /b 0

:start_clean
echo.
echo   [1/6] Geplante Aufgabe entfernen ...
schtasks /query /tn %AUFGABE% >nul 2>&1
if errorlevel 1 goto tab_done
fltmc >nul 2>&1
if errorlevel 1 goto tab_elev
schtasks /delete /tn %AUFGABE% /f >nul 2>&1
goto tab_check

:tab_elev
echo         (kurze UAC-Abfrage, um die Aufgabe zu entfernen)
powershell -NoProfile -Command "try{Start-Process -FilePath 'cmd.exe' -ArgumentList '/c','schtasks /delete /tn %AUFGABE% /f' -Verb RunAs -Wait}catch{}"

:tab_check
schtasks /query /tn %AUFGABE% >nul 2>&1
if errorlevel 1 goto tab_ok
echo         Hinweis: Aufgabe besteht weiterhin. Manuell entfernen:
echo                  taskschd.msc -^> Aufgabenplanungsbibliothek -^> %AUFGABE%
goto tab_done

:tab_ok
echo         Aufgabe entfernt.
:tab_done

echo   [2/6] Verknuepfungen entfernen ...
powershell -NoProfile -ExecutionPolicy Bypass -EncodedCommand JABFAHIAcgBvAHIAQQBjAHQAaQBvAG4AUAByAGUAZgBlAHIAZQBuAGMAZQA9ACcAQwBvAG4AdABpAG4AdQBlACcACgAkAG4APQAwAAoAJABkAGkAcgBzAD0AQAAoACkACgB0AHIAeQB7ACQAdwA9AE4AZQB3AC0ATwBiAGoAZQBjAHQAIAAtAEMAbwBtAE8AYgBqAGUAYwB0ACAAVwBTAGMAcgBpAHAAdAAuAFMAaABlAGwAbAA7ACQAZAA9ACQAdwAuAFMAcABlAGMAaQBhAGwARgBvAGwAZABlAHIAcwAuAEkAdABlAG0AKAAnAEQAZQBzAGsAdABvAHAAJwApADsAaQBmACgAJABkACkAewAkAGQAaQByAHMAKwA9ACQAZAB9AH0AYwBhAHQAYwBoAHsAfQAKAHQAcgB5AHsAJABkAD0AWwBFAG4AdgBpAHIAbwBuAG0AZQBuAHQAXQA6ADoARwBlAHQARgBvAGwAZABlAHIAUABhAHQAaAAoACcARABlAHMAawB0AG8AcAAnACkAOwBpAGYAKAAkAGQAKQB7ACQAZABpAHIAcwArAD0AJABkAH0AfQBjAGEAdABjAGgAewB9AAoAdAByAHkAewAkAGQAPQBbAEUAbgB2AGkAcgBvAG4AbQBlAG4AdABdADoAOgBHAGUAdABGAG8AbABkAGUAcgBQAGEAdABoACgAJwBEAGUAcwBrAHQAbwBwAEQAaQByAGUAYwB0AG8AcgB5ACcAKQA7AGkAZgAoACQAZAApAHsAJABkAGkAcgBzACsAPQAkAGQAfQB9AGMAYQB0AGMAaAB7AH0ACgBpAGYAKAAkAGUAbgB2ADoAVQBTAEUAUgBQAFIATwBGAEkATABFACkAewAkAGQAaQByAHMAKwA9ACgASgBvAGkAbgAtAFAAYQB0AGgAIAAkAGUAbgB2ADoAVQBTAEUAUgBQAFIATwBGAEkATABFACAAJwBEAGUAcwBrAHQAbwBwACcAKQB9AAoAaQBmACgAJABlAG4AdgA6AFAAVQBCAEwASQBDACkAewAkAGQAaQByAHMAKwA9ACgASgBvAGkAbgAtAFAAYQB0AGgAIAAkAGUAbgB2ADoAUABVAEIATABJAEMAIAAnAEQAZQBzAGsAdABvAHAAJwApAH0ACgBmAG8AcgBlAGEAYwBoACgAJAB2ACAAaQBuACAAQAAoACQAZQBuAHYAOgBPAG4AZQBEAHIAaQB2AGUALAAkAGUAbgB2ADoATwBuAGUARAByAGkAdgBlAEMAbwBuAHMAdQBtAGUAcgAsACQAZQBuAHYAOgBPAG4AZQBEAHIAaQB2AGUAQwBvAG0AbQBlAHIAYwBpAGEAbAApACkAewBpAGYAKAAkAHYAKQB7ACQAZABpAHIAcwArAD0AKABKAG8AaQBuAC0AUABhAHQAaAAgACQAdgAgACcARABlAHMAawB0AG8AcAAnACkAfQB9AAoAaQBmACgAJABlAG4AdgA6AEEAUABQAEQAQQBUAEEAKQB7AAoAJABkAGkAcgBzACsAPQAoAEoAbwBpAG4ALQBQAGEAdABoACAAJABlAG4AdgA6AEEAUABQAEQAQQBUAEEAIAAnAE0AaQBjAHIAbwBzAG8AZgB0AFwASQBuAHQAZQByAG4AZQB0ACAARQB4AHAAbABvAHIAZQByAFwAUQB1AGkAYwBrACAATABhAHUAbgBjAGgAXABVAHMAZQByACAAUABpAG4AbgBlAGQAXABUAGEAcwBrAEIAYQByACcAKQAKACQAZABpAHIAcwArAD0AKABKAG8AaQBuAC0AUABhAHQAaAAgACQAZQBuAHYAOgBBAFAAUABEAEEAVABBACAAJwBNAGkAYwByAG8AcwBvAGYAdABcAFcAaQBuAGQAbwB3AHMAXABTAHQAYQByAHQAIABNAGUAbgB1AFwAUAByAG8AZwByAGEAbQBzACcAKQAKAH0ACgBpAGYAKAAkAGUAbgB2ADoAUAByAG8AZwByAGEAbQBEAGEAdABhACkAewAkAGQAaQByAHMAKwA9ACgASgBvAGkAbgAtAFAAYQB0AGgAIAAkAGUAbgB2ADoAUAByAG8AZwByAGEAbQBEAGEAdABhACAAJwBNAGkAYwByAG8AcwBvAGYAdABcAFcAaQBuAGQAbwB3AHMAXABTAHQAYQByAHQAIABNAGUAbgB1AFwAUAByAG8AZwByAGEAbQBzACcAKQB9AAoAaQBmACgAJABlAG4AdgA6AFUAUwBFAFIAUABSAE8ARgBJAEwARQApAHsAJABkAGkAcgBzACsAPQAkAGUAbgB2ADoAVQBTAEUAUgBQAFIATwBGAEkATABFAH0ACgBpAGYAKAAkAGUAbgB2ADoASABGAF8AUwBLAFIASQBQAFQARABJAFIAKQB7ACQAZABpAHIAcwArAD0AJABlAG4AdgA6AEgARgBfAFMASwBSAEkAUABUAEQASQBSAH0ACgAkAGQAaQByAHMAPQBAACgAJABkAGkAcgBzAHwAVwBoAGUAcgBlAC0ATwBiAGoAZQBjAHQAewAkAF8AfQB8AEYAbwByAEUAYQBjAGgALQBPAGIAagBlAGMAdAB7ACQAXwAuAFQAcgBpAG0ARQBuAGQAKAAnAFwAJwApAH0AfABTAG8AcgB0AC0ATwBiAGoAZQBjAHQAIAAtAFUAbgBpAHEAdQBlACkACgBmAG8AcgBlAGEAYwBoACgAJABkACAAaQBuACAAJABkAGkAcgBzACkAewAKAGkAZgAoAFQAZQBzAHQALQBQAGEAdABoACAALQBMAGkAdABlAHIAYQBsAFAAYQB0AGgAIAAkAGQAKQB7AAoAZgBvAHIAZQBhAGMAaAAoACQAZgAgAGkAbgAgAEAAKAAnAEgAZQByAHUAbgB0AGUAcgBmAGEAaAByAGUAbgAuAGwAbgBrACcALAAnAEgAZQByAHUAbgB0AGUAcgBmAGEAaAByAGUAbgAgACoALgBsAG4AawAnACkAKQB7AAoARwBlAHQALQBDAGgAaQBsAGQASQB0AGUAbQAgAC0ATABpAHQAZQByAGEAbABQAGEAdABoACAAJABkACAALQBGAGkAbAB0AGUAcgAgACQAZgAgAC0ARgBpAGwAZQAgAC0ARQByAHIAbwByAEEAYwB0AGkAbwBuACAAUwBpAGwAZQBuAHQAbAB5AEMAbwBuAHQAaQBuAHUAZQAgAHwAIABGAG8AcgBFAGEAYwBoAC0ATwBiAGoAZQBjAHQAIAB7AAoAdAByAHkAewBSAGUAbQBvAHYAZQAtAEkAdABlAG0AIAAtAEwAaQB0AGUAcgBhAGwAUABhAHQAaAAgACQAXwAuAEYAdQBsAGwATgBhAG0AZQAgAC0ARgBvAHIAYwBlACAALQBFAHIAcgBvAHIAQQBjAHQAaQBvAG4AIABTAHQAbwBwADsAJwAgACAAZwBlAGwAbwBlAHMAYwBoAHQAOgAgACcAKwAkAF8ALgBGAHUAbABsAE4AYQBtAGUAOwAkAG4AKwArAH0ACgBjAGEAdABjAGgAewAnACAAIABnAGUAcwBwAGUAcgByAHQAOgAgACcAKwAkAF8ALgBGAHUAbABsAE4AYQBtAGUAfQAKAH0ACgB9AAoAfQAKAH0ACgAnACAAIABWAGUAcgBrAG4AdQBlAHAAZgB1AG4AZwBlAG4AIABlAG4AdABmAGUAcgBuAHQAOgAgACcAKwAkAG4ACgBpAGYAKAAkAG4AIAAtAGUAcQAgADAAKQB7ACcAIAAgACgAawBlAGkAbgBlACAAZwBlAGYAdQBuAGQAZQBuACAALQAgAG8AawApACcAfQAKAGUAeABpAHQAIAAwAA==

echo   [3/6] Programmordner entfernen ...
rd /s /q "%ZIEL%" >nul 2>&1

echo   [4/6] Temp-Reste des Pakets entfernen ...
del /f /q "%TEMP%\hf_*.b64" >nul 2>&1
del /f /q "%TEMP%\hf-*.cmd" >nul 2>&1
del /f /q "%TEMP%\hf-elev.*" >nul 2>&1

echo   [5/6] Icon- und Thumbnail-Cache loeschen ...
del /f /q "%LOCALAPPDATA%\IconCache.db" >nul 2>&1
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\iconcache*.db" >nul 2>&1
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache*.db" >nul 2>&1
ie4uinit.exe -show >nul 2>&1

echo   [6/6] Explorer neu starten ...
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 1 /nobreak >nul
start explorer.exe
timeout /t 3 /nobreak >nul

echo.
echo   ==========================================================
echo    FERTIG - alles entfernt.
echo   ==========================================================
echo.
if exist "%ZIEL%" echo    Hinweis: Ordner liess sich nicht komplett loeschen:
if exist "%ZIEL%" echo             %ZIEL%
echo    Naechster Schritt fuer einen frischen Aufbau:
echo.
echo      1. Dieses Fenster schliessen
echo      2. "Installieren.cmd" doppelklicken
echo.
echo    Danach ist die Verknuepfung neu angelegt, die Aufgabe
echo    eingerichtet und Windows zeichnet das Icon frisch.
echo.
pause
if defined HF_WEITER exit
exit /b 0

:abbruch
echo.
echo   Abgebrochen - es wurde nichts geloescht.
echo.
pause
exit /b 0
