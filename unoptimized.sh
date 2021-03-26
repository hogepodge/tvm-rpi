#!/bin/bash
set -x

# Get the ONNX model
wget https://github.com/onnx/models/raw/master/vision/classification/resnet/model/resnet50-v2-7.onnx
wget https://s3.amazonaws.com/onnx-model-zoo/synset.txt

# Compile an unoptimized model
python3 -m tvm.driver.tvmc compile \
    --target "llvm" \
    --output resnet50-v2-7.tvm \
    resnet50-v2-7.onnx

# Preprocess the image data
python3 preprocess.py

# Run inference on the model
python3 -m tvm.driver.tvmc run \
  --inputs imagenet_cat.npz \
  --output predictions.npz \
  resnet50-v2-7.tvm

# Print the inferences
python3 postprocess.py

# Gather some performance data on the model
python3 -m tvm.driver.tvmc run \
   --inputs imagenet_cat.npz \
   --output predictions.npz  \
   --print-time \
   --repeat 20 \
   resnet50-v2-7.tvm

