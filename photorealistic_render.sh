#!/bin/bash
set -e

# Read the DECAs and create video parameters
# test=$1

test="1_63_pred"


subject="RickyGervais"
model=from_nlipexp3_exp4_03e6

# =============================================================================
celeb=test_examples/$subject
# 55F_3 is trained with SPECTRE
checkpoints_dir=renderer_checkpoints/Ricky_SPECTRE


for i in $(seq 1)
do
    #test=1_${i}_pred

    if [ -d $celeb/$test/DECA ]; then 
        echo
    else
        mkdir -p $celeb/$test/DECA
        cp $celeb/DECA/* $celeb/$test/DECA
    fi

    # # postprocess.sh
    # # Shapes, nmfcs...
    # python renderer/create_inputs.py \
    #     --celeb $celeb \
    #     --exp_name $test \
    #     --input /home/gmil/FastSpeech2/results_new/55F/$model/${test}_blend.pth \
    #     --save_shapes
    # Creates faces_aligned
    python renderer/test.py \
        --celeb $celeb \
        --exp_name $test \
        --checkpoints_dir $checkpoints_dir \
        #--which_epoch 40
    # Creates faces
    python postprocessing/unalign.py --celeb $celeb --exp_name $test
    # Writes full_frames
    python postprocessing/blend.py --celeb $celeb --exp_name $test --save_images


    # Create mp4 from frames
    python postprocessing/images2video.py \
        --imgs_path $celeb/$test/full_frames \
        --out_path $celeb/videos/$test-new40.mp4 \
        --wav /home/gmil/FastSpeech2/results_new/55F/$model/$test.mp4.wav

    # python postprocessing/images2video.py \
    #     --imgs_path test_examples/$subject/$test/shapes \
    #     --out_path test_examples/$subject/videos/$test-shape-new.mp4 \
    #     --wav /home/gmil/FastSpeech2/results_new/$subject/$model/$test.mp4.wav
done
