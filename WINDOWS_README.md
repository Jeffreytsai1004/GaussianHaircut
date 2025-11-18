# GaussianHaircut Windows 版本 - 文档索引

欢迎使用 GaussianHaircut 的 Windows 适配版本！本文档将帮助您快速找到所需的信息。

## 🚀 快速开始

**第一次使用？从这里开始：**

1. 📖 阅读 [快速入门指南](QUICKSTART_WINDOWS.md) - 5 分钟了解基本流程
2. ✅ 使用 [安装检查清单](INSTALLATION_CHECKLIST.md) - 确保所有依赖已安装
3. 🎬 准备您的视频并运行重建流程

## 📚 文档导航

### 新用户必读

| 文档 | 说明 | 适合人群 |
|------|------|----------|
| [QUICKSTART_WINDOWS.md](QUICKSTART_WINDOWS.md) | 快速入门指南 | 想要快速上手的用户 |
| [INSTALLATION_CHECKLIST.md](INSTALLATION_CHECKLIST.md) | 安装检查清单 | 正在安装的用户 |
| [README_WINDOWS.md](README_WINDOWS.md) | 完整使用手册 | 需要详细信息的用户 |

### 技术文档

| 文档 | 说明 | 适合人群 |
|------|------|----------|
| [WINDOWS_COMPATIBILITY_ANALYSIS.md](WINDOWS_COMPATIBILITY_ANALYSIS.md) | 深度兼容性分析 | 遇到依赖问题的用户 |
| [ALTERNATIVE_COMPONENTS.md](ALTERNATIVE_COMPONENTS.md) | 替代组件方案 | 编译失败需要替代方案 |
| [WINDOWS_ADAPTATION_SUMMARY.md](WINDOWS_ADAPTATION_SUMMARY.md) | Windows 适配说明 | 开发者和高级用户 |
| [README.md](README.md) | 原项目文档 | 了解项目背景 |

## 🛠️ 脚本文件

### PowerShell 脚本（推荐）

| 文件 | 用途 | 使用方法 |
|------|------|----------|
| `install.ps1` | 安装所有依赖 | `.\install.ps1` |
| `run.ps1` | 运行重建流程 | `.\run.ps1` |
| `setup_env.ps1` | 配置环境变量 | `. .\setup_env.ps1` |

### 批处理文件（简化版）

| 文件 | 用途 | 使用方法 |
|------|------|----------|
| `install.bat` | 安装包装器 | 双击运行 |
| `run.bat` | 运行包装器 | 双击运行 |

## 📋 使用流程

### 方案 A: 命令行方式（推荐）

```powershell
# 1. 安装（首次使用）
.\install.ps1

# 2. 配置环境变量
. .\setup_env.ps1

# 3. 运行重建
.\run.ps1
```

### 方案 B: 图形界面方式

1. 双击 `install.bat` 进行安装
2. 编辑 `setup_env.ps1` 设置路径
3. 双击 `run.bat` 运行重建

## 🎯 根据您的需求选择文档

### 我想...

#### 快速了解如何使用
👉 阅读 [QUICKSTART_WINDOWS.md](QUICKSTART_WINDOWS.md)

#### 详细了解安装步骤
👉 阅读 [README_WINDOWS.md](README_WINDOWS.md) 的"前置依赖安装"部分

#### 检查我的安装是否正确
👉 使用 [INSTALLATION_CHECKLIST.md](INSTALLATION_CHECKLIST.md)

#### 了解 Windows 版本与 Linux 版本的区别
👉 阅读 [WINDOWS_ADAPTATION_SUMMARY.md](WINDOWS_ADAPTATION_SUMMARY.md)

#### 解决遇到的问题
👉 查看 [README_WINDOWS.md](README_WINDOWS.md) 的"常见问题"部分

#### 深入了解依赖兼容性
👉 阅读 [WINDOWS_COMPATIBILITY_ANALYSIS.md](WINDOWS_COMPATIBILITY_ANALYSIS.md)

#### 寻找替代组件（编译失败时）
👉 查看 [ALTERNATIVE_COMPONENTS.md](ALTERNATIVE_COMPONENTS.md)

#### 了解重建流程的每个步骤
👉 阅读 [README_WINDOWS.md](README_WINDOWS.md) 的"重建流程说明"部分

#### 优化性能
👉 查看 [README_WINDOWS.md](README_WINDOWS.md) 的"性能优化建议"部分

#### 为项目做贡献
👉 阅读 [WINDOWS_ADAPTATION_SUMMARY.md](WINDOWS_ADAPTATION_SUMMARY.md) 的"贡献指南"部分

## ⚙️ 系统要求速查

| 项目 | 最低要求 | 推荐配置 |
|------|----------|----------|
| 操作系统 | Windows 10 (64位) | Windows 11 |
| GPU | GTX 1060 (6GB) | RTX 3060 或更高 |
| 内存 | 16GB | 32GB |
| 存储 | 50GB 可用空间 | 100GB SSD |
| CUDA | 11.8 | 11.8 |

## 🔧 前置依赖清单

