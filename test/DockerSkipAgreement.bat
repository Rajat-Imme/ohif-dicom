@echo off

:: Set the path to Docker Desktop executable
set "dockerDesktopPath=C:\Program Files\Docker\Docker\Docker Desktop.exe"

:: Run Docker Desktop with --accept-license to skip the subscription agreement screen
"%dockerDesktopPath%" --accept-license

:: Wait for Docker to start (optional)
echo Waiting for Docker to start...
timeout /t 10

:: Check if Docker is running
docker info >nul 2>&1
if %errorlevel%==0 (
    echo Docker is running.
) else (
    echo Docker failed to start.
)

pause
