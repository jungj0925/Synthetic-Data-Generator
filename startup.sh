#!/bin/bash
echo "Starting container..."
cd dataset_preprocessing/ffhq

python preprocess_in_the_wild.py --indir=/dataset_preprocessing/ffhq/INPUT_IMAGE_FOLDER/

cd INPUT_IMAGE_FOLDER
find deca_results -type f ! -name "*.png" -exec cp {} /data/demo \;
cp ./crop/*.png /data/demo/
cp dataset.json /data/demo/
cd /
python /reenact_avatar_next3d.py --drive_root=/data/demo --network=/pretrained_models/next3d_ffhq_512.pkl --grid=2x1 --seeds=166 --outdir=/out --fname=reenact.mp4 --trunc=0.7 --lms_cond=1 &
