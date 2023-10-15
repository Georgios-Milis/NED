import os
import pickle

import numpy as np
import torch


# 'tform': SimilarityTransform
#    [[ 1.06698565e+00,  1.42328892e-16, -2.24066986e+01],
#    [-6.64015611e-19,  1.06698565e+00, -5.17488038e+01],
#    [ 0.00000000e+00,  0.00000000e+00,  1.00000000e+00]] 
# 'original_size': (256, 256)

# We have:
#    ['shape', 'tex', 'exp', 'pose', 'cam', 'light', 'verts']
# Required:
#    ['shape', 'tex', 'exp', 'pose', 'cam', 'light', 'detail', 'tform', 'original_size']

def check_decas():
    deca_path = "test_examples/Obama/manipulated_happy/DECA/001131.pkl"
    data = np.load(deca_path, allow_pickle=True)
    print(data['exp'].shape, data['pose'].shape)


def reprocess_blendshapes(blendshape_path):
    blendshapes = torch.load(blendshape_path)
    blendshapes = torch.nn.functional.interpolate(
        blendshapes.transpose(-1, -2),
        scale_factor=(30000/1001)*(256/22050),
        mode='linear',
    ).squeeze().transpose(-1, -2).cpu().numpy()

    for i in range(blendshapes.shape[0]):
        path = os.path.join(f"test_examples/Obama/IMPORTED/DECA/{i:06d}.pkl")
        codedict = {}
        exp = blendshapes[i][6:].reshape((1, -1))
        codedict['exp'] = exp
        #pose = np.zeros((1, 6), dtype=np.float32)
        pose = blendshapes[i][:6].reshape((1, -1))
        codedict['pose'] = pose

        #print(exp.shape, pose.shape)

        pickle.dump(codedict, open(path, 'wb'))


if __name__ == '__main__':
    reprocess_blendshapes('ref.pth')
