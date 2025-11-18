# GaussianHaircut 环境变量设置脚本
# 使用方法: . .\setup_env.ps1

Write-Host "=== 设置 GaussianHaircut 环境变量 ===" -ForegroundColor Green

# 项目根目录（当前脚本所在目录）
$env:PROJECT_DIR = $PSScriptRoot
Write-Host "PROJECT_DIR = $env:PROJECT_DIR" -ForegroundColor Cyan

# Blender 可执行文件路径（请根据实际安装路径修改）
$env:BLENDER_DIR = "C:\Program Files\Blender Foundation\Blender 3.6\blender.exe"
Write-Host "BLENDER_DIR = $env:BLENDER_DIR" -ForegroundColor Cyan

# 数据路径（请修改为您的场景文件夹路径）
# 示例: $env:DATA_PATH = "E:\Data\my_haircut_scene"
$env:DATA_PATH = ""
if ($env:DATA_PATH -eq "") {
    Write-Host "WARNING: DATA_PATH 未设置！" -ForegroundColor Yellow
    Write-Host "请编辑 setup_env.ps1 文件，设置 DATA_PATH 变量" -ForegroundColor Yellow
    Write-Host "或者手动设置: `$env:DATA_PATH = 'C:\path\to\your\scene'" -ForegroundColor Yellow
} else {
    Write-Host "DATA_PATH = $env:DATA_PATH" -ForegroundColor Cyan
}

Write-Host "`n环境变量设置完成！" -ForegroundColor Green
Write-Host "运行重建: .\run.ps1" -ForegroundColor Cyan
