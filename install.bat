@echo off
REM GaussianHaircut Windows 安装批处理脚本
REM 这个脚本会调用 PowerShell 脚本来安装依赖

echo ========================================
echo GaussianHaircut Windows Installer
echo ========================================
echo.
echo This script will install all dependencies.
echo Please make sure you have:
echo   1. CUDA 11.8 installed
echo   2. Anaconda/Miniconda installed
echo   3. Git for Windows installed
echo   4. Administrator privileges
echo.
pause

REM 检查 PowerShell 是否可用
where powershell >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: PowerShell not found!
    echo Please install PowerShell or run the .ps1 scripts directly.
    pause
    exit /b 1
)

REM 检查是否以管理员身份运行
net session >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo WARNING: This script should be run as Administrator!
    echo Some operations may fail without admin privileges.
    echo.
    pause
)

REM 运行 PowerShell 安装脚本
echo Running PowerShell installation script...
echo This may take 30-60 minutes depending on your internet speed.
echo.
powershell.exe -ExecutionPolicy Bypass -File "%~dp0install.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Installation failed with error code %ERRORLEVEL%
    echo Please check the error messages above.
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo ========================================
echo Installation completed successfully!
echo ========================================
echo.
echo Next steps:
echo   1. Edit setup_env.ps1 to set your paths
echo   2. Run: . .\setup_env.ps1
echo   3. Run: .\run.ps1
echo.
pause
