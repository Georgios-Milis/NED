#!/bin/bash
set -e


subject=21M
driving_subject=21M
# model=from_TCD_all_exp4_03e6

# =============================================================================
celeb=test_examples/$subject
checkpoints_dir=renderer_checkpoints/${subject}
#checkpoints_dir=renderer_checkpoints/Tom

# for wav_file in $(ls driving/$driving_subject/*_pred.mp4.wav)
for wav_file in $(ls ../FastSpeech2/user_study/${driving_subject}_[1-9]*.wav)
do
    # test=$(basename $wav_file .mp4.wav)
	test=$(basename $wav_file .wav)
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
		--input ../FastSpeech2/user_study/${test}.pth \
        --save_shapes
    # Creates faces_aligned
    python renderer/test.py \
        --celeb $celeb \
        --exp_name $test \
        --checkpoints_dir $checkpoints_dir \
        #--which_epoch 20
    # Creates faces
    python postprocessing/unalign.py --celeb $celeb --exp_name $test
    # Writes full_frames
    python postprocessing/blend.py --celeb $celeb --exp_name $test --save_images


    # Create mp4 from frames
    python postprocessing/images2video.py \
        --imgs_path $celeb/$test/full_frames \
        --out_path $celeb/videos/$test.mp4 \
        --wav $wav_file \
        --fps 25

    # python postprocessing/images2video.py \
    #     --imgs_path test_examples/$subject/$test/shapes \
    #     --out_path test_examples/$subject/videos/$test-shape-new.mp4 \
    #     --wav /home/gmil/FastSpeech2/results_new/$subject/$model/$test.mp4.wav
done
