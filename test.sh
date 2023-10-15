#!/bin/bash

celeb=../FastSpeech2/test/DECA
exp_name=rendered

python renderer/create_inputs.py --celeb $celeb --exp_name $exp_name --no_eye_gaze --save_shapes
python renderer/test.py --celeb $celeb --exp_name $exp_name --checkpoints_dir renderer_checkpoints/Pacino --which_epoch 20
python postprocessing/unalign.py --celeb $celeb --exp_name $exp_name
python postprocessing/blend.py --celeb $celeb --exp_name $exp_name --save_images

python postprocessing/images2video.py \
    --imgs_path $celeb/$exp_name/full_frames \
    --out_path $celeb/$exp_name/rendered.mp4 \
    --audio ../FastSpeech2/test/sample.mp4
