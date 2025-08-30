@echo off
REM AutoPPTGenerator Start Script for Windows
REM This script handles starting the Flask application with proper error handling

setlocal enabledelayedexpansion

REM Project paths
set PROJECT_DIR=%~dp0
set VENV_PATH=%PROJECT_DIR%.venv
set PYTHON_PATH=%VENV_PATH%\Scripts\python.exe
set APP_FILE=%PROJECT_DIR%app.py
set LOG_FILE=%PROJECT_DIR%app.log
set PID_FILE=%PROJECT_DIR%app.pid

REM Function to print status messages
:print_status
echo [INFO] %~1
goto :eof

:print_success
echo [SUCCESS] %~1
goto :eof

:print_warning
echo [WARNING] %~1
goto :eof

:print_error
echo [ERROR] %~1
goto :eof

REM Function to check if app is running
:is_running
if exist "%PID_FILE%" (
    set /p pid=<"%PID_FILE%"
    tasklist /FI "PID eq !pid!" 2>nul | find /I "!pid!" >nul
    if !errorlevel! equ 0 (
        exit /b 0
    ) else (
        del "%PID_FILE%" 2>nul
        exit /b 1
    )
)
exit /b 1

REM Function to start the application
:start_app
call :print_status "Starting AutoPPTGenerator..."

REM Check if already running
call :is_running
if !errorlevel! equ 0 (
    call :print_warning "Application is already running"
    call :print_status "Local access: http://localhost:7777"
    call :print_status "Remote access: http://84.247.184.189:7777"
    goto :eof
)

REM Change to project directory
cd /d "%PROJECT_DIR%"

REM Check if virtual environment exists
if not exist "%PYTHON_PATH%" (
    call :print_error "Virtual environment not found at %VENV_PATH%"
    call :print_status "Please run: python -m venv .venv && .venv\Scripts\activate && pip install -r requirements.txt"
    goto :eof
)

REM Check if app.py exists
if not exist "%APP_FILE%" (
    call :print_error "Application file not found at %APP_FILE%"
    goto :eof
)

REM Create necessary directories
if not exist "uploads" mkdir uploads
if not exist "generated" mkdir generated

REM Start the application
call :print_status "Starting Flask application..."
start /B "AutoPPTGenerator" "%PYTHON_PATH%" app.py > "%LOG_FILE%" 2>&1

REM Get the PID (this is approximate for Windows)
for /f "tokens=2" %%i in ('tasklist /FI "WINDOWTITLE eq AutoPPTGenerator*" /FO CSV ^| find /V "PID"') do (
    echo %%~i > "%PID_FILE%"
    goto :found_pid
)
:found_pid

timeout /t 2 /nobreak >nul

call :print_success "AutoPPTGenerator started successfully!"
call :print_success "Local access: http://localhost:7777"
call :print_success "Remote access: http://84.247.184.189:7777"
call :print_status "Logs are being written to: %LOG_FILE%"
call :print_status "To stop the application, run: start.bat stop"
goto :eof

REM Function to stop the application
:stop_app
call :print_status "Stopping AutoPPTGenerator..."

call :is_running
if !errorlevel! equ 0 (
    set /p pid=<"%PID_FILE%"
    call :print_status "Stopping process with PID: !pid!"
    taskkill /PID !pid! /F >nul 2>&1
    del "%PID_FILE%" 2>nul
    call :print_success "Application stopped successfully"
) else (
    call :print_warning "Application is not running"
)
goto :eof

REM Function to show status
:show_status
call :is_running
if !errorlevel! equ 0 (
    set /p pid=<"%PID_FILE%"
    call :print_success "AutoPPTGenerator is running (PID: !pid!)"
    call :print_status "Local access: http://localhost:7777"
    call :print_status "Remote access: http://84.247.184.189:7777"
    call :print_status "Log file: %LOG_FILE%"
) else (
    call :print_warning "AutoPPTGenerator is not running"
)
goto :eof

REM Function to show help
:show_help
echo AutoPPTGenerator Management Script for Windows
echo.
echo Usage: %~nx0 {start^|stop^|restart^|status^|help}
echo.
echo Commands:
echo   start   - Start the AutoPPTGenerator application
echo   stop    - Stop the AutoPPTGenerator application
echo   restart - Restart the AutoPPTGenerator application
echo   status  - Show application status
echo   help    - Show this help message
echo.
echo Examples:
echo   %~nx0 start
echo   %~nx0 status
goto :eof

REM Main script logic
if "%1"=="" set "command=start"
if not "%1"=="" set "command=%1"

if "%command%"=="start" (
    call :start_app
) else if "%command%"=="stop" (
    call :stop_app
) else if "%command%"=="restart" (
    call :stop_app
    timeout /t 2 /nobreak >nul
    call :start_app
) else if "%command%"=="status" (
    call :show_status
) else if "%command%"=="help" (
    call :show_help
) else (
    call :print_error "Unknown command: %command%"
    call :show_help
)
