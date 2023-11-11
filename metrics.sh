#!/bin/bash
set -e


folder=$1
subject=$2

subject=21M

regex=../video-retalking/results/18*.mp4
regex=../SadTalker/results/18*.mp4
# for file in $(ls $folder/*.mp4)
for file in $(ls $regex)
do
    mkdir -p tmp/`basename $file`
    /home/gmil/miniconda3/envs/NED/bin/python save_frames.py $file tmp/`basename $file`

    test=$(basename $file .mp4)

    X_dir=test_examples/$subject/images
    Y_dir=tmp/`basename $file`
    #Y_dir=test_examples/$subject/$test/images

    # FID
    /home/gmil/miniconda3/envs/NED/bin/python \
        -m pytorch_fid $X_dir $Y_dir --device cuda

    # SSIM, APD
    /home/gmil/miniconda3/envs/NED/bin/python image_metrics.py $X_dir $Y_dir
done
