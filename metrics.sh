#!/bin/bash
set -e


folder=$1
subject=$2

subjects="38F 42M 49F"
methods="Wav2Lip SadTalker video-retalking"

for subject in $subjects
do
    # regex=results/NEUTART/$subject/*_pred.mp4
    for method in $methods
    do
        regex=../$method/results/$subject*.mp4
        echo
        echo "$regex"
        for file in $(ls $regex)
        do
            mkdir -p tmp/`basename $file`
            /home/gmil/miniconda3/envs/NED/bin/python save_frames.py $file tmp/`basename $file`

            test=$(basename $file .mp4)

            X_dir=test_examples/$subject/full_frames
            Y_dir=tmp/`basename $file`
            #Y_dir=test_examples/$subject/$test/images

            # FID
            /home/gmil/miniconda3/envs/NED/bin/python \
                -m pytorch_fid $X_dir $Y_dir --device cuda

            rm tmp/`basename $file`/*
            # SSIM, APD
            # /home/gmil/miniconda3/envs/NED/bin/python image_metrics.py $X_dir $Y_dir
        done
    done
done
