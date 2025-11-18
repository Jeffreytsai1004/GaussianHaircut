# GaussianHaircut Windows 快速入门指南

## 5 分钟快速开始

### 步骤 1: 安装前置依赖（首次使用）

1. **安装 CUDA 11.8**
   - 下载: https://developer.nvidia.com/cuda-11-8-0-download-archive
   - 选择 Windows 版本并安装

2. **安装 Miniconda**
   - 下载: https://docs.conda.io/en/latest/miniconda.html
   - 运行安装程序

3. **安装 Git for Windows**
   - 下载: https://git-scm.com/download/win
   - 运行安装程序

4. **安装 Blender 3.6**
   - 下载: https://www.blender.org/download/lts/3-6/
   - 记住安装路径

### 步骤 2: 克隆并安装项目

打开 PowerShell（以管理员身份）:

```powershell
# 克隆项目
cd E:\Zoroot\Dev
git clone https://github.com/Jeffreytsai1004/GaussianHaircut
cd GaussianHaircut

# 允许运行脚本
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 运行安装（需要 30-60 分钟）
.\install.ps1
```

或者直接双击 `install.bat` 文件。

### 步骤 3: 准备数据

1. 创建场景文件夹:
   ```powershell
   mkdir E:\Data\my_scene
   ```

2. 将您的视频文件放入该文件夹并重命名为 `raw.mp4`

### 步骤 4: 配置环境变量

编辑 `setup_env.ps1` 文件，修改以下内容：

```powershell
# Blender 路径（根据实际安装位置修改）
$env:BLENDER_DIR = "C:\Program Files\Blender Foundation\Blender 3.6\blender.exe"

# 数据路径（修改为您的场景文件夹）
$env:DATA_PATH = "E:\Data\my_scene"
```

### 步骤 5: 运行重建

```powershell
# 加载环境变量
. .\setup_env.ps1

# 运行重建流程
.\run.ps1
```

或者直接双击 `run.bat` 文件（需要先设置环境变量）。

## 方法 1: 使用 PowerShell（推荐）

```powershell
# 1. 设置环境变量
. .\setup_env.ps1

# 2. 运行重建
.\run.ps1

# 3. 指定 GPU（如果有多个 GPU）
.\run.ps1 -GPU 1
```

## 方法 2: 使用批处理文件

1. 编辑 `setup_env.ps1` 设置路径
2. 双击 `run.bat`

## 方法 3: 手动设置环境变量

```powershell
$env:PROJECT_DIR = "E:\Zoroot\Dev\GaussianHaircut"
$env:BLENDER_DIR = "C:\Program Files\Blender Foundation\Blender 3.6\blender.exe"
$env:DATA_PATH = "E:\Data\my_scene"
.\run.ps1
```

## 监控进度

在另一个 PowerShell 窗口中运行:

```powershell
conda activate gaussian_splatting_hair
tensorboard --logdir=$env:DATA_PATH
```

然后在浏览器中访问 http://localhost:6006

## 预期运行时间

在配备 RTX 4090 的系统上，完整流程大约需要：

- **预处理**: 30-60 分钟
- **3D 高斯溅射**: 1-2 小时
- **FLAME 拟合**: 2-3 小时
- **发丝重建**: 3-4 小时
- **可视化**: 30-60 分钟

**总计**: 约 8-12 小时

## 输出结果

重建完成后，您会在 `$DATA_PATH` 目录下找到：

```
my_scene/
├── images/                          # 提取的视频帧
├── matte_anything/                  # 分割掩码
├── 3d_gaussian_splatting/          # 3D 重建结果
├── flame_fitting/                   # FLAME 头部模型
├── strands_reconstruction/          # 潜在发丝
├── curves_reconstruction/           # 最终发丝
└── final_video.mp4                  # 最终可视化视频
```

## 常见问题快速解决

### 问题 1: "无法加载文件，因为在此系统上禁止运行脚本"

**解决**:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 问题 2: "CUDA out of memory"

**解决**:
- 关闭其他占用 GPU 的程序
- 使用更小的视频分辨率
- 减少批次大小（需要修改脚本）

### 问题 3: Conda 环境激活失败

**解决**:
```powershell
conda init powershell
# 关闭并重新打开 PowerShell
```

### 问题 4: 找不到 CUDA

**解决**:
- 确认 CUDA 11.8 已安装
- 检查环境变量 `CUDA_PATH`
- 重启计算机

### 问题 5: 下载失败

**解决**:
- 使用 VPN 或代理
- 手动下载文件到对应目录
- 检查网络连接

## 系统要求检查清单

在开始之前，确保：

- [ ] NVIDIA GPU (支持 CUDA 11.8)
- [ ] 至少 16GB RAM（推荐 32GB）
- [ ] 至少 50GB 可用磁盘空间
- [ ] Windows 10/11 (64位)
- [ ] CUDA 11.8 已安装
- [ ] Anaconda/Miniconda 已安装
- [ ] Git for Windows 已安装
- [ ] Blender 3.6 已安装
- [ ] 稳定的网络连接

## 获取帮助

- **详细文档**: 查看 `README_WINDOWS.md`
- **原项目**: https://github.com/eth-ait/GaussianHaircut
- **项目主页**: https://eth-ait.github.io/GaussianHaircut/
- **论文**: https://arxiv.org/abs/2409.14778

## 提示和技巧

1. **使用 SSD**: 将项目和数据放在 SSD 上可以显著提升速度
2. **监控资源**: 使用任务管理器监控 GPU 和内存使用情况
3. **保存检查点**: 脚本会自动保存检查点，可以从中断处继续
4. **测试小视频**: 首次使用时，先用短视频（10-20 秒）测试流程
5. **备份数据**: 在开始前备份重要数据

## 下一步

成功运行后，您可以：

1. 调整参数以获得更好的结果
2. 尝试不同的视频和发型
3. 修改可视化设置
4. 导出结果用于其他应用

祝您使用愉快！
