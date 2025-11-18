# GaussianHaircut Windows Installation Script
# Prerequisites:
#
# 1. Install CUDA 11.8
#    Follow instructions on https://developer.nvidia.com/cuda-11-8-0-download-archive
#    Make sure that CUDA_PATH environment variable is set
#    The environment was tested only with this CUDA version
#
# 2. Install Blender 3.6 to create strand visualizations
#    Follow instructions on https://www.blender.org/download/lts/3-6
#
# 3. Install Git for Windows (https://git-scm.com/download/win)
#
# 4. Install Anaconda or Miniconda (https://docs.conda.io/en/latest/miniconda.html)
#
# 5. Run this script in PowerShell with Administrator privileges

# Enable error handling
$ErrorActionPreference = "Stop"

Write-Host "=== GaussianHaircut Windows Installation ===" -ForegroundColor Green

# Save parent directory
$PROJECT_DIR = $PWD.Path
Write-Host "Project directory: $PROJECT_DIR" -ForegroundColor Cyan

# Initialize conda for PowerShell
Write-Host "`nInitializing Conda..." -ForegroundColor Yellow
conda init powershell
# Refresh environment
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Pull all external libraries
Write-Host "`nCloning external libraries..." -ForegroundColor Yellow
if (-not (Test-Path "ext")) {
    New-Item -ItemType Directory -Path "ext"
}

# Clone OpenPose
Write-Host "Cloning OpenPose..." -ForegroundColor Cyan
Set-Location "$PROJECT_DIR\ext"
if (-not (Test-Path "openpose")) {
    git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose --depth 1
    Set-Location "$PROJECT_DIR\ext\openpose"
    git submodule update --init --recursive --remote
}

# Clone Matte-Anything
Write-Host "Cloning Matte-Anything..." -ForegroundColor Cyan
Set-Location "$PROJECT_DIR\ext"
if (-not (Test-Path "Matte-Anything")) {
    git clone https://github.com/hustvl/Matte-Anything
    Set-Location "$PROJECT_DIR\ext\Matte-Anything"
    git clone https://github.com/IDEA-Research/GroundingDINO.git
}

# Clone NeuralHaircut
Write-Host "Cloning NeuralHaircut..." -ForegroundColor Cyan
Set-Location "$PROJECT_DIR\ext"
if (-not (Test-Path "NeuralHaircut")) {
    # Note: SSH clone may not work on Windows, using HTTPS instead
    git clone https://github.com/egorzakharov/NeuralHaircut.git --recursive
}

# Clone PyTorch3D
Write-Host "Cloning PyTorch3D..." -ForegroundColor Cyan
Set-Location "$PROJECT_DIR\ext"
if (-not (Test-Path "pytorch3d")) {
    git clone https://github.com/facebookresearch/pytorch3d
    Set-Location "$PROJECT_DIR\ext\pytorch3d"
    git checkout 2f11ddc5ee7d6bd56f2fb6744a16776fab6536f7
}

# Clone simple-knn
Write-Host "Cloning simple-knn..." -ForegroundColor Cyan
Set-Location "$PROJECT_DIR\ext"
if (-not (Test-Path "simple-knn")) {
    git clone https://github.com/camenduru/simple-knn
}

# Clone GLM for diff_gaussian_rasterization_hair
Write-Host "Cloning GLM..." -ForegroundColor Cyan
Set-Location "$PROJECT_DIR\ext\diff_gaussian_rasterization_hair\third_party"
if (-not (Test-Path "glm")) {
    git clone https://github.com/g-truc/glm
    Set-Location "$PROJECT_DIR\ext\diff_gaussian_rasterization_hair\third_party\glm"
    git checkout 5c46b9c07008ae65cb81ab79cd677ecc1934b903
}

# Clone Kaolin
Write-Host "Cloning Kaolin..." -ForegroundColor Cyan
Set-Location "$PROJECT_DIR\ext"
if (-not (Test-Path "kaolin")) {
    git clone --recursive https://github.com/NVIDIAGameWorks/kaolin
    Set-Location "$PROJECT_DIR\ext\kaolin"
    git checkout v0.15.0
}

# Clone hyperIQA
Write-Host "Cloning hyperIQA..." -ForegroundColor Cyan
Set-Location "$PROJECT_DIR\ext"
if (-not (Test-Path "hyperIQA")) {
    git clone https://github.com/SSL92/hyperIQA
}

# Install main environment
Write-Host "`nCreating main conda environment..." -ForegroundColor Yellow
Set-Location $PROJECT_DIR

# 检查是否存在 Windows 优化版本的环境配置
if (Test-Path "environment_windows.yml") {
    Write-Host "使用 Windows 优化版本: environment_windows.yml" -ForegroundColor Cyan
    conda env create -f environment_windows.yml
} else {
    Write-Host "使用原始版本: environment.yml" -ForegroundColor Yellow
    Write-Host "注意: 原始版本包含 Linux 特定依赖，可能需要手动调整" -ForegroundColor Yellow
    conda env create -f environment.yml
}

Write-Host "`nActivating gaussian_splatting_hair environment..." -ForegroundColor Yellow
conda activate gaussian_splatting_hair

