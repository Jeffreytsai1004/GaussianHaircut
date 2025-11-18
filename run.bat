@echo off
REM GaussianHaircut Windows 批处理启动脚本
REM 这个脚本会调用 PowerShell 脚本来运行重建流程

echo ========================================
echo GaussianHaircut Windows Launcher
echo ========================================
echo.

REM 检查 PowerShell 是否可用
where powershell >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: PowerShell not found!
    echo Please install PowerShell or run the .ps1 scripts directly.
    pause
    exit /b 1
)

REM 运行 PowerShell 脚本
echo Running PowerShell script...
echo.
powershell.exe -ExecutionPolicy Bypass -File "%~dp0run.ps1" %*

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Script execution failed with error code %ERRORLEVEL%
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo ========================================
echo Script completed successfully!
echo ========================================
pause
