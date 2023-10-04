#!/bin/bash

gdown https://drive.google.com/uc?id=1FKjHqHrcbvy93yqqqjz7JExztdmc3Nq9
unzip manipulator_checkpoints.zip
rm manipulator_checkpoints.zip
gdown --folder https://drive.google.com/drive/folders/1re3LeGf9T3_XoeoRJL4LTCZ5H-Ut2p-S
mkdir renderer_checkpoints
unzip Tarantino/checkpoints_tarantino.zip -d renderer_checkpoints/Tarantino/
rm -r Tarantino
gdown https://drive.google.com/uc?id=1KDzRI91Q0RdXnVlPMmR_vgvGzvxukS3R
unzip manipulator_checkpoints_pretrained_affwild2.zip -d manipulator_checkpoints/pretrained_affwild2/
rm manipulator_checkpoints_pretrained_affwild2.zip
gdown --folder https://drive.google.com/drive/folders/1bky2YPNDZSfBmtV9oqyIIJ9Iu7LiHYBd
unzip Meta-renderer/checkpoints_meta-renderer.zip
rm -r Meta-renderer
