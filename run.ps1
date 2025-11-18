# GaussianHaircut Windows Reconstruction Script
# 
# Usage:
#   $env:PROJECT_DIR = "C:\path\to\GaussianHaircut"
#   $env:BLENDER_DIR = "C:\path\to\blender\blender.exe"
#   $env:DATA_PATH = "C:\path\to\scene\folder"
#   .\run.ps1

param(
    [string]$GPU = "0"
)

# Enable error handling
$ErrorActionPreference = "Stop"

Write-Host "=== GaussianHaircut Reconstruction Pipeline ===" -ForegroundColor Green

# Check required environment variables
if (-not $env:PROJECT_DIR) {
    Write-Host "ERROR: PROJECT_DIR environment variable not set!" -ForegroundColor Red
    Write-Host "Example: `$env:PROJECT_DIR = 'C:\path\to\GaussianHaircut'" -ForegroundColor Yellow
    exit 1
}

if (-not $env:BLENDER_DIR) {
    Write-Host "ERROR: BLENDER_DIR environment variable not set!" -ForegroundColor Red
    Write-Host "Example: `$env:BLENDER_DIR = 'C:\Program Files\Blender Foundation\Blender 3.6\blender.exe'" -ForegroundColor Yellow
    exit 1
}

if (-not $env:DATA_PATH) {
    Write-Host "ERROR: DATA_PATH environment variable not set!" -ForegroundColor Red
    Write-Host "Example: `$env:DATA_PATH = 'C:\path\to\scene\folder'" -ForegroundColor Yellow
    exit 1
}

$PROJECT_DIR = $env:PROJECT_DIR
$BLENDER_DIR = $env:BLENDER_DIR
$DATA_PATH = $env:DATA_PATH

Write-Host "Project Directory: $PROJECT_DIR" -ForegroundColor Cyan
Write-Host "Blender Path: $BLENDER_DIR" -ForegroundColor Cyan
Write-Host "Data Path: $DATA_PATH" -ForegroundColor Cyan
Write-Host "GPU: $GPU" -ForegroundColor Cyan

# Experiment names
$EXP_NAME_1 = "3d_gaussian_splatting"
$EXP_NAME_2 = "strands_reconstruction"
$EXP_NAME_3 = "curves_reconstruction"
$EXP_PATH_1 = "$DATA_PATH\3d_gaussian_splatting\$EXP_NAME_1"

# Initialize conda for PowerShell
conda init powershell

Write-Host "`n=== Starting Preprocessing ===" -ForegroundColor Green

# Extract frames from video
Write-Host "`nExtracting frames from video..." -ForegroundColor Yellow
conda activate gaussian_splatting_hair
Set-Location "$PROJECT_DIR\src\preprocessing"
$env:CUDA_VISIBLE_DEVICES = $GPU
python extract_frames.py --data_dir $DATA_PATH

# Detect faces with PIXIE
Write-Host "`nDetecting faces with PIXIE..." -ForegroundColor Yellow
conda deactivate
conda activate pixie-env
Set-Location "$PROJECT_DIR\ext\PIXIE"
$env:CUDA_VISIBLE_DEVICES = $GPU
python demos\demo_fit_face.py --inputpath "$DATA_PATH\images" --savefolder "$DATA_PATH\pixie"

# Detect 2D keypoints
Write-Host "`nDetecting 2D keypoints..." -ForegroundColor Yellow
conda deactivate
conda activate gaussian_splatting_hair
Set-Location "$PROJECT_DIR\src\preprocessing"
$env:CUDA_VISIBLE_DEVICES = $GPU
python detect_keypoints.py --data_dir $DATA_PATH --project_dir $PROJECT_DIR