- [ ] CUDA 11.8
- [ ] Anaconda/Miniconda
- [ ] Git for Windows
- [ ] Blender 3.6
- [ ] Visual Studio Build Tools（可选）

详细安装说明见 [README_WINDOWS.md](README_WINDOWS.md)

## 📊 预期时间

| 阶段 | 时间 |
|------|------|
| 安装依赖 | 30-60 分钟 |
| 预处理 | 30-60 分钟 |
| 3D 重建 | 1-2 小时 |
| FLAME 拟合 | 2-3 小时 |
| 发丝重建 | 3-4 小时 |
| 可视化 | 30-60 分钟 |
| **总计** | **8-12 小时** |

*基于 RTX 4090 的估计时间*

## 🆘 获取帮助

### 文档资源
1. 查看本目录下的 Windows 相关文档
2. 阅读原项目的 [README.md](README.md)
3. 访问 [项目主页](https://eth-ait.github.io/GaussianHaircut/)

### 在线资源
- **原项目仓库**: https://github.com/eth-ait/GaussianHaircut
- **论文**: https://arxiv.org/abs/2409.14778
- **项目主页**: https://eth-ait.github.io/GaussianHaircut/

### 常见问题快速解决

| 问题 | 解决方案 |
|------|----------|
| 无法运行脚本 | `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser` |
| CUDA 错误 | 确认 CUDA 11.8 已安装，检查 `$env:CUDA_PATH` |
| Conda 激活失败 | `conda init powershell` 然后重启 PowerShell |
| 内存不足 | 关闭其他程序，使用更小的视频 |
| 下载失败 | 使用 VPN 或手动下载文件 |

更多问题请查看 [README_WINDOWS.md](README_WINDOWS.md) 的"常见问题"部分。

## 📁 项目结构

```
GaussianHaircut/
├── 📄 Windows 文档
│   ├── WINDOWS_README.md              # 本文件（索引）
│   ├── QUICKSTART_WINDOWS.md          # 快速入门
│   ├── README_WINDOWS.md              # 完整手册
│   ├── INSTALLATION_CHECKLIST.md      # 安装检查清单
│   └── WINDOWS_ADAPTATION_SUMMARY.md  # 适配说明
│
├── 🔧 Windows 脚本
│   ├── install.ps1                    # PowerShell 安装脚本
│   ├── run.ps1                        # PowerShell 运行脚本
│   ├── setup_env.ps1                  # 环境变量配置
│   ├── install.bat                    # 批处理安装包装器
│   └── run.bat                        # 批处理运行包装器
│
├── 📄 原项目文件
│   ├── README.md                      # 原项目文档
│   ├── install.sh                     # Linux 安装脚本
│   ├── run.sh                         # Linux 运行脚本
│   └── environment.yml                # Conda 环境配置
│
├── 📁 源代码
│   └── src/                           # Python 源代码
│
└── 📁 外部依赖
    └── ext/                           # 外部库
```

## 🎓 学习路径

### 初学者路径
1. 📖 [QUICKSTART_WINDOWS.md](QUICKSTART_WINDOWS.md) - 了解基本概念
2. ✅ [INSTALLATION_CHECKLIST.md](INSTALLATION_CHECKLIST.md) - 完成安装
3. 🎬 运行第一个示例
4. 📚 [README_WINDOWS.md](README_WINDOWS.md) - 深入学习

### 高级用户路径
1. 📖 [WINDOWS_ADAPTATION_SUMMARY.md](WINDOWS_ADAPTATION_SUMMARY.md) - 了解适配细节
2. 🔧 修改脚本参数优化结果
3. 🐛 调试和解决问题
4. 🤝 为项目做贡献

## 💡 提示和技巧

1. **首次使用**: 先用短视频（10-20 秒）测试流程
2. **性能优化**: 将项目和数据放在 SSD 上
3. **监控进度**: 使用 TensorBoard 查看中间结果
4. **保存工作**: 脚本会自动保存检查点
5. **备份数据**: 在开始前备份重要数据

## 🔄 更新日志

### Version 1.0 (当前版本)
- ✅ 完整的 Windows PowerShell 脚本
- ✅ 批处理文件包装器
- ✅ 详细的中文文档
- ✅ 安装检查清单
- ✅ 快速入门指南

## 📝 反馈和贡献

如果您：
- 发现了 bug
- 有改进建议
- 想要贡献代码
- 需要帮助

欢迎：
- 提交 Issue
- 创建 Pull Request
- 分享您的经验

## 📜 许可证

本项目基于 3D Gaussian Splatting 项目。详见 LICENSE 文件。

---

## 🎉 开始使用

准备好了吗？选择您的起点：

- 🚀 **快速开始**: [QUICKSTART_WINDOWS.md](QUICKSTART_WINDOWS.md)
- 📖 **详细指南**: [README_WINDOWS.md](README_WINDOWS.md)
- ✅ **检查安装**: [INSTALLATION_CHECKLIST.md](INSTALLATION_CHECKLIST.md)

祝您使用愉快！🎊
