@echo off
rem ============================================================================
rem  DSH fallback launcher - port 3081
rem
rem  PURPOSE: start a minimal dsh (fallback profile, no user plugins) on port
rem          3081 when the main process (3080) cannot start.
rem
rem  PORTABLE: auto-detects the dsh binary and the data dir. If detection
rem  fails, edit the two lines below (remove "rem" and fill your paths):
rem    set "DSH_BIN_OVERRIDE=C:\path\to\dsh.cmd"
rem    set "DSH_HOME_OVERRIDE=C:\path\to\dsh-data"
rem
rem  NOTE: keep this file in GBK/ANSI encoding (do NOT save as UTF-8).
rem ============================================================================
title DSH Backup Entry (3081)

setlocal enabledelayedexpansion

rem --- locate dsh: override > PATH > common install locations -----------------
set "DSH_BIN_OVERRIDE="
if defined DSH_BIN_OVERRIDE (
  set "DSH_BIN=%DSH_BIN_OVERRIDE%"
) else (
  where dsh >nul 2>nul
  if errorlevel 1 (
    if exist "%USERPROFILE%\AppData\Roaming\npm\dsh.cmd" set "DSH_BIN=%USERPROFILE%\AppData\Roaming\npm\dsh.cmd"
    if not defined DSH_BIN if exist "%ProgramFiles%\harness\npm\global\dsh.cmd" set "DSH_BIN=%ProgramFiles%\harness\npm\global\dsh.cmd"
    if not defined DSH_BIN if exist "%LOCALAPPDATA%\Programs\harness\npm\global\dsh.cmd" set "DSH_BIN=%LOCALAPPDATA%\Programs\harness\npm\global\dsh.cmd"
    if not defined DSH_BIN (
      echo [ERROR] dsh not found. Install dsh or set DSH_BIN_OVERRIDE.
      pause
      exit /b 1
    )
  ) else (
    set "DSH_BIN=dsh"
  )
)

rem --- locate data dir: override > env DSH_HOME > default ~/.dsh --------------
set "DSH_HOME_OVERRIDE="
if defined DSH_HOME_OVERRIDE (
  set "DSH_HOME=%DSH_HOME_OVERRIDE%"
) else if defined DSH_HOME (
  rem keep caller's DSH_HOME
) else if exist "%USERPROFILE%\.dsh" (
  set "DSH_HOME=%USERPROFILE%\.dsh"
) else (
  echo [WARN] no DSH_HOME detected, using default
  set "DSH_HOME=%USERPROFILE%\.dsh"
)

echo ============================================================
echo   DSH Backup Entry
echo   - Port:  3081
echo   - Profile: fallback (built-in only, no user plugins)
echo   - Data:  %DSH_HOME%
echo   - Bin:   %DSH_BIN%
echo   - Use: when main process 3080 cannot start
echo ============================================================
echo.

call "%DSH_BIN%" --profile fallback --port 3081

if errorlevel 1 (
  echo.
  echo [ERROR] startup failed (exit code %errorlevel%)
  echo Possible causes:
  echo   - port 3081 in use: change port or close the program
  echo   - fallback profile missing: run
  echo       "dsh plugin --profile fallback add @deepseek-ai/dsh-base @deepseek-ai/dsh-web-app"
  echo   - data dir broken: see 00-restore-guide.md in the backup folder
  pause
)