# Read the DECAs and create video parameters
celeb_name=Obama
celeb=test_examples/$celeb_name
exp_name=IMPORTED
checkpoints_dir=renderer_checkpoints/$celeb_name

# postprocess.sh
# Shapes, nmfcs...
echo "create_inputs.py"
python renderer/create_inputs.py --celeb $celeb --exp_name $exp_name --save_shapes
Creates faces_aligned
echo "test.py"
python renderer/test.py --celeb $celeb --exp_name $exp_name --checkpoints_dir $checkpoints_dir --which_epoch 20
# Creates faces
echo "unalign.py"
python postprocessing/unalign.py --celeb $celeb --exp_name $exp_name
# Writes full_frames
echo "blend.py"
python postprocessing/blend.py --celeb $celeb --exp_name $exp_name --save_images


# Create mp4 from frames
python postprocessing/images2video.py \
    --imgs_path test_examples/$celeb_name/$exp_name/full_frames \
    --out_path test_examples/$celeb_name/imported.mp4 \
    --audio ref.mp4
