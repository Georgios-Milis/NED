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

IMG_EXTENSIONS = ['.png']

def is_image_file(filename):
    return any(filename.endswith(extension) for extension in IMG_EXTENSIONS)

def get_img_paths(dir):
    # Returns list: [path1, path2, ...]
    img_files = []
    assert os.path.isdir(dir), '%s is not a valid directory' % dir
    for root, _, fnames in sorted(os.walk(dir)):
        for fname in sorted(fnames):
            if is_image_file(fname):
                path = os.path.join(root, fname)
                img_files.append(path)
    return img_files

def mkdir(path):
    if not os.path.exists(path):
        os.makedirs(path)

def fit_ROI_in_frame(center, ROI_size=72):
    center_w, center_h = center[0], center[1]
    center_h = ROI_size // 2 if center_h < ROI_size // 2 else center_h
    center_w = ROI_size // 2 if center_w < ROI_size // 2 else center_w
    center_h = 256 - ROI_size // 2 if center_h > 256 - ROI_size // 2 else center_h
    center_w = 256 - ROI_size // 2 if center_w > 256 - ROI_size // 2 else center_w
    return np.array([center_w, center_h]).astype(np.int32)

def draw_str(image, target, s):
    # Draw string for visualisation.
    x, y = target
    cv2.putText(image, s, (x+1, y+1), cv2.FONT_HERSHEY_PLAIN, 1.0, (0, 0, 0), thickness = 2, lineType=cv2.LINE_AA)
    cv2.putText(image, s, (x, y), cv2.FONT_HERSHEY_PLAIN, 1.0, (255, 255, 255), lineType=cv2.LINE_AA)

def get_pixel_distance(rgb_frame, fake_frame, total_distance, total_pixels, mask=None):
    # If mask frame is given, use it as a mask.
    if mask is not None:
        mask = (mask[:,:,0]/255).astype(np.int32)   # keep one channel
    # Sum rgb distance across pixels.
    error = abs(rgb_frame.astype(np.int64) - fake_frame.astype(np.int64))
    if mask is not None:
        distance = np.multiply(np.linalg.norm(error, axis=2), mask)
        n_pixels = mask.sum()
    else:
        distance = np.linalg.norm(error, axis=2)
        n_pixels = distance.shape[0] * distance.shape[1]
    sum_distance = distance.sum()
    total_distance += sum_distance
    total_pixels += n_pixels
    # Heatmap
    maximum = 50.0
    minimum = 0.0
    maxim = maximum * np.ones_like(distance)
    distance_trunc = np.minimum(distance, maxim)
    zeros = np.zeros_like(distance)
    ratio = 2 * (distance_trunc-minimum) / (maximum - minimum)
    b = np.maximum(zeros, 255*(1 - ratio))
    r = np.maximum(zeros, 255*(ratio - 1))
    g = 255 - b - r
    heatmap = np.stack([r, g, b], axis=2).astype(np.uint8)
    if mask is not None:
        heatmap = np.multiply(heatmap, np.expand_dims(mask, axis=2)).astype(np.uint8)
    draw_str(heatmap, (20, 20), "%0.1f" % (sum_distance/n_pixels))
    return total_distance, total_pixels, heatmap

def print_args(parser, args):
    message = ''
    message += '----------------- Arguments ---------------\n'
    for k, v in sorted(vars(args).items()):
        comment = ''
        default = parser.get_default(k)
        if v != default:
            comment = '\t[default: %s]' % str(default)
        message += '{:>25}: {:<30}{}\n'.format(str(k), str(v), comment)
    message += '-------------------------------------------'
    print(message)

