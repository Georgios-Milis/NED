# Preprocess the video {train, test, reference}
./preprocess.sh test_examples/Pacino test
./preprocess.sh reference_examples/DeNiro_clip reference


# Manipulate the emotion on a test video
# Label-driven
python manipulator/test.py \
    --celeb test_examples/Pacino \
    --checkpoints_dir ./manipulator_checkpoints \
    --trg_emotions angry \
    --exp_name manipulated_angry

./postprocess.sh test_examples/Pacino manipulated_angry renderer_checkpoints/Pacino

python postprocessing/images2video.py \
    --imgs_path test_examples/Pacino/manipulated_angry/full_frames \
    --out_path test_examples/Pacino/angry.mp4 \
    --audio test_examples/Pacino/videos/Pacino_t.mp4

# Reference-driven
python manipulator/test.py \
    --celeb test_examples/Pacino \
    --checkpoints_dir ./manipulator_checkpoints \
    --ref_dirs reference_examples/DeNiro_clip/DECA \
    --exp_name manipulated_DeNiro

./postprocess.sh test_examples/Pacino manipulated_DeNiro renderer_checkpoints/Pacino

python postprocessing/images2video.py \
    --imgs_path test_examples/Pacino/manipulated_DeNiro/full_frames \
    --out_path test_examples/Pacino/from_Pacino.mp4 \
    --audio test_examples/Pacino/videos/Pacino_t.mp4


# Train a neural face renderer
# <celeb_path> is the path to the train folder used for the new actor.
# <load_pretrain> is the path with the checkpoints of the pretrained meta-renderer
python renderer/train.py \
    --celeb <celeb_path> \
    --checkpoints_dir renderer_checkpoints/new \
    --load_pretrain checkpoints_meta-renderer \
    --which_epoch 15 \
    --niter 60 \
    --gpu_ids 0 \
    --batch_size 4 \


# =============================================================================
# Train the Emotion Manipulator
python preprocessing/reconstruct_MEAD.py \
    --root ./MEAD_data \
    --actors M003 M009 W029 M023

./preprocess.sh test_examples/Pacino/ test
./preprocess.sh reference_examples/Nicholson_clip/ reference
./preprocess.sh reference_examples/Pacino_clip/ reference
./preprocess.sh reference_examples/DeNiro_clip/ reference

python manipulator/train.py \
    --train_root <train_root> \
    --selected_actors <selected_actors> \
    --selected_actors_val <selected_actors_val> \
    --checkpoints_dir ./manipulator_checkpoints_pretrained_affwild2/ \
    --finetune

# Pretrain
python preprocessing/detect_affwild2.py \
    --videos_path /path/to/videos/of/the/train/set \
    --annotations_path /path/to/annotations/of/the/train/set/ \
    --save_dir <save_dir>

python preprocessing/detect_affwild2.py \
    --videos_path /path/to/videos/of/the/train/set \
    --annotations_path /path/to/annotations/of/the/train/set/ \
    --save_dir <save_dir>

python preprocessing/reconstruct.py \
    --celeb /path/to/saved/results

python manipulator/train.py \
    --database aff-wild2 \
    --train_root <train_root> \
    --annotations_path /path/to/annotations/of/the/train/set/ \
    --checkpoints_dir <checkpoints_dir> \
    --niter 20