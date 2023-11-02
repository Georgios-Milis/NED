#!/bin/bash
set -e

# Read the DECAs and create video parameters
# exp_name=$1
# audio=$2
# outfile=$3

exp_name=test2

celeb=test_examples/55F
checkpoints_dir=renderer_checkpoints/55F_2

mkdir -p $celeb/$exp_name/DECA
cp $celeb/DECA/* $celeb/$exp_name/DECA

# postprocess.sh
# Shapes, nmfcs...
python renderer/create_inputs.py \
    --celeb $celeb \
    --exp_name $exp_name \
    --input ../FastSpeech2/test/$exp_name.pth \
    --save_shapes
# Creates faces_aligned
python renderer/test.py --celeb $celeb --exp_name $exp_name --checkpoints_dir $checkpoints_dir --which_epoch 20
# Creates faces
python postprocessing/unalign.py --celeb $celeb --exp_name $exp_name
# Writes full_frames
python postprocessing/blend.py --celeb $celeb --exp_name $exp_name --save_images


# Create mp4 from frames
python postprocessing/images2video.py \
    --imgs_path $celeb/$exp_name/full_frames \
    --out_path $celeb/videos/$exp_name.mp4 \
    --wav ../FastSpeech2/test/$exp_name.wav


# Copy structure to exp_name
# Replace with pth