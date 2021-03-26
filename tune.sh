#!/bin/bash
set -x

# Tune the model
python3 -m tvm.driver.tvmc tune \
  --target "llvm -device=arm_cpu -mtriple=armv6k-unknown-linux-gnueabihf" \
  -o arm200.json \
  --trials 200 \
 resnet50-v2-7.onnx

# Compile the model with the tuned data
python3 -m tvm.driver.tvmc compile \
  --target "llvm" \
  --output resnet50-v2-7.tuned200.tvm \
  --tuning-records arm200.json \
  resnet50-v2-7.onnx

# Run inference and get performance data
python3 -m tvm.driver.tvmc run \
  -i imagenet_cat.npz \
  --print-time \
  --repeat 10 \
  --outputs predictions.npz 
  resnet50-v2-7.tuned200.tvm

# Check that the results are the same
python3 postprocess.py