# Segment hair and body
Write-Host "`nSegmenting hair and body..." -ForegroundColor Yellow
conda deactivate
conda activate matte_anything
Set-Location "$PROJECT_DIR\ext\Matte-Anything"
$env:CUDA_VISIBLE_DEVICES = $GPU
python matte_anything.py --checkpoint pretrained\sam_vit_h_4b8939.pth `
    --input_path "$DATA_PATH\images" --output_path "$DATA_PATH\matte_anything" `
    --prompt_type point --point_coords 256 256 --point_labels 1 `
    --dilate_kernel_size 15 --output_format png

# Estimate camera poses with COLMAP
Write-Host "`nEstimating camera poses with COLMAP..." -ForegroundColor Yellow
conda deactivate
conda activate gaussian_splatting_hair
Set-Location "$PROJECT_DIR\src\preprocessing"
$env:CUDA_VISIBLE_DEVICES = $GPU
python colmap_estimation.py --data_dir $DATA_PATH

# Preprocess masks
Write-Host "`nPreprocessing masks..." -ForegroundColor Yellow
Set-Location "$PROJECT_DIR\src\preprocessing"
$env:CUDA_VISIBLE_DEVICES = $GPU
python preprocess_masks.py --data_dir $DATA_PATH

Write-Host "`n=== Starting Reconstruction ===" -ForegroundColor Green

# Run 3D Gaussian Splatting reconstruction
Write-Host "`nRunning 3D Gaussian Splatting reconstruction..." -ForegroundColor Yellow
conda activate gaussian_splatting_hair
Set-Location "$PROJECT_DIR\src"
$env:CUDA_VISIBLE_DEVICES = $GPU
python train_gaussians.py `
    -s $DATA_PATH -m "$EXP_PATH_1" -r 1 --port "888$GPU" `
    --trainable_cameras --trainable_intrinsics --use_barf `
    --lambda_dorient 0.1

# Run FLAME mesh fitting
Write-Host "`nRunning FLAME mesh fitting (Stage 1)..." -ForegroundColor Yellow
conda activate gaussian_splatting_hair
Set-Location "$PROJECT_DIR\ext\NeuralHaircut\src\multiview_optimization"
$env:CUDA_VISIBLE_DEVICES = $GPU
python fit.py --conf confs\train_person_1.conf `
    --batch_size 1 --train_rotation True --fixed_images True `
    --save_path "$DATA_PATH\flame_fitting\$EXP_NAME_1\stage_1" `
    --data_path $DATA_PATH `
    --fitted_camera_path "$EXP_PATH_1\cameras\30000_matrices.pkl"

Write-Host "`nRunning FLAME mesh fitting (Stage 2)..." -ForegroundColor Yellow
$env:CUDA_VISIBLE_DEVICES = $GPU
python fit.py --conf confs\train_person_1.conf `
    --batch_size 4 --train_rotation True --fixed_images True `
    --save_path "$DATA_PATH\flame_fitting\$EXP_NAME_1\stage_2" `
    --checkpoint_path "$DATA_PATH\flame_fitting\$EXP_NAME_1\stage_1\opt_params_final" `
    --data_path $DATA_PATH `
    --fitted_camera_path "$EXP_PATH_1\cameras\30000_matrices.pkl"

Write-Host "`nRunning FLAME mesh fitting (Stage 3)..." -ForegroundColor Yellow
$env:CUDA_VISIBLE_DEVICES = $GPU
python fit.py --conf confs\train_person_1_.conf `
    --batch_size 32 --train_rotation True --train_shape True `
    --save_path "$DATA_PATH\flame_fitting\$EXP_NAME_1\stage_3" `
    --checkpoint_path "$DATA_PATH\flame_fitting\$EXP_NAME_1\stage_2\opt_params_final" `
    --data_path $DATA_PATH `
    --fitted_camera_path "$EXP_PATH_1\cameras\30000_matrices.pkl"

# Crop the reconstructed scene
Write-Host "`nCropping the reconstructed scene..." -ForegroundColor Yellow
conda activate gaussian_splatting_hair
Set-Location "$PROJECT_DIR\src\preprocessing"
$env:CUDA_VISIBLE_DEVICES = $GPU
python scale_scene_into_sphere.py `
    --path_to_data $DATA_PATH `
    -m "$DATA_PATH\3d_gaussian_splatting\$EXP_NAME_1" --iter 30000

