import os
import random

x = 100
for i in range(x):
    random_number = random.randint(100, 999)
    command = f"python /mnt/Next3D/reenact_avatar_next3d.py --drive_root=/mnt/Next3D/data/demo --network=/mnt/Next3D/pretrained_models/next3d_ffhq_512.pkl --grid=2x1 --seeds={random_number} --outdir=/mnt/Next3D/out --fname=reenact{random_number}.mp4 --trunc=0.7 --lms_cond=1"
    os.system(command)

