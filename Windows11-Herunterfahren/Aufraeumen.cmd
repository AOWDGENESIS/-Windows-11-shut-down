@echo off
setlocal EnableExtensions
title Windows 11 - System-Aufraeumen und Herunterfahren
rem ============================================================
rem  Laeuft automatisch MIT ADMINISTRATORRECHTEN, gestartet von
rem  der geplanten Aufgabe "Windows11-Herunterfahren"
rem  (angelegt durch Installieren.cmd bzw. Aufgabe-anlegen.cmd).
rem
rem  Raeumt ALLE Temp-/Cache-Ordner des Systems auf und faehrt
rem  danach Windows sauber herunter. Kein Zwangs-Beenden (/f).
rem
rem  Diese Datei enthaelt absichtlich keine Umlaute.
rem ============================================================

rem  1 = aufraeumen,  0 = ueberspringen
set "UPDATE_CACHE=1"     rem  Windows-Update-Downloads
set "PAPIERKORB=0"       rem  Papierkorb leeren (kein Temp - Standard aus)

fltmc >nul 2>&1
if errorlevel 1 goto ohne_rechte

echo.
echo   ==================================================
echo    System-Aufraeumen + Herunterfahren (Administrator)
echo   ==================================================
echo.

echo   - Temp des angemeldeten Benutzers ...
call :leer "%TEMP%"

echo   - Temp und Caches aller Benutzerprofile ...
for /d %%U in ("%SystemDrive%\Users\*") do call :profil "%%~fU"

echo   - Windows-Temp ...
call :leer "%SystemRoot%\Temp"

echo   - Fehlerberichte (systemweit) ...
call :leer "%ProgramData%\Microsoft\Windows\WER"

echo   - Absturz-Abbilder (systemweit) ...
call :leer "%ProgramData%\Microsoft\Windows\WER\ReportQueue"

if "%UPDATE_CACHE%"=="1" if exist "%SystemRoot%\SoftwareDistribution\Download" (
    echo   - Windows-Update-Downloads ...
    call :leer "%SystemRoot%\SoftwareDistribution\Download"
)

if "%PAPIERKORB%"=="1" (
    echo   - Papierkorb ...
    powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
)

echo.
echo   Aufraeumen beendet - Windows wird jetzt heruntergefahren.
echo.
shutdown /s /t 0
exit /b 0

rem ---- Ein Benutzerprofil aufraeumen ----
:profil
set "UN=%~nx1"
if /i "%UN%"=="Public" exit /b
if /i "%UN%"=="Default" exit /b
if /i "%UN%"=="Default User" exit /b
if /i "%UN%"=="All Users" exit /b
if /i "%UN%"=="defaultuser0" exit /b
if not exist "%~1\AppData\Local" exit /b
call :leer "%~1\AppData\Local\Temp"
call :leer "%~1\AppData\Local\CrashDumps"
call :leer "%~1\AppData\Local\Microsoft\Windows\WER"
call :leer "%~1\AppData\Local\Microsoft\Windows\INetCache"
exit /b

rem ---- Ordnerinhalt loeschen (best effort) ----
:leer
if not exist "%~1" exit /b
del /f /s /q "%~1\*.*" >nul 2>&1
for /d %%D in ("%~1\*") do rd /s /q "%%~D" >nul 2>&1
exit /b

:ohne_rechte
echo.
echo   FEHLER: Dieses Skript benoetigt Administratorrechte.
echo.
echo   Richtig starten:
echo     - ueber die Desktop-Verknuepfung "Herunterfahren"
echo       (dann laeuft es automatisch mit Adminrechten), oder
echo     - "Aufgabe-anlegen.cmd" per Rechtsklick als Administrator
echo       ausfuehren, um die geplante Aufgabe einzurichten.
echo.
pause
exit /b 1
