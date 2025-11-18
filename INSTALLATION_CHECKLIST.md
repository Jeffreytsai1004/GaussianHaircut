# GaussianHaircut Windows 安装检查清单

使用本清单确保所有依赖项都已正确安装。在每个步骤完成后打勾 ✓。

## 前置依赖检查

### 1. 操作系统
- [ ] Windows 10 (64位) 或更高版本
- [ ] 已安装所有 Windows 更新

### 2. 硬件要求
- [ ] NVIDIA GPU (支持 CUDA 11.8)
  - 推荐: RTX 3060 或更高
  - 最低: GTX 1060 (6GB VRAM)
- [ ] RAM: 至少 16GB (推荐 32GB)
- [ ] 存储空间: 至少 50GB 可用空间
- [ ] SSD (推荐，用于提升性能)

### 3. CUDA 11.8
- [ ] 已下载 CUDA 11.8 安装程序
- [ ] 已安装 CUDA 11.8
- [ ] 验证安装:
  ```powershell
  nvcc --version
  # 应显示: Cuda compilation tools, release 11.8
  ```
- [ ] 环境变量 `CUDA_PATH` 已设置
  ```powershell
  $env:CUDA_PATH
  # 应显示: C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.8
  ```

### 4. Anaconda/Miniconda
- [ ] 已下载 Miniconda 或 Anaconda
- [ ] 已安装 Miniconda/Anaconda
- [ ] 验证安装:
  ```powershell
  conda --version
  # 应显示版本号，例如: conda 23.x.x
  ```
- [ ] Conda 已初始化 PowerShell:
  ```powershell
  conda init powershell
  ```

### 5. Git for Windows
- [ ] 已下载 Git for Windows
- [ ] 已安装 Git
- [ ] 验证安装:
  ```powershell
  git --version
  # 应显示版本号，例如: git version 2.x.x
  ```

### 6. Blender 3.6
- [ ] 已下载 Blender 3.6 LTS
- [ ] 已安装 Blender
- [ ] 记录 Blender 可执行文件路径:
  ```
  路径: _______________________________________________
  例如: C:\Program Files\Blender Foundation\Blender 3.6\blender.exe
  ```

### 7. Visual Studio Build Tools (可选但推荐)
- [ ] 已下载 Visual Studio Build Tools
- [ ] 已安装，包含 "使用 C++ 的桌面开发" 工作负载
- [ ] 验证安装:
  ```powershell
  where cl
  # 应显示 cl.exe 的路径
  ```

## 项目安装检查

### 8. 克隆项目
- [ ] 已克隆 GaussianHaircut 仓库
  ```powershell
  git clone https://github.com/eth-ait/GaussianHaircut.git
  ```
- [ ] 已进入项目目录
  ```powershell
  cd GaussianHaircut
  ```

### 9. PowerShell 执行策略
- [ ] 已设置执行策略:
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

### 10. 运行安装脚本
- [ ] 已运行 `install.ps1`:
  ```powershell
  .\install.ps1
  ```
- [ ] 安装过程没有严重错误
- [ ] 所有 conda 环境已创建:
  - [ ] `gaussian_splatting_hair`
  - [ ] `matte_anything`
  - [ ] `pixie-env`

### 11. 验证 Conda 环境

#### 主环境 (gaussian_splatting_hair)
```powershell
conda activate gaussian_splatting_hair
python -c "import torch; print(f'PyTorch: {torch.__version__}'); print(f'CUDA Available: {torch.cuda.is_available()}')"
# 应显示:
# PyTorch: 2.1.1+cu118
# CUDA Available: True
```
- [ ] PyTorch 版本正确
- [ ] CUDA 可用

#### Matte-Anything 环境
```powershell
conda activate matte_anything
python -c "import torch; print(torch.__version__)"
# 应显示: 2.0.0+cu118
```
- [ ] 环境可以激活
- [ ] PyTorch 版本正确

#### PIXIE 环境
```powershell
conda activate pixie-env
python -c "import torch; print(torch.__version__)"
# 应显示: 2.0.0+cu118
```
- [ ] 环境可以激活
- [ ] PyTorch 版本正确

### 12. 验证外部库

- [ ] `ext/openpose` 目录存在
- [ ] `ext/Matte-Anything` 目录存在
- [ ] `ext/NeuralHaircut` 目录存在
- [ ] `ext/pytorch3d` 目录存在
- [ ] `ext/simple-knn` 目录存在
- [ ] `ext/kaolin` 目录存在
- [ ] `ext/hyperIQA` 目录存在
- [ ] `ext/PIXIE` 目录存在

### 13. 验证预训练模型

- [ ] NeuralHaircut 模型已下载
- [ ] Matte-Anything 模型已下载:
  - [ ] `ext/Matte-Anything/pretrained/sam_vit_h_4b8939.pth`
  - [ ] `ext/Matte-Anything/pretrained/groundingdino_swint_ogc.pth`
