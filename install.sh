# Prerequisites:
#
# 1. Install CUDA 11.8
#    Follow intructions on https://developer.nvidia.com/cuda-11-8-0-download-archive
#    Make sure that
#      -   PATH includes <CUDA_DIR>/bin
#      -   LD_LIBRARY_PATH includes <CUDA_DIR>/lib64
#    If needed, restart bash environment

#    The environment was tested only with this CUDA version

# 2. Install Blender 3.6 to create strand visualizations
#    Follow instructions on https://www.blender.org/download/lts/3-6
#

# Need to use this to activate conda environments
eval "$(conda shell.bash hook)"

# Save parent dir
PROJECT_DIR=$PWD

# Pull all external libraries
mkdir ext
cd $PROJECT_DIR/ext && git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose --depth 1
cd $PROJECT_DIR/ext/openpose && git submodule update --init --recursive --remote
cd $PROJECT_DIR/ext && git clone https://github.com/hustvl/Matte-Anything
cd $PROJECT_DIR/ext/Matte-Anything && git clone https://github.com/IDEA-Research/GroundingDINO.git
cd $PROJECT_DIR/ext && git clone git@github.com:egorzakharov/NeuralHaircut.git --recursive
cd $PROJECT_DIR/ext && git clone https://github.com/facebookresearch/pytorch3d
cd $PROJECT_DIR/ext/pytorch3d && git checkout 2f11ddc5ee7d6bd56f2fb6744a16776fab6536f7
cd $PROJECT_DIR/ext && git clone https://github.com/camenduru/simple-knn
cd $PROJECT_DIR/ext/diff_gaussian_rasterization_hair/third_party && git clone https://github.com/g-truc/glm
cd $PROJECT_DIR/ext/diff_gaussian_rasterization_hair/third_party/glm && git checkout 5c46b9c07008ae65cb81ab79cd677ecc1934b903
cd $PROJECT_DIR/ext && git clone --recursive https://github.com/NVIDIAGameWorks/kaolin
cd $PROJECT_DIR/ext/kaolin && git checkout v0.15.0
cd $PROJECT_DIR/ext && git clone https://github.com/SSL92/hyperIQA

# Install environment
cd $PROJECT_DIR
conda create --name gaussian_splatting_hair  python=3.9 pip=23.3.1 setuptools=69.5.1 gcc=10.4.0 gxx=10.4.0 gxx_linux-64=10.4.0 plyfile=0.8.1 pytorch=2.1.1 torchvision=0.16.1 torchaudio=2.1.1 pytorch-cuda=11.8 cmake=3.28.0 pyhocon=0.3.60 icecream=2.1.3 einops=0.6.0 accelerate=0.18.0 jsonmerge=1.9.0 easydict=1.9 iopath=0.1.10 tensorboardx=2.6 scikit-image=0.20.0 fvcore=0.1.5 toml=0.10.2 tqdm=4.66.5 gdown=5.2.0 colmap=3.10  -c pytorch -c conda-forge -c defaults -c anaconda -c fvcore -c iopath -c bottler -c nvidia
conda activate gaussian_splatting_hair
pip install pysdf clean-fid face-alignment clip torchdiffeq torchsde resize-right
pip install $PROJECT_DIR/ext/pytorch3d
pip install $PROJECT_DIR/ext/NeuralHaircut/npbgpp
pip install $PROJECT_DIR/ext/simple-knn
pip install $PROJECT_DIR/ext/diff_gaussian_rasterization_hair
pip install $PROJECT_DIR/ext/kaolin


# Download Neural Haircut files
cd $PROJECT_DIR/ext/NeuralHaircut
gdown --folder https://drive.google.com/drive/folders/1TCdJ0CKR3Q6LviovndOkJaKm8S1T9F_8
cd $PROJECT_DIR/ext/NeuralHaircut/pretrained_models/diffusion_prior # downloads updated diffusion prior
gdown 1_9EOUXHayKiGH5nkrayncln3d6m1uV7f
cd $PROJECT_DIR/ext/NeuralHaircut/PIXIE
gdown 1mPcGu62YPc4MdkT8FFiOCP629xsENHZf && tar -xvzf pixie_data.tar.gz ./ && rm pixie_data.tar.gz
cd $PROJECT_DIR/ext/hyperIQA && mkdir pretrained && cd pretrained
gdown 1OOUmnbvpGea0LIGpIWEbOyxfWx6UCiiE
cd $PROJECT_DIR

# Matte-Anything
conda create -y -n matte_anything   pytorch=2.0.0 pytorch-cuda=11.8 torchvision tensorboard timm=0.5.4 opencv=4.5.3   mkl=2024.0 setuptools=58.2.0 easydict wget scikit-image gradio=3.46.1 fairscale   -c pytorch -c nvidia -c conda-forge # this worked better than the official installation config
conda deactivate && conda activate matte_anything
pip install git+https://github.com/facebookresearch/segment-anything.git
python -m pip install 'git+https://github.com/facebookresearch/detectron2.git'
cd $PROJECT_DIR/ext/Matte-Anything/GroundingDINO && pip install -e .
pip install supervision==0.22.0 # fixes the GroundingDINO error
cd $PROJECT_DIR/ext/Matte-Anything && mkdir pretrained
cd $PROJECT_DIR/ext/Matte-Anything/pretrained
wget https://dl.fbaipublicfiles.com/segment_anything/sam_vit_h_4b8939.pth
wget https://github.com/IDEA-Research/GroundingDINO/releases/download/v0.1.0-alpha/groundingdino_swint_ogc.pth
conda deactivate && conda activate gaussian_splatting_hair
gdown 1d97oKuITCeWgai2Tf3iNilt6rMSSYzkW

# OpenPose
cd $PROJECT_DIR/ext/openpose
gdown 1Yn03cKKfVOq4qXmgBMQD20UMRRRkd_tV && tar -xvzf models.tar.gz && rm models.tar.gz # downloads openpose checkpoint
conda deactivate
git submodule update --init --recursive --remote
conda create -y -n openpose cmake=3.20 -c conda-forge # needed to avoid cmake complining error
conda activate openpose
sudo apt install libopencv-dev # installation instructions are from EasyMocap, in case of problems refer to the official OpenPose docs
sudo apt install protobuf-compiler libgoogle-glog-dev
sudo apt install libboost-all-dev libhdf5-dev libatlas-base-dev
mkdir build
cd build
cmake .. -DBUILD_PYTHON=true -DUSE_CUDNN=off
make -j8
conda deactivate

# PIXIE
cd $PROJECT_DIR/ext && git clone https://github.com/yfeng95/PIXIE
cd $PROJECT_DIR/ext/PIXIE
chmod +x fetch_model.sh && ./fetch_model.sh
conda create -y -n pixie-env python=3.8 pytorch==2.0.0 torchvision==0.15.0 torchaudio==2.0.0   pytorch-cuda=11.8 fvcore pytorch3d==0.7.5 kornia matplotlib   -c pytorch -c nvidia -c fvcore -c conda-forge -c pytorch3d # this environment works with RTX 4090
conda activate pixie-env
pip install pyyaml==5.4.1
pip install git+https://github.com/1adrianb/face-alignment.git@54623537fd9618ca7c15688fd85aba706ad92b59 # install this commit to avoid error
