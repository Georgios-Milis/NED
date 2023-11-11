#!/bin/bash
set -e

# Read the DECAs and create video parameters
# test=$1

test="1_63_pred"


#subject="21M"
subject=Obama
model=from_TCD_all_exp4_03e6

# =============================================================================
celeb=test_examples/$subject
# 55F_3 is trained with SPECTRE
checkpoints_dir=renderer_checkpoints/$subject


for test in $(ls ../FastSpeech2/results_new/21M/$model/*_pred.mp4)
do
    #test=18_si518_pred

    test=$(basename $test .mp4)
    echo $test

    if [ -d $celeb/$test/DECA ]; then 
        echo
    else
        mkdir -p $celeb/$test/DECA
        cp $celeb/DECA/* $celeb/$test/DECA
    fi

    # postprocess.sh
    # Shapes, nmfcs...
    python renderer/create_inputs.py \
        --celeb $celeb \
        --exp_name $test \
        --input /home/gmil/FastSpeech2/results_new/21M/$model/${test}_blend.pth \
        --save_shapes
    # Creates faces_aligned
    python renderer/test.py \
        --celeb $celeb \
        --exp_name $test \
        --checkpoints_dir $checkpoints_dir \
        --which_epoch 20
    # Creates faces
    python postprocessing/unalign.py --celeb $celeb --exp_name $test
    # Writes full_frames
    python postprocessing/blend.py --celeb $celeb --exp_name $test --save_images #--method copy_paste


    # Create mp4 from frames
    python postprocessing/images2video.py \
        --imgs_path $celeb/$test/full_frames \
        --out_path $celeb/videos/$test.mp4 \
        --wav /home/gmil/FastSpeech2/results_new/21M/$model/$test.mp4.wav

    # python postprocessing/images2video.py \
    #     --imgs_path test_examples/$subject/$test/shapes \
    #     --out_path test_examples/$subject/videos/$test-shape-new.mp4 \
    #     --wav /home/gmil/FastSpeech2/results_new/$subject/$model/$test.mp4.wav
done