- [ ] PIXIE 模型已下载
- [ ] hyperIQA 模型已下载

## 配置检查

### 14. 环境变量配置
- [ ] 已编辑 `setup_env.ps1`
- [ ] `PROJECT_DIR` 设置正确
- [ ] `BLENDER_DIR` 设置正确（指向 blender.exe）
- [ ] `DATA_PATH` 已设置（或准备手动设置）

### 15. 测试数据准备
- [ ] 已创建场景文件夹
- [ ] 已准备测试视频
- [ ] 视频已重命名为 `raw.mp4`
- [ ] 视频已放入场景文件夹

## 功能测试

### 16. 基本功能测试

#### 测试 1: 环境激活
```powershell
. .\setup_env.ps1
# 应显示环境变量设置信息，无错误
```
- [ ] 通过

#### 测试 2: Python 导入
```powershell
conda activate gaussian_splatting_hair
python -c "import torch, torchvision, numpy, PIL"
# 应无错误
```
- [ ] 通过

#### 测试 3: CUDA 测试
```powershell
conda activate gaussian_splatting_hair
python -c "import torch; print(torch.cuda.get_device_name(0))"
# 应显示您的 GPU 名称
```
- [ ] 通过，GPU 名称: _______________

#### 测试 4: Blender 测试
```powershell
& "$env:BLENDER_DIR" --version
# 应显示 Blender 版本信息
```
- [ ] 通过

## 常见问题检查

### 17. 如果遇到问题

#### CUDA 问题
- [ ] 检查 NVIDIA 驱动是否最新
- [ ] 确认 CUDA 版本为 11.8
- [ ] 重启计算机

#### Conda 问题
- [ ] 重新运行 `conda init powershell`
- [ ] 关闭并重新打开 PowerShell
- [ ] 检查 conda 配置文件

#### 路径问题
- [ ] 确保所有路径使用反斜杠 `\`
- [ ] 避免路径中包含空格
- [ ] 使用绝对路径

#### 权限问题
- [ ] 以管理员身份运行 PowerShell
- [ ] 检查文件夹权限
- [ ] 禁用防病毒软件（临时）

## 准备运行

### 18. 最终检查
- [ ] 所有上述步骤都已完成
- [ ] 没有未解决的错误
- [ ] 测试数据已准备好
- [ ] 环境变量已配置
- [ ] 有足够的磁盘空间（至少 50GB）
- [ ] 有足够的时间（完整流程需要 8-12 小时）

### 19. 开始运行
```powershell
# 加载环境变量
. .\setup_env.ps1

# 运行重建
.\run.ps1

# 或使用批处理文件
.\run.bat
```
- [ ] 已开始运行

## 监控和验证

### 20. 运行时监控
- [ ] 打开 TensorBoard 监控进度:
  ```powershell
  conda activate gaussian_splatting_hair
  tensorboard --logdir=$env:DATA_PATH
  ```
- [ ] 在浏览器中访问 http://localhost:6006
- [ ] 使用任务管理器监控 GPU 和内存使用

### 21. 预期输出
- [ ] `images/` 目录已创建并包含提取的帧
- [ ] `matte_anything/` 目录已创建并包含分割结果
- [ ] `3d_gaussian_splatting/` 目录已创建
- [ ] `flame_fitting/` 目录已创建
- [ ] 没有严重错误信息

## 完成标志

### 22. 成功标准
- [ ] 所有步骤都已完成
- [ ] 生成了最终视频
- [ ] 结果质量满意
- [ ] 可以重复运行流程

## 故障排除资源

如果遇到问题，请查看:
- [ ] `README_WINDOWS.md` - 详细文档
- [ ] `QUICKSTART_WINDOWS.md` - 快速入门
- [ ] `WINDOWS_ADAPTATION_SUMMARY.md` - 适配说明
- [ ] 原项目 Issues: https://github.com/eth-ait/GaussianHaircut/issues
- [ ] 项目主页: https://eth-ait.github.io/GaussianHaircut/

## 记录信息

为了方便故障排除，请记录以下信息:

```
系统信息:
- Windows 版本: _______________
- GPU 型号: _______________
- GPU 驱动版本: _______________
- CUDA 版本: _______________
- RAM 大小: _______________
- 可用磁盘空间: _______________

软件版本:
- Conda 版本: _______________
- Python 版本: _______________
- PyTorch 版本: _______________
- Git 版本: _______________
- Blender 版本: _______________

项目路径:
- PROJECT_DIR: _______________
- BLENDER_DIR: _______________
- DATA_PATH: _______________

安装日期: _______________
首次运行日期: _______________
```

---

**祝您安装顺利！如有问题，请参考相关文档或寻求社区帮助。**
