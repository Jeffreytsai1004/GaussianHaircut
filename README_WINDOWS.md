# Gaussian Haircut - Windows 安装和使用指南

这是 Gaussian Haircut 项目的 Windows 版本适配说明。原项目主要针对 Linux 系统，本文档提供了在 Windows 上运行该项目的详细步骤。

## 系统要求

- **操作系统**: Windows 10/11 (64位)
- **GPU**: NVIDIA GPU (支持 CUDA 11.8)
- **内存**: 建议 32GB 以上
- **存储空间**: 至少 50GB 可用空间

## 前置依赖安装

### 1. 安装 CUDA 11.8

1. 访问 [NVIDIA CUDA 11.8 下载页面](https://developer.nvidia.com/cuda-11-8-0-download-archive)
2. 选择 Windows 版本并下载安装程序
3. 运行安装程序，按照提示完成安装
4. 验证安装：
   ```powershell
   nvcc --version
   ```
5. 确保环境变量 `CUDA_PATH` 已正确设置（通常为 `C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.8`）

### 2. 安装 Anaconda 或 Miniconda

1. 下载 [Miniconda](https://docs.conda.io/en/latest/miniconda.html) 或 [Anaconda](https://www.anaconda.com/products/distribution)
2. 运行安装程序，建议选择"为所有用户安装"
3. 安装完成后，打开 "Anaconda PowerShell Prompt" 或配置 PowerShell 使用 conda

### 3. 安装 Git for Windows

1. 下载 [Git for Windows](https://git-scm.com/download/win)
2. 运行安装程序，建议使用默认设置
3. 验证安装：
   ```powershell
   git --version
   ```

### 4. 安装 Blender 3.6

1. 访问 [Blender 3.6 LTS 下载页面](https://www.blender.org/download/lts/3-6/)
2. 下载 Windows 版本并安装
3. 记录 Blender 可执行文件的完整路径（例如：`C:\Program Files\Blender Foundation\Blender 3.6\blender.exe`）

### 5. 安装 Visual Studio Build Tools (可选但推荐)

某些 Python 包需要 C++ 编译器：

1. 下载 [Visual Studio Build Tools](https://visualstudio.microsoft.com/downloads/)
2. 安装时选择 "使用 C++ 的桌面开发" 工作负载
3. 确保包含 MSVC 和 Windows SDK

## 项目安装

### 1. 克隆项目

打开 PowerShell（建议以管理员身份运行）：

```powershell
cd E:\Zoroot\Dev
git clone https://github.com/eth-ait/GaussianHaircut.git
cd GaussianHaircut
```

### 2. 运行安装脚本

```powershell
# 如果遇到执行策略限制，先运行：
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 运行安装脚本
.\install.ps1
```

**注意**: 安装过程可能需要 30 分钟到 1 小时，取决于网络速度和系统性能。

### 3. 安装过程中的注意事项

- **OpenPose 编译**: Windows 上编译 OpenPose 比较复杂，需要 Visual Studio 和 CMake。如果遇到问题，请参考 [OpenPose Windows 安装文档](https://github.com/CMU-Perceptual-Computing-Lab/openpose/blob/master/doc/installation/0_index.md#windows)
- **网络问题**: 如果下载 Google Drive 文件失败，可能需要手动下载或使用代理
- **依赖冲突**: 如果遇到包版本冲突，可以尝试创建新的 conda 环境

## 使用方法

### 1. 准备数据

1. 录制一段单目视频（参考项目主页的示例）
2. 创建场景文件夹：
   ```powershell
   mkdir E:\Data\my_haircut_scene
   ```
3. 将视频文件放入该文件夹并重命名为 `raw.mp4`

### 2. 设置环境变量

在 PowerShell 中设置以下环境变量：

```powershell
$env:PROJECT_DIR = "E:\Zoroot\Dev\GaussianHaircut"
$env:BLENDER_DIR = "C:\Program Files\Blender Foundation\Blender 3.6\blender.exe"
$env:DATA_PATH = "E:\Data\my_haircut_scene"
```

**提示**: 可以将这些命令保存到一个 `setup_env.ps1` 文件中，每次使用前运行：

```powershell
# setup_env.ps1
$env:PROJECT_DIR = "E:\Zoroot\Dev\GaussianHaircut"
$env:BLENDER_DIR = "C:\Program Files\Blender Foundation\Blender 3.6\blender.exe"
$env:DATA_PATH = "E:\Data\my_haircut_scene"
```

然后运行：
```powershell
. .\setup_env.ps1
```

### 3. 运行重建流程

```powershell
.\run.ps1
```

可选参数：
- 指定 GPU 编号（默认为 0）：
  ```powershell
  .\run.ps1 -GPU 1
  ```

### 4. 监控进度

使用 TensorBoard 查看中间结果：

```powershell
conda activate gaussian_splatting_hair
tensorboard --logdir=$env:DATA_PATH
```

然后在浏览器中访问 `http://localhost:6006`

## 重建流程说明

完整的重建流程包括以下步骤：

### 预处理阶段
1. **提取视频帧** - 从输入视频中提取图像帧
2. **人脸检测** - 使用 PIXIE 检测人脸
3. **关键点检测** - 检测 2D 关键点
4. **分割** - 使用 Matte-Anything 分割头发和身体
5. **相机姿态估计** - 使用 COLMAP 估计相机参数
6. **掩码预处理** - 处理分割掩码

### 重建阶段
7. **3D 高斯溅射重建** - 重建场景的 3D 表示
8. **FLAME 网格拟合** - 拟合头部模型（3个阶段）
9. **场景裁剪** - 将场景缩放到单位球内
10. **过滤交叉** - 移除与头部网格相交的高斯点
11. **渲染训练视图** - 生成合成训练数据
12. **提取头皮图** - 获取头皮可见性信息
13. **潜在发丝重建** - 重建潜在发丝表示
14. **发丝重建** - 最终发丝重建

### 可视化阶段
15. **导出发丝** - 导出为 PLY 和 PKL 格式
16. **渲染可视化** - 使用 Blender 渲染
17. **渲染发丝** - 渲染最终发丝
18. **生成视频** - 合成最终视频

## 常见问题

### 1. CUDA 相关错误

**问题**: `CUDA out of memory` 错误

**解决方案**:
- 减小批次大小
- 使用更小的图像分辨率
- 关闭其他占用 GPU 的程序

### 2. Conda 环境激活失败

**问题**: PowerShell 中无法激活 conda 环境

**解决方案**:
```powershell
conda init powershell
# 关闭并重新打开 PowerShell
```

### 3. 编译错误

**问题**: C++ 扩展编译失败

**解决方案**:
- 确保安装了 Visual Studio Build Tools
- 检查 CUDA 版本是否为 11.8
- 尝试使用 Visual Studio 2019 或 2022

### 4. 路径问题

**问题**: 脚本找不到文件或目录

**解决方案**:
- Windows 使用反斜杠 `\` 作为路径分隔符
- 确保路径中没有空格，或使用引号包围路径
- 使用绝对路径而非相对路径

### 5. OpenPose 编译问题

**问题**: OpenPose 在 Windows 上编译失败

**解决方案**:
- 参考 [OpenPose Windows 官方文档](https://github.com/CMU-Perceptual-Computing-Lab/openpose/blob/master/doc/installation/0_index.md#windows)
- 考虑使用预编译的二进制文件
- 或者跳过 OpenPose，使用替代的关键点检测方法

### 6. 下载失败

**问题**: gdown 下载 Google Drive 文件失败

**解决方案**:
- 使用 VPN 或代理
- 手动从 Google Drive 下载文件
- 使用浏览器下载后放置到对应目录

## 性能优化建议

1. **使用 SSD**: 将数据和项目放在 SSD 上可显著提升 I/O 性能
2. **增加虚拟内存**: 如果物理内存不足，增加页面文件大小
3. **关闭不必要的程序**: 重建过程需要大量 GPU 和内存资源
4. **使用多 GPU**: 如果有多个 GPU，可以修改脚本使用不同的 GPU

## Windows 特定限制

1. **路径长度限制**: Windows 默认最大路径长度为 260 字符，可能需要启用长路径支持
2. **文件权限**: 某些操作可能需要管理员权限
3. **行尾符**: Git 可能会自动转换行尾符，建议配置 `core.autocrlf=false`
4. **符号链接**: Windows 上的符号链接需要管理员权限或开发者模式

## 启用长路径支持（可选）

如果遇到路径过长的错误：

1. 以管理员身份运行 PowerShell
2. 运行以下命令：
   ```powershell
   New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force
   ```
3. 重启计算机

## 技术支持

- **原项目**: [GitHub - GaussianHaircut](https://github.com/eth-ait/GaussianHaircut)
- **项目主页**: [https://eth-ait.github.io/GaussianHaircut/](https://eth-ait.github.io/GaussianHaircut/)
- **论文**: [arXiv:2409.14778](https://arxiv.org/abs/2409.14778)

## 与 Linux 版本的主要差异

1. **脚本语言**: 使用 PowerShell (.ps1) 替代 Bash (.sh)
2. **路径分隔符**: 使用反斜杠 `\` 替代正斜杠 `/`
3. **环境变量**: 使用 `$env:VAR_NAME` 替代 `$VAR_NAME`
4. **命令差异**: 
   - `type` 替代 `cat`
   - `Remove-Item` 替代 `rm`
   - `New-Item` 替代 `mkdir`
5. **OpenPose 编译**: 需要 Visual Studio 而非 GCC
6. **某些依赖**: 可能需要 Windows 特定版本

## 贡献

如果您在 Windows 上遇到问题并找到了解决方案，欢迎提交 Issue 或 Pull Request 帮助改进这个 Windows 适配版本。

## 许可证

本项目基于 3D Gaussian Splatting 项目。条款和条件请参考 LICENSE_3DGS。其余代码在 CC BY-NC-SA 4.0 下分发。
