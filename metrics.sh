#!/bin/bash
set -e


subject="21M"
test="1_9_pred"

# python preprocessing/detect.py --celeb ../SadTalker/results


for i in $(seq 10)
do
    test=1_${i}_pred

    echo $subject, $test

    python save_frames.py ../SadTalker/results/$test.mp4 ../SadTalker/results/$test

    # X_dir=test_examples/$subject/images
    # Y_dir=test_examples/$subject/$test/images

    X_dir=test_examples/$subject/images
    Y_dir=../SadTalker/results/$test

    # # Compress original actor images
    # python -m pytorch_fid \
    #     --save-stats train_examples/${subject}_3/images/000000 $subject-FID.npz

    # FID
    python -m pytorch_fid $subject-FID.npz $Y_dir --device cuda 

    # SSIM
    python metrics.py $X_dir $Y_dir
done
