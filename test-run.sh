cd /opt
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh
sudo bash Miniconda3-py38_4.12.0-Linux-x86_64.sh -b -p /gpfsssd/worksf/projects/rech/six/commun/conda/tr11-176B-ml/
sudo chown -R ec2-user /gpfsssd
export six_ALL_CCFRWORK=/gpfsssd/worksf/projects/rech/six/commun
eval "$(/gpfsssd/worksf/projects/rech/six/commun/conda/tr11-176B-ml/bin/conda shell.bash hook)"

export CONDA_ENVS_PATH=$six_ALL_CCFRWORK/conda

conda create -y -n tr11-176B-ml python=3.8
conda activate tr11-176B-ml

pip install transformers

# switch to a `compil` interactive node where we don't get killed by cgroups
srun --pty -A six@cpu -p compil --hint=nomultithread --time=60 bash

conda activate tr11-176B-ml

# pt-1.11.0 / cuda 11.5
pip install --pre torch torchvision torchaudio -f https://download.pytorch.org/whl/test/cu115/torch_test.html -U

# XXX: will change on Mar-11
# conda install pytorch torchvision torchaudio cudatoolkit=11.3 -c pytorch

pip install deepspeed
mkdir -p $six_ALL_CCFRWORK/code/DeepSpeed
cd $six_ALL_CCFRWORK/code/DeepSpeed
chmod +x build.sh
cd $six_ALL_CCFRWORK/code/tr11-176B-ml/DeepSpeed
./build.sh

cd $six_ALL_CCFRWORK/code/tr11-176B-ml/Megatron-DeepSpeed
pip install -r requirements.txt

cd $six_ALL_CCFRWORK/code/tr11-176B-ml/apex
./build.sh

# to build custom tokenizers make sure that if run on JZ your `~/.cargo/config.toml` contains the following:
[net]
git-fetch-with-cli = true

# if needed first:
# git clone https://github.com/huggingface/tokenizers $six_ALL_CCFRWORK/code/tr11-176B-ml/tokenizers
cd $six_ALL_CCFRWORK/code/tr11-176B-ml/tokenizers
git checkout bigscience_fork
module load rust
pip install setuptools_rust
pip install -e bindings/python