def main():
    print('Computation of average pixel distances (APD, Face-APD, Mouth-APD)\n')
    parser = argparse.ArgumentParser()
    parser.add_argument('--gpu_id', type=int, default='0', help='Negative value to use CPU, or greater equal than zero for GPU id.')
    parser.add_argument('--celeb', type=str, default='21M', help='Path to celebrity folder.')
    parser.add_argument('--style', type=str, default='18_si518_pred', help='Subfolder for specific style clip')
    parser.add_argument('--save_heatmaps', type=bool, default=False, help='Whether to save heatmap images')
    args = parser.parse_args()

    # Figure out the device
    gpu_id = int(args.gpu_id)
    if gpu_id < 0:
        device = 'cpu'
    elif torch.cuda.is_available():
        if gpu_id >= torch.cuda.device_count():
            device = 'cuda:0'
        else:
            device = 'cuda:' + str(gpu_id)
    else:
        print('GPU device not available. Exit')
        exit(0)

    # Print Arguments
    print_args(parser, args)

    # Get the path of each transformation file.
    images_dir = os.path.join('test_examples', args.celeb, args.style, 'images')
    img_paths = get_img_paths(images_dir)

    if args.save_heatmaps:
        mkdir(os.path.join(args.celeb, args.style, 'heatmaps_APD'))
        mkdir(os.path.join(args.celeb, args.style, 'heatmaps_FaceAPD'))
        mkdir(os.path.join(args.celeb, args.style, 'heatmaps_MouthAPD'))

    # run DECA decoding to find 2D mouth landmarks for mAPD
    deca_cfg.model.use_tex = True
    deca = DECA(config = deca_cfg, device=device)

    total_distance_APD, total_pixels_APD = 0, 0
    total_distance_FaceAPD, total_pixels_FaceAPD = 0, 0
    total_distance_MouthAPD, total_pixels_MouthAPD = 0, 0
    print('Computing APD, Face-APD, Mouth-APD' + ' and saving heatmaps'*args.save_heatmaps)

    # print(img_paths)
    # raise
    for img_path in tqdm(img_paths):
        f_img = cv2.imread(img_path)
        r_img = cv2.imread(img_path.replace(f'/{args.style}/images', '/images'))
        print(f_img.shape,r_img.shape)

        mask = cv2.imread(img_path.replace(f'/{args.style}/images', '/masks'))

        codedict_pth = os.path.splitext(img_path.replace(f'/{args.style}/images', '/DECA'))[0] + '.pkl'
        with open(codedict_pth, 'rb') as f:
            param = pickle.load(f)
        for key in param.keys():
            if key!='tform' and key!='original_size':
                param[key] = torch.from_numpy(param[key]).to(device)
        opdict, _ = deca.decode(param)
        lnds = param['tform'].inverse(112 + 112*opdict['landmarks2d'][0].cpu().numpy())
        mouth_center = np.median(lnds[48:,:], axis=0)
        mouth_center = mouth_center.astype(np.int32)
        ROI_size = 72
        mouth_center = fit_ROI_in_frame(mouth_center, ROI_size = ROI_size)
        mouth_mask = np.zeros_like(mask).astype(np.int32)
        mouth_mask[mouth_center[1] - ROI_size // 2:mouth_center[1] + ROI_size // 2,
                   mouth_center[0] - ROI_size // 2:mouth_center[0] + ROI_size // 2, :] = 255

        total_distance_APD, total_pixels_APD, heatmap_APD = get_pixel_distance(r_img, f_img, total_distance_APD, total_pixels_APD)
        total_distance_FaceAPD, total_pixels_FaceAPD, heatmap_FaceAPD = get_pixel_distance(r_img, f_img, total_distance_FaceAPD, total_pixels_FaceAPD, mask)
        total_distance_MouthAPD, total_pixels_MouthAPD, heatmap_MouthAPD = get_pixel_distance(r_img, f_img, total_distance_MouthAPD, total_pixels_MouthAPD, mouth_mask)

        # if args.save_heatmaps:
        #     cv2.imwrite(img_path.replace('images', 'heatmaps_APD'), heatmap_APD[:,:,::-1])
        #     cv2.imwrite(img_path.replace('images', 'heatmaps_FaceAPD'), heatmap_FaceAPD[:,:,::-1])
        #     cv2.imwrite(img_path.replace('images', 'heatmaps_MouthAPD'), heatmap_MouthAPD[:,:,::-1])

    msg_APD = 'Average pixel (L2) distance for sequence (APD-L2): %0.2f' % (total_distance_APD/total_pixels_APD)
    msg_FaceAPD = 'Face average pixel (L2) distance for sequence (Face-APD-L2): %0.2f' % (total_distance_FaceAPD/total_pixels_FaceAPD)
    msg_MouthAPD = 'Mouth average pixel (L2) distance for sequence (Mouth-APD-L2): %0.2f' % (total_distance_MouthAPD/total_pixels_MouthAPD)
    print(msg_APD)
    print(msg_FaceAPD)
    print(msg_MouthAPD)
    # with open(os.path.join(args.celeb, args.style, 'APD' + '.txt'), 'w+') as f:
    #     f.write(msg_APD)
    # with open(os.path.join(args.celeb, args.style, 'FaceAPD' + '.txt'), 'w+') as f:
    #     f.write(msg_FaceAPD)
    # with open(os.path.join(args.celeb, args.style, 'MouthAPD' + '.txt'), 'w+') as f:
    #     f.write(msg_MouthAPD)

if __name__=='__main__':
    main()
