import cv2
import os
import numpy as np
import argparse
from tqdm import tqdm
import pickle
import torch
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from DECA.decalib.deca import DECA
from DECA.decalib.utils import util
from DECA.decalib.utils.config import cfg as deca_cfg


def read_image_batch(image_dir, H=256, W=256):
    image_files = [f for f in sorted(os.listdir(image_dir)) if f.endswith('.png')]
    image_data = np.empty((len(image_files), 3, H, W))

    for i, image_file in enumerate(image_files):
        image = cv2.imread(os.path.join(image_dir, image_file))
        image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        image = cv2.resize(image, (H, W))
        image_data[i] = image.transpose(2, 0, 1)

    return torch.from_numpy(image_data).cuda()


subject = '38F'
gold_dir = f"test_examples/{subject}/images"
pred_dir = f"results/NEUTART/{subject}/images"

