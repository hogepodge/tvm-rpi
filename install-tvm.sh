#!/bin/bash

# General Developer Dependencies
sudo apt install -y vim \
                    gcc \
                    g++ \
                    cmake \
                    python3 \
                    python3-dev \
                    python3-pip \
                    python3-setuptools \
                    git \
                    wget

# Additional TVM Dependencies
sudo apt install -y libtinfo-dev \
                    zlib1g-dev \
                    build-essential \
                    libedit-dev \
                    libxml2-dev \
                    protobuf-compiler \
                    llvm \
                    libatlas-base-dev \
                    gfortran

# Python dependencies for TVM
# This will take a while, as a number of these
# packages need to be installed from source
pip3 install --user numpy \
                    decorator \
                    attrs \
                    tornado \
                    psutil \
                    xgboost \
                    cloudpickle \
                    onnx

# Install TVM
git clone --recursive https://github.com/apache/tvm tvm 
pushd tvm 
git submodule init
git submodule update

mkdir build
cp cmake/config.cmake build
pushd build
cmake ../.
make -j4
popd
popd

# Add this to your shell to make tvm available
export TVM_HOME=/home/pi/tvm
export PYTHONPATH=$TVM_HOME/python:${PYTHONPATH}

# Check to see if tvm and tvmc is installed
python3 -m tvm.driver.tvmc --help
