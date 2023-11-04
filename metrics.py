import os
import sys

import cv2
import numpy as np
from pytorch_msssim import SSIM, MS_SSIM
import torch


def read_image_batch(image_dir, H=256, W=256):
    image_files = [f for f in os.listdir(image_dir) if f.endswith('.png')]
    image_data = np.empty((len(image_files), 3, H, W))

    for i, image_file in enumerate(image_files):
        image = cv2.imread(os.path.join(X_dir, image_file))
        image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        image_data[i] = image.transpose(2, 0, 1)

    return torch.from_numpy(image_data).cuda()


X_dir = sys.argv[1]
Y_dir = sys.argv[2]

X = read_image_batch(X_dir)
Y = read_image_batch(Y_dir)

batch_size = min(X.shape[0], Y.shape[0])
X = X[:batch_size]
Y = Y[:batch_size]

# Reuse the Gaussian kernel with SSIM & MS_SSIM 
ssim_module = SSIM().cuda()
# ms_ssim_module = MS_SSIM()

ssim_val = ssim_module(X, Y).item()
print(ssim_val)
