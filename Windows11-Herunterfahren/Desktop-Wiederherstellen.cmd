@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Windows 11 - Desktop-Verknuepfungen zurueckholen
rem ============================================================
rem  Holt die Verknuepfungen aus dem neuesten Sicherungsordner
rem  (Desktop-Sicherung-DATUM) zurueck auf den Desktop.
rem  Diese Datei enthaelt absichtlich keine Umlaute.
rem ============================================================

set "SICHER=%USERPROFILE%\Desktop-Sicherung"

echo.
echo   ==========================================================
echo    Desktop-Verknuepfungen zurueckholen
echo   ==========================================================
echo.

if not exist "%SICHER%" goto keine_sicherung

set "NEUESTE="
for /f "delims=" %%D in ('dir /b /ad /o-n "%SICHER%" 2^>nul') do if not defined NEUESTE set "NEUESTE=%SICHER%\%%D"
if not defined NEUESTE goto keine_sicherung

echo   Neuester Sicherungsordner:
echo   %NEUESTE%
echo.
dir /b /a-d "%NEUESTE%\*.lnk" "%NEUESTE%\*.url" 2^>nul
echo.

choice /c JN /n /t 30 /d N /m "   Diese Verknuepfungen zurueck auf den Desktop holen? [J]a/[N]ein (30s): "
if errorlevel 2 goto abbruch

set "DESKTOP="
for /f "usebackq delims=" %%D in (`powershell -NoProfile -ExecutionPolicy Bypass -EncodedCommand JABkAD0AQAAoACkACgB0AHIAeQB7ACQAZAArAD0AKABOAGUAdwAtAE8AYgBqAGUAYwB0ACAALQBDAG8AbQBPAGIAagBlAGMAdAAgAFcAUwBjAHIAaQBwAHQALgBTAGgAZQBsAGwAKQAuAFMAcABlAGMAaQBhAGwARgBvAGwAZABlAHIAcwAuAEkAdABlAG0AKAAnAEQAZQBzAGsAdABvAHAAJwApAH0AYwBhAHQAYwBoAHsAfQAKAHQAcgB5AHsAJABkACsAPQBbAEUAbgB2AGkAcgBvAG4AbQBlAG4AdABdADoAOgBHAGUAdABGAG8AbABkAGUAcgBQAGEAdABoACgAJwBEAGUAcwBrAHQAbwBwACcAKQB9AGMAYQB0AGMAaAB7AH0ACgBpAGYAKAAkAGUAbgB2ADoAVQBTAEUAUgBQAFIATwBGAEkATABFACkAewAkAGQAKwA9ACgASgBvAGkAbgAtAFAAYQB0AGgAIAAkAGUAbgB2ADoAVQBTAEUAUgBQAFIATwBGAEkATABFACAAJwBEAGUAcwBrAHQAbwBwACcAKQB9AAoAZgBvAHIAZQBhAGMAaAAoACQAdgAgAGkAbgAgAEAAKAAkAGUAbgB2ADoATwBuAGUARAByAGkAdgBlACwAJABlAG4AdgA6AE8AbgBlAEQAcgBpAHYAZQBDAG8AbgBzAHUAbQBlAHIALAAkAGUAbgB2ADoATwBuAGUARAByAGkAdgBlAEMAbwBtAG0AZQByAGMAaQBhAGwAKQApAHsAaQBmACgAJAB2ACkAewAkAGQAKwA9ACgASgBvAGkAbgAtAFAAYQB0AGgAIAAkAHYAIAAnAEQAZQBzAGsAdABvAHAAJwApAH0AfQAKAGkAZgAoACQAZQBuAHYAOgBQAFUAQgBMAEkAQwApAHsAJABkACsAPQAoAEoAbwBpAG4ALQBQAGEAdABoACAAJABlAG4AdgA6AFAAVQBCAEwASQBDACAAJwBEAGUAcwBrAHQAbwBwACcAKQB9AAoAJABkAHwAVwBoAGUAcgBlAC0ATwBiAGoAZQBjAHQAewAkAF8AfQB8AEYAbwByAEUAYQBjAGgALQBPAGIAagBlAGMAdAB7ACQAXwAuAFQAcgBpAG0ARQBuAGQAKAAnAFwAJwApAH0AfABTAG8AcgB0AC0ATwBiAGoAZQBjAHQAIAAtAFUAbgBpAHEAdQBlAHwAVwBoAGUAcgBlAC0ATwBiAGoAZQBjAHQAewBUAGUAcwB0AC0AUABhAHQAaAAgAC0ATABpAHQAZQByAGEAbABQAGEAdABoACAAJABfAH0A`) do if not defined DESKTOP set "DESKTOP=%%D"
if not defined DESKTOP set "DESKTOP=%USERPROFILE%\Desktop"

set "G=0"
for %%F in ("%NEUESTE%\*.lnk") do if exist "%%~fF" ( move /y "%%~fF" "%DESKTOP%\" >nul 2>&1 & if not errorlevel 1 set /a G+=1 )
for %%F in ("%NEUESTE%\*.url") do if exist "%%~fF" ( move /y "%%~fF" "%DESKTOP%\" >nul 2>&1 & if not errorlevel 1 set /a G+=1 )

ie4uinit.exe -show >nul 2>&1
echo.
echo   %G% Verknuepfung(en) zurueckgeholt nach:
echo   %DESKTOP%
echo.
pause
exit /b 0

:keine_sicherung
echo   Kein Sicherungsordner gefunden:
echo   %SICHER%
echo.
pause
exit /b 1

:abbruch
echo.
echo   Abgebrochen - es wurde nichts geaendert.
echo.
pause
exit /b 0
