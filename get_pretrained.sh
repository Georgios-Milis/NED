#!/bin/bash

gdown https://drive.google.com/uc?id=1FKjHqHrcbvy93yqqqjz7JExztdmc3Nq9
unzip manipulator_checkpoints.zip
rm manipulator_checkpoints.zip
gdown --folder https://drive.google.com/drive/folders/1GCc7EbwNiDHoRpbJJ79wqy6R4spkgkWS
mkdir renderer_checkpoints
unzip Pacino/checkpoints_pacino.zip -d renderer_checkpoints/Pacino/
rm -r Pacino
gdown https://drive.google.com/uc?id=1KDzRI91Q0RdXnVlPMmR_vgvGzvxukS3R
unzip manipulator_checkpoints_pretrained_affwild2.zip -d manipulator_checkpoints/pretrained_affwild2/
rm manipulator_checkpoints_pretrained_affwild2.zip
gdown --folder https://drive.google.com/drive/folders/1bky2YPNDZSfBmtV9oqyIIJ9Iu7LiHYBd
unzip Meta-renderer/checkpoints_meta-renderer.zip
rm -r Meta-renderer
https://drive.google.com/drive/folders/1GCc7EbwNiDHoRpbJJ79wqy6R4spkgkWS?usp=drive_link
