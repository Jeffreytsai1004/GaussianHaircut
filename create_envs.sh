eval "$(conda shell.bash hook)"
conda create -y -n base_01 python==3.9 pip==23.3.1 setuptools==69.5.1 -c pytorch -c conda-forge -c defaults -c anaconda -c iopath -c bottler -c nvidia
conda activate base_01
conda create -y -n gaussian_splatting_hair python==3.9 pip==23.3.1 setuptools==69.5.1 gcc==10.4.0 gxx==10.4.0 gxx_linux-64==10.4.0 plyfile==0.8.1 pytorch==2.1.1 torchvision==0.16.1 torchaudio==2.1.1 pytorch-cuda==11.8 cmake==3.28.0 pyhocon==0.3.60 icecream==2.1.3 einops==0.6.0 accelerate==0.18.0 jsonmerge==1.9.0 easydict==1.9 iopath==0.1.10 tensorboardx==2.6 scikit-image==0.20.0 fvcore==0.1.5 toml==0.10.2 tqdm==4.66.5 gdown==5.2.0 colmap==3.10 -c pytorch -c conda-forge -c defaults  -c anaconda -c fvcore -c iopath -c bottler -c nvidia
conda deactivate && conda activate gaussian_splatting_hair
pip install "pillow<11.0" --force-reinstall
pip install "numpy<1.25.0,>=1.18.5" --force-reinstall
conda deactivate && conda activate base_01
conda create -y -n matte_anything pytorch=2.0.0 pytorch-cuda=11.8 torchvision tensorboard timm=0.5.4 opencv=4.5.3 mkl=2024.0 setuptools=58.2.0 easydict wget scikit-image gradio=3.46.1 fairscale -c pytorch -c nvidia -c conda-forge
conda create -y -n openpose cmake=3.20 -c conda-forge
conda create -y -n pixie-env python=3.8 pytorch==2.0.0 torchvision==0.15.0 torchaudio==2.0.0 pytorch-cuda=11.8 fvcore pytorch3d==0.7.5 kornia matplotlib -c pytorch -c nvidia -c fvcore -c conda-forge -c pytorch3d
