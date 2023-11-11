#!/bin/bash
set -e


subject="55F"
celeb=train_examples/$subject

# # video="55F_t.mp4"
# # mkdir -p $celeb/videos
# # mv $video $celeb/videos/($subject)_t.mp4

# # preprocess.sh in train mode
# # Face detection (writes images)
# python preprocessing/detect.py --celeb $celeb --split
# # Writes eye_landmarks (calculates mouth landmarks, too)
# python preprocessing/eye_landmarks.py --celeb $celeb --mouth --align
# # Writes masks, faces
# python preprocessing/segment_face.py --celeb $celeb

# exit

# Go to reconstruct and insert SPECTRE!
# Writes DECA, shapes, nmfcs
python preprocessing/reconstruct.py \
    --celeb $celeb \
    --save_shapes \
    --save_nmfcs

# All aligned
python preprocessing/align.py \
    --celeb $celeb \
    --faces_and_masks \
    --shapes \
    --nmfcs \
    --landmarks


# Train renderer
python renderer/train.py \
    --celeb $celeb \
    --checkpoints_dir renderer_checkpoints/$subject/ \
    --niter 20 \
    --load_pretrain checkpoints_meta-renderer/ \
    --which_epoch 15

python renderer/train.py \
    --celeb $celeb \
    --checkpoints_dir renderer_checkpoints/$subject/ \
    --continue_train \
    --niter 30 \
    --lr 0.00005
