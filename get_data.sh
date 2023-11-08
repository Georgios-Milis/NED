#!/bin/bash

# urle () { [[ "${1}" ]] || return 1; local LANG=C i x; for (( i = 0; i < ${#1}; i++ )); do x="${1:i:1}"; [[ "${x}" == [a-zA-Z0-9.~-] ]] && echo -n "${x}" || printf '%%%02X' "'${x}"; done; echo; }

# # Fetch FLAME data
# echo -e "\nBefore you continue, you must register at https://flame.is.tue.mpg.de/ and agree to the FLAME license terms."
# read -p "Username (FLAME):" username
# read -p "Password (FLAME):" password
# username=$(urle $username)
# password=$(urle $password)

# echo -e "\nDownloading FLAME..."
# wget --post-data "username=$username&password=$password" \
#     'https://download.is.tue.mpg.de/download.php?domain=flame&sfile=FLAME2020.zip&resume=1' \
#     -O './DECA/data/FLAME2020.zip' --no-check-certificate --continue
# unzip ./DECA/data/FLAME2020.zip -d ./DECA/data/FLAME2020
# mv ./DECA/data/FLAME2020/generic_model.pkl ./DECA/data
# rm -r ./DECA/data/FLAME2020
# rm ./DECA/data/FLAME2020.zip

# echo -e "\nDownloading deca_model..."
# FILEID=1rp8kdyLPvErw2dTmqtjISRVvQLj6Yzje
# FILENAME=./DECA/data/deca_model.tar
# wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(\
#     wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate \
#     'https://docs.google.com/uc?export=download&id='${FILEID} -O- | \
#     sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=${FILEID}" -O $FILENAME \
#     && rm -rf /tmp/cookies.txt

# echo -e "\nMaking FLAME_albedo_from_BFM..."
# git clone https://github.com/TimoBolkart/BFM_to_FLAME.git
# cd BFM_to_FLAME
# read -p "Username (BFM):" username
# read -p "Password (BFM):" password
# username=$(urle $username)
# password=$(urle $password)
# wget --user=$username --ask-password \
#     https://faces.dmi.unibas.ch/bfm/bfm2017/restricted/model2017-1_bfm_nomouth.h5 \
#     -O model/model2017-1_bfm_nomouth.h5  --auth-no-challenge
# wget files.is.tue.mpg.de/tbolkart/FLAME/mask_inpainting.npz -O data/mask_inpainting.npz
# python col_to_tex.py
# mv output/FLAME_albedo_from_BFM.npz ../DECA/data/

# echo -e "\nDownloading FSGAN..."
# git clone https://github.com/YuvalNirkin/fsgan.git
# cd fsgan
# cp ../download_fsgan_models.py .
# python download_fsgan_models.py
# mv weights/lfw_figaro_unet_256_2_0_segmentation_v1.pth ../preprocessing/segmentation/

# echo -e "\nFinished. Optionally, you can delete BFM_to_FLAME, fsgan and download_fsgan_models.py."

# Old BFM
# username=el18035@mail.ntua.gr
# wget --user=$username --ask-password \
#     https://faces.dmi.unibas.ch/bfm/content/basel_face_model/downloads/restricted/BaselFaceModel.tgz \
#     --auth-no-challenge
