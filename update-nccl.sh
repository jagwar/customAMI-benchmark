mkdir /apps/ncc-pr691 && cd /apps/ncc-pr691
git clone https://github.com/NVIDIA/nccl
cd nccl
git fetch origin pull/691/head:pr691
sudo make clean && sudo make -j src.build CUDA_HOME=/usr/local/cuda NVCC_GENCODE='-gencode=arch=compute_70,code=sm_70 -gencode=arch=compute_75,code=sm_75 -gencode=arch=compute_80,code=sm_80' PREFIX=/apps/ncc-pr691/nccl
cd ..
git clone  https://github.com/aws/aws-ofi-nccl
cd aws-ofi-nccl/
./autogen.sh
./configure --prefix=/apps/nccl-pr691/aws-ofi-nccl --with-mpi=/opt/amazon/openmpi --with-libfabric=/opt/amazon/efa --with-nccl=/apps/nccl-pr691/nccl --with-cuda=/usr/local/cuda-11.4
