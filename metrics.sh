#!/bin/bash
set -e


folder=$1
subject=$2

for file in $(ls $folder/*.mp4)
do
    # mkdir -p tmp/`basename $file`
    # /home/gmil/miniconda3/envs/NED/bin/python save_frames.py $file tmp/`basename $file`

    X_dir=test_examples/$subject/images
    Y_dir=tmp/`basename $file`

    # # Compress original actor images
    # python -m pytorch_fid \
    #     --save-stats train_examples/${subject}_3/images/000000 $subject-FID.npz

    # FID
    # python -m pytorch_fid $subject-FID.npz $Y_dir --device cuda
    # /home/gmil/miniconda3/envs/NED/bin/python \
    #     -m pytorch_fid $X_dir $Y_dir --device cuda

    # SSIM, APD
    /home/gmil/miniconda3/envs/NED/bin/python image_metrics.py $X_dir $Y_dir
done
