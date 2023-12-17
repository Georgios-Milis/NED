#!/bin/bash
set -e


subject=Hampton

celeb=test_examples/$subject
checkpoints_dir=renderer_checkpoints/$subject
#checkpoints_dir=renderer_checkpoints/Tom

# for wav_file in $(ls ../FastSpeech2/test/driving/M_[1-9]*.wav)
# do
    # test=$(basename $wav_file .mp4.wav)
    wav_file=../FastSpeech2/test/supp_11.wav
	test=$(basename $wav_file .wav)
    pth_file=$(dirname $wav_file)/$test.pth
    echo $test

    if [ -d $celeb/$test/DECA ]; then 
        echo
    else
        mkdir -p $celeb/$test/DECA
        cp $celeb/DECA/* $celeb/$test/DECA
    fi

    # Shapes, nmfcs...
    python renderer/create_inputs.py \
        --celeb $celeb \
        --exp_name $test \
        --input $pth_file \
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
# done
