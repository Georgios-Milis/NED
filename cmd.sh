# Train renderer
python renderer/train.py --celeb train_examples/Obama/ --checkpoints_dir renderer_checkpoints/Obama/ --load_pretrain checkpoints_meta-renderer/ --which_epoch 15


# Preprocess for testing mode
./preprocess.sh test_examples/Obama test

# Manipulate emotion
python manipulator/test.py \
    --celeb test_examples/Obama \
    --checkpoints_dir ./manipulator_checkpoints \
    --trg_emotions happy \
    --exp_name manipulated_happy

./postprocess.sh test_examples/Obama manipulated_angry renderer_checkpoints/Obama

python postprocessing/images2video.py \
    --imgs_path test_examples/Obama/manipulated_angry/full_frames \
    --out_path test_examples/Obama/angry.mp4 \
    --audio test_examples/Obama/videos/Obama_t.mp4

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