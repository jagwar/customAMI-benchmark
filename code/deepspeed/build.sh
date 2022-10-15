#!/bin/bash

rm -rf build

time TORCH_CUDA_ARCH_LIST="7.0 8.0" DS_BUILD_CPU_ADAM=1 DS_BUILD_UTILS=1 pip install -e . --global-option="build_ext" --global-option="-j8" --no-cache -v --disable-pip-version-check 2>&1 | tee build.log