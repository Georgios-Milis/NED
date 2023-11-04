#!/bin/bash
set -e

# video="55F_t.mp4"

subject="55F_3"
dataset_path=train_examples
celeb=$dataset_path/$subject
spectre_path=$celeb/SPECTRE

# mkdir -p $celeb/videos
# mv $video $celeb/videos/($subject)_t.mp4

# # preprocess.sh in train mode
# # Face detection (writes images)
# python preprocessing/detect.py --celeb $celeb --split
# # Writes eye_landmarks (calculates mouth landmarks, too)
# python preprocessing/eye_landmarks.py --celeb $celeb --mouth --align
# # Writes masks, faces
# python preprocessing/segment_face.py --celeb $celeb

# I should interfere here! ====================================================

# Writes DECA, shapes, nmfcs
# python preprocessing/reconstruct.py \
#     --celeb $celeb \
#     --save_shapes \
#     --save_nmfcs

# =============================================================================

# All aligned
# python preprocessing/align.py \
#     --celeb $celeb \
#     --faces_and_masks \
#     --shapes \
#     --nmfcs \

# Train renderer
python renderer/train.py \
    --celeb $celeb \
    --checkpoints_dir renderer_checkpoints/$subject/ \
    --continue_train \
    --niter 40 \
    --lr 0.00005
    # --load_pretrain checkpoints_meta-renderer/ \
    # --which_epoch 15
