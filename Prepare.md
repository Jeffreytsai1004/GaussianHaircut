# wsl切换到wsl2（可选）
wsl -l -v
wsl --set-version <发行版名称> 2
如：
wsl --set-version Ubuntu-20.04 2

sudo -i
输入密码
cd ~

# 新建路径
mkdir Documents
mkdir Downloads
mkdir Workspace
mkdir docker/app
mkdir docker/workspace

# 更新包
sudo apt update && sudo apt upgrade -y
sudo apt-get update

# 安装 tar
sudo apt update
sudo apt install vim
sudo apt install tar

# 安装 git
sudo apt update
sudo apt install git

# 安装显卡驱动

# 安装CUDA
### 访问NVIDIA CUDA Toolkit 11.8下载页面，选择以下配置：
### Operating System: Linux
### Architecture: x86_64
### Distribution: WSL-Ubuntu
### Installer Type: deb (local)
cd ~/Downloads
wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-wsl-ubuntu-11-8-local_11.8.0-1_amd64.deb
sudo dpkg -i cuda-repo-wsl-ubuntu-11-8-local_11.8.0-1_amd64.deb
sudo cp /var/cuda-repo-wsl-ubuntu-11-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda
sudo apt install nvidia-cuda-toolkit
### 验证安装
nvidia-smi
nvcc -v
which nvcc
whereis nvcc

# 安装 Opencv
sudo apt install libopencv-dev python3-opencv

# 安装Python
cd ~/Downloads
sudo apt update
sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev -y
wget https://www.python.org/ftp/python/3.9.18/Python-3.9.18.tgz
tar -xf Python-3.9.18.tgz && rm 3.9.18/Python-3.9.18.tgz
cd Python-3.9.18
./configure --enable-optimizations
make -j$(nproc)
sudo make altinstall
python3.9 --version
whereis python
export PYTHONPATH=$PYTHONPATH:/usr/bin/python3.8
python3 --version
apt install python3-pip

# 安装cmake
cd ~/Downloads
sudo apt update
sudo apt-get install libgl1-mesa-dev libglu1-mesa-dev libxt-dev libxmu-dev libxi-dev zlib1g-dev
wget https://cmake.org/files/v3.18/cmake-3.18.4.tar.gz
tar -zxvf cmake-3.18.4.tar.gz && rm cmake-3.18.4.tar.gz
cd cmake-3.18.4
./bootstrap
make -j$(nproc)
sudo make install
sudo ln -sf /usr/local/bin/cmake /usr/bin/cmake
cmake --version

# 安装Miniconda3
cd ~/Downloads
wget -c https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh
source ~/.bashrc
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --set show_channel_urls yes

# 安装 Protobuf
cd ~/Workspace
### 更新系统包列表
sudo apt update && sudo apt upgrade -y
### 安装编译依赖
sudo apt install -y autoconf automake libtool curl make g++ unzip
sudo apt-get install zlib1g-dev
### 下载Protobuf源码
wget -t 0 -c https://github.com/protocolbuffers/protobuf/releases/download/v21.12/protobuf-all-21.12.tar.gz
tar -xzf protobuf-all-21.12.tar.gz && rm protobuf-all-21.12.tar.gz
cd protobuf-21.12
### 编译与安装
./autogen.sh  # 仅Git源码需要此步骤
export CXXFLAGS="-std=c++11"
./configure # --prefix=/usr/local
make -j$(nproc)
sudo make install
### 若需安装到用户目录（无需sudo），可将--prefix设为$HOME/.local，并添加环境变量：
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
### 验证安装
protoc --version
### Python支持（可选）
pip install protobuf

# 安装 openpose
cd ~/Workspace
### 安装依赖项
sudo apt-get install build-essential cmake libopencv-dev libboost-all-dev
# 安装 CMake GUI（可选，用于可视化配置）
sudo apt-get install cmake-qt-gui
### 克隆 OpenPose 仓库
git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose.git
cd openpose
git submodule update --init --recursive
### 下载模型
cd models
./getModels.sh
### CMake 配置
rm -rf build
mkdir build
cd build
cmake -DBUILD_PYTHON=ON
### 编译安装
make -j$(nproc)
sudo make install
### 测试运行
./build/examples/openpose/openpose.bin --video examples/media/video.avi

# 安装blender3.6
