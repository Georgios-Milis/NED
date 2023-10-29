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
# ./preprocess.sh test_examples/Subject1 test

# # Manipulate emotion
# python manipulator/test.py \
#     --celeb test_examples/Subject1 \
#     --checkpoints_dir ./manipulator_checkpoints \
#     --trg_emotions angry \
#     --exp_name manipulated_angry

# ./postprocess.sh test_examples/Subject1 manipulated_angry renderer_checkpoints/Subject

# python postprocessing/images2video.py \
#     --imgs_path test_examples/Subject1/manipulated_angry/full_frames \
#     --out_path test_examples/Subject1/angry.mp4 \
#     --audio test_examples/Subject1/videos/Subject1_t.mp4


# TEST with reference
# python manipulator/test.py \
#     --celeb test_examples/Obama \
#     --checkpoints_dir ./manipulator_checkpoints \
#     --ref_dirs reference_examples/DeNiro_clip/DECA \
#     --exp_name manipulated_DeNiro

# ./postprocess.sh test_examples/Obama manipulated_DeNiro renderer_checkpoints/Obama

# python postprocessing/images2video.py \
#     --imgs_path test_examples/Obama/manipulated_DeNiro/full_frames \
#     --out_path test_examples/Obama/from_Obama.mp4 \
#     --audio test_examples/Obama/videos/Obama_t.mp4

# TRAIN renderer
dataset_path=/gpu-data3/gmil/data/actors
dataset_path=train_examples
./preprocess.sh $dataset_path/55F train

# Train renderer
# python renderer/train.py \
#     --celeb $dataset_path/55F \
#     --checkpoints_dir renderer_checkpoints/55F/ \
#     --load_pretrain checkpoints_meta-renderer/ \
#     --which_epoch 15
