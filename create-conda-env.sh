#update c++ and g++
sudo yum install centos-release-scl
sudo yum install devtoolset-7-gcc*
scl enable devtoolset-7 bash
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh
sudo bash Miniconda3-py38_4.12.0-Linux-x86_64.sh -b -p /gpfswork/rech/six/commun/conda/
sudo chown -R ec2-user /gpfswork/rech/six/commun/conda/
export six_ALL_CCFRWORK=/gpfswork/rech/six/commun
eval "$(/gpfswork/rech/six/commun/conda/bin/conda shell.bash hook)"
cd /home/ec2-user/
echo ". /gpfswork/rech/six/commun/conda/etc/profile.d/conda.sh" >> ~/.bashrc
echo "export six_ALL_CCFRWORK=/gpfswork/rech/six/commun\" >> ~/.bashrc
echo "export six_ALL_CCFRSCRATCH=/scratch" >> ~/.bashrc
echo ". /gpfswork/rech/six/commun/conda/etc/profile.d/conda.sh" >> ~/.bashrc
export CONDA_ENVS_PATH=$six_ALL_CCFRWORK/conda
conda create -y -n tr11-176B-ml python=3.8
conda activate tr11-176B-ml
conda install pytorch==1.12.0 torchvision==0.13.0 torchaudio==0.12.0 cudatoolkit=11.6 -c pytorch -c conda-forge
pip install transformers
cd $six_ALL_CCFRWORK/code/tr11-176B-ml
git clone https://github.com/huggingface/tokenizers.git
cd tokenizers
git checkout bigscience_fork
cd bindings/python
pip install setuptools_rust
pip install -e .
pip install git+https://github.com/microsoft/DeepSpeed@2a64448830375528009d2d8c81e8a40d7e09396d
git clone https://github.com/bigscience-workshop/Megatron-DeepSpeed $six_ALL_CCFRWORK/code/tr11-176B-ml/Megatron-DeepSpeed
cd $six_ALL_CCFRWORK/code/tr11-176B-ml/Megatron-DeepSpeed
git pull
git checkout 9edd93934d0cb616b359d22ef4a3112336fea558
pip install -r requirements.txt
git clone https://github.com/NVIDIA/apex.git $six_ALL_CCFRWORK/code/apex
git clone https://github.com/bigscience-workshop/bigscience.git $six_ALL_CCFRWORK/code/tr11-176B-ml/bigscience
cd $six_ALL_CCFRWORK/code/apex
pip install --global-option="--cpp_ext" --global-option="--cuda_ext" --no-cache -v --disable-pip-version-check .  2>&1 | tee build.log
conda deactivate
conda create --name tr11-176B-ml --clone /gpfswork/rech/six/commun/conda/tr11-176B-ml