# Download Neural Haircut files
Write-Host "`nDownloading Neural Haircut pretrained models..." -ForegroundColor Yellow
Set-Location "$PROJECT_DIR\ext\NeuralHaircut"
gdown --folder https://drive.google.com/drive/folders/1TCdJ0CKR3Q6LviovndOkJaKm8S1T9F_8

Set-Location "$PROJECT_DIR\ext\NeuralHaircut\pretrained_models\diffusion_prior"
gdown 1_9EOUXHayKiGH5nkrayncln3d6m1uV7f

Set-Location "$PROJECT_DIR\ext\NeuralHaircut\PIXIE"
gdown 1mPcGu62YPc4MdkT8FFiOCP629xsENHZf
tar -xvzf pixie_data.tar.gz
Remove-Item pixie_data.tar.gz

Set-Location "$PROJECT_DIR\ext\hyperIQA"
if (-not (Test-Path "pretrained")) {
    New-Item -ItemType Directory -Path "pretrained"
}
Set-Location "$PROJECT_DIR\ext\hyperIQA\pretrained"
gdown 1OOUmnbvpGea0LIGpIWEbOyxfWx6UCiiE

Set-Location $PROJECT_DIR

# Create Matte-Anything environment
Write-Host "`nCreating Matte-Anything environment..." -ForegroundColor Yellow
conda create -y -n matte_anything `
    pytorch=2.0.0 pytorch-cuda=11.8 torchvision tensorboard timm=0.5.4 opencv=4.5.3 `
    mkl=2024.0 setuptools=58.2.0 easydict wget scikit-image gradio=3.46.1 fairscale `
    -c pytorch -c nvidia -c conda-forge

conda deactivate
conda activate matte_anything

pip install git+https://github.com/facebookresearch/segment-anything.git
python -m pip install 'git+https://github.com/facebookresearch/detectron2.git'

Set-Location "$PROJECT_DIR\ext\Matte-Anything\GroundingDINO"
pip install -e .
pip install supervision==0.22.0

Set-Location "$PROJECT_DIR\ext\Matte-Anything"
if (-not (Test-Path "pretrained")) {
    New-Item -ItemType Directory -Path "pretrained"
}
Set-Location "$PROJECT_DIR\ext\Matte-Anything\pretrained"

# Download pretrained models
Invoke-WebRequest -Uri "https://dl.fbaipublicfiles.com/segment_anything/sam_vit_h_4b8939.pth" -OutFile "sam_vit_h_4b8939.pth"
Invoke-WebRequest -Uri "https://github.com/IDEA-Research/GroundingDINO/releases/download/v0.1.0-alpha/groundingdino_swint_ogc.pth" -OutFile "groundingdino_swint_ogc.pth"

conda deactivate
conda activate gaussian_splatting_hair
gdown 1d97oKuITCeWgai2Tf3iNilt6rMSSYzkW

# OpenPose (Note: Building OpenPose on Windows requires Visual Studio)
Write-Host "`nNote: OpenPose compilation on Windows requires Visual Studio 2019 or later" -ForegroundColor Yellow
Write-Host "Please refer to OpenPose documentation for Windows build instructions:" -ForegroundColor Yellow
Write-Host "https://github.com/CMU-Perceptual-Computing-Lab/openpose/blob/master/doc/installation/0_index.md#windows" -ForegroundColor Yellow

Set-Location "$PROJECT_DIR\ext\openpose"
gdown 1Yn03cKKfVOq4qXmgBMQD20UMRRRkd_tV
tar -xvzf models.tar.gz
Remove-Item models.tar.gz

# PIXIE environment
Write-Host "`nCreating PIXIE environment..." -ForegroundColor Yellow
Set-Location "$PROJECT_DIR\ext"
if (-not (Test-Path "PIXIE")) {
    git clone https://github.com/yfeng95/PIXIE
}

Set-Location "$PROJECT_DIR\ext\PIXIE"
# On Windows, we need to manually download the models
Write-Host "Downloading PIXIE models..." -ForegroundColor Cyan
# The fetch_model.sh script needs to be adapted for Windows or models downloaded manually

conda create -y -n pixie-env python=3.8 pytorch==2.0.0 torchvision==0.15.0 torchaudio==2.0.0 `
    pytorch-cuda=11.8 fvcore pytorch3d==0.7.5 kornia matplotlib `
    -c pytorch -c nvidia -c fvcore -c conda-forge -c pytorch3d

conda activate pixie-env
pip install pyyaml==5.4.1
pip install git+https://github.com/1adrianb/face-alignment.git@54623537fd9618ca7c15688fd85aba706ad92b59

conda deactivate

Write-Host "`n=== Installation Complete ===" -ForegroundColor Green
Write-Host "`nIMPORTANT NOTES FOR WINDOWS:" -ForegroundColor Yellow
Write-Host "1. OpenPose requires manual compilation with Visual Studio" -ForegroundColor White
Write-Host "2. Some Linux-specific dependencies may need Windows alternatives" -ForegroundColor White
Write-Host "3. Ensure CUDA 11.8 is properly installed and CUDA_PATH is set" -ForegroundColor White
Write-Host "4. You may need to install Visual Studio Build Tools for C++ compilation" -ForegroundColor White
Write-Host "`nTo run the reconstruction, use: .\run.ps1" -ForegroundColor Cyan

Set-Location $PROJECT_DIR
