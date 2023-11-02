import os
import pickle
import sys

from glob import glob
import numpy as np


subject = sys.argv[1]
subjects_dir = "train_examples"

# for actor in os.listdir(actors_dir):
spectre_path = f'{subjects_dir}/{subject}/SPECTRE'

if os.path.exists(spectre_path):
    for chunk in glob(spectre_path + '/*.pkl'):
        chunk_id = os.path.split(chunk)[-1].replace('.pkl', '')
        chunk_dict = np.load(chunk, allow_pickle=True)
        poses = chunk_dict["pose"]
        exps = chunk_dict["exp"]

        deca_path = f'{subjects_dir}/{subject}/DECA'
        for frame in glob(f"{deca_path}/{chunk_id}/*.pkl"):
            frame_id = os.path.split(frame)[-1].replace('.pkl', '')
            frame_dict = np.load(frame, allow_pickle=True)

            idx = int(frame_id) % 50

            frame_dict["pose"] = [poses[idx].numpy()]
            frame_dict["exp"] = [exps[idx].numpy()]

            pickle.dump(frame_dict, open(frame, 'wb'))
else:
    raise FileNotFoundError("Couldn't find SPECTRE fits.")
