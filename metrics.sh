#!/bin/bash
set -e


subject="55F"
test="1_9_pred"


echo $subject, $test

X_dir=test_examples/$subject/images
Y_dir=test_examples/$subject/$test/images


# # Compress original actor images
# python -m pytorch_fid \
#     --save-stats train_examples/${subject}_3/images/000000 $subject-FID.npz

# FID
python -m pytorch_fid $subject-FID.npz $Y_dir --device cuda 

# SSIM
python metrics.py $X_dir $Y_dir
