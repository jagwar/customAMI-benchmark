# Building Custom ParallelCluster AMIs with Packer

This document documents how to build ParallelCluster AMIs with [Packer](https://www.packer.io/) from [HashiCorp](https://www.hashicorp.com/). You can run Packer on your own computer, an EC2 instance with suitable IAM rights or through an automated process with [AWS CodeBuild](https://docs.aws.amazon.com/codebuild/latest/userguide/welcome.html) associated to a code repository.


#### 1 - Software Stack Installed

The software stack installed on the AMI through packer consists of:

- [Nvidia Driver](https://www.nvidia.com/Download/index.aspx?lang=en-us) - 510.47.03
- [CUDA](https://developer.nvidia.com/cuda-downloads) - 11.6
- [CUDNN](https://developer.nvidia.com/cudnn) - v8
- [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-docker) - system latest
- Docker - system latest
- [NCCL](https://developer.nvidia.com/nccl) - v2.12.7-1
- [Pyxis](https://github.com/NVIDIA/pyxis) - v0.12.0"
- [Enroot](https://github.com/NVIDIA/enroot) - latest
- [AWS CLI V2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) - latest for Nvidia Driver 510.47.03
- [Nvidia Fabric Manager](https://docs.nvidia.com/datacenter/tesla/pdf/fabric-manager-user-guide.pdf) - latest
- [EFA Driver](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/efa-start.html) - latest
- [EFA OFI NCCL plugin](https://github.com/aws/aws-ofi-nccl) - latest
- [NCCL Tests](https://github.com/NVIDIA/nccl-tests) - Latest
- [Intel MKL](https://www.intel.com/content/www/us/en/develop/documentation/get-started-with-mkl-for-dpcpp/top.html) - 2020.0-088

#### 2 - Assets Required to Build the Image

The image build assets consist of the following assets:
- `nvidia-efa-ml-al2-enroot_pyxis.json`: is your main image file, it consists of several sections to define the resources (instance, base AMI, security groups...) you will use to build your image. The base AMI is a ParallelCluster Amazon Linux 2 base AMI. The provisioners section consists of inline scripts that will be executed serially to install the desired software stack onto your image.
- `variables.json`: contains some key variables. Packer will refer to them in the image script through `user` variables calls.
- `enroot.com`: in the enroot directory contains the [Enroot](https://github.com/NVIDIA/enroot) configuration that will be copied to your AMI.


#### 3 - Installing Packer

You can install Packer using [Brew](https://brew.sh/) on OSX or Linux as follows:

```bash
brew install packer
```

Alternatively, you can download the Packer binary through the [tool website](https://www.packer.io/). Ensure your `PATH` is set to use the binary or use its absolute path. Once Packer installed, proceed to the next stage.

#### 4 - Build Your Image

Once packer installed, from the assets directory run the command below:

```bash
packer build -color=true -var-file variables.json nvidia-efa-ml-al2-enroot_pyxis.json | tee build_AL2.log
```

Packer will start by creating the instances and associated resources (EC2 Key, Security Group...), run through the installation scripts, shutdown the instance and image it then terminate the instance.

The process is automated and the output will be displayed on your terminal. If Packer encounters an error during the installation, it will stop the process and terminate all the resources. You will have to go through its log to identify where the error occurred and correct it.

Once the image build, feel free to use it to create new clusters. The image will be retrieval from the Amazon EC2 Console under "Images -> AMIs"

#### 5 - Run your Containers on Slurm

Running your containers on Slurm is straightforward with Pyxis and Enroot. Please refer to the [official documentation](https://github.com/NVIDIA/pyxis#examples=) on Github for examples with Slurm (srun).

You can also get more information by running `srun --help` as shown in the [Pyxis](https://github.com/NVIDIA/pyxis#usage=) documentation.

The base docker image used for this POC was based on the NGC/Pytorch Image v22.03. For conversion of the image from NGC to a compatible image to use GPUDirectRDMA over EFA see. (Dockerfile)[https://github.com/aws-samples/aws-efa-nccl-baseami-pipeline/blob/master/nvidia-efa-docker_base/ubuntu20.04/Dockerfile-cu11-pt22.03.base]. A premade is image is available on ECR Public - https://gallery.ecr.aws/w6p6i9i7/aws-efa-nccl-rdma

