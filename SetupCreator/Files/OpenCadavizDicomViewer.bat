@echo off

set folderPath="C:\Program Files (x86)\CadavizDicomViewer"

echo **Preparing CADAVIZ DICOM VIEWER**
cd /d %folderPath%
if %errorlevel% neq 0 (
    echo Failed to change directory to %folderPath%. Ensure the path exists and is accessible.
    pause
    exit /B 1
)

echo Checking if Docker is running...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo Docker is not running. Starting Docker and accepting license...
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe" -AcceptLicense
    echo Waiting for Docker to start...
    timeout /t 10 /nobreak >nul
)

rem Wait for Docker to be fully operational
set maxRetries=5
set /a retries=0

:checkDocker
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo Docker is not ready yet. Waiting for it to initialize...
    set /a retries+=1
    if %retries% lss %maxRetries% (
        timeout /t 5 >nul
        goto checkDocker
    ) else (
        echo Docker failed to start after several attempts.
        pause
        exit /B 1
    )
)

echo Docker Subscription Service Agreement accepted.

echo Adding image "ohif_viewer"... 
//docker load -i ohif_viewer.tar
if %errorlevel% neq 0 (
    echo Failed to load "ohif_viewer.tar". Make sure the file exists in the folder.
    pause
    exit /B 1
)

echo Adding image "pacs"...
//docker load -i pacs.tar
if %errorlevel% neq 0 (
    echo Failed to load "pacs.tar". Make sure the file exists in the folder.
    pause
    exit /B 1
)

echo Running Docker...
docker-compose up
if %errorlevel% neq 0 (
    echo Failed to run Docker Compose. Make sure Docker and Docker Compose are installed and running.
    pause
    exit /B 1
)

rem If Docker Compose runs successfully, set registry key
echo Setting registry key for Cadaviz...
reg add "HKEY_CURRENT_USER\Software\ImmersiveLabz\Cadaviz" /v IsDockerReady /t REG_SZ /d "true" /f
if %errorlevel% neq 0 (
    echo Failed to set the registry key.
    pause
    exit /B 1
)

echo Operation completed successfully.
pause
exit /B