# Remove hair Gaussians that intersect with the FLAME head mesh
Write-Host "`nRemoving hair Gaussians that intersect with FLAME mesh..." -ForegroundColor Yellow
conda activate gaussian_splatting_hair
Set-Location "$PROJECT_DIR\src\preprocessing"
$env:CUDA_VISIBLE_DEVICES = $GPU
python filter_flame_intersections.py `
    --flame_mesh_dir "$DATA_PATH\flame_fitting\$EXP_NAME_1" `
    -m "$DATA_PATH\3d_gaussian_splatting\$EXP_NAME_1" --iter 30000 `
    --project_dir "$PROJECT_DIR\ext\NeuralHaircut"

# Run rendering for training views
Write-Host "`nRendering training views..." -ForegroundColor Yellow
conda activate gaussian_splatting_hair
Set-Location "$PROJECT_DIR\src"
$env:CUDA_VISIBLE_DEVICES = $GPU
python render_gaussians.py `
    -s $DATA_PATH -m "$DATA_PATH\3d_gaussian_splatting\$EXP_NAME_1" `
    --skip_test --scene_suffix "_cropped" --iteration 30000 `
    --trainable_cameras --trainable_intrinsics --use_barf

# Get FLAME mesh scalp maps
Write-Host "`nExtracting FLAME mesh scalp maps..." -ForegroundColor Yellow
conda activate gaussian_splatting_hair
Set-Location "$PROJECT_DIR\src\preprocessing"
$env:CUDA_VISIBLE_DEVICES = $GPU
python extract_non_visible_head_scalp.py `
    --project_dir "$PROJECT_DIR\ext\NeuralHaircut" --data_dir $DATA_PATH `
    --flame_mesh_dir "$DATA_PATH\flame_fitting\$EXP_NAME_1" `
    --cams_path "$DATA_PATH\3d_gaussian_splatting\$EXP_NAME_1\cameras\30000_matrices.pkl" `
    -m "$DATA_PATH\3d_gaussian_splatting\$EXP_NAME_1"

# Run latent hair strands reconstruction
Write-Host "`nRunning latent hair strands reconstruction..." -ForegroundColor Yellow
conda activate gaussian_splatting_hair
Set-Location "$PROJECT_DIR\src"
$env:CUDA_VISIBLE_DEVICES = $GPU
python train_latent_strands.py `
    -s $DATA_PATH -m "$DATA_PATH\3d_gaussian_splatting\$EXP_NAME_1" -r 1 `
    --model_path_hair "$DATA_PATH\strands_reconstruction\$EXP_NAME_2" `
    --flame_mesh_dir "$DATA_PATH\flame_fitting\$EXP_NAME_1" `
    --pointcloud_path_head "$EXP_PATH_1\point_cloud_filtered\iteration_30000\raw_point_cloud.ply" `
    --hair_conf_path "$PROJECT_DIR\src\arguments\hair_strands_textured.yaml" `
    --lambda_dmask 0.1 --lambda_dorient 0.1 --lambda_dsds 0.01 `
    --load_synthetic_rgba --load_synthetic_geom --binarize_masks --iteration_data 30000 `
    --trainable_cameras --trainable_intrinsics --use_barf `
    --iterations 20000 --port "800$GPU"

# Run hair strands reconstruction
Write-Host "`nRunning hair strands reconstruction..." -ForegroundColor Yellow
conda activate gaussian_splatting_hair
Set-Location "$PROJECT_DIR\src"
$env:CUDA_VISIBLE_DEVICES = $GPU
python train_strands.py `
    -s $DATA_PATH -m "$DATA_PATH\3d_gaussian_splatting\$EXP_NAME_1" -r 1 `
    --model_path_curves "$DATA_PATH\curves_reconstruction\$EXP_NAME_3" `
    --flame_mesh_dir "$DATA_PATH\flame_fitting\$EXP_NAME_1" `
    --pointcloud_path_head "$EXP_PATH_1\point_cloud_filtered\iteration_30000\raw_point_cloud.ply" `
    --start_checkpoint_hair "$DATA_PATH\strands_reconstruction\$EXP_NAME_2\checkpoints\20000.pth" `
    --hair_conf_path "$PROJECT_DIR\src\arguments\hair_strands_textured.yaml" `
    --lambda_dmask 0.1 --lambda_dorient 0.1 --lambda_dsds 0.01 `
    --load_synthetic_rgba --load_synthetic_geom --binarize_masks --iteration_data 30000 `
    --position_lr_init 0.0000016 --position_lr_max_steps 10000 `
    --trainable_cameras --trainable_intrinsics --use_barf `
    --iterations 10000 --port "800$GPU"

# Clean up temporary files
Write-Host "`nCleaning up temporary files..." -ForegroundColor Yellow
if (Test-Path "$DATA_PATH\3d_gaussian_splatting\$EXP_NAME_1\train_cropped") {
    Remove-Item -Recurse -Force "$DATA_PATH\3d_gaussian_splatting\$EXP_NAME_1\train_cropped"
}

