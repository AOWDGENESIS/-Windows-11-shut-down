@echo off
setlocal EnableExtensions
title Windows 11 - Herunterfahren
rem ============================================================
rem  Ziel der Desktop-Verknuepfung.
rem
rem  Ablauf: startet die geplante Aufgabe "Windows11-Herunterfahren".
rem  Diese laeuft automatisch mit Administratorrechten, raeumt ALLE
rem  Temp-Ordner auf (auch C:\Windows\Temp und die Temp-Ordner
rem  aller Benutzer) und faehrt danach Windows sauber herunter.
rem
rem  Ist die Aufgabe nicht eingerichtet, wird ersatzweise der
rem  Benutzer-Temp geleert (ohne Adminrechte) - Hinweis dazu siehe
rem  Aufgabe-anlegen.cmd.
rem
rem  Diese Datei enthaelt absichtlich keine Umlaute.
rem ============================================================

echo.
echo   ============================================
echo    Windows 11 - Herunterfahren mit Aufraeumen
echo   ============================================
echo.

schtasks /query /tn Windows11-Herunterfahren >nul 2>&1
if errorlevel 1 goto ohne_aufgabe

echo   Starte das Aufraeumen mit Administratorrechten ...
schtasks /run /tn Windows11-Herunterfahren >nul 2>&1
if errorlevel 1 goto ohne_aufgabe

echo.
echo   Laeuft: Es oeffnet sich ein Fenster mit dem Fortschritt.
echo   Danach faehrt Windows automatisch herunter.
echo.
timeout /t 4 /nobreak >nul
exit /b 0

:ohne_aufgabe
echo   Hinweis: Die System-Aufgabe ist nicht eingerichtet.
echo   Es wird nur der Benutzer-Temp geleert (ohne Adminrechte).
echo.
echo   Einmalig nachholen fuer das komplette Aufraeumen:
echo     Rechtsklick auf "Aufgabe-anlegen.cmd" -^> "Als Administrator ausfuehren"
echo.
call :leer "%TEMP%"
call :leer "%LOCALAPPDATA%\Microsoft\Windows\INetCache"
call :leer "%LOCALAPPDATA%\Microsoft\Windows\WER"
call :leer "%LOCALAPPDATA%\CrashDumps"
echo.
echo   Windows wird heruntergefahren ...
shutdown /s /t 0
exit /b 0

rem ---- Ordnerinhalt loeschen (best effort) ----
:leer
if not exist "%~1" exit /b
del /f /s /q "%~1\*.*" >nul 2>&1
for /d %%D in ("%~1\*") do rd /s /q "%%~D" >nul 2>&1
exit /b
