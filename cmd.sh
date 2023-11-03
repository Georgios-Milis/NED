#!/bin/bash
set -e

# # TRAIN renderer
# ./preprocess.sh train_examples/Subject1 train

# # Train renderer
# python renderer/train.py \
#     --celeb train_examples/Subject/ \
#     --checkpoints_dir renderer_checkpoints/Subject/ \
#     --load_pretrain checkpoints_meta-renderer/ \
#     --which_epoch 15


# TEST with emotion
# Preprocess for testing mode
# ./preprocess.sh test_examples/55F test

# Manipulate emotion
python manipulator/test.py \
    --celeb test_examples/14M \
    --checkpoints_dir ./manipulator_checkpoints \
    --trg_emotions neutral \
    --exp_name manipulated_neutral

./postprocess.sh test_examples/14M manipulated_neutral renderer_checkpoints/14M_2

python postprocessing/images2video.py \
    --imgs_path test_examples/14M/manipulated_neutral/full_frames \
    --out_path test_examples/14M/videos/neutral.mp4 \
    --audio test_examples/14M/videos/14M_t.mp4


# TEST with reference
# python manipulator/test.py \
#     --celeb test_examples/Obama \
#     --checkpoints_dir ./manipulator_checkpoints \
#     --ref_dirs reference_examples/DeNiro_clip/DECA \
#     --exp_name manipulated_DeNiro

# ./postprocess.sh test_examples/Obama manipulated_DeNiro renderer_checkpoints/Obama

# python postprocessing/images2video.py \
#     --imgs_path train_examples/55F_2/shapes \
#     --out_path train_examples/55F_2/videos/shapes.mp4 \
#     --audio train_examples/55F_2/videos/55F_t.mp4

# TRAIN renderer
# dataset_path=/gpu-data3/gmil/data/actors
# dataset_path=train_examples
# celeb=$dataset_path/14M

# # preprocess.sh in train mode
# python preprocessing/detect.py --celeb $celeb --split
# python preprocessing/eye_landmarks.py --celeb $celeb --mouth --align
# python preprocessing/segment_face.py --celeb $celeb
# python preprocessing/reconstruct.py \
#     --celeb $celeb \
#     --save_shapes \
#     --save_nmfcs
# python preprocessing/align.py \
#     --celeb $celeb \
#     --faces_and_masks \
#     --shapes \
#     --nmfcs \
#     --landmarks

# # Train renderer
# python renderer/train.py \
#     --celeb $dataset_path/14M \
#     --checkpoints_dir renderer_checkpoints/14M/ \
#     --load_pretrain checkpoints_meta-renderer/ \
#     --which_epoch 15

# python preprocessing/reconstruct.py \
#     --celeb train_examples/55F_2 \
#     --save_shapes \
#     --save_nmfcs