Write-Host "`n=== Starting Visualization ===" -ForegroundColor Green

# Export the resulting strands as pkl and ply
Write-Host "`nExporting strands..." -ForegroundColor Yellow
conda activate gaussian_splatting_hair
Set-Location "$PROJECT_DIR\src\preprocessing"
$env:CUDA_VISIBLE_DEVICES = $GPU
python export_curves.py `
    --data_dir $DATA_PATH --model_name $EXP_NAME_3 --iter 10000 `
    --flame_mesh_path "$DATA_PATH\flame_fitting\$EXP_NAME_1\stage_3\mesh_final.obj" `
    --scalp_mesh_path "$DATA_PATH\flame_fitting\$EXP_NAME_1\scalp_data\scalp.obj" `
    --hair_conf_path "$PROJECT_DIR\src\arguments\hair_strands_textured.yaml"

# Render the visualizations
Write-Host "`nRendering visualizations with Blender..." -ForegroundColor Yellow
conda activate gaussian_splatting_hair
Set-Location "$PROJECT_DIR\src\postprocessing"
$env:CUDA_VISIBLE_DEVICES = $GPU
python render_video.py `
    --blender_path "$BLENDER_DIR" --input_path "$DATA_PATH" `
    --exp_name_1 "$EXP_NAME_1" --exp_name_3 "$EXP_NAME_3"

# Render the strands
Write-Host "`nRendering strands..." -ForegroundColor Yellow
conda activate gaussian_splatting_hair
Set-Location "$PROJECT_DIR\src"
$env:CUDA_VISIBLE_DEVICES = $GPU
python render_strands.py `
    -s $DATA_PATH --data_dir "$DATA_PATH" --data_device 'cpu' --skip_test `
    -m "$DATA_PATH\3d_gaussian_splatting\$EXP_NAME_1" --iteration 30000 `
    --flame_mesh_dir "$DATA_PATH\flame_fitting\$EXP_NAME_1" `
    --model_hair_path "$DATA_PATH\curves_reconstruction\$EXP_NAME_3" `
    --hair_conf_path "$PROJECT_DIR\src\arguments\hair_strands_textured.yaml" `
    --checkpoint_hair "$DATA_PATH\strands_reconstruction\$EXP_NAME_2\checkpoints\20000.pth" `
    --checkpoint_curves "$DATA_PATH\curves_reconstruction\$EXP_NAME_3\checkpoints\10000.pth" `
    --pointcloud_path_head "$EXP_PATH_1\point_cloud\iteration_30000\raw_point_cloud.ply" `
    --interpolate_cameras

# Make the video
Write-Host "`nCreating final video..." -ForegroundColor Yellow
conda activate gaussian_splatting_hair
Set-Location "$PROJECT_DIR\src\postprocessing"
$env:CUDA_VISIBLE_DEVICES = $GPU
python concat_video.py `
    --input_path "$DATA_PATH" --exp_name_3 "$EXP_NAME_3"

Write-Host "`n=== Reconstruction Complete ===" -ForegroundColor Green
Write-Host "Results saved to: $DATA_PATH" -ForegroundColor Cyan
Write-Host "Check Tensorboard for intermediate visualizations" -ForegroundColor Yellow
