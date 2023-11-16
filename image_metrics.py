import os
import sys

import cv2
import numpy as np
from pytorch_msssim import SSIM
import torch
import torchvision.transforms.functional as F_v

from DECA.decalib.utils import util


# FID, SSIM (F/M), APD (F/M)

def read_masks(dir, max_n_sequences=None):
    masks = []
    fnames = sorted(os.walk(dir))
    for fname in sorted(fnames):
        paths = []
        root = fname[0]
        for f in sorted(fname[2]):
            paths.append(os.path.join(root, f))
        if len(paths) > 0:
            masks.append(paths)
    if max_n_sequences is not None:
        masks = masks[:max_n_sequences]
    return masks


def read_image_batch(image_dir, H=256, W=256):
    image_files = [f for f in sorted(os.listdir(image_dir)) if f.endswith('.png')]
    image_data = np.empty((len(image_files), 3, H, W))

    for i, image_file in enumerate(image_files):
        image = cv2.imread(os.path.join(image_dir, image_file))
        image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        image = cv2.resize(image, (H, W))
        image_data[i] = image.transpose(2, 0, 1)

    return torch.from_numpy(image_data).cuda()


def transform_points(points, mat):
    points = np.expand_dims(points, axis=1)
    points = cv2.transform(points, mat, points.shape)
    points = np.squeeze(points)
    return points


def get_mats_paths(dir):
    mats_files = []
    assert os.path.isdir(dir), '%s is not a valid directory' % dir
    for root, _, fnames in sorted(os.walk(dir)):
        for fname in sorted(fnames):
            if fname.endswith('txt'):
                path = os.path.join(root, fname)
                mats_files.append(path)
    return mats_files


def APD(img1, img2):
    return torch.nn.functional.mse_loss(img1, img2).item()


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
print(f"SSIM: {100 * ssim_val:.2f}%")



# face_attr_mask = util.load_local_mask(image_size=256, mode='bbx')
# m = face_attr_mask[3]

# # image = X[0]
# # import matplotlib.pyplot as plt

# # image = image.permute(1, 2, 0) / 255
# # m is a bounding box: l r t b

# import cpbd


# cpbds = []
# for image in Y:
#     image = F_v.rgb_to_grayscale(image).squeeze().cpu().numpy()
#     cpbds.append(cpbd.compute(image))


# print(f"CPBD:", np.mean(cpbds))


# mats_dir = os.path.join(X_dir.replace('images', 'align_transforms'))
# mat_paths = sorted(get_mats_paths(mats_dir))

# X_mouths = X
# Y_mouths = Y

# X_mouths = X[..., m[2]:m[3], m[0]:m[1]]
# Y_mouths = Y[..., m[2]:m[3], m[0]:m[1]]

# mapd = APD(X_mouths, Y_mouths)
# print(f"MAPD: {mapd}")


# import matplotlib.pyplot as plt
# plt.figure()
# plt.imshow(Y_mouths[4].cpu().permute(1, 2, 0) / 255)
# plt.savefig('mouth.png')
